{ En este ejemplo se crea un archivo maestro que almacena la información de los 3 archivos: det1, det2 y det3.
 Cada archivo se encuentra ordenada por nombre de alumno y un alumno no se repeti, está solamente en UN "det" }
program Ejemplo_merge_union_de_archivos;

const
  valoralto = 'zzzz';

type
  str30 = string [30];
  str10 = string [10];

  alumno = record
    nombre: str30;
    dni: str10;
    direccion: str30;
    carrera: str10;
  end;

  detalle = file of alumno;

var
  min,regd1,regd2,regd3: alumno;
  det1,det2,det3,maestro : detalle;

{ si el archivo recibido sigue teniendo alumnos, se obtiene ese alumno. 
  Si no tiene, se asigna la condicion de corte a dato.nombre }
procedure leer ( var archivo:detalle ; var dato: alumno);
begin
  if not eof ( archivo ) then
    read (archivo, dato)
  else
    dato.nombre := valoralto
end;

{ compara cuál de los 3 registros recibido tiene el nombre "mas chico" }
procedure minimo (var r1,r2,r3:alumno; var min:alumno);
begin
  { luego de guardar en "min" el registro que corresponde, por ejemplo si en "min" se guarda el registro "r1",
  se vuelve a llamar a "leer" para que en "r1" quede guardado un nuevo alumno. Entonces cuando se vuelva a llamar
  a este proceso, ahora las comparaciones van a ser con los 2 alumnos que quedaron anteriormente "r2 y r3" y el nuevo
  alumno "r1". De esta manera se van recorriendo los 3 archivos con alumnos y obteniendo siempre el alumno "mas chico" }
  if (r1.nombre<r2.nombre) and (r1.nombre<r3.nombre ) then begin
    min := r1;
    leer(det1,r1)
  end
  else
    if (r2.nombre<r3.nombre ) then
      begin
        min := r2;
        leer(det2,r2)
      end
    else
      begin
        min := r3;
        leer(det3,r3)
      end
end;

begin
  assign(det1, 'det1');
  assign(det2, 'det2');
  assign(det3, 'det2');
  assign(maestro, 'maestro');

  rewrite(maestro);
  reset (det1); reset (det2); reset (det3);

  leer(det1, regd1); leer(det2, regd2); leer(det3, regd3);
  minimo(regd1, regd2, regd3, min);
  { se procesan los tres archivos }
  while (min.nombre <> valoralto ) do begin
    write ( maestro,min );
    minimo( regd1,regd2,regd3, min);
  end;
  close(maestro);
end.