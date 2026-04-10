{
  Supongo que la fecha esta guardada en el nombre del archivo diario.
  Ej:
    detalle_2025_01_01
    detalle_2025_01_02
    ....
    detalle_2025_12_20
    detalle_2026_01_01
}

program eje13;
  const
    fin = 9999;
    
  type
    REG_log = record
      nro_usuario, cantidadMailEnviados: integer;
      nombreUsuario, nombre, apellido: string[20];
    end;

    REG_detalle = record
      nro_usuario: integer;
      cuentaDestino: string[30];
      cuerpoMensaje: string;
    end;

    archivo_log = file of REG_log;
    archivo_detalle = file of REG_detalle;


// Buscar dato del archivo
procedure leer( var archivo: archivo_detalle; var dato: REG_detalle );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.nro_usuario:= fin;
end;

// Leer fecha del archivo
procedure leerFecha( var fecha: string );
var
  anio, mes, dia, fecha: string[4];

begin

  Write( 'Anio: ');
  ReadLn( anio );

  Write( 'Mes: ' );
  ReadLn( mes );

  write( 'Dia: ' );
  ReadLn( dia );

  fecha:= anio + '_' + mes + '_' + dia;
end;

// ============================ INCISO I)
// Analizar archivo
procedure analizarArchivo( var log: archivo_log );
var
  rl: REG_log;
  detalle: archivo_detalle;
  rd: REG_detalle;
  fecha: string[10];
  cantEmail, nro_usuario: integer;
begin
  leerFecha( fecha );

  Assign( detalle, 'detalle_' + fecha );
  
  Reset( detalle );
  Reset( log );

  leer( detalle, rd );

  while ( rl.nro_usuario <> fin ) do begin
    
    // Corte control USUARIO
    nro_usuario:= rd.nro_usuario;
    cantEmail:= 0;

    while ( rd.nro_usuario = nro_usuario ) do begin
      cantEmail:= cantEmail + 1;
      leer( detalle, rd );
    end;

    Read( log, rl );
    while ( rl.nro_usuario <> nro_usuario ) do
      Read( log, rl );

    rl.cantidadMailEnviados:= rl.cantidadMailEnviados + cantEmail;

    Seek( log, FilePos(log) - 1 );
    WriteLn( log, rl.nro_usuario, rl.nombreUsuario, rl.nombre, rl.apellido, rl.cantidadMailEnviados );

  end;

  Close( detalle );
  
end;

// Generar archivo
procedure generarArchivo();
var
  detalle: archivo_detalle;
  rd: REG_detalle;
  fecha: string[10];
  nro_usuario, cantEmail: integer;
  texto: Text;
begin
  leerFecha( fecha );

  Assign( detalle, 'detalle_' + fecha );
  Assign( texto, 'detalle_' + fecha + '.txt' );
  
  Reset( detalle );
  Rewrite( texto );

  leer( detalle, rd );
  while ( rd.nro_usuario <> fin ) do begin
    
    // Corte control
    nro_usuario:= rd.nro_usuario;
    cantEmail:= 0;

    while ( rd.nro_usuario = nro_usuario ) do begin
      cantEmail:= cantEmail + 1;
      leer( detalle, rd );
    end;

    WriteLn( texto, nro_usuario, ' ', cantEmail );
  end;

  Close( detalle );
  Close( texto );
end;



// ============================ INCISO II)
{
  Abria que agregar la variable de tipo Text, y luego, despues del while que contabiliza, agregarlo al archivo de texto
}


// Programa principal
var
  log: archivo_log;

begin
  Assign( log, '/var/log/logmail.dat');
  Reset( log );

  analizarArchivo( log );
  generarArchivo();

  Close( log );
end.