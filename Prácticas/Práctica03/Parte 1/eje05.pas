program eje05;

const
  fin = 'terminar';

type
  reg_prenda = record
    cod_prenda, stock: integer;
    descripcion: String;
    color: String[20];
    tipo_prenda: String[15];
    precio: Real;
  end;

  archivo_maestro = File of reg_prenda;
  archivo_detalle = File of integer;

// Leer archivo MAESTRO
procedure leerMaestro( var a: archivo_maestro; var dato: reg_prenda );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.tipo_prenda:= fin;
end;

// Leer archivo DETALLE
procedure leerDetalle( var a: archivo_detalle; var dato: integer );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato:= -1;
end;

// Dar de baja prendas
procedure baja( var maestro: archivo_maestro; var detalle: archivo_detalle );
var
  rm: reg_prenda;
  codigo: integer;

begin
  Reset( maestro );
  Reset( detalle );

  leerDetalle( detalle, codigo );
  while ( codigo <> -1 ) do begin
    
    leerMaestro( maestro, rm );
    while ( rm.cod_prenda <> codigo ) and ( rm.tipo_prenda <> fin ) do
      leerMaestro( maestro, rm );

    if ( rm.cod_prenda = codigo ) then begin
      Seek( maestro, FilePos(a) - 1 );
      rm.stock:= -99;
      Write( maestro, rm );
      Reset( maestro );
    end;

    leerDetalle( detalle, codigo );
  end;

  Close( maestro );
  Close( detalle );
end;

// Efectivizar archivo maestro y crear uno actualizado
procedure efectivizar( var maestro: archivo_maestro );
var
  nuevoMaestro: archivo_maestro;
  rm: reg_prenda;
begin
  Assign( nuevoMaestro, 'nuevoMaestro' );
  Rewrite( nuevoMaestro );
  Reset( maestro );

  leerMaestro( maestro, rm );
  while ( rm.tipo_prenda <> fin ) do begin
    if ( rm.stock >= 0 ) then
      Write( nuevoMaestro, rm );
    
    leerMaestro( maestro, rm );
  end;

  Close( nuevoMaestro );
  Close( maestro );

  Rename( maestro, 'maestro_old' );
  Rename( nuevoMaestro, 'maestro' );
end;


// Programa principal 
var
  maestro: archivo_maestro;
  detalle: archivo_detalle;
begin
  Assign( maestro, 'maestro' );
  Assign( detalle, 'detalle' );
  baja( maestro, detalle );
  efectivizar( maestro );
end.