<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
%>
<html>
	<head>
		<title>AltaGestion</title>
	</head>
	<frameset rows="20%,*" frameborder='0' framespacing='0' border='0'>
		<frame frameborder=0 marginwidth=0 marginheight=0 framespacing='0' src="Find_OrdenUbicacion.asp"	scrolling=no	name="Busqueda"></frame>
		<frame frameborder=0 marginwidth=0 marginheight=0 framespacing='0' src='../../Empty.asp' scrolling=auto	name="Listado"></frame>
	</frameset>
	<noframes>
	<body qonload="javascript:{if(parent.top.frames[0]&&parent.top.frames['Menu'].Go)parent.top.frames['Menu'].Go()}" bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
		El browse que tienes instalado no soporta FRAMES. <a href='<%=Request.ServerVariables("SERVER_NAME")%>'>Inicio</a>
	</body></noframes>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>