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
		strSQL="select A.producto, A.nombre, A.Superfamilia, A.Familia, A.Subfamilia, A.Genero, A.Marca, B.valor_unitario as precio, C.codigo_postal as proveedor from " &_
               "(select producto, Superfamilia, Familia, Subfamilia, Genero, Marca, nombre, proveedor from productos where empresa='SYS' and producto='"&producto&"') A, " &_
               "(select producto, valor_unitario from productos_en_listas_de_precios where empresa='SYS' and lista_de_precios='"&lista_base&"') B, " &_
               "(select entidad_comercial, codigo_postal from entidades_comerciales where empresa='SYS') C " &_
               "where A.producto=B.producto and A.proveedor*=C.entidad_comercial"
	Else
		strSQL="select A.producto, A.nombre, A.Superfamilia, A.Familia, A.Subfamilia, A.Genero, A.Marca, B.valor_unitario as precio, C.codigo_postal as proveedor from " &_
               "(select producto, Superfamilia, Familia, Subfamilia, Genero, Marca, nombre, proveedor from productos where empresa='SYS' and producto = producto and Upper(nombre) like '%"&nombre&"%') A, " &_
               "(select producto, valor_unitario from productos_en_listas_de_precios where empresa='SYS' and lista_de_precios='"&lista_base&"') B, " &_
               "(select entidad_comercial, codigo_postal from entidades_comerciales where empresa='SYS' and " &_
			   "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial = 'P')) C " &_
               "where A.producto=B.producto and A.proveedor*=C.entidad_comercial " &_
			   "order by A.Superfamilia, " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Genero else A.Familia end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Familia else A.Subfamilia end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Subfamilia else A.Marca end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Marca else A.Producto end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.producto end) "
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

	strSQL="select A.producto, A.nombre, A.Superfamilia, A.Familia, A.Subfamilia, A.Genero, A.Marca, B.valor_unitario as precio, C.codigo_postal as proveedor from " &_
           "(select producto, Superfamilia, Familia, Subfamilia, Genero, Marca, nombre, proveedor from productos where empresa='SYS' "&strWhere&") A, " &_
           "(select producto, valor_unitario from productos_en_listas_de_precios where empresa='SYS' and lista_de_precios='"&lista_base&"') B, " &_
           "(select entidad_comercial, codigo_postal from entidades_comerciales where empresa='SYS' and " &_
		   "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial = 'P')) C " &_
           "where A.producto=B.producto and A.proveedor=C.entidad_comercial " &_
		   "order by A.Superfamilia, " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Genero else A.Familia end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Familia else A.Subfamilia end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Subfamilia else A.Marca end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Marca else A.Producto end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.producto end) "
ElseIf tipo_busqueda = "folio" Then
	folio	= Request.Form("folio")
	strSQL="select A.producto, A.nombre, A.Superfamilia, A.Familia, A.Subfamilia, A.Genero, A.Marca, B.precio, C.codigo_postal as proveedor from " &_
	       "(select producto, Superfamilia, Familia, Subfamilia, Genero, Marca, nombre, proveedor from productos where empresa='SYS') A, " &_
	       "(select producto, precio from cambios_de_precios where folio_cambio_de_precio='"&folio&"') B, " &_
		   "(select entidad_comercial, codigo_postal from entidades_comerciales where empresa='SYS' and " &_
		   "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial ='P')) C " &_
		   "where A.producto=B.producto and A.proveedor=C.entidad_comercial " &_
		   "order by A.Superfamilia, " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Genero else A.Familia end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Familia else A.Subfamilia end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Subfamilia else A.Marca end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Marca else A.Producto end), " &_
			   "(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.producto end) "
ElseIf tipo_busqueda = "ultimocambio" Then
	fecha_hoy = Date()
	fecha_menos_2_dias = DateAdd("d",-2, fecha_hoy)
	fecha_menos_2_dias_YYYY_DD_MM = Get_Fecha_Formato_YYYY_DD_MM(fecha_menos_2_dias)
	strSQL="select A.producto,  C.Superfamilia, C.Familia, C.Subfamilia, C.Genero, C.Marca, C.nombre, A.valor_unitario as precio, D.codigo_postal as proveedor from " &_
		   "(select distinct producto, valor_unitario, fecha from ZbitacoraProductos_en_listas_de_precios " &_
		   "where fecha >= '"&fecha_menos_2_dias_YYYY_DD_MM&"' and accion='I' and lista_de_precios='"&lista_base&"') A," &_
		   "(select distinct producto from productos_en_bodegas where empresa='SYS' and bodega='0011' and stock_real>0) B," &_ 
		   "(select producto, Superfamilia, Familia, Subfamilia, Genero, Marca, nombre, proveedor from productos where empresa='SYS') C, " &_
		   "(select entidad_comercial, codigo_postal from entidades_comerciales where empresa='SYS' " &_
		   "and (Tipo_entidad_comercial='A' or Tipo_entidad_comercial = 'P')) D " &_
           "where A.producto=B.producto and A.producto=C.producto and C.proveedor=D.entidad_comercial " &_
		   "order by C.Superfamilia, " &_
			   "(case when C.Superfamilia in (select rubro from Orden_rubros (nolock)) then C.Genero else C.Familia end), " &_
			   "(case when C.Superfamilia in (select rubro from Orden_rubros (nolock)) then C.Familia else C.Subfamilia end), " &_
			   "(case when C.Superfamilia in (select rubro from Orden_rubros (nolock)) then C.Subfamilia else C.Marca end), " &_
			   "(case when C.Superfamilia in (select rubro from Orden_rubros (nolock)) then C.Marca else A.Producto end), " &_
			   "(case when C.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.producto end) "
 ElseIf tipo_busqueda= "numeroguia" Then
	numeroguia = Request.Form("numeroguia")
	strSQL="select A.producto,  A.Superfamilia, A.Familia, A.Subfamilia, A.Genero, A.Marca, A.nombre, B.precio, C.codigo_postal as proveedor from " &_
	               "(select producto, Superfamilia, Familia, Subfamilia, Genero, Marca, nombre from productos) A,"&_
					"(select producto, precio=valor_unitario from productos_en_listas_de_precios where empresa='SYS' and lista_de_precios = (select Valor_texto from parametros where parametro = 'LP_BASE')) B,"&_
					"(select entidad_comercial, codigo_postal from entidades_comerciales where empresa='SYS' and Tipo_entidad_comercial='A' or Tipo_entidad_comercial ='P') C,"&_
					"(select empresa, documento_no_valorizado,numero_documento_no_valorizado,producto, proveedor from movimientos_productos where empresa='SYS' and documento_no_valorizado='TBS' and numero_documento_no_valorizado ='"&numeroguia&"') E "&_
					"Where  A.PRODUCTO = E.PRODUCTO and E.Producto = B.Producto and E.proveedor = C.entidad_comercial "&_
					"order by A.Superfamilia, " &_
					"(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Genero else A.Familia end), " &_
					"(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Familia else A.Subfamilia end), " &_
					"(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Subfamilia else A.Marca end), " &_
					"(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.Marca else A.Producto end), " &_
					"(case when A.Superfamilia in (select rubro from Orden_rubros (nolock)) then A.producto end) "
					
'ElseIf tipo_busqueda = "proveedor" Then
'	proveedor	= Request.Form("proveedor")
'	strSQL="select A.producto, A.nombre, B.precio, C.codigo_postal as proveedor from " &_
'	       "(select producto, nombre, proveedor from productos where empresa='SYS') A, " &_
'	       "(select producto, precio from cambios_de_precios where folio_cambio_de_precio=222026) B, " &_
'		   "(select entidad_comercial, codigo_postal from entidades_comerciales where empresa='SYS' and " &_
'		   "(Tipo_entidad_comercial='A' or Tipo_entidad_comercial ='P')) C " &_
'		   "where A.producto=B.producto and A.proveedor=C.entidad_comercial order by A.producto"
End If
'response.write strSQL
'response.end
Set rs = ConnAlta.Execute(strSQL)
cant_promociones = 0 : fila = 1
If Not rs.EOF Then
	w_imp				=30
	w_cant				=40
	w_fleje				=50
	w_gancho			=50
	w_grande			=50
	w_ofer				=50
	w_ofertop			=58
	w_producto			=65
	w_RuFaSub			=60
	w_Genero			=20
	w_Marca				=70
	w_precio_venta		=40
	w_proveedor			=70
	w_precio_promocion	=40
	w_table = 980
%>
<div style="width:<%=w_table%>px;">
<table class="table_cabecera" style="width:<%=w_table%>px;">
	<TR>
		<td colspan="3">
			<table>
				<tr>
					<td><input type="radio" name="tipoprecio" id="tipoprecio" value="verde">Verde</td>
					<td><input type="radio" name="tipoprecio" id="tipoprecio" value="rojo">Rojo</td>
				</tr>
			</table>
		</td>
	</TR>
	<tr align="center">
		<td style="width: <%=w_imp%>px;">IMP</td>
		<td style="width: <%=w_cant%>px;">CANT</td>
		<td style="width: <%=w_fleje%>px;">FLEJE</td>
		<td style="width: <%=w_gancho%>px;">GANCHO</td>
		<td style="width: <%=w_grande%>px;">GRANDE</td>
		<td style="width: <%=w_ofer%>px;">PROM.</td>
		<td rowspan="2" style="width: <%=w_producto%>px;" align="left">&nbsp;PRODUCTO</td>
		<td rowspan="2" style="width: <%=w_RuFaSub%>px;" align="Center">&nbsp;Ru Fa Sub</td>
		<td rowspan="2" style="width: <%=w_Genero%>px;" align="Center">&nbsp;G&nbsp;</td>
		<td rowspan="2" style="width: <%=w_Marca%>px;" align="Center">&nbsp;Marca</td>
		<td rowspan="2" align="left">&nbsp;DESCRIPCION</td>
		<td rowspan="2" style="width: <%=w_precio_venta%>px;">PRECIO VENTA</td>
		<td rowspan="2" style="width: <%=w_proveedor%>px;">PROVEEDOR</td>
		<td rowspan="2" style="width: <%=w_precio_promocion%>px;">PRECIO PROM.</td>
	</tr>
	<tr align="center">
		<td><input type="checkbox" name="todos_imprimir" value="todos_imprimir" onclick="selectAllcheck(1);"></td>
		<td align="center"><input type="text" name="todos_cantidad" class="todos_cantidad" id="todos_cantidad" style="width:24px;" maxlength=1></td>
		<td><input type="radio" name="todos_radio" id="todos_radio" value="todos_fleje" onclick="selectAllRadio();"></td>
		<td><input type="radio" name="todos_radio" id="todos_radio" value="todos_gancho" onclick="selectAllRadio();"></td>
		<td><input type="radio" name="todos_radio" id="todos_radio" value="todos_grande" onclick="selectAllRadio();"></td>
		<td><input type="checkbox" name="todos_oferta" id="todos_oferta" value="todos_oferta" onclick="selectAllcheck(2);"></td>
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
		<td style="width: <%=w_imp%>px;" align="center"><input 
		OnClick="if(this.checked)$('#oferta_<%=fila%>').attr('checked',false);"
		type="checkbox" class="imprimir_all" name="imprimir_<%=fila%>" id="imprimir_<%=fila%>" value="imprimir_<%=fila%>"></td>
		<td style="width: <%=w_cant%>px;" align="center"><input OnKeyPress="return Valida_Digito(event)" type="text" name="cantidad_<%=fila%>" class="cantidad_all" id="cantidad_<%=fila%>" style="width:24px;" maxlength=2></td>
		<td style="width: <%=w_fleje%>px;" align="center"><input type="radio" name="radio_tipo_precio_<%=fila%>" id="radio_tipo_precio_<%=fila%>" value="fleje"></td>
		<td style="width: <%=w_gancho%>px;" align="center"><input type="radio" name="radio_tipo_precio_<%=fila%>" id="radio_tipo_precio_<%=fila%>" value="gancho"></td>
		<td style="width: <%=w_grande%>px;" align="center"><input type="radio" name="radio_tipo_precio_<%=fila%>" id="radio_tipo_precio_<%=fila%>" value="grande"></td>
		<td style="width: <%=w_ofer%>px;" align="center"><input 
		<%If precio_promocion > 0 Then 
			cant_promociones = cant_promociones + 1
		%> 
			checked 
		<%else%>
			disabled 
		<%End if%>
		type="checkbox" 
		OnClick="if(this.checked)$('#imprimir_<%=fila%>').attr('checked',false);"
		class="ofertas_all" name="oferta_<%=fila%>" id="oferta_<%=fila%>" value="oferta"></td>
		<td style="width: <%=w_producto%>px;">&nbsp;<%=trim(Rs("producto"))%></td>
		<input type="hidden" id="cod_producto_<%=fila%>" name="cod_producto_<%=fila%>" value="<%=trim(Rs("producto"))%>">
		<td style="width: <%=w_RuFaSub%>px;">&nbsp;<%=trim(Rs("Superfamilia"))%>&nbsp;<%=trim(Rs("Familia"))%>&nbsp;<%=trim(Rs("Subfamilia"))%></td>
		<td style="width: <%=w_Genero%>px;" Align=Center>&nbsp;<%=trim(Rs("Genero"))%>&nbsp;</td>
		<td style="width: <%=w_Marca%>px;">&nbsp;<%=trim(Rs("Marca"))%></td>
		<td>&nbsp;<%=trim(rs("nombre"))%></td>
		<input type="hidden" id="desc_prod_<%=fila%>" name="desc_prod_<%=fila%>" value="<%=trim(rs("nombre"))%>">
		<td style="width: <%=w_precio_venta%>px;" align="right"><%=formatNumber(rs("precio"),0)%>&nbsp;</td>
		<input type="hidden" id="precio_venta_<%=fila%>" name="precio_venta_<%=fila%>" value="<%=formatNumber(rs("precio"),0)%>">
		<td style="width: <%=w_proveedor%>px;"><%=rs("proveedor")%></td>
		<td style="width: <%=w_precio_promocion%>px;" align="right"><%=FormatNumber(precio_promocion,0)%>&nbsp;</td>
		<input type="hidden" id="precio_promocion_<%=fila%>" name="precio_promocion_<%=fila%>" value="<%=FormatNumber(precio_promocion,0)%>">
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