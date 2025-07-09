<!-- #include file="Scripts/Inc/Cache.Inc" -->
<%
	Cache
'Response.Write Session("Dataconn_ConnectionString") & "**"
%>
<html>

<head>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
   <meta http-equiv="Pragma" content="no-cache">
   <meta http-equiv="Expires" content="Tue, 01 Jan 1980 1:00:00 GMT">   
   <title>Identificación</title>
   <link rel="stylesheet" type="text/css" href="CSS/Estilos.css">
	<script src="Scripts/Js/Caracteres.js"></script>
</head>
<body background="Imagenes/ImagenDfondo.jpg" leftmargin="0" topmargin="0">

<form name="Formulario" action="Validacion_Usuario.asp" method="post" target="Paso">

<table width=80% align=center height=100% border=0>
 <tr>
  <td valign=center>
		<table class="formulario" cellPadding="0" width="450" border="0" align="center">
			<tr>
			  <td align="Left" colspan="2" class="barratitulo">iPAQ - Módulo Supervisor</td>
			</tr>
			<tr>
			  <td align="center" colspan="2"><br>Digite el usuario y la clave de acceso para ingresar al sistema<br><br></td>
			</tr>
			<tr>
			  <td align="right" width="50%">Usuario</td>
				<td>
					<input type="text" size="9" maxlength="12" name="Usuario" class="FuenteInput">
				</td>
			</tr>
			<tr>
			  <td align="right">Clave acceso</td>
			  <td><input type="password" size="9" maxlength="12" name="Clave" class="FuenteInput"></td>
			</tr>
			<tr class=oculto>
				<td colspan=2 align="center">Si desea cambiar su clave ingresela a continuación</td>
			</tr>
			<tr class=oculto>
				<td colspan=2 align="center">
					<input type="password" size="8" maxlength="10" name="Nva_Clave" class="FuenteInput">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="password" size="8" maxlength="10" name="Reingreso_Nva_Clave" class="FuenteInput">
				</td>
		   </tr>
		   <tr >
			  <td align="center" colspan="2"><br>
			  <input type="button" OnClick="JavaScript:fIngresar()" value=" Aceptar " class="FuenteInput"><br><br>
			  </td>
		   </tr>
		</table>
	</td>
</tr>
<tr>					
	<td class="FuenteInput" align=center nowrap>
		<input class="TextoColorNegro" width=1 height=1 type=image name="Enter" src="<%=Session("ImagenFondo")%>">
	</td>
</tr>
</table>

</form>

</body>
</html>

<script language="JavaScript">
	function fCambiarClave()
	{
		var Error = 'N';
		var ClaveNueva			= document.Formulario.Nva_Clave.value;
		var ReingresoClaveNueva = document.Formulario.Reingreso_Nva_Clave.value;
		if ( ClaveNueva != ReingresoClaveNueva )
		{
			alert ( 'El reingreso de la clave no es consistente, por favor revise.' );
			document.Formulario.Reingreso_Nva_Clave.focus();
			Error = "S";
		}
		
		if ( Error == "N" )
		{
			document.Formulario.action = "CambioClave_Usuario.asp";		
			document.Formulario.target = "Paso";
			document.Formulario.submit();
		}
	}

	function fIngresar()
	{
		var ClaveNueva			= document.Formulario.Nva_Clave.value;
		var ReingresoClaveNueva = document.Formulario.Reingreso_Nva_Clave.value;
		if ( ! validEmpty(ClaveNueva) || ! validEmpty(ReingresoClaveNueva) )
		{
			fCambiarClave();
		}
		else
		{
			document.Formulario.action = "Validacion_Usuario.asp";
			document.Formulario.target = "Paso";
			document.Formulario.submit();
		}
	}
</script>