program eje06;

type
  reg_ave = record
    codigo: integer;
    nombre, familia: String[20];
    zona_geografica: String[30];
    descripcion: String;
  end;

  archivo_aves = File of reg_ave;


// Leer archivo
procedure leerArchivo( var a: archivo_aves; var dato: reg_ave );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.codigo:= 0;
end;



// Borrado lógico
procedure marcarBorrado( var a: archivo_aves );
var
  r: reg_ave
  codigo: integer;
begin
  Reset( a );

  Write('Codigo de ave a eliminar: ');
  ReadLn( codigo );

  leerArchivo( a, r );
  while ( r.codigo <> 0 ) and ( r.codigo <> codigo ) do
    leerArchivo( a, r );

  if ( r.codigo = codigo ) then begin
    r.codigo:= -99;
    Seek( a, FilePos(a) - 1 );
    Write( a, r );
  end;
end;

// Borrado físico
procedure compactacion( var a: archivo_aves );
var
  r: reg_ave;
  pos: integer;
begin
  Reset( a );

  leerArchivo( a, r );
  while ( r.codigo <> 0 ) do begin

    if ( r.codigo = -99 ) then begin
      // Volvemos a la posición del registro a borrar
      Seek( a, FilePos(a) - 1 );
      // Guardamos su posicion
      pos:= FilePos(a);
      // Vamos al final del archivo
      Seek( a, FileSize(a) );
      // Leemos el registro del final
      leerArchivo( a, r );
      // Volvemos una posición
      Seek( a, FilePos(a) - 1 );
      // Se trunca el registro
      Truncate( a );
      // Volvemos a la posición del registro a reemplzar
      Seek( a, pos );
      // Lo sobreescribimos con el registro de la última posición
      Write( a, r );
    end;

    // Seguimos leyendo desde donde nos quedamos
    leerArchivo( a, r );
  end;

  Close( a );
end;

//  FALTA REALIZAR LA VARIANTE

// Programa principal
var
  a: archivo_aves;
begin
  Assign( a, 'aves' );
  marcarBorrado( a );
  compactacion( a );
end.