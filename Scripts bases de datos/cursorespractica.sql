create table productos(
producto char(20),
cantidad number);

create table resumen(
producto char(20),
cantidad number);

insert into productos values('atun',100);
insert into productos values('coca cola',10);
insert into productos values('arroz',55);
insert into productos values('frijoles',25);
insert into productos values('arroz',40);
insert into productos values('atun',25);
commit;

select * from productos;

-- usando cursores
-- sin usar funciones de agrupamiento 
-- llenar la tabla resumen
-- el programa se puede correr mas de una vez
set serveroutput on;

declare
    vTemp number;
    cursor cProductos is select * from productos;
begin
    delete from resumen;
    for i in cProductos loop
        select count(*) into vTemp from productos
        where producto= i.producto;

            if vTemp = 0 then
                insert into resumen values(i.producto, i.cantidad);
                else
                    update resumen 
                    set cantidad= cantidad+i.cantidad
                    where producto= i.producto;
            end if;
    end loop;
end;

-- count(*) retorna un 1 o un 0, 0 si la tabla no tiene nada
-- 1 si la tabla tiene datos
select * from productos;
select * from resumen

-----------------------------------------------------------------

create table factura(
idFactura number, 
fecha date,
montoTotal number,
primary key(idFactura));

create table facturaDet(
idFactura number,
idProducto number,
cantidad number,
precioUni number,
subtotal number,
primary key(idfactura, idProducto));

select * from factura;
select * from facturaDet;

insert into factura values (1, sysdate, 100);
insert into factura values (2, sysdate, 200);
insert into factura values (3, sysdate, 150);
commit;

insert into facturaDet values(1,1,1,10,10);
insert into facturaDet values(1,2,2,50,100);
insert into facturaDet values(2,1,1,10,10);
insert into facturaDet values(2,2,2,50,100);
insert into facturaDet values(2,3,2,50,100);
insert into facturaDet values(3,1,1,150,150);
commit;

-- usando cursores
-- sin funciones de agrupamiento
-- imprimir en pantalla las facturas que tienen
-- mal calculado su MontoTotal 
-- debe imprimir factura, montoTotal, y el precio adecuado

declare
    cursor is select * from facturaDet;
    cursor c
begin
    for i in cFacturaDet loop
        
    end loop;
end;