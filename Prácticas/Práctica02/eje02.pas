program eje02;

type
  REG_producto = record
    cod: string[4];
    stockActal, stockMin: integer;
    nombre: string;
    precio: real;
  end;

  REG_detalle = record
    cod: string[4]; 
    unidadesVendidas: integer;
  end;

  archivo_maestro = file of REG_producto;
  archivo_detalle = file of REG_detalle;


var
  maestro: archivo_maestro;
  detalle: archivo_detalle;
  minimoStock: Text;
  rm: REG_producto;
  rd: REG_detalle;
  codActual: string;
  totalVendido: integer;
begin
  Assign(maestro, 'maestro.dat');
  Assign(detalle, 'detalle.dat');
  Assign(minimoStock, 'stock_minimo.txt');

  Reset(maestro);
  Reset(detalle);
  Rewrite(minimoStock);

  if ( not Eof(maestro) ) then Read(maestro, rm);
  if ( not Eof(detalle) ) then Read(detalle, rd);

  while ( not eof(detalle) ) do begin
    codActual = rd.cod;
    totalVendido:= 0;

    while ( not eof(detalle) ) and ( rd.cod = codActual ) do begin
      totalVendido:= totalVendido + rd.unidadesVendidas;
      Real(detalle, rd);
    end;

    while ( rm.cod <> codActual) do
      Read(maestro, rm);

    // Inciso A
    rm:= rm.stockActal - totalVendido;

    Seek(maestro, filepos(maestro) - 1);
    Write(maestro, rm);

    // Inciso B
    if (rm.stockActal < rm.stockMin) then 
      writeln(minimoStock, rm.cod, ' ', rm.nombre, ' ', rm.stockActal);

  end;

  Close(maestro);
  Close(detalle);

  Close(minimoStock);
end.