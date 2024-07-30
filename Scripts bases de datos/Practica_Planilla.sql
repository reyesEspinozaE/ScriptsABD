drop table empleado cascade constraints;
drop table marcas cascade constraints;
drop table produccion cascade constraints; 
drop table planilla cascade constraints;
drop table producto cascade constraints;
drop table diasferiados cascade constraints;

create table empleado( 
    idEmpleado number, 
    nombre varchar(20), 
    tipoEmpleado varchar(15), 
    salario number, 
primary key(idEmpleado)); 

insert into empleado values (1,'Juan', 'Destajo', 0); 
insert into empleado values (2,'Ana', 'Por hora', 200); 
insert into empleado values (3,'Carlos', 'Destajo', 0); 
insert into empleado values (4,'Pedro', 'Por hora', 100); 


create table marcas( 
    idMarca number, 
    idEmpleado number, 
    fecha date, 
    entrada number, 
    salida number, 
    tipoMarca varchar(10), 
primary key(idMarca)); 

insert into marcas values (1,2,'07-01-2022', 8, 11, 'Diurnas'); 
insert into marcas values (2,4,'14-01-2022', 18, 23, 'Nocturnas'); 
insert into marcas values (3,4,'10-01-2022', 8, 10, 'Diurnas'); 
insert into marcas values (4,4,'10-01-2022', 12, 14, 'Diurnas'); 
insert into marcas values (5,2,'11-01-2022', 18, 22, 'Nocturnas'); 

create table produccion( 
    idProduccion number, 
    fecha date, 
    idProducto number, 
    idEmpleado number, 
    kilosProducidos number, 
primary key(idProduccion)); 

insert into produccion values(1, '07-01-2022', 1, 1, 10); 
insert into produccion values(2, '14-01-2022', 2, 3, 15);   -- 15*500=7500
insert into produccion values(3, '14-01-2022', 3, 3, 5);    -- 15*50 =750    total:8250
insert into produccion values(4, '14-01-2022', 3, 3, 10); 
insert into produccion values(5, '15-01-2022', 5, 3, 15); 

create table producto( 
    idProducto number, 
    nombre varchar(10), 
    costoKiloProducido number, 
primary key(idProducto)); 
    
insert into producto values (1, 'Helado', 750); 
insert into producto values (2, 'Chocolate', 500); 
insert into producto values (3, 'Coca Cola', 50); 
insert into producto values (4, 'Agua', 100); 
insert into producto values (5, 'Frutas', 200); 

create table planilla( 
    idEmpleado number, 
    fecha date, 
    montoAPagar number, 
primary key(idEmpleado,Fecha)); 

create table diasFeriados( 
    idFeriado number, 
    fecha date, 
    descripcion varchar(20), 
primary key(idFeriado)); 

insert into diasFeriados values (1, '15-01-2022', 'un feriado'); 
commit;

--Funciones y proedimientos

-- fDiaFeriado(pFecha)
 --retorna si el dia es feriado 0/1
 
 create or replace function fDiaFeriado(pFecha date)
 return number is 
    vExiste number;
 BEGIN
        select count(*) into vExiste from diasFeriados where fecha= pFecha;
        return  vExiste;
 END;
 
 select fDiaFeriado('15-01-2022') from dual;
 

-- fPagoKilosProducidos(pIdEmpleado number, pFecha date)
 --retorna el monto a pagar para ese dia para ese emp
 
 create or replace function fPagoKilosProducidos(pIdEmpleado number, pFecha date)
 return number is
 vKilosProducidos number;
 vMontoPagar number;
 BEGIN
    select nvl(sum(p.kilosProducidos * pr.costokiloproducido),0)into vMontoPagar
    from produccion p, producto pr
       where fecha= pFecha and idEmpleado= pIdEmpleado and pr.idProducto= p.idProducto
            and p.idEmpleado= pIdEmpleado;
    
    return vMontoPagar * (fDiaFeriado(pFecha)+1);        
 END;
 
-- fHorasDiurnas(pIdEmpleado number, pFecha date)
 --retorna las horas diurnas trabajadas
 create or replace function fHorasDiurnas(pIdEmpleado number, pFecha date)
 return number is
 vHorasT number;
 BEGIN 
    select nvl(sum(salida - entrada), 0) into vHorasT from marcas where idEmpleado= pIdEmpleado 
        and fecha= pFecha and tipoMarca= 'Diurnas';
    return vHorasT;
 END;
 
 select fHorasDiurnas(4, '10-01-2022') from dual;
 
 
-- fHorasNocturnas(pIdEmpleado number, pFecha date)
 --retorna las horas nocturnas trabajadas
  create or replace function fHorasNocturnas(pIdEmpleado number, pFecha date)
 return number is
 vHorasT number;
 BEGIN 
    select nvl(sum(salida - entrada), 0) into vHorasT from marcas where idEmpleado= pIdEmpleado 
        and fecha= pFecha and tipoMarca= 'Nocturnas';
    return vHorasT;
 END;
 
 select fHorasNocturnas(4, '14-01-2022') from dual;
 
 
-- fPagoHoras(pIdEmpleado number, pFecha date)
 -- retorna el monto a pagar para ese dia
 create or replace function fPagoHoras(pIdEmpleado number, pFecha date)
 return number is
    vMontoPagar number;
    vSalario number;
 BEGIN
    select salario into vSalario from empleado where idEmpleado= pIdEmpleado;
    
    vMontoPagar:= fHorasDiurnas(pIdEmpleado, pFecha) * vSalario;
    vMontoPagar:= vMontoPagar+(fHorasNocturnas(pIdEmpleado, pFecha));
    vMontoPagar:= vMontoPagar+(fDiaFeriado(pFecha)+1);
    
    return vMontoPagar;
 END;
 
 select fPagoHoras(4, '14/01/2022') from dual;
 
-- pPlanilla(pFechaInicial date, pFechaFinal date)
 -- hace el calculo de la planilla
 
 create or replace procedure pPlanilla(pFechaInicial date, pFechaFinal date)
 IS
    cursor cEmpleados is select * from empleados;
    vFecha date;
    vMontoPagar number;
 BEGIN
    --delete form planilla where fecha between pFechaIncial and pFechaFinal;
    --Para borrar si se va a usar mas de una vez
    for i in cEmpleados loop
        vFecha:= pFechaInicial;
        while vFecha<=pFechaInicial loop
            if i.tipoEmpleado = 'Por hora' then
                vMontoPagar:= fPagoHoras(i.idEmpleado, vFecha);
                else 
                    vMontoPagar:= fPagoKilosProducidos(i.idEmpleado, vFecha);
            end if;
            
            if vMontoPagar > 0 then
                insert into planilla values(i.idEmpleado, vFecha, vMontoPagar);
            end if;
            vFecha:= vFecha+1;
        end loop;
    end loop;
 END;
 
execute pPlanilla('01-01-2022','31-01-2022');
select *from planilla;
------------------------------------------------------------------------------------
----------------------------- El codigo del profe ----------------------------------
------------------------------------------------------------------------------------

create or replace function fPagoHoras(pidEmpleado number, pFecha date)
return number
IS
  vMontoPagar number:=0;
  vSalario number;
BEGIN
  select salario into vSalario
  from empleado where idEmpleado=pidEmpleado;
  
  vMontoPagar:=fHorasDiurnas(pidEmpleado,pFecha)*vSalario;
  vMontoPagar:=vMontoPagar+(fHorasNocturnas(pidEmpleado,pFecha)*vSalario);
  vMontoPagar:=vMontoPagar*(fDiaFeriado(pFecha)+1);
  
  return vMontoPagar;
end;

create or replace procedure pPlanilla(pFechaInicial date, pFechaFinal date)
IS
  cursor cEmpleados is
    select * from empleado;
  vFecha date;
  vMontopagar number;
begin
  delete from planilla
    where fecha between pFechaInicial and pFechaFinal;
  for i IN cEmpleados LOOP
    vFecha:=pFechaInicial;
    while vFecha<=pFechaFinal loop
      if i.tipoEmpleado='Por hora' then
        vMontoPagar:=fPagoHoras(i.idEmpleado,vFecha);
      else
        vMontoPagar:=fPagoKilosProducidos(i.idEmpleado,vFecha);
      end if;
      
      if vMontoPagar > 0 then
        insert into planilla
          values(i.idEmpleado,vFecha,vMontoPagar);
      end if;
      vFecha:=vFecha+1;
    end loop;    
  end loop;
end;