program eje17;

//uses sysutils;

const
  dimF = 10;
  fin = 9999;

type
  REG_maestro = record
    codigo, stockActual: integer;
    nombre, modelo, marca: string[20];
    descripcion: string;
  end;

  REG_detalle = record
    codigoMoto: integer;
    precio: real;
    fechaVenta: string[10];
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
    dato.codigo:= fin;
end;

// Leer archivo DETALLE
procedure leerDetalle( var archivo: archivo_detalle; var dato: REG_detalle );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.codigoMoto:= fin;
end;

// Obtener minimo
procedure minimo ( var aDetalles: vector_archivo_detalle; var rDetalles: vector_registro_detalle; var min: REG_detalle );
var
  i, pos: integer;

begin
  min.codigoMoto:= fin;
  pos:= -1;

  for i:=1 to dimF do begin
    if ( rDetalles[i].codigoMoto < min.codigoMoto ) then begin
      min:= rDetalles[i];
      pos:= i;
    end;
  end;

  if ( pos <> -1 ) then
    leerDetalle( aDetalles[pos], rDetalles[pos] );
end;

// Actualizar archivo
procedure actializarArchivo( var maestro: archivo_maestro; var aDetalles: vector_archivo_detalle );
var
  rm: REG_maestro;
  rDetalles: vector_registro_detalle;
  min: REG_detalle;
  i, codigoMoto, cantVendidas, maxVendidas: integer;
  maxMarca, maxModelo, maxNombre: string[20];

begin
  Reset( maestro );

  maxVendidas:= 0;

  for i:=1 to dimF do begin
    Reset( aDetalles[i] );
    leerDetalle( aDetalles[i], rDetalles[i] );
  end;

  leerMaestro( maestro, rm );
  minimo( aDetalles, rDetalles, min );

  while ( min.codigoMoto <> fin ) do begin

    while ( rm.codigo < min.codigoMoto ) do 
      leerMaestro( maestro, rm );

    // Corte control
    codigoMoto:= min.codigoMoto;
    cantVendidas:= 0;

    while ( min.codigoMoto = codigoMoto ) do begin
      cantVendidas:= cantVendidas + 1;
      minimo( aDetalles, rDetalles, min );
    end;

    // Actualizar registor MAESTRO
    rm.stockActual:= rm.stockActual - cantVendidas;

    // Actualizar archivo MAESTRO
    Seek( maestro, FilePos(maestro) - 1 );
    Write( maestro, rm );

    // Guardar maximo
    if ( cantVendidas > maxVendidas ) then begin
      maxVendidas:= cantVendidas;
      maxMarca:= rm.marca;
      maxModelo:= rm.modelo;
      maxNombre:= rm.nombre;
    end;

  end;

  WriteLn( 'La moto mas vendida fue: ');
  WriteLn( 'Marca: ', maxMarca, ' | Modelo: ', maxModelo, ' | Nombre: ', maxNombre );
end;


var
  maestro = archivo_maestro;
  aDetalles = vector_archivo_detalle;
  i: integer;

begin
  Assign( maestro, 'maestro' );
  for i:=1 to dimF do 
    Assign( aDetalles[i], 'detalle_' + IntToStr(i) );

  actializarArchivo( maestro, aDetalles );

  for i:=1 to dimF do 
    Close( aDetalles[i] );
end.