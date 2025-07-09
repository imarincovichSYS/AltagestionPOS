<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
	<script src="../../Scripts/Js/Fechas.js"></script>
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
	<script language="javascript">
		    var blnDOM = false, blnIE4 = false, blnNN4 = false;

		    if (document.layers) blnNN4 = true;
		    else if (document.all) blnIE4 = true;
		    else if (document.getElementById) blnDOM = true;
		    function getKeycode(e) {
		        var TeclaPresionada = ""

		        if (blnNN4) {
		            var NN4key = e.which
		            TeclaPresionada = NN4key;
		        }
		        if (blnDOM) {
		            var blnkey = e.which
		            TeclaPresionada = blnkey;
		        }
		        if (blnIE4) {
		            var IE4key = event.keyCode
		            TeclaPresionada = IE4key
		        }

		        //alert(TeclaPresionada)
		        if (TeclaPresionada == 8 && (event.srcElement.type != "text" && event.srcElement.type != "textarea")) //Backspace
		        {
		            return false;
		        }


		    }

		    document.onkeydown = getKeycode
		    if (blnNN4) document.captureEvents(Event.KEYDOWN)
	</script>
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
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600

	DecretoLey = "TRASPASO ENTRE BODEGAS NO IMPLICA VENTA" & CHR(10) & CHR(13)
	DecretoLey = DecretoLey & "D.L. Nº 825 ART. 55"

	empresa=session("empresa_usuario")
	if request("accion")="N" then
  		 Numero_documento_no_valorizado="Nuevo"
	     Fecha_emision=date()
	     Numero_interno_documento_no_valorizado=0
	else
	
	cSql = "Exec EMP_ListaEmpresas '" & Empresa & "', Null, Null"
	Set Rs = Conn.Execute ( cSql )
	If Not Rs.Eof then
		Nombre		= Rs("Nombre")
		Rut			= Rs("Rut")
		Direccion	= Rs("Direccion")		
	end if
	Rs.Close
	Set Rs = Nothing	
		
	Sql = "Exec DNV_ListaTransferencias " &+_
          "'"  & Empresa & "'," +_
          "null" & "," +_
          "0"  & request.queryString("NumGuia") & "," +_
          "'"  & Fecha_emision & "'," +_
          "'"  & Bodega_entrada & "'," +_
          "'"  & Bodega_salida & "'," +_
          "'"  & Usuario & "'," +_
          "'"  & Documento_respaldo & "',0" & Numero_Documento_respaldo

'Response.Write(sql)
		set rs=conn.Execute(sql)
			Numero_documento_no_valorizado=rs("Numero_documento_no_valorizado")
			responsable=rs("Empleado_responsable")
			Numero_interno_documento_no_valorizado_ing = rs("Numero_interno_documento_no_valorizado")
			Numero_documento_respaldo                  = rs("Numero_documento_respaldo")
			Documento_respaldo                         = rs("Documento_respaldo")
			Bodega_salida                              = rs("Bodega")
			if rs("Estado_documento_no_valorizado") = "PRE" Then
				Estado="Preparándose"
			else
				Estado="Autorizada"
			end if
			Observaciones_generales  = rs("Observaciones_generales")
			Fecha_emision            = rs("Fecha_emision")
			control_ing              = rs("control")
			
    			DesdeBodega  = Rs("DesdeBodega") 
    
			Rs.movenext
			
    			Bodega_entrada           = rs("Bodega")
    			control_egr              = rs("control")
    			Numero_interno_documento_no_valorizado_egr = rs("Numero_interno_documento_no_valorizado")
    			HastaBodega  = Rs("HastaBodega")

			Fecha_hora   = Rs("Fecha_hora")
			NumeroGuia   = Rs("Numero_documento_no_valorizado")
			NomResponsable = Rs("NomResponsable")
			
'modificar
	end if
     i=1
%>
	<body aonload="javascript:this.print()" leftmargin=0 topmargin=0 abackground="../../<%=Session("ImagenFondo")%>">
		<Form name="Formulario" method="post" action="Save_IngMerma.asp" target="Trabajo">		
			<table width=90% align=center border=0 cellspacing=0 cellpadding=0>
				<tr valign=bottom class="Fuenteinput" height=0>
					<td colspan=2 class="Fuenteinput" width=100% align=left ><%=Nombre%>&nbsp;</td>
				</tr>
				<tr valign=bottom class="Fuenteinput" >
					<td colspan=2 class="Fuenteinput" width=100% align=Center >GUIA ESTADO PRE&nbsp;</td>
				</tr>

				<tr class="Fuenteinput">
					<td class="Fuenteinput" width=50% align=left >Nº Guia:&nbsp;<%=NumeroGuia%></td>
					<td class="Fuenteinput" width=50% align=left >Fecha y hora:&nbsp;<%=Fecha_hora%></td>
				</tr>
				<tr class="Fuenteinput">
					<td class="Fuenteinput" width=50% align=left >Local Salida:&nbsp;<%=DesdeBodega%></td>
					<td class="Fuenteinput" width=50% align=left >Local Destino:&nbsp;<%=HastaBodega%></td>
				</tr>
<!--        <tr class="Fuenteinput">
					<td class="Fuenteinput" width=100% align=left >Obs&nbsp;<%=Observaciones_generales%></td>
				</tr>-->
				<tr class="Fuenteinput" height=30>
					<td colspan=4 class="Fuenteinput" width=10% align=left ><%=Observaciones_generales%>&nbsp;</td>
				</tr>
			</table>
			
			<table Name="ListaDetalles" Id="ListaDetalles" width=90% align=center border=0 cellspacing=0 cellpadding=0>
     			<tr class="FuenteEncabezados">
     			     <td width=2% align=left>Item&nbsp;</td>
     			     <td width=6% align=center>Cantidad&nbsp;</td>
     			      <td width=6% align=center>UM&nbsp;</td>
     			     <td width=7% align=Left>Código Ant.&nbsp;</td>
     			     <td width=6% align=Left>Marca&nbsp;</td>					 
					 <td width=7% align=Left>RuFaSub G&nbsp;</td>	
     			     <td width=6% align=Left>Producto&nbsp;</td>					 
     			     <td width=28% align=left  >Descripción&nbsp;</td>
     			     <td width=6% align=right >Precio&nbsp;</td>
    			</tr>
	<%		if request("accion")<>"N" then
				sql = "Exec MOP_ListaMovimientosProductos_Transferencias '" & session("empresa_usuario") & "'," & request.queryString("NumGuia") & ",null" 
'Response.Write(sql)
				set rs=conn.Execute(sql)
				i=1
				do while not rs.eof	%>
	     			<tr class="Fuenteinput">
	     			     <td width=2% align=right><%=rs("numero_de_linea")%>&nbsp;</td>	     			
	     			     <td width=6% align=right><B><%=rs("Cantidad_entrada")%>&nbsp;&nbsp;&nbsp;&nbsp;</B></td>
	     			     <td width=6% align=right><%=rs("Unidad_de_medida_consumo")%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	     			     <td width=7% align=Left><%=rs("Producto")%>&nbsp;</td>
	     			     <td width=6% align=left><%=Rs("Marca")%>&nbsp;</td>	
						 <td width=7% align=Left><%=Rs("RuFaSub_G")%>&nbsp;</td>					 						 
						 <td width=6% align=Left>&nbsp;<%=Rs("Producto_numerico")%>&nbsp;</td>					 						 						 
	     			     <td width=28% align=left  ><%=Trim(rs("Nombre_producto"))%>&nbsp;</td>
	     			     <td width=6% align=right ><%=FormatNumber( rs("PrecioUnitario"),0)%>&nbsp;</td>
					</tr>
		    <%		rs.movenext
		       		i=i+1
				loop
				rs.close
				set rs = nothing
			end if %>
			</table>
			
			<table width=90% align=center border=0 cellspacing=0 cellpadding=0>
     			<tr class="Fuenteinput" height=150>
     			    <td valign=bottom width=30% align=center>
     			        <table class="Fuenteinput" width=70% border=0 cellpadding=0 cellspacing=0>
     			            <tr>
     			                <td align=center><%=NomResponsable%><br><hr></td>
     			            </tr>
     			            <tr>
     			                <td align=center>Nombre empleado Responsable que Autoriza</td>
     			            </tr>
     			        </table>
                    </td>
     			    <td valign=bottom width=30% align=center>
     			        <table class="Fuenteinput" width=70% border=0 cellpadding=0 cellspacing=0>
     			            <tr>
     			                <td align=center>&nbsp;<br><hr></td>
     			            </tr>
     			            <tr>
     			                <td align=center>Nombre y firma receptor</td>
     			            </tr>
     			        </table>
                    </td>
    			</tr>
			</table>
		</form>
	</body>
<%conn.close()%>
	<script language="javascript">
    	parent.top.frames[2].location.href = "BotonesMantencion_TraspBodega.asp?consultar=S";
	</script>

<%else
	Response.Redirect "../../index.htm"
end if%>

</html>
