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
    vCaracA varchar(1):='';
    vCaracC varchar(1):='';
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
                select caracter into vCaracA from auxAper where contador = vContador; --Las tablas quedan en null, por lo que no puedo ejecutrar este select
                select caracter into vCaracC from auxCier where contador = vContadorC;--Lo mismo que con el select anterior
            end if;
-------------------------------------------------------------------------------------
                if vCarA = '{' then --  Por lo tanto, esata seccion no tiene ninguna funcionalidad 
                    if vCaracC = '}' then-- comprobada hasta el momento
                        delete from auxAper where contador = vContador;
                        delete from auxCier where contador = vContadorC;
                    end if;
                else
                    if vCaracA = '[' then
                        if vCaracC = ']' then
                            delete from auxAper where contador = vContador;
                            delete from auxCier where contador = vContadorC;
                        end if;
                    else
                        if vCaracA = '(' then
                            if vCaracC = ')' then
                                delete from auxAper where contador = vContador;
                                delete from auxCier where contador = vContadorC;
                            end if;
                        end if;
                    end if;
                end if;
-------------------------------------------------------------------------------------
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
