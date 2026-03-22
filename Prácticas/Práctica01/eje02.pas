program eje02;
type
  numeros_enteros = file of integer;

var
  archivo: numeros_enteros;
  nombre: string[20];
  min15k: integer;
  nro, cantNro, sumaNro: longint;
begin
  min15k:= 0;
  cantNro:= 0;
  sumaNro:= 0;

  write('Nombre del archivo a abrir: ');
  readln(nombre);

  assign(archivo, nombre);
  reset(archivo);

  writeln('===== Listado de numeros =====');
  while (not eof (archivo)) do begin
    read(archivo, nro);
    writeln(nro);

    // Cantidad de números mayores a 15000
    if (nro < 15000) then
      inc(min15k); 

    // Para calcular el promedio
    sumaNro:= sumaNro + nro;
    inc(cantNro);
  end;

  close(archivo);

  writeln('=======================');
  writeln('Cantidad de nro menores a 15000: ',min15k);
  writeln('El numero promedio: ',(sumaNro/cantNro):0:0);
end.