create table curso(
idCurso number,
nombre varchar(45),
notaMinima number,
creditos number);

create table cursoRubro(
idPeriodo number,
idCurso number,
idRubro number,
nombre varchar(45),
porcentaje number);

create table estudiante(
idEstudiante number,
nombre varchar(45),
idCarrera number);

create table notas(
idPeriodo number,
idCurso number,
idRubro number,
idEstudiante number,
nota number);

create table matricula(
idPeriodo number,
idEstudiante number,
idCurso number,
notaFinal number,
resultado varchar(45));

create table carrera(
idCarrera number,
nombre varchar(45),
creditos number);

--malla se refiere al plan de estudios
create table malla(
idCarrera number,
idCurso number);

--Con base en el modelo de tablas anterior, programar una función que devuelva si un estudiante aprobó o no un 
--curso. 
create or replace function consultaCursoAprobado(pIdEstudiante number, pIdCurso number)
return varchar is
    vMensaje varchar(20);
    vNotaFinalEst number;
    vNotaMinima number;
    vResultado number;
BEGIN
    select notaFinal, resultado into vNotaFinalEst, vResultado from matricula 
        where idEstudiante= pIdEstudiante and idCurso= pIdCurso;
        
    select notaMinima into vNotaMinima from Curso where idCurso = pIdCurso;
    
    if vNotaFinal >= vNotaMinima then
        vMensaje:= 'El estudiante aprobo el curso';
    end if;
    return vMensaje;
END;

--Con base en el modelo de tablas anterior, programar una función que devuelva el total de créditos ya ganados 
--por un estudiante.

create or replace function totalCreditosGanados(pIdEstudiante number)
return number is
    vTotalCreditos number;
BEGIN
    select sum(c.creditos) into vTotalCreditos from matricula m join curso c
        ON m.idCurso = c.IdCurso where m.idEstudiante = pIdEstudiante 
            and m.resultado = 'Aprobado';
            
    return vTotalCreditos;
END;


--Con base en el modelo de tablas anterior, programar una función que devuelva si un estudiante ya ganó el total 
--de cursos de su carrera.

create or replace function consultaGraduacion(pIdEstudiante number)
return varchar is
    vIdCarrera number;
    vTotalCursosCarr number;
    vCursosGanados number;
    vMensaje varchar(20);
BEGIN
    select idCarrera into vIdCarrera from estudiante where idEstudiante= pIdEstudiante;
    
    select count(*) into vTotalCursosCarr from malla where idCarrera= vIdCarrera;
    
    select count(*) into vCursosGanados from matricula where idEstudiante= pIdEstudiante
        and resultado = 'Aprobado';
    
    if vCursosGanados >= vTotalCursosCarr then
        vMensaje:= 'El estudiante ya gano todos los cursos de la carrera';
    end if;
    
    return vMensaje;
END;


--Con base en el modelo de tablas anterior, programar una función que devuelva si los créditos totales de una 
--carrera están correctos con los créditos de sus cursos. 

create or replace function consultaCreditosCarrera(pIdCarrera number)
return varchar is
    vCreditosCarrera number;
    vCreditosCursos number;
    vMensaje varchar(45);
BEGIN
    select creditos into vCreditosCarrera from carrera where idCarrera= pIdCarrera;
    
    select sum(c.creditos) into vCreditosCursos from malla m join 
        curso c ON m.idCurso= c.idCurso where m.idCarrera= pIdCarrera;
        
    if vCreditosCarrera = vCreditosCursos then
        vMensaje:= 'Los creditos totales de la carrera son correctos con los creditos de los cursos';
    end if;
    return vMensaje;
END;

--Con base en el modelo de tablas anterior, programar una función que devuelva la cantidad de cursos que le 
--restan a un estudiante para concluir su carrera.

create or replace function consultaCursosRestantes(pIdEstudiante number)
return number is
    vCreditosAprobados number;
    vIdCarrera number;
    vTotalCursosCarr number;
    vCursosRestantes number;
BEGIN
    select sum(c.creditos) into vCreditosAprobados from matricula m join curso c
        ON m.idCurso = c.IdCurso where m.idEstudiante = pIdEstudiante 
            and m.resultado = 'Aprobado';
            
    select idCarrera into vIdCarrera from estudiante where idEstudiante= pIdEstudiante;
    
    select count(*) into vTotalCursosCarr from malla where idCarrera= vIdCarrera;
    
    vCursosRestantes:= vCreditosAprobados - vtotalcursoscarr;
    
    return vCursosRestantes;
END;