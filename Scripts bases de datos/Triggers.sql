-- Trigger de validacion

select * from empleados;

create or replace trigger trigger1
before insert on empleados
for each row 
declare 
    -- variables
begin
    if :new.salario > 5000 then
        raise_application_error(-20505, 'error de salario');
    end if;
end;

insert into empleados values(15, 'prueba-15', 32, 5500, 1);
insert into empleados values(15, 'prueba-15', 32, 500, 1);

-- Se comprueba que el salario sea menor que 5000, si esto se cumple, entonces el trigger
-- se va a activar y nos ba a indicar el error que describimos en la linea 10 por ej.

-- Trigger de cambio de datos

drop trigger trigger1;

create or replace trigger trigger2
before insert on empleados
for each row
begin
    :new.salario:= 5000;
end;

insert into empleados values(16, 'prueba-16', 30, 0, 1);

drop trigger trigger2;

---- Con la misma tabla de empleados 
---- programar un trigger 
---- que simule el autoincremental
---- para el idEmpleado

--insert into empleado (nombre, salario, sexo, iddepartamento)
--values ('prueba-20', 155, 'm', 1);

insert into empleados (nombre, edad, salario, cod_dep)
values('prueba-2', 29, 2300, 1);

select * from empleados;
rollback;

create or replace trigger trigger3
before insert on empleados
for each row
declare
    vCuantos number:= 0;
begin
    select count(*) into vCuantos from empleados;
    :new.cod_emp:= vCuantos+1;
end;

drop trigger trigger3;

-- crear un trigger 
-- que no permita
-- que un empleado gane mas que su jefe
create table pruebaEmpleado
(idEmpleado number,
 nombre varchar(30),
 salario number,
 idJefe number,
primary key(idEmpleado));

insert into pruebaEmpleado
values(1, 'Juan', 500, null);

insert into pruebaEmpleado
values(2, 'Carlos', 400, 1);

commit;

select * from pruebaEmpleado;


create or replace trigger trigger4
before insert on pruebaEmpleado
for each row
declare 
    vSalarioJefe number:= 0;
begin
    select salario into vSalarioJefe from pruebaEmpleado where idEmpleado =1;
    if vSalarioJefe < :new.salario then
        raise_application_error(-20505, 'error de salario');
    end if;
end;

drop trigger trigger4;
--------------Manera correcta, no puedo poner un # especifico, ya que no todos 
--------------los empleados tienen el mismo jefe
create or replace trigger trigger4
before insert on pruebaEmpleado
for each row
declare 
    vSalarioJefe number:= 0;
begin
    -- :new.idEmpleado -> el empleado se esta insertando
    select salario into vSalarioJefe from pruebaEmpleado where idEmpleado =:new.idJefe;-- <-- :new.idJefe es el jefe del nuevo empleado
    if vSalarioJefe < :new.salario then
        raise_application_error(-20505, 'Error de salario, salario mayor al del jefe');
    end if;
end;

insert into pruebaEmpleado 
values(3, 'A', 600, 1);


-- Desarrollar un trigger que controle lo siguiente del proceso de matricula:
-- No puede matricular mas creditos del maximo del estudiante por matricula
-- No puede matricular un curso que ya haya matriculado
-- Debe actualizar los creditos matriculados de la matricula
-- Denbe actualizar el total de creditos matriculados del estudiante

create or replace trigger trigger5
before insert on matriculaDetalle
for each row
begin
    select 
end;

