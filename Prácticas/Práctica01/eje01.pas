program eje01;

type
  numeros_enteros = file of integer;

var
  archivo: numeros_enteros;
  nombre: string[20];
  nro: longint;
begin
  write('Ingresar nombre del archivo: ');
  readln(nombre);

  assign(archivo, nombre);
  rewrite(archivo);
  
  write('Ingresar numero: ');
  readln(nro);

  while (nro <> 30000) do begin
    write(archivo, nro);

    write('Ingresar numero: ');
    readln(nro);
  end;
  close(archivo);
end.