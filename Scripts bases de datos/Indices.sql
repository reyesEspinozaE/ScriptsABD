--Conectado con el usuario system

drop table pruebaind;

create table pruebaIND
(campo1 number,
campo2 char(400),
campo3 char(400),
campo4 char(400),
campo5 char(400),
campo6 char(400),
campo7 char(400),
campo8 char(400),
campo9 char(400),
campo10 char(400));

begin
  for i in 1..200000 loop
    insert into pruebaIND values(i,'a','a','a','a','a','a','a','a','a');
  end loop;
end;

select * from dba_tablespaces;
select * from dba_data_files;
select * from dba_Data_files where tablespace_name ='Prueba';

--alter database datafile 'C:\ORACLE\ORADATA\XE\PRUEBA01.DBF' resize 100M;
ALTER TABLESPACE PRUEBA ADD DATAFILE 'C:\ORACLE\ORADATA\XE\PRUEBA01.DBF' size 100M autoextended on 
maxsize 300M;


select segment_name, segment_type, bytes/1024/1024
from dba_segments 
where segments_name='pruebaIND';

select * from pruebaIND
where campo1=1;

create index indice1 on PruebaIND(campo1);

drop index indice1;