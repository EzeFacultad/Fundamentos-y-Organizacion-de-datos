program eje05;
type
  REG_celular = record
    cod, stockDisponible, stockMin: integer;
    precio: real;
    marca, descripcion, nombre: string;
  end;

  archivo_celulares = file of REG_celular;


// =================== Procesos
// ===== Opcion 1
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
    
    writeln(celulares,r.cod,' ',r.precio:0:0,' ',r.marca);
    writeln(celulares,r.stockDisponible,' ',r.stockMin,' ',r.descripcion);
    writeln(celulares,r.nombre);
  end;

  close(archivo);
  close(celulares);
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

    writeln('1) Creacion y carga de');
    writeln('2) Listar celulares con stock disponible menor al minimo');
    writeln('3) Listar celulares con descripcion proporcionada por usuario');
    writeln('4) Exportar a archivo de texto');
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

      0: begin
        writeln('Finalizando...');
      end;
    end;

  end;
end.