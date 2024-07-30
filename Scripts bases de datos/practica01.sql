select file_name from dba_Data_files;

create tablespace T_PRUEBAS datafile 'C:\APP\UCR\PRODUCT\21C\ORADATA\XE\t_pruebas.DBF' size 10m;

create tablespace T_PRUEBAS2 datafile 'C:\APP\UCR\PRODUCT\21C\ORADATA\XE\t_pruebas2.DBF' size 10m;

alter session set "_ORACLE_SCRIPT"=true;

create user SPL
identified by ucr2023
default tablespace T_PRUEBAS 
temporary tablespace TEMP;

grant connect, resource to SPL2;


create user SPL2
identified by ucr2023
default tablespace T_PRUEBAS2 
temporary tablespace TEMP;

create table empleados(
cod_emp number,
nombre varchar(50),
edad number,
salario number,
cod_dep number);


create table departamentos(
cod_dep number,
descripcion varchar(50));


insert into departamentos values(
1,
'recursos humanos');

insert into departamentos values(
2,
'mercadeo');

insert into departamentos values(
3, 
'finanzas');

select * from departamentos

----------------------------Empleados

insert into empleados values(
1,
'Angela',
28,
735000,
3);

insert into empleados values(
2, 
'Omar',
32,
825000,
2);

insert into empleados values(
3,
'Rebeca',
36,
835000,
1);

insert into empleados values(
4, 
'Francisco',
42,
975000,
3);

insert into empleados values(
5, 
'Leti',
52,
995000,
3);

create tablespace T_PRUEBAS datafile 'C:\APP\UCR\PRODUCT\21C\ORADATA\XE\t_pruebas.DBF' 
size 10m default storage (initial 1m next 1m pctincrease 0);


-----------------Primera parte-----------------
select * from dba_tablespaces

select * from dba_data_files

select * from dba_tables

select * from user_tables

--1
select tablespace_name from dba_tablespaces

--2 x
select sum(bytes) from dba_data_files

--3 
select file_name, bytes from dba_data_files order by bytes

--4pendiente 
select tablespace_name from dba_data_files;

--5