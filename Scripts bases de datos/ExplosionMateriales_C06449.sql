select file_name from dba_Data_files;

select * from dba_tablespaces;

--Crear el tablespace
create tablespace materiales
datafile 'C:\ORACLE\ORADATA\XE\MATERIALES.DBF' size 100m;


alter session set "_ORACLE_SCRIPT"=true;

--creacion del usuario curso 
create user materiales 
identified by ucr2023
default tablespace materiales
temporary tablespace temp;

--otorgar permisos al usuario curso
grant connect, resource to materiales;

--otorgar espacio en el tablespace al usuario curso 
alter user curso quota unlimited on materiales;


grant "DBA", resource to MATERIALES;


create table producto(
idProducto number,
nombre varchar(50),
primary key(idProducto));

create table insumos(
idInsumo number,
nombre varchar(50),
primary key(idInsumo));

create table inventario(
idInsumo number,
cantidad number,
reserva number,
primary key(idInsumo));

create table receta(
idProducto number,
idInsumo number,
cantidad number,
primary key(idProducto,idInsumo));

create table pedido(
idPedido number,
fechaPedido date,
fechaEntrega date,
primary key(idPedido));

create table pedidoDetalle(
idPedido number,
idProducto number,
cantidad number,
primary key(idPedido,idProducto));

create table ordenProduccion(
idOrdenProd number,
idPedido number,
primary key(idOrdenProd));

create table ordenProdDetalle(
idOrdenProd number,
idProducto number,
cantidad number,
primary key(idOrdenProd,idProducto));

create table ordenCompra(
idOrdenCompra number,
fecha date,
primary key(idOrdenCompra));

create table detalleOrdenCompra(
idOrdenCompra number,
idInsumo number,
cantidad number,
primary key(idOrdenCompra,idInsumo));

create table bitacortaExplosionMat(
idBitacora number,
fechaEjecucion date,
cantidadPedProduccion number,
cantidadPedCompra number,
primary key(idBitacora));
create table detalleExplosionMat(
idBitacora number,
idPedido number,
resultado char(20),
primary key(idbitacora,idPedido));

----------------------------------------------------
----------- Inserts

Insert into producto values (1,'producto1');
Insert into producto values (2,'producto2');
Insert into producto values (3,'producto3');

Insert into insumos values (1,'insumo 1');
Insert into insumos values (2,'insumo 2');
Insert into insumos values (3,'insumo 3');
Insert into insumos values (4,'insumo 4');

Insert into inventario values (1, 6,0);
Insert into inventario values (2, 12,0);
Insert into inventario values (3, 4,0);
Insert into inventario values (4, 2,0);

Insert into receta values (1,1,2);
Insert into receta values (1,2,3);
Insert into receta values (2,1,1);
Insert into receta values (2,3,1);
Insert into receta values (2,4,1);
Insert into receta values (3,1,2);
Insert into receta values (3,2,2);
Insert into receta values (3,4,2);

Insert into pedido values (1,sysdate, '10-06-2022');
Insert into pedido values (2,sysdate, '15-06-2022');
Insert into pedido values (3,sysdate, '20-06-2022');
Insert into pedido values (4,sysdate, '21-06-2022');

Insert into pedidoDetalle values (1, 1, 2);
Insert into pedidoDetalle values (1, 2, 2);
Insert into pedidoDetalle values (2, 1, 1);
Insert into pedidoDetalle values (2, 2, 1);
Insert into pedidoDetalle values (3, 3, 2);
Insert into pedidoDetalle values (4, 1, 1);
Insert into pedidoDetalle values (4, 2, 1);

--------------------------------------------------------

select * from insumos;
set serveroutput on;

create or replace function verificaInsumos(pIdInsumo number)
return number is
    cursor cReceta is select * from receta where idInsumo =pIdInsumo;
    cursor cInventario is select * from inventario where idInsumo =pIdInsumo;
    vExistencia number:=0;
    vSuficiente number:=0;
BEGIN
    for i in cReceta loop
        for j in cInventario loop
            select cantidad into vExistencia from inventario;
            if vExistencia < i.cantidad then
                vSuficiente:=1;
                dbms_output.put_line(vSuficiente);
            end if;
        end loop;
    end loop;
    --return vSuficiente;
END;

select verificaInsumos(1) from dual;