<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if

if	len(trim(request("Fiscal_actual"))) > 0 then
  session("Fiscal_actual") = request("Fiscal_actual")
else
  session("Fiscal_actual") = 99
end if

Fiscal_actual = session("Fiscal_actual")

	if request("Login_punto_venta") <> "" then
   Session("Login_punto_venta") = request("Login_punto_venta")
	 session("Nombre_usuario_boleta") = Session("Login_punto_venta")
  end if

%>

<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<body OnLoad="placeFocus()"  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center>&nbsp;&nbsp;&nbsp;&nbsp;<%=session("title")%></td>
			</tr>
		</table>

	<Form name="Frm_Mantencion" method="post" action="Mant_pais.asp?accion=N" target="Seleccion">

		<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteEncabezados">
				<td width=33% class="FuenteEncabezados" align=center>
					<input class="FuenteEncabezados" type=button name="btnCierrePeriodo" value="Cierre Período Venta (Z)" OnClick="javascript:fManejo(1)">
				</td>

				<td width=33% class="FuenteEncabezados" align=center>
					<input class="FuenteEncabezados" type=button name="btnInformeX" value="Informe X" OnClick="javascript:fManejo(2)">
				</td>

				<td width=33% class="FuenteEncabezados" align=center>
					<input class="FuenteEncabezados" type=button name="btnApertura" value="Apertura de periodo" OnClick="javascript:fManejo(3)">
				</td>

			</tr>
      <tr>
          <td width=33% class="FuenteEncabezados" align=center colspan="3"><br>
              <input class="FuenteEncabezados" type=button name="btnApertura" value="Instalación del controlador de la impresora" OnClick="javascript:fInstala()">
          </td>
      </tr>
		</table>
	</Form>

	<iframe id="Paso" name="Paso" src="../../empty.asp" height=0 width=0></iframe>

	<script language="javascript">
		///parent.Mensajes.location.href = "../../Mensajes.asp";
	   
	  var session_login = "<%=session("LOGIN")%>"
		function fManejo( valor )
		{
		  if (valor == 1 && session_login == "")
      {
         alert ("se ha perdido la sesión del sistema. Por favor ingrese nuevamente") 
         location.href = "../../index1.asp";
         return;
      } 
			Paso.location.href = "Manejo_IF.asp?Manejo=" + valor + "&Fiscal_actual=" + <%=Fiscal_actual%>;
		}	   
		function fInstala()
		{
			location.href = "instalacion.htm";
		}

	</script>
  </body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
