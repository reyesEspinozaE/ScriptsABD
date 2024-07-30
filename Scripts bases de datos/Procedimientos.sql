  --hacer un  proc
--que genere 10 empleados nuevos
--para un dep que entrara como parametro
--hay que programar alguna funcion

select * from departamentos;

--Primeramente desarrollar las funciones que permiten que el proc no sea tan extenso

--Funcion verificaDep(idDep)
--retorna 1/0 1= si existe

create or replace function verificaDep(pIdDep number) 
return number is
    vExiste number:=0;
BEGIN
    select count(*) into vExiste from departamentos where cod_dep = pIdDep;
    
    return vExiste;
END;

select verificaDep(1) from dual;

-----------------------------------
select * from empleado;

create or replace function consecutivo
return int is
    vSiguiente int:=0;
BEGIN
    select count(*)+1 into vSiguiente from empleado;
    
    return vSiguiente;
END;

select consecutivo from dual;

------------------------------------
set serveroutput on;
select * from empleado;

create or replace procedure generaEmpleados(pIdDep number) is
BEGIN
    if verificaDep(pIdDep) <> 0 then
        DBMS_OUTPUT.PUT_LINE('No existe un departamento con ese ID');
    else
        for i in 1..10 loop
            insert into empleado values(consecutivo, 'Everth', 998000, pIdDep);
        end loop;
    end if;
END;

execute generaEmpleados(4);





drop table empleado;

create table empleado
(idEmpleado number,
nombre varchar(20),
salario number,
idDepartamento number);

insert into empleado values(1,'juan',1500,1);
insert into empleado values(2,'luis',2500,1);
insert into empleado values(3,'maria',1500,2);
insert into empleado values(4,'ana',3500,3);