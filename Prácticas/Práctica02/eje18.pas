program eje18;
const
  fin = 9999;

type
  REG_maestro = record
    codLocalidad, codMunicipio, codHospital, cantCasosInfec: integer;
    nomLocalidad, nomMunicipio, nomHospital: string[20];
    fecha: string[10];
  end;

  archivo_maestro = file of REG_maestro;


// Leer archivo
procedure leer (var archivo: archivo_maestro; var dato: REG_maestro );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.codLocalidad:= fin;
end;

// Procesar archivo
procedure procesarArchivo( var maestro: archivo_maestro );
var
  rm: REG_maestro;
  codLocalidad, casosLocalidad, codMunicipio, casosMunicipio, codHospital, cantCasos, casosTotales: integer;
  nomLocalidad, nomMunicipio: string[20];
  texto: Text;

begin
  Assign( texto, 'COVID19.txt' );
  Rewrite( texto );

  leer( maestro, rm );

  casosTotales:= 0;

  while ( rm.codLocalidad <> fin) do begin
    
    // Corte control LOCALIDAD
    codLocalidad:= rm.codLocalidad;
    
    casosLocalidad:= 0;
    nomLocalidad:= rm.nomLocalidad;

    WriteLn( 'Localidad: ', rm.codLocalidad );

    while ( rm.codLocalidad = codLocalidad ) do begin
      
      // Corte control MUNICIPIO
      codMunicipio:= rm.codMunicipio;

      casosMunicipio:= 0;
      nomMunicipio:= rm.nomMunicipio;

      WriteLn( 'Municipio: ', rm.nomMunicipio );

      while ( rm.codLocalidad = codLocalidad ) and ( rm.codMunicipio = codMunicipio ) do begin

        // Corte control HOSPITAL
        codHospital:= rm.codHospital;
        cantCasos:= 0;

        while ( rm.codLocalidad = codLocalidad ) and ( rm.codMunicipio = codMunicipio ) and ( rm.codHospital = codHospital ) do begin
          cantCasos:= cantCasos + rm.cantCasosInfec;
          leer( maestro, rm );
        end;

        WriteLn( 'Hospital: ', rm.nomHospital, ' ........... Cantidad de casos: ', rm.cantCasosInfec );

        casosMunicipio:= casosMunicipio + cantCasos;
      end;

      WriteLn( 'Cantiodad de casos del municipio: ', casosMunicipio );

      if ( casosMunicipio > 1500 ) then
        WriteLn( texto, nomLocalidad, ' ', nomMunicipio, ' ', casosMunicipio );

      casosLocalidad:= casosLocalidad + casosMunicipio;
    end;

    WriteLn( ' Cantidad de casos de la localidad: ', casosLocalidad );

    casosTotales:= casosTotales + casosLocalidad;
  end;

  WriteLn( 'Casos totales de la provincia: ', casosTotales );

  Close( texto );
end;


// Programa principal
var
  maestro: archivo_maestro;

begin
  Assign( maestro, 'maestro' );
  Reset( maestro );

  procesarArchivo( maestro );

  Close( maestro );
end.