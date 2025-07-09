<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	Vendible = Request("Vendible") 'S o N
%>
<script>var VentanaAbierta=true;</script>
<title>Ayuda de cuentas contables</title>

<frameset rows="30%,*" framespacing=0 frameborder=0>
  <frame name="wnd_arriba"	src="Find_AyudaCtasCtbles.asp?Vendible=<%=Vendible%>" scrolling=no	marginwidth=0>
  <frame name="wnd_abajo"	src='../../Empty.asp' scrolling=auto	marginwidth=0>
</frameset>
