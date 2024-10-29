-- Crear la base de datos 
create DATABASE LosDesterrados; 
use LosDesterrados;

-- Crear las tablas 
create table Cultivo(
Id_cultivo int Primary key identity(1,1),
Tipo_planta varchar(100),
Fecha_siembra date, 
Estado_crecimiento varchar(100),
Redimiento_esperado decimal(10,2)
); 

Create table Insumos (
Id_insumo int Primary Key identity (1,1),
Tipo_insumo varchar (100),
Cantidad_disponible decimal (10,2),
Fecha_caducidad date
);

Create table Cliente(
Id_cliente int Primary key identity(1,1),
Nombre varchar (100),
Correo varchar(60), 
Telefono varchar (12)
);


Create table Venta ( 
Id_venta int Primary Key Identity(1,1),
Id_Cliente int not null, 
Fecha_venta datetime, 
Total decimal (10,2),
Foreign Key (Id_Cliente) references Cliente(Id_Cliente)
);

Create table Detalle_Venta(
Id_detalle int Primary Key Identity(1,1),
Id_venta int, 
Id_cultivo int, 
Cantidad decimal, 
Subtotal decimal, 
Foreign Key (Id_venta) references Venta (Id_venta),
Foreign Key (Id_cultivo) references Cultivo(Id_cultivo)
);

Create table Compras (
Id_compra int primary key identity (1,1), 
Id_insumo int, 
Fecha_compra date, 
Cantidad_compra decimal (10,2), 
Total_compra decimal (10,2),
Foreign Key (Id_insumo) references Insumos (Id_insumo),
);

Create table Resumen_Cultivo (
Id_resumen int Primary Key identity (1,1), 
Id_cultivo int, 
Id_insumo int, 
Cantidad_total decimal (10,2),
Foreign key (Id_cultivo) references Cultivo (Id_cultivo),
Foreign key (Id_insumo) references Insumos (Id_insumo)
);

-- Insertar registros en las tablas -- 
INSERT INTO Cultivo (Tipo_planta, Fecha_siembra, Estado_crecimiento, Redimiento_esperado) 
VALUES 
    ('Lechuga Romana', '2024-01-15', 'Creciendo', 12.50),
    ('Tomate Cherry', '2024-02-05', 'Maduro', 25.00),
    ('Albahaca Genovesa', '2024-03-20', 'Germinando', 8.75);

INSERT INTO Insumos (Tipo_insumo, Cantidad_disponible, Fecha_caducidad) 
VALUES 
    ('Fertilizante A', 50.0, '2025-01-01'),
    ('Fertilizante B', 75.0, '2025-02-15'),
    ('Solución Nutriente', 120.0, '2025-04-01');

INSERT INTO Cliente (Nombre, Correo, Telefono) 
VALUES 
    ('Luis Gomez', 'luisgomez@example.com', '3123456789'),
    ('Ana Martinez', 'anamartinez@example.com', '3216549870'),
    ('Pedro Sanchez', 'pedrosanchez@example.com', '3001234567');

INSERT INTO Venta (Id_Cliente, Fecha_venta, Total) 
VALUES 
    (1, '2024-04-20', 180.00),
    (2, '2024-05-18', 220.00),
    (3, '2024-06-10', 65.00);

INSERT INTO Detalle_Venta (Id_venta, Id_cultivo, Cantidad, Subtotal) 
VALUES 
    (1, 1, 12, 120.00),
    (1, 2, 4, 60.00),
    (2, 3, 6, 75.00);

INSERT INTO Compras (Id_insumo, Fecha_compra, Cantidad_compra, Total_compra) 
VALUES 
    (1, '2024-04-15', 20.0, 60.00),
    (2, '2024-05-01', 30.0, 90.00),
    (3, '2024-05-25', 50.0, 120.00);

INSERT INTO Resumen_Cultivo (Id_cultivo, Id_insumo, Cantidad_total) 
VALUES 
    (1, 1, 10.0),
    (2, 2, 15.0),
    (3, 3, 20.0);

-- CONSULTA -- 

SELECT 
    c.Tipo_planta,
    SUM(dv.Cantidad) AS Total_Vendido,
    SUM(dv.Subtotal) AS Ingresos
FROM 
    Venta v
JOIN 
    Detalle_Venta dv ON v.Id_venta = dv.Id_venta
JOIN 
    Cultivo c ON dv.Id_cultivo = c.Id_cultivo
WHERE 
    v.Fecha_venta BETWEEN '2024-04-01' AND '2024-06-30'  -- Rango de fechas a modificar
GROUP BY 
    c.Tipo_planta;
