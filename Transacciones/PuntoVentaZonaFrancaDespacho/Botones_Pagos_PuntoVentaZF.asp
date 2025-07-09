<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then%>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
	<script src="../../js/jquery-1.7.2.min.js"></script>
<script language="JavaScript">
onsubmit = "No";
function Venta()
{		
parent.top.frames[1].Venta();
}
function AgregaDocumento()
{		
parent.top.frames[1].AgregaDocumento();
}
function EliminaDocumento()
{		
parent.top.frames[1].EliminaDocumento();
}
function Descuentos()
{		
parent.top.frames[1].Descuentos();
}

function fObservaciones()
{
    var sValue = window.showModalDialog ("Observaciones_ZF.asp", "valor", "dialogWidth:30;dialogHeight:15;center:yes;edge:sunken;unadorned:yes;status:no;help:no;")
}
 
function Terminar()
{
if ( onsubmit == "No" ) {
   onsubmit = "Si";
			
	//alert( parent.top.frames[1].document.getElementById("Numero_documentos_cobro").value );

	Numero_documentos_cobro = parent.top.frames[1].document.getElementById("Numero_documentos_cobro").value;
	for ( kk = 1; kk < Numero_documentos_cobro - 0; kk++ ) {
		objId = "Tipo_documento_cobro_" + kk;
		parent.top.frames[1].document.getElementById(objId).setAttribute("disabled","");
	}
	
	parent.top.frames[1].Terminar();
  }
}
</script>
</head>
<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
	
<table width=100% border=0 cellspacing=0 cellpadding=0>
<tr>
<td align="center"><a href="javascript:Venta()"><img src="ESC_venta.gif" border="0"/></a></td>
<td align="center"><a href="javascript:AgregaDocumento()"><img src="F6.gif" border="0"/></a></td>
<td align="center"><a href="javascript:EliminaDocumento()"><img src="F7.gif" border="0"/></a></td>
<td align="center"><a href="javascript:Descuentos()"><img src="F9.gif" border="0"/></a></td> 
<td align="center"><a href="javascript:fObservaciones()"><img src="Observaciones.jpg" border="0"/></a></td>
<td align="center"><a href="javascript:Terminar()"><img src="Enter.gif" border="0"/></a></td>
</tr>
</table>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
