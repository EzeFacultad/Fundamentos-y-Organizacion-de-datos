program eje03;

const
  fin = 9999;
type  
  REG_libro = record
    codigo, cantPaginas: integer;
    genero: String[20];
    titulo: String[30];
    precio: real;
  end;

  archivo_libros = File of REG_libro;


// Leer registro
procedure leer( var r: REG_libro );
begin
  ReadLn(r.codigo);
  if ( r.codigo <> -1 ) then begin
    ReadLn( r.cantPaginas );
    ReadLn( r.genero );
    ReadLn( r.titulo );
    ReadLn( r.precio );
  end;
end;

// Leer archivo
procedure leerArchivo( var a: archivo_libros; var dato: REG_libro );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.codigo:= fin;
end;


// ============= Opcion 1
procedure pocion();
var
  a: archivo_libros;
  r: REG_libro;

begin
  Assign( a, 'libros' );
  Rewrite( a );

  r.codigo:= 0;
  Write( a, r );

  leer( r );
  while ( r.codigo <> -1 ) do begin
    Write( a, r );
    leer( r );
  end;

  Close( a );
end;

// ============= Opcion 2
procedure opcion2();
  // ======= Agregar libro si hay espacio
  procedure agregarLibro( var a: archivo_libros );
  var
    r: REG_libro;

  begin
    Reset( a );

    leerArchivo( a, r );
    if ( r.codigo = 0 ) then begin
      leer( r );
      Seek( a, FilePos(FileSize(a)) );
      Write( a, r );
    end
    else begin
      // Guardamos la posicion y la hacemos positiva
      pos:= r.codigo * -1;
      // Nos posicionamos en el archivo
      Seek( a, pos );
      // Leemos el registro dentro del archivo
      leerArchivo( a, r );
      // Guardamos la posición para luego guardarla en la posición 0
      pos:= r.codigo;
      // Leemos el nuevo libro
      leer( r );
      // Guardamos el libro en el archivo
      Seek( a, FilePos(a) - 1 );
      Write( a, r );
      // Volvemos al inicio del archivo
      Reset( a );
      // Guardamos la nueva posición;
      leerArchivo( a, r );
      r.codigo:= pos;
      Seek( a, FilePos(a) - 1 );
      Write( a, r );
    end;
      
    Close( a );
  end;

  // ======= Modificar libro
  procedure modificarLibro( var a: archivo_libros );
  var
    r: REG_libro;
    codigo: integer;
  begin
    Reset( a );
    
    Write( 'Codigo del libro a modificar: ' );
    ReadLn( codigo );

    leerArchivo( a, r );
    while ( r.codigo <> fin ) and ( r.codigo <> codigo ) do
      leerArchivo( a, r );

    if ( r.codigo = codigo ) then begin
      Write( 'Cantidad de paginas: ');
      ReadLn( r.cantPaginas );
      Write( 'Genero: ' );
      ReadLn( r.genero );
      Write( 'Titulo: ' );
      ReadLn( r.titulo );
      Write( 'Precio: ' );
      ReadLn( r.precio );

      Seek( a, FilePos(a) - 1 );
      Write( a, r );
    end;

    Close( a );
  end;

  // ======= Eliminar libro
  procedure eliminarLibro( var a: archivo_libros );
  var
    codigo, pos, posIni: integer;
  begin
    Reset( a );

    Write( 'Codigo de libro a eliminar: ');
    ReadLn( codigo );

    leerArchivo( a, r );
    posIni:= r.codigo; // Guardamos la posición guardada en el inicio
    while ( r.codigo <> fin ) and ( r.codigo <> codigo ) do
      leerArchivo( a, r );

    if ( r.codigo = codigo ) then begin
      // Guardamos la posicion del registro eliminado
      pos:= (FilePos(a) - 1) * -1;
      // Al codigo le asignamos el valor de la posición que estaba en el inicio
      r.codigo:= posIni;
      // Volvemos al inicio del archivo
      Reset( a );
      // Leemos el registro
      leerArchivo( a, r );
      // Guardamos el nuevo valor
      r.codigo:= pos;
      // Volvemos al inicio
      Seek( a, FilePos(a) - 1 );
      // Guardamos el registro actualizado
      Write( a, r );
    end;

    Close( a );
  end;

  // ============= Opcion 3
  procedure opcion3();
  var
    a: archivo_libros;
    texto: Text;
    r: REG_libro;
  begin
    Assign( a, 'libros' );
    Assign( texto, 'libros.txt' );
    Reset( a );
    Rewrite( texto );

    leerArchivo( a, r );
    while ( r.codigo <> fin ) do begin
      if ( r.codigo > 0 ) then
        WriteLn( texto, r );

      leerArchivo( a, r );
    end; 

    Close( a );
    Close( texto );
  end;


var
  r: REG_libro;
  pos: integer;
  opcion: Byte;
  a: archivo_libros;
begin
  Assign( a, 'libros' );

  WriteLn( 'Dar de alta libro' );
  WriteLn( 'Modificar datos de libro' );
  WriteLn( 'Eliminar libro' );
  ReadLn(opcion);

  case option of
    1: begin
      agregarLibro( a );
    end;

    2: begin
      modificarLibro( a );
    end;

    3: begin
      eliminarLibro( a );
    end;
  end;

end;


var
  opcion: Byte;
begin
  Write('Elegir una opcion: ');
  ReadLn( opcion );

  WriteLn( '1) Crear archivo y cargarlo ' );
  WriteLn( '2) Mantenimiento' );
  WriteLn( '3) Exportar a .txt' );

  ReadLn( opcion );

  case opcion of
    1: begin
      opcion1();
    end;

    2: begin
      opcion2();
    end;

    3: begin
      opcion3();
    end;
  end;
  
end.