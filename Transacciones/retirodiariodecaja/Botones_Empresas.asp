<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
'	if Session("Browser") = 0 then
		JavaScript = "JavaScript:"
'	end if
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
	<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<%	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes_frame( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	else%>
		<script language="JavaScript">
			function Mensajes_frame( valor )
			{
				with (parent.top.frames[3].document.IdMensaje.document)
				{
				  open();
				  write(valor);
				  close();
				}
			}
		</script>
<%	end if%>


<script language="JavaScript">
	function Mensajes( valor )
	{
		window.status = valor ;
	}

	function Actualizar()
	{
	    alert (1)
			parent.top.frames[1][1].document.frm_mantencion.action = "Save_Empresas.asp"
			parent.top.frames[1][1].document.frm_mantencion.submit();

	}


	
	function Cerrar()
	{
		parent.top.frames[1].location.href = "Empty.asp?pagenum=<%=session("pagenum")%>";
		parent.top.frames[2].location.href = "Empty.asp";
    		
	}	
	
</script>

<script language="vbScript">
			Sub Mensajes( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">

<Form name="Formulario_Botones" method="post" action="Mant_Empresas.asp" target="Listado">
	<input type="hidden" name="Nombre" value="">
	<input type="hidden" name="Empresa" value="">
	<input type="hidden" name="pagenum"		value="">
	<input type="hidden" name="Orden"		value="1">
	<input type="hidden" name="Nuevo"		value="S">
	
	<table width=100% border=0 cellspacing=0 cellpadding=0>
		<tr class="FuenteBotonesLink" width=100%>
<!--
	El Request("SinRegistros") Si es "S" entonces significa que trae registros por lo tanto
	Desplegará los botones correspondientes al proceso invocado. Si es Nuevo o va Actualizar
	Este efecto es para cuando se ha eliminado un registro por un lado y van a eliminar el mismo
	registro por otro lado con una lista antigua de pantalla.
-->
<%if Request("SinRegistros") <> "S" then%>
	<%if Request("Nuevo") = "S" then %>
			<td align=center width=25% nowrap>
				<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Graba la nueva empresa que se está ingresando.")'  OnMouseMove='<%=JavaScript%>Mensajes("Graba la nueva empresa que se está ingresando.")' Onfocus='<%=JavaScript%>Mensajes("Graba la nueva empresa que se está ingresando.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:Actualizar()" >Agregar</a></b>
			</td> 
	<%else%>
			<td align=center width=25% nowrap>
				<!--<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Actualiza la empresa que se está editando.")' OnMouseMove='<%=JavaScript%>Mensajes("Actualiza la empresa que se está editando.")' Onfocus='<%=JavaScript%>Mensajes("Actualiza la empresa que se está editando.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:Actualizar()" >Imprimir y Grabar Retiro</a></b>-->
			</td> 
	<%end if%>
<%end if%>
			<td align=left width=25% nowrap>
				<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Vuelve al menú principal de empresas, cancelando los cambios realizados en esta edición.")'  OnMouseMove='<%=JavaScript%>Mensajes("Vuelve al menú principal de empresas, cancelando los cambios realizados en esta edición.")' Onfocus='<%=JavaScript%>Mensajes("Vuelve al menú principal de empresas, cancelando los cambios realizados en esta edición.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:Cerrar()" >Cerrar</a></b>
			</td> 
		</tr>
	</table>
</Form>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
