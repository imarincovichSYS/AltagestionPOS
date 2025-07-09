
<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">

Sub Estilos(abonado)
 Select case Abonado
        Case "" 
		   response.write "<LINK REL='STYLESHEET' HREF='../../Includes/Estilos_publico.css' TYPE='text/css'>"
		Case else
		   response.write "<LINK REL='STYLESHEET' HREF='../../Includes/Estilos.css' TYPE='text/css'>"
 End Select
End Sub

Function cambia_fecha (fecha_in)
  if isnull(fecha_in) then
    cambia_fecha= ""
  else
    nAM=Instr(fecha_in,"AM")
    nPM=Instr(fecha_in,"PM")
	if nAM > 0 then	fecha_in=MID(fecha_in,1,nAM -1)
	if nPM > 0 then	fecha_in=MID(fecha_in,1,nPM -1) 
    fecha1 = cDate(fecha_in)
	if InStr(fecha_in,":")=0 then
	  hora1=""
    else
     hora1 = Mid(fecha_in,InStr(fecha_in,":")-3)  
    end if

    dia=Day(fecha1)
    mes=Month(fecha1)
    ano=Year(fecha1)
    cambia_fecha=ano & "/" & mes & "/" & dia & hora1
  end if
End Function

Function cambia_fecha_americana (fecha_in)
  if isnull(fecha_in) then
    cambia_fecha_americana = ""
  else
    nAM=Instr(fecha_in,"AM")
    nPM=Instr(fecha_in,"PM")
	if nAM > 0 then	fecha_in=MID(fecha_in,1,nAM -1)
	if nPM > 0 then	fecha_in=MID(fecha_in,1,nPM -1) 
    fecha1 = cDate(fecha_in)
	if InStr(fecha_in,":")=0 then
	  hora1=""
    else
     hora1 = Mid(fecha_in,InStr(fecha_in,":")-3)  
    end if

    dia=Day(fecha1)
    mes=Month(fecha1)
    ano=Year(fecha1)
      cambia_fecha_americana = dia & "/" & mes & "/" & ano
  end if
End Function

Function Cambia_idioma_mes(mes)
select case mes
case "enero" nombre ="Jan"
case "febrero" nombre ="Feb"
case "marzo" nombre ="Mar"
case "abril" nombre ="Apr"
case "mayo" nombre ="May"
case "junio" nombre ="Jun"
case "julio" nombre ="Jul"
case "agosto" nombre ="Aug"
case "septiembre" nombre ="Sep"
case "octubre" nombre ="Oct"
case "noviembre" nombre ="Nov"
case "diciembre" nombre ="Dec"
end select
Cambia_idioma_mes = nombre
End Function




Function Nombre_mes_castellano(mes)
select case mes
 case "01" nombre ="Enero"
    case "02" nombre ="Febrero"
    case "03" nombre ="Marzo"
    case "04" nombre ="Abril"
    case "05" nombre ="Mayo"
    case "06" nombre ="Junio"
    case "07" nombre ="Julio"
    case "08" nombre ="Agosto"
    case "09" nombre ="Septiembre"
    case "10" nombre ="Octubre"
    case "11" nombre ="Noviembre"
    case "12" nombre ="Diciembre"
end select
Nombre_mes_castellano = nombre
End Function

Function cambia_formato_fecha (fecha_in)
if isnull(fecha_in) then
 cambia_formato_fecha= ""
else
 fecha=Cdate(fecha_in)
 dia=Day(fecha)
 mes = Month(fecha)
 nombre_mes=Cambia_idioma_mes(MonthName(mes))
 ano=Year(fecha)
 cambia_formato_fecha=nombre_mes & " " & dia & " " & ano
end if
End Function

Function ValidaRut(Rut,Digito)

   DigitoCorrecto = ""

   If not isnumeric(Rut) then 
      ValidaRut = False
      exit function
   End if

   largo = len(trim(Rut))

   If largo > 8 or largo < 7 then
      ValidaRut = False
      exit function
   End If

   desde   = largo
   lasuma  = 0

   For n = 0 to 5
       lasuma = lasuma + Mid(Rut,desde - n,1) * (n + 2)
   Next

   lasuma = lasuma + mid(Rut,desde - 6,1) * 2

   If largo = 8 then
	  lasuma = lasuma + mid(Rut,1,1) * 3
   End If

   resultado = 11 - (lasuma mod 11)

   If resultado = 10 then
      DigitoCorrecto = "K"
   Else   
      If resultado = 11 then
         DigitoCorrecto = "0"
      Else
         DigitoCorrecto = resultado      
      End If
   End If  

   If Cstr(DigitoCorrecto) <> Cstr(Digito) then
      ValidaRut = False
   Else
      ValidaRut = True
   End if

End Function


' Maneja la construccion del WHERE del query 
' Entradas:
' fieldName Nombre del campo en la tabla
' ByVal fieldData Contenido del campo en la tabla
' dataType  Char, Date o num , determina el delimitador de campo y el operador 
'   de comparacion
' Salida:
' strwhere String con la parte Where de un Query

Sub addWhere (ByRef strWhere, fieldName, ByVal fieldData, dataType )
If fieldData = "" Then Exit Sub     ' If campo vacio sale de la Sub
If strWhere <> "" Then strWhere = strWhere & " And "  ' Concatenar operador And
If strWhere <> "" Then criterio = criterio & " , "
Select Case dataType
 Case "vchar"   'string types
  strWhere = strWhere & fieldName & " LIKE '%" & FieldData & "%'"
  criterio = criterio & fieldName & " = '" & FieldData & "'"
 Case "char"   'string types
  strWhere = strWhere & fieldName & " = '" & FieldData & "'"
  criterio = criterio & fieldName & " = '" & FieldData & "'"
 Case "date"   'date types
  strWhere = strWhere & fieldName & " = '" & cambia_fecha(FieldData) & "'"
  criterio = criterio & fieldName & " = '" & cambia_fecha(FieldData) & "'"
 Case "mndate"   'date types
  strWhere = strWhere & fieldName & " <= '" & cambia_fecha(FieldData) & "'"
  criterio = criterio & fieldName & " <= '" & cambia_fecha(FieldData) & "'"
 Case "mydate"   'date types
  strWhere = strWhere & fieldName & " >= '" & cambia_fecha(FieldData) & "'"
  criterio = criterio & fieldName & " >= '" & cambia_fecha(FieldData) & "'"
 Case "mnchar"   'date types
        strWhere = strWhere & fieldName & " <= '" & FieldData & "'"
  criterio = criterio & fieldName & " <= '" & FieldData & "'"
    Case "mnnum"   'date types
        strWhere = strWhere & fieldName & " <= " & FieldData
  criterio = criterio & fieldName & " <= " & FieldData
 Case "mychar"   'date types
                strWhere = strWhere & fieldName & " >= '" & FieldData & "'"
  criterio = criterio & fieldName & " >= '" & FieldData & "'"
 Case Else
  strWhere = strWhere & fieldName & "=" & FieldData
  criterio = criterio & fieldName & "=" & FieldData
End Select
End Sub

Sub llenado_i(varcampo,vardato,vartipo,keytipo)
 session("izq_values") = session("izq_values") & varcampo & ", "
 If keytipo = "Llave" then
    SinEspacios vardato
    End if
 if len(vardato)=0 then
  session("der_values") = session("der_values") & "DEFAULT, "
 else
  select case vartipo
  case "C"
   session("der_values") = session("der_values") & "'" & vardato & "', "
  case "N"
   session("der_values") = session("der_values") & vardato & ", "
  case "F"
   session("der_values") = session("der_values") & "'" & cambia_fecha(vardato) & "', "
  end select
 end if
end sub

Sub SinEspacios (ByRef vardato) 
    Dato = vardato
    varDato = ""
 For nStep = 1 To Len(Dato)
     If Mid(Dato,nStep,1) <> " " Then
     vardato = vardato + Mid(Dato,nStep,1)
  End if
 Next
End Sub


Sub llenado_u(varcampo,vardato,vartipo)
 if len(vardato)=0 then
  session("upd_values") = session("upd_values") & varcampo & "=" & "DEFAULT, "
 else
  select case vartipo
  case "C"
   session("upd_values") = session("upd_values") & varcampo & "='" & vardato & "', "
  case "N"
   session("upd_values") = session("upd_values") & varcampo & "=" & vardato & ", "
  case "F"
   session("upd_values") = session("upd_values") & varcampo & "='" & cambia_fecha(vardato) & "', "
  end select
 end if
end sub


Function FadeOut(cTexto, cBasura)
Dim nPos, cBak
  cBak = cTexto
  Do while Instr(cBak, cBasura)>0
    nPos = Instr(cBak, cBasura)
	cBak = Left(cBak, nPos - 1) & Mid(cBak, nPos + Len(cBasura))
  Loop
  FadeOut = cBak
End Function


Function Codigos_Error(Err_Description)
  If InStr(Err_Description, "duplicate key") <> 0 then
	Codigos_Error = "   Registro ya existe en la base de datos."
  Elseif InStr(Err_Description, "TABLE REFERENCE ") <> 0 then
	   Codigos_Error = "   Existe información asociada a este ítem, no se puede eliminar."
  Elseif InStr(Err_Description, "FOREIGN KEY") <> 0 then
     Codigos_Error = "   Valor no permitido."
  Elseif InStr(Err_Description, "CHECK constraint") <> 0 then
     Codigos_Error = "   Valor no permitido."
  Else
    Codigos_Error = FadeOut(Err_Description, "[ODBC SQL Server Driver]")
    Codigos_Error = FadeOut(Codigos_Error, "[SQL Server]")
    Codigos_Error = FadeOut(Codigos_Error, "[Microsoft]")
  End if

End Function

Function enviaMail(cDestinatario, cResumen, cMensaje, cNombreOrigen, cEmailOrigen)
	Const CdoDefaultFolderInbox = 1
	Const CdoDefaultFolderOutbox = 2
	Const CdoTo  = 1
	Const CdoCC  = 2
	Const CdoBcc = 3

	Dim objSession 
	Dim objCarpetaSalida
	Dim objMensaje
	Dim objRecipiente

	Set objSession = Server.CreateObject("CDONTS.Session")

'Iniciar session en servidor de correo
	objSession.LogonSMTP cNombreOrigen, cEmailOrigen

'Obtener una referencia a la carpera de salida desde donde se envian los correos
	Set objCarpetaSalida = objSession.GetDefaultFolder(CdoDefaultFolderOutbox)

'Crear mensaje
	Set objMensaje = objCarpetaSalida.Messages.Add

	objMensaje.Subject = cResumen
	objMensaje.Text    = cMensaje

	Set objRecipiente = objMensaje.Recipients.Add(,cDestinatario, CdoTo)

	objMensaje.Send

'Terminar session en servidor de correo
	objSession.Logoff
	
End Function

Function enviaMailCC(cDestinatario, cResumen, cMensaje, cNombreOrigen, cEmailOrigen, cc)
	Const CdoDefaultFolderInbox = 1
	Const CdoDefaultFolderOutbox = 2
	Const CdoTo  = 1
	Const CdoCC  = 2
	Const CdoBcc = 3

	Dim objSession 
	Dim objCarpetaSalida
	Dim objMensaje
	Dim objRecipiente

	Set objSession = Server.CreateObject("CDONTS.Session")

'Iniciar session en servidor de correo
	objSession.LogonSMTP cNombreOrigen, cEmailOrigen

'Obtener una referencia a la carpera de salida desde donde se envian los correos
	Set objCarpetaSalida = objSession.GetDefaultFolder(CdoDefaultFolderOutbox)

'Crear mensaje
	Set objMensaje = objCarpetaSalida.Messages.Add

	objMensaje.Subject = cResumen
	objMensaje.Text    = cMensaje

	Set objRecipiente = objMensaje.Recipients.Add(,cDestinatario, CdoTo)
	Set objRecipiente = objMensaje.Recipients.Add(,cc, CdoCC)

	objMensaje.Send

'Terminar session en servidor de correo
	objSession.Logoff
	
End Function

Function enviaMailHtml(cDestinatario, cResumen, cMensaje, cNombreOrigen, cEmailOrigen)
	Const CdoDefaultFolderInbox = 1
	Const CdoDefaultFolderOutbox = 2
	Const CdoTo  = 1
	Const CdoCC  = 2
	Const CdoBcc = 3

	Dim objSession 
	Dim objCarpetaSalida
	Dim objMensaje
	Dim objRecipiente

	Set objSession = Server.CreateObject("CDONTS.Session")

'Iniciar session en servidor de correo
	objSession.LogonSMTP cNombreOrigen, cEmailOrigen

'Obtener una referencia a la carpera de salida desde donde se envian los correos
	Set objCarpetaSalida = objSession.GetDefaultFolder(CdoDefaultFolderOutbox)

'Crear mensaje
	Set objMensaje = objCarpetaSalida.Messages.Add

	objMensaje.Subject       = cResumen
	objMensaje.MessageFormat = 0
	objMensaje.HTMLText      = cMensaje

	Set objRecipiente = objMensaje.Recipients.Add(,cDestinatario, CdoTo)

	objMensaje.Send

'Terminar session en servidor de correo
	objSession.Logoff
	
End Function


Function enviaMailconAttach(cDestinatario, cResumen, cMensaje, cNombreOrigen, cEmailOrigen, attach, nombre)
	Const CdoDefaultFolderInbox = 1
	Const CdoDefaultFolderOutbox = 2
	Const CdoTo  = 1
	Const CdoCC  = 2
	Const CdoBcc = 3
	Const CdoFileData = 1

	Dim objSession 
	Dim objCarpetaSalida
	Dim objMensaje
	Dim objRecipiente
	Dim objAttach

	Set objSession = Server.CreateObject("CDONTS.Session")

'Iniciar session en servidor de correo
	objSession.LogonSMTP cNombreOrigen, cEmailOrigen

'Obtener una referencia a la carpera de salida desde donde se envian los correos
	Set objCarpetaSalida = objSession.GetDefaultFolder(CdoDefaultFolderOutbox)

'Crear mensaje
	Set objMensaje = objCarpetaSalida.Messages.Add

	objMensaje.Subject       = cResumen
	objMensaje.MessageFormat = 0
	objMensaje.HTMLText      = cMensaje

	Set objRecipiente = objMensaje.Recipients.Add(,cDestinatario, CdoTo)

'Attachar objeto

	Set	objAttach=objMensaje.Attachments
	objAttach.Add nombre, CdoFileData, attach
	 
	objMensaje.Send

'Terminar session en servidor de correo
	objSession.Logoff
	
End Function

</SCRIPT>