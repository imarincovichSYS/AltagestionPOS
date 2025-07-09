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
numero_nota_de_venta = Request.queryString("numero") 
cliente              = Request.queryString("cliente")
Puerto1 = "LPT1"
numero_de_copias = 1
copias = 0
'Nombre_DSN = "AG_Sanchez"
'strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"
'SET Conn_nv = Server.CreateObject("ADODB.Connection")
'Conn_nv.Open strConnect
openConn

sql = "select Codigo_EAN13 from productos where empresa='SYS' and producto = 'BOUCHER"&numero_nota_de_venta&"'"
set rs = conn.Execute(sql)
if not rs.eof then
  barra = rs("Codigo_EAN13")
else 
  barra  = Get_Nuevo_Codigo_EAN13
end if
strSQL =  "select A.producto, A.Superfamilia, A.Familia, A.Subfamilia, Genero= Isnull(A.Genero,''), Marca = Isnull((Case when A.Marca = 'OCASIONAL' THEN '' Else A.Marca end),''), " &_
		  "Nombre, cantidad, precio, pedido=isnull(pedido,0), observacion from " &_ 
          "(select producto, Nombre, Superfamilia, Familia, Subfamilia, Genero, Marca from productos) A, " &_ 
          "(select producto, precio, cantidad = sum(cantidad), pedido = max (pedido), observacion = max (observacion) from ordenes_de_ventas where numero_orden_de_venta= "& numero_nota_de_venta &" and (cliente = '"&cliente&"' or cliente is Null) " &_
          "group by  producto, precio having sum(cantidad) > 0) B " &_
          "where A.producto = B.producto"
'response.write strSQL
'response.end
aumenta_linea = 0
alto_boucher = 20
set rs_nv = Conn.Execute(strSQL)
do while not rs_nv.eof 
  'alto_boucher = alto_boucher + 10
  if len(rs_nv("Nombre"))>35 then
    alto_boucher = alto_boucher + 10
  else
    alto_boucher = alto_boucher + 7
  end if
  rs_nv.movenext 
loop
alto_boucher = alto_boucher + 15  'PARA LA FILAS DEL TOTAL
rs_nv.movefirst
inicio_linea = 155
avance_linea = 0
Etiqueta = "^Q"&alto_boucher&",0,2<BR>" 
Etiqueta = Etiqueta & "^W46<BR>" 
Etiqueta = Etiqueta & "^H10<BR>" 
Etiqueta = Etiqueta & "^P2<BR>" 'CANTIDAD DE ETIQUETAS
Etiqueta = Etiqueta & "^S6<BR>" 
Etiqueta = Etiqueta & "^AD<BR>" 
Etiqueta = Etiqueta & "^C1<BR>" 
Etiqueta = Etiqueta & "^R0<BR>" 
Etiqueta = Etiqueta & "~Q+0<BR>" 
Etiqueta = Etiqueta & "^O0<BR>" 
Etiqueta = Etiqueta & "^D0<BR>" 
Etiqueta = Etiqueta & "^E12<BR>" 
Etiqueta = Etiqueta & "~R200<BR>" 
Etiqueta = Etiqueta & "^L<BR>" 
Etiqueta = Etiqueta & "Dy2-me-dd<BR>" 
Etiqueta = Etiqueta & "Th:m:s<BR>" 
Etiqueta = Etiqueta & "Lo,6,150,350,152<BR>"
Etiqueta = Etiqueta & "AB,0,0,1,1,1,0,"&Date&"<BR>"
Etiqueta = Etiqueta & "AB,0,25,1,1,1,0, N. de Venta " & cdbl(numero_nota_de_venta) &"<BR>"

do while not rs_nv.eof 
  observacion= ucase(rs_nv("observacion"))
  precio = formatNumber(cdbl(rs_nv("precio")) * cdbl(rs_nv("cantidad")),0)
  izquierda  = 0
  if Cdbl(precio) < 100 then
    izquierda = 370
  elseif Cdbl(precio) >= 100 and Cdbl(precio) <1000 then
    izquierda = 355
  elseif Cdbl(precio) >= 1000 and Cdbl(precio) <10000 then
    izquierda = 330
  elseif Cdbl(precio) >= 100000 and Cdbl(precio) <1000000 then
    izquierda = 298
  else
    izquierda = 315
  end if
  if cdbl(rs_nv("pedido")) = 1 then
    pedido = "@"
  else
    pedido = ""
  end if
 'Etiqueta = Etiqueta & "AC,"&izquierda&","&inicio_linea + avance_linea&",1,1,1,0," & precio & "<BR>"  
   Etiqueta = Etiqueta & "AA,0,"&inicio_linea + avance_linea&",1,1,1,0,"&pedido&trim(rs_nv("Producto"))&" "&trim(rs_nv("Superfamilia"))&""&trim(rs_nv("Familia"))&""&trim(rs_nv("Subfamilia"))&"  "&trim(rs_nv("Genero"))&"  "&trim(rs_nv("Marca"))&" <BR>"
 ' Etiqueta = Etiqueta & "AB,0,"&inicio_linea + avance_linea&",1,1,1,0,"&pedido&trim(rs_nv("Producto"))& " "  & formatNumber(rs_nv("cantidad"),0) & "x" & formatNumber(trim(rs_nv("precio")),0) & " --- " & formatNumber(precio ,0) & "<BR>"
	avance_linea = avance_linea + 15
    'Etiqueta = Etiqueta & "AB,100,"&inicio_linea + avance_linea&",1,1,1,0,"&pedido&trim(rs_nv("Subfamilia"))& " " & "<BR>"
	Etiqueta = Etiqueta & "AB,140,"&inicio_linea + avance_linea&",1,1,1,0,"& formatNumber(rs_nv("cantidad"),0) & "x" & formatNumber(trim(rs_nv("precio")),0) & " --- " & formatNumber(precio ,0) & "<BR>"
    if len(trim(rs_nv("Nombre")))>35 then
    avance_linea = avance_linea + 25
    Etiqueta = Etiqueta & "AA,0,"&inicio_linea + avance_linea&",1,1,1,0,"&left(trim(rs_nv("Nombre")),35)&"<BR>"
    avance_linea = avance_linea + 20
    Etiqueta = Etiqueta & "AA,0,"&inicio_linea + avance_linea&",1,1,1,0,"&Mid(trim(rs_nv("Nombre")),36,15)&"<BR>"
    avance_linea = avance_linea + 20
  else
    avance_linea = avance_linea + 25
    Etiqueta = Etiqueta & "AA,0,"&inicio_linea + avance_linea&",1,1,1,0,"&trim(rs_nv("Nombre"))&"<BR>"
    avance_linea = avance_linea + 20
  end if  
  Etiqueta = Etiqueta & "Lo,1,"&inicio_linea + avance_linea-2&",390,"&inicio_linea + avance_linea-2&"<BR>"
  Total_Boucher = Total_Boucher + (cdbl(rs_nv("precio"))*cdbl(rs_nv("cantidad")))
  rs_nv.movenext 
loop
Etiqueta = Etiqueta & "AC,100,"&inicio_linea + avance_linea+10&",1,1,0,0,TOTAL<BR>"
Etiqueta = Etiqueta & "AE,190,"&inicio_linea + avance_linea&",1,1,0,0,"&"$ "&FormatNumber(Total_Boucher,0)&"<BR>"
if observacion <> "" then
  if len(observacion) > 30 then
    Etiqueta = Etiqueta & "AA,2,"&inicio_linea + avance_linea+48&",1,1,0,0,"&left(trim(observacion),35)&"<BR>"
    Etiqueta = Etiqueta & "AA,2,"&inicio_linea + avance_linea+65&",1,1,0,0,"&Mid(trim(observacion),36,34)&"<BR>"
    Etiqueta = Etiqueta & "R0,"&inicio_linea + avance_linea+40&",390,"&inicio_linea + avance_linea+90&",1,1"&"<BR>"
    'R110,6,290,48,1,1  
  else
    Etiqueta = Etiqueta & "AA,2,"&inicio_linea + avance_linea+48&",1,1,0,0,"&observacion&"<BR>"
    Etiqueta = Etiqueta & "R0,"&inicio_linea + avance_linea+45&",390,"&inicio_linea + avance_linea+80&",1,1"&"<BR>"
  end if 
end if
Etiqueta = Etiqueta & "BE,4,55,3,3,75,0,1,"&Barra&"<BR>"
Etiqueta = Etiqueta & "E"

'sql = "select producto from productos where empresa='SYS' and producto = 'BOUCHER"&numero_nota_de_venta&"'"
'set rs = conn.Execute(sql)
'if rs.eof then 
    'response.write Etiqueta
    'response.end
    '--------------------------------------------------------------------------------------------------
    '1) insert a productos
    sql = "Exec PRO_GrabaProducto 'BOUCHER"&numero_nota_de_venta&"', " &_
                           "'',  " &_
                           "'SYS', " &_
                           "'P', " &_
                           "'F', " &_
                           "0,  " &_
                           "0,  " &_
                           "0, " &_
                           "'ZZ', " &_
                           "'VO', " &_
                           "'VOU', " &_
                           "'OCAS', " &_ 
                           "'UN    ', " &_
                           "'UN    ', " &_
                           "01,   " &_
                           "Null,  " &_
                           "'', " &_
                           "'', " &_
                           "0,  " &_
                           "0,  " &_
                           "0,  " &_
                           "0,  " &_
                           "00,  " &_
                           "0,  " &_
                           "0,  " &_
                           "0,  " &_
                           "0,  " &_
                           "0,  " &_
                           "'US$', " &_
                           "Null, " &_
                           "0, " &_
                           "'A', " &_
                           "'', " &_
                           "'S', " &_
                           "'', " &_
                           "'', " &_
                           "Null, " &_
                           "Null, " &_
                           "Null, " &_
                           "'N', " &_
                           "'"&barra&"', " &_
                           "'', " &_
                           "'UN    ', " &_
                           "00, " &_
                           "00, " &_
                           "00, " &_
                           "00, " &_
                           "A, " &_
                           "Null, " &_
                           "Null, " &_
                           "Null, " &_
                           "'N', " &_
                           "0, " &_
                           "'N', " &_
                           "0, " &_
                           "0, " &_
                           "0, " &_
                           "0, " &_
                           "0 " '
    Conn.Execute(sql)
    '2) insert a composición
      '2.2) si existe entonces borrar código
      sql = "Exec FOR_Borra_formulacion_producto_final 'BOUCHER"&numero_nota_de_venta&"',Null" 
      Conn.Execute(sql)    
      
      rs_nv.movefirst
      '2.4) insert en composicion __> HACER LOOP SI HAY MAS DE UN producto en BOUCHER
      do while not rs_nv.eof 
        sql= "Exec FOR_Graba_productos_insumos 'BOUCHER"&numero_nota_de_venta&"', " &_
                          "'"&trim(rs_nv("Producto"))&"', " &_
                          ""&rs_nv("cantidad")& ", " &_
                          "'UN', " &_
                          "'', " &_
                          "" & rs_nv("precio") & ", " &_     
                          "Null"'
        Conn.Execute(sql)
        rs_nv.movenext   
      loop
      '2.5) insert en productos_en_listas_de_precios
      sql = "Exec FOR_Graba_precio_KIT_en_Tarifario 'SYS','BOUCHER"&numero_nota_de_venta&"'"
      Conn.Execute(sql)                
    '------------------------------------------------------------------------------------------
'end if 
rs_nv.close
set rs_nv = nothing
Conn.Close
set Conn = nothing
%>   
</body>
</html>
<OBJECT classid="CLSID:B829BCD0-3892-11D3-A519-0000216ABE11" 
codebase="../../Impresion/Impresora.CAB#version=2,0,0,1" 
id=Locales style="LEFT: 0px; TOP: 0px">
<PARAM NAME="_ExtentX" VALUE="503">
<PARAM NAME="_ExtentY" VALUE="503">
</OBJECT>

<Script language="VBScript">
If Locales.InicioImpresion("<%=Puerto1%>") then
  'copia = "<%=copias%>"
  'do while copia < "<%=numero_de_copias%>"
    'document.write Replace("<%=Etiqueta%>","<BR>",VbCrlf)
    Locales.imprimir Replace("<%=Etiqueta%>","<BR>",VbCrlf)
    'copia = copia + 1   
  'loop
  Locales.FinImpresion
  window.location = "Nota_de_venta_Inicial.asp"  
end if
</Script>



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
