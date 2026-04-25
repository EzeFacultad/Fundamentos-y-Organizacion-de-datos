program eje02;

type
  reg_votos = record
    codLocalidad, numMesa, cantVotos: integer;
  end; 

  reg_auxiliar = record
    codLocalidad, cantVotos: integer;
  end;

  archivo_votos = File of reg_votos;
  archivo_auxiliar = File of reg_auxiliar;


// Leer archivo ORIGINAL
procedure leerArchivo( var a: archivo_votos; var dato: reg_votos );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.codLocalidad:= -1;
end;

// Leer archivo AUXILIAR
procedure leerAuxiliar( var a: archivo_auxiliar; var dato: reg_auxiliar );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.codLocalidad:= -1;
end;

// Recorrer archivo AUXILIAR para imprimir
procedure recorrerAuxiliar( a: archivo_auxiliar );
var
  r: reg_auxiliar;
  totalVotos: integer;
begin
  totalVotos:= 0;
  Reset( a );

  leerAuxiliar( a, r );
  Write( 'Codigo de Localidad' );
  Write( '              ');
  WriteLn( 'Total de Votos' );
  while ( r.codLocalidad <> -99 ) do begin
    Write( r.codLocalidad );
    Write( '              ');
    WriteLn( r.cantVotos );

    totalVotos:= totalVotos + r.cantVotos;

    leerAuxiliar( a, r );
  end;

  WriteLn( 'Total General de Votos:              ', totalVotos );

  Close( a );
end;

// Procesar votos
procedure procesarVotos( a: archivo_votos );
var
  r: reg_votos;
  aux: archivo_auxiliar;
  raux: reg_auxiliar;
begin
  Reset( a );

  // Crear archivo auxiliar
  Assign( aux, 'archivo_auxiliar' );
  Rewrite( aux );

  // Leer archivo de votos
  leerArchivo( a, r );
  while ( r.codLocalidad <> -1 ) do begin
    // Posicionamos el puntero del archivo auxiliar siempre en el inicio
    Seek( aux, 0 );

    // Leer archivo auxiliar
    leerAuxiliar( aux, raux );
    // Buscar registro con mismo código de localidad
    while ( raux.codLocalidad <> -1 ) and ( raux.codLocalidad <> r.codLocalidad ) do
      leerAuxiliar( aux, raux );

    // Si se encontro en el archivo auxiliar, se actualiza
    if ( raux.codLocalidad = r.codLocalidad ) then begin
      raux.cantVotos:= raux.cantVotos + r.cantVotos;
      Seek( aux, FilePos(aux) - 1 );
      Write( aux, raux );
    end
    // Si no está, se agrega
    else begin
      raux.codLocalidad:= r.codLocalidad;
      raux.cantVotos:= r.cantVotos;
      Write( aux, raux );
    end;

    // Leer otro registro del archivo de votos
    leerArchivo( a, r );
  end;

  Close( a );
  Close( aux );

  recorrerAuxiliar( aux );


  Assign( aux, 'archivo_auxiliar' );
  // Eliminación del archivo auxiliar
  Erase( aux );
end;

// Programa principal
begin
  // Sin programa principal
end.