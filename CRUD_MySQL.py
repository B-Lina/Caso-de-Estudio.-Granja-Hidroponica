import mysql.connector

def create_connection():
    connection = mysql.connector.connect(
        host='localhost',         
        user='root',       
        password='lina0610', 
        database='LosDesterrados'  
    )
    return connection

def insertar_cultivo(tipo_planta, fecha_siembra, estado_crecimiento, rendimiento_esperado):
    connection = create_connection()
    cursor = connection.cursor()
    sql = "INSERT INTO Cultivo (Tipo_planta, Fecha_siembra, Estado_crecimiento, Rendimiento_esperado) VALUES (%s, %s, %s, %s)"
    values = (tipo_planta, fecha_siembra, estado_crecimiento, rendimiento_esperado)
    
    cursor.execute(sql, values)
    connection.commit()
    print("Cultivo insertado con éxito.")
    
    cursor.close()
    connection.close()

def agregar_cultivo():
    connection = create_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM Cultivo")
    
    for (id_cultivo, tipo_planta, fecha_siembra, estado_crecimiento, rendimiento_esperado) in cursor:
        print(f"{id_cultivo}: {tipo_planta}, {fecha_siembra}, {estado_crecimiento}, {rendimiento_esperado}")
    
    cursor.close()
    connection.close()
    
def modificar_cultivo(id_cultivo, tipo_planta, fecha_siembra, estado_crecimiento, rendimiento_esperado):
    connection = create_connection()
    cursor = connection.cursor()
    sql = "UPDATE Cultivo SET Tipo_planta=%s, Fecha_siembra=%s, Estado_crecimiento=%s, Rendimiento_esperado=%s WHERE Id_cultivo=%s"
    values = (tipo_planta, fecha_siembra, estado_crecimiento, rendimiento_esperado, id_cultivo)
    
    cursor.execute(sql, values)
    connection.commit()
    print("Cultivo actualizado con éxito.")
    
    cursor.close()
    connection.close()

def eliminar_cultivo(id_cultivo):
    connection = create_connection()
    cursor = connection.cursor()
    sql = "DELETE FROM Cultivo WHERE Id_cultivo=%s"
    
    cursor.execute(sql, (id_cultivo,))
    connection.commit()
    print("Cultivo eliminado con éxito.")
    
    cursor.close()
    connection.close()

def main():
    while True:
        print("\nOpciones:")
        print("1. Insertar Cultivo")
        print("2. Consultar Cultivos")
        print("3. Actualizar Cultivo")
        print("4. Eliminar Cultivo")
        print("5. Salir")
        
        choice = input("Selecciona una opción: ")
        
        if choice == '1':
            tipo_planta = input("Tipo de planta: ")
            fecha_siembra = input("Fecha de siembra (YYYY-MM-DD): ")
            estado_crecimiento = input("Estado de crecimiento: ")
            rendimiento_esperado = float(input("Rendimiento esperado: "))
            insertar_cultivo(tipo_planta, fecha_siembra, estado_crecimiento, rendimiento_esperado)
        
        elif choice == '2':
            agregar_cultivo()
        
        elif choice == '3':
            id_cultivo = int(input("ID del cultivo a actualizar: "))
            tipo_planta = input("Nuevo tipo de planta: ")
            fecha_siembra = input("Nueva fecha de siembra (YYYY-MM-DD): ")
            estado_crecimiento = input("Nuevo estado de crecimiento: ")
            rendimiento_esperado = float(input("Nuevo rendimiento esperado: "))
            modificar_cultivo(id_cultivo, tipo_planta, fecha_siembra, estado_crecimiento, rendimiento_esperado)
        
        elif choice == '4':
            id_cultivo = int(input("ID del cultivo a eliminar: "))
            eliminar_cultivo(id_cultivo)
        
        elif choice == '5':
            print("Saliendo...")
            break
        
        else:
            print("Opción no válida. Intente nuevamente.")

if __name__ == "__main__":
    main()
