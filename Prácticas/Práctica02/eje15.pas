program eje15;
//uses sysutils;
  
const
  dimF = 10;
  fin = 9999;

type
  REG_maestro = record
    codPcia, codLocalidad, viviendasSinLuz, viviendaSinGas, 
    viviendasDeChapa, viviendasSinAgua, viviendasSinSanitarios: integer;
    nomProvincia, nomLocalidad: string[20];
  end;

  REG_detalle = record
    codPcia, codLocalidad: integer;
    viviendasConLuz, viviendasConstruidas, viviendasConAgua,
    viviendasConGas, entregaSanitarios: integer;
  end;

  archivo_maestro = file of REG_maestro;
  archivo_detalle = file of REG_detalle;

  vector_archivo_detalle = array [1..dimF] of archivo_detalle;
  vector_registro_detalle = array [1..dimF] of REG_detalle;


// Leer archivo MAESTRO
procedure leerMaestro ( var archivo: archivo_maestro; var dato: REG_maestro );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.codPcia:= fin;
end;

// Leer archivo DETALLE
procedure leerDetalle( var archivo: archivo_detalle; var dato: REG_detalle );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.codPcia:= fin;
end;

// Obtener minimo
procedure minimo( var aDetalles: vector_archivo_detalle; var rDetalles: vector_registro_detalle; var min: REG_detalle );
var
  i, pos: integer;

begin
  min.codPcia:= fin;
  min.codLocalidad:= 9999;
  pos:= -1;

  for i:=1 to dimF do begin
    if ( rDetalles[i].codPcia < min.codPcia ) or (( rDetalles[i].codPcia = min.codPcia ) and ( rDetalles[i].codLocalidad < min.codLocalidad )) then begin
      min:= rDetalles[i];
      pos:= i;
    end;
  end;

  if ( pos <> -1 ) then
    leerDetalle( aDetalles[pos], rDetalles[pos] );
end;

// Procesar los archivos DETALLE
procedure procesarDetalles( var maestro: archivo_maestro );
var
  rm: REG_maestro;
  aDetalles: vector_archivo_detalle;
  rDetalles: vector_registro_detalle;
  min, detalle: REG_detalle;
  i: integer;

begin
  // Abrir archivo MAESTRO
  Reset( maestro );
  
  for i:=1 to dimF do begin
    Assign( aDetalles[i], 'detalles_' + IntToStr(i) );
    Reset( aDetalles[i] );
    leerDetalle( aDetalles[i], rDetalles[i] );
  end;

  minimo( aDetalles, rDetalles, min );

  while ( min.codPcia <> fin) do begin
    
    // Corte control CODPCIA
    detalle.codPcia:= min.codPcia;

    while ( min.codPcia <> fin ) and ( min.codPcia = detalle.codPcia ) do begin
      
      // Conrte control CODPROVINCIA
      detalle.codLocalidad:= min.codLocalidad;
      detalle.viviendasConLuz:= 0;
      detalle.viviendasConstruidas:= 0;
      detalle.viviendasConAgua:= 0;
      detalle.viviendasConGas:= 0;
      detalle.entregaSanitarios:= 0;

      while ( min.codPcia <> fin ) and ( min.codPcia = detalle.codPcia ) and ( min.codLocalidad = detalle.codLocalidad ) do begin
        detalle.viviendasConLuz:= detalle.viviendasConLuz + min.viviendasConLuz;
        detalle.viviendasConstruidas:= detalle.viviendasConstruidas + min.viviendasConstruidas;
        detalle.viviendasConAgua:= detalle.viviendasConAgua + min.viviendasConAgua;
        detalle.viviendasConGas:= detalle.viviendasConGas + min.viviendasConGas;
        detalle.entregaSanitarios:= detalle.entregaSanitarios + min.entregaSanitarios;

        minimo( aDetalles, rDetalles, min );
      end;

      // Buscar en el archio MAESTRO
      leerMaestro( maestro, rm );
      while ( rm.codPcia <> detalle.codPcia ) or ( rm.codLocalidad <> detalle.codLocalidad ) do 
        leerMaestro( maestro, rm );

      // Actualizar registro MAESTRO
      rm.viviendasSinLuz:= rm.viviendasSinLuz - detalle.viviendasConLuz;
      rm.viviendaSinGas:= rm.viviendaSinGas - detalle.viviendasConGas;
      rm.viviendasSinAgua:= rm.viviendasSinAgua - detalle.viviendasConAgua;
      rm.viviendasSinSanitarios:= rm.viviendasSinSanitarios - detalle.entregaSanitarios;
      rm.viviendasDeChapa:= rm.viviendasDeChapa - detalle.viviendasConstruidas;

      // Actualizar
      Seek( maestro, FilePos(maestro) - 1 );
      Write( maestro, rm );

    end;
  end;

  for i:=1 to dimF do
    Close( aDetalles[i] );
end;

// Informar viviendas sin chapa
procedure informar( var maestro: archivo_maestro );
var
  rm: REG_maestro;
  cantLocalidades: integer;

begin
  Reset( maestro );
  cantLocalidades:= 0;

  leerMaestro( maestro, rm );
  while ( rm.codPcia <> fin ) do begin
    if ( rm.viviendasDeChapa = 0 ) then
      cantLocalidades:= cantLocalidades + 1;

    leerMaestro( maestro, rm );
  end;

  WriteLn( 'La cantidad de localidades sin viviendas de chapa es: ', cantLocalidades );
end;


// Programa principal
var
  maestro: archivo_maestro;

begin
  Assign( maestro, 'maestro' );

  procesarDetalles( maestro );
  informar( maestro );

  Close( maestro );
end.