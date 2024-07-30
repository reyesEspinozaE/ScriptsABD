-- creacion de tablas

create table cuenta
(idCuenta number,
nombre varchar(30),
tipo char(6),
primary key (idCuenta));

create table asiento
(ano number not null,
 mes number not null,
 numeroAsiento number not null,
 idCuenta number not null,
 fecha date not null,
 debe number not null,
 haber number not null,
primary key(ano,mes,numeroAsiento,idCuenta));

create table mayor
(ano number not null,
 mes number not null,
 idCuenta number not null,
 debe number not null,
 haber number not null,
 primary key(ano,mes,idCuenta));
 
create table mesCerrado
(ano number not null,
 mes number not null,
primary key(ano,mes));
----------------------------------------------------

-- inserts

insert into cuenta(idCuenta,nombre,tipo) values (111,'Caja','Activo');
insert into cuenta(idCuenta,nombre,tipo) values (112,'Banco Popular','Activo');
insert into cuenta(idCuenta,nombre,tipo) values (113,'Cuentas por cobrar','Activo');
insert into cuenta(idCuenta,nombre,tipo) values (114,'Doc por cobrar','Activo');
insert into cuenta(idCuenta,nombre,tipo) values (115,'Edificio','Activo');
insert into cuenta(idCuenta,nombre,tipo) values (116,'Muebles','Activo');
insert into cuenta(idCuenta,nombre,tipo) values (117,'Vehiculos','Activo');
insert into cuenta(idCuenta,nombre,tipo) values (211,'Cuentas por pagar','Pasivo');
insert into cuenta(idCuenta,nombre,tipo) values (212,'Doc por pagar','Pasivo');
insert into cuenta(idCuenta,nombre,tipo) values (213,'Hipotecas','Pasivo');
insert into cuenta(idCuenta,nombre,tipo) values (311,'Capital social','Pasivo');


-- inserts de movimientos

insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,111,'1/1/2020',350,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,112,'1/1/2020',12600,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,113,'1/1/2020',21500,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,114,'1/1/2020',25700,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,115,'1/1/2020',86250,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,116,'1/1/2020',18000,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,117,'1/1/2020',15600,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,211,'1/1/2020',0,15800);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,212,'1/1/2020',0,20300);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,213,'1/1/2020',0,23900);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,1,311,'1/1/2020',0,120000);

insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,2,211,'2/1/2020',600,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,2,112,'2/1/2020',0,600);

insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,3,111,'2/1/2020',1500,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,3,113,'2/1/2020',0,1500);

insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,4,112,'3/1/2020',1500,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,4,111,'3/1/2020',0,1500);


insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,5,116,'4/1/2020',1000,0);
insert into asiento(ano,mes,numeroAsiento,idCuenta,fecha,debe,haber)
values (2020,1,5,112,'4/1/2020',0,1000);

commit;

select * from cuenta;
select * from asiento where idCuenta=111;

--Funciones y procedimientos

--Funcion para obtener el total del campo debe de la tabla asiento

-- fTotalAsientosDebe(pCuenta number, pAno number, pMes number)
-- devuelve el total al debe de una cuenta

    create or replace function fTotalAsientosDebe(pCuenta number, pAno number, pMes number)
    return number is
        --cursor cAsiento is select * from asiento;
        vRetorna number;
    BEGIN
        select sum(debe) into vRetorna from asiento where idCuenta= pCuenta and Ano= pAno and Mes= pMes;
        
        return vRetorna;
    END;
    
    select fTotalAsientosDebe(111, 2020, 1) from dual;
    
    -- Probar con la cuenta 111 para el anio 2020 mes 1, debe dar 1850

-- fTotalAsientosHaber(pCuenta number, pAno number, pMes number)
-- devuelve el total al debe de una cuenta

    create or replace function fTotalAsientosHaber(pCuenta number, pAno number, pMes number)
    return number is
        vRetorna number;
    BEGIN
        select sum(haber) into vRetorna from asiento where idCuenta= pCuenta and Ano= pAno and Mes= pMes;
        
        return vRetorna;
    END;
    
    select fTotalAsientosHaber(111, 2020, 1) from dual;
-- pMayorizacion(pAnio number, pMes number)
-- Hace la resta y guarda en la tabla mayor

    create or replace procedure pMayorizacion(pAnio number, pMes number)
    IS
        cursor cCuenta is select * from cuenta;
        vHaber number;
        vDebe number;
        vSaldo number;
    BEGIN 
        for i in cCuenta loop
            vDebe:= fTotalAsientosDebe(i.idCuenta, pAnio, pMes);
            vHaber:= fTotalAsientosHaber(i.idCuenta, pAnio, pMes);
            
            if i.tipo= 'Activo' then
                vSaldo:= vDebe - vHaber;
                insert into mayor values(pAnio, pMes, i.idCuenta, vSaldo, 0);
                else
                    vSaldo:= vHaber - vDebe;
                    insert into mayor values(pAnio, pMes, i.idCuenta, 0, vSaldo);
            end if;
        end loop;
    END;
    
    execute pMayorizacion(2020, 1);
    
    select * from Mayor;
    --delete mayor;
