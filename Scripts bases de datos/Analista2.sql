alter session set "_ORACLE_SCRIPT"=true;

create user ANALISTA2
identified by ucr2023
default tablespace T_SISTEMA
temporary tablespace temp
quota unlimited on T_SISTEMA;

grant connect to ANALISTA2;


select * from sistema.facturas;

insert into sistema.facturas 
values(10, 10, 10, '10/05/2023');

delete from sistema.facturas where no_factura=10;

update sistema.facturas set cod_cli=11 where no_factura=10;