<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

set Conn = server.createobject("ADODB.Connection")
Conn.open session("DataConn_ConnectionString")

function Get_Numero_Interno_DVT_Activa_X_Login(v_login)
  strSQL="select numero_interno_dvt_activa resultado from entidades_comerciales with(nolock) " &_
	       "where empresa='SYS' and entidad_comercial='"&trim(v_login)&"'"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	Get_Numero_Interno_DVT_Activa_X_Login = resultado
end function

on error resume next 

cSql = "Exec MOP_Consulta_producto '" 
cSql = cSql & trim(Session("xBodega")) & "', '"
cSql = cSql & trim(Session("xCentro_de_venta")) & "', '"
cSql = cSql & Session("Cliente_boleta") & "', '"
cSql = cSql & Session("Empresa_usuario") & "', '"
cSql = cSql & trim(Request.Form("Producto")) & "', '"
cSql = cSql & Session("Login") & "', 1"
delimiter = "~"
Set rs = Conn.execute( cSql )
if Conn.Errors.Count = 0 then
  v_num_int_DVT_activa = Get_Numero_Interno_DVT_Activa_X_Login(Session("Login"))
  'strSQL="select producto From Movimientos_productos (Nolock) " &_
  '       "where Numero_interno_documento_no_valorizado = "&v_num_int_DVT_activa&" " &_
  '       "and ( (producto = '"&trim(Request.Form("Producto"))&"' and kit is null) or Kit = '"&trim(Request.Form("Producto"))&"')"
  
'  strSQL="select producto from codigos_alternativos_de_productos " &_
'         "where codigo_alternativo_producto='"&trim(Unescape(Request.Form("Producto")))&"' " &_
'         "or producto='"&trim(Unescape(Request.Form("Producto")))&"'"
'  set rs_prod = Conn.Execute(strSQL)
  strSQL="select producto = producto_numerico from Productos_alfanumericos_numericos with(nolock) " &_
         "where producto_alfanumerico ='"&trim(Unescape(Request.Form("Producto")))&"' "
  set rs_prod = Conn.Execute(strSQL)
  producto = trim(rs_prod("producto"))
  if isNull(producto) or producto = "" then
    producto = trim(Unescape(Request.Form("Producto")))
  end if

  strSQL="select producto, kit From Movimientos_productos with(nolock) " &_
         "where Numero_interno_documento_no_valorizado = "&v_num_int_DVT_activa&" " &_
         "and (producto = '"&producto&"' or Kit = '"&producto&"')"
  'Response.Write strSQL
  'Response.End
  Set rs_mov_dvt = Conn.execute(strSQL)
  if not rs_mov_dvt.EOF then '-->Existe en la venta
    if rs_mov_dvt("producto") = trim(Unescape(Request.Form("Producto"))) and not IsNull(rs_mov_dvt("kit")) then
      Response.Write "ERROR" & delimiter & "Producto pertenece al kit "&Ucase(trim(rs_mov_dvt("kit")))
    else
      Response.Write "OK" & delimiter & rs("precio_venta_de_lista_1")
    end if
  else 'No existe en venta activa
    Response.Write "ERROR" & delimiter & "Producto "&Ucase(trim(Unescape(Request.Form("Producto"))))&" no pertenece a venta activa de cajera"
  end if
else
  Response.Write "ERROR" & delimiter & LimpiaError(Err.Description)
end if
%>