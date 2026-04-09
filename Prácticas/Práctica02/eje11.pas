program eje11;
const
  fin = 'terminar';
  dimF = 15;
  
type
  REG_empleado = record
    departamento, division: string[30];
    numEmpleado, categoria, cantHoras: integer;
  end;

  archivo_empleado = file of REG_empleado;

  vector_categoria = array [1..dimF] of real;


// Cargar vector valor
procedure cargarVector( var v: vector_categoria );
var
  categoria: integer;
  valor: real;
  texto: Text;
begin
  Assign( texto, 'valorHora.txt' );
  Reset( texto );

  while ( not Eof(texto) ) do begin
    Readln( texto, categoria, valor );
    v[categoria]:= valor;
  end;

  Close( texto );
end;

// Leer dato del archivo
procedure leer( var arch: archivo_empleado; var dato: REG_empleado );
begin
  if ( not Eof(arch) ) then
    Read( arch, dato )
  else
    dato.departamento:= fin;
end;

// Analizar archivos
procedure analizarArchivo( var arch: archivo_empleado; v: vector_categoria );
var
  ra: REG_empleado;
  departamento, division: string[30];
  numEmpleado, horasDivision, totalHorasDepartamento: integer;
  monto, montoDivision, montoTotalDepartamento: real;
begin
  leer( arch, ra );

  while ( ra.departamento <> fin ) do begin

    // Corte control DEPARTAMENTO
    departamento:= ra.departamento;
    totalHorasDepartamento:= 0;
    montoTotalDepartamento:= 0;

    WriteLn( 'Departamento: ', departamento );

    while ( ra.departamento = departamento ) do begin

      // Corte control DIVISION
      division:= ra.division;
      horasDivision:= 0;
      montoDivision:= 0;

      WriteLn( 'Division: ', ra.division );
      WriteLn( 'Numero de Empleado', '          ','Total de Hs.','          ','Importe a cobrar' );
      while ( ra.departamento = departamento ) and ( ra.division = division ) do begin
        
        monto:= ra.cantHoras * v[ra.categoria];
        horasDivision:= totalHorasDivision + ra.cantHoras;
        montoDivision:= montoDivision + monto;

        writeln( ra.numEmpleado,'          ',rm.cantHoras,'          ',monto );

        leer( arch, ra );
      end;
      
      WriteLn( 'Total horas division: ', horasDivision );
      WriteLn( 'Monto total division: ', montoDivision );

      totalHorasDepartamento:= totalHorasDepartamento + horasDivision;
      montoTotalDepartamento:= montoTotalDepartamento + montoDivision;
    end;  

    WriteLn( 'Total horas departamento: ', totalHorasDepartamento );
    WriteLn( 'Monto total departamento: ', montoTotalDepartamento );
  end;
end;

// Programa principal
var
  arch: archivo_empleado;
  v: vector_categoria;

begin
  cargarVector( v );

  Assign( arch, 'empleados' );
  Reset( arch );

  analizarArchivo( arch, v );

  Close( arch );
end.