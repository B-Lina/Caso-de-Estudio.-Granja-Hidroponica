import mysql.connector
import pyodbc

def create_mysql_connection():
    return mysql.connector.connect(
        host='localhost',         # Cambia por tu host de MySQL
        user='root',        # Cambia por tu usuario de MySQL
        password='lina0610',  # Cambia por tu contraseña de MySQL
        database='LosDesterrados'  # Nombre de la base de datos MySQL
    )

def create_sql_server_connection():
    return pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'  # Cambia si usas otro controlador
        'SERVER=LINAA//SQLSERVER;'  # Cambia por tu servidor SQL Server
        'DATABASE=MigracionLosDesterrados;'  # Cambia por tu base de datos en SQL Server
        'UID=sa;'  # Cambia por tu usuario de SQL Server
        'PWD=lina0610'  # Cambia por tu contraseña de SQL Server
    )

def migrate_cultivos():
    mysql_conn = create_mysql_connection()
    sql_server_conn = create_sql_server_connection()

    mysql_cursor = mysql_conn.cursor()
    sql_server_cursor = sql_server_conn.cursor()

    # Leer datos de la tabla Cultivo en MySQL
    mysql_cursor.execute("SELECT * FROM Cultivo")
    cultivos = mysql_cursor.fetchall()

    # Insertar datos en la tabla Cultivo en SQL Server
    for cultivo in cultivos:
        sql_server_cursor.execute("""
            INSERT INTO Cultivo (Id_cultivo, Tipo_planta, Fecha_siembra, Estado_crecimiento, Rendimiento_esperado)
            VALUES (?, ?, ?, ?, ?)
        """, (cultivo[0], cultivo[1], cultivo[2], cultivo[3], cultivo[4]))

    sql_server_conn.commit()

    # Cerrar conexiones
    mysql_cursor.close()
    sql_server_cursor.close()
    mysql_conn.close()
    sql_server_conn.close()

    print("Migración de cultivos completada con éxito.")

if __name__ == "__main__":
    migrate_cultivos()

