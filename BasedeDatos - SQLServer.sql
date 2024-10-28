create DATABASE LosDesterrados; 

use LosDesterrados;

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