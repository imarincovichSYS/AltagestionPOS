<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache

	Codigo	= Request ( "Producto" )
	i=               0 + trim(Request ( "Productoi" ))

	msgerror=""
	error=0
	
	if len(Codigo) > 0 then
		Set ConnManejo= Server.CreateObject("ADODB.Connection")
		ConnManejo.Open Session( "DataConn_ConnectionString" )

		cSQL	=	"Exec PRO_ListaProductos '" & Codigo & "', '' , '', '" & Session("Empresa_usuario") & "', Null, Null, Null" 
		Set RsManejo = ConnManejo.Execute( cSQL )
		'Response.Write csql
		'break
		if RsManejo.eof then
		     msg="Producto no existe"
		else %>
     		<script language="JavaScript">
     		     parent.top.frames[1].document.all("Nombre_producto<%=trim(i)%>").innerHTML='<%=RsManejo("Nombre")%>' ;
     		     parent.top.frames[1].document.all("Unidad_de_medida_consumo<%=trim(i)%>").innerHTML='<%=RsManejo("Unidad_de_medida_consumo")%>&nbsp;' ;
		     </script>
		     <%msg=""
		end if
     end if
 %>
 
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
		<form name="Mensajes">
				<span class="FuenteEncabezados" id="IdMensaje">&nbsp;</span>
	     </form>
</body>

<%	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes_frame( valor )
				document.all("IdMensaje").InnerHtml = valor
			End Sub

		</script>
<%	else%>
		<script language="JavaScript">
			function Mensajes_frame( valor )
			{
				with (document.IdMensaje.document)
				{
				  open();
				  write(valor);
				  close();
				}
			}
		</script>
<%	end if%>


<script language="JavaScript">
     Mensajes_frame ('<%=msg%>');
     //history.back();
</script>
 