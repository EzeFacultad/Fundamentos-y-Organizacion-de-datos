program eje09;
const
  fin = 9999;

type
  REG_cliente = record
    codCliente: integer;
    apellido, nombre: string[20];
  end;

  REG_maestro = record
    cliente: REG_cliente;
    anio, mes, dia: integer;
    montoVenta: real;
  end;

  archivo_maestro = file of REG_maestro;


// Leer archivo
procedure leer( var maestro: archivo_maestro; var dato: REG_maestro );
begin
  if ( not Eof(maestro) ) then
    Read( maestro, dato )
  else
    dato.cliente.codCliente:= fin;
end;


procedure analizarArchivo( var maestro: archivo_maestro );
var
  rm: REG_maestro;
  rc: REG_cliente;
  codCliente, anio, mes: integer;
  totalMes, totalAnio, totalEmpresa: real;

begin
  totalEmpresa:= 0;

  leer( maestro, rm );

  while ( rm.cliente.codCliente <> fin) do begin
    
    // Corte control CODCLIENTE
    codCliente:= rm.cliente.codCliente;

    // Informar CLIENTE
    WriteLn( '(',rm.cliente.codCliente,') ', 'Apellido y nombre: ', rm.cliente.apellido,' ', rm.cliente.nombre );
   
    while ( rm.cliente.codCliente = codCliente ) do begin
      
      // Corte control ANIO
      anio:= rm.anio;
      totalAnio:= 0;

      while ( rm.cliente.codCliente = codCliente ) and ( rm.anio = anio ) do begin
        
        // Corte control MES
        mes:= rm.mes;
        totalMes:= 0;

        while ( rm.cliente.codCliente = codCliente ) and ( rm.anio = anio ) and ( mes = rm.mes ) do begin
          totalMes:= totalMes + rm.montoVenta;
          leer( maestro, rm );
        end;

        // Informar monto MES
        if ( totalMes <> 0 ) then
          WriteLn( 'Mes ', mes, ': ', totalMes );

        totalAnio:= totalAnio + totalMes;
      end;

      // Informar monto Anio
      WriteLn( 'Monto anual: ', totalAnio );

      totalEmpresa:= totalEmpresa + totalAnio;
    end;
  end;

  // Informar total EMPRESA
  WriteLn( 'Total de la empresa: ', totalEmpresa );
end;


// Programa principal 
var
  maestro: archivo_maestro;

begin
  Assign( maestro, 'maestro' );
  Reset( maestro );

  analizarArchivo( maestro );

  Close( maestro );
end.