<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
'	if Session("Browser") = 0 then
		JavaScript = "JavaScript:"
'	end if	
%>

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<!-- Aqui están las funciones que permiten escribir en el Frame de mensajes.
	¿ Por que hay 2 funciones ?.- 
	Rpt. Segun el Browser que este corriendo la aplicación va ha ser la que se llame,
	Una está desarrollada en VBS y la otra en JS la que está hecha en VBS también puede
	ser llamada de JavaScript, pero la que está hechha en JS no.
	Mensajes ( valor ) es el formato de llamada donde valor va a ser el string que se
	coloca en la sección de los Mensajes.
-->
<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
<%	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes( valor )
				'parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	else%>
		<script language="JavaScript">
			function Mensajes( valor )
			{
				//with (parent.top.frames[3].document.IdMensaje.document)
				//{
				  //open();
				  //write(valor);
				  //close();
				//}
			}
		</script>
<%	end if%>

<script language="JavaScript">
	function MensajesStatus( valor )
	{
		//window.status = valor ;
	}

	function Nuevo(valor)
	{		
		Mensajes ( "" );
		//parent.top.frames[2].document.Formulario_Botones.Nuevo.value		= "S";
		//parent.top.frames[2].document.Formulario_Botones.Codigo_pais.value	= parent.top.frames[1][0].document.Formulario.Codigo_pais.value;
		//parent.top.frames[2].document.Formulario_Botones.Nombre_pais.value	= parent.top.frames[1][0].document.Formulario.Nombre_pais.value;
		//parent.top.frames[2].document.Formulario_Botones.Orden.value		= parent.top.frames[1][1].document.Listado.Orden.value;
		//parent.top.frames[2].document.Formulario_Botones.Valor.value		= valor;
		//parent.top.frames[2].location.href									= "BotonesMantencion_Productos.asp?Nuevo=S";
		//parent.top.frames[2].document.Formulario_Botones.submit();
	}
	
	function Buscar()
	{
		Mensajes ( "" );
		parent.top.frames[1][0].document.Formulario.submit();
	}
	
	function Eliminar()
	{
	/*
		Aqui se procesán todos los objetos de tipo checkbox y además se encuentren
	marcados.
	*/
		Mensajes ( "" );
		var TotalElementos = parent.top.frames[1][1].document.Listado.elements.length;
		var d = 0;
		var Afectados = "";
		
		if ( TotalElementos >= 0 )
		{
			for(a=0;a<TotalElementos;a++)
			{
				if ( parent.top.frames[1][1].document.Listado.elements[a].type == "checkbox" )
				{
					if ( parent.top.frames[1][1].document.Listado.elements[a].checked == true )
					{						
						Afectados = Afectados + parent.top.frames[1][1].document.Listado.elements[a].value + "|";
					}					
					d = d + 1;
				}
			}

			/* Si hay elementos chequeados la variable Afectados se encontrará con datos
			en caso contrario se enviará un mensaje que indique que no hay seleccionados.
			Si no preguntará si desea completar el proceso de eliminación, si el verdadera
			la respuesta se procesa en caso contrario no se hace nada.
			*/
			if ( validEmpty(Afectados) )
			{
				Mensajes ( "No hay ningún producto seleccionado, para ser eliminado." )
			}
			else
			{
				document.Eliminar.Codigo_pais.value = parent.top.frames[1][0].document.Formulario.Codigo_pais.value;
				document.Eliminar.Nombre_pais.value = parent.top.frames[1][0].document.Formulario.Nombre_pais.value;					
				document.Eliminar.Orden.value		= parent.top.frames[1][1].document.Listado.Orden.value;
				document.Eliminar.Afectados.value   = Afectados;
				var Resp = confirm("Presione Aceptar para confirmar proceso, en caso contrario pulse Cancelar");
				if ( Resp )
				{
					document.Eliminar.submit();
				}
			}
		}
		else
		{
			Mensajes ( "No hay ningún producto seleccionado, para ser eliminado." )
		}
	}
	
	function Cerrar()
	{
		Mensajes ("");
		parent.Botones.location.href = "../../Empty.asp";
		parent.Trabajo.location.href = "../../Empty.asp";
		//parent.Mensajes.location.href = "../../Mensajes.asp";
	}	
	
</script>

	<Form name="Formulario_Botones" method="post" action="Mant_Productos.asp" target="Trabajo">
	<!-- Formulario que envia a editar o ingresar un nuevo registro de esta mantención -->
		<input type="hidden" name="Nombre_pais" value="">
		<input type="hidden" name="Codigo_pais" value="">
		<input type="hidden" name="pagenum"		value="1">
		<input type="hidden" name="Orden"		value="1">
		<input type="hidden" name="Nuevo"		value="S">
		<input type="hidden" name="Valor"		value="">
		
		<table width=100% border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteBotonesLink" width=100%>
				<td align=center width=20% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Permite ingresar un nuevo producto.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Permite ingresar un nuevo producto.")' Onfocus='<%=JavaScript%>MensajesStatus("Permite ingresar un nuevo producto.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Nuevo(1)">Nuevo</a></b>
				</td> 
		<!--		<td align=center width=20% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Permite ingresar un nuevo producto.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Permite ingresar un nuevo producto.")' Onfocus='<%=JavaScript%>MensajesStatus("Permite ingresar un nuevo producto.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Nuevo(2)">Nvo. Op B</a></b>
				</td> 
		-->
				<td align=center width=20% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' Onfocus='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Buscar()" >Buscar</a></b>
				</td> 
		<% if Request("Eliminar") <> "N" then%>
				<td align=center width=20% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Elimina los registros que se encuentran seleccionados.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Elimina los registros que se encuentran seleccionados.")' Onfocus='<%=JavaScript%>MensajesStatus("Elimina los registros que se encuentran seleccionados.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Eliminar()" >Eliminar</a></b>
				</td> 
		<%	end if%>
				<td align=center width=20% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' Onfocus='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Cerrar()" >Cerrar</a></b>
				</td> 
			</tr>
		</table>
	</Form>

<!-- Formulario que envia a eliminar los registros que serán almacenados en la variable Afectados 
	para luego ser procesados en Eliminar_Productos.asp 
	pagenum = Variable que pasa el número de la página en que se encuentra
	Orden	= orden que ha establecido el usuario para mantenerlo al repintar	
-->
	<Form name="Eliminar" action="Eliminar_Productos.asp" method="post" target="Trabajo">
		<input type=hidden name="Codigo_pais" value="">
		<input type=hidden name="Nombre_pais" value="">
		<input type=hidden name="Orden"		  value="1">
		<input type=hidden name="Afectados"   value="">
		<input type=hidden name="pagenum"	  value="1">
	</form>
</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
