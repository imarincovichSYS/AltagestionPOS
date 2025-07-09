<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	Vendible = Request("Vendible") 'S o N
	Proveedor = Request("Proveedor")
%>
<script>var VentanaAbierta=true;</script>
<title>Ayuda de NoRosas</title>

<frameset rows="100%" framespacing=0 frameborder=0>
  <frame name="wnd_arriba"	src="List_AyudaProductos.asp?Proveedor=<%=Proveedor%>&Vendible=<%=Vendible%>" scrolling=auto marginwidth=0>
<!--  <frame name="wnd_abajo"	src='../../Empty.asp' scrolling=auto	marginwidth=0> -->
</frameset>
