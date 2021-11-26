--CREACION DE LA BASE DE DATOS BDFacturaOveniSofSur2
------------------------------------------------------------------------------------------------------------
use master
go
------------------------------------------------------------------------------------------------------------
if exists(select name from sysdatabases where name in('BDFACTURACIONOVENI'))
	drop database BDFACTURACIONOVENI
go
------------------------------------------------------------------------------------------------------------
create database BDFACTURACIONOVENI
go
------------------------------------------------------------------------------------------------------------
use BDFACTURACIONOVENI
go
------------------------------------------------------------------------------------------------------------
-- CREACION DE TABLAS DE LA BASE DE DATOS
------------------------------------------------------------------------------------------------------------
----TClienteNatural---------------------------------
create table TClienteNatural(
 DNI_CN				varchar(8)not null primary key,
 Nombres 			varchar(50)not null,
 Apellidos			varchar(50)not null,
 Telefono			varchar(9)not null,
 Direccion			varchar(50)not null,
 E_mail			varchar(50)not null
)
go
--TClienteJuridico ----------------------------------------------
create table TClienteJuridicos( 
 RUC_CJ				varchar(11)not null primary key,
 Razon_Social		varchar(50)not null,
 Telefono			varchar(9)not null,
 Direccion			varchar(50)not null,
 E_mail			varchar(50)not null
 )
go
------------------------------------------------------------------------------------------------------------
-- CREACION DE TABLAS DE LA BASE DE DATOS
------------------------------------------------------------------------------------------------------------
Create table TUsuario(
 ID_U	int not null identity (1,1)primary key ,
 Id_Usuario AS ('U' + RIGHT('0000' + CONVERT(VARCHAR,ID_U),(4))),
 IdUsuario		varchar(15) not null,
 Contrasena		varbinary(8000) not null,
 )
go
------------------------------------------------------------------------------------------------------------
create table TTrabajador(
 ID_T	int not null identity (1,1) primary key,
 Id_Trabajador AS ('T' + RIGHT('0000' + CONVERT(VARCHAR,ID_T),(4))),
 DNI_T				varchar(8)not null,
 Apellidos			varchar(30)not null,
 Nombres			varchar(30)not null,
 Rol_T				varchar(50)not null,
 Telefono			varchar(9)not null,
 Direccion			varchar(50)not null,
 Genero				Char(1)not null,
 ID_U		int not null,
 foreign key 		(Id_U) references TUsuario,
)
go
------------------------------------------------------------------------------------------------------------
create table TLocal(
 ID_L	int NOT NULL  identity (1,1)primary key,
 Id_Local AS ('L' + RIGHT('0000' + CONVERT(VARCHAR,ID_L),(4))),
 NombreLocal 	varchar(50)not null,
 telefono		varchar(9)not null,
 direccion 		varchar(50)not null,
 )
go
------------------------------------------------------------------------------------------------------------
create table TCategoria(
 ID_C	int NOT NULL identity (1,1)primary key,
 Id_Categoria AS ('C' + RIGHT('0000' + CONVERT(VARCHAR,ID_C),(4))),
 Nombre_Categoria	varchar(50)not null,
 Descripcion 		varchar(50)not null,
 )
go
------------------------------------------------------------------------------------------------------------
create table TProducto(
 ID_P  int NOT NULL identity (1,1)primary key,
 Id_Producto AS ('C' + RIGHT('0000' + CONVERT(VARCHAR,ID_P),(4))),
 Nombre 			varchar(50)not null,
 Descripcion		varchar(50)not null,
 Precio 			real not null check (Precio > 0),
 ID_C		int not null,
 foreign key 		(ID_C) references TCategoria,
 )
go
---TEmpresa---------------------------------------------------------------------------------------------------------
create table TEmpresa(
 RucEmpresa			nvarchar(11)not null primary key,
 RazonSocial		nvarchar(200)not null,
 Direccion		nvarchar(200)not null,
 Telefono		nvarchar(15),
 Celular		nvarchar(9),
 E_mail		nvarchar(200),
 Propietario nvarchar(200)
)
go
----TFactura--------------------------------------------------------------------------------------------------------
create table TFactura(
 Id_Factura			varchar(6)not null primary key,
 Id_Trabajador		INT NOT null,
 Id_Local			INT NOT null,
 Fecha 				datetime not null, 
 SubTotal			decimal(6,2)not null,
 Total				decimal(6,2)not null,
 IGV				decimal(6,2)not null,
 Descuento			decimal(6,2)not null,
 Porcentaje_Desc	decimal(6,2)not null,
 RUC_CJ				varchar(11),
 ID_T				int not null,
 ID_L				int not null,
 RucEmpresa			nvarchar(11) not null,
 foreign key 		(RUC_CJ) references TClienteJuridicos,
 foreign key 		(ID_T) references TTrabajador,
 foreign key 		(ID_L) references TLocal,
 foreign key 		(RucEmpresa) references TEmpresa
)
go
----TBoleta--------------------------------------------------------------------------------------------------------
create table TBoleta(
 Id_Boleta			varchar(6)not null primary key,
 Id_Trabajador		INT NOT null,
 Id_Local			INT NOT null,
 Fecha 				datetime not null, 
 SubTotal			decimal(6,2)not null,
 Total				decimal(6,2)not null,
 Descuento			decimal(6,2)not null,
 Porcentaje_Desc	decimal(6,2)not null,
 DNI_CN				varchar(8),
 ID_T				int not null,
 ID_L				int not null,
 RucEmpresa			nvarchar(11) not null,
 foreign key 		(DNI_CN) references TClienteNatural,
 foreign key 		(ID_T) references TTrabajador,
 foreign key 		(ID_L) references TLocal,
 foreign key 		(RucEmpresa) references TEmpresa
)
go
---TDetalleFactura---------------------------------------------------------------------------------------------------------
create table TDetalleF(
 Id_Factura			varchar(6)not null,
 ID_P				int not null, 
 Cantidad  			real not null check (Cantidad > 0),
 primary key 		(Id_Factura,ID_P),
 foreign key 		(Id_Factura) references TFactura,
 foreign key 		(ID_P) references TProducto
)
go
---TDetalleBoleta---------------------------------------------------------------------------------------------------------
create table TDetalleB(
 Id_Boleta			varchar(6)not null,
 ID_P				int not null, 
 Cantidad  			real not null check (Cantidad > 0),
 primary key 		(Id_Boleta,ID_P),
 foreign key 		(Id_Boleta) references TBoleta,
 foreign key 		(ID_P) references TProducto
)
go
----TNotaCredito--------------------------------------------------------------------------------------------------------
create table TNotaCredito(
 Id_NotaCredito		varchar(6)not null primary key,
 Fecha 				datetime not null, 
 Descrip_Anulación	nvarchar(350)not null,
 Id_Factura			varchar(6)not null,
 foreign key 		(Id_Factura) references TFactura
)
go
-- Insert Cliente Juridico-------
insert into TClienteJuridicos values('20606435607','OVENI PROYECTOS GENERALES E.I.R.L.','957072752','LOS CHASQUIS Q-9','oveniproyectos@gmail.com')
insert into TClienteJuridicos values('20606435608','COCOLOCO S.A.C.','957072755', 'AV SOL Q-20','cocoloco@gmail.com')
insert into TClienteJuridicos values('20606435609','SABROSO S.A.C.','977072755','AV CULTURA A-20','sabrosos@gmail.com')
insert into TClienteJuridicos values('20606435610','EL RICO S.A.C.','977072777', 'AV CULTURA K-77','elrico@gmail.com')
select * from TClienteJuridicos
go

-- Insert Cliente Natural 
insert into TClienteNatural values( '45454545','MIRIAM','PERALTA ARAOZ','957072752','URB VISTA ALEGRE J-34','peraltaam@gmail.com')
insert into TClienteNatural values('47474747','PEDRO','MIRANDA DIAZ', '957077777','CALLE INCA 438','pmirandadiaz@gmail.com')
insert into TClienteNatural values('57575757','MONICA','SUAREZ GAVANCHO','957077778','AV. LA CULTURA S/N','monicasg@gmail.com')
insert into TClienteNatural values('75757575','MARIO','PERALTA DUENAS','957077779','AV. EL SOL 435','peraltamario@gmail.com')
select * from TClienteNatural
----TUsuario--------------------------------------------------------------------------------------------------------
/*insert into TUsuario values ('ZManuel','12345678')
insert into TUsuario values ('VNicolas','43182444')
insert into TUsuario values ('VMonica','00000000')*/
insert into TUsuario values ('VNicolas',ENCRYPTBYPASSPHRASE('pass','43182444'))
insert into TUsuario values ('PManuel',ENCRYPTBYPASSPHRASE('pass','12345678'))
insert into TUsuario values ('VMonica',ENCRYPTBYPASSPHRASE('pass','87654321'))

select * from TUsuario
----TTrabajador--------------------------------------------------------------------------------------------------------
insert into TTrabajador values('12345678','Peralta Zanabria','Manuel','Administrativo','957777777','Chinchaysuto R-45','M',1)
insert into TTrabajador values('43182444','Velasco Ocampo', 'Nicolas','Gerente','957072752', 'Los chasquis Q-9','M',2)
insert into TTrabajador values('00000000','Vera Campana', 'Monica','Contadora','123456789','san jeronimo K-45','F',3)
select * from TTrabajador
----TLocal--------------------------------------------------------------------------------------------------------
insert into TLocal values ('OFICINA CENTRAL','957072752','LOS CHASQUIS Q-9')
insert into TLocal values ('OFICINA CHALLHUAHUACHO','957072777','LOS JERANIOS S/N')
insert into TLocal values ('MOVIL','957072778','ITINERANTE')
select * from TLocal
----TCategoria--------------------------------------------------------------------------------------------------------
insert into TCategoria values ('Servicio','Formulación Perfil Tecnico')
insert into TCategoria values ('Servicio','Elaboración Expediente Técnico')
insert into TCategoria values ('Servicio','Liquidación Técnico')
insert into TCategoria values ('Servicio','Liquidación Financiero')
insert into TCategoria values ('Servicio','Liquidación Técnico Financiero')
insert into TCategoria values ('Servicio','Levantamiento Topografico')
select * from TCategoria
--delete from TCategoria where ID_C = 12
----TProducto--------------------------------------------------------------------------------------------------------
insert into TProducto values ('Consultoria','Formulación Perfil Técnico para el proyecto: ME',18000.00,1)
insert into TProducto values ('Consultoria','Elaboración de un Expediente Téc. proyecto: ME',28000.00,2)
insert into TProducto values ('Consultoria','Liquidación Técnico Financiero del Proyecto:" "',20000.00,5)
select * from TProducto
--delete from TProducto where ID_C = 1
-- Insert Empresa-------
insert into TEmpresa values('20606435607','OVENI PROYECTOS GENERALES E.I.R.L.','LOS CHASQUIS Q-9','084-758577','957072752','oveniproyectos@gmail.com','Nicolas Velasco ocampo')
select * from TEmpresa 
----TFactura--------------------------------------------------------------------------------------------------------
insert into TFactura values ('FE0001',1,2,'10/09/2021',0,0,0.18,5,0.05,20606435610,2,1,20606435607)
insert into TFactura values ('FE0002',2,1,'07/09/2021',0,0,0.18,5,0.05,20606435609,1,2,20606435607)
--insert into TFactura values ('FE0002','20606435608','T001','L001','10/09/2021',0,0,0,1.18)
select * from TFactura
----TBoleta--------------------------------------------------------------------------------------------------------
insert into TBoleta values ('BE0001',1,2,'10/09/2021',0,0,5,0.05,57575757,2,1,20606435607)
insert into TBoleta values ('BE0002',2,1,'07/09/2021',0,0,5,0.05,45454545,1,2,20606435607)
--insert into TFactura values ('FE0002','20606435608','T001','L001','10/09/2021',0,0,0,1.18)
select * from TBoleta
----TDetalleFactura--------------------------------------------------------------------------------------------------------
insert into TDetalleF values ('FE0001',1,'1')
insert into TDetalleF values ('FE0002',2,'1')
select * from TDetalleF
----TDetalleBoleta--------------------------------------------------------------------------------------------------------
insert into TDetalleB values ('BE0001',3,'1')
insert into TDetalleB values ('BE0002',2,'1')
select * from TDetalleB
----TNotaCredito--------------------------------------------------------------------------------------------------------
insert into TNotaCredito values ('NCE002','07/09/2021','Anulación del Servicio por falta de pago','FE0002')
----Mostras las Tablas--------------------------------------------------------------------------------------------------------
select * from TClienteNatural
select * from TClienteJuridicos
select * from TTrabajador
select * from TLocal
select * from TProducto
select * from TEmpresa
select * from TFactura
select * from TDetalleF
select * from TBoleta
select * from TDetalleB
select * from TUsuario
select * from TNotaCredito
