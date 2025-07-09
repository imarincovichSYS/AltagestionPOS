<%
	Producto=request.Form("v_id_buscar_x_cod_desc")
	Descripcion=request.Form("v_desc_buscar_x_cod_desc")
	tabla = "<table><tr><td>Producto</td><td>Precio Venta</td><td>Provedor</td><td>Precio Promoci&oacute;n</td></tr></table>"
	Response.Write(tabla)
%>