<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )

	Producto	= Request("Producto")
	Modo		= Request("Modo")
	Orden		= Request("Orden")

	cSql = "Exec PRO_Siguiente_producto '"	& Producto & "', '" & Modo & "', '" & Orden & "'"
	Set Rs = Conn.Execute( cSql )
	Producto = ""
	if Not Rs.Eof then
		Producto = Rs("Producto")
	end if
	Rs.Close
	Set Rs = Nothing
	Conn.Close()
%>
	<script language="JavaScript">
		if ( '<%=Producto%>' != '')
		{
			parent.top.frames[1].location.href = 'Mant_Productos.asp?Codigo_pais=<%=Producto%>&Nuevo=N&OrdenadoPor=<%=Orden%>';
		}
	</script>
<%else
	Response.Redirect "../../index.htm"
end if%>