program eje02;

type
  REG_producto = record
    codProducto, stockDisponible: integer;
    nombre: String[20];
    descripcion: String[120];
    precio: real;
  end;

  archivo_maestro = File of REG_producto;


// Leer registro
procedure leer( var r: REG_producto );
begin
  ReadLn( r.codProducto );
  if ( r.codProducto <> -1 ) then begin
    ReadLn( r.stockDisponible );
    ReadLn( r.nombre );
    ReadLn( r.descripcion );
    ReadLn( r.precio );
  end;
end;

// Leer archivo
procedure leerArchivo( var a: archivo_maestro; var dato: REG_producto );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.codProducto:= -1;
end;

// Cargar archivo
procedure cargarArchivo( var a: archivo_maestro );
var
  r: REG_producto;

begin
  // Crear y abrir archivo
  Rewrite( a );

  leer( r );
  while ( r.codProducto <> -1 ) do begin
    Write( a, r );
    leer( r );
  end;  

  Close( a );
end;

// Realizar bajas
procedure bajaLogica( var a: archivo_maestro );
var
  r: REG_producto;
begin
  // Abrir archivo
  Reset( a );

  leerArchivo( a, r);
  while ( r.codProducto <> -1 ) do begin
    if ( r.stockDisponible = 0 ) then begin
      r.nombre:= '@' + r.nombre;
      Seek( a, FilePos(a) - 1 );
      write( a, r );
    end;

    leerArchivo( a, r );
  end;

  Close( a );
end;


// Programa principal  
var
  archivo: archivo_maestro;

begin
  Assign( archivo, 'maestro' );

  cargarArchivo( archivo );
  bajaLogica( archivo );
end.