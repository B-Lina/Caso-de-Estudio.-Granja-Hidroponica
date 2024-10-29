import pymysql
import pyodbc

# Configuraciones de conexión para MySQL
mysql_config = {
    "host": "localhost",
    "user": "root",
    "password": "sergio",
    "database": "LosDesterrados"
}

# Configuraciones de conexión para SQL Server
sqlserver_config = {
    "driver": "{ODBC Driver 18 for SQL Server}",
    "server": "SERGIO_O\\SQLEXPRESS",
    "database": "Punto5",
    "uid": "sa",
    "pwd": "sergio"
}

# Establecer conexión con MySQL
mysql_conn = pymysql.connect(
    host=mysql_config["host"],
    user=mysql_config["user"],
    password=mysql_config["password"],
    database=mysql_config["database"]
)

# Establecer conexión con SQL Server
sqlserver_conn = pyodbc.connect(
    f"DRIVER={sqlserver_config['driver']};"
    f"SERVER={sqlserver_config['server']};"
    f"DATABASE={sqlserver_config['database']};"
    f"UID={sqlserver_config['uid']};"
    f"PWD={sqlserver_config['pwd']};"
    f"TrustServerCertificate=yes;"
)


# Crear cursores para ambas bases de datos
mysql_cursor = mysql_conn.cursor()
sqlserver_cursor = sqlserver_conn.cursor()

# Función para mapear tipos de datos de MySQL a SQL Server
def map_mysql_to_sqlserver_type(mysql_type):
    mysql_to_sqlserver = {
        "int": "INT",
        "varchar": "VARCHAR(255)",
        "text": "TEXT",
        "date": "DATE",
        "datetime": "DATETIME",
        "float": "FLOAT",
        "double": "FLOAT",
        "tinyint": "BIT"
    }
    base_type = mysql_type.split("(")[0]
    if "varchar" in mysql_type:
        size = mysql_type[mysql_type.find("(")+1:mysql_type.find(")")]
        return f"VARCHAR({size})"
    return mysql_to_sqlserver.get(base_type, "VARCHAR(255)")

# Función para crear la tabla en SQL Server
def create_table_in_sqlserver(table_name, columns):
    sqlserver_cursor.execute(f"IF OBJECT_ID('{table_name}', 'U') IS NOT NULL DROP TABLE {table_name}")
    columns_str = ", ".join([f"{col[0]} {map_mysql_to_sqlserver_type(col[1])}" for col in columns])
    create_table_sql = f"CREATE TABLE {table_name} ({columns_str})"
    sqlserver_cursor.execute(create_table_sql)
    sqlserver_conn.commit()

# Función para insertar datos en SQL Server
def insert_data_in_sqlserver(table_name, columns, rows):
    placeholders = ", ".join(["?"] * len(columns))
    insert_sql = f"INSERT INTO {table_name} VALUES ({placeholders})"
    for row in rows:
        sqlserver_cursor.execute(insert_sql, row)
    sqlserver_conn.commit()

try:
    # Obtener todas las tablas de MySQL
    mysql_cursor.execute("SHOW TABLES")
    tables = mysql_cursor.fetchall()
    
    for (table_name,) in tables:
        try:
            # Obtener la estructura de la tabla
            mysql_cursor.execute(f"DESCRIBE {table_name}")
            columns = [(column[0], column[1]) for column in mysql_cursor.fetchall()]
            
            # Crear la tabla en SQL Server
            create_table_in_sqlserver(table_name, columns)
            
            # Obtener los datos de la tabla MySQL
            mysql_cursor.execute(f"SELECT * FROM {table_name}")
            rows = mysql_cursor.fetchall()
            
            # Insertar los datos en SQL Server
            insert_data_in_sqlserver(table_name, columns, rows)
            
            print(f"Datos migrados para la tabla: {table_name}")
        
        except Exception as table_error:
            print(f"Error migrando la tabla {table_name}: {table_error}")

except Exception as e:
    print(f"Error general durante la migración: {e}")

finally:
    # Cerrar conexiones
    mysql_cursor.close()
    mysql_conn.close()
    sqlserver_cursor.close()
    sqlserver_conn.close()
