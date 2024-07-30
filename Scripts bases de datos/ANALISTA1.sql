create user ANALISTA1
identified by ucr2023
default tablespace T_SISTEMA
temporary tablespace temp
quota unlimited on T_SISTEMA;

grant connect to ANALISTA1;

select * from SISTEMA.clientes;
select * from SISTEMA.facturas;

select * from user_tables;

create table clientes(
cod_cli number,
telefono varchar(45),
saldo number);

create table facturas(
no_factura number,
cod_cli number,
monto number,A
fecha date);


select * from sistema.facturas;

insert into sistema.facturas values(
0,
0,
0,
'01/01/2001');

delete from sistema.facturas where no_factura =0;

update sistema.facturas set fecha = '07/05/2023' where no_factura=0;

select * from sistema.clientes;