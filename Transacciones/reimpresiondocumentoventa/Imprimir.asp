<!-- #include file="../../Scripts/Inc/MontoEscrito.Inc" -->
<!-- #include file="../../Scripts/Inc/caracteres.Inc" -->
<HTML>
<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">

   <OBJECT id=Locales style="LEFT: 0px; TOP: 0px" codeBase=http://altanet1/Epysa/impresion/Impresora.CAB#version=1,1,0,2 
	height=19 width=19 classid="CLSID:EFF5C013-BD27-11D2-9689-0080ADB4B9A9">
	<PARAM NAME="_ExtentX" VALUE="503">
	<PARAM NAME="_ExtentY" VALUE="503"></OBJECT>

   
   <Script language="VBScript">

<% 	        

SET Conn = Server.CreateObject("ADODB.Connection")
Conn.Open Session("Dataconn_ConnectionString")							  
Conn.commandtimeout=600

if request("Reimpresion") <> "S" then
	Nro_int = Request ( "Nroint" )  & "|"
else
	Nro_int	= Request ( "Nroint" )
end if

Arreglo_Nro_int = split(Nro_int,"|")

IVA_Diferido = "N"
Cuenta_bancaria = ""
Empresa	= session ( "Empresa_usuario" )

'response.write(Nro_int)
for i=0 to ubound(Arreglo_Nro_int) -1
	Sql = "Exec DOV_Lista_Facturas "  & Arreglo_Nro_int(i) & ",'" & Empresa & "', 'FAV', 0, '','','',''"

'Response.Write Sql
		SET RsUpdate	=	Conn.Execute( SQL )
		If Not RsUpdate.eof then
			Numero				                    = RsUpdate ( "Numero_documento_valorizado" )
			banco         		                    = RsUpdate ( "banco" )
			Cuenta_bancaria         		        = RsUpdate ( "Cuenta_bancaria" )
			Fecha         		                    = RsUpdate ( "Fecha_emision" )
			Fecha_vencimiento	                    = RsUpdate ( "Fecha_vencimiento" )
			Documento_especial	                    = RsUpdate ( "Documento_especial" )
			Cuenta_contable_para_neto         		= RsUpdate ( "Cuenta_contable_para_neto" )
			Vendedor				         		= RsUpdate ( "Empleado_responsable" )
			Rut						         		= RsUpdate ( "Rut_entidad_comercial" )
			NVendedor				         		= RsUpdate ( "Nombre_Vendedor" )
			Bodega									= RsUpdate ( "Bodega" )
			Cliente         		                = RsUpdate ( "Cliente" )
			Numero_documento_valorizado				= rsUpdate("Numero_documento_valorizado")
			if not isnull(RsUpdate("Datos_cliente")) then
				datoscliente							= split(RsUpdate("Datos_cliente"),"@")
				Comuna         							= datoscliente(0)
				Telefono       							= datoscliente(2)
				Giro_o_profesion						= datoscliente(3)
				Direccion								= datoscliente(4) 			
			else
				Comuna=""
			end if
			Nombre_Cliente         		            = RsUpdate ( "Nombre_cliente" )
			'Fecha_vencimiento         		        = RsUpdate ( "Fecha_vencimiento" )
			Empresa         		                = RsUpdate ( "Empresa" )
			Centro_de_venta         		        = RsUpdate ( "Centro_de_venta" )
			enter13=chr(13)
			enter10=chr(10)
			Observaciones_generales         		= replace(replace(RsUpdate ( "Observaciones_generales" ),enter13, ""), enter10, "")
			Monto_exento_moneda_oficial         	= RsUpdate ( "Monto_exento_moneda_oficial" )
			Monto_afecto_moneda_oficial         	= RsUpdate ( "Monto_afecto_moneda_oficial" )
			Monto_neto								= cdbl(Monto_afecto_moneda_oficial) + cdbl(Monto_exento_moneda_oficial)
			Monto_iva_moneda_oficial         		= RsUpdate ( "Monto_iva_moneda_oficial" )
			Monto_total_moneda_oficial         		= RsUpdate ( "Monto_total_moneda_oficial" )
			Monto_cobrado_o_pagado_moneda_oficial   = RsUpdate ( "Monto_cobrado_o_pagado_moneda_oficial" )
            Fecha_ultimo_cobro_o_pago               = RsUpdate ( "Fecha_ultimo_cobro_o_pago" )
			Control					                = RsUpdate ( "Control" )
			Fecha_ultima_impresion					= RsUpdate ( "Fecha_ultima_impresion" )
			Numero_orden_de_venta					= RsUpdate ( "Numero_orden_de_venta" )
			Numero_interno_epysa					= 0
			Numero_orden_de_venta					= RsUpdate ( "Numero_orden_de_venta" )
		else
			RegistroExistente		= "N"
		end if
		RsUpdate.Close
		'Conn.Close  		
		set RsUpdate=nothing
		
		banco=""
		if Cuenta_bancaria <> "" then
			sql="exec CCB_ListaCuentasBancarias null, '" & Cuenta_bancaria & "'"
			set rs = conn.Execute(sql)
			if not rs.eof then
				banco=rs("banco")
			end if
			Rs.Close
		end if


		if banco <> "" then
			sql="exec BAN_ListaBancos  '" & banco & "', null"
			set rs = conn.Execute(sql)
			if not rs.eof then
				nombre_banco=rs("nombre")
			end if
			Rs.Close
		end if

		sql="exec CIU_ListaCiudades '" & comuna & "', '',''"
		set rs = conn.Execute(sql)
		if not rs.eof then
			comuna=rs("nombre")
		end if
		Rs.Close
		'Conn.Close  		
		set Rs=nothing

		sql="exec DNV_Lista_Notas_de_venta null, '" & session("empresa_usuario") & "'," & Numero_orden_de_venta & ", null, null, null, null, 'B'"
		set rs = conn.Execute(sql)
		if not rs.eof then
			Forma_de_pago=rs("Forma_de_pago")
		end if
		Rs.Close
		'Conn.Close  		
		set Rs=nothing

		sql="exec ECP_Lista_financieras '" & Session("empresa") & "', '" & trim(Forma_de_pago) & "'"
		set rs = conn.Execute(sql)
		if not rs.eof then
			Forma_de_pago=rs("Nombres_persona")
		end if
		Rs.Close
		'Conn.Close  		
		set Rs=nothing


	if documento_especial <> "S" AND NOT Isnull(Numero_interno_epysa) then
		Sql_D = "Exec PRI_Lista_productos_individuales_por_Numero_interno_Epysa " & Numero_interno_epysa

		set RsUpdate = conn.Execute(sql_D)
				Nro_interno					= RsUpdate ( "Numero_interno")			
				Anno_comercial				= RsUpdate ( "Año_comercial")		
				Color						= RsUpdate ( "Color")				
				Largo						= RsUpdate ( "Largo_total")				
				Marca_chasis				= RsUpdate ( "Chasis_marca")		
				Marca_vehiculo				= RsUpdate ( "Carroceria_marca")		
				Modelo_chasis				= RsUpdate ( "modelo_Chasis")		
'				Modelo_chasis				= RsUpdate ( "Chasis_modelo")		
				Modelo_carroceria			= RsUpdate ( "Carroceria_modelo")	
				Nro_asientos				= RsUpdate ( "Numero_de_asientos")		
				Nro_carroceria				= RsUpdate ( "Carroceria_numero")		
				Nro_chasis					= RsUpdate ( "Chasis_numero")			
				Nro_motor					= RsUpdate ( "Numero_motor")			
				Nro_puertas					= RsUpdate ( "Numero_de_puertas")			
				Patente						= RsUpdate ( "Patente")			
				IVA_Diferido				= RsUpdate ( "IVA_Diferido")
				Nuevo_usado					= RsUpdate ( "Nuevo_usado")	
				if Nuevo_usado = "N" then
					Imprime_glosa="N"
					nuevo="(Nuevo sin uso)"
				else
					Imprime_glosa="S"
					nuevo="(Usado)"
				end if
				
				RsUpdate.Close
				set RsUpdate=nothing
	else		
		Imprime_glosa="N"
		Numero_interno_epysa = 0			
	end if	
	if documento_especial = "N" and Numero_interno_epysa = 0 then
		Sql = "Exec DNV_ListaNotaVentaServicio null, '" & Session("Empresa_usuario") & "'," & Numero_orden_de_venta & ", Null, Null, Null, Null, 'S', Null, Null, Null"
	'	Response.Write Sql
		SET RsUpdate	=	Conn.Execute( SQL )
		If Not RsUpdate.eof then
			Clasificacion			= RsUpdate ( "Clasificacion_Servicio" )
			Fecha_NVS    			= RsUpdate ( "Fecha_emision" )
			Nombre_servicio			= RsUpdate ( "Nombre" )
			NumVehiculo   			= RsUpdate ( "Numero_interno_epysa" )
			Observaciones_generales	= RsUpdate ( "Observaciones_generales" )
			if not isnull(NumVehiculo) then
				cSql = "Exec PRI_Lista_productos_individuales 0, 0" & NumVehiculo & ", null, null, null, null "
				'Response.Write(csql)
				Set RsProducto = Conn.Execute( cSql )
				If Not RsProducto.eof then ' Existe el producto
					Ano_comercial	= RsProducto("Año_comercial")
					Chasis_modelo	= RsProducto("Chasis_modelo")
					NumFactura		= RsProducto("Numero_Factura")
				end if
			end if
			RsUpdate.Close
		
			set Rs=nothing
			if not isnull(NumFactura)then
				sql="exec DOV_Lista_DocumentosProductoID 'FAV', '" & session("empresa_usuario") & "', 0" & NumFactura & ", 0" & NumVehiculo
				set Rs = conn.Execute(sql)
				If Not Rs.eof then
					Fecha_factura		= Rs("Fecha_emision")
					Fecha_fac_vcto		= Rs("Fecha_vencimiento")
					Cliente_propietario	= Rs("Cliente")
					Cliente_final		= Rs("Cliente_empresa")
				end if
				Rs.close
				set RsUpdate=nothing
			end if
			if not isnull(Cliente_final) and not isnull(NumFactura) then
				sql="exec ECP_ListaClientes '" & session("empresa_usuario") & "','" & Cliente_final & "',null, null"
				set RS = conn.Execute(sql)
				Nombre_final	= RS("Nombre")
				Rs.close
				set RsUpdate=nothing
			else				
				Nombre_final	= ""
			end if
			if not isnull(Cliente_propietario) and not isnull(NumFactura) then
				sql="exec ECP_ListaClientes '" & session("empresa_usuario") & "','" & Cliente_propietario & "',null, null"
				set RS = conn.Execute(sql)
				Nombre_propietario	= RS("Nombre")
				Rs.close
			else				
				Nombre_propietario	= ""
			end if
			Cuenta_bancaria=""		
		end if
	end if%>

function validar_rut(entrada)

   largo=len(trim(entrada))
   if largo>8 or largo<7 then
	valida_rut=""
	exit function
   end if

   desde=largo

   suma=0

   for n=0 to 5
	suma=suma+mid(entrada,desde-n,1)*(n+2)
   next
   suma=suma+mid(entrada,desde-6,1)*2

   if largo=8 then
	suma=suma+mid(entrada,1,1)*3
   end if

   resultado=11-(suma mod 11)
   dv =		resultado
   if resultado=10 then
	dv="K"
	validar_rut = dv
   end if
   if resultado=11 then
	dv="0"
	validar_rut = dv
   end if
   validar_rut = dv

end function


	linea = space(80)
	linea= mid(linea,1,70) & <%=Numero%>
	Locales.InicioImpresion("LPT1")
'Locales.InicioImpresion("<%=session("impresora_FAV")%>")  
'Locales.InicioImpresion("\\michilla\HPDeskJe") 
'Dim puerto
'if Locales.ElegirImpresora(puerto) then
'Locales.InicioImpresion(puerto) 
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (Linea)
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir ("              <%=Fecha%>")
	Locales.Imprimir ("              <%=Nombre_Cliente%>")

	dim DV					  
	DV = validar_rut ("<%=RUT%>")
	dim Rut_entidad_comercial
	Rut_entidad_comercial = "<%=RUT%>-" & DV

	Linea = space(80)
	Linea = space(14) & "<%=Mid(Direccion,1,50)%>"   & space(62 - len(trim("<%=Mid(Direccion,1,50)%>"))) & "<%=Numero_orden_de_venta%>"
	Locales.Imprimir (Linea)
	Linea = space(80)
	Linea = space(14) & "<%=Mid(Comuna,1,20)%>"   & space(62 - len(trim("<%=Mid(Comuna,1,20)%>"))) & "<%=Vendedor%>"
	Locales.Imprimir (Linea)
	Linea = space(80)
	Linea = space(14) & Rut_entidad_comercial   & space(62 - len(trim(Rut_entidad_comercial))) & "<%=mid(NVendedor,1,20)%>"
	Locales.Imprimir (Linea)
	Linea = space(80)
	Linea = space(14) & "<%=Mid(Telefono,1,30)%>"   & space(62 - len(trim("<%=Mid(Telefono,1,30)%>"))) & ""
	Locales.Imprimir (Linea)
	Linea = space(80)
	Linea = space(14) & "<%=Mid(Giro_o_profesion,1,35)%>"   & space(62 - len(trim("<%=Mid(Giro_o_profesion,1,35)%>"))) & "<%=Bodega%>"
	Locales.Imprimir (Linea)
	Linea = space(80)
	Linea = space(21) & "<%=Mid(Forma_de_pago,1,35)%>"   & space(55 - len(trim("<%=Mid(Forma_de_pago,1,35)%>"))) & "<%=Fecha_vencimiento%>"
	Locales.Imprimir (Linea)
	if "<%=documento_especial%>" <> "S" and <%=Numero_interno_epysa%> > 0 then
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir ("              Tipo de vehiculo : BUS  <%=nuevo%>")
		Locales.Imprimir (" ")
		Locales.Imprimir ("              Marca            : <%=Marca_chasis%>")
		Locales.Imprimir ("              Año comercial    : <%=Anno_comercial%>")
		Locales.Imprimir ("              Modelo           : <%=Modelo_chasis%>")
		Locales.Imprimir ("              Color            : <%=Color%>")
		Locales.Imprimir ("              Nro.Motor        : <%=Nro_motor%>")
		Locales.Imprimir ("              Nro.Chassis      : <%=Nro_chasis%>")
		Locales.Imprimir ("              Nro.Carroceria   : <%=Nro_carroceria%>")
		Locales.Imprimir ("              Nro.Puertas      : <%=Nro_puertas%>")
		Locales.Imprimir ("              Nro.Asientos     : <%=Nro_asientos%>")
		Locales.Imprimir ("              Patente          : <%=Patente%>")
		Locales.Imprimir ("              Largo            : <%=Largo%>")
		Locales.Imprimir ("              Nro.Interno      : <%=Nro_interno%>")
		Locales.Imprimir (" ")
	else
		if "<%=documento_especial%>" = "N" and <%=Numero_interno_epysa%> = 0 then
			Locales.Imprimir (" ")
			Locales.Imprimir ("		 NVS.: <%=Numero_orden_de_venta%> F.E.:<%=Fecha_NVS%>")
			Locales.Imprimir ("		 Num.Vehiculo :<%=NumVehiculo%>")
			Locales.Imprimir ("		 Año Comer.:<%=Ano_comercial%>")
			Locales.Imprimir ("		 Mod.Chasis:<%=Chasis_modelo%>")
			Locales.Imprimir (" ")
			Locales.Imprimir ("		 Propietario:<%=Nombre_propietario%>")
			Locales.Imprimir ("		 Clinete Final:<%=Nombre_final%>")
			Locales.Imprimir (" ")
			Locales.Imprimir ("              <%=trim(mid(Observaciones_generales,1,50))%>")
			Locales.Imprimir ("              <%=trim(mid(Observaciones_generales,51,50))%>")
			Locales.Imprimir ("              <%=trim(mid(Observaciones_generales,101,50))%>")
			Locales.Imprimir ("              <%=trim(mid(Observaciones_generales,151,50))%>")
			Locales.Imprimir ("              <%=trim(mid(Observaciones_generales,201))%>")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
		else
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir ("              <%=trim(mid(Observaciones_generales,1,50))%>")
			Locales.Imprimir ("              <%=trim(mid(Observaciones_generales,51,50))%>")
			Locales.Imprimir ("              <%=trim(mid(Observaciones_generales,101,50))%>")
			Locales.Imprimir ("              <%=trim(mid(Observaciones_generales,151,50))%>")
			Locales.Imprimir ("              <%=trim(mid(Observaciones_generales,201))%>")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
		end if
	end if
	<%if Nuevo_usado = "N" then%>
		<%if IVA_Diferido = "S" then%>
			Locales.Imprimir ("              El Iva que afecta a esta factura se acoge al beneficio señalado")
			Locales.Imprimir ("              en el inciso final del Art.64 DL825 de 1974 segun resolucion")
			Locales.Imprimir ("              Nro Ex. 1364 del 2 de Dicienmbre del 2002 del S.I.I. (DRMSC)")
		<%end if%>
'		Locales.Imprimir (" ")
'		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir ("              Se deja expresa y especial constancia que Epysa Buses")
		Locales.Imprimir ("              administra exclusivamente la garantia tecnica correspondiente")
		Locales.Imprimir ("              a la carroceria Marcopolo. La garantia tecnica correspondiente")
		Locales.Imprimir ("              a cualquier componente distinto de la carroceria es de cargo y ")
		Locales.Imprimir ("              responsabilidad de su respectivo representante y/o fabricante.")
	<%else%>
	   if "<%=Imprime_glosa%>" = "S" then
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir ("              El comprador declara conocer personalmente el estado actual")
			Locales.Imprimir ("              del vehiculo adquirido, tanto en su aspecto material como de")
			Locales.Imprimir ("              condiciones de uso, y lo acepta desde ya, liberando a la")
			Locales.Imprimir ("              vendedora de toda responsabilidad por ello. Pol lo anterior, ")
			Locales.Imprimir ("              el vehiculo no esta amparado por garantia alguna.")
			Locales.Imprimir (" ")
		else
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
		end if
	<%end if%>
	
	<% if Nuevo_usado <> "U" then  'Si es nuevo
		  if IVA_Diferido <> "S" then%>
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
			Locales.Imprimir (" ")
		<%end if%>
	<%end if%>

	if "<%=trim(banco)%>" = "" then
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
	else
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir ("              Instrucciones de pago:")
		Locales.Imprimir ("              Al vencimiento de la presente factura, sirvase a depositar en nuestra Cta.Cte.")
		Locales.Imprimir ("              Nro. <%=Cuenta_bancaria%> Banco:<%=nombre_banco%> y enviar copia del deposito")
		Locales.Imprimir ("              al fax Nro. 6241044")
	end if

		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir ("                 <%=mid(Escribir(cdbl(Monto_total_moneda_oficial)),1,50)%> -")
		Locales.Imprimir ("                 <%=mid(Escribir(cdbl(Monto_total_moneda_oficial)),51)%> PESOS")
	'msgbox(Linea)
		Linea = space(80)
		Linea = space(92 - len(trim("<%=formatnumber(Monto_neto,0)%>"))) & "<%=formatnumber(Monto_neto,0)%>"
		Locales.Imprimir (Linea)
		Linea = space(80)
		if <%=clng(Monto_iva_moneda_oficial)%> > 0 then
			Linea = space(92 - len(trim("<%=formatnumber(Monto_iva_moneda_oficial,0)%>"))) & "<%=formatnumber(Monto_iva_moneda_oficial,0)%>"
		else
			linea = ""
		end if
		Locales.Imprimir (Linea)
		Linea = space(80)
		Linea = space(92 - len(trim("<%=formatnumber(Monto_total_moneda_oficial,0,0)%>"))) & "<%=formatnumber(Monto_total_moneda_oficial,0,0)%>"
		Locales.Imprimir (Linea & chr(12))
	'	Locales.Imprimir ()
	Locales.FinImpresion	
<%next
Conn.Close%>
'end if
 </Script>
<BR>
<BR>
<center><font color="RED" face="arial" size="6"><b>
	&nbsp;Imprimiendo ...
		</b>
	</font></center>
<script language="javascript">
function salir()
{
	if( '<%=request("Reimpresion")%>' == 'S')
	{
		parent.top.frames[3].location.href = "../../mensajes.asp?Msg=Documento Nº <%=Numero%> se está imprimiendo";
	}
	else
	{
		if ('<%=Documento_especial%>' == "S")
		{
			parent.top.frames[3].location.href = "../../mensajes.asp?Msg=Documento Nº <%=Numero%> se está imprimiendo";
			parent.top.frames[1].location.href = "../FacturaVtaEspecial/Inicial_FacVtaEsp.asp";
			parent.top.frames[2].location.href = "../FacturaVtaEspecial/Botones_FacVtaEsp.asp";
		}
		else
		{
			parent.top.frames[1].location.href = "Inicial_FacturaBus.asp";
			parent.top.frames[2].location.href = "Botones_FacturaBus.asp";
		}
	}
}
</script>
</body>
</HTML>
