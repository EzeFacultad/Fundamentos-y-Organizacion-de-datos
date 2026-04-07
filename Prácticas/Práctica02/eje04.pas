program eje04;
const
  dimF = 30;
  fin = 9999;

type
  REG_maestro = record
    cod: integer;
    nombre: string[20];
    descripcion: string[50];
    stockDisponible, stockMinimo: integer;
    precio: real;
  end;

  REG_detalle = record
    cod: integer;
    cantVendida: integer;
  end;

  archivo_maestro = file of REG_maestro;
  archivo_detalle = file of REG_detalle;

  vector_archivos = array [1..dimF] of archivo_detalle;
  vector_registros = array [1..dimF] of REG_detalle;

// Leer el archivo
procedure leer( var archivo: archivo_detalle; var dato: REG_detalle );
begin
  if ( not Eof(archivo) ) then
    Read( archivo, dato )
  else
    dato.cod:= fin;
end;

// Guardar el minimo
procedure minimo(var vArch: vector_archivos; var vReg: vector_registros; var min: REG_detalle);
var
  i, pos: integer;
begin
  min.cod := fin;
  pos := -1;

  for i := 1 to dimF do begin
    if (vReg[i].cod < min.cod) then begin
      min := vReg[i];
      pos := i;
    end;
  end;

  if (pos <> -1) then
    leer(vArch[pos], vReg[pos]);
end;

var
  maestro: archivo_maestro;
  vArch: vector_archivos;
  vReg: vector_registros;
  min: REG_detalle;
  rm: REG_maestro;
  i, totalVendido, codActual: integer;
  txt: Text;

begin
  Assign( maestro, 'maestro' );
  Reset( maestro );
  
  Assign( txt, 'stock_minimo.txt' );
  Rewrite( txt );

  for i:=1 to 30 do begin
    Assign( vArch[i], 'detalle' + i );
    Reset ( vArch[i] );
    leer( vArch[i], vReg[i] );
  end;
  

  minimo( vArch, vReg, min );

  Read( maestro, rm );

  while ( min.cod <> fin ) do begin
    // Buscar en el archivo maestro
    while ( not Eof(maestro) ) and ( rm.cod <> min.cod ) do
      Read( maestro, rm );

    totalVendido:= 0;
    codActual:= min.cod;
    
    while ( min.cod = cod ) do begin
      totalVendido:= totalVendido + min.cantVendida;
      minimo( vArch, vReg, min );
    end;

    rm.stockDisponible:= rm.stockDisponible - totalVendido;

    Seek( maestro, FilePos(maestro) - 1 );
    Write( maestro, rm );

    if ( rm.stockDisponible < rm.stockMinimo ) then begin
      writeln( txt, 'Nomnbre: ', rm.nombre );
      writeln( txt, 'Descripcion: ', rm.descripcion );
      writeln( txt, 'Stocl disponible: ', rm.stockDisponible );
      writeln( txt, 'Precio: ', rm.precio );
    end;
  end;

  Close( maestro );
  Close( txt );
  for i:=1 to 30 do
    Close( vArch[i] );
end.