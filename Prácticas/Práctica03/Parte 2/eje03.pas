program eje03;

//uses sysutils;

const
  dimF = 5;

type
  reg_maestro = record
    cod_usuario, tiempo_total_de_sesiones_abiertas: integer;
    fecha: String[10];
  end;
  reg_detalle = record
    cod_usuario, tiempo_sesion: integer;
    fecha: String[10];
  end;

  archivo_maestro = File of reg_maestro;
  archivo_detalle = File of reg_detalle;

  vector_archivo_detalle = array [1..dimF] of archivo_detalle;
  vector_registro_detalle = array [1..dimF] of reg_detalle;


// Leer archivo MAESTRO
procedure leerMaestro( var a: archivo_maestro; var dato: reg_maestro );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.cod_usuario:= -1;
end;

// Leer archivo DETALLE
procedure leerDetalle( var a: archivo_detalle; var dato: reg_detalle );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.cod_usuario:= -1;
end;

// Crear archivo maestro
procedure crearMaestro( vDetalle: vector_archivo_detalle );
var
  maestro: archivo_maestro;
  rm: reg_maestro;
  rd: reg_detalle;
  i: integer;
begin
  for i:=1 to dimF do begin
    Assign( vDetalle[i], 'detalle_' + IntToStr(i) );
    Reset( vDetalle[i] );
  end;

  Assign( maestro, 'maestro' );
  Rewrite( maestro );
  

  // Leer archivos detalle
  for i:=1 to dimF do begin
    // Por cada iteración del for, vamos a realizar una lectura completa de cada log
    leerDetalle( vDetalle[i], rd );
    while ( rd.cod_usuario <> -1) do begin
      // Por cada iteración del while, volvemos al inicio del maestro
      Seek( maestro, 0 );

      // Busqueda del usuario
      leerMaestro( maestro, rm );
      while ( rm.cod_usuario <> -1 ) and ( rm.cod_usuario <> rd.cod_usuario ) do
        leerMaestro( maestro , rm );

      // Si devuelve distino de -1 el usuario existe
      if ( rm.cod_usuario <> -1 ) then begin
        // Buscamos si el usuario inicio sesión en esta fecha
        leerMaestro( maestro, rm );
        while ( rm.cod_usuario = rd.cod_usuario ) and ( rm.fecha <> rd.fecha ) do
          leerMaestro( maestro, rm );
      end;
      
      // Si el mismo usuraio se volvio a conectar en la misma fecha, se actualiza la cantidad de horas
      if ( rm.cod_usuario = rd.cod_usuario ) and ( rm.fecha = rd.fecha ) then begin
        rm.tiempo_total_de_sesiones_abiertas:= rm.tiempo_total_de_sesiones_abiertas + rd.tiempo_sesion;
        Seek( maestro, FilePos(maestro) - 1 );
      end;

      // Si el usuario es nuevo o si inició sesión en una fecha nueva, se guarda al final
      if ( rm.cod_usuario = -1 ) or ( rm.cod_usuario <> rd.cod_usuario ) then begin
        // Si no el usuario no tiene datos guardados en esta fecha, lo agregamos al final
        Seek( maestro, FileSize(maestro) );
        rm.cod_usuario:= rd.cod_usuario;
        rm.fecha:= rd.fecha;
        rm.tiempo_total_de_sesiones_abiertas:= rd.tiempo_sesion;
      end;

      // Por último guardamos/actualizamos el registro
      Write( maestro, rm );
    end;
  end;
end;


// Programa principal
begin
  // Sin programa principal
end.