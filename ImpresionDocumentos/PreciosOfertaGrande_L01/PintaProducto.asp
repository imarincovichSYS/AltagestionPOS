<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
	<script language="VbScript">		
		Id			= cDbl("0" + parent.top.frames(1).document.Frm_Mantencion.NroLineaDetalle.value)
	if Id > 0 then
		oProducto 		= "txtProducto"		& Id
		sProducto 		= "Span_Producto"	& Id
		sUnidad	  		= "Span_Unidad"		& Id
		oCodProdProv	= "txtCodProdProv"	& Id
		oNumIntMovProd	= "txtNumIntMovProd" & Id
		
		nNumIntMovProd	= parent.top.frames(1).document.all(oNumIntMovProd).value
		
		if parent.top.frames(1).document.all(oProducto).ReadOnly = false then
			CajaProducto = "<Input class=FuenteInput type=text size=26 maxlength=20 name='" & oProducto & "' value='<%=Request("CodigoProducto")%>' OnBlur='JavaScript:fCambiaNroLinea(" & Id & ")'>"
			CajaProducto = CajaProducto & "<Input class=FuenteInput type=hidden name='" & oCodProdProv & "' value='<%=Request("CodProdProv")%>'>"
			CajaProducto = CajaProducto & "<input class=FuenteInput type=hidden name='" & oNumIntMovProd & "' value=" & nNumIntMovProd & ">"

			SpanProducto = "<table width=90% align=left border=0 cellspacing=0 cellpadding=0>"
			SpanProducto = SpanProducto & "<tr class=FuenteEncabezados>"
			SpanProducto = SpanProducto & "<td valign=center Class=DatoVariableConCaja colspan=3 width=15% align=left>"
			SpanProducto = SpanProducto & "<Span  class=FuenteInput name='Span_Producto" & cStr(Id) & "' id='Span_Producto" & cStr(Id) & "'><%=Request("NombreProducto")%>&nbsp;</span>"
			SpanProducto = SpanProducto & "</td>"
			SpanProducto = SpanProducto & "</tr>"
			SpanProducto = SpanProducto & "</table>"

			SpanUnidad = "<table width=90% align=left border=0 cellspacing=0 cellpadding=0>"
			SpanUnidad = SpanUnidad & "<tr class=FuenteEncabezados>"
			SpanUnidad = SpanUnidad & "<td valign=center Class=DatoVariableConCaja colspan=3 width=15% align=left>"
			SpanUnidad = SpanUnidad & "<Span  class=FuenteInput id='Span_Unidad" & cStr(Id) & "'><%=Request("UnidadProducto")%>&nbsp;</span>"
			SpanUnidad = SpanUnidad & "</td>"
			SpanUnidad = SpanUnidad & "</tr>"
			SpanUnidad = SpanUnidad & "</table>"
	
			parent.top.frames(1).document.all("ListaDetalles").rows(Id).Cells(1).InnerHtml = CajaProducto
			parent.top.frames(1).document.all("ListaDetalles").rows(Id).Cells(2).InnerHtml = SpanProducto
			parent.top.frames(1).document.all("ListaDetalles").rows(Id).Cells(3).InnerHtml = SpanUnidad
		end if
	end if
	</script>
</body>
</html>