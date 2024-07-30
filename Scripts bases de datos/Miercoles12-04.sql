-- se crean las tablas

drop table factura;
drop table facturaDetalle;
drop table cliente;
drop table pedido;
drop table pedidoDetalle;
drop table producto;

create table factura
(idFactura number,
fecha date,
montoTotal number,
idCliente number,
idPedido number,
primary key(idFactura));

create table facturaDetalle
(idFactura number,
idProducto number,
cantidad number,
subTotal number,
precio number,
primary key(idFactura,idProducto));

create table cliente
(idCliente number,
nombre varchar(30),
tipo char(1),
primary key(idCliente));

create table producto
(idProducto number,
nombre varchar(30),
precio number,
primary key(idProducto));

create table pedido
(idPedido number,
fecha date,
idCliente number,
primary key(idPedido));

create table pedidoDetalle
(idPedido number,
idProducto number,
cantidad number,
primary key(idPedido,idProducto));

-- se crea la Integridad Referencial

alter table facturaDetalle add foreign key(idFactura) references factura(idFactura);
alter table facturaDetalle add foreign key(idProducto) references producto(idProducto);

alter table pedidoDetalle add foreign key(idPedido) references pedido(idPedido);
alter table pedidoDetalle add foreign key(idProducto) references producto(idProducto);

alter table pedido add foreign key(idCliente) references cliente(idCliente);

alter table factura add foreign key(idCliente) references cliente(idCliente);
alter table factura add foreign key(idPedido) references pedido(idPedido);


-- insertamos datos

insert into cliente values(1,'cliente 1','A');
insert into cliente values(2,'cliente 2','A');
insert into cliente values(3,'cliente 3','B');
insert into cliente values(4,'cliente 4','B');
insert into cliente values(5,'cliente 5','A');

insert into producto values(1,'producto 1',100);
insert into producto values(2,'producto 2',150);
insert into producto values(3,'producto 3',50);
insert into producto values(4,'producto 4',200);
insert into producto values(5,'producto 5',500);

insert into pedido values(1,'01/04/22',1);
insert into pedido values(2,'01/04/22',1);
insert into pedido values(3,'01/04/22',5);
insert into pedido values(4,'01/04/22',2);
insert into pedido values(5,'01/04/22',3);
insert into pedido values(6,'01/04/22',3);

insert into pedidoDetalle values(1,1,2);
insert into pedidoDetalle values(1,2,1);
insert into pedidoDetalle values(1,3,3);

insert into pedidoDetalle values(2,1,2);
insert into pedidoDetalle values(2,2,1);

insert into pedidoDetalle values(3,5,1);
insert into pedidoDetalle values(3,1,2);
insert into pedidoDetalle values(3,2,1);
insert into pedidoDetalle values(3,3,3);

insert into pedidoDetalle values(4,2,2);
insert into pedidoDetalle values(4,3,1);
insert into pedidoDetalle values(4,4,3);

insert into pedidoDetalle values(5,4,2);
insert into pedidoDetalle values(5,5,1);

commit;

----------------------------------------

--------------------
---- Solucion 1 ----
--------------------
Declare
    cursor cCliente is 
        select * from cliente where tipo ='A';
    cursor cPedido(pCliente number) is 
        select * from pedido 
        where idCliente = pCliente;
    cursor cPedidoDetalle(pPedido number) is 
        select * from pedidodetalle
        where idPedido = pPedido;
    
    vPrecio number:= 0;
    vExiste number:= 0;
    vNumeroFactura number:= 0;
    vMontoTotal number:= 0;
Begin
    select count(*)+1 into vNumeroFactura from factura;
    for i in cCliente loop
        for j in cPedido(i.idCliente) loop
            select count(*) into vExiste 
            from factura where idPedido = j.idPedido;
            
            if vExiste =0 then
                vMontoTotal:= 0;
                --  Insertamos encabezado factura
                insert into factura values(vNumeroFactura, sysdate, vMontoTotal, j.idCliente, j.idPedido);
            
                for k in cPedidoDetalle(j.idPedido) loop
                    select precio into vPrecio
                    from producto where idProducto = k.idProducto;
                
                    --Insertar en facturaDetalle
                    insert into facturaDetalle 
                    values(vNumeroFactura, k.idProducto, k.cantidad, 
                    (k.cantidad*vPrecio), vPrecio);
                
                    vMontoTotal:= vMontoTotal + (k.cantidad*vPrecio);
                end loop;
                -- Actualizamos la factura
                update factura 
                set montoTotal= vMontoTotal
                where idFactura= vNumeroFactura;
                
                -- Aumentar el numero de la factura
                vNumeroFactura:= vNumeroFactura +1;
            end if;
        end loop;
    end loop;
End;

---------------------------
---- Fin de Solucion 1 ----
---------------------------



select * from factura;
select * from facturaDetalle;

delete from facturaDetalle;
delete from factura;



----------------------------------------

--------------------
---- Solucion 2 ----
--------------------

Declare
    cursor cPedido is 
        select p.idPedido, p.idCliente
        from pedido p, cliente c 
        where p.idCliente = c.idCliente
        and c.tipo='A'
        and p.idPedido NOT IN (select idPedido from factura);
    cursor cPedidoDetalle(pPedido number) is 
        select pd.idPedido, pd.idProducto, pd.cantidad, 
        p.precio, (pd.cantidad*p.precio) as "subtotal"
        from pedidoDetalle pd, producto p
        where idPedido= pPedido
        and pd.idProducto = p.idProducto;
    
    vPrecio number:= 0;
    vNumeroFactura number:= 0;
    vMontoTotal number:= 0;
Begin
    select count(*)+1 into vNumeroFactura from factura;
    for j in cPedido loop
            
        vMontoTotal:= 0;
        --  Insertamos encabezado factura
        insert into factura 
        values(vNumeroFactura, sysdate, vMontoTotal, j.idCliente, j.idPedido);
            
        for k in cPedidoDetalle(j.idPedido) loop
                
            --Insertar en facturaDetalle
            insert into facturaDetalle 
            values(vNumeroFactura, k.idProducto, k.cantidad, 
                (k.subtotal), k.Precio);
                
            vMontoTotal:= vMontoTotal + (k.cantidad*vPrecio);
        end loop;
        -- Actualizamos la factura
        update factura 
        set montoTotal= vMontoTotal
        where idFactura= vNumeroFactura;
                
        -- Aumentar el numero de la factura
        vNumeroFactura:= vNumeroFactura +1;
    end loop;
End;

---------------------------
---- Fin de Solucion 2 ----
---------------------------


----------------------------------
---- Validacion de caracteres ----
----------------------------------
set serveroutput on;

---- Tablas ----
create table auxAper (caracter char(1),contador number);
create table auxCier (caracter char(1),contador number);

---- Bloque anonimo ----
declare
    vTxt varchar(20):= '}(]([)]{{{{';
    vLtr varchar(5):= '';
    --vMensaje varchar(50);
    vContador number:=0;
    vContadorC number:= 0;
    vCarA varchar(1):='';
    vCarC varchar(1):='';
begin
    if substr(vTxt, 1, 1) IN ('}', ']', ')') and substr(vTxt, length(vTxt), 1) IN ('[', '{', '(') then
        --vMensaje:='';
        for i in 1..length(vTxt) loop
            vLtr:= substr(vTxt, i, 1);
            if  vLtr IN ('{', '[', '(') then
                insert into auxAper values(substr(vTxt, i, 1), vContador);
                vContador:= vContador+1;
            else
                insert into auxCier values(substr(vTxt, i, 1), vContadorC);
                vContadorC:= vContadorC+1;
                select caracter into vCarA from auxAper where contador = vContador; --Tengo en null las tablas, por lo que no puedo ejecutrar este select
                select caracter into vCarC from auxCier where contador = vContadorC; 
            end if;
            -------------------------------------------------------------------------
            if vCarA = '{' then
                if vCarC = '}' then
                    delete from auxAper where contador = vContador;
                    delete from auxCier where contador = vContadorC;
                end if;
            else
                if vCarA = '[' then
                    if vCarC = ']' then
                        delete from auxAper where contador = vContador;
                        delete from auxCier where contador = vContadorC;
                    end if;
                    else
                        if vCarA = '(' then
                            if vCarC = ')' then
                                delete from auxAper where contador = vContador;
                                delete from auxCier where contador = vContadorC;
                            end if;
                    end if;
                end if;
            end if;
            -------------------------------------------------------------------------
        end loop;
        --delete from aux;
    else
        dbms_output.put_line('No es valido');
    end if;
end;

---- Selects and deletes ----
select * from auxAper;
delete from auxAper;

select * from auxCier;
delete from auxCier;

declare
    vTxt varchar(20):= '}(]([)]{{{{';
begin 
    dbms_output.put_line();
end;