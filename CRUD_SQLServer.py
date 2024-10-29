import pyodbc

def create_sql_server_connection():
    # Cambia los parámetros de conexión según tu configuración
    return pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=localhost;'
        'DATABASE=LosDesterrados;'  
        'Trusted_Connection=yes;'  
    )


def insert_cultivo(tipo_planta, fecha_siembra, estado_crecimiento, rendimiento_esperado):
    conn = create_sql_server_connection()
    cursor = conn.cursor()
    
    cursor.execute("""
        INSERT INTO Cultivo (Tipo_planta, Fecha_siembra, Estado_crecimiento, Rendimiento_esperado)
        VALUES (?, ?, ?, ?)
    """, (tipo_planta, fecha_siembra, estado_crecimiento, rendimiento_esperado))

    conn.commit()
    cursor.close()
    conn.close()
    print("Registro insertado exitosamente.")

def query_cultivos():
    conn = create_sql_server_connection()
    cursor = conn.cursor()
    
    cursor.execute("SELECT * FROM Cultivo")
    rows = cursor.fetchall()
    
    print("Registros en la tabla Cultivo:")
    for row in rows:
        print(f"ID: {row.Id_cultivo}, Tipo de Planta: {row.Tipo_planta}, "
              f"Fecha de Siembra: {row.Fecha_siembra}, "
              f"Estado de Crecimiento: {row.Estado_crecimiento}, "
              f"Rendimiento Esperado: {row.Rendimiento_esperado}")

    cursor.close()
    conn.close()

if __name__ == "__main__":
    # Inserta un nuevo cultivo
    insert_cultivo('Lechuga Batavia', '2024-08-28', 'Germinando', 15.00)

    # Consulta los cultivos existentes
    query_cultivos()
