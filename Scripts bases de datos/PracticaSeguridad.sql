--1
create tablespace T_SISTEMA 
datafile 'C:\ORACLE\ORADATA\XE\T_SISTEMA01.DBF' size 10m;

--2
alter session set "_ORACLE_SCRIPT"=true;

create user sistema
identified by ucr2023
default tablespace T_SISTEMA
temporary tablespace temp
quota 10m on T_SISTEMA;

grant "DBA", resource to sistema;
grant connect, resource to sistema;
--3

create table clientes(
cod_cli number,
telefono varchar(45),
saldo number);

create table facturas(
no_factura number,
cod_cli number,
monto number,
fecha date);

select * from user_tables;  --De esta manera puedo ver las tablas que tiene el user
                            -- con el que estoy conectado.
                            
------------------------------------ Inserts de la tabla facturas                           
insert into clientes values(
1, '71121459', 15000);

insert into clientes values(
2, '71121459', 25000);

insert into clientes values(
3, '71121459', 35000);

insert into clientes values(
4, '71121459', 45000);

insert into clientes values(
5, '71121459', 55000);

------------------------------------ Inserts de la tabla facturas

insert into facturas values(
1, 1, 25000, '25/10/2023');

insert into facturas values(
2, 2, 35000, '01/11/2023');

insert into facturas values(
3, 3, 45000, '15/03/2023');

insert into facturas values(
4, 4, 55000, '13/02/2023');

insert into facturas values(
5, 5, 65000, '23/05/2023');


select * from clientes;
select * from facturas;

--grant create table to ANALISTA1;

select * from ANALISTA1.clientes;

--El permiso para que ananlista1, pueda ver las tablas desde user sistema seria:
grant select on sistema.clientes from ANALISTA1;

--6
--Creando un rol
create role ROLE1;

--Asignando los privilegios al role
grant select on SISTEMA.clientes to ROLE1;
grant insert on SISTEMA.facturas to ROLE1;
grant delete on SISTEMA.facturas to ROLE1;
grant select on SISTEMA.facturas to ROLE1;
grant update on SISTEMA.facturas to ROLE1;

--Asignando el rol a un usuario
grant ROLE1 to ANALISTA1;

alter user ANALISTA1
identified by ucr2023
default tablespace T_SISTEMA
temporary tablespace temp
quota unlimited on T_SISTEMA
default role ROLE1;

--Como el usuario ANALISTA1, estaba conectado a la BD al momento de asignarle el role ROLE1
--era necesario desconectarlo de la BD y volverlo a conectar, pero me decia que debia asignarle el 
--privilegio create session al usuario ANALISTA1
grant create session to ANALISTA1;
--revoke correcto
--revoke insert on SISTEMA.clientes from ROLE1;


--Creando ROLE 2
create role ROLE2;

--Creando la vista para que puede seleccionar sistema.clientes
--pero no vea el campo saldo

create or replace view vClientes
as select c.cod_cli, c.telefono from sistema.clientes c;

select * from vClientes;

--Asignamos los provilegios al role
grant select on sistema.facturas to ROLE2;
grant insert on sistema.facturas to ROLE2;
grant select on vClientes to ROLE2;

--Asignamos el role al user

grant ROLE2 to ANALISTA2;

grant create session to ANALISTA2;

alter user ANALISTA2
identified by ucr2023
default tablespace T_SISTEMA
temporary tablespace temp
default role ROLE2;

--7 
--Usando la vista DBA_TAB_PRIVS, realizar el query necesario para verificar que los
--anteriores grants fueron realizados satisfactoriamente

select * from DBA_TAB_PRIVS where owner = 'ANALISTA1';
select * from DBA_TAB_PRIVS where owner = 'ANALISTA2';
select * from DBA_TAB_PRIVS where owner = 'SISTEMA';

--8
--Usando la vista DBA_SYS_PRIVS, realizar el query necesario para ver los
--privilegios de sistema que tiene asignados el role llamado DBA

select * from DBA_SYS_PRIVS where grantee = 'DBA';

--9 
--Usando la vista DBA_ROLE_PRIVS, realizar e query necesario para ver que usuarios
--tienen asignado el role DBA

select * from DBA_ROLE_PRIVS where granted_role ='DBA';