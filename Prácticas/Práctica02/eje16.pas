{
  Formato de la fecha: YYYY-MM-DD
}

program eje16;
  //uses sysutils;
  
  const
    dimF = 100;
    fin = '9999-99-99';
type
  REG_maestro = record
    fecha: string[10];
    codSemanario, totalEjemplares, totalEjemplaresVendidos: integer;
    nombreSemanario: string[30];
    descripcion: string;
    precio: real;
  end;

  REG_detalle = record
    fecha: string[10];
    codSemanario, cantEjemplaresVendidos: integer;
  end;

  archivo_maestro = file of REG_maestro;
  archivo_detalle = file of REG_detalle;

  vector_archivo_detalle = array [1..dimF] of archivo_detalle;
  vector_registro_detalle = array [1..dimF] of REG_detalle;


// Leer archivo MAESTRO
procedure leerMaestro( var archivo: archivo_maestro; var dato: REG_maestro );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.fecha:= fin;
end;

// Leer archivo DETALLE
procedure leerDetalle( var archivo: archivo_detalle; var dato: REG_detalle );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.fecha:= fin;
end;

// OBtener minimo
procedure minimo( var aDetalles: vector_archivo_detalle; var rDetalles: vector_registro_detalle; var min: REG_detalle );
var
  i, pos: integer;

begin
  min.fecha:= fin;
  min.codSemanario:= 9999;
  pos:= -1;

  for i:=1 to dimF do begin
    if ( rDetalles[i].fecha < min.fecha ) or (( rDetalles[i].fecha = min.fecha ) and ( rDetalles[i].codSemanario < min.codSemanario )) then begin
      min:= rDetalles[i];
      pos:= i;
    end;
  end;

  if ( pos <> -1 ) then
    leerDetalle( aDetalles[pos], rDetalles[pos] );
end;

// Procesar archivos detalle
procedure procesarDetalles( var maestro: archivo_maestro; var aDetalles: vector_archivo_detalle );
var
  rm: REG_maestro;
  rDetalles: vector_registro_detalle;
  min: REG_detalle;
  fecha: string[10];
  i, codSemanario, cantEjemplaresVendidos: integer;

  // Para la parte de informar
  maxCantVentas, minCantVentas: integer;
  maxFecha, minFecha: string[10];
  maxNombreSemanario, minNombreSemanario: string[30];

begin
  Reset( maestro );

  maxCantVentas:= 0;
  minCantVentas:= 9999;

  for i:=1 to dimF do begin
    Reset( aDetalles[i] );
    leerDetalle( aDetalles[i], rDetalles[i] );
  end;

  minimo( aDetalles, rDetalles, min );

  while ( min.fecha <> fin ) do begin

    // Corte control FECHA
    fecha:= min.fecha;

    while ( min.fecha = fecha ) do begin
      
      // Corte control SEMANARIO
      codSemanario:= min.codSemanario;
      cantEjemplaresVendidos:= 0;

      while ( min.fecha = fecha ) and ( min.codSemanario = codSemanario ) do begin
        cantEjemplaresVendidos:= cantEjemplaresVendidos + min.cantEjemplaresVendidos;
        minimo( aDetalles, rDetalles, min );  
      end;

      // Buscar en archivo MAESTRO
      leerMaestro( maestro, rm );
      while ( rm.fecha < fecha ) or (( rm.fecha = fecha ) and ( rm.codSemanario < codSemanario )) do
        leerMaestro( maestro, rm );

      // Actualizar registro MAESTRO
      rm.totalEjemplaresVendidos:= rm.totalEjemplaresVendidos + cantEjemplaresVendidos;

      // Guardar en archivo MAESTRO
      Seek( maestro, FilePos(maestro) - 1 );
      Write( maestro, rm );

      // Obtener máximo y mínimo
      if ( cantEjemplaresVendidos > maxCantVentas ) then begin
        maxCantVentas:= cantEjemplaresVendidos;
        maxFecha:= rm.fecha;
        maxNombreSemanario:= rm.nombreSemanario;
      end;  

      if ( cantEjemplaresVendidos < minCantVentas ) then begin
        minCantVentas:= cantEjemplaresVendidos;
        minFecha:= rm.fecha;
        minNombreSemanario:= rm.nombreSemanario;
      end;
    end;
  end;

  WriteLn( 'En la fecha: ', maxFecha, ' se vendieron más del seminario: ', maxNombreSemanario );
  WriteLn( 'En la fecha: ', minFecha, ' se vendieron menos del seminario: ', minNombreSemanario );
end;


// Programa principal
var
  maestro: archivo_maestro;
  aDetalles: vector_archivo_detalle;
  i: integer;
begin
  Assign( maestro, 'maestro' );

  for i:=1 to dimF do
    Assign( aDetalles[i], 'detalle_' + IntToStr(i) );

  procesarDetalles( maestro, aDetalles );
  informar( maestro );

  Close( maestro );
    for i:=1 to dimF do
    Close( aDetalles[i] );
end.