program eje04;

const
  fin = 'terminar';

type
  reg_flor = record
    nombre: String[45];
    codigo: integer;
  end;

  tArchFlores = File of reg_flor;


// Leer registro
procedure leer( var r: reg_flor );
begin
  ReadLn( r.nombre );
  ReadLn( r.codigo );
end;

// Leer archivo
procedure leerArchivo( var a: tArchFlores; var dato: reg_flor );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.nombre:= fin;
end;

// Agregar flor
procedure agregarFlor( var a: tArchFlores; nombre: String; codigo: integer );
var
  r: reg_flor;
  flor: reg_flor;
  pos: integer;
begin
  Reset( a );
  leerArchivo( a, r );

  flor.nombre:= nombre;
  flor.codigo:= codigo;

  if ( r.codigo = 0 ) then begin
    Seek( a, FileSize(a) );
    Write( a, flor );
  end
  else begin
    // Posicion donde guardar el registro
    pos:= r.codigo * -1;
    // Posicionarme dentro del archivo
    Seek( a, pos );
    // Leer el registro dentro del archivo
    leerArchivo( a, r );
    // Guardar la posición que guarda el registro a reemplazar
    pos:= r.codigo;
    // Retroceder para guardar el nuevo registro
    Seek( a, FilePos(a) - 1 );
    // Guardar el nuevo registro
    Write( a, flor );
    // Volver al inicio del archivo
    Reset( a );
    // Actualizar la posción
    leerArchivo( a, r );
    r.codigo:= pos;
    // Volver un paso para guardar
    Seek( a, FilePos(a) - 1 );
    Write( a, r );
  end;

  Close( a );
end;

// Mostrar contenido del archivo
procedure listar( a: tArchFlores );
var
  r: reg_flor;
begin
  Reset( a );

  leerArchivo( a, r );
  WriteLn( '======= Flores =======' );
  while ( r.nombre <> fin ) do begin
    if ( r.codigo > 0 ) then
      WriteLn( '(',r.cogio,') ', r.nombre );
    
    leerArchivo( a, r );
  end;

  Close( a );
end;

// Eliminar una flor
procedure eliminarFlor( var a: tArchFlores; flor: reg_flor );
var
  r: reg_flor;
  pos: integer;
begin
  Reset( a );

  // Leer registro
  leerArchivo( a, r );

  // Guardar posicion guardada del primer registro
  pos:= r.codigo;

  while ( r.nombre <> fin ) and ( r.codigo <> flor.codigo ) do
    leerArchivo( a, r );

  if ( r.codigo = flor.codigo ) then begin
    // Volvemos donde está el registro
    Seek( a, FilePos(a) - 1 );
    // Actualizamos el codigo con la posición guardada en la cabezara
    r.codigo:= pos;
    // Guardamos el registro actualizado
    Write( a, r );
    // Guardamos la posición negada del registro borrado
    pos:= FilePos(a) * -1;
    // Volvemos al inicio
    Reset( a );
    // Leemos nuevamente el primer registro
    leerArchivo( a, r );
    // Actualizamos la posicion guardada en el primer registro
    r.codigo:= pos;
    // Volvemos al inicio del archivo
    Reset( a );
    // Guardamos el registro actualizado
    Write( a, r );
  end;

  Close( a );
end;

// Agrupar módulos
procedure incisos( var a: tArchFlores );
var
  r: reg_flor;
begin
  leer( r );
  agregarFlor( a, r.nombre, r.codigo );
  listar( a );
  leer( r );
  eliminarFlor( a, r );
end;


// Programa principal
var
  a: tArchFlores;
begin
  Assign( a, 'flores' );
  incisos( a );
end.