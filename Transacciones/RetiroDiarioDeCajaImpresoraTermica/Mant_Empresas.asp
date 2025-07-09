<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if
%>

<%session("pagenum")=request("pagenum")
	Empresa	= Request ( "Empresa" )
	Nombre	= Request ( "Nombre" )
	Orden		= Request ( "Orden" )
  Rut		= Request ( "Rut" )
  Zona_franca = Request( "Zona_franca" )

	RegistroExistente = "S"
	Nuevo		= Request("Nuevo")
	Control		= 0

' Si Nuevo = S significa que es nuevo si es igual a N significa que existe y hay que
' buscarlo
	if Nuevo = "N" then
		SET Conn = Server.CreateObject("ADODB.Connection")
		Conn.Open Session("Dataconn_ConnectionString")
		Conn.commandtimeout=600
		Sql = "Exec EMP_ListaEmpresas '"  & Request("Empresa") & "', " +_
									"'" & Request("Nombre") & "', " +_
									"0" & Orden & "" 
	'Response.Write Sql
		SET RsUpdate	=	Conn.Execute( SQL )
		If Not RsUpdate.eof then
			Empresa		= RsUpdate ( "Empresa" )
			Nombre      = RsUpdate ( "Nombre" )
			RazonSocial	= RsUpdate ( "Razon_Social" )
			Telefono	= RsUpdate ( "Telefono" )	
			Direccion	= RsUpdate ( "Direccion" )	
			Control		= RsUpdate ( "Control" )
      Rut	= RsUpdate ( "Rut" )	
			Zona_franca		= RsUpdate ( "Zona_franca_o_no" )
		else
			RegistroExistente		= "N"
		end if
			RsUpdate.Close
			Conn.Close  		
	end if
'Response.Write Accion
%>

<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<body OnLoad="placeFocus()"  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

<%if RegistroExistente = "S" Then %>
		
	<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
		<tr>
			<td width=100% class="FuenteTitulosFunciones" align=center>&nbsp;&nbsp;&nbsp;&nbsp;<%=session("title")%></td>
		</tr>
	</table>

	<Form name="Frm_Mantencion" method="post" action="Mant_Empresas.asp?accion=N" target="Trabajo">
		<input type=hidden name="pagenum" 		value = "<%=Request("pagenum")%>">
		<input type=hidden name="Orden"			value = "<%=Orden%>">
		<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
			<tr>
	  			<td width=10% class="FuenteEncabezados" align=left>
					<b>Código</b>
					<input type=hidden name="Control" value=<%=Control%>>
				</td>
				<%	if Nuevo = "N" then %>
						<td nowrap width=80% class="FuenteEncabezados" align=left >
						     <span style=width:12ex class=DatoVariableConCaja ><%=Empresa%></span>
							<input type=hidden name="Empresa"  value="<%=Empresa%>">
						</td>
				<%	else%>
						<td class="FuenteEncabezados" width=80% align=left nowrap>
							<input Class="FuenteInput" size=13 maxlength=12 type=Text name="Empresa"  value="<%=Empresa%>" aonblur="javascript:validaCaractesPassWord(this.value , this)">
						</td>
				<%end if%>				
			</tr>

			<tr >
				<td width=10% class="FuenteEncabezados" align=left >Nombre</td>
				<td class="FuenteEncabezados" width=80% align=left>
					<input Class="FuenteInput" type=Text name="Nombre" size="<%=largocampo%>" maxlength=50 value="<%=Nombre%>" aonblur="javascript:validaCaractesPassWord(this.value , this)">
				</td>
	   		</tr>

			<tr >
				<td width=10% class="FuenteEncabezados" align=left >Razón social</td>
				<td class="FuenteEncabezados" width=80% align=left>
					<input Class="FuenteInput" type=Text name="RazonSocial" size="50" maxlength=50 value="<%=RazonSocial%>" >
				</td>
	   		</tr>
			<tr >
				<td width=10% class="FuenteEncabezados" align=left >Dirección</td>
				<td class="FuenteEncabezados" width=80% align=left>
					<input Class="FuenteInput" type=Text name="Direccion" size="50" maxlength=50 value="<%=Direccion%>" >
				</td>
	   		</tr>

		  	<tr>
				<td width=10% class="FuenteEncabezados" align=left >Teléfono</td>
				<td class="FuenteEncabezados" width=80% align=left>
					<input Class="FuenteInput" type=Text name="Telefono" size="30" maxlength=30 value="<%=Telefono%>" >
				</td>
	   		</tr>
        
		  	<tr>
				<td width=10% class="FuenteEncabezados" align=left >Rut</td>
				<td class="FuenteEncabezados" width=80% align=left>
					<input Class="FuenteInput" type=Text name="Rut" size="14" maxlength=12 value="<%=Rut%>" >
				</td>
	   		</tr>
        
			  <tr >
				<td nowrap class="FuenteEncabezados" align=left >Zona franca</td>
				<td align=left class="FuenteEncabezados">
				     <select class="fuenteinput" name="Zona_franca" Style="width:130">
				          <option <%if Zona_franca= "N" then Response.write ("selected ")%> value="N">No</option>
				          <option <%if Zona_franca= "S" then Response.write ("selected ")%> value="S">Si</option>
				      </select>
				</td>
				</tr>

		</table>
	</Form>

	<Form name="grabar" method="post" action="Save_Empresas.asp" target="Trabajo">
		<input type=hidden name="Orden"			value = "<%=Orden%>">
		<input type=hidden name="Empresa"	value = "<%=Empresa%>">
		<input type=hidden name="Control"		value = "<%=Control%>">
		<input type=Hidden name="Nombre"	value = "<%=Nombre%>">
		<input type=hidden name="pagenum" 		value = "<%=Request("pagenum")%>">
	</form>

	<script language="javascript">
		if ( "<%=RegistroExistente%>" == "S")
		{
		   document.Frm_Mantencion.Nombre.focus();
		}
		else
		{
		   document.Frm_Mantencion.Empresa.focus();
		}
	</script>

<%	else%>
		<script language="javascript">
		   parent.top.frames[2].location.href = "BotonesMantencion_Empresas.asp?SinRegistros=S"		   
		</script>
		<table width=100% border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td class="FuenteTitulosFunciones" align=center width=100%>
					<b>No se encontró información sobre este Empresa.</b>
				</td>
				<td align=center width=25%>
					<br><br><br><br><br><br>
				</td>
			</tr>
		</table>	
<%	end if%>
		<script language="javascript">
		   parent.Mensajes.location.href = "../../Mensajes.asp"		   
		</script>
   </body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>