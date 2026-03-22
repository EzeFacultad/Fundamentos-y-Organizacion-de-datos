program eje07;
type
  REG_novela = record
    cod: integer;
    nombre, genero: string;
    precio: real;
  end;

  archivo_novela = file of REG_novela;


// =================== Procesos
procedure leer(var r: REG_novela);
begin
  write('Codigo: ');
  readln(r.cod);
  write('Precio: ');
  readln(r.precio);
  write('Genero: ');
  readln(r.genero);
  write('Nombre: ');
  readln(r.nombre);
end;

// ========= Inciso A
procedure crearArchivo();
var
  archivo: archivo_novela;
  novelas: Text;
  nombre: string;
  r: REG_novela;
begin
  assign(novelas, 'novelas.txt');
  reset(novelas);

  write('Nombre el archivo binario: ');
  readln(nombre);
  assign(archivo, nombre);
  rewrite(archivo);

  while (not eof(novelas)) do begin
    readln(novelas,r.cod, r.precio, r.genero);
    readln(novelas,r.nombre);
    write(archivo, r);
  end;

  close(novelas);
  close(archivo);
end;

// ========= Inciso B
procedure agregaryModificar();
  procedure agregar(var a: archivo_novela);
  var
    r: REG_novela;
  begin
    writeln('===== Agregar nueva novela ====');
    leer(r);
    writeln('===============================');

    seek(a, filesize(a));
    write(a, r);
  end;

  procedure modificar(var a: archivo_novela);
  var
    r: REG_novela;
    cod, opcion: integer;
    fin, editar: boolean;
  begin
    reset(a);
    writeln('===== Modificar novela ====');
    write('Codigo de la novela a modificar: ');
    readln(cod);

    fin:= false;
    while (not eof(a)) and (not fin) do begin

      read(a, r);

      if (r.cod = cod) then begin
        fin:= true;
        editar:= true;
        while (editar) do begin
          writeln('======= Editar =======');
          writeln('1) Codigo');
          writeln('2) Precio');
          writeln('3) Genero');
          writeln('4) Nombre');
          writeln();
          writeln('0) Finalizar');

          write('Opcion a editar: ');
          readln(opcion);

          case opcion of
            1: begin
              write('Nuevo codigo: ');
              readln(r.cod);
            end;

            2: begin
              write('Nuevo precio: ');
              readln(r.precio);
            end;

            3: begin
              write('Nuevo genero: ');
              readln(r.genero);
            end;

            4: begin
              write('Nuevo nombre: ');
              readln(r.nombre);
            end;

            0: begin
              writeln('Finalizando...');
              editar:= false;
            end;

          end;
        end;

        seek(a, filepos(a) - 1);
        write(a, r);
      end;
    end;
    writeln('===============================');
  end;

var
  archivo: archivo_novela;
  nombre: string;
begin
  write('Nombre del archivo binario para abrir: ');
  readln(nombre);

  assign(archivo, nombre);
  reset(archivo);
  
  agregar(archivo);
  modificar(archivo);

  close(archivo);

end;


// =================== Prog. principal
begin
  crearArchivo();
  agregaryModificar();
end.