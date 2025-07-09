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
	Const adUseClient = 3
	Dim conn1
	conn1 = Session("DataConn_ConnectionString")

	cSql = "Exec HAB_ListaBodega '" & Session("Empresa_usuario") & "'"
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.PageSize = Session("PageSize")-1
	rs.CacheSize = 3
	rs.CursorLocation = adUseClient
	rs.Open cSql, conn1, , , adCmdText
		TotalBodegas = Rs.RecordCount + 2 'Nombre del producto + las bodegas + Codigo
		Do While Not  Rs.Eof
			cBodegas = cBodegas & Rs("Descripcion_breve") & "¬"
			Rs.MoveNext
		Loop
	Rs.Close
	Set Rs = Nothing

	cSql = "Exec PRO_Lista_NoRosas "
	Set rs = Server.CreateObject("ADODB.Recordset")
		
	rs.PageSize = Session("PageSize")-1
	rs.CacheSize = 3
	rs.CursorLocation = adUseClient
	rs.Open cSql, conn1, , , adCmdText 'mejor		
	Filas = rs.RecordCount / (TotalBodegas-2)

	Redim MtzNoRosas(Filas, TotalBodegas)

	x=0
	Do While Not Rs.Eof 
		MtzNoRosas(x,0) = Rs("Nombre")
		MtzNoRosas(x,TotalBodegas) = Rs("Producto")
		for m=1 to TotalBodegas-2
			MtzNoRosas(x,m) = Rs("Disponible")
			Rs.MoveNext
		next
		x = x + 1
	Loop

	Response.Write "<table border=0 width=100% hecellspacing=0 cellpaddin=0>"
		Response.Write "<tr>"
		Response.Write "<td class=FuenteTitulosFunciones align=center>Ayuda de NoRosas</td>"
		Response.Write "</tr>"
	Response.Write "</table>"

	Response.Write "<table border=1 width=100% cellspacing=0 cellpaddin=0>"
		Response.Write "<tr>"
			Response.Write "<td class=fuenteinput align=center>Producto</td>"
			aBodegas = Split(cBodegas,"¬")
			for a=1 to TotalBodegas-2
				Response.Write "<td class=FuenteInput align=center><b>" & aBodegas(a-1) & "</b></td>"
			next
		Response.Write "</tr>"

	for a=0 to Filas-1
		Response.Write "<tr>"
			for b=0 to TotalBodegas-2
				if b > 0 then
					if len(trim(MtzNoRosas(a,b))) = 0 then
						Pinta = "&nbsp;"
					elseif MtzNoRosas(a,b) = 0 then
						Pinta = "-"
					else
						Pinta = "<a href='JavaScript:ClipBoard( " & chr(34) & "Formulario" & chr(34) & ", " & chr(34) & "IdProd"&a & chr(34) & ", " & chr(34) & chr(34) & ", " & chr(34) & "c" & chr(34) & ");window.blur()'>" & MtzNoRosas(a,b) & "</a>"
					end if
				else
					Pinta = MtzNoRosas(a,b)
				end if
'				Response.Write "<td class=fuenteinput align=" & alinear & ">" & Pinta
				Response.Write "<td class=fuenteinput align=center>" & Pinta
				if b<>TotalBodegas-2 then Response.Write "</td>"
			next
			Response.Write "<SPAN ID='IdProd" & a & "' style='visibility:hidden'>" & MtzNoRosas(a,TotalBodegas)  & "¬¬¬¬¬</Span>"
			Response.Write "</td>"
		Response.Write "</tr>"
	next
%>
	</table>

</form>
</body>
</html>