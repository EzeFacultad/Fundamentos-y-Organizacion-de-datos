program eje06;
const
  dimF = 10;
  fin = 9999;

type
  REG_maestro = record
    nomLocalidad: string[20];
    nomCepa: string[15];
    codLocalidad, codCepa, cantCasosAct, cantCasosNue, cantCasosRecu, cantCasosFalle: integer;
  end;

  REG_detalle = record
    codLocalidad, codCepa, cantCasosAct, cantCasosNue, cantCasosRecu, cantCasosFalle: integer;
  end;

  archivo_maestro = file of REG_maestro;
  archivo_detalle = file of REG_detalle;

  vector_archivo_detalle = array [1..dimF] of archivo_detalle;
  vector_registro_detalle = array [1..dimF] of REG_detalle;


// Leer dato del archivo
procedure Leer( var archivo: archivo_detalle; var dato: REG_detalle );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.codLocalidad:= fin;
end;

// Obtener el minimo
procedure minimo( var aDetalle: vector_archivo_detalle; var rDetalle: vector_registro_detalle; var min: REG_detalle );
var
  i, pos: integer;
begin
  min.codLocalidad:= fin;
  min.codCepa:= fin;
  pos:= -1;

  for i:=1 to dimF do begin
    if ( rDetalle[i].codLocalidad < min.codLocalidad ) or 
    (( rDetalle[i].codLocalidad = min.codLocalidad ) and ( rDetalle[i].codCepa < min.codCepa )) then begin
      min:= rDetalle[i];
      pos:= i;
    end;
  end;

  if ( pos <> -1 ) then
    Leer( aDetalle[pos], rDetalle[pos] );
end;

// Actualizar archivo maestro
procedure actualizar( var maestro: archivo_maestro; var aDetalle: vector_archivo_detalle; var rDetalle: vector_registro_detalle );
var
  rm: REG_maestro;
  min: REG_detalle;
  i, codLocalidad, codCepa, cantCasosAct, cantCasosNue, cantCasosRecu, cantCasosFalle, cantLocalidades: integer;
begin
  cantLocalidades:= 0;

  // Leer archivo maestro
  Read( maestro, rm );

  // Cargamos los primeros datos en cada registro correspondiente
  for i:=1 to dimF do 
    Leer( aDetalle[i], rDetalle[i] );
  
  // Obtenemos el minimo
  minimo( aDetalle, rDetalle, min );

  while ( min.codLocalidad <> fin ) do begin

    // Corte control Localidad
    codLocalidad:= min.codLocalidad;

    while ( min.codLocalidad = codLocalidad ) do begin
      
      // Corte control Cepa
      codCepa:= min.codCepa;
      cantCasosAct:= 0;
      cantCasosNue:= 0;
      cantCasosRecu:= 0;
      cantCasosFalle:= 0;

      while ( min.codLocalidad = codLocalidad ) and ( min.codCepa = codCepa ) do begin
        cantCasosAct:= cantCasosAct + min.cantCasosAct;
        cantCasosNue:= cantCasosNue + min.cantCasosNue;
        cantCasosRecu:= cantCasosRecu + min.cantCasosRecu;
        cantCasosFalle:= cantCasosFalle + min.cantCasosFalle;

        minimo( aDetalle, rDetalle, min );
      end;

      // Buscamos en el archivo maestro la localidad
      while ( not Eof(maestro) ) and 
      (( rm.codLocalidad < codLocalidad ) or 
      (( rm.codLocalidad = codLocalidad ) and ( rm.codCepa < codCepa ))) do      
        Read( maestro, rm );

      // Retrocedemos una posición
      Seek( maestro, FilePos(maestro) - 1 );
      
      // Actualizamos datos en el registro rm
      rm.cantCasosFalle:= rm.cantCasosFalle + cantCasosFalle;
      rm.cantCasosRecu:= rm.cantCasosRecu + cantCasosRecu;
      rm.cantCasosAct:= cantCasosAct;
      rm.cantCasosNue:= cantCasosNue;

      // Guardamos en el archivo
      write( maestro, rm );
    end;

  end;
end;

procedure contarLocalidades (var maestro: archivo_maestro );
var
  cantLocalidades, cantActivos: integer;
  localidad: string;
  rm: REG_maestro;
begin
  cantLocalidades:= 0;

  while ( not Eof(maestro) ) do begin
    Read( maestro, rm );

    localidad:= rm.nomLocalidad;
    cantActivos:= 0;
    while ( not Eof(maestro) ) and ( rm.nomLocalidad = localidad ) do begin
      cantActivos:= cantActivos + rm.cantCasosAct;
      Read( maestro, rm );
    end;

    // Contar el último rm
    if ( rm.nomLocalidad = localidad ) then
      cantActivos:= cantActivos + rm.cantCasosAct
    else
      Seek( maestro, FilePos(maestro) - 1 );


    if ( cantActivos > 50 ) then
      cantLocalidades:= cantLocalidades + 1;
  end;

  writeln( 'La cantidad de localidades con mas de 50 recuperados es: ', cantLocalidades );
end;

var
  maestro: archivo_maestro;
  aDetalle: vector_archivo_detalle;
  rDetalle: vector_registro_detalle;
  i: integer;
begin
  Assign( maestro, 'maestro' );
  Reset( maestro );

  for i:=1 to dimF do begin
    Assign( aDetalle[i], 'detalle' + InToStr(i) );
    Reset( aDetalle[i] );
  end;

  contarLocalidades( maestro );

  Reset( maestro );
  actualizar( maestro, aDetalle, rDetalle );

  Close( maestro );
  for i:=1 to dimF do
    Close( aDetalle[i] );
end.