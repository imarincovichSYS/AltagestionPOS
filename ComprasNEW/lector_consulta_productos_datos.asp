<%
'Nombre_DSN = "AG_Sanchez_Productivo"
Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=Vp?T+!mZpJds;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"

RutaProyecto = "http://s01sys/altagestion/"

SET Conn = Server.CreateObject("ADODB.Connection")
Conn.Open strConnect
Conn.commandtimeout=600

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

function Existe_ImagenProducto(v_imagen_producto)
  RutaFISICA_ImagenesProductos  = Request.ServerVariables("APPL_PHYSICAL_PATH") & "\Imagenes\Productos\"
  
  SinImagen   = "noimagen.gif"  
  archivo     = RutaFISICA_ImagenesProductos & v_imagen_producto
  Set objFSO  = Server.CreateObject("Scripting.FileSystemObject")
  imagen      = v_imagen_producto
  if not objFSO.FileExists(archivo) then imagen = SinImagen
  Existe_ImagenProducto = imagen
end function

codigo  = Ucase(trim(Request.Form("codigo")))
'codigo  = "7794626923937"
if IsNumeric(codigo) then
  num_inicio_L3 = cdbl(left(codigo,3))
  if num_inicio_L3 >= 211 and num_inicio_L3 <= 236 then codigo = left(codigo,len(codigo)-1)
end if
strSQL="select A.producto, A.nombre, B.codigo_alternativo_producto, C.valor_unitario from " &_
       "(select producto, nombre from productos with(nolock) where empresa='SYS') A, " &_
       "(select producto, codigo_alternativo_producto from codigos_alternativos_de_productos with(nolock) " &_
       "where codigo_alternativo_producto='"&codigo&"' or producto='"&codigo&"') B, " &_
       "(select producto, valor_unitario from productos_en_listas_de_precios with(nolock) where empresa='SYS') C " &_
       "where A.producto=B.producto and A.producto=C.producto"
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)
if not rs.EOF then
%>
<table width="100%" cellPadding="0" cellSpacing="0" align="center">
<tr id="texto_10">
  <td><b>
  <b><u>Código:</u></b>
  <br><%=rs("producto")%>
  <br><b><u>Descripción:</u></b>
  <br><%=rs("nombre")%>
  <b><br><u>Precio:</u></b>
  <%=FormatNumber(rs("valor_unitario"),0)%>
  </td>
</tr>
<tr>
  <td align="center">
  <img src="<%=RutaProyecto%>imagenes/productos/<%=Existe_ImagenProducto( Ucase(trim(rs("producto"))) & ".jpg" )%>" border=1 width=100 height=100>
  </td>
</tr>
<%end if
rs.close
set rs = nothing
Conn.Close
set Conn = nothing%>