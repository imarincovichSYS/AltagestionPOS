<%
	if len(trim(Request("Imagen"))) > 0 then 
	   Imagen = Request("Imagen")
	else
	   Imagen = "BackGround.jpg"
	end if
%>
<html>
	<body background="<%=Imagen%>">
	</body>
</html>