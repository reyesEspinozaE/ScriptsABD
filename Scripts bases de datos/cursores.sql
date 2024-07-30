create table empleados(
cod_emp number,
nombre varchar(50),
edad number,
salario number,
cod_dep number);


create table departamentos(
cod_dep number,
descripcion varchar(50));


insert into departamentos values(
1,
'recursos humanos');

insert into departamentos values(
2,
'mercadeo');

insert into departamentos values(
3, 
'finanzas');

select * from departamentos

----------------------------Empleados

insert into empleados values(
1,
'Angela',
28,
735000,
3);

insert into empleados values(
2, 
'Omar',
32,
825000,
2);

insert into empleados values(
3,
'Rebeca',
36,
835000,
1);

insert into empleados values(
4, 
'Francisco',
42,
975000,
3);

insert into empleados values(
5, 
'Leti',
52,
995000,
3);

select * from empleados;

----------------------------------------

--PL SQL
--SQL: SELECT, INSERT, UPDATE, DELETE

--BLOQUES ANONIMOS
--CURSORES
--PROCEDIMIENTOS
--FUNCIONES
--TRIGGERS


declare
    -- variables
begin
    -- logica
end;

-- Ejemplo

declare
vContador number;
begin
    vContador:= 10;
    for i in 6..vContador loop
        insert into empleados values(i, 'prueba', 100, 100000, 1);
    end loop;
    --La i solo funciona dentro de este ciclo for, despues del end loop no me
    --va a reconocer i como variable con algun valor
end;

select * from empleados;
select * from departamentos;

-- Para imprimir en consola o pantalla
set serveroutput on;


-- Imprima los numeros de 1 al 20 con un (FOR)
Declare
    vContador number;
Begin
    vContador:= 20;
    
    for i in 1..vContador loop
        DBMS_OUTPUT.PUT_LINE('valor de i: '||i);
    end loop;
END;

-- Imprima los numeros de 1 al 20 con un (WHILE)
Declare
    vContador number;
Begin 
    vContador:= 1;
    while vContador < 21 loop
        DBMS_OUTPUT.PUT_LINE('valor de i: '||vContador);
        vContador:= vContador +1;
    end loop;
End;

-- Imprima los numeros pares de 1 al 20 con un (FOR)
Declare
    vContador number;
Begin
    vContador:=20;
    for i in 1..vContador loop
        if mod(i,2) =0 then 
            DBMS_OUTPUT.PUT_LINE('Numero par: '||i);
        end if;
    end loop;
End;
-- Imprima los numeros pares de 1 al 20 con un (FOR), pero sin funcion
Declare
    vContador number;
    vP number;
Begin
    vContador:=20;
    for i in 1..vContador loop
    vP:=i;
         if vp < vContador then 
            vP:= i*2;
            DBMS_OUTPUT.PUT_LINE('Numero par: '||vP);
         end if;
    end loop;
End;

-----------------------------------------------


Declare
    vVariable1 number:=10;
    vVariable2 number:=20;
Begin
    DBMS_OUTPUT.PUT_LINE('Variable 1: '||vVariable1);
    DBMS_OUTPUT.PUT_LINE('Variable 2: '||vVariable2);
    
    -----------Intercambiar valores, sin usar tercera variable-----------------
    if vVariable1 > vVariable2 then
        for i in vVariable1 loop
            vVariable2 := vVariable1;
        end loop;
        else
    end if;
    
    DBMS_OUTPUT.PUT_LINE('Variable 1: '||vVariable1);
    DBMS_OUTPUT.PUT_LINE('Variable 2: '||vVariable2);
End;

--Alternativa a solucion

--vVariable1:=vVariable1+vVariable2;
--vVariable2:=vVariable1-vVariable2;
--vVariable1:=vVariable1-vVariable2;





------------------------------------------------------------------------------------

-- Cursores

declare 
    vTotalSalarios number;
    cursor cEmpleados is 
        select * from empleados;
begin
    vTotalSalarios:=0;
    for i in cEmpleados loop
        vTotalSalarios:= vTotalSalarios + i.salario;
    end loop;
    
    DBMS_OUTPUT.PUT_LINE('Total: '||vTotalSalarios);
end;


----------  Parametros en cursores

declare 
    vTotalSalarios number;
    cursor cEmpleados(pDep number) is 
        select * from empleados 
        where cod_Dep= pDep;
begin
    vTotalSalarios:=0;
    for i in cEmpleados(1) loop
        vTotalSalarios:= vTotalSalarios + i.salario;
    end loop;
    
    DBMS_OUTPUT.PUT_LINE('Total: '||vTotalSalarios);
end;


------------------------------------------------------------------------
--Departamento 1 - recursos humanos
--Empleado: Angela
--Empleado: Omar
--Empleado: Rebeca
--...
--Total empleados: ???
--Total salarios: ???
------------------------------------------------------------------------
-----------Imprimiendo solo nombres
declare 
    vTotalSalarios number;
    vTotalEmpleados number;
    cursor cDepartamentos is
        select * from departamentos;
        
    cursor cEmpleados(pDep number) is 
        select * from empleados 
        where cod_Dep= pDep;
begin
    vTotalSalarios:=0;
    vTotalEmpleados:=0;
    for j in cDepartamentos loop
        DBMS_OUTPUT.PUT_LINE('Departamento: '||j.descripcion);
        for i in cEmpleados(j.cod_dep) loop
            DBMS_OUTPUT.PUT_LINE('Nombre empleado: '||i.nombre);
        end loop;
    end loop;
end;
------------------Imprimiendo salarios 
declare 
    vTotalSalarios number;
    vTotalEmpleados number;
    cursor cDepartamentos is
        select * from departamentos;
        
    cursor cEmpleados(pDep number) is 
        select * from empleados 
        where cod_Dep= pDep;
begin
    for j in cDepartamentos loop
    vTotalSalarios:=0;
    vTotalEmpleados:=0;
        DBMS_OUTPUT.PUT_LINE('Departamento: '||j.descripcion);
        for i in cEmpleados(j.cod_dep) loop
            DBMS_OUTPUT.PUT_LINE('Nombre empleado: '||i.nombre);
            vTotalSalarios:= vTotalSalarios + i.salario;
            vTotalEmpleados:= vTotalEmpleados+1;
        end loop;
        DBMS_OUTPUT.PUT_LINE('Total Empleados: '||vTotalEmpleados);
        DBMS_OUTPUT.PUT_LINE('Total Salarios: '||vTotalSalarios);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    end loop;
end;