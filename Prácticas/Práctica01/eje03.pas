program eje03;

type
  REG_empleado = record
    nroEmpleado, edad: integer;
    dni: longint;
    apellido, nombre: string[30];
  end;

  archivo_empleado = file of REG_empleado;


// =================== Procesos
procedure leer(var r: REG_empleado);
begin
  write('Apellido: ');
  readln(r.apellido);
  if (r.apellido <> 'fin') then begin
    write('Nombre: ');
    readln(r.nombre);
    write('D.N.I: ');
    readln(r.dni);
    write('Edad: ');
    readln(r.edad);
    write('Nro. emplado: ');
    readln(r.nroEmpleado);
  end;
end;

// ===== Opcion 1
procedure opcion1(var a: archivo_empleado);
var
  r: REG_empleado;
  nombre: string;
begin
  write('Nombre del archivo: ');
  readln(nombre);
  assign(a, nombre);

  rewrite(a);
  leer(r);
  while (r.apellido <> 'fin') do begin
    write(a, r);
    leer(r);
  end;

  close(a);
end;

// ===== Opcion 2
procedure opcion2(var a: archivo_empleado);
var
  nombre, buscar: string;
  r: REG_empleado;
begin
  write('Ingresar nombre del archivo: ');
  readln(nombre);
  assign(a, nombre);

  write('Apellido o nombre a listar: ');
  readln(buscar);

  reset(a);

  while (not eof(a)) do begin
    read(a, r);
    if (r.apellido = buscar) or (r.nombre = buscar) then begin
      writeln('----------------------');
      writeln('Datos empleado: ');
      write('Apellido y nombre: ');
      writeln(r.apellido,' ',r.nombre);
      write('D.N.I: ');
      writeln(r.dni);
      write('Edad: ');
      writeln(r.edad);
      write('Nro. empleado: ');
      writeln(r.nroEmpleado);
      writeln('----------------------');
    end;
  end;

  close(a);
end;

// ===== Opcion 3
procedure opcion3(var a: archivo_empleado);
var
  nombre, buscar: string;
  r: REG_empleado;
begin
  write('Ingresar nombre del archivo: ');
  readln(nombre);
  assign(a, nombre);

  reset(a);

  writeln('----------------------');
  write('Apellido y nombre: ');
  while (not eof(a)) do begin
    read(a, r);
    writeln(r.apellido,' ',r.nombre);
  end;  
  
  writeln('----------------------');

  close(a);
end;

// ===== Opcion 4
procedure opcion4(var a: archivo_empleado);
var
  nombre, buscar: string;
  r: REG_empleado;
begin
  write('Ingresar nombre del archivo: ');
  readln(nombre);
  assign(a, nombre);

  reset(a);

  writeln('----------------------');
  write('Apellido y nombre proximos a jubilarse: ');
  while (not eof(a)) do begin
    read(a, r);
    if (r.edad >= 70) then
      writeln(r.apellido,' ',r.nombre);
  end;  
  
  writeln('----------------------');

  close(a);
end;

// =================== Prog. principal
var
  archivo: archivo_empleado;
  opcion: byte;
begin
  opcion:= -1;

  writeln('===== Menu =====');
  while (opcion <> 0) do begin
    writeln('Elija una opcion:');

    writeln('1) Crear y completar archivo');
    writeln('2) Listar empleados por apellido o nombre');
    writeln('3) Listar empleados');
    writeln('4) Listar empleados por jubilarse');
    writeln('0) Finalizar');

    write('Opcion: ');
    readln(opcion);

    case opcion of
      1: begin
        opcion1(archivo);
      end;

      2: begin
        opcion2(archivo);
      end;

      3: begin
        opcion3(archivo);
      end;

      4: begin
        opcion4(archivo);
      end;

      0: begin
        writeln('Finalizando...');
      end;
    end;
  end;
  
end.