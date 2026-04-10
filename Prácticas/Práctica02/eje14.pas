{
  Se supone que la fecha tiene el formato: YYYY-MM-DD
  La hora tiene el formarto: HH:MM
}

program eje14;
const
  fin = 'terminar';

type
  REG_vuelo = record
    destino: string[40];
    fecha: string[10];
    hora_salida: string[5];
  end;

  REG_maestro = record
    vuelo: REG_vuelo;
    asientos_disp: integer;
  end;

  REG_detalle = record
    vuelo: REG_vuelo;
    asientos_comprados: integer;
  end;

  Lista = ^Nodo;
  Nodo = record
    dato: REG_vuelo;
    sig: Lista;
  end;

  archivo_maestro = file of REG_maestro;
  archivo_detalle = file of REG_detalle;


// Crear lista
procedure insertarAdelante ( var L: Lista; r: REG_vuelo );
var
  nue: Lista;
begin
  new( nue );
  nue^.dato:= r;
  nue^.sig:= L;
  L:= nue;
end;

// Leer archivo
procedure leer( var archivo: archivo_detalle; var dato: REG_detalle );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.destino:= fin;
end;

// Obtener el menor
procedure minimo( var detalle1, detalle2: archivo_detalle; var rd1, rd2, min: REG_detalle );
begin
  if ( rd1.vuelo.destino <> fin ) and 
  (( rd1.vuelo.destino < rd2.vuelo.destino ) or
  (( rd1.vuelo.destino = rd2.vuelo.destino ) and ( rd1.vuelo.fecha < rd2.vuelo.fecha )) or
  (( rd1.vuelo.destino = rd2.vuelo.destino ) and ( rd1.vuelo.fecha = rd2.vuelo.fecha ) and ( rd1.vuelo.hora_salida < rd2.vuelo.hora_salida ))) then begin
    min:= rd1;
    leer( detalle1, rd1 );
  end
  else
    begin
      min:= rd2;
      leer( detalle2, rd2 );
    end;
end;

// Analizar archivo
procedure analizarArchivo( var maestro: archivo_maestro; var L: Lista );
var
  rm: REG_maestro;
  detalle1, detalle2: archivo_detalle;
  rd1, rd2, min: REG_detalle;
  vuelo: REG_vuelo;
  comprados, cantDisponibles: integer;

begin
  Assign( detalle1, 'detalle1' );
  Assign( detalle2, 'detalle2' );

  Reset( maestro );
  Reset( detalle1 );
  Reset( detalle2 );

  leer( detalle1, rd1 );
  leer( detalle2, rd2 );
  minimo( detalle1, detalle2, rd1, rd2, min );

  // Para el inciso B
  Write( 'Ingresar cant. asienos disponibles: ');
  readln( cantDisponibles );

  while ( min.vuelo.destino <> fin ) do begin

    // Corte control DESTINO
    vuelo.destino:= min.vuelo.destino;
    
    while ( min.vuelo.destino = destino ) do begin
      
      // Corte control FECHA
      vuelo.fecha:= min.vuelo.fecha;

      while ( min.vuelo.destino = destino ) and ( min.vuelo.fecha = fecha ) do begin
        
        // Corte control HORA
        vuelo.hora_salida:= min.vuelo.hora_salida;
        comprados:= 0;

        // Contar asientos comprados
        while ( min.vuelo.destino = destino ) and ( min.vuelo.fecha = fecha ) and ( min.vuelo.hora_salida = hora_salida ) do begin
          comprados:= comprados + min.asientos_comprados;
          minimo( detalle1, detalle2, rd1, rd2, min );
        end;

        // Buscar vuelo en archivo MAESTRO
        Read( maestro, rm );
        while ( not Eof(maestro) ) and (( rm.vuelo.destino <= destino ) or ( rm.vuelo.fecha <= fecha ) or ( rm.vuelo.hora_salida < hora_salida )) do
          Read( maestro, rm );

        rm.asientos_disp:= rm.asientos_disp - comprados;

        Seek( maestro, FilePos(maestro) - 1 );
        Write( maestro, rm );

        // Inciso B
        if ( rm.asientos_disp < cantDisponibles ) then
          insertarAdelante( L, vuelo );

      end;
    end;
  end;

  Close( detalle1 );
  Close( detalle2 );
end;


// Programa principal
var
  maestro: archivo_maestro;
  L: Lista;
begin
  L:= nil;

  Assign( maestro, 'maestro' );

  analizarArchivo( maestro, L );

  Close( maestro );
end.