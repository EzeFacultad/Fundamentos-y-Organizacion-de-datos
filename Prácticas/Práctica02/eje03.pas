program eje03;
const
  fin = 'terminar';

type
  REG_maestro = record
    nomProvincia: string[20];
    cantPersonas, totalEncuestados: integer;
  end;

  REG_detalle = record
    nomProvincia: string[20];
    codigo: string[4];
    cantPersonas, cantEncuestados: integer;
  end;

  archivo_maestro = file of REG_maestro;
  archivo_detalle = file of REG_detalle;


// Leer el archivo
procedure leer( var archivo: archivo_detalle; var dato: REG_detalle );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.nomProvincia = fin;
end;

// Guardar el minimo
procedure minimo( var detalle1, detalle2: archivo_detalle; var rd1, rd2, min: REG_detalle )
begin
  if ( rd1.nomProvincia <= rd2.nomProvincia ) then begin
    min:= rd1;
    leer( detalle1, rd1 );
  end
  else begin
    min:= rd2;
    leer( detalle2, rd2 );
  end;
end;


var
  maestro: archivo_maestro;
  detalle1, detalle2: archivo_detalle;
  rm: REG_maestro;
  rd1, rd2, min: REG_detalle;
  provincia: string[20];
  cantPersonas, totalEncuestados: integer;
begin
  Assign(maestro, 'maestro');
  Assign(detalle1, 'detalle1');
  Assign(detalle2, 'detalle2');

  Reset(maestro);
  Reset(detalle1);
  Reset(detalle2);

  leer( detalle1, rd1 );
  leer( detalle2, rd2 );
  minimo(detalle1, detalle2, rd1, rd2, min);
  Read( maestro, rm );

  while ( min.nomProvincia <> fin ) do begin
    // Buscas en el archivo maestro
    while ( not Eof(maestro) ) and ( rm.nomProvincia <> min.nomProvincia ) do
      Read( maestro, rm );
    
    cantPersonas:= 0; 
    totalEncuestados:= 0;
    provincia:= min.nomProvincia;
    while ( min.nomProvincia <> fin) and ( min.nomProvincia = provincia ) do begin
      cantPersonas:= cantPersonas + min.cantPersonas;
      totalEncuestados:= totalEncuestados + min.cantEncuestados;
      minimo(detalle1, detalle2, rd1, rd2, min);
    end;

    rm.cantPersonas:= rm.cantPersonas + cantPersonas;
    rm.totalEncuestados:= rm.totalEncuestados + totalEncuestados;

    Seek( maestro, FilePos(maestro) - 1 );
    Write( maestro, rm );
  end;

  Close( maestro );
  Close( detalle1 );
  Close( detalle2 );
end.