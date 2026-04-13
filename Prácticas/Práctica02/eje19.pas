program eje19;

//uses sysutils;

const
  dimF = 50;
  fin = 9999;

type
  REG_direccion = record
    calle, ciudad: string[20];
    nro, piso, depto: integer;
  end;

  REG_persona = record
    nombre, apellido: string[20];
    dni: LongInt;
  end;

  REG_nacimiento = record
    nroPartidaNacimiento: integer;
    nombre, apellido: string[20];
    direccion: REG_direccion;
  end;

  REG_deceso = record
    matriculaMedico: string[15];
    fecha: string[10];
    hora: string[5];
    lugar: string[30];
  end;
  
  REG_detalleNacimiento = record
    nacido: REG_nacimiento;
    madre: REG_persona;
    padre: REG_persona;
    matriculaMedico: string[15];
  end;

  REG_detalleFallecimiento = record
    nroPartidaNacimiento: integer;
    persona: REG_persona;
    deceso: REG_deceso;
  end;

  REG_maestro = record
    datos: REG_nacimiento;
    madre: REG_persona;
    padre: REG_persona;
    matriculaMedicoNacimiento: string[15];
    deceso: REG_deceso;
  end;

  archivo_maestro = file of REG_maestro;
  archivo_detalleNacimiento = file of REG_detalleNacimiento;
  archivo_detalleFallecimiento = file of REG_detalleFallecimiento;

  vector_archivo_detalleNacimiento = array [1..dimF] of archivo_detalleNacimiento;
  vector_archivo_detalleFallecimiento = array [1..dimF] of archivo_detalleFallecimiento;
  vector_registro_nacimiento = array [1..dimF] of REG_detalleNacimiento;
  vector_registro_fallecimiento = array [1..dimF] of REG_detalleFallecimiento;


var
  maestro: archivo_maestro;
  aDetalleNacimiento: vector_archivo_detalleNacimiento;
  aDetalleFallecimiento: vector_archivo_detalleFallecimiento;
  i: integer;


// Leer archivo NACIMIENTO
procedure leerNacimiento( var archivo: archivo_detalleNacimiento; var dato: REG_detalleNacimiento );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.nacido.nroPartidaNacimiento:= fin;
end;

// Leer archivo FALLECIMIENTO
procedure leerFallecimiento( var archivo: archivo_detalleFallecimiento; var dato: REG_detalleFallecimiento );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.nroPartidaNacimiento:= fin;
end;

// Buscar minimo NACIMIENTO
procedure minimoNacimiento( var aDetalleNacimiento: vector_archivo_detalleNacimiento; var rDetalleNacimiento: vector_registro_nacimiento; var min: REG_detalleNacimiento );
var
  i, pos: integer;

begin
  min.nacido.nroPartidaNacimiento:= fin;
  pos:= -1;

  for i:=1 to dimF do begin
    if ( rDetalleNacimiento[i].nacido.nroPartidaNacimiento < min.nacido.nroPartidaNacimiento ) then begin
      min:= rDetalleNacimiento[i];
      pos:= i;
    end;
  end;

  if ( pos <> -1 ) then
    leerNacimiento( aDetalleNacimiento[pos], rDetalleNacimiento[pos] );
end;

// Buscar minimo FALLECIMIENTO
procedure minimoFallecimiento( var aDetalleFallecimiento: vector_archivo_detalleFallecimiento; var rDetalleFallecimiento: vector_registro_fallecimiento; var min: REG_detalleFallecimiento );
var
  i, pos: integer;

begin
  min.nroPartidaNacimiento:= fin;
  pos:= -1;

  for i:=1 to dimF do begin
    if ( rDetalleFallecimiento[i].nroPartidaNacimiento < min.nroPartidaNacimiento ) then begin
      min:= rDetalleFallecimiento[i];
      pos:= i;
    end;
  end;

  if ( pos <> -1 ) then
    leerFallecimiento( aDetalleFallecimiento[pos], rDetalleFallecimiento[pos] );
end;

// Crear archivo MAESTRO
procedure crearMaestro ( var maestro: archivo_maestro; var aDetalleNacimiento: vector_archivo_detalleNacimiento; var aDetalleFallecimiento: vector_archivo_detalleFallecimiento );
var
  rm: REG_maestro;
  rDetalleNacimiento: vector_registro_nacimiento;
  rDetalleFallecimiento: vector_registro_fallecimiento;
  minNacimiento: REG_detalleNacimiento;
  minFallecimiento: REG_detalleFallecimiento;
  i: integer;
  texto: Text;
begin
  Assign ( texto, 'datos_personas.txt' );
  Rewrite( texto );

  // Leer datos
  for i:=1 to dimF do begin
    leerNacimiento( aDetalleNacimiento[i], rDetalleNacimiento[i] );
    leerFallecimiento( aDetalleFallecimiento[i], rDetalleFallecimiento[i] );
  end;

  // Obtener minimos
  minimoNacimiento( aDetalleNacimiento, rDetalleNacimiento, minNacimiento );
  minimoFallecimiento( aDetalleFallecimiento, rDetalleFallecimiento, minFallecimiento );

  while ( minNacimiento.nacido.nroPartidaNacimiento <> fin ) do begin
    rm.datos:= minNacimiento.nacido;
    rm.madre:= minNacimiento.madre;
    rm.padre:= minNacimiento.padre;
    rm.matriculaMedicoNacimiento:= minNacimiento.matriculaMedico;

    rm.deceso.matriculaMedico := '';
    rm.deceso.fecha := '';
    rm.deceso.hora := '';
    rm.deceso.lugar := '';

    // Obtener la persona fallecida si es que existe    
    while (minFallecimiento.nroPartidaNacimiento < minNacimiento.nacido.nroPartidaNacimiento) do
      minimoFallecimiento(aDetalleFallecimiento, rDetalleFallecimiento, minFallecimiento);

    if ( minNacimiento.nacido.nroPartidaNacimiento = minFallecimiento.nroPartidaNacimiento ) then begin
      rm.deceso:= minFallecimiento.deceso;

      minimoFallecimiento( aDetalleFallecimiento, rDetalleFallecimiento, minFallecimiento );
    end;

    Write( maestro, rm );
    WriteLn( 
        texto, 
        rm.datos.nroPartidaNacimiento, ' ', rm.datos.nombre, ' ', rm.datos.apellido, ' ', 
        rm.datos.direccion.calle, ' ', rm.datos.direccion.nro, ' ', rm.datos.direccion.piso, ' ', rm.datos.direccion.depto, ' ', rm.datos.direccion.ciudad, ' ', 
        rm.madre.nombre, ' ', rm.madre.apellido, ' ', rm.madre.dni, ' ',
        rm.padre.nombre, ' ', rm.padre.apellido, ' ', rm.padre.dni, ' ',
        rm.matriculaMedicoNacimiento, ' ', rm.deceso.matriculaMedico, ' ', rm.deceso.fecha, ' ', rm.deceso.hora, ' ', rm.deceso.lugar
       );

    minimoNacimiento( aDetalleNacimiento, rDetalleNacimiento, minNacimiento );
  end;

  Close( texto );
end;

begin
  Assign( maestro, 'maestro' );
  Rewrite( maestro );

  for i:=1 to dimF do begin
    Assign( aDetalleNacimiento[i], 'detalle_nacimiento_' + IntToStr(i) );
    Assign( aDetalleFallecimiento[i], 'detalle_fallecimiento_' + IntToStr(i) );
    Reset( aDetalleNacimiento[i] );
    Reset( aDetalleFallecimiento[i] );
  end;

  crearMaestro( maestro, aDetalleNacimiento, aDetalleFallecimiento );

  Close( maestro );
  for i:=1 to dimF do begin
    Close( aDetalleNacimiento[i] );
    Close( aDetalleFallecimiento[i] );
  end;
end.