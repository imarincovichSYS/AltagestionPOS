<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<%
	Cache
%>
<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

<form name="Formulario">
	<Textarea ID="holdtext" STYLE="display:none;"></Textarea>
<%
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	cSql = "Exec PRO_Lista_rosas "

	Set rs = Server.CreateObject("ADODB.Recordset")

	Const adUseClient = 3		
	rs.PageSize = Session("PageSize")-1
	rs.CacheSize = 3
	rs.CursorLocation = adUseClient

	rs.Open cSql, Conn, , , adCmdText 'mejor
		
	Filas = Rs.RecordCount

	ReDim MtzRosas(Filas,17)
	x = 0
	Do While Not Rs.Eof
		ColorVariedad = Rs("ColorVariedad")

'Response.Write ColorVariedad & "=" & Rs("ColorVariedad") & "<br>"
		Nombre = Rs("Nombre")
		Do While ColorVariedad = Rs("ColorVariedad")
			if Rs("Calibre") = 34 then
				if Rs("Tallo") = 40 then
					Pos = 1
				elseif Rs("Tallo") = 50 then
					Pos = 2
				elseif Rs("Tallo") = 60 then
					Pos = 3
				elseif Rs("Tallo") = 70 then
					Pos = 4
				end if
			elseif Rs("Calibre") = 37 then
				if Rs("Tallo") = 40 then
					Pos = 5
				elseif Rs("Tallo") = 50 then
					Pos = 6
				elseif Rs("Tallo") = 60 then
					Pos = 7
				elseif Rs("Tallo") = 70 then
					Pos = 8
				end if
			end if
'Response.Write x & "-" & Pos & "<br>"
			MtzRosas(x,0)	  = Nombre
			
			Cadena = "<a href='JavaScript:ClipBoard_(" & chr(34) & "Formulario" & chr(34) & "," & chr(34) & Rs("Producto")  & "¬¬¬¬¬" & chr(34) & ", " & Chr(34) & "c" & Chr(34) & ");window.blur()'>" & Cdbl(Rs("Disponible")) & "</a>"
			'Cadena = Cadena & "<SPAN ID='IdProd" & x & "_" & Pos & "' style='visibility:hidden'>" & Rs("Producto")  & "¬¬¬¬¬</Span>"
			'Cadena = Cadena & "<Input Name='IdProd" & x & "_" & Pos & "' ID='IdProd" & x & "_" & Pos & "' type=hidden value='>" & Rs("Producto")  & "¬¬¬¬¬'>"
			
			MtzRosas(x,Pos)   = Cadena
			MtzRosas(x,9)	  = Rs("Producto")

	if Session.SessionID = 5808916 then
	'	Response.Write Cadena
	end if

			Rs.MoveNext
			if Rs.EOF Then
				exit do
			end if
		Loop
'break			
		if Rs.EOF Then
			exit do
		end if
		x = x + 1
	Loop
	Rs.Close
	Set Rs = Nothing



	Response.Write "<table border=0 width=100% hecellspacing=0 cellpaddin=0>"
		Response.Write "<tr>"
		Response.Write "<td class=FuenteTitulosFunciones align=center>Ayuda de Rosas</td>"
		Response.Write "</tr>"
	Response.Write "</table>"

	Response.Write "<table border=1 width=100% cellspacing=0 cellpaddin=0>"
		Response.Write "<tr>"
		Response.Write "<td class=fuenteinput align=center>Color-Variedad</td>"
		Response.Write "<td class=fuenteinput align=center colspan=4>Calidad 34</td>"
		Response.Write "<td class=fuenteinput align=center colspan=4>Calidad 37</td>"
		Response.Write "</tr>"
		Response.Write "<tr>"
		Response.Write "<td class=fuenteinput align=center>&nbsp;</td>"
		Response.Write "<td class=fuenteinput align=center>40</td>"
		Response.Write "<td class=fuenteinput align=center>50</td>"
		Response.Write "<td class=fuenteinput align=center>60</td>"
		Response.Write "<td class=fuenteinput align=center>70</td>"
		Response.Write "<td class=fuenteinput align=center>40</td>"
		Response.Write "<td class=fuenteinput align=center>50</td>"
		Response.Write "<td class=fuenteinput align=center>60</td>"
		Response.Write "<td class=fuenteinput align=center>70</td>"
		Response.Write "</tr>"

	for a=0 to x
		Response.Write "<tr>"
		for b=0 to 8
			if b=0 then alinear = "left" else alinear = "center"
			if len(trim(MtzRosas(a,b))) = 0 then 
				Pinta = "&nbsp;"				
			else
				Pinta = MtzRosas(a,b)
			end if
			Response.Write "<td class=fuenteinput align=" & alinear & ">" & Pinta 
			if b<>8 then Response.Write "</td>" & Chr(13) & Chr(10)
		next
		Response.Write "</td>"
		Response.Write "</tr>"
	next

	Response.Write "</table>"
%>
</form>
</body>
</html>