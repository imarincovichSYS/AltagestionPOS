<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<%
	Cache

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600

     num_retiro = request("num_retiro")
     impresora = request("impresora")
     rut_cajero = request("rut_cajero")
     nombre_cajero = request("nombre_cajero")
     Fecha_solicitada_informe = month(request("Fecha_solicitada_informe")) & "/" & day(request("Fecha_solicitada_informe")) & "/" & year(request("Fecha_solicitada_informe"))
     Retiro = request("Retiro")
    
%>
<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Fechas.js"></script>
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
	<script src="../../Scripts/Js/Ventanas.js"></script>
</head>
<%     
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	else%>
		<script language="JavaScript">
			function Mensajes( valor )
			{
				with (parent.top.frames[3].document.IdMensaje.document)
				{
				  open();
				  write(valor);
				  close();
				}
			}
		</script>
<%	end if

	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if

	empresa=session("empresa_usuario")
%>

	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=50% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=50% class="FuenteTitulosFunciones" align=center nowrap><a href="javascript:window.close();">Reimpresión de Retiro</a></td> 
			</tr>
		</table>

		<Form name="Formulario" method="post" action="reimpresion_retiro.asp">
		 <table width=60%  align=center>
		  <caption class="FuenteCabeceraTabla">S Á N C H E Z &nbsp;&nbsp; & &nbsp;&nbsp; S Á N C H E Z</caption>
		  <tr>
      <td class="FuenteCabeceraTabla" align=right>Nº RETIRO: </td><td class="FuenteInput"><%=num_retiro%></td>
      </tr>
		  <tr>
      <td class="FuenteCabeceraTabla" align=right>FECHA: </td><td class="FuenteInput"><%=Fecha_solicitada_informe%></td>
      </tr>
      <tr>
      <td class="FuenteCabeceraTabla" align=right>IMPRESORA: </td><td class="FuenteInput"><%=impresora%></td>
      </tr>
      <tr>
      <td class="FuenteCabeceraTabla" align=right>RUT: </td><td class="FuenteInput"><%=rut_cajero%></td>
      </tr>
      <tr>
      <td class="FuenteCabeceraTabla" align=right>CAJERO(A): </td><td class="FuenteInput"><%=nombre_cajero%></td>
      </tr>
      <tr>
      <td class="FuenteCabeceraTabla" align=right>MONTO $: </td><td class="FuenteInput"><%=formatNumber(Retiro,0)%></td>
      </tr>
      <tr>
           <td align=center><input type=submit name="reimprimir_retiro" value="Imprimir"></td>
      </tr>
     </table>

     <input type=hidden name="Fecha_solicitada_informe" value=<%=Fecha_solicitada_informe%>>    
     <input type=hidden name="num_retiro" value=<%=num_retiro%>>
     <input type=hidden name="impresora" value=<%=impresora%>>
     <input type=hidden name="rut_cajero" value=<%=rut_cajero%>>
     <input type=hidden name="nombre_cajero" value=<%=nombre_cajero%>>
     <input type=hidden name="Retiro" value=<%=Retiro%>>

     
		</form>
	</body>
<%conn.close()%>
<%else
	Response.Redirect "../../index.htm"
end if%>
	<script language="JavaScript">
		//maximizeWin()
	</script>
</html>
