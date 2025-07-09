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
</head>

<%if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=600


	if request("accion")="N" then
		Numero_documento_no_valorizado = "Nuevo"
	     Fecha_emision=date()
	     if trim(request("Tipo_comprobante_de_Egreso")) = "P" then
			D_Tipo_comprobante_de_Egreso="Proveedor"
	     else
			D_Tipo_comprobante_de_Egreso="Otro"
	     end if
	     Moneda=request("Moneda")
	     D_moneda=request("D_moneda")
	     Tipo_comprobante_de_Egreso=request("Tipo_comprobante_de_Egreso")

         Proveedor=request("Proveedor")
        if trim(request("Tipo_comprobante_de_Egreso")) = "P" then
			Sql = "Exec ECP_ListaProveedores '" & session("empresa_usuario") & "','" & request("proveedor") & "','',2, 'R'"
			SET Rs = Conn.Execute( SQL )
			If Not Rs.eof then
				ExisteProveedor			= true
				Proveedor				= request("proveedor")
				Nombre_Proveedor		= rs ( "Nombre" )
				Nombre_Completo			= rs ( "Nombre" )	'Trim(rs ( "Nombre_Completo" ))
				Clasif_ClteProv			= rs("Clasificacion_proveedor")
			else
	%>
				<script language="javascript">
					parent.Mensajes.location.href = '../../Mensajes.asp?Msg=Proveedor no existe';
					parent.Botones.location.href = 'Botones_CEgresoSUP.asp';
					location.href = 'Inicial_CEgresoSUP.asp';
				</script>
				<%Proveedor					= "ERROR!!!"
				NombreProveedor		= "Proveedor no existe"
				ExisteProveedor			= false
			End if
			rs.close
		end if 
		estado = "AUT"
	else
		 nuevo="N"
		Numero_documento_no_valorizado= request("Numero_documento_no_valorizado")
		NRO=Numero_documento_no_valorizado
		sql="exec DNV_ListaComprobantesEgreso " & Numero_documento_no_valorizado & ",'" & session("empresa_usuario") & "'"
	'Response.Write(sql)
		set rs=Conn.Execute(sql)

		D_Tipo_comprobante_de_Egreso="Empleado"
		Estado=rs("estado_documento_no_valorizado")
		if estado = "PRE" then
			Nombre_estado="Preparandose"
		else
			Nombre_estado="Autorizado"
		end if
		
		Carpeta = Rs("Carpeta")
		proveedor = rs("proveedor")
		Nombre_proveedor = rs("Nombre_proveedor")
		moneda = rs("Moneda_documento")
		Tipo_comprobante_de_Egreso="P"

		Numero_comprobante_de_Egreso=rs("Numero_comprobante_de_Egreso")
		Fecha_emision=rs("Fecha_emision")
		Observaciones_generales=rs("Observaciones_generales")
		Documento_ingresado_o_egresado=rs("Documento_ingresado_o_egresado")
		Numero_interno_documento_no_valorizado=rs("Numero_interno_documento_no_valorizado")
		Numero_documento_no_valorizado=rs("Numero_documento_no_valorizado")
		if trim(rs("moneda_documento")) = "$" then
			monto = cdbl(rs("Monto_total_moneda_oficial"))
		else
			monto = rs("Monto_neto_US$")
		end if
		Monto_total_moneda_oficial		= Monto
		Numero_comprobante_de_Egreso=rs("Numero_comprobante_de_Egreso")
		Banco=rs("banco")
		cuenta_bancaria=rs("cuenta_bancaria")
		rs.close
		set rs=nothing

		sql="exec DOV_Lista_comprobante_de_Egreso  " & Numero_documento_no_valorizado & ",'" & session("empresa_usuario") & "'"
	'Response.Write(sql)
		set rs=Conn.Execute(sql)
		if not rs.eof then
			Fecha_vencimiento=rs("Fecha_vencimiento")
			Documento_valorizado = rs("documento_valorizado")
			Numero_documento_valorizado=rs("Numero_documento_valorizado")
			Numero_interno_documento_valorizado=rs("Numero_interno_documento_valorizado")
			Mes_y_ano_vencimiento=rs("Mes_y_año_vencimiento")
			if Fecha_vencimiento="01/01/1900" then
				Fecha_vencimiento=""
			end if
			Cuenta_bancaria=rs("Cuenta_bancaria")
		end if
		rs.close
		set rs=nothing
	end if
  
  saldo=0
    if Trim(Request("Tipo_comprobante_de_Egreso")) <> "O" then
        sql="exec DOV_Revisa_saldo_a_favor_proveedor '" & session("empresa_usuario") & "', '" & Proveedor & "'"
        set rs = Conn.Execute(sql)
        if rs.eof then
            saldo=0
        else
            if rs("Docs") > 0 then
                saldo=1
            else
                saldo=0
            end if
        end if
    end if
    i=0
%>
	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>

		<Form name="Formulario" method="post" action="Save_CEgresoSUP.asp" target="Mensajes">
			<input type=hidden name="TotalSelec" value=0>
			<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td nowrap class="FuenteEncabezados" width=10% align=left ><b>Número</b></td>
					<td width=20% align=left >
						<input type=hidden name="Accion" value="">
						<input type=hidden name="Nuevo" value="<%=nuevo%>">
						<input type=hidden name="estado_documento_no_valorizado" value="<%=estado%>">
						<input type=hidden name="Numero_interno_documento_valorizado" value="<%=Numero_interno_documento_valorizado%>">
						<input type=hidden name="Numero_interno_documento_no_valorizado" value="<%=Numero_interno_documento_no_valorizado%>">
						<input Class="DatoOutput" readonly type=Text name="Numero_documento_no_valorizado" size=11 maxlength=10 value="<%=Numero_documento_no_valorizado%>" >
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >Fecha</td>
					<td width=20% align=left >
						<input Class="FuenteInput" type=Text name="Fecha_emision" size=7 maxlength=10 value="<%=Fecha_emision%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Formulario.Fecha_emision');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>
					<td nowrap class="FuenteEncabezados" width=10% align=left >Tipo</td>
					<td align=left>
					     <input value="<%=D_Tipo_comprobante_de_Egreso%>" type=text size=7 readonly class="DatoOutput" name="D_Tipo_comprobante_de_Egreso" >
					     <input value="<%=Tipo_comprobante_de_Egreso%>" type=hidden name="Tipo_comprobante_de_Egreso" >
					</td>
					<td  nowrap class="FuenteEncabezados" width=10% align=left >Moneda</td>
					<td align=left>
					     <input type=text size=2 readonly value="<%=moneda%>" class="DatoOutput" name="Moneda" ID="Text4">
					</td>
				</tr>    
				<tr>
				<%if Tipo_comprobante_de_Egreso="P" then%>
					<td nowrap class="FuenteEncabezados" width=10% align=left >Proveedor</td>
					<td nowrap colspan=3 align=left>
				          <input readonly type=text value="<%=Proveedor%>" size=11 class="DatoOutput"  name="Proveedor">
				          <input readonly type=text value="<%=nombre_Proveedor%>" size=35 class="DatoOutput"  name="nombre_Proveedor">
					</td>
				<%else%>
					     <input type=hidden  value="<%=Proveedor%>" name="Proveedor" >
				<%end if%>

					<td  nowrap class="FuenteEncabezados" width=10% align=left >Centro de venta</td>
					<td colspan=3 align=left>
				        <select class="Fuenteinput" name="Centro_de_venta" style="width:200" ID="Select2">
				            <option  value=""></option>
	                    <%	Sql = "Exec CDV_ListaCentrosVentas Null, Null, '" & Session("Empresa_usuario") & "', 2"
							SET Rs	=	Conn.Execute( SQL )
	                    	Do while not rs.eof%>
	                    	    <option <%if Centro_de_venta = trim(rs("Centro_de_venta")) then Response.write("selected " ) end if %> value="<%=trim(rs("Centro_de_venta"))%>"><%=rs("Nombre")%></option>
	                    <%		Rs.movenext
							loop
							rs.close
							set rs=nothing%>
				        </select>
					</td>
				</tr>
				
				<tr>
					<td valign=top nowrap class="FuenteEncabezados" width=10% align=left >Observaciones</td>
					<td align=left colspan=7>

					     <TEXTAREA aonblur="javascript:validaCaractesPassWord(this.value , this)" Class="FuenteInput" COLS="120" ROWS="5" NAME="Observaciones_generales"><%=Observaciones_generales%></TEXTAREA> 
					</td>
				</tr>
				<tr>
					<td colspan=2 valign=top nowrap class="FuenteEncabezados" width=10% align=left >Nombre destinatario cheque:</td>
					<td align=left colspan=5>
					     <input class="FuenteInput" type=text size=40 maxlength=50 name="DestinatarioCheque" value="<%=Nombre_Completo%>"> 
					</td>
				</tr>				
			</table>
			<table width=95%  align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
	                    <td  width=5% nowrap class="FuenteEncabezados" align=left >
	                         <span class=FuenteAreaMensajes id="oculto" name= "oculto" value="" >&nbsp;</span>
	                     </td>
				</tr>
			</table>
			<table width=95%  align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
                    <td  width=5% nowrap class="FuenteEncabezados" align=left >Documento de pago</td>
                    <td  width=5% nowrap class="FuenteEncabezados" align=left >
	                    	<%Sql = "Exec DOC_Lista_DocumentosPago_CE 0, '"  & moneda & "'"
	                    	SET Rs	=	Conn.Execute( SQL )%>
				          <select class="fuenteinput" name="Documento_ingresado_o_egresado">
				               <option  value=""></option>
	                    	<%do while not rs.eof%>
	                    	     <option <%if Documento_valorizado = trim(rs("Documento")) then Response.write("selected " ) end if %> value="<%=trim(rs("Documento"))%>"><%=rs("Nombre")%>&nbsp;(<%=trim(rs("Documento"))%>)</option>
	                    	     <%rs.movenext
	                    	loop
	                    	rs.close
	                    	set rs=nothing%>
				           </select>
					</td>
                    <td  width=5% nowrap class="FuenteEncabezados" align=left >Número</td>
                    <td  width=5% nowrap class="FuenteEncabezados" align=left >
						<input type=text class='FunteInputNumerico' MAXLENGTH=9 size=9 onblur="javascript:validaMontos(this.value, this)" name="Numero_documento_egresado" value="">
			     </td>
                    <td  width=5% nowrap class="FuenteEncabezados" align=left >Monto</td>
                    <td  width=5% nowrap class="FuenteEncabezados" align=left >
						<input MAXLENGTH=9 class='DatoOutputNumerico' readonly type="text"	 size=9 name="Monto_total_pesos" value="0" ID="Text3">
						<input type="hidden" name="Monto_total_moneda_oficial" value=0 ID="Hidden1">
						<input type="hidden" name="Monto_total_moneda_oficial1" value=0 ID="Hidden2">
			     </td>
			  </tr>

			  <tr>
                    <td  nowrap class="FuenteEncabezados" align=left >Monto nominal</td>
                    <td  nowrap class="FuenteEncabezados" align=left >
						<input class="FunteInputNumerico" type=text MAXLENGTH=9 size=9 onblur="javascript:validaDecimales(this.value, this);nominal()" name="Monto_nominal" value="" ID="Text1">
					</td>
                    <td  width=5% nowrap class="FuenteEncabezados" align=left >Moneda nominal</td>
                    <td  width=5% nowrap class="FuenteEncabezados" align=left  >
					     <select class="fuenteinput" onchange="javascript:nominal()" name="Moneda_nominal" ID="Select1">
					     <%if moneda = "US$" then%>
							<option value="US$">Dólar americano (US$)</option>
						<%else%>
							<option value="$">Pesos chilenos ($)</option>
							<option value="UF">Unidad de fomento (UF)</option>
						<%end if%>
					     </select>
                    </td>
                    <td  nowrap class="FuenteEncabezados" align=left >Paridad nominal</td>
                    <td  nowrap class="FuenteEncabezados" align=left >
						<input class="FunteInputNumerico" type=text MAXLENGTH=9 size=9 onblur="javascript:nominal()" name="Paridad_nominal" value="<%=paridad%>" ID="Text2">
			     </td>
			  </tr>


				<tr>
                    <td  width=5% nowrap class="FuenteEncabezados" align=left >Cuenta corriente</td>
                    <td  width=5% nowrap class="FuenteEncabezados" align=left >
	                    	<%Sql = "Exec CCB_ListaCuentasBancarias '','','" & moneda &"', '" & Session("Empresa_usuario") & "'" 
	                    	SET Rs	=	Conn.Execute( SQL )%>
				          <select  class="fuenteinput" style="width:200" name="CuentaBanco">
				               <option  value=""></option>
	                    	<%do while not rs.eof%>
	                    	     <option value='<%=rs("banco")%>@<%=rs("Cuenta_bancaria")%>'><%=rs("Cuenta_bancaria")%>(<%=rs("banco")%>)</option>
	                    	     <%rs.movenext
	                    	loop
	                    	rs.close
	                    	set rs=nothing%>
				           </select>
				           <input type =hidden name ="registros" value=0>
				</td>

                <td  nowrap class="FuenteEncabezados" align=left >Vencimiento</td>
                <td  nowrap class="FuenteEncabezados" align=left >
					<input Class="FuenteInput" type=Text name="Fecha_vencimiento" size=7 maxlength=10 value="" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Formulario.Fecha_vencimiento');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
			    </td>

                <td  nowrap class="FuenteEncabezados" align=left >Carpeta</td>
                <td  nowrap class="FuenteEncabezados" align=left >
					<input Class="FuenteInput" type=Text name="Carpeta" size=10 maxlength=10 value="" >
			    </td>
			</tr>
		</table>
<%if Tipo_comprobante_de_Egreso="O" then%>
			<table width=95%  align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
                    <td   width=5% nowrap class="FuenteEncabezados" align=left >
						<a class="FuenteEncabezados" href="JavaScript:ClipBoard( 'Formulario', '', 'CuentaContable', 'p');">Cuenta contable del Egreso</a>
                    </td>
                    <td   width=75% nowrap class="FuenteEncabezados" align=left >
						<input Class="FuenteInput" name="CuentaContable" size =15 maxlength=15 value='<%=Cuenta_contable%>'>
					</td>
				</tr>
			     
			</table>
<%end if%>
<%if Tipo_comprobante_de_Egreso="P" then%>
	           <%
	           sql="exec DOV_ListaDocs_a_Pagar '" & session("empresa_usuario") & "','" & Proveedor & "','" & moneda & "'"
	           'Response.Write(sql)
	           set rs=conn.Execute(sql)
	           i=0
	           if rs.eof then%>
			<table width=95%  align=center border=0 cellspacing=0 cellpadding=0>
			    <tr class="FuenteEncabezados">
						<td class="FuenteEncabezados" width=20% align=left><B><br>No hay documentos pendientes de pago.</B></td>
				</tr>
			</table>
	           <%else%>
			<table width=95%  align=center border=1 cellspacing=0 cellpadding=0>
      			<tr class="FuenteCabeceraTabla">
    			     <td>Docto.</td>
     			     <td align=right>Número</td>
     			     <td>Emisión</td>
     			     <td>Vencimiento</td>
     			     <td align=right>Orden cpa.</td>
     			     <td>Supervisor</td>
     			     <td>Estado</td>
     			     <td align=right>Monto total</td>
     			     <td align=right>Monto x pagar</td>
     			     <td align=right>Monto a pagar</td>
     			     <td align=center >Paga</td>
	           </tr>
				<%end if
	           do while not rs.eof
					monto=clng(rs("Monto_total_moneda_oficial"))
					xpagar= cdbl(rs("Monto_a_pagar") )
				%>
     			<tr class="FuenteEncabezados">
     			     <td><input size=2	Class="DatoOutput" type=text readonly name="Documento_valorizado<%=i%>" value="<%=rs("Documento_valorizado")%>">
     					<input type=hidden name="Numero_interno_documento_imputado<%=i%>" value="<%=rs("Numero_interno_documento_valorizado")%>">
     					<input type=hidden name="Valor_paridad_moneda_oficial_imputado<%=i%>" value="<%=rs("Valor_paridad_HOY")%>">
     					<input type=hidden name="Valor_paridad_moneda_oficial_cobrado<%=i%>" value="<%=rs("Valor_paridad_moneda_oficial")%>">
     					<input type=hidden name="Tipo_documento<%=i%>" value="<%=rs("Tipo_documento")%>">
     					<input type=hidden name="Estado_financiero<%=i%>" value="<%=rs("Estado_financiero")%>">
     					</td>
     			     <td><input size=7	Class="DatoOutputNumerico"  type=text readonly name="documento<%=i%>" value="<%=rs("Numero_documento_valorizado")%>"></td>
     			     <td><input size=8 Class="DatoOutput" type=text readonly name="Fecha_emision<%=i%>" value="<%=rs("Fecha_emision")%>"></td>
     			     <td><input size=8 Class="DatoOutput" type=text readonly name="Vencimiento<%=i%>" value="<%=rs("Vencimiento")%>"></td>
     					<%if rs("Numero_orden_de_compra") <> 0 then %>
     						<a href='javascript:ordencpa(<%=rs("Numero_orden_de_compra")%>)'>
     						<td>
     						<input size=7	Class="DatoOutputNumerico" type=text readonly name="Orden_de_compra<%=i%>" value="<%=rs("Numero_orden_de_compra")%>">
     						</td>
     						</a>
     					<%else%>
     					<td>
     						<input size=7	Class="DatoOutputNumerico" type=text readonly name="Orden_de_compra<%=i%>" value="<%=rs("Numero_orden_de_compra")%>">
     					</td>
     					<%end if%>
     			     <td><input size=7 Class="DatoOutput" type=text readonly name="Supervisor_orden_de_compra<%=i%>" value="<%=rs("Supervisor_orden_de_compra")%>"></td>
     			     <td><input size=1 Class="DatoOutput" type=text readonly name="Estado_para_pago<%=i%>" value="<%=rs("Estado_para_pago")%>"></td>
     			     <td><input size=9	Class="DatoOutputNumerico" type=text readonly name="Monto<%=i%>" value="<%=monto%>"></td>
     			     <td><input size=9	Class="DatoOutputNumerico" type=text readonly name="xpagar<%=i%>" value="<%=rs("Monto_x_pagar")%>"></td>
     			     <td><input size=9	class="FunteInputNumerico" onblur="javascript:validamonto(this, <%=i%>)" type=text  name="apagar<%=i%>" value="<%=xpagar%>">
     						<input type=hidden value=0 name="montoapagar<%=i%>">
     				 </td>
     			     <td align=center ><input type=checkbox onclick="javascript=sumar(this, <%=i%>)" name="pagar<%=i%>"></td>
	           </tr>
	           <%
	           		i=i+1
					rs.movenext
				loop
	           rs.close
	           set rs=nothing
	           %>    
			</table>
<%end if 'Tipo_comprobante_de_Egreso=otro%> 
		</form>
	</body>
	<script language="vbscript">
     if  <%=saldo%>=1 then
          msg_saldo_favor()
     end if
     
     function msg_saldo_favor()			
			document.all("oculto").InnerHTML="Atención : Este Proveedor tiene <a href='javascript:saldofavor()'>saldos a favor</a> no imputados"
     End function
     </script>
	
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
<%	end if%>

<script language="javascript">
	document.Formulario.registros.value=<%=i%>;

	function nominal()
	{
		if(!validaNumDec(document.Formulario.Paridad_nominal.value))
		{
				Mensajes("Debe ingresar sólo números, decimales con punto");
				document.Formulario.Paridad_nominal.focus();
		}
		if(document.Formulario.Moneda_nominal.value == '$')
		{
			document.Formulario.Paridad_nominal.value = 1;
		}	

		if(document.Formulario.Moneda_nominal.value != 'US$')
		{
			document.Formulario.Monto_total_pesos.value = roundOff(document.Formulario.Monto_nominal.value * document.Formulario.Paridad_nominal.value, 2);
		}
		else
		{
			document.Formulario.Monto_total_pesos.value = document.Formulario.Monto_nominal.value;
		}
/*
			document.Formulario.Monto_total_moneda_oficial.value = document.Formulario.Monto_total_pesos.value
			document.Formulario.Monto_total_moneda_oficial1.value = document.Formulario.Monto_total_pesos.value
*/

	}
	
	function ordencpa(nro)
	{
		location.href="../OrdenDeCompra/Consulta_OrdenCompra.asp?Nuevo=N&NOC="+nro;
	}
	
	function validamontototal(obj)
	{
		Mensajes("");
		if (document.Formulario.Monto_total_moneda_oficial1.value!=0)
		{
			obj.value=document.Formulario.Monto_total_moneda_oficial1.value;
		}
		else
		{
			if (document.Formulario.Moneda.value == 'US$')
			{
				if (!validaNumDec(obj.value))
				{
					Mensajes ("Ingrese sólo números (positivos) separados por .");
					obj.focus();
				}
//				validaMontos(obj.value, obj);
			}
			else
			{
				if(!validNum(obj.value))
				{
					Mensajes ("Ingrese sólo números (positivos) separados por .");
					obj.focus();
				}
			}
		}
	}
	
	function validamonto(obj, i)
	{
		if (validaMontos(obj.value, obj))
		{
			campo=eval("document.Formulario.xpagar" + i);
			if (parseFloat(campo.value) < parseFloat(obj.value))
			{
				Mensajes("El monto a pagar no debe ser mayor a " + campo.value);
				obj.value=campo.value;
				obj.focus();
			}
			else
			{
				Mensajes("");
			}
		}	
		
	}
	
	function sumar(obj, i)
	{
		
		campo=eval("document.Formulario.apagar" + i);
		campomonto=eval("document.Formulario.montoapagar" + i);
		campomonto.value=campo.value;
		campo.disabled=!campo.disabled;
		if (document.Formulario.Monto_total_moneda_oficial.value=='')
		{
			document.Formulario.Monto_total_moneda_oficial.value=0;
		}
		if (document.Formulario.Monto_total_moneda_oficial.value != document.Formulario.Monto_total_moneda_oficial1.value)
		{
			document.Formulario.Monto_total_moneda_oficial.value=0;
		}

		if (obj.checked)
		{
			document.Formulario.Monto_total_moneda_oficial.value = parseFloat(document.Formulario.Monto_total_moneda_oficial.value) + parseFloat(campo.value);
		}
		else
		{
			document.Formulario.Monto_total_moneda_oficial.value = format_number2( parseFloat(document.Formulario.Monto_total_moneda_oficial.value) - parseFloat(campo.value),2);
		}
		
		if (document.Formulario.Monto_total_moneda_oficial.value==0)
		{
			document.Formulario.Monto_total_moneda_oficial.className = "FunteinputNumerico";
		}
		else
		{
			document.Formulario.Monto_total_moneda_oficial.className="DatooutputNumerico";
		}
		document.Formulario.Monto_total_pesos.value = document.Formulario.Monto_total_moneda_oficial.value
		document.Formulario.Monto_total_moneda_oficial1.value = document.Formulario.Monto_total_moneda_oficial.value;
		document.Formulario.TotalSelec.value = document.Formulario.Monto_total_pesos.value;
		if ( document.Formulario.Monto_total_moneda_oficial.value == 0 )
		{
			nominal();
		}
	}
	
	function saldofavor()
	{
	    // alert("saldo a favor");
		var hora = new Date() ;
		vHours  = hora.getHours() ;
		vMinute = hora.getMinutes() ;
		vSecond = hora.getSeconds() ;
		hora    = "H" + vHours + "" + vMinute + "" + vSecond ;

		var CodDoc = 'UYY'
		if ( '<%=Trim(moneda)%>' == '$' )
		{
			CodDoc = 'YYY'
		}
		
		var winURL  = "../../Consultas/CuentaCteProveedor/WndDetalle_Deuda.asp?hora="+hora + "&CodDoc=" + CodDoc + "&CodProv=<%=Proveedor%>&Título=saldos a favor&Moneda=<%=moneda%>" ;
		var winName = "WndDetalle" ;

		var winFeatures  = "status=no," ; 
		    winFeatures += "resizable=no," ;
			winFeatures += "toolbar=no," ;
			winFeatures += "location=no," ;
			winFeatures += "scrollbars=yes," ;
			winFeatures += "menubar=0," ;
			winFeatures += "target=top," ;
			winFeatures += "width=750," ;
			winFeatures += "height=300," ;
			winFeatures += "top=100," ;
			winFeatures += "left=10" ;

		var wclcl = window.open( winURL, winName, winFeatures ) ;
	          wclcl.opener = self;
	}



</script>



<%conn.close()%>
<%else
	Response.Redirect "../../index.htm"
end if%>

</html>
