<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if
%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../js/tools.js"></script>
</head>
	<body Onload="Formulario.Codigo_pais.focus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<Form name="Formulario" method="post" target="Listado">		
			<table width=30% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td class="FuenteEncabezados" width=5% align=left ><b>Código</b></td>
					<td width=50% align=left>
						<input
						OnKeyPress="javascript:SetKey(event);if(key==13)document.Formulario.boton1.focus()"
            OnBlur="Consultar()"  
            type="text" name="Codigo_pais" value = "" size=20 maxlength=20 >
            <input type="text" name="boton1" id="boton1" style="border:0px; width:0px;">
					</td>
				</tr>    
		  </table>
		</form>
	</body>
</html>
<script language="javascript">
function Consultar(){
  if(document.Formulario.Codigo_pais.value!="")
  {
    document.Formulario.action="List_Productos.asp" 
    document.Formulario.submit()
    document.Formulario.Codigo_pais.value=""
    document.Formulario.Codigo_pais.focus()
  }
}
</script>

<%else
	Response.Redirect "../../index.htm"
end if%>
