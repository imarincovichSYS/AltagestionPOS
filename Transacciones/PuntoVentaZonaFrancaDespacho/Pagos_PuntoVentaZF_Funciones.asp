<%
function Get_Numero_Interno_DVT_Activa_X_Login(v_login)
	strSQL="select numero_interno_dvt_activa resultado from entidades_comerciales with(nolock) " &_
	       "where empresa='SYS' and entidad_comercial='"&v_login&"'"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	Get_Numero_Interno_DVT_Activa_X_Login = resultado
end function

function Get_Total_Precio_Mayoristas_Lista_DVT(v_num_int_DVT_activa)
  '#### Total precio con descuento productos mayoristas ####
	'strSQL="select Sum(cantidad_salida*precio_de_lista_modificado) resultado from movimientos_productos " &_
	'       "where empresa='SYS' and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" " &_
	'       "and (temporada='XMAY' or temporada='PATG' or temporada='NOV' or temporada='CHAO')"
	'--------------------------------------------------------------------------------------------------------
	'#### Total precio normal productos mayoristas ####
  strSQL="select Sum(cantidad_salida*precio_de_lista) resultado from movimientos_productos with(nolock) " &_
	       "where empresa='SYS' and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" " &_
	       "and (temporada='XMAY' or temporada='PATG' or temporada='NOV' or temporada='CHAO')"
	'--------------------------------------------------------------------------------------------------------
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	Get_Total_Precio_Mayoristas_Lista_DVT = resultado
end function

function Existe_Producto_Mayorista_En_Lista_DVT(v_num_int_DVT_activa)
	strSQL="select producto from movimientos_productos with(nolock) " &_
	       "where empresa='SYS' and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" " &_
	       "and (temporada is not null and temporada <> 'ECO')"
	set rs_get = Conn.Execute(strSQL) : resultado = false
	if not rs_get.EOF then resultado = true
	Existe_Producto_Mayorista_En_Lista_DVT = resultado
end function

function Get_Total_Precio_Normal_Lista_DVT(v_num_int_DVT_activa)
  strSQL="select Sum(Floor " &_
         "( " &_
         "  cantidad_salida * " &_
         "  ( " &_
         "    Round(precio_de_lista * ((100-porcentaje_descuento_1)/100 )*((100-porcentaje_descuento_2)/100),0) " &_
         "  ) " &_
         ")) resultado " &_
         " from movimientos_productos with(nolock) where empresa='SYS' and documento_no_valorizado='DVT' " &_
         " and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	Get_Total_Precio_Normal_Lista_DVT = resultado
end function

sub log_error(Sql,SqlError)
		set Conector = server.createobject("ADODB.Connection")
		Conector.open session("DataConn_ConnectionString")
		Conector.CommandTimeout = 3600
		SqlError = replace( SqlError , "[Microsoft][ODBC SQL Server Driver][SQL Server]", "")
 		Conector.Execute( "exec LOG_Insert '" & trim(Session("Login")) & "','" & replace( Sql ,"'",chr(34)) & "','" & replace( SqlError ,"'",chr(34)) & "','" & replace( Request.ServerVariables("SCRIPT_NAME") ,"'",chr(34)) & "'" )
		Conector.close
		set Conector = nothing
end sub

function saca(byref cData,cSeparador)
   if instr(cData,cSeparador) = 0 then cData = cData & cSeparador
   nAt = instr(cData,cSeparador)
   saca = mid(cData,1,nAt-1)
   cData = mid(cData,nAt+len(cSeparador))
end function

Function Vacio(cData)
   if trim( cData & "" ) & "*" = "*" then vacio = true else vacio = false
End Function

Function CajaConBordes(nTop,nLeft,nWidth,nHeight)
  CajaConBordes = "<div style='position:absolute; top:" & (nTop - 10) & "px; left:" & (nLeft -10) & "px; width:" & (nWidth + 20) & "px; height:" & (nHeight + 20) & "px; z-index:0' style='border: 2px #808080 solid'></div>" & chr(13) & chr(10) & _
                  "<div style='position:absolute; top:" & (nTop - 2) & "px; left:" & (nLeft - 2) & "px; width:" & (nWidth + 4) & "px; height:" & (nHeight + 4) & "px; z-index:0' style='border: 1px #999999 solid'></div>" & chr(13) & chr(10) & _
                  "<div style='position:absolute; top:" & nTop & "px; left:" & nLeft & "px; width:" & nWidth & "px; height:" & nHeight & "px; z-index:0' style='background-color:#CCCD94;'></div>"
  CajaConBordes = replace( CajaConBordes , "'" , chr(34) )
End Function

Function Selected( cValue, cOption )
   if cValue & "*" = cOption & "*" and cValue <> "" then
      Selected = " selected "
   else
      Selected = ""
   end if
End Function

function Get_Porcentaje_Descuento_Producto_X_Economato(v_economato,v_superfamilia, v_familia)
  strSQL="select porcentaje_descuento resultado from economatos_descuentos with(nolock) " &_
         "where economato = '"&v_economato&"' and " &_
         "superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"'"
  'Response.Write strSQL
  'Response.End
  set rs_get = Conn.Execute(strSQL) : resultado = 0
	if not rs_get.EOF then resultado = rs_get("resultado")
  Get_Porcentaje_Descuento_Producto_X_Economato = resultado
end function
%>
