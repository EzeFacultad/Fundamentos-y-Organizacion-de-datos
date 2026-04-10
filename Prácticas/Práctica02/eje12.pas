program eje12;

const
  fin = 9999;

type
  REG_archivo = record
    anio, mes, dia, idUsuario, tiempo: integer;
  end;

  archivo_acceso = file of REG_archivo;


// Leer dato del archivo
procedure leer( var archivo: archivo_acceso; var dato: REG_archivo );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.anio:= fin;
end;

// Procesar archivo
procedure procesarArchivo( anio: integer );
var
  ra: REG_archivo;
  dia, mes, idUsuario, tiempoUsuario, tiempoTotalDia, tiempoTotalMes, tiempoTotalAnio: integer;
  arch: archivo_acceso;

begin
  Assign( arch, 'acessos' );
  Reset( arch );
  
  leer( arch, ra );
  while ( ra.anio <> fin ) and ( ra.anio < anio )  do
    leer( arch, ra );

  if ( ra.anio = fin ) or ( ra.anio > anio ) then
    WriteLn ( 'Anio no en contrado' )
  else
    begin
      tiempoTotalAnio:= 0;

      WriteLn( 'Anio: ', anio );
      
      while ( ra.anio = anio ) do begin
        
        // Corte control MES
        mes:= ra.mes;
        tiempoTotalMes:= 0;

        WriteLn( 'Mes: ', mes );

        while ( ra.anio = anio ) and ( ra.mes = mes ) do begin
          
          // Corte control DIA
          dia:= ra.dia;
          tiempoTotalDia:= 0;

          WriteLn ( 'Dia: ', dia );

          while ( ra.anio = anio ) and ( ra.mes = mes ) and ( ra.dia = dia ) do begin

            // Corte contol USUARIP
            idUsuario:= ra.idUsuario;
            tiempoUsuario:= 0;

            while ( ra.anio = anio ) and ( ra.mes = mes ) and ( ra.dia = dia ) and ( ra.idUsuario = idUsuario) do begin
              tiempoUsuario:= tiempoUsuario + ra.tiempo;
              leer( arch, ra );
            end;

            WriteLn( '(',ra.idUsuario,') ','Tiempo Total de acceso en el dia ', dia,' del mes ', mes,': ', tiempoUsuario );

            tiempoTotalDia:= tiempoTotalDia + tiempoUsuario;
          end;

          // Informar tiempo por DIA
          WriteLn( 'Tiempo total acceso dia ', dia, ' mes ', mes, ': ', tiempoTotalDia );

          tiempoTotalMes:= tiempoTotalMes + tiempoTotalDia;
        end;

        // Informar tiempo MES
        WriteLn( 'Total tiempo de acceso mes ', mes, ': ', tiempoTotalMes );

        tiempoTotalAnio:= tiempoTotalAnio + tiempoTotalMes;
      end;

      // Informar tiempo AÑO
      WriteLn( 'Total tiempo de acceso anio ', anio, ': ', tiempoTotalAnio );
    end;
  
  Close( arch );
end;

procedure inciso();
var
  anio: integer;

begin
  Write(' Ingresar anio a buscar: ');
  readln( anio );

  procesarArchivo( anio );
end;


// Programa principal
var
  arch: archivo_acceso;

begin
  inciso();
end.