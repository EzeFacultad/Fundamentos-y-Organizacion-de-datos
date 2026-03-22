program eje05;
type
  REG_celular = record
    cod, stockDisponible, stockMin: integer;
    precio: real;
    marca, descripcion, nombre: string;
  end;

  archivo_celulares = file of REG_celular;


// =================== Procesos
procedure leer(var r: REG_celular);
begin
  write('Codigo: ');
  read(r.cod);
  if (r.cod <> 0) then begin // Condición de corte inventada porque no especifican
    write('Precio: ');
    readln(r.precio);
    write('Marca: ');
    readln(r.marca);
    write('Stock diponible: ');
    readln(r.stockDisponible);
    write('Stock min: ');
    readln(r.stockMin);
    write('Descripcion: ');
    readln(r.descripcion);
    write('Nombre: ');
    readln(r.nombre);
  end;
end;

// ========= Opcion 1
procedure opcion1();
var
  archivo: archivo_celulares;
  celulares: Text;
  r: REG_celular;
  nombre: string;
begin
  assign(celulares, 'celulares.txt');
  reset(celulares);

  write('Nombre del archivo binario: ');
  readln(nombre);

  assign(archivo, nombre);
  rewrite(archivo);

  while(not eof(celulares)) do begin
    readln(celulares, r.cod, r.precio, r.marca);
    readln(celulares, r.stockDisponible, r.stockMin, r.descripcion);
    readln(celulares, r.nombre);
    write(archivo, r);
  end;

  close(archivo);
  close(celulares);
end;

// ===== Opcion 2
procedure opcion2();
var
  archivo: archivo_celulares;
  r: REG_celular;
  nombre: string;
begin
  write('Nombre del archivo binario: ');
  readln(nombre);

  assign(archivo, nombre);
  reset(archivo);

  while(not eof(archivo)) do begin
    read(archivo, r);
    if (r.stockDisponible < r.stockMin) then begin
      writeln('Cod: ',r.cod,' | Precio: $',r.precio:0:2,' | Marca: ',r.marca);
      writeln('Stock disponible: ',r.stockDisponible,' | Stock min.: ',r.stockMin);
      writeln('Nombre: ',r.nombre);
    end;
  end;

  close(archivo);
end;

// ===== Opcion 3
procedure opcion3();
var
  archivo: archivo_celulares;
  r: REG_celular;
  nombre, descripcion: string;
begin
  write('Nombre del archivo binario: ');
  readln(nombre);

  assign(archivo, nombre);
  reset(archivo);

  write('Proporcionar descripcion: ');
  readln(descripcion);

  while(not eof(archivo)) do begin
    read(archivo, r);
    if (pos(descripcion, r.descripcion) <> 0) then begin
      writeln('Cod: ',r.cod,' | Precio: $',r.precio:0:2,' | Marca: ',r.marca);
      writeln('Stock disponible: ',r.stockDisponible,' | Stock min.: ',r.stockMin,' | Descripcion: ',r.descripcion);
      writeln('Nombre: ',r.nombre);
    end;
  end;

  close(archivo);
end;

// ===== Opcion 4
procedure opcion4();
var
  archivo: archivo_celulares;
  r: REG_celular;
  nombre: string;
  celulares: Text;
begin
  write('Nombre del archivo binario: ');
  readln(nombre);

  assign(archivo, nombre);
  reset(archivo);

  assign(celulares, 'celulares_exp.txt');
  rewrite(celulares);

  while(not eof(archivo)) do begin
    read(archivo, r);
    
    writeln(celulares, r.cod,' ',r.precio:0:0,' ',r.marca);
    writeln(celulares, r.stockDisponible,' ',r.stockMin,' ',r.descripcion);
    writeln(celulares, r.nombre);
  end;

  close(archivo);
  close(celulares);
end;

// ===== Opcion 5
procedure opcion5();
var
  archivo: archivo_celulares;
  r: REG_celular;
  nombre: string;
begin
  write('Nombre del archivo binario: ');
  readln(nombre);

  assign(archivo, nombre);
  reset(archivo);

  seek(archivo, filesize(archivo));

  leer(r);
  while(r.cod <> 0) do begin
    write(archivo, r);
    leer(r);
  end;

  close(archivo);
end;

// ===== Opcion 6
procedure opcion6();
var
  archivo: archivo_celulares;
  r: REG_celular;
  nombre: string;
  cod: integer;
  cumple: boolean;
begin
  cumple:= true;

  write('Nombre del archivo binario: ');
  readln(nombre);

  assign(archivo, nombre);
  reset(archivo);

  write('Modificar stock disponible del celular con codigo: ');
  readln(cod);

  while(not eof(archivo)) and (cumple) do begin
    read(archivo, r);
    if (r.cod = cod) then begin
      seek(archivo, filepos(archivo) - 1);

      write('Establecer el nuevo disponible: ');
      readln(r.stockDisponible);

      write(archivo, r);
      cumple:= false;
    end;
  end;

  close(archivo);
end;

// ===== Opcion 7
procedure opcion7();
var
  archivo: archivo_celulares;
  r: REG_celular;
  nombre: string;
  sinStock: Text;
begin
  write('Nombre del archivo binario: ');
  readln(nombre);

  assign(archivo, nombre);
  reset(archivo);

  assign(sinStock, 'sinStock.txt');
  rewrite(sinStock);

  while(not eof(archivo)) do begin
    read(archivo, r);
    if (r.stockDisponible = 0) then begin
      writeln(sinStock,r.cod,' ',r.precio:0:0,' ',r.marca);
      writeln(sinStock,r.stockDisponible,' ',r.stockMin,' ',r.descripcion);
      writeln(sinStock,r.nombre);
    end;
  end;

  close(archivo);
  close(sinStock);
end;


// =================== Prog. principal
var
  opcion: integer;
  nombre: string;
begin
  opcion:= -1;

  writeln('===== Menu =====');
  while (opcion <> 0) do begin
    
    writeln('Elija una opcion:');

    writeln('1) Creacion y carga de archivo binario');
    writeln('2) Listar celulares con stock disponible menor al minimo');
    writeln('3) Listar celulares con descripcion proporcionada por usuario');
    writeln('4) Exportar a archivo de texto');
    writeln('5) Agregar celular/es');
    writeln('6) Modificar stock disponible');
    writeln('7) Exportar celulares SIN stock');
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

      0: begin
        writeln('Finalizando...');
      end;
    end;

  end;
end.