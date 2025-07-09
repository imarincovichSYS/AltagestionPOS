<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
	<script src="../../Scripts/Js/Fechas.js"></script>
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
</head>


<%     
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	else%>
		<script language="JavaScript">
			function Mensajes( valor )
			{
				with (parent.top.frames[3].document.IdMensaje.document)
				{
				  open();
				  write(valor);
				  close();
				}
			}

	
		</script>
<%	end if

	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

    Fecha_cierre_solicitado=request("Fecha_cierre_solicitado")
	Fecha_cierre_anterior=request("Fecha_cierre_anterior")
	empresa=session("empresa_usuario")

	SQL  ="exec DOV_Bodega_utlimo_cierre 'SYS', '" & trim(session("login")) & "'"

	set rs=conn.Execute(SQL)'

	If Not rs.EOF Then
		if rs("bodega") = "0003" then
			%>
				<!--#include file="DetalleCobros_CierreCaja_Ashley.asp" -->
			<%	
		else
			%>
				<!--#include file="DetalleCobros_CierreCaja_2.asp" -->
			<%
		end if
	end if
%>

	
	


<%
	Conn.Close
	Set Conn = Nothing
%>
<%else
	Response.Redirect "../../index.htm"
end if%>

</html>
