select file_name from dba_Data_files;

--Crear el tablespace
create tablespace prueba
datafile 'C:\ORACLE\ORADATA\XE\PRUEBA01.DBF' size 100m;


alter session set "_ORACLE_SCRIPT"=true;

--creacion del usuario curso 
create user curso 
identified by ucr2023
default tablespace prueba
temporary tablespace temp;

--otorgar permisos al usuario curso
grant connect, resource to curso;

--otorgar espacio en el tablespace al usuario curso 
alter user curso quota unlimited on prueba;