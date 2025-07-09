<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<title>FOTOS</title>
	</head>

<%if len(trim(request("imagen"))) > 0 then%>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
<img width="100%" height="100%" src="<%=request("imagen")%>">
<%else%>
	<body leftmargin=0 topmargin=0 text="#000000">
	<br><br>
	<br><br>
	<br><br>
	<br><br>
	<center><img awidth="50%" aheight="50%" src="noimagen.gif"></center>
<%end if%>

</body>
