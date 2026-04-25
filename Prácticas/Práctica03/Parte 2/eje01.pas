program eje01;

type
  reg_maestro = record
    codigo, stockActual, stockMinimo: integer;
    nombre: String[20];
    precio: real;
  end;

  reg_detalle = record
    codigo, cantUniVendidas: integer;
  end;

  archivo_maestro = File of reg_maestro;
  archivo_detalle = File of reg_detalle;


// Leer archivo MAESTRO
procedure leerMaestro( var a: archivo_maestro; var dato: reg_maestro );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.codigo:= -99;  
end;

// Leer archivo DETALLE
procedure leerDetalle( var a: archivo_detalle; var dato: reg_detalle );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.codigo:= -99;
end;

procedure actualizarMaestro( var maestro: archivo_maestro; detalle: archivo_detalle );
var
  rm: reg_maestro;
  rd: reg_detalle;

begin
  // Abrir archivo detalle
  Reset( detalle );

  leerDetalle( detalle, rd );
  // Recorrido archivo DETALLE
  while ( rd.codigo <> -99 ) do begin
    // Por cada nuevo código hay que volver a recorrer el archivo MAESTRO
    Reset( maestro );

    // Leer archivo MAESTRO
    leerMaestro( maestro, rm );
    // Buscar producto en el archivo MAESTRO
    while ( rm.codigo <> -99 ) and ( rd.codigo <> rm.codigo ) do
      leerMaestro( maestro, rm );

    if ( rd.codigo = rm.codigo ) then begin
      // Actualizamos el stock del archivo MAESTRO
      rm.stockActual:= rm.stockActual - rd.cantUniVendidas;

      // Retrocedemos el puntero una posición
      Seek( maestro, FilePos(maestro) - 1 );
      // Actualizamos el registro
      Write( maestro, rm );
    end;

          
    // Se lee otro registro de DETALLE
    leerDetalle( detalle, rd );
  end;

  Close( maestro );
  Close( detalle );
end;



// Programa principal
begin
  // Sin programa principal
end.

{
 B) Rta: Deberia recorrer el archivo MAESTRO y por cada registro leido, recorro el archivo DETALLE en busca de
 un registro con el mismo código. Si lo encuentra, actualiza el registro del archivo MAESTRO y sino, se pasa a 
 leer otro registro del archivo MAESTRO y se vuelve a recorrer desde el inicio el archivo DETALLE.
}