<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
Server.ScriptTimeOut = 1000
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn_Alta

fecha_hoy_YYYY_MM_DD = Get_Fecha_Formato_YYYY_MM_DD(Date)
nom_dia_semana = GetDiaSemana(Weekday(date,0))

lista_base = Request.Form("lista_base")
lista_base = "L01"
tipo_busqueda	= Request.Form("tipo_busqueda")
solo_promocion = Request.Form("solo_promocion")

If tipo_busqueda = "producto" then
	producto	=Unescape(Request.Form("producto"))
	nombre		= UCase(Trim(Unescape(Request.Form("nombre"))))
	If producto <> "" then
		strSQL="select A.producto, A.nombre, B.valor_unitario as precio, C.codigo_postal as proveedor from " &_
               "(select producto, nombre, proveedor from productos where empresa='SYS' and producto='"&producto&"') A, " &_
               "(select producto, valor_unitario from productos_en_listas_de_precios where empresa='SYS' and lista_de_precios='"&lista_base&"') B, " &_
               "(select entidad_comercial, codigo_postal from entidades_comerciales where empresa='SYS') C " &_
               "where A.producto=B.producto and A.proveedor=C.entidad_comercial"
	Else
		strSQL="select A.producto, A.nombre, B.valor_unitario as precio, C.codigo_postal as proveedor from " &_
               "(select producto, nombre, proveedor from productos where empresa='SYS' and producto = producto and Upper(nombre) like '%"&nombre&"%') A, " &_
               "(select producto, valor_unitario from productos_en_listas_de_precios where empresa='SYS' and lista_de_precios='"&lista_base&"') B, " &_
               "(select entidad_comercial, codigo_postal from entidades_comerciales where empresa='SYS' and " &_
			   "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial = 'P')) C " &_
               "where A.producto=B.producto and A.proveedor=C.entidad_comercial order by A.producto"
	End if
ElseIf tipo_busqueda = "estructura" then
	superfamilia	= Request.Form("superfamilia")
	familia			= Request.Form("familia")
	subfamilia		= Request.Form("subfamilia")
	
	strWhere = ""
	If superfamilia <> "" Then
		strWhere = " and superfamilia = '"&superfamilia&"' "
	End If
	
	If familia <> "" Then
		strWhere = strWhere & " and familia = '"&familia&"' "
	End If
	
	If subfamilia <> "" Then
		strWhere = strWhere & " and subfamilia = '"&subfamilia&"' "
	End If

	strSQL="select A.producto, A.nombre, B.valor_unitario as precio, C.codigo_postal as proveedor from " &_
           "(select producto, nombre, proveedor from productos where empresa='SYS' "&strWhere&") A, " &_
           "(select producto, valor_unitario from productos_en_listas_de_precios where empresa='SYS' and lista_de_precios='"&lista_base&"') B, " &_
           "(select entidad_comercial, codigo_postal from entidades_comerciales where empresa='SYS' and " &_
		   "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial = 'P')) C " &_
           "where A.producto=B.producto and A.proveedor=C.entidad_comercial order by A.producto"
ElseIf tipo_busqueda ="proveedor" Then
	proveedor = Request.Form("proveedor")
	'hacer la consulta a la base de datos

End If
Set rs = ConnAlta.Execute(strSQL)
cant_promociones = 0 : fila = 1
If Not rs.EOF Then
	w_imp								=30
	w_cant								=40
	w_fleje								=50
	w_gancho							=50
	w_grande							=50
	w_ofer								=50
	w_ofertop							=58
	w_producto						=70
	w_precio_venta				=50
	w_proveedor						=70
	w_precio_promocion		=70
	w_ara									=200
	w_arac								=200
	w_table								=1000
%>
<div style="width:<%=w_table+17%>px;">
	<table>
		<tr>
			<td>Codigo Arancelario</td><td><input type="text" name="cod_arancelario" style="width: 75px;" maxlength="8"></td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>Descripcion</td><td><input type="text" name="desc_arancelario" style="width: 500px;" maxlength="62"></td>
			<td><input type="button" name="guardar" value="Actualizar" id="guardar" onclick="guardar();"></td>
		</tr>
	</table>
	<table class="table_cabecera" style="width:<%=w_table%>px;">
		<tr align="center">
			<td style="width: <%=w_imp%>px;">SEL</td>
			<!--<td style="width: <%=w_cant%>px;">CANT</td>-->
			<td rowspan="2" style="width: <%=w_producto%>px;" align="left">&nbsp;PRODUCTO</td>
			<td rowspan="2" align="left">&nbsp;DESCRIPCION</td>
			<td rowspan="2" align="left" style="width: <%=w_ara%>px;">CODIGO ARANCELARIO</td>
			<td rowspan="2" align="left" style="width: <%=w_arac%>px;">DESC. CODIGO ARANCELARIO</td>
		</tr>
		<tr align="center">
			<td><input type="checkbox" name="todos_imprimir" value="todos_imprimir" onclick="selectAllcheck(1);"></td>
		</tr>
	</table>
</div>
<div style="width: <%=w_table+17%>px; height:360px; overflow:auto;">
<table class="table_detalle" style="width:<%=w_table%>px;">
	<%
	Do While Not rs.EOF
		strSQL="select C1.promocion, C1.monto_descuento, C2.fecha_inicio, C2.fecha_termino, C2.estado from " &_
		       "(select promocion, monto_descuento from productos_en_promociones where producto='"&trim(Rs("producto"))&"') C1, " &_
			   "(select promocion, fecha_inicio, fecha_termino, estado from promociones where estado='A' and Dia_"&nom_dia_semana&"='S' and " &_
			   " (convert(varchar(10),fecha_inicio,111)<='"&fecha_hoy_YYYY_MM_DD&"' and '"&fecha_hoy_YYYY_MM_DD&"'<=convert(varchar(10),fecha_termino,111))) C2 " &_
			   "where C1.promocion=C2.promocion"
		'response.write strSQL
		'response.end
		Set rs_prom = ConnAlta.Execute(strSQL) : precio_promocion = 0
		If Not rs_prom.EOF Then 
			If CDbl(rs("precio")) - CDbl(rs_prom("monto_descuento")) > 0 Then precio_promocion = CDbl(rs("precio")) - CDbl(rs_prom("monto_descuento"))
		End If
		mostrar_fila  = false
		If solo_promocion = "NO" Then
			mostrar_fila = True
		Else 'SI
			If precio_promocion > 0 Then mostrar_fila = True
		End If
		If mostrar_fila Then
		%>
		<tr>
		<td style="width: <%=w_imp%>px;" align="center"><input OnClick="if(this.checked)$('#oferta_<%=fila%>').attr('checked',false);" type="checkbox" class="imprimir_all" name="imprimir_<%=fila%>" id="imprimir_<%=fila%>" value="imprimir_<%=fila%>"></td>
		<td style="width: <%=w_producto%>px;">&nbsp;<%=trim(Rs("producto"))%></td>
		<input type="hidden" id="cod_producto_<%=fila%>" name="cod_producto_<%=fila%>" value="<%=trim(Rs("producto"))%>">
		<td>&nbsp;<%=trim(rs("nombre"))%></td>
		<input type="hidden" id="desc_prod_<%=fila%>" name="desc_prod_<%=fila%>" value="<%=trim(rs("nombre"))%>">
		<td style="width: <%=w_ara%>px;">Aqui va codigo ara</td>
		<td style="width: <%=w_arac%>px;">Aqui va descripcion codigo ara</td>
		</tr>
		<%
		fila = fila + 1
		End if
	  rs.MoveNext
	loop%>
</table>
</div>
<%End if%>
<input type="hidden" id="total_filas" name="total_filas" value="<%=fila-1%>">
<input type="hidden" id="total_promociones" name="total_promociones" value="<%=cant_promociones%>">