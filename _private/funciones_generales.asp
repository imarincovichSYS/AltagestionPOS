<%
sub Eliminar_Temporales(RutaInf_tmp,user_tmp)
  'Elimina Todos Los informes temporales creados por el usuario
  Set MyDirectory=Server.CreateObject("Scripting.FileSystemObject")
  Set MyFiles=MyDirectory.GetFolder(Server.MapPath(RutaInf_tmp))
  for each filefound in MyFiles.files
    FileName = fileFound.Path
    if instr(CStr(FileName), user_tmp)<> 0 then
      Set fs = CreateObject("Scripting.FileSystemObject")
      on error resume next
      fs.DeleteFile FileName, True
    end if
  next
end sub

'********************************************************
'Obtener nombre Mes según el numero
'********************************************************
function getMes(num)
  Select Case num
    Case 1 name ="Enero"
    Case 2 name = "Febrero"
    Case 3 name = "Marzo"
    Case 4 name = "Abril"
    Case 5 name = "Mayo"
    Case 6 name = "Junio"
    Case 7 name = "Julio"
    Case 8 name = "Agosto"
    Case 9 name = "Septiembre"
    Case 10 name = "Octubre"
    Case 11 name = "Noviembre"
    Case 12 name = "Diciembre"
  end Select
  getMes = name
end function

function getMesCorto(num)
  Select Case num
    Case 1 name ="Ene"
    Case 2 name = "Feb"
    Case 3 name = "Mar"
    Case 4 name = "Abr"
    Case 5 name = "May"
    Case 6 name = "Jun"
    Case 7 name = "Jul"
    Case 8 name = "Ago"
    Case 9 name = "Sep"
    Case 10 name = "Oct"
    Case 11 name = "Nov"
    Case 12 name = "Dic"
  end Select
  getMesCorto = name
end function

function getDiaSemana(num)
  Select Case num
    Case 1 name ="Lunes"
    Case 2 name = "Martes"
    Case 3 name = "Miercoles"
    Case 4 name = "Jueves"
    Case 5 name = "Viernes"
    Case 6 name = "Sabado"
    Case 7 name = "Domingo"
  end Select
  getDiaSemana = name
end function

'*******************************************************
'Obtener la cantidad de dias para una fecha determinada
'*******************************************************
function GetMaxDias(fecha)
  m=month(fecha)
  a=year(fecha)
  select case m
    case 1,3,5,7,8,10,12
      maxDias=31
    case 4,6,9,11
      maxDias=30
    case 2
      if a Mod 4 = 0 then
        maxDias=29
      else
        maxDias=28
      end if
  end select
  GetMaxDias=maxDias
end function

'Border una celda de Excel
sub Bordear(Area, EstiloLinea)
  Area.borders(8).LineStyle = EstiloLinea 'Arriba
  Area.borders(9).LineStyle = EstiloLinea 'Abajo
  Area.borders(7).LineStyle = EstiloLinea 'Borde Izquierdo
  Area.borders(10).LineStyle = EstiloLinea 'Borde Derecho         
end sub

'Bordear celdas completas en una fila determina y entre que columnas 
sub Bordear_celdas(row,ini,fin)
  for k=cint(ini) to cint(fin)
    ExcelBook.Worksheets(1).cells(row, k).borders(8).LineStyle = 1'Arriba
    ExcelBook.Worksheets(1).cells(row, k).borders(9).LineStyle = 1'Abajo
    ExcelBook.Worksheets(1).cells(row, k).borders(7).LineStyle = 1'Izquierda
    ExcelBook.Worksheets(1).cells(row, k).borders(10).LineStyle = 1'Derecha
  next
end sub

'Bordear celdas completas en una fila determina y entre que columnas para una Hoja cualquiera
sub Bordear_celdas_hoja(h,row,ini,fin)
  for k=cint(ini) to cint(fin)
    ExcelBook.Worksheets(h).cells(row, k).borders(8).LineStyle = 1'Arriba
    ExcelBook.Worksheets(h).cells(row, k).borders(9).LineStyle = 1'Abajo
    ExcelBook.Worksheets(h).cells(row, k).borders(7).LineStyle = 1'Izquierda
    ExcelBook.Worksheets(h).cells(row, k).borders(10).LineStyle = 1'Derecha
  next
end sub

function IFF(cond, ifTrue, ifFalse)
	if cond then
		IFF = ifTrue
	else
		IFF = ifFalse
	end if
end function

function Nvl(expression, r_value)
  Nvl = r_value
  if IsNull(expression) then exit function
  if Trim(expression) = "" then exit function
  Nvl = expression
end function

'Rellena Caracteres por la Izquerda
function LPad(Cadena, Largo, Caracter)
   LPad = Cadena
   For j = Len(Cadena) To Largo - 1
      LPad = Mid(Caracter, 1, 1) & LPad
   Next
end function

'Rellena Caracteres por la Derecha
function RPad(Cadena, Largo, Caracter)
   RPad = Cadena
   For j = Len(Cadena) To Largo - 1
      RPad = RPad & Mid(Caracter, 1, 1)
   Next
end function

function Cambiar_Caracteres_Especiales_Texto(texto_tmp)
  Dim caracteres_especiales(10,1)
  caracteres_especiales(0,0) = "Á" : caracteres_especiales(0,1) = "A"
  caracteres_especiales(1,0) = "É" : caracteres_especiales(1,1) = "E"
  caracteres_especiales(2,0) = "Í" : caracteres_especiales(2,1) = "I"
  caracteres_especiales(3,0) = "Ó" : caracteres_especiales(3,1) = "O"
  caracteres_especiales(4,0) = "Ú" : caracteres_especiales(4,1) = "U"
  caracteres_especiales(5,0) = "À" : caracteres_especiales(5,1) = "A"
  caracteres_especiales(6,0) = "È" : caracteres_especiales(6,1) = "E"
  caracteres_especiales(7,0) = "Ì" : caracteres_especiales(7,1) = "I"
  caracteres_especiales(8,0) = "Ò" : caracteres_especiales(8,1) = "O"
  caracteres_especiales(9,0) = "Ù" : caracteres_especiales(9,1) = "U"
  caracteres_especiales(10,0) = "Ñ" : caracteres_especiales(10,1) = "&Ntilde;"
  for cant_caracteres = 0 to Ubound(caracteres_especiales)
    texto_tmp = replace(texto_tmp,caracteres_especiales(cant_caracteres,0),caracteres_especiales(cant_caracteres,1))
  next
  Cambiar_Caracteres_Especiales_Texto = texto_tmp
end function

function Get_Texto_Tipo_Oracion(texto_tmp)
  texto = ""
  if not IsNull(texto_tmp) or texto_tmp<>"" then
    array_texto=split(lcase(trim(texto_tmp))," ")
    for cont_text_tipo_oracion=0 to ubound(array_texto)
      largo_tmp = len(array_texto(cont_text_tipo_oracion))
      primera_letra = left(array_texto(cont_text_tipo_oracion),1)
      if trim(array_texto(cont_text_tipo_oracion))<>"" then
        resto_palabra = right(array_texto(cont_text_tipo_oracion),cint(largo_tmp)-1)
        texto = texto&" "&Ucase(primera_letra)&resto_palabra
      end if
    next
  end if
  Get_Texto_Tipo_Oracion = trim(texto)
end function

function Get_Digito_Verificador_Rut(rut_tmp)
  tur=strreverse(rut_tmp) : mult = 2 
  for i = 1 to len(tur) 
    if mult > 7 then mult = 2 end if 
    suma = mult * mid(tur,i,1) + suma 
    mult = mult +1 
  next 
  valor = 11 - (suma mod 11)
  if valor = 11 then 
    Get_Digito_Verificador_Rut = "0" 
  elseif valor = 10 then 
    Get_Digito_Verificador_Rut = "k" 
  else 
    Get_Digito_Verificador_Rut = valor 
  end if 
end function 

function GetTime(tot_segundos_tmp)
  horas = int(cdbl(tot_segundos_tmp)/ 3600)
  if horas > 0 then
    segundos  = cdbl(tot_segundos_tmp) mod 3600
    minutos   = int(cdbl(segundos) / 60)
    segundos  = segundos mod 60
  else
    minutos   = int(cdbl(tot_segundos_tmp) / 60)
    segundos  = cdbl(tot_segundos_tmp) mod 60
  end if
  GetTime = Lpad(horas,2,0)&":"&Lpad(minutos,2,0)&":"&Lpad(segundos,2,0)
end function

sub Cargar_Diccionario(obj_dict,v_strSQL)
  set rs_dict = Conn.Execute(v_strSQL)
  do while not rs_dict.EOF
    'Response.Write trim(rs_dict("text"))&","&trim(rs_dict("value"))&"<br>"
    obj_dict.Add trim(rs_dict("value")),trim(rs_dict("text"))
    rs_dict.MoveNext
  loop
  'Response.End
end sub

function Get_Fecha_Hoy()
  c_dia = day(date())
  c_mes = month(date())
  c_anio = year(date())
  Get_Fecha_Hoy = Lpad(c_dia,2,0)&"/"&Lpad(c_mes,2,0)&"/"&c_anio
end function

function Get_Version_Navegador()
  browserInfo = Ucase(Request.ServerVariables("HTTP_USER_AGENT"))
  if InStr(browserInfo,"MSI") then
    arg_version = split(Right(browserInfo,len(browserInfo)-InStr(browserInfo,"MSI")+1),";")
    v = arg_version(0)
  elseif InStr(browserInfo,"FIREFOX") then
    arg_version = split(Right(browserInfo,len(browserInfo)-InStr(browserInfo,"FIREFOX")+1),";")
    v = arg_version(0)
  elseif InStr(browserInfo,"CHROME") then
    arg_version = split(Right(browserInfo,len(browserInfo)-InStr(browserInfo,"CHROME")+1)," ")
    v = arg_version(0)
  else
    v = "Desconocida"
  end if
  Get_Version_Navegador = v
end function

Function FechaDDMMAA(Fecha)
	if not isDate(Fecha) or len(Fecha)<>10 then	
		FechaDDMMAA = ""
		Exit Function
	end if
	cad = ""
	dia = left(Fecha,2)	
	mes = mid(Fecha,4,2)
	ano = mid(Fecha,9,2)
	if mes > 12 then
		FechaDDMMAA = ""
		Exit Function
	end if
	cad = dia & "/" & mes & "/" & ano
	FechaDDMMAA = cad
End Function

%>