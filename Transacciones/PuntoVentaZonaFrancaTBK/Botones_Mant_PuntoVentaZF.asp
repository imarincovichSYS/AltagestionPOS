<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then%>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
<script language="JavaScript">
function Pagos()
{		
parent.top.frames[1].Pagos();
}
function Consulta()
{		
parent.top.frames[1].Consulta();
}
function Eliminar()
{		
parent.top.frames[1].Eliminar();
}

function fObservaciones()
{
    parent.top.frames[1].fObservaciones()
}

function Descuento()
{		
parent.top.frames[1].Descuento();
}
</script>
</head>
<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
	
<table width=100% border=0 cellspacing=0 cellpadding=0>
<tr>
<td align="center"><a href="javascript:Pagos()"><img src="ESC_pagos.gif" border="0"/></a></td>
<td align="center"><a href="javascript:Consulta()"><img src="F2.gif" border="0"/></a></td> 
<td align="center"><a href="javascript:fObservaciones()"><img src="Observaciones_F7.jpg" border="0"/></a></td> 
<td align="center"><a href="javascript:Eliminar()"><img src="F8.gif" border="0"/></a></td>
</tr>
</table>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
