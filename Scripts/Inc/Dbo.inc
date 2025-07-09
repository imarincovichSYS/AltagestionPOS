<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">

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

function title(NFuncion)
	Funcion = Trim(lcase( NFuncion ))
	do while instr( Funcion , "/" ) > 0
		Funcion = mid(Funcion, instr( Funcion , "/" ) + 1)
	loop
	
	nAt = instr( Funcion , "_" )
	if nAt > 0 then Funcion = mid(Funcion, nAt + 1)
	nAt = instr( Funcion , ".asp" )
	if nAt > 0 then Funcion = mid(Funcion, 1, nAt - 1)

	set conn = server.createobject("adodb.connection")
	conn.open Session("DataConn_ConnectionString")
	Sql = "exec FUN_ListaFunciones '" &  Funcion & "', '' ,1"

'response.write(sql)
	Set RS = Conn.Execute (sql)
	Nombre = RS("Nombre_funcion")
	Menu = RS("Titulo_grupo_menu")
'	title = "ABCAP - " & Menu & "/" & Nombre
	title = "ABCAP - " & Nombre
	RS.close
	Conn.close
	session("title") = title

end function

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

Function FadeOut(cTexto, cBasura)
Dim nPos, cBak
  cBak = cTexto
  Do while Instr(cBak, cBasura)>0
    nPos = Instr(cBak, cBasura)
	cBak = Left(cBak, nPos - 1) & Mid(cBak, nPos + Len(cBasura))
  Loop
  FadeOut = cBak
End Function

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

</SCRIPT>