<!-- #include file="../../Scripts/Asp/Conecciones.asp" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	SET Conn = AbrirConexion ( Session("Dataconn_ConnectionString") )

	Producto		= Request ("Producto")
    Bodega			= Request ("Bodega")
    Superfamilia	= Request ("Slct_SuperFam")
    Familia			= Request ("Slct_Familia")
    Subfamilia		= Request ("Slct_SubFamilia")
	Empresa			= Session ("Empresa_usuario")
		
	cSql = "Exec PRB_Toma_Inventario "
	cSql = cSql & "'" & Session ("Empresa_usuario") & "', "
	cSql = cSql & "'" & Bodega & "', "
	cSql = cSql & "'" & Producto & "', "
	cSql = cSql & "'" & Superfamilia & "', "
	cSql = cSql & "'" & Familia & "', "
	cSql = cSql & "'" & SubFamilia & "'"
	
	SET Rs	=	Conn.Execute( cSql )
%>
<html>
<head>
	<title><%=session("title")%></title>	
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Ventanas.js"></script>
</head>

<body OnLoad="Javascript:maximizeWin()">
<form name="Listado">
			<%if Not Rs.Eof then %>
				<table width="95%" border=0 align=center cellpadding=0 cellspacing=0>
					<tr class="FuenteTitulosFunciones">
						<td colspan=7 align=center NOWRAP >&nbsp;<a href="JavaScript:window.close()"><%=session("title")%></a>&nbsp;</td>
					</tr>
					<tr height=40 class="FuenteInput">
						<td colspan=6 align=left NOWRAP>Emitido por:&nbsp;&nbsp;<b><%=Session("Nombre_Usuario")%></b></td>
						<td align=right NOWRAP >&nbsp;<b><%=left(Now(),16)%></b>&nbsp;</td>
					</tr>

					<%if len(trim(Request("Bodega")))+len(trim(Request("Producto"))) > 0 then %>
					<tr class="FuenteInput">
						<%if len(trim(Request("Bodega"))) > 0 then%>
						<td class="FuenteInput" width=10% align=left >Bodega</td>
						<td width=30% align=left><b><%=Request("Bodega")%></b></td>
						<%end if%>

						<%if len(trim(Request("Producto"))) > 0 then%>
						<td class="FuenteInput" width=10% align=left >Producto</td>
						<td width=30% align=left><b><%=Request("Producto")%></b></td>
						<%end if%>
					</tr>
					<%end if%>

					<%if len(trim(Request("Slct_SuperFam")))+len(trim(Request("Slct_Familia")))+len(trim(Request("Slct_SubFamilia"))) > 0 then %>
					<tr class="FuenteInput">
						<%if len(trim(Request("Slct_SuperFam"))) > 0 then%>
						<td class="FuenteInput" width=10% align=left >Superfamilia</td>
						<td width=30% align=left><b><%=Request("Slct_SuperFam")%></b></td>
						<%end if%>

						<%if len(trim(Request("Slct_Familia"))) > 0 then%>
						<td class="FuenteInput" width=10% align=left >Familia</td>
						<td width=30% align=left><b><%=Request("Slct_Familia")%></b></td>
						<%end if%>
						<%if len(trim(Request("Slct_SubFamilia"))) > 0 then%>
							<td class="FuenteInput" width=15% align=left >SubFamilia</td>
							<td width=30%  align=left><b><%=Request("Slct_SubFamilia")%></b>
							</td>
						<%end if%>
					</tr>
					<%end if%>
				</table>
				<br>
				<table width="95%" border=0 align=center cellpadding=4 cellspacing=0>
					<tr class="FuenteCabeceraTabla">
						<td style="border: 1px solid black; "				   width=05% align=center >Código</td>
						<td style="border: 1px solid black; border-left: none" width=10% align=center >Código Catálogo</td>
						<td style="border: 1px solid black; border-left: none" width=10% align=center >EAN13</td>
						<td style="border: 1px solid black; border-left: none" width=15% align=right  >Stock contado</td>
						<td style="border: 1px solid black; border-left: none" width=30% align=left   >Descripción</td>
						<td style="border: 1px solid black; border-left: none" width=05% align=center >U/M</td>
						<td style="border: 1px solid black; border-left: none" width=25% align=center colspan=3>Ubicaciones (1,2,3)</td>
					</tr>
			<%		i=0
					do While Not Rs.Eof%>
						<tr class="FuenteInput">
							<td style="border: 1px solid black; border-top:  none"					  NOWRAP align=center ><%=rs("Codigo")%>&nbsp;</td>
							<td style="border: 1px solid black; border-left: none; border-top:  none" NOWRAP align=center ><%=rs("Codigo_Catalogo")%>&nbsp;</td>
							<td style="border: 1px solid black; border-left: none; border-top:  none" NOWRAP align=center ><%=rs("EAN13")%>&nbsp;</td>
							<td style="border: 1px solid black; border-left: none; border-top:  none" NOWRAP align=right  >&nbsp;</td>
							<td style="border: 1px solid black; border-left: none; border-top:  none" NOWRAP align=left   ><%=rs("Nombre_producto")%>&nbsp;</td>
							<td style="border: 1px solid black; border-left: none; border-top:  none" NOWRAP align=center ><%=rs("UnidadMedida")%>&nbsp;</td>
							<td style="border: 1px solid black; border-left: none; border-top:  none" NOWRAP align=center >&nbsp;<%=rs("Ubicacion1")%>&nbsp;</td>
							<td style="border: 1px solid black; border-left: none; border-top:  none" NOWRAP align=center >&nbsp;<%=rs("Ubicacion2")%>&nbsp;</td>
							<td style="border: 1px solid black; border-left: none; border-top:  none" NOWRAP align=center >&nbsp;<%=rs("Ubicacion3")%>&nbsp;</td>
						</tr>
					<%	rs.MoveNext
						Loop
					%>
				</table>

			<script language="JavaScript">
					this.window.focus();
					//printPage();
					function printPage()
					{
						if (window.print)
						{
							window.print();
						}
						else
						{
							Mensajes ("Este browser no soporta impresión en modo automático, solamente en modo manual CTRL+P.");
						}
					}
			</script>
				
<%		Else
			abspage = 0 %>
			<table Width=95% border=0 cellspacing=2 cellpadding=2 >
			    <tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=20% align=left><B>No hay registros disponibles para el criterio de búsqueda escogido.</B></td>
				</tr>
			</table>
		<%End If
						
		rs.Close
		Set rs = Nothing
%>
</form>
</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
