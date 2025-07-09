<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.inc" -->
<!-- #include file="../../Scripts/Inc/Montoescrito.Inc" -->
<!-- #include file="../../_private/funciones_generales.asp" -->
<!-- #include file="../../_private/config.asp" -->

<%Cache
'Session.LCID = 11274%>
<html>
	<head>
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
<% 

'Nombre_DSN = "AG_Sanchez"
'strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"
'SET Conn_nv = Server.CreateObject("ADODB.Connection")
'Conn_nv.Open strConnect
openConn

sql = "select codigo from hoja1"
set rs = conn.Execute(sql)%>
<table>

<%do while not rs.eof
  barra = Get_Nuevo_Codigo_EAN13%>
  <tr>
    <td><%response.write (rs("codigo"))%></td>
    <td><%response.write (barra)%></td>
  </tr><%  
  rs.movenext
  loop
%>
<table>
<%
function Get_Nuevo_Codigo_EAN13()
  cod_ini_CL = "25"
  'cod_ini = 1
  minimo  = 1
  maximo  = 9999999999
  do while true
    cod_ini = Get_Numero_Aleatorio(minimo,maximo)
    x_cod_EAN13_12  = cod_ini_CL & Lpad(cod_ini,10,0)
    x_cod_EAN13_13  = x_cod_EAN13_12 & Calcular_Digito_Verificador_EAN13(x_cod_EAN13_12)
    band_codEAN13_codAltPro = false : band_codEAN13_productos = false
    strSQL="select codigo_alternativo_producto from Codigos_alternativos_de_productos " &_
           "where codigo_alternativo_producto='" & x_cod_EAN13_13 & "'"
    set v_rs = Conn.Execute(strSQL)
    if v_rs.EOF then band_codEAN13_codAltPro = true
    strSQL="select codigo_ean13 from productos where empresa='SYS' and codigo_ean13='" & x_cod_EAN13_13 & "'"
    set v_rs = Conn.Execute(strSQL)
    if v_rs.EOF then band_codEAN13_productos = true
    if band_codEAN13_codAltPro and band_codEAN13_productos then exit do
  loop
  Get_Nuevo_Codigo_EAN13 = x_cod_EAN13_13
end function

function Get_Numero_Aleatorio(v_minimo,v_maximo)
  Randomize
  Get_Numero_Aleatorio = Int(((v_maximo - v_minimo+1) * Rnd) + v_minimo)
end function

function Calcular_Digito_Verificador_EAN13(v_cod_ean13_12)
  Val1 = 1 
  Val2 = 3 
  
  uno     = cdbl(Mid(v_cod_ean13_12, 1, 1))   * Val1 
  dos     = cdbl(Mid(v_cod_ean13_12, 2, 1))   * Val2 
  tres    = cdbl(Mid(v_cod_ean13_12, 3, 1))   * Val1 
  cuatro  = cdbl(Mid(v_cod_ean13_12, 4, 1))   * Val2 
  cinco   = cdbl(Mid(v_cod_ean13_12, 5, 1))   * Val1 
  seis    = cdbl(Mid(v_cod_ean13_12, 6, 1))   * Val2 
  siete   = cdbl(Mid(v_cod_ean13_12, 7, 1))   * Val1 
  ocho    = cdbl(Mid(v_cod_ean13_12, 8, 1))   * Val2 
  nueve   = cdbl(Mid(v_cod_ean13_12, 9, 1))   * Val1 
  diez    = cdbl(Mid(v_cod_ean13_12, 10, 1))  * Val2 
  once    = cdbl(Mid(v_cod_ean13_12, 11, 1))  * Val1 
  doce    = cdbl(Mid(v_cod_ean13_12, 12, 1))  * Val2
  
  v_suma1   = uno + dos + tres + cuatro + cinco + seis + siete + ocho + nueve + diez + once + doce
  v_suma2   = v_suma1 - v_suma1 mod 10 + 10
  'Response.Write "v_suma1: "&v_suma1&", v_suma2: "&v_suma2&" <br>"
  v_dif_ver = v_suma2 - v_suma1
  if (v_suma1 + v_suma2) > 9 then v_dif_ver = right(trim(v_suma1 - v_suma2),1)
  Calcular_Digito_Verificador_EAN13 = v_dif_ver
end function
%>
