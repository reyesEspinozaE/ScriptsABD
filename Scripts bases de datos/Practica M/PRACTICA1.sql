
select count(*) from dba_tables;
select * from dba_tablespaces;
select * from dba_data_files;

--1. Nombre de los tablespaces creados en la BD

select tablespace_name from dba_tablespaces;

--2. Tamaño en megas de la BD

select sum(bytes)/1024/1024 "Tamaño en Megas"
from dba_data_files;

--3. Nombre los datafiles con su respectivo tamaño en megas.

select FILE_NAME, sum(bytes)/1024/1024 "TAMAÑO" from dba_data_files
GROUP BY FILE_NAME;

--4. Cantidad de datafiles con que se encentra creado cada tablespace

select tablespace_name, count(file_name)from dba_data_files
group by tablespace_name;

--5. Parámetros de storage por defecto con los que fueron creados los tablespaces

SELECT TABLESPACE_NAME, INITIAL_EXTENT, NEXT_EXTENT, MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE FROM dba_tablespaces;

--6. Cantidad de usuarios creados en la BD (no contar al usuario SYSTEM ni al usuario
--SYS)

SELECT COUNT(USERNAME) "Cantidad de usuarios" FROM DBA_USERS
where username != 'SYS' and username!= 'SYSTEM';

select * from dba_users;

--7. Cantidad de tablas por usuario
SELECT * FROM DBA_TABLES;

SELECT OWNER, COUNT(TABLE_NAME) FROM DBA_TABLES GROUP BY OWNER;

--8. Cantidad de tablas en cada uno de los tablespaces

SELECT * FROM DBA_TABLES;

SELECT TABLESPACE_NAME, COUNT(TABLE_NAME) FROM DBA_TABLES GROUP BY TABLESPACE_NAME;

--9. Lista de usuarios que tienen como default_tablespace al tablespace llamado
--“SYSTEM”

SELECT USERNAME FROM dba_users WHERE DEFAULT_TABLESPACE = 'SYSTEM';

--10. Lista de los índices que poseen las tablas del usuario llamado “SCOTT”

SELECT OWNER, COUNT(TABLE_NAME) FROM DBA_TABLES
WHERE OWNER ='SCOTT'
GROUP BY OWNER ;

--11. Lista de usuarios con el nombre del tablespace por defecto y el tablespace temporal.

SELECT USERNAME, DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE FROM DBA_USERS;

--12. Lista de tablas y su propietario, que fueron creadas en un tablespace diferente al
--situado como tablespace por defecto del usuario propietario de la tabla.

SELECT * FROM DBA_USERS;
SELECT * FROM DBA_TABLES;

SELECT T.TABLE_NAME, T.OWNER 
FROM DBA_TABLES t, DBA_USERS U
WHERE t.tablespace_name != u.default_tablespace
AND T.OWNER = U.USERNAME;


--13. Nombre de los índices y su propietario, que fueron creados en el mismo tablespace de
--su respectiva tabla origen.




--14. Cantidad en megas libres en cada uno de los tablespaces.
--15. Tablespaces que poseen menos de 10 megas de espacio libre.
--16. Ver que tablespaces se encuentran creados y no poseen ninguna tabla ni índice creada
--en él.
--17. Ver cuales segmentos y de qué tipo, están a 10 o menos extents de llegar al tope
--máximo de extents declarados para el segmento.
--18. Listar los segmentos de mas de 50 megas (mostrar el tablespace, tipo y propietario del
--segmento)
--19. Listar los usuarios que no son dueños de ningún segmento.
--20. Listar los índices que poseen más de 10 extents