program Ejercicio01;
const
  fin = -1;

type
  REG_empleado = record
    cod: integer;
    nombre: string;
    monto: real;
  end;

  archivo_empleado = file of REG_empleado;


procedure leer(var archivo: archivo_empleado; var dato: REG_empleado);
begin
  if (not eof(archivo)) then
    read(archivo, dato)
  else
    dato.cod:= fin;
end;

procedure inciso();
var
  nombre, nueNombre : string;
  archivo, nueArchivo: archivo_empleado;
  dato, emp: REG_empleado;
begin
  write('Nombre del archivoivo: ');
  readln(nombre);

  write('Nombre del nuevo archivoivo: ');
  readln(nueNombre);

  assign(archivo, nombre);
  assign(nueArchivo, nueNombre);

  reset(archivo);
  rewrite(nueArchivo);


  leer(archivo, dato);
  while (dato.cod <> fin) do begin
    emp.nombre:= dato.nombre;
    emp.cod:= dato.cod;
    emp.monto:= 0;

    while (dato.cod <> fin) and ( emp.cod = dato.cod ) do begin
      emp.monto:= emp.monto + dato.monto;
      
      leer(archivo, dato);
    end;

    write(nueArchivo, emp);
  end;

  close(archivo);
  close(nueArchivo);
end;


// ======= Prog. principal
begin
  inciso();  
end.