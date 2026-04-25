program eje07;

const
  fin = 'fin';
type
  reg_distribucion = record
    nombre: String[15];
    anio, cantDesarrolladores: integer;
    versionKernel: String[7];
    descripcion: String;
  end;

  archivo_distribucion = File of reg_distribucion;


// Leer archivo
procedure leerArchivo( var a: archivo_distribucion; var dato: reg_distribucion );
begin
  if ( not Eof(a) ) then
    Read( a, dato )
  else
    dato.nombre:= fin;
end;

// Buscar distribución
function buscarDistribucion( a: archivo_distribucion; nombre: String[15] ): integer;
var
  r: reg_distribucion;
  pos: integer;
begin
  Reset( a );

  leerArchivo( a, r );
  while ( r.nombre <> fin ) and ( r.nombre <> nombre ) do
    leerArchivo( a, r );

  if ( r.nombre = nombre ) then
    pos:= FilePos(a) - 1
  else
    pos:= -1;

  Close( a );

  buscarDistribucion:= pos;
end;

// Guardar registro en archivo
procedure altaDistribucion( var a: archivo_distribucion; r: reg_distribucion );
var
  pos: integer;
  rd: reg_distribucion;
begin
  Reset( a );

  // Buscamos si existe la distribuciòn
  if ( buscarDistribucion( a, r.nombre ) = -1 ) then
    WriteLn( 'Ya existe la distribucion' )
  else begin
    
    // Buscar lugar donde guardar el dato
    leerArchivo( a, rd );
    pos:= rd.cantDesarrolladores;
    
    // Si pos es 0, no hay espacio, agregamos al final
    if ( pos = 0 ) then begin
      Seek( a, FileSize(a) );
      Write( a, r );
    end 
    // Si no es 0, guarda la posición negativa donde hay lugar
    else begin
      // Pasamos la posición a positivo
      pos:= pos * -1;
      // Nos posicionamos en el archivo
      Seek( a, pos );
      // Leemos el registro del archivo
      leerArchivo( a, rm );
      // Guardamos la posicion que guarda este registro para actualizar la cabecera
      pos:= rm.cantDesarrolladores;
      // Nos posicionamos donde hay que guardar el registro nuevo
      Seek( a, FilePos(a) - 1 );
      // Guardamos el regisotr
      Write( a, r );
      // Volvemos al inicio
      Reset( a );
      // Leemos la cabecera
      leerArchivo( a, rm );
      // Volvemos al inicio
      Reset( a );
      // Actualizamos la posición
      rm.cantDesarrolladores:= pos;
      // Guardamos
      Write( a, rm );
    end;

  end;

  Close( a );
end;

// Dar de baja una distribución
procedure bajaDistribucion( var a: archivo_distribucion; nombre: String[15] );
var
  rm: reg_distribucion;
  pos, posBorrar: integer;
begin
  Reset( a );

  posBorrar:= uscarDistribucion( a, nombre );

  if ( posBorrar = -1 ) then
    WriteLn( 'Distribucion no existe' )
  else begin
    // Leemos registro de la cabecera
    leerArchivo( a, rm );
    // Guardamos la posición que está en la cabecera
    pos:= rm.cantDesarrolladores;
    // Guardamos la nueva posición negativa
    rm.cantDesarrolladores:= posBorrar * -1;
    // Volvemos a la cabecera
    Reset( a );
    // Actualizamos la cabecera con la nueva posición
    Write( a, rm );
    // Nos posicionamos donde está el registro a borrar
    Seek( a, posBorrar );
    // Leemos el registro
    leerArchivo( a, rm );
    // Lo actualizamos con la posición de la cabecera
    rm.cantDesarrolladores:= pos;
    // Retrocedemos en 1 el puntero
    Seek( a, FilePos(a ) - 1 );
    // Guardamos el registro
    Write( a, rm );
  end;

  Close( a );
end;

// Programa principal
begin
  { Sin programa principal }
end.