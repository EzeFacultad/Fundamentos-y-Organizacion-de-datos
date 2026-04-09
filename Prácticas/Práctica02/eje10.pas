program eje10;
const
  fin = 9999;

type
  REG_votos = record
    codProvincia, codLocalidad, numMesa, cantVotos: integer;
  end;

  archivo_votos = file of REG_votos;


procedure leer ( var archivo: archivo_votos; var dato: REG_votos );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.codProvincia:= fin;
end;

procedure analizarArchivo( var arch: archivo_votos );
var
  ra: REG_votos;
  codProvincia, codLocalidad, totalVotosProv, totalVotosLocal: integer;

begin
  // Leer dato del archivo
  leer( arch, ra );

  while ( ra.codProvincia <> fin ) do begin

    // Corte control PROVINCIA
    codProvincia:= ra.codProvincia;  
    totalVotosProv:= 0;

    WriteLn( 'Codigo de Provincia: ', codProvincia );
    while ( ra.codProvincia = codProvincia ) do begin
      
      // Corte control LOCALIDAD
      codLocalidad:= ra.codLocalidad;
      totalVotosLocal:= 0;

      Write( 'Codigo de Localidad: ', ra.codLocalidad, '       ' );
      while ( ra.codProvincia = codProvincia ) and ( ra.codLocalidad = codLocalidad ) do begin
        totalVotosLocal:= totalVotosLocal + ra.cantVotos;
        leer( arch, ra );
      end;

      // Informar votos LOCALIDAD
      WriteLn( 'Total de Votos: ', totalVotosLocal );

      totalVotosProv:= totalVotosProv + totalVotosLocal;
    end;

    // Informar total PROVINCIA
    WriteLn( 'Total de Votos Provincia: ', totalVotosProv );    
  end;
end;


// Programa principal
var
  arch: archivo_votos;

begin
  Assign( arch, 'votos' );
  Reset( arch );

  analizarArchivo( arch );

  Close( arch );
end.