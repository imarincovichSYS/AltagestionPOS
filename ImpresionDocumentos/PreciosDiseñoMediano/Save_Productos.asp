<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	Codigo	= Request ( "Codigo_pais" )
	Nombre	= Request ( "Nombre_pais" )	
	Orden	= Request ( "Orden" )	

On error resume next
	msgerror=""
	error=0
	Error_ = "N"
	
	Proveedor = Request("Proveedor")	
	if len(trim(Proveedor)) = 0 then
		Proveedor = "Null"
	else
		Proveedor = "'" & Proveedor & "'"
	end if


	'AfectoExento = Request("AfectoExento")
	'	if len(trim(AfectoExento)) = 0 then AfectoExento = "Null" Else AfectoExento = "'" & AfectoExento & "'"

  if ucase(left(Codigo,1)) = "G" then
	   AfectoExento = "E"
	else
	   AfectoExento = "A"
	end if

	Descripcion_para_boleta				= Request("Descripcion_para_boleta")
		if len(trim(Descripcion_para_boleta)) = 0 then Descripcion_para_boleta = "Null" Else Descripcion_para_boleta = "'" & Descripcion_para_boleta & "'"
	Ultimo_CPA							= Request("Ultimo_CPA")
		if len(trim(Ultimo_CPA)) = 0 then Ultimo_CPA = "Null"
	Temporada							= Request("Temporada")
		if len(trim(Temporada)) = 0 then Temporada = "Null" Else Temporada = "'" & Temporada & "'"
	Producto_es_vehiculo				= Request("Producto_es_vehiculo")
		if len(trim(Producto_es_vehiculo)) = 0 then Producto_es_vehiculo = "Null" Else Producto_es_vehiculo = "'" & Producto_es_vehiculo & "'"

  Esta_certificado				= Request("Esta_certificado")
		if len(trim(Esta_certificado)) = 0 then Esta_certificado = "N" Else Esta_certificado = "'" & Esta_certificado & "'"

	TasaImpuesto = Request("TasaImpuesto")
		if len(trim(TasaImpuesto)) = 0 then TasaImpuesto = 0 Else TasaImpuesto = TasaImpuesto

    Unidad_de_medida_venta_volumen_en_m3 = Request("Unidad_de_medida_venta_volumen_en_m3")
        if len(trim(Unidad_de_medida_venta_volumen_en_m3)) = 0 then Unidad_de_medida_venta_volumen_en_m3 = 0 Else Unidad_de_medida_venta_volumen_en_m3 = Cdbl( Unidad_de_medida_venta_volumen_en_m3 )
    Unidad_de_medida_venta_volumen_en_m3 = Unidad_de_medida_venta_volumen_en_m3 * 1000000



	Set ConnManejo= Server.CreateObject("ADODB.Connection")
	ConnManejo.Open Session( "DataConn_ConnectionString" )
	ConnManejo.BeginTrans
	if len(trim(Request("Tipo_servicio"))) = 0 then
		Tipo_servicio = "Null"
	else
		Tipo_servicio = "'" & Request("Tipo_servicio") & "'"
	end if

		cSQL	=	"Exec PRO_GrabaProducto		 '"	&	Request("Codigo_pais")									& "', '" & +_
														Request("Nombre_pais")									& "', '" & +_
														Request("Empresa")										& "', '" & +_
														Request("Tipo_producto")								& "', '" & +_
														Request("Producto_final_o_insumo")						& "', 0" & +_
														Request("Stock_minimo")									& ",  0" & +_
														Request("Stock_maximo")									& ",  0" & +_
														Request("Costo_de_reposicion_unitario")					& ",  '" & +_
														Request("Slct_SuperFam")								& "', '" & +_
														Request("Slct_Familia")									& "', '" & +_
														Request("Slct_SubFamilia")								& "', '" & +_
														Request("Marca")										& "', '" & +_
														
														Request("Unidad_de_medida_consumo")						& "', '" & +_
														Request("Unidad_de_medida_compra")						& "', 0" & +_
														Request("Cantidad_um_consumo_que_hay_en_una_um_compra")	& ",   " & +_
														
														Proveedor												& ",  '" & +_
														Request("Producto_proveedor_habitual")					& "', '" & +_
														Request("Nombre_producto_proveedor_habitual")			& "', 0" & +_
														Request("Precio_lista_proveedor_habitual")				& ",  0" & +_
														Request("Porcentaje_descuento_1_de_compra")				& ",  0" & +_
														Request("Porcentaje_descuento_2_de_compra")				& ",  0" & +_
														Request("Porcentaje_descuento_3_de_compra")				& ",  0" & +_
														Request("Porcentaje_impuesto_1")						& ",  0" & +_
														Request("Porcentaje_impuesto_2")						& ",  0" & +_
														Request("Porcentaje_impuesto_3")						& ",  0" & +_
														Request("Porcentaje_impuesto_4")						& ",  0" & +_
														Request("Porcentaje_impuesto_5")						& ",  0" & +_
														Request("Porcentaje_impuesto_6")						& ",  '" & +_
														Request("Moneda_de_compra")								& "', "  & +_
														Tipo_servicio											& ", 0"  & +_
														Request("Control")										& ", '"  & +_
														Request("Slct_Estado")									& "', '" & +_
														Request("IvaObligatorio")								& "', '" & +_
														Request("Vendible")										& "','" & +_
														Request("Descripcion_detallada") & "', '" & _
                            Request("Imagen") & "', Null, Null, Null, '" & Request("Procedencia_producto") & "', '" & +_
														Request("Codigo_EAN13")									& "', '" & +_
														Request("Unidad_de_medida_cajas_envase_compra")			& "', '" & +_
														Request("Unidad_de_medida_envase_compra")				& "', 0" & +_
														Request("Unidad_de_medida_venta_peso_en_kgs")			& ", 0" & +_
														Unidad_de_medida_venta_volumen_en_m3			        & ", 0" & +_
														Request("Cantidad_um_compra_en_envase_compra")			& ", 0" & +_
														Request("Cantidad_um_compra_en_caja_envase_compra")		& ", " & +_
														AfectoExento											& ", " & +_
														Descripcion_para_boleta									& ", " & +_
														Ultimo_CPA												& ", " & +_
														Temporada												& ", " & +_
														Producto_es_vehiculo                                    & ", " & +_
														TasaImpuesto                                 & ", " & +_
														Esta_certificado



			Set RsManejo = ConnManejo.Execute( cSQL )
			if ConnManejo.Errors.Count = 0 then
				Registros	= RsManejo("Registros")
				Error		= RsManejo("Error")
				If Registros > 0 and Error = 0 then
				Else
					Error_ = "S"
					msgerror = Replace(Err.Description, "[Microsoft][ODBC SQL Server Driver][SQL Server]","")
				end if
			Else
				Error_ = "S"
				msgerror = Replace(Err.Description, "[Microsoft][ODBC SQL Server Driver][SQL Server]","")
			end if
			RsManejo.Close
			Set RsManejo = Nothing

	if len(trim(Request("Codigo_DUN14"))) > 0 then
		if ConnManejo.Errors.Count = 0 then
			cSQL	=	"Exec PRD_Graba_Producto_DUN14 '" &	Request("Codigo_pais")	& "', '" & +_
															Request("Codigo_EAN13")	& "', '" & +_
															Request("Codigo_DUN14")	& "', 0" & +_
															Request("Unidades_DUN14")
	'Response.Write cSQL + "<br>"
			Set RsManejo = ConnManejo.Execute( cSQL )
			if ConnManejo.Errors.Count > 0 then
				Error_ = "S"
				msgerror = Replace(Err.Description, "[Microsoft][ODBC SQL Server Driver][SQL Server]","")
			end if			
		end if
	end if					
		msgerror	= Replace(msgerror, "[Microsoft][ODBC SQL Server Driver][SQL Server]","")
		msgerror	= Replace(msgerror, "'","")
		if Error_ = "N" then
			ConnManejo.CommitTrans				
			msgerror	= "Proceso terminado satisfactoriamente."
		else
			ConnManejo.RollbackTrans
		end if
		RsManejo.Close
		Set RsManejo = Nothing
		ConnManejo.close
%>

<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
</body>

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

<script language="JavaScript">
		if ( '<%=msgerror%>' != '')
		{
			Mensajes( "<%=msgerror%>" );
		}
		if ( '<%=Error_%>' != "S" )
		{
			parent.top.frames[2].location.href = "Botones_Productos.asp";
			parent.top.frames[1].location.href = 'Inicial_Productos.asp?Orden=<%=Orden%>&pagenum=<%=Request("pagenum")%>';
		}
</script>
<%else
	Response.Redirect "../../index.htm"
end if%>
