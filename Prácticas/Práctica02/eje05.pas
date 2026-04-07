program eje05;

const
  fin = '9999';
  dimF = 5;

type
  REG_maestro = record
    codUsuario: string[4];
    fecha: string[10];
    tiempoTotal: integer;
  end;

  REG_detalle = record
    codUsuario: string[4];
    fecha: string[10];
    tiempoSesion: integer;
  end;

  archovo_maestro = file of REG_maestro;
  archivo_detalle = file of REG_detalle;

  vector_archivo_detalle = array [1..dimF] of archivo_detalle;
  vector_registro_detalle = array [1..dimF] of REG_detalle;


procedure leer( var archivo: archivo_detalle; var dato: REG_detalle );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.codUsuario:= fin;
end;

procedure minimo( var aDetalle: vector_archivo_detalle; var rDetalle: vector_registro_detalle; var min: REG_detalle);
var
  i, pos: integer;
begin
  min.codUsuario:= fin;
  pos:= -1;

  for i:=1 to dimF do begin
    if ( rDetalle[i].codUsuario < min.codUsuario ) or 
      (( rDetalle[i].codUsuario < min.codUsuario ) and ( rDetalle[i].fecha < min.fecha )) then begin
      min:= rDetalle[i];
      pos:= i;
    end;
  end;

  if ( pos <> -1 ) then
    leer( aDetalle[pos], rDetalle[pos] );

end;


var
  maestro: archovo_maestro;
  rm: REG_maestro;
  aDetalle: vector_archivo_detalle;
  rDetalle: vector_registro_detalle;
  min: REG_detalle;
  i: integer;
begin
  Assign(maestro, '/var/log/maestro.dat');
  Rewrite( maestro );

  for i:=1 to dimF do begin
    Assign( aDetalle[i], 'detalle' + i );
    Reset( aDetalle[i] );
    leer( aDetalle[i], rDetalle[i] );
  end;

  minino( aDetalle, rDetalle, min );

  while ( min.codUsuario <> fin ) do begin
    rm.codUsuario:= min.codUsuario;
    rm.tiempoTotal:= 0;
    rm.fecha:= min.fecha;

    while (min.codUsuario = rm.codUsuario ) and ( min.fecha = rm.fecha ) do begin
      rm.tiempoTotal:= rm.tiempoTotal + min.tiempoSesion;
      minimo( vDetalle, rDetalle, min );
    end;

    write( maestro, rm );
  end;

  Close( maestro );
  for i:=1 to dimF do
    Close( aDetalle[i] );
end.