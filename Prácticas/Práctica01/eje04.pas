program eje04;

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
procedure opcion1();
var
  a: archivo_empleado;
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
procedure opcion2();
var
  a: archivo_empleado;
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
procedure opcion3();
var
  a: archivo_empleado;
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
procedure opcion4();
var
  a: archivo_empleado;
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

// ===== Opcion 5
procedure opcion5();
var
  a: archivo_empleado;
  nombre, buscar: string;
  r,r2: REG_empleado;
  cumple: boolean;
begin
  write('Ingresar nombre del archivo: ');
  readln(nombre);
  assign(a, nombre);

  leer(r);
  while (r.apellido <> 'fin') do begin
    cumple:= true;

    reset(a); // Volver al inicio

    while (not eof(a)) and (cumple) do begin
      read(a, r2);
      if (r2.nroEmpleado = r.nroEmpleado) then begin
        writeln('Nro empleado ya utilizado');
        cumple:= false;
      end;
    end;

    if (cumple) then begin
      seek(a, filesize(a)); // ir al final
      write(a, r);
    end;

    leer(r);
  end;

  close(a);
end;

// ===== Opcion 6
procedure opcion6();
var
  a: archivo_empleado;
  nombre, buscarNom, buscarApe: string;
  r: REG_empleado;
  cumple: boolean;
begin
  write('Ingresar nombre del archivo: ');
  readln(nombre);
  assign(a, nombre);

  reset(a);

  write('Apellido: ');
  readln(buscarApe);
  write('Nombre: ');
  readln(buscarNom);

  while (not eof(a)) and (cumple) do begin
    read(a, r);
    if (r.apellido = buscarApe) and (r.nombre = buscarNom) then begin
      read(a, r); // Al hacer read, luego de guardarse el dato, pasa a la sig. posición

      write('Ingresar nueva edad: ');
      readln(r.edad);

      seek(a, filepos(a) - 1); // Volver una posición
      write(a, r);

      cumple:= false;
    end;
  end;  

  close(a);
end;

// ===== Opcion 7
procedure opcion7();
var
  a: archivo_empleado;
  nombre: string;
  r: REG_empleado;
  t: Text;
begin
  write('Ingresar nombre del archivo: ');
  readln(nombre);
  assign(a, nombre);
  assign(t, 'todos_empleados.txt');

  reset(a);
  rewrite(t);
  
  while (not eof(a)) do begin
    read(a, r);
    writeln(t, r.apellido,' ',r.nombre,' ',r.dni,' ',r.edad,' ',r.nroEmpleado);
  end;  

  close(a);
  close(t);
end;

// ===== Opcion 8
procedure opcion8();
var
  a: archivo_empleado;
  nombre: string;
  r: REG_empleado;
  t: Text;  
begin
  write('Ingresar nombre del archivo: ');
  readln(nombre);
  assign(a, nombre);
  assign(t, 'faltaDNIEmpleado.txt');

  reset(a);
  rewrite(t);
  
  while (not eof(a)) do begin
    read(a, r);

    if (r.dni = 0) then
      writeln(t, r.apellido,' ',r.nombre,' ',r.dni,' ',r.edad,' ',r.nroEmpleado);
  end;  

  close(a);
  close(t);
end;


// =================== Prog. principal
var
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
    writeln('5) Agregar empleado/s');
    writeln('6) Cambiar edad de empleado');
    writeln('7) Exportar a txt');
    writeln('8) Exportar a txt empleados sin D.N.I');
    writeln();
    writeln('0) Finalizar');

    write('Opcion: ');
    readln(opcion);

    case opcion of
      1: begin
        opcion1();
      end;

      2: begin
        opcion2();
      end;

      3: begin
        opcion3();
      end;

      4: begin
        opcion4();
      end;

      5: begin
        opcion5();
      end;

      6: begin
        opcion6();
      end;

      7: begin
        opcion7();
      end;

      8: begin
        opcion8();
      end;

      0: begin
        writeln('Finalizando...');
      end;
    end;
  end;
  
end.