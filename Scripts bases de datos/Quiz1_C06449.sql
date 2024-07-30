create table orden(
idOrden number,
fechaOrden date,
montoTotal number,-- Este con impuestos agregados
idCliente number,
primary key(idOrden));

create table ordenDetalle(
idOrdenDetalle number,
idProducto number,
idOrden number,
precioProducto number,
cantidadComprada number,
subtotal number,
primary key(idProducto, idOrdenDetalle));

create table resumen(
totalMes number,
totalCliente number,
idCliente number,
anio date,
hora date);

tabla Temp 

--Annio --Mes
2018    03
--      04
--      06
declare
    vMes date;
    vAnnio number:= 2018;
    vAnnioOrden number;
    vTotal number;
    cursor cOrden is select * from orden;
    cursor cOrdenDetalle(pOrden number) is select * from ordenDetalle where idOrden = pOrden;
begin
    delete from resumen;
        for i in cOrden loop
            vMes:= to_number(to_char(i.fechaOrden, 'MM')) extract(Month from orden);
            vAnnioOrden:= to_number(i.fechaOrden, 'YYYY')) extract(Year from orden);
            if vAnnioOrden = vAnnio then
                for i ..in 12 loop
                    insert into temp values(....);
                    
                end loop;
            end if;
        end loop;
end;

declare
vAnnio date;
begin
    dbms_output.put_line(sysdate);
end;


DECLARE
  -- Definir una tabla temporal para almacenar los datos de resumen
  TYPE resumen_tab IS TABLE OF VARCHAR2(100)
    INDEX BY PLS_INTEGER;
  resumen resumen_tab;

BEGIN
  -- Escribir una consulta para recuperar los datos que necesitamos de las tablas Orden y ordenDetalle
  FOR r IN (
    SELECT o.idCliente,
           TO_CHAR(o.fechaOrden, 'YYYY-MM') AS mes,
           SUM(od.subtotal) AS total
    FROM Orden o
    INNER JOIN ordenDetalle od ON o.idOrden = od.idOrden
    WHERE TO_CHAR(o.fechaOrden, 'YYYY') = '2018'
    GROUP BY o.idCliente, TO_CHAR(o.fechaOrden, 'YYYY-MM')
    ORDER BY o.idCliente, TO_CHAR(o.fechaOrden, 'YYYY-MM')
  ) LOOP
    -- Iterar sobre los resultados de la consulta y actualizar la tabla temporal con los totales por cliente y mes
    resumen(r.idCliente || '_' || r.mes) := r.idCliente || ' ' || r.mes || ' ' || r.total;
  END LOOP;

  -- Finalmente, recuperar los datos de la tabla temporal y mostrarlos en la pantalla
  FOR i IN resumen.first .. resumen.last LOOP
    DBMS_OUTPUT.PUT_LINE(resumen(i));
  END LOOP;
END;







--Probar esto luego
Declare
    vFecha date; 
begin
    vFecha:= to_char(sysdate,'YYYY') from dual;
    --select into vFecha extract(year from sysdate) from dual; 
    if vFecha>= '01/01/2018' and vFecha<= '31/12/2018' then
        dbms_output.put_line('Funca');
        else 
        dbms_output.put_line('No funca');
    end if;
end;
