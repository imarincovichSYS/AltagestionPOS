<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then%>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
<script language="JavaScript">
function Venta()
{		
parent.top.frames[1].Venta();
}
</script>
</head>
<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
	
<table width=100% border=0 cellspacing=0 cellpadding=0>
<tr>
<td align="center"><a href="javascript:Venta()"><img src="ESC_venta.gif" border="0"/></a></td>
<td align="center"><a href="javascript:Venta()"><img src="F8_venta.gif" border="0"/></a></td>
</tr>
</table>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>