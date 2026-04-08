program eje08;
const
  dimF = 16;
  fin = 9999;

type
  REG_maestro = record
    codProvincia, cantHabitantes: integer;
    nomProvincia: string[20];
    cantTotalKg: real;
  end;

  REG_detalle = record
    codProvincia: integer;
    cantConsumo: real;
  end;

  archivo_maestro = file of REG_maestro;
  archivo_detalle = file of REG_detalle;

  vector_archivo_detalle = array [1..dimF] of archivo_detalle;
  vector_registro_detalle = array [1..dimF] of REG_detalle;


// Leer archivo
procedure Leer( var archivo: archivo_detalle; var dato: REG_detalle );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.codProvincia:= fin;
end;

// Buscar la provincia mas chica
procedure minimo ( var aDetalle: vector_archivo_detalle; var rDetalle: vector_registro_detalle; var min: REG_detalle );
var
  i, pos: integer;
begin
  min.codProvincia:= fin;
  pos:= -1;

  for i:=1 to dimF do begin
    if ( rDetalle[i].codProvincia < min.codProvincia ) then begin
      min:= rDetalle[i];
      pos:= i;
    end;
  end;

  if ( pos <> -1 ) then
    Read( aDetalle[pos], rDetalle[pos] );
end;

// Procesar los archivos
procedure procesarArchivos ( var maestro: archivo_maestro; var aDetalle: vector_archivo_detalle );
var
  i, codProvincia: integer;
  rm: REG_maestro;
  rDetalle: vector_registro_detalle;
  min: REG_detalle;
  consumo: real;
begin
  // Lectura archivo MAESTRO
  Read( maestro, rm );
  // Lectura de cada archivo dentro del vector
  for i:=1 to dimF do
    Leer( aDetalle[i], rDetalle[i] );
  
  // Buscar el cod de provincia mas chico
  minimo( aDetalle, rDetalle, min );

  while ( min.codProvincia <> fin ) do begin
    
    // Corte control
    codProvincia:= min.codProvincia;
    consumo:= 0;

    while ( min.codProvincia = codProvincia ) do begin
      consumo:= consumo + min.cantConsumo;
      minimo( aDetalle, rDetalle, min );
    end;

    // Buscar en archivo MAESTRO
    while ( rm.codProvincia <> codProvincia ) do
      Read( maestro, rm );

    rm.cantTotalKg:= rm.cantTotalKg + consumo;

    Seek( maestro, FilePos(maestro) - 1 );
    Write( maestro, rm );

    // Actualizo el registro rm
    if ( not Eof(maestro) ) then
      Read( maestro, rm );

  end;
end;

// Informar archivo MAESTRO
procedure informarMaestro ( var maestro: archivo_maestro );
var
  rm: REG_maestro;

begin
  while ( not Eof(maestro) ) do begin
      Read(maestro, rm);

    if (rm.cantTotalKg > 10000) then begin
      WriteLn('(', rm.codProvincia, ') ', rm.nomProvincia);
      WriteLn('Promedio: ', (rm.cantTotalKg / rm.cantHabitantes):0:2);
    end;
  end;
end;

 
// Programa principal
var
  maestro: archivo_maestro;
  aDetalle: vector_archivo_detalle;
  i: integer;
begin
  Assign( maestro, 'maestro' );
  Reset( maestro );

  for i:=1 to dimF do begin
    Assign( aDetalle[i], 'detalle' + IntToStr(i) );
    Reset( aDetalle[i] );
  end;

  procesarArchivos( maestro, aDetalle );
  
  // Reiniciar archivo maestro
  Reset( maestro );
  informarMaestro( maestro );

  Close( maestro );
  for i:=1 to dimF do
    Close( aDetalle[i] );

end.