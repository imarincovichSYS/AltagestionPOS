<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	
if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600

    Fecha_cierre_solicitado=now()
	sql="exec CIC_datos_ultimo_cierre '" & session("empresa_usuario") & "','" & session("login") & "'"
	 sql_2="select Nombre= LTRIM(RTRIM(Nombres_persona)) + ' ' + LTRIM(RTRIM(Apellidos_persona_o_nombre_empresa)) from entidades_comerciales with(nolock) where entidad_comercial = '" & session("login") & "'"  
'	Response.Write(sql)
	set rs=conn.Execute(sql)
	 set rs_2=conn.Execute(sql_2)
	if not rs.eof then
					Fecha_cierre_anterior=rs("Fecha_cierre_anterior")
					Fecha_cierre_solicitado=rs("Fecha_cierre_actual")
	else
		Fecha_cierre_anterior=""
	end if
	rs.close
	set rs=nothing
	empresa=session("empresa_usuario")
	
	Nombre = rs_2("Nombre")
	rs_2.close
	set rs_2=nothing
	
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
	</head>

<%if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
		JavaScript = "JavaScript:"
	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes_frame( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	else%>
		<script language="JavaScript">
			function Mensajes_frame( valor )
			{
				with (parent.top.frames[3].document.IdMensaje.document)
				{
				  open();
				  write(valor);
				  close();
				}
			}
		</script>
<%	end if%>


<script language="JavaScript">

function Ventas()
{
	var anterior=parent.top.frames[1].document.Formulario.anterior.value;
	parent.top.frames[1].document.Formulario.action="DetalleVentas_CierreCaja.asp";
	parent.top.frames[1].document.Formulario.submit();
	location.href="BotonesMantencion_CierreCaja.asp?Ventas=S&anterior="+anterior;
}

function Cobros()
{
	var anterior=parent.top.frames[1].document.Formulario.anterior.value;
	parent.top.frames[1].document.Formulario.action="DetalleCobros_CierreCaja.asp";
	parent.top.frames[1].document.Formulario.submit();
	location.href="BotonesMantencion_CierreCaja.asp?Cobros=S&anterior="+anterior;
}

function Anterior()
{
	parent.top.frames[1].location.href = "Mant_CierreCaja.asp?anterior=S";
	location.href="BotonesMantencion_CierreCaja.asp?Anterior=S";
}
function Imprimir_Anterior()
{
	parent.top.frames[1].location.href = "Mant_CierreCaja.asp?anterior=KOF";
	location.href="BotonesMantencion_CierreCaja.asp?Anterior=S";
}

function Confirmar()
{
	//alert(parent.top.frames[1].location.href);
	parent.top.frames[1].window.focus();
	//parent.top.frames[1].window.print();
	parent.top.frames[1].document.Formulario.submit();
}

function volver()
{
	var anterior=parent.top.frames[1].document.Formulario.anterior.value;
	parent.top.frames[1].location.href = "Mant_CierreCaja.asp?anterior="+anterior;
	location.href="BotonesMantencion_CierreCaja.asp?anterior="+anterior;
}

function Actual()
{
	var anterior=parent.top.frames[1].document.Formulario.anterior.value;
	parent.top.frames[1].location.href = "Mant_CierreCaja.asp?anterior=N";
	location.href="BotonesMantencion_CierreCaja.asp?anterior=N";
}

	function Mensajes( valor )
	{
		window.status = valor ;
	}  

	function Cerrar()
	{
	    Mensajes_frame('');
		parent.Botones.location.href = "../../Empty.asp";
		parent.Trabajo.location.href = "../../Empty.asp";
		parent.Mensajes.location.href = "../../Mensajes.asp";
//		parent.top.frames[1].location.href = "Inicial_CierreCaja.asp?pagenum=<%=session("pagenum")%>";
//		parent.top.frames[2].location.href = "Botones_CierreCaja.asp";		
	}	
	function fWndCierreTurno( responsable, inicio, termino, nombre)
	{
		var winURL		 = "CierreCajaAnterior.asp?Responsable=" + responsable;
			winURL		 = winURL + "&Fecha_desde=" + escape(inicio);
			winURL		 = winURL + "&Fecha_hasta=" + escape(termino);
			winURL		 = winURL + "&Nombre=" + escape(nombre);
		var winName		 = "Wnd_Imprimir";
		var winFeatures  = "status=no," ; 
			winFeatures += "resizable=no," ;
			winFeatures += "toolbar=no," ;
			winFeatures += "location=no," ;
			winFeatures += "scrollbars=yes," ;
			winFeatures += "menubar=0," ;
			winFeatures += "width=650," ;
			winFeatures += "height=300," ;
			winFeatures += "top=30," ;
			winFeatures += "left=50" ;
			window.open(winURL , winName , winFeatures , 'mainwindow')
	}
</script>


<body  bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
<Form name="Formulario_Botones" method="post" >
	<table width=100% border=0 cellspacing=0 cellpadding=0>
		<tr class="FuenteBotonesLink" width=100%>
			<%if request("ventas") <> "S" then%>
				<%if request("cobros") <> "S" then
					if request("anterior") = "S" then%>
						<td align=center width=20% nowrap>
							<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Cierre de caja actual.")'  OnMouseMove='<%=JavaScript%>Mensajes("Cierre de caja actual.")' Onfocus='<%=JavaScript%>Mensajes("Cierre de caja actual.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:Actual()" >Cierre de caja actual</a></b>
						</td> 
						<td align=center width=20% nowrap>
							<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Detalle cobros.")'  OnMouseMove='<%=JavaScript%>Mensajes("Detalle cobros.")' Onfocus='<%=JavaScript%>Mensajes("Detalle cobros.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:Cobros()" >Detalle ingresos</a></b>
						</td>
						
            <td align=center width=20% nowrap>
							<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Imprimir Cierre de caja anterior.")'  OnMouseMove='<%=JavaScript%>Mensajes("Imprimir Cierre de caja anterior.")' Onfocus='<%=JavaScript%>Mensajes("Imprimir Cierre de caja anterior.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:fWndCierreTurno('<%=session("login")%>','<%=Fecha_cierre_anterior%>','<%=Fecha_cierre_solicitado%>','<%=Nombre%>')">Imprimir Cierre de caja anterior</a></b>
							                                                                                                                                                                                                                                                                                                                                             
						</td>             
					
          <%else%>
						<td align=center width=20% nowrap>
							<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Cierre de caja anterior.")'  OnMouseMove='<%=JavaScript%>Mensajes("Cierre de caja anterior.")' Onfocus='<%=JavaScript%>Mensajes("Cierre de caja anterior.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:Anterior()" >Cierre de caja anterior</a></b>
						</td>
						<td align=center width=20% nowrap>
							<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Detalle cobros.")'  OnMouseMove='<%=JavaScript%>Mensajes("Detalle cobros.")' Onfocus='<%=JavaScript%>Mensajes("Detalle cobros.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:Cobros()" >Detalle ingresos</a></b>
						</td> 
						<td align=center width=20% nowrap>
							<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Detalle documentos de venta.")'  OnMouseMove='<%=JavaScript%>Mensajes("Detalle documentos de venta.")' Onfocus='<%=JavaScript%>Mensajes("Detalle documentos de venta.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:Ventas()" >Detalle documentos de venta</a></b>
						</td>
					<%end if%>
				<%else
					if request("anterior") <> "S" then
					%> 
					<td align=center width=20% nowrap>
						<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Confirmar e imprimir.")'  OnMouseMove='<%=JavaScript%>Mensajes("Confirmar e imprimir.")' Onfocus='<%=JavaScript%>Mensajes("Confirmar e imprimir.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:Confirmar()" >Confirmar e imprimir</a></b>
					</td>
					<%end if%>
					<td align=center width=20% nowrap>
						<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Volver.")'  OnMouseMove='<%=JavaScript%>Mensajes("Volver.")' Onfocus='<%=JavaScript%>Mensajes("Volver.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:volver()" >Volver</a></b>
					</td>
				<%end if
			else%>
					<td align=center width=20% nowrap>
						<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Volver.")'  OnMouseMove='<%=JavaScript%>Mensajes("Volver.")' Onfocus='<%=JavaScript%>Mensajes("Volver.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:volver()" >Volver</a></b>
					</td>
			<%end if%>
				<td align=center width=20% nowrap>
					<b><a class="FuenteBotonesLink" OnMouseOver='<%=JavaScript%>Mensajes("Vuelve al menú principal.")'  OnMouseMove='<%=JavaScript%>Mensajes("Vuelve al menú principal.")' Onfocus='<%=JavaScript%>Mensajes("Vuelve al menú principal.")' OnMouseOut='<%=JavaScript%>Mensajes("")' OnClick='<%=JavaScript%>Mensajes("")' href="JavaScript:Cerrar()" >Cerrar</a></b>
				</td>
		</tr>
	</table>
</Form>
<%
	Conn.Close
	Set Conn = Nothing
%>
</body>
<%else
	Response.Redirect "../../index.htm"
end if%>
</html>
