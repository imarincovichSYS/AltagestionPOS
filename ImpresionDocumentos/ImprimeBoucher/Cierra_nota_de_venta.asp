<%
'Nombre_DSN = "AG_Sanchez_Productivo"
Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=Vp?T+!mZpJds;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"

RutaProyecto = "http://s01sys.sys.local/altagestion/"
'Response.Write RutaProyecto
'Response.End
SET Conn = Server.CreateObject("ADODB.Connection")
Conn.Open strConnect
Conn.commandtimeout=600

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

numero_nota_de_venta = Request.Form("numero")
sql = "select numero_orden_de_venta from  ordenes_de_ventas where numero_orden_de_venta = " & numero_nota_de_venta
set rs = Conn.Execute(sql)
if not rs.eof then
  sql = "update ordenes_de_ventas set estado = 'C' where numero_orden_de_venta = " & numero_nota_de_venta
  Conn.Execute(sql)
  response.write "Orden de venta cerrada"
else
  %>
  <center><b>NO EXISTEN PRODUCTOS EN NOTA DE VENTA</b></center>
  <%
end if
%>
