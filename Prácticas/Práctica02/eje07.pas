program eje07;
const
  fin = 9999;

type
  REG_maestro = record
    codAlumno, cantCursadasAprob, cantFinalesAprob: integer;
    apellido, nombre: string[20];
  end;

  REG_cursada = record
    codAlumno, codMateria, anioCursada: integer;
    aprobado: boolean;
  end;

  REG_final = record
    codAlumno, codMateria: integer;
    fecha: string[10];
    nota: real;
  end;

  archivo_maestro = file of REG_maestro;
  archivo_cursada = file of REG_cursada;
  archivo_final = file of REG_final;


// Lectura del archivo CURSADA
procedure LeerCursada( var archivo: archivo_cursada; var dato: REG_cursada );
begin
  if ( not Eof (archivo) ) then
    Read( archivo, dato )
  else
    dato.codAlumno:= fin;
end;

// Lectura del archivo FINALES
procedure LeerFinal( var archivo: archivo_final; var dato: REG_final );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.codAlumno:= fin;
end;

// Procesar los archivos
procedure procesarArchivos( var maestro: archivo_maestro; var cursadas: archivo_cursada; var finales: archivo_final );
var
  rm: REG_maestro;
  rc: REG_cursada;
  rf: REG_final;
  codMin, codMateria, cantCursadas, cantFinales: integer;
  aprobado, aprobadoFinal: boolean;
begin
  Read( maestro, rm );
  LeerCursada( cursadas, rc );
  LeerFinal( finales, rf );

  while ( rc.codAlumno <> fin ) or ( rf.codAlumno <> fin) do begin
    
    // Obtener el codigo mas chico
    if ( rc.codAlumno < rf.codAlumno ) then
      codMin:= rc.codAlumno
    else
      codMin:= rf.codAlumno;

    cantCursadas:= 0;
    cantFinales:= 0;

    // ======= Procesar CURSADAS =======
    // Corte control ALUMNO
    while ( rc.codAlumno = codMin ) do begin

      codMateria:= rc.codMateria;
      aprobado:= false;

      // Corte control MATERIA
      while ( rc.codAlumno = codMin ) and ( rc.codMateria = codMateria ) do begin
        aprobado:= rc.aprobado;
        LeerCursada( cursadas, rc );
      end;

      if ( aprobado ) then
        cantCursadas:= cantCursadas + 1;
    end;

    // ======= Procesar FINALES =======
    // Corte control ALUMNO
    while ( rf.codAlumno = codMin ) do begin
      
      codMateria:= rf.codMateria;
      aprobadoFinal:= false;

      // Corte control MATERIA
      while ( rf.codAlumno = codMin ) and ( rf.codMateria = codMateria ) do begin
        aprobadoFinal:= rf.nota >= 4;
        LeerFinal( finales, rf );
      end;

      if ( aprobadoFinal ) then
        cantFinales:= cantFinales + 1;
    end;

    // Buscar alumno en archivo MAESTRO
    while ( rm.codAlumno <> codMin) do
      Read( maestro, rm );

    rm.cantCursadasAprob:= rm.cantCursadasAprob + cantCursadas;
    rm.cantFinalesAprob:= rm.cantFinalesAprob + cantFinales;

    Seek( maestro, FilePos(maestro) - 1 );
    Write( maestro, rm );
  end;
end;

// Programa principal
var
  maestro: archivo_maestro;
  cursadas: archivo_cursada;
  finales: archivo_final;

begin
  Assign( maestro, 'maestro' );
  Assign( cursadas, 'cursadas' );
  Assign( finales, 'finales' );

  Reset( maestro );
  Reset( cursadas );
  Reset( finales );

  procesarArchivos( maestro, cursadas, finales );

  Close( maestro );
  Close( cursadas );
  Close( finales );

end.