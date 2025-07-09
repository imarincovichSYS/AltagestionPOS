<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
  <body>
	<script language="JavaScript">
		parent.Trabajo.location.href = 'Find_DocVtaNul.asp'
		parent.Mensajes.location.href = '../../Mensajes.asp';
	</script>
  </body>
     
<%else
	Response.Redirect "../../index.htm"
end if%>
</html>
