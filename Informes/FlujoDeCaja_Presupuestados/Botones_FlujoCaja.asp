<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
'	if Session("Browser") = 0 then
		JavaScript = "JavaScript:"
'	end if	
%>
<!-- #include file="../../Scripts/Inc/Caracteres.Inc" -->

<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
		<script src="../../Scripts/Js/Caracteres.js"></script>
		<script src="../../Scripts/Js/Fechas.js"></script>
		<script src="../../Scripts/Js/Numerica.js"></script>
	</head>

<!-- Aqui están las funciones que permiten escribir en el Frame de mensajes.
	¿ Por que hay 2 funciones ?.- 
	Rpt. Segun el Browser que este corriendo la aplicación va ha ser la que se llame,
	Una está desarrollada en VBS y la otra en JS la que está hecha en VBS también puede
	ser llamada de JavaScript, pero la que está hechha en JS no.
	Mensajes ( valor ) es el formato de llamada donde valor va a ser el string que se
	coloca en la sección de los Mensajes.
-->

<%	if Session("Browser") = 1 then %>
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
		Mensajes('');
<%	end if%>




<script language="JavaScript">
	var newwin;

	function launchwin(winurl,winname,winfeatures,parentname)
	{
		if (!document.images)
		{
			newwin = null;
		}
		
		if (newwin == null || newwin.closed)
		{
			newwin = window.open(winurl,winname,winfeatures);
			if (newwin.opener == null)
			{
				newwin.opener = window;
			}
			newwin.opener.name = parentname;
		}
		else
		{
			if(newwin.opener.name != winname)
			{
				newwin = window.open(winurl,winname,winfeatures);
				if (newwin.opener == null)
				{
					newwin.opener = window;
				}
				newwin.opener.name = parentname;
			}
			else
			{
				newwin.focus(); 
			}
		}
	}


	function MensajesStatus( valor )
	{
		window.status = valor;
	}

	
	function Buscar()
	{
        Mensajes ( '' )
		var Fecha_desde = parent.top.frames[1][0].document.Listado.Fecha_desde;
		var Fecha_hasta = parent.top.frames[1][0].document.Listado.Fecha_hasta;
		var Paridad     = parent.top.frames[1][0].document.Listado.Paridad;
		
		if ( ! validEmpty(Fecha_desde.value) )
		{
		  if ( ! validaFecha(Fecha_desde.value) )
		  {
		      Mensajes ( 'La fecha desde ingresada no es válida, revise por favor.' )
		      Fecha_desde.focus();
		      return;
          }
        }

		if ( ! validEmpty(Fecha_hasta.value) )
		{
		  if ( ! validaFecha(Fecha_hasta.value) )
		  {
		      Mensajes ( 'La fecha hasta ingresada no es válida, revise por favor.' )
		      Fecha_hasta.focus();
		      return;
          }
        }

		if ( ! validEmpty(Paridad.value) )
		{
		  if ( ! validNum(Paridad.value) )
		  {
		      Mensajes ( 'La paridad ingresada debe ser numérica, revise por favor.' )
		      Paridad.focus();
		      return;
          }
        }

		parent.top.frames[1][0].document.Listado.Recalcula_sin_cheques_ni_otros_ingresos.value = "N";
		parent.top.frames[1][0].document.Listado.action = "List_FlujoCaja.asp";
		parent.top.frames[1][0].document.Listado.target = "Listado";
		parent.top.frames[1][0].document.Listado.submit();
	}

	function Cerrar()
	{
		parent.Botones.location.href = "../../Empty.asp";
		parent.Trabajo.location.href = "../../Empty.asp";
		parent.Mensajes.location.href = "../../Mensajes.asp";
	}	
	
    function fRecalculaSinCheques()
    {
        parent.top.frames[1][0].document.Listado.Recalcula_sin_cheques_ni_otros_ingresos.value = "S";
		parent.top.frames[1][0].document.Listado.action = "List_FlujoCaja.asp";
		parent.top.frames[1][0].document.Listado.target = "Listado";
        parent.top.frames[1][0].Listado.method = "post"
        parent.top.frames[1][0].Listado.submit();
    }
    
	function fActualizaPresupuestos()
	{
	   var Rsp = confirm ( '¿ Esta seguro de actualizar los montos presupuestados ?' )
	   if ( Rsp )
	   {
            parent.top.frames[1][1].document.Listado.Recalcula_sin_cheques_ni_otros_ingresos.action = "S";
            parent.top.frames[1][1].Listado.action = "Save_Presupuesto.asp"
            parent.top.frames[1][1].Listado.target = "Paso"
            parent.top.frames[1][1].Listado.method = "post"
            parent.top.frames[1][1].Listado.submit();
	   }
       	
    }
	
</script>

<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
	<Form name="Listado_Botones" method="post" action="Save_FlujoCaja.asp" target="Trabajo">
	<!-- Listado que envia a editar o ingresar un nuevo registro de esta mantención -->
		<input type="hidden" name="pagenum"		value="1">
		<input type="hidden" name="Orden"		value="1">
		<input type="hidden" name="Numero_documento_no_valorizado"		value="">
		<input type="hidden" name="Accion"		value="">
		
		<table width=100% border=0 cellspacing=0 cellpadding=0>
				<td align=center width=20% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' Onfocus='<%=JavaScript%>MensajesStatus("Genera un listado de acuerdo a los criterios de búsqueda que se han especificado.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Buscar()" >Buscar</a></b>
				</td>
            <% if Request("SinRegistro") = "N" then %>
                <% if Request("Periodo") = "D" Then %>
    				<td align=center width=20% nowrap>
    					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Actualiza los presupuestos indicados.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Actualiza los presupuestos indicados.")' Onfocus='<%=JavaScript%>MensajesStatus("Actualiza los presupuestos indicados.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:fActualizaPresupuestos()" >Actualizar presupuestos</a></b>
    				</td>
				<% end if%>
				<td align=center width=20% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus(".")'  OnMouseMove='<%=JavaScript%>MensajesStatus(".")' Onfocus='<%=JavaScript%>MensajesStatus(".")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:fRecalculaSinCheques()" >Recalcula sin cheques ni otros ingresos</a></b>
				</td>
            <% end if%>
				<td align=center width=20% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")'  OnMouseMove='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' Onfocus='<%=JavaScript%>MensajesStatus("Vuelve al menú principal.")' OnMouseOut='<%=JavaScript%>MensajesStatus("")' OnClick='<%=JavaScript%>MensajesStatus("")' href="JavaScript:Cerrar()" >Cerrar</a></b>
				</td> 
			</tr>
		</table>
	</Form>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
