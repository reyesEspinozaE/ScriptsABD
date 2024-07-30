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

commit;

select * from empleado;

create or replace function sumaSalario(pDep number)
return number IS
    vSuma number:=0;
BEGIN
    select sum(salario) into vSuma 
        from empleado where idDepartamento = pDep;
        return vSuma;
END;

select sumaSalario(1) from dual;


select * from departamento;

select idDepartamento, nombre, 
    sumaSalario(idDepartamento)
        from departamento;

create table reservaciones
(idReservacion int,
 idHabitacion int, 
 fechaINicio date, 
 fechafin date)

insert into reservaciones 
    values (1, 5, '10/ene/2020','15/ene/2020');
insert into reservaciones 
    values (2, 5, '20/ene/2020','22/ene/2020');
    

--Realizar una funcion
--parametros: habitacion, fechaEntrada, fechaSalida
--retorna los dias de choque


create or replace function dias(pFecha number, pHabitacion number)
return number is
    vDia number:= pFecha;
BEGIN
    select fechaInicio, fechaFin, idHabitacion from reservaciones where idHabitacion = pHabitacion;
    
    while fechaInicio < fechaFin loop
        if vDia = fechaInicio then
            
        end if;
        fechaInicio +1;
    end loop;
    return
END;