#Crear la base de datos
CREATE DATABASE LosDesterrados; 
USE LosDesterrados;

#Crear las tablas 
CREATE TABLE Cultivo (
    Id_cultivo INT AUTO_INCREMENT PRIMARY KEY,
    Tipo_planta VARCHAR(100),
    Fecha_siembra DATE, 
    Estado_crecimiento VARCHAR(100),
    Redimiento_esperado DECIMAL(10,2)
); 

CREATE TABLE Insumos (
    Id_insumo INT AUTO_INCREMENT PRIMARY KEY,
    Tipo_insumo VARCHAR(100),
    Cantidad_disponible DECIMAL(10,2),
    Fecha_caducidad DATE
);

CREATE TABLE Cliente (
    Id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Correo VARCHAR(60), 
    Telefono VARCHAR(12)
);

CREATE TABLE Venta ( 
    Id_venta INT AUTO_INCREMENT PRIMARY KEY,
    Id_Cliente INT NOT NULL, 
    Fecha_venta DATETIME, 
    Total DECIMAL(10,2),
    FOREIGN KEY (Id_Cliente) REFERENCES Cliente(Id_cliente)
);

CREATE TABLE Detalle_Venta (
    Id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    Id_venta INT, 
    Id_cultivo INT, 
    Cantidad DECIMAL(10,2), 
    Subtotal DECIMAL(10,2), 
    FOREIGN KEY (Id_venta) REFERENCES Venta(Id_venta),
    FOREIGN KEY (Id_cultivo) REFERENCES Cultivo(Id_cultivo)
);

CREATE TABLE Compras (
    Id_compra INT AUTO_INCREMENT PRIMARY KEY, 
    Id_insumo INT, 
    Fecha_compra DATE, 
    Cantidad_compra DECIMAL(10,2), 
    Total_compra DECIMAL(10,2),
    FOREIGN KEY (Id_insumo) REFERENCES Insumos(Id_insumo)
);

CREATE TABLE Resumen_Cultivo (
    Id_resumen INT AUTO_INCREMENT PRIMARY KEY, 
    Id_cultivo INT, 
    Id_insumo INT, 
    Cantidad_total DECIMAL(10,2),
    FOREIGN KEY (Id_cultivo) REFERENCES Cultivo(Id_cultivo),
    FOREIGN KEY (Id_insumo) REFERENCES Insumos(Id_insumo)
);

-- Insertar registros en la tabla Cultivo
INSERT INTO Cultivo (Tipo_planta, Fecha_siembra, Estado_crecimiento, Rendimiento_esperado) 
VALUES 
    ('Lechuga Romana', '2024-01-15', 'Creciendo', 12.50),
    ('Tomate Cherry', '2024-02-05', 'Maduro', 25.00),
    ('Albahaca Genovesa', '2024-03-20', 'Germinando', 8.75);

-- Insertar registros en la tabla Insumos
INSERT INTO Insumos (Tipo_insumo, Cantidad_disponible, Fecha_caducidad) 
VALUES 
    ('Fertilizante A', 50.0, '2025-01-01'),
    ('Fertilizante B', 75.0, '2025-02-15'),
    ('Solución Nutriente', 120.0, '2025-04-01');

-- Insertar registros en la tabla Cliente
INSERT INTO Cliente (Nombre, Correo, Telefono) 
VALUES 
    ('Luis Gomez', 'luisgomez@example.com', '3123456789'),
    ('Ana Martinez', 'anamartinez@example.com', '3216549870'),
    ('Pedro Sanchez', 'pedrosanchez@example.com', '3001234567');

-- Insertar registros en la tabla Venta
INSERT INTO Venta (Id_Cliente, Fecha_venta, Total) 
VALUES 
    (1, '2024-04-20', 180.00),
    (2, '2024-05-18', 220.00),
    (3, '2024-06-10', 65.00);

-- Insertar registros en la tabla Detalle_Venta
INSERT INTO Detalle_Venta (Id_venta, Id_cultivo, Cantidad, Subtotal) 
VALUES 
    (1, 1, 12, 120.00),
    (1, 2, 4, 60.00),
    (2, 3, 6, 75.00);

-- Insertar registros en la tabla Compras
INSERT INTO Compras (Id_insumo, Fecha_compra, Cantidad_compra, Total_compra) 
VALUES 
    (1, '2024-04-15', 20.0, 60.00),
    (2, '2024-05-01', 30.0, 90.00),
    (3, '2024-05-25', 50.0, 120.00);

-- Insertar registros en la tabla Resumen_Cultivo
INSERT INTO Resumen_Cultivo (Id_cultivo, Id_insumo, Cantidad_total) 
VALUES 
    (1, 1, 10.0),
    (2, 2, 15.0),
    (3, 3, 20.0);

-- CONSULTAR --

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
    v.Fecha_venta BETWEEN '2024-04-01' AND '2024-06-30' 
GROUP BY 
    c.Tipo_planta;



