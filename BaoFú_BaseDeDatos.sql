create database BaoFuBD_22
use BaoFuBD_22


drop table Usuario
drop table Pedido
drop table Tickets
drop table Platillos
drop table MetodoPago
drop table Empleado

---Tablas (Normales) ------

select * from Usuario
select * from Platillos
select * from MetodoPago
select * from Pedido
select * from Tickets

---Tablas (de Triggers)----

select * from log_AltaUsuario
select * from log_Pedido
select * from log_Tickets


create table Usuario (
    Id int primary key not null identity(1,1),
    Nombre varchar(50) not null,
	Usuario varchar(50) not null,
	Email varchar(50) not null,
	Telefono bigint not null,
	Direccion varchar(30) not null,    
	Contraseña varchar(50) not null  
)   

create table Platillos(

    Id int primary key not null identity(1,1),
    Nombre varchar(20) not null,
    Precio numeric(10,2) not null
)

create table MetodoPago (
    Id int primary key not null identity(1,1),
    Tipo varchar(20) not null
)

create table Empleado (
	Id int primary key not null identity(1,1),
	Nombre varchar(20) not null,
	Paterno varchar(20) not null,
	Materno varchar(20),
	Direccion varchar(50)
)

create table Pedido(

    Id_Pedido int primary key not null identity(1,1),
    Id_Platillo int not null,
    Id_Usuario int not null,
    Direccion varchar(30),
    Descripcion varchar(50),
	FOREIGN KEY (Id_Usuario) REFERENCES Usuario(Id),
	FOREIGN KEY (Id_Platillo) REFERENCES Platillos(Id)
)

create table Tickets(

    Id int primary key not null identity (1,1), 
    Id_FormaPago int not null,
	Id_Empleado int not null,
    Fecha smalldatetime,
    Total numeric(10,2) not null,
	FOREIGN KEY(Id_Empleado) REFERENCES Empleado(Id),
	FOREIGN KEY(Id_FormaPago) REFERENCES MetodoPago(Id)


)

----Procesos Alamcenados----
 
 drop proc AgregarUsuario

create proc AgregarUsuario

    @nom varchar(60),
	@usu varchar(50),
	@email varchar(50),
	@tel bigint,
	@direc varchar(30),    
	@contra varchar(50)

AS

	insert into Usuario (Nombre,Usuario,Email,Telefono,Direccion,Contraseña)
	values(@nom,@usu,@email,@tel,@direc,@contra)
	select 1 as mensaje
	return 1

	exec AgregarUsuario 'Ana Rosa Hernández', 'ARH28','ar82@live.com' ,3314548670, 'Av. Patria #102', 'cafe123' 

---------------------------------------------------------------------


create proc AgregaPlatillo

    @nombre varchar(20),
    @precio NUMERIC(10,2)
AS
	insert into  Platillos(Nombre,Precio)
	values(@nombre,@precio)
    select 'Platillo Agregado' as MESSAGE

	exec AgregaPlatillo 'Pollo A la Naranja', '150'

---------------------------------------------------------------------

create proc AgregaMetodoPago
    @tipo varchar(20)
AS
    insert into MetodoPago(Tipo)
    VALUES(@tipo)
	select 'Metodo Agregado' as MESSAGE

	exec AgregaMetodoPago 'EFECTIVO'

---------------------------------------------------------------------


create proc AgregaPedido
    @idplat int,
    @idusuario int,
    @direc varchar(30),
    @desc varchar(50)
AS
    if EXISTS(
        SELECT * FROM  Platillos where Id = @idplat
    )AND EXISTS(
        SELECT * FROM  Usuario where Id = @idusuario
    )
		BEGIN
			insert into Pedido(Id_Platillo,Id_Usuario,Direccion,Descripcion)
			VALUES(@idplat,@idusuario,@direc,@desc)
			select 'Pedido Generado' as MESSAGE
		END
	else 
		select 'Error en el Pedido' as ERROR

	exec AgregaPedido 1,1, 'Av.Patria #92', 'Pedido de Pollo'

------------------------------------------------------------------------------------------------------

create proc AgregaTickets
	@formapag int,
	@emp int,
    @tot numeric(10,2)
AS
    if EXISTS(
        SELECT * FROM MetodoPago where Id = @formapag
    )AND EXISTS(
        SELECT * FROM  Empleado where Id = @emp
    )
		BEGIN
			insert into Tickets(Id_FormaPago,Id_Empleado,Fecha,Total )
			VALUES(@formapag,@emp,GETDATE(),@tot)
			select 'Ticket Generado' as MESSAGE
		END
	else 
		select 'Error en el Ticket' as ERROR

	exec AgregaTickets 1,1,150.00

--------------------------------------------------------------------------------------------------
create proc AgregaEmpleado
	@nombre varchar(20),
	@pat varchar(20),
	@mat varchar(20),
	@direc varchar(50)
AS
	insert into  Empleado(Nombre,Paterno,Materno,Direccion)
	values(@nombre,@pat,@mat,@direc)
    select 'Empleado Agregado' as MESSAGE

	exec AgregaEmpleado 'Emilia','Rojas','Martínez','Av. Vallarta #92'




----Triggers-----


create table log_AltaUsuario(  ---Tabla del Trigger---
    Id int primary key not null identity(1,1),
    Nombre varchar(50) not null,
	Usuario varchar(50) not null,
	Email varchar(50) not null,
	Telefono bigint not null,
	Direccion varchar(30) not null,    
	Contraseña varchar(50) not null,
	Mensaje varchar(50),
	Fecha smalldatetime
)

create trigger tg_UsuarioRegistrado ---Trigger---
on Usuario
after insert 
AS 
    insert into log_AltaUsuario(Nombre,Usuario,Email,Telefono,Direccion,Contraseña,Mensaje,Fecha)
    select Nombre,Usuario,Email,Telefono,Direccion,Contraseña,'Registrado',GETDATE()
	FROM inserted

------------------------------------------------------------------------------------------------------    


create table log_Pedido(   --Tabla del Trigger---
    Id_Pedido int primary key not null identity(1,1),
    Id_Platillo int,
    Id_Usuario int,
    Direccion varchar(30),
    Descripcion varchar(50),
    Mensaje varchar(20),
    Fecha smalldatetime
)

create trigger tg_PedidoRegistro --Trigger
on Pedido
after insert 
AS 
    insert into log_Pedido(Id_Platillo,Id_Usuario,Direccion,Descripcion,Mensaje,Fecha)
    select Id_Platillo,Id_Usuario,Direccion,Descripcion,'Registrado', GETDATE()
	FROM inserted

------------------------------------------------------------------------------------------------------

create table log_Tickets(

    Id int primary key not null identity (1,1), 
    Id_FormaPago int,
	Id_Empleado int,
    Total numeric(10,2),
    Mensaje varchar(30),
    Fecha smalldatetime 

)

create trigger tg_TicketsAgregados
on Tickets
after INSERT
AS  
    insert into log_Tickets(Id_FormaPago,Id_Empleado,Total,Mensaje,Fecha)
    SELECT Id_FormaPago,Id_Empleado,Total,'Ticket Registrado',GETDATE()
	FROM inserted
	

create proc log_in

	@username varchar(50),
	@password varchar(20)
AS
	if exists (select * from Usuario where Usuario = @username and Contraseña = @password) 
		select 1 as mensaje
		return 1
	else
		select 0 as mensaje
		return 0



