{TRABAJO PRÁCTICO N° 4.1}
{EJERCICIO 9}
{Modificar la solución del punto anterior considerando que el programa lea y almacene la información de, a lo sumo, 400 alumnos.
La lectura finaliza cuando se ingresa el DNI -1 (que no debe procesarse).}

program TP4_E9;
{$codepage UTF8}
uses crt;
const
  alumnos_total=400;
  dni_salida=-1;
type
  t_alumno=1..alumnos_total;
  t_registro_alumno=record
    numero: int16;
    dni: int32;
    apellido: string;
    nombre: string;
    nacimiento: int16;
  end;
  t_vector_alumnos=array[t_alumno] of t_registro_alumno;
function random_string(length: int8): string;
var
  i: int8;
  string_aux: string;
begin
  string_aux:='';
  for i:= 1 to length do
    string_aux:=string_aux+chr(ord('A')+random(26));
  random_string:=string_aux;
end;
procedure leer_alumno(var registro_alumno: t_registro_alumno);
var
  i: int8;
begin
  i:=random(100);
  if (i=0) then
    registro_alumno.dni:=dni_salida
  else
    registro_alumno.dni:=10000000+random(40000001);
  if (registro_alumno.dni<>dni_salida) then
  begin
    registro_alumno.numero:=1+random(high(int16));
    registro_alumno.apellido:=random_string(5+random(6));
    registro_alumno.nombre:=random_string(5+random(6));
    registro_alumno.nacimiento:=(2020-18)-random(10);
  end;
end;
procedure cargar_vector_alumnos(var vector_alumnos: t_vector_alumnos; var alumnos: int16);
var
  registro_alumno: t_registro_alumno;
begin
  leer_alumno(registro_alumno);
  while ((registro_alumno.dni<>dni_salida) and (alumnos<alumnos_total)) do
  begin
    alumnos:=alumnos+1;
    vector_alumnos[alumnos]:=registro_alumno;
    leer_alumno(registro_alumno);
  end;
end;
function hay_impar(dni: int32): boolean;
var
  digito: int8;
  impar: boolean;
begin
  impar:=false;
  while ((dni<>0) and (impar<>true)) do
  begin
    digito:=dni mod 10;
    impar:=(digito mod 2<>0);
    dni:=dni div 10;
  end;
  hay_impar:=impar;
end;
procedure actualizar_minimos(nacimiento: int16; apellido, nombre: string ; var nacimiento_min1, nacimiento_min2: int16; var apellido_min1, nombre_min1, apellido_min2, nombre_min2: string);
begin
  if (nacimiento<nacimiento_min1) then
  begin
    nacimiento_min2:=nacimiento_min1;
    apellido_min2:=apellido_min1;
    nombre_min2:=nombre_min1;
    nacimiento_min1:=nacimiento;
    apellido_min1:=apellido;
    nombre_min1:=nombre;
  end
  else
    if (nacimiento<nacimiento_min2) then
    begin
      nacimiento_min2:=nacimiento;
      apellido_min2:=apellido;
      nombre_min2:=nombre;
    end;
end;
procedure procesar_vector_alumnos(vector_alumnos: t_vector_alumnos; alumnos: int16; var porcentaje_pares: real; var apellido_min1, nombre_min1, apellido_min2, nombre_min2: string);
var
  i: t_alumno;
  alumnos_pares, nacimiento_min1, nacimiento_min2: int16;
begin
  alumnos_pares:=0;
  nacimiento_min1:=high(int16); nacimiento_min2:=high(int16);
  for i:= 1 to alumnos do
  begin
    if (hay_impar(vector_alumnos[i].dni)=false) then
      alumnos_pares:=alumnos_pares+1;
    actualizar_minimos(vector_alumnos[i].nacimiento,vector_alumnos[i].apellido,vector_alumnos[i].nombre,nacimiento_min1,nacimiento_min2,apellido_min1,nombre_min1,apellido_min2,nombre_min2);
  end;
  if (alumnos>0) then
    porcentaje_pares:=alumnos_pares/alumnos*100;
end;
var
  vector_alumnos: t_vector_alumnos;
  alumnos: int16;
  porcentaje_pares: real;
  apellido_min1, nombre_min1, apellido_min2, nombre_min2: string;
begin
  randomize;
  alumnos:=0;
  porcentaje_pares:=0;
  apellido_min1:=''; nombre_min1:=''; apellido_min2:=''; nombre_min2:='';
  cargar_vector_alumnos(vector_alumnos,alumnos);
  if (alumnos>0) then
  begin
    procesar_vector_alumnos(vector_alumnos,alumnos,porcentaje_pares,apellido_min1,nombre_min1,apellido_min2,nombre_min2);
    textcolor(green); write('El porcentaje de alumnos con DNI compuesto sólo por dígitos pares es '); textcolor(red); write(porcentaje_pares:0:2); textcolor(green); writeln('%');
    textcolor(green); write('El apellido y nombre de los dos alumnos de mayor edad son '); textcolor(red); write(apellido_min1,' ',nombre_min1); textcolor(green); write(' y '); textcolor(red); write(apellido_min2,' ',nombre_min2);
  end;
end.