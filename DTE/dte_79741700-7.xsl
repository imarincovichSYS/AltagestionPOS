<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sii="http://www.sii.cl/SiiDte" version="1.0">
	<xsl:output method="html"/>
	<xsl:decimal-format name="clp" decimal-separator="," grouping-separator="."/>
	<xsl:template match="/">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
				<title/>
				<style type="text/css">

@page {
  margin-left: 0cm;
  margin-right: 0cm;
  margin-top: 0cm;
  margin-bottom: 0cm;
  size: 21.6cm 27.9cm;
}

.DTEPage {
  background-position: center;
  background-repeat  : repeat;
  position           : relative;
  width              : 18.5cm;
  height             : 20cm;
}

.DTEidTable {
  border: 1mm solid black;
  width: 5.5cm;
  height: 2cm;
  font-family: arial;
  font-size: 0.35cm;
  font-weight: bold; 
  color: black;
  text-align: center;
}

.letraRazon {
  font-style  : normal;
  font-size   : 3.3mm;
  font-family : Arial, Helvetica;
  font-weight : bold;
  color       : black;
}

.letraGiro {
  font-style  : normal;
  font-size   : 2mm;
  font-family : Arial, Helvetica;
  color       : black;
}

.letraDireccion {
  font-style  : normal;
  font-size   : 2mm;
  font-family : Arial, Helvetica;
  color       : black;
}
.letraFono {
  font-style  : normal;
  font-weight : bold;
  font-size   : 3.3mm;
  font-family : Arial, Helvetica;
  color       : black;
}
.letraMail {
  font-style  : normal;
  font-weight : bold;
  font-size   : 2.15mm;
  font-family : Arial, Helvetica;
  color       : black;
}

.tablaFactura {
  border-style: solid;
  border-color: black;
  width	      : 100%;
}

.tablaDatos {
  border-style: solid;
  border-width: 1;
  border-color: black;
}

.cabeceraClientes {
  font-family : arial;
  font-size   : 10px;
  text-align  : left;
}

.textoClientes {
  font-family : arial;
  font-size   : 11px;
  text-align  : left;
}

.textoTransporte {
  font-family : arial;
  font-size   : 11px;
  text-align  : left;
  border-right: 1px solid black;
}

.textoReferencia {
  font-family : arial;
  font-size   : 12px;
  text-align  : left;
}

.cabeceraDetallesB {
  border-right  : 1px solid black;
  font-family   : arial;
  font-size     : 2.5mm;  
  border-bottom : 1px solid black;
  border-top    : 1px solid black;
  color         : black;
  background-color : white;
}

.cabeceraDetallesN {
  font-family   : arial;
  font-size     : 10px;
  text-align    : center;
  border-bottom : 1px solid black;
  border-top    : 1px solid black;
  color         : black;
}

.DetalleB {
  font-family  : arial;
  font-size    : 2.5mm;
  border-right : 1px solid black;
}

.DetalleN {
  font-family  : arial;
  font-size    : 10px;
}

.productoTextoConMargenDF {
  font-family :arial;
  font-size   :10px;
  border-right:1px solid black;
  border-bottom:1px solid black;
}

.TablaTotales {
  font-family :arial;
  font-size   :9px;
  font-weight :bold;
  text-align  :left;
  border      :2px solid black;
  color       :black;
}

.TotalGlosa {
  font-family :Arial;
  font-size   :2.5mm;
  font-weight :bold;  
  vertical-align: bottom;
  color       :black;
}

.TotalMonto {
  font-family :Arial;
  font-size   :3mm;
  font-weight :bold;
  text-align  :right;
  color       :black;
}

.espacio {
  height: 1mm;
  font-size: 1mm;
}

.oficina-sii {
  font-family: arial; 
  font-size: 3mm; 
  color: black; 
  text-align: center; 
  font-weight: bold; 
  text-transform: uppercase;
}

        </style>
				<script>
					<xsl:comment><![CDATA[

					String.prototype.formTraslado = function () {
						switch (this + '.') {
							case '.': result = ""; break;
							case '1.': result = "Constituye venta"; break;
							case '2.': result = "Venta por efectuar"; break;
							case '3.': result = "Consignaciones"; break;
							case '4.': result = "Entrega gratuita"; break;
							case '5.': result = "Traslado interno"; break;
							case '6.': result = "Otro traslado no venta"; break;
							case '7.': result = "Guía de devolución"; break;
							default:   result = "¿Tipo Traslado? ["+this+"]"; break;
						}
						document.write(result);
					}

					String.prototype.formDTEName = function () {
						switch (this + '.') {
							case '33.': result = "FACTURA ELECTRÓNICA"; break;
							case '34.': result = "FACTURA EXENTA O NO AFECTA ELECTRÓNICA"; break;
							case '52.': result = "GUÍA DE DESPACHO ELECTRÓNICA"; break;
							case '56.': result = "NOTA DE DÉBITO ELECTRÓNICA"; break;
							case '61.': result = "NOTA DE CRÉDITO ELECTRÓNICA"; break;
							case '801.': result = "ORDEN DE COMPRA"; break;
							case 'MER.': result = "MERCADERIA"; break;
							case 'SER.': result = "SERVICIO"; break;
							case 'SET.': result = "SET DE PRUEBA"; break;
							default:    result = "¿Tipo DTE? ["+this+"]"; break;
						}
						document.write(result);
					}

					String.prototype.formRut = function() {
						result = this.toUpperCase();
						result = result.replace(/[^0-9K]+/g, "");
						result = result.match(/(.+)(...)(...)(.)/);
						document.write(result[1] + "." + result[2] +  "." + result[3] +  "-" + result[4]);
					}

					String.prototype.formUpper = function() {
						document.write(this.toUpperCase());
					}

					String.prototype.formMedioPago = function() {
						switch (this + '.') {
							case '.'  : result = ''; break;
							case 'EF.': result = 'Efectivo'; break;
							case 'CH.': result = 'Cheque'; break;
							case 'LT.': result = 'Letra'; break;
							case 'PE.': result = 'Pago a Cta. Cte.'; break;
							case 'TC.': result = 'Tarjeta de Crédito'; break;
							case 'OT.': result = 'Otro'; break;
							case 'CF.': result = 'Cheque a fecha'; break;
							default:    result = "¿Medio Pago? ["+this+"]"; break;
						}
						document.write(result);
					}

					String.prototype.formFecha = function() {
						if (this != "") {
							document.write(this.substring(8,10) + "/" + this.substring(5,7) + "/" + this.substring(0,4));
						}
					}

					function setRowsBgcolor() 
					{
						for(i=0;i<this.rows.length;i++)
						{
							if(this.rows[i].rowIndex % 2 == 0)
								this.rows[i].style.backgroundColor="white";
							else
								this.rows[i].style.backgroundColor="LightGrey";
						}
					}

]]></xsl:comment>
				</script>
			</head>
			<body style="margin: 0; text-align: right; background-color: white;">
				<table class="DTEPage" border="0">
					<tr>
						<td valign="top">
							<table border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td rowspan="2" valign="top" align="left" width="20%">
										<xsl:choose>
											<xsl:when test="Document/Content/DatosAdjuntos/LogoURL[.!='']">
												<img style="border: 0; width: 3cm; height: 2cm;">
													<xsl:attribute name="src"><xsl:value-of select="Document/Content/DatosAdjuntos/LogoURL"/></xsl:attribute>
												</img>
												<br/>
											</xsl:when>
										</xsl:choose>
										<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado/sii:Emisor">
											<font class="letraRazon">
												<xsl:value-of select="/Document/Content/DatosAdjuntos/xRazonSocial"/>
											</font>
											<br/>
											<font class="letraGiro">
												<xsl:value-of select="sii:GiroEmis"/>
											</font>
											<br/>
											<font class="letraDireccion">
												<xsl:value-of select="sii:DirOrigen"/>, <xsl:value-of select="sii:CmnaOrigen"/>, <xsl:value-of select="sii:CiudadOrigen"/>
											</font>
											<br/>
										</xsl:for-each>
											<font class="letraDireccion">
												SUCURSALES<br/>
												CONDELL 1307 - 1308, Providencia<br/>
												ALBERTO RIESCO 0220, Huechuraba<br/>
											</font>
										<font class="letraFono">
											<xsl:value-of select="/Document/Content/DatosAdjuntos/DatosEmpresa"/>
										</font>
											 <br/>
										<font class="letraMail">
											<xsl:value-of select="/Document/Content/DatosAdjuntos/xDatosEmpresaEmail"/>
											 <br/>
										</font>
									</td>
									
									<td valign="top" style="width: 60%; text-align: left;">
										<!--COMIENZO tabla datos receptor-->
										<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado">
											<table class="textoclientes" style="width: 100%;" cellspacing="0" cellpadding="0" border="0">
												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">SEÑORES:</td>
													<td style="width: 6cm; text-align: LEFT;" class="textoClientes">
														<xsl:value-of select="sii:Receptor/sii:RznSocRecep"/>
													</td>
												</tr>
												
												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">R.U.T.:</td>
													<td style="width: 2.8cm; text-align: LEFT;" class="textoClientes">
														<script>"<xsl:value-of select="sii:Receptor/sii:RUTRecep"/>".formRut()</script>
													</td>
												</tr>
			
												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">GIRO:</td>
													<td class="textoClientes">
														<xsl:value-of select="sii:Receptor/sii:GiroRecep"/>
													</td>
												</tr>
												
												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">DIRECCION:</td>
													<td class="textoClientes">
														<xsl:value-of select="sii:Receptor/sii:DirRecep"/>
													</td>
												</tr>
												
												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">COMUNA:</td>
													<td class="textoClientes">
														<xsl:value-of select="sii:Receptor/sii:CmnaRecep"/>
													</td>
												</tr>

												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">TELEFONO:</td>
													<td class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xTelefonoCliente"/>
													</td>
												</tr>

												<tr valign="bottom" style="height: 6mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">VENDEDOR:</td>
													<td class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xVendedor"/>
													</td>
												</tr>

												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">COND.PAGO:</td>
													<td style="width: 2.8cm; text-align: LEFT;" class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xCondPago"/>
													</td>
												</tr>

												<tr valign="bottom" style="height: 6mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">TRANSPORTE:</td>
													<td style="width: 2.8cm; text-align: left;" class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xTransporte"/>
													</td>
												</tr>

												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">DESPACHAR A:</td>
													<td style="width: 2.8cm; text-align: left;" class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xDespacharA"/>
													</td>
												</tr>
												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">PESO:</td>
													<td style="width: 2.8cm; text-align: left;" class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xPeso"/>
													</td>
												</tr>
												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">BODEGA:</td>
													<td style="width: 2.8cm; text-align: left;" class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xBodega"/>
													</td>
												</tr>
											</table>
										</xsl:for-each>
									</td>									
									
									<td valign="top" >
										<table class="DTEidTable" align="center" border="0">
											<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado">
												<tr>
													<td align="center" >R.U.T.: <script>"<xsl:value-of select="sii:Emisor/sii:RUTEmisor"/>".formRut()</script>
													</td>
												</tr>
												<tr>
													<td>
														<script>"<xsl:value-of select="sii:IdDoc/sii:TipoDTE"/>".formDTEName()</script>
													</td>
												</tr>
												<tr>
													<td>Nº&#160;<xsl:value-of select="format-number(sii:IdDoc/sii:Folio, '.##0', 'clp')"/>
													</td>
												</tr>
											</xsl:for-each>
										</table>
										<div class="espacio"/>
										<div class="oficina-sii">
											<xsl:value-of select="Document/Content/DatosAdjuntos/SIIAgencia"/>
										</div>
									<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado">
										<div class="espacio"/>
										<div class="textoclientes" >
											<table width="100%" border="0">
												<tr style="height: 3mm;">
													<td style="width: 4.5cm;" class="cabeceraClientes">FECHA EMISION:</td>
													<td style="width: 2.8cm; text-align: LEFT;" class="textoClientes"><script>"<xsl:value-of select="sii:IdDoc/sii:FchEmis"/>".formFecha()</script></td>
												</tr>
												<tr style="height: 3mm;">
													<td style="width: 4.5cm;" class="cabeceraClientes">FECHA VENCIMIENTO:</td>
													<td style="width: 2.8cm; text-align: LEFT;" class="textoClientes">
													<script>"<xsl:value-of select="/Document/Content/DatosAdjuntos/xFechaVencimiento"/>".formFecha()</script>
													</td>
												</tr>

												<tr style="height: 3mm;">
													<td style="width: 4.5cm;" class="cabeceraClientes">NOTA DE VENTA:</td>
													<td style="width: 2.8cm; text-align: left;" class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xNotaVenta"/>
													</td>
												</tr>

												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">GUIA DESPACHO:</td>
													<td style="width: 2.8cm; text-align: left;" class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xGuiaDespacho"/>
													</td>
												</tr>												
												<tr style="height: 3mm;">
													<td style="width: 4.5cm;" class="cabeceraClientes">ORDEN COMPRA:</td>
													<td style="width: 2.8cm; text-align: LEFT;" class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xOrdenCompra"/>
													</td>
												</tr>
												<!--
												<tr style="height: 3mm;">
													<td style="width: 2.5cm;" class="cabeceraClientes">PESO:</td>
													<td style="width: 2.8cm; text-align: left;" class="textoClientes">
														<xsl:value-of select="/Document/Content/DatosAdjuntos/xPeso"/>
													</td>
												</tr>	-->											
											</table>
										</div>
									</xsl:for-each>
									</td>
								</tr>
								<tr>
									<td colspan="2" class="cabeceraClientes">OBSERVACIONES:&#160;&#160;
										<xsl:value-of select="/Document/Content/DatosAdjuntos/xObservaciones_generales"/>
									</td>
							<!--
								</tr>
								<tr>
									<td style="width: 10cm; text-align: left;" class="textoClientes">&#160;</td>
									<td colspan="2" style="width: 10cm; text-align: left;" class="textoClientes">
										<xsl:value-of select="/Document/Content/DatosAdjuntos/xObservaciones_generales"/>
									</td>
							-->
								</tr>
							</table>
							<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado/sii:Transporte">
								<table class="tablaDatos" style="width: 100%; border-top: none;" cellspacing="1" cellpadding="2" border="0">
									<tr>
										<xsl:choose>
											<xsl:when test="sii:Patente[.!='']">
												<td class="textoTransporte">Patente:&#160;<xsl:value-of select="sii:Patente"/>
												</td>
											</xsl:when>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="sii:RUTTrans[.!='']">
												<td class="textoTransporte">R.U.T. Transportista:&#160;<script>"<xsl:value-of select="sii:RUTTrans"/>".formRut()</script>
												</td>
											</xsl:when>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="sii:DirDest[.!='']">
												<td class="textoTransporte">Direccion:&#160;<xsl:value-of select="sii:DirDest"/>
												</td>
											</xsl:when>
										</xsl:choose>
										<xsl:choose>
											<xsl:when test="sii:CmnaDest[.!='']">
												<td class="textoTransporte">Comuna:&#160;<xsl:value-of select="sii:CmnaDest"/>
												</td>
											</xsl:when>
										</xsl:choose>
									</tr>
								</table>
							</xsl:for-each>
							<div class="espacio"/>
							<div class="espacio"/>
							<!--fin de tabla con datos receptor, empieza tabla detalle -->
							<table border="0" cellspacing="0" cellpadding="0" width="100%">
								<tr>
									<td>
										<!-- INICIO de tabla contenido -->
										<table border="0" style="width: 100%; height: 15.5cm; border-left: 1px solid black; border-bottom: 1px solid black;" cellspacing="0" id="mitabla">
											<tr style="height: 3mm;">
												<!-- <td class="cabeceraDetallesB" style="width: 0.8cm;">ITEM</td> -->
												<td class="cabeceraDetallesB" align="right" style="width: 0.5cm;">CANT.</td>
												<td class="cabeceraDetallesB" align="left" style="width: 1.25cm;">CODIGO</td>
												<td class="cabeceraDetallesB">DESCRIPCION</td>
												<td class="cabeceraDetallesB" align="center" style="width: 2cm;">COD.CLIENTE</td>
												<td class="cabeceraDetallesB" align="right" style="width: 1cm;">PRECIO</td>
												<td class="cabeceraDetallesB" align="right" style="width: 1cm;">DESC.</td>
												<td class="cabeceraDetallesB" align="right" style="width: 1cm;">TOTAL</td>
											</tr>
											<!-- <tr style="height: 1mm;">
												<td class="DetalleB" style="font-size: 1mm;">&#160;</td>
												<td class="DetalleB" style="font-size: 1mm;">&#160;</td>
												<td class="DetalleB" style="font-size: 1mm;">&#160;</td>
												<td class="DetalleB" style="font-size: 1mm;">&#160;</td>
												<td class="DetalleB" style="font-size: 1mm;">&#160;</td>
												<td class="DetalleB" style="font-size: 1mm;">&#160;</td>
												<td class="DetalleB" style="font-size: 1mm;">&#160;</td>
											</tr> -->
											<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Detalle">
												<tr style="height: 2.5mm;">
													<!--
													<td class="DetalleB" align="center" valign="top">
														<xsl:value-of select="sii:NroLinDet"/>
													</td>
													-->
													<td class="DetalleB" align="right" valign="top">
														<xsl:choose>
															<xsl:when test="sii:QtyItem[.!='']">
																<xsl:value-of select="sii:QtyItem"/>
															</xsl:when>
															<xsl:otherwise>&#160;</xsl:otherwise>
														</xsl:choose>
													</td>
													<td class="DetalleB" align="left" valign="top">
														<xsl:choose>
															<xsl:when test="sii:CdgItem[.!='']">
																<xsl:value-of select="sii:CdgItem/sii:VlrCodigo"/>
															</xsl:when>
															<xsl:otherwise>&#160;</xsl:otherwise>
														</xsl:choose>
													</td>
													<td class="DetalleB" align="left" valign="top">
														<xsl:value-of select="sii:NmbItem"/>
													</td>
													<td class="DetalleB" align="center" valign="top">
														<xsl:value-of select="sii:DscItem"/>&#160;
													</td>
													<td class="DetalleB" align="right" valign="top">
														<xsl:if test="sii:PrcItem[.!='']">
															<xsl:value-of select='format-number(sii:PrcItem, ".##0,", "clp")'/>
														</xsl:if>&#160;
													</td>
													<td class="DetalleB" align="right" valign="top">
														<xsl:if test="sii:DescuentoPct[.!='']">(<xsl:value-of select="format-number(sii:DescuentoPct, '.##0,#', 'clp')"/>%)</xsl:if>&#160;
														<xsl:if test="sii:DescuentoMonto[.!='']">
															<xsl:value-of select="format-number(sii:DescuentoMonto, '.##0', 'clp')"/>
														</xsl:if>&#160;
													</td>
													<td class="DetalleB" align="right" valign="top">
														<xsl:value-of select='format-number(sii:MontoItem, ".##0", "clp")'/>&#160;</td>
												</tr>
											</xsl:for-each>
											<tr>
												<td class="DetalleB">&#160;</td>
												<td class="DetalleB">&#160;</td>
												<td class="DetalleB">&#160;</td>
												<td class="DetalleB">&#160;</td>
												<td class="DetalleB">&#160;</td>
												<td class="DetalleB">&#160;</td>
												<td class="DetalleB">&#160;</td>
											</tr>
											<xsl:variable name="hasReferences" select="boolean(Document/Content/sii:DTE/sii:Documento/sii:Referencia)"/>
											<xsl:variable name="hasDscRcgGlobales" select="boolean(Document/Content/sii:DTE/sii:Documento/sii:DscRcgGlobal)"/>
											<xsl:if test="$hasReferences or $hasDscRcgGlobales">
												<tr>
													<td class="DetalleB" colspan="7" style="border:1px solid black; height: 1%; border-left: none; border-bottom: none;" valign="top">
														<span style="width: 100%; vertical-align: top;">
															<xsl:if test="$hasReferences">
														<!--
															<div class="espacio"/>
														-->
																<table cellpadding="1" cellspacing="1" bgcolor="black" width="95%">
																	<tr style="background-color: LightGrey;">
																		<td class="DetalleN" align="left">DOCUMENTO(S) DE REFERENCIA:</td>
																		<td class="DetalleN" align="center">Fecha Emisión</td>
																		<td class="DetalleN" align="right">Folio&#160;&#160;&#160;</td>
																		<td class="DetalleN">Razon de Referencia</td>
																	</tr>
																	<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Referencia">
																		<tr style="background-color: LightGrey;">
																			<td class="DetalleN" align="left">
																				<script>"<xsl:value-of select="sii:TpoDocRef"/>".formDTEName()</script>
																			</td>
																			<td class="DetalleN" align="center">
																				<script>"<xsl:value-of select="sii:FchRef"/>".formFecha()</script>
																			</td>
																			<td class="DetalleN" align="right">
																				<xsl:value-of select='format-number(sii:FolioRef, ".##0", "clp")'/>&#160;&#160;&#160;</td>
																			<td class="DetalleN">
																				<xsl:value-of select="sii:RazonRef"/>
																			</td>
																		</tr>
																	</xsl:for-each>
																</table>
															</xsl:if>
														</span>
														<span style="width: 49%; vertical-align: top;">
															<xsl:if test="$hasDscRcgGlobales">
														DESCUENTOS Y RECARGOS GLOBALES:<br/>
																<div class="espacio"/>
																<table cellpadding="3" cellspacing="1" bgcolor="black" width="100%">
																	<tr style="background-color: LightGrey;">
																		<td class="DetalleN">Glosa&#160;&#160;&#160;</td>
																		<td class="DetalleN" align="right">Valor&#160;&#160;&#160;</td>
																		<td class="DetalleN">Afecta Item(s)&#160;&#160;&#160;</td>
																	</tr>
																	<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:DscRcgGlobal">
																		<tr style="background-color: LightGrey;">
																			<td class="DetalleN">
																				<xsl:value-of select="sii:GlosaDR"/>&#160;&#160;&#160;</td>
																			<td class="DetalleN" align="right">
																				<xsl:value-of select="sii:ValorDR"/>&#160;<xsl:value-of select="sii:TpoValor"/>&#160;&#160;&#160;</td>
																			<td class="DetalleN">
																				<xsl:variable name="DscIndExe" select="string(sii:IndExeDR)"/>
																				<xsl:for-each select="/Document/Content/sii:DTE/sii:Documento/sii:Detalle">
																					<xsl:variable name="DetIndExe" select="string(sii:IndExe)"/>
																					<xsl:if test="$DscIndExe = $DetIndExe">
																						<xsl:value-of select="sii:NroLinDet"/>,&#160;</xsl:if>
																				</xsl:for-each>
																			</td>
																		</tr>
																	</xsl:for-each>
																</table>
															</xsl:if>
														</span>
													</td>
												</tr>
											</xsl:if>
										</table>
										<!-- FIN tabla de contenido -->
										<script> mitabla.setbgcolor = setRowsBgcolor; mitabla.setbgcolor(); </script>
									</td>
								</tr>								
								
								<tr>
									<td>
										<table border="0" width="100%" cellspacing="0" cellpadding="0">
											<tr>
												<td colspan="2" width="100%">
													<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado/sii:Totales">
														<table class="TablaTotales" border="0" width="100%" cellspacing="0" cellpadding="2" style="border-top: 1px solid rgb(49,66,132);">
															<tr>
																<td width="12.5%" align="right" class="TotalGlosa">NETO:</td>
																<td width="12.5%" class="TotalMonto">
																	<xsl:value-of select='format-number(sii:MntNeto, ".##0", "clp")'/>
																</td>
																<td width="12.5%" align="right" class="TotalGlosa">EXENTO:</td>
																<td width="12.5%" class="TotalMonto">
																	<xsl:choose>
															          <xsl:when test="sii:MntExe[.!='0']">
															            <xsl:value-of select='format-number(sii:MntExe, ".##0", "clp")'/>
															          </xsl:when>
															          <xsl:otherwise>0</xsl:otherwise>
															        </xsl:choose>
																</td>
																<td width="12.5%" align="right" class="TotalGlosa">I.V.A.:<xsl:value-of select="sii:TasaIVA"/>%</td>
																<td width="12.5%" class="TotalMonto">
																	<xsl:value-of select='format-number(sii:IVA, ".##0", "clp")'/>
																</td>
															<xsl:if test="sii:GrntDep[.!='0']">
																<tr>
																	<td class="TotalGlosa">GAR. DEP. ENV.</td>
																	<td class="TotalMonto">
																		<xsl:value-of select='format-number(sii:GrntDep, ".##0", "clp")'/>
																	</td>
																</tr>
															</xsl:if>
																<td width="12.5%" align="right" class="TotalGlosa">TOTAL:</td>
																<td width="12.5%" class="TotalMonto">
																	<xsl:value-of select='format-number(sii:MntTotal, ".##0", "clp")'/>
																</td>
															</tr>
															<xsl:if test="sii:MontoNF[.!='0']">
																<tr>
																	<td class="TotalGlosa">NO FACTURABLE</td>
																	<td class="TotalMonto">
																		<xsl:value-of select='format-number(sii:MontoNF, ".##0", "clp")'/>
																	</td>
																</tr>
																<tr>
																	<td class="TotalGlosa">MONTO PERIODO</td>
																	<td class="TotalMonto">
																		<xsl:value-of select='format-number(sii:MontoPeriodo, ".##0", "clp")'/>
																	</td>
																</tr>
															</xsl:if>
															<xsl:if test="boolean(sii:SaldoAnterior) and number(sii:SaldoAnterior) != 0">
																<tr>
																	<td class="TotalGlosa">SALDO ANTERIOR</td>
																	<td class="TotalMonto">
																		<xsl:value-of select='format-number(sii:SaldoAnterior, ".##0", "clp")'/>
																	</td>
																</tr>
															</xsl:if>
															<xsl:if test="boolean(sii:VlrPagar) and (number(sii:SaldoAnterior) != 0 or (boolean(sii:MontoNF) and number(sii:MontoNF) &gt; 0))">
																<tr>
																	<td class="TotalGlosa">VALOR A PAGAR</td>
																	<td class="TotalMonto">
																		<xsl:value-of select='format-number(sii:VlrPagar, ".##0", "clp")'/>
																	</td>
																</tr>
															</xsl:if>
														</table>
													</xsl:for-each>
												</td>
											</tr>
											
											<tr>
												<td valign="top" align="left" width="50%" height="150">
													<div class="espacio" style="height: 6mm;"/>
													<xsl:choose>
														<xsl:when test="Document/Content/sii:DTE/sii:Documento/sii:TED/sii:FRMT[.='']">
															<div style="width: 9cm; height: 3.3cm; text-align: center; font-size: 3mm; border: 0.3mm solid black; font-family: Arial; font-style: italic;">
																<br/>
																<br/>
																<br/>
																<br/>DOCUMENTO SIN FIRMA Y TIMBRE</div>
														</xsl:when>
														<xsl:otherwise>
															<!-- TIMBRE START -->
															<div style="margin-left: 8mm; width: 9cm; text-align: center; font-family: Arial;">
																<object style="width: 9cm; height: 3.3cm" classid="clsid:60C81663-2604-4469-917B-5CA34A0C30B4" codebase="http://www.altanet.cl/cabs/pdf417.cab#version=1,0,0,33">
																	<param name="AspectRatio" value="2"/>
																	<param name="Columns" value="15"/>
																	<param name="ECLevel" value="5"/>
																	<param name="ModuleWidth" value="3"/>
																	<param name="Mode" value="0"/>
																	<param name="Escape" value="1"/>
																	<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:TED">
																		<param name="DataToEncode">
																			<xsl:attribute name="value">@lt;TED version=@quot;1.0@quot;@gt;@lt;DD@gt;@lt;RE@gt;<xsl:value-of select="sii:DD/sii:RE"/>@lt;/RE@gt;@lt;TD@gt;<xsl:value-of select="sii:DD/sii:TD"/>@lt;/TD@gt;@lt;F@gt;<xsl:value-of select="sii:DD/sii:F"/>@lt;/F@gt;@lt;FE@gt;<xsl:value-of select="sii:DD/sii:FE"/>@lt;/FE@gt;@lt;RR@gt;<xsl:value-of select="sii:DD/sii:RR"/>@lt;/RR@gt;@lt;RSR@gt;<xsl:value-of select="sii:DD/sii:RSR"/>@lt;/RSR@gt;@lt;MNT@gt;<xsl:value-of select="sii:DD/sii:MNT"/>@lt;/MNT@gt;@lt;IT1@gt;<xsl:value-of select="sii:DD/sii:IT1"/>@lt;/IT1@gt;@lt;CAF version=@quot;1.0@quot;@gt;@lt;DA@gt;@lt;RE@gt;<xsl:value-of select="sii:DD/sii:CAF/sii:DA/sii:RE"/>@lt;/RE@gt;@lt;RS@gt;<xsl:value-of select="sii:DD/sii:CAF/sii:DA/sii:RS"/>@lt;/RS@gt;@lt;TD@gt;<xsl:value-of select="sii:DD/sii:CAF/sii:DA/sii:TD"/>@lt;/TD@gt;@lt;RNG@gt;@lt;D@gt;<xsl:value-of select="sii:DD/sii:CAF/sii:DA/sii:RNG/sii:D"/>@lt;/D@gt;@lt;H@gt;<xsl:value-of select="sii:DD/sii:CAF/sii:DA/sii:RNG/sii:H"/>@lt;/H@gt;@lt;/RNG@gt;@lt;FA@gt;<xsl:value-of select="sii:DD/sii:CAF/sii:DA/sii:FA"/>@lt;/FA@gt;@lt;RSAPK@gt;@lt;M@gt;<xsl:value-of select="sii:DD/sii:CAF/sii:DA/sii:RSAPK/sii:M"/>@lt;/M@gt;@lt;E@gt;<xsl:value-of select="sii:DD/sii:CAF/sii:DA/sii:RSAPK/sii:E"/>@lt;/E@gt;@lt;/RSAPK@gt;@lt;IDK@gt;<xsl:value-of select="sii:DD/sii:CAF/sii:DA/sii:IDK"/>@lt;/IDK@gt;@lt;/DA@gt;@lt;FRMA algoritmo=@quot;SHA1withRSA@quot;@gt;<xsl:value-of select="sii:DD/sii:CAF/sii:FRMA"/>@lt;/FRMA@gt;@lt;/CAF@gt;@lt;TSTED@gt;<xsl:value-of select="sii:DD/sii:TSTED"/>@lt;/TSTED@gt;@lt;/DD@gt;@lt;FRMT algoritmo=@quot;SHA1withRSA@quot;@gt;<xsl:value-of select="sii:FRMT"/>@lt;/FRMT@gt;@lt;/TED@gt;</xsl:attribute>
																		</param>
																	</xsl:for-each>
																</object>
																<br/>
																<font face="arial" size="2" color="black">
																	<b>Timbre Electrónico SII</b>
																</font>
																<br/>
																<font face="arial" size="1" color="black">Res.&#160;<xsl:value-of select="Document/Content/DatosAdjuntos/NroResol"/> de <xsl:value-of select="Document/Content/DatosAdjuntos/FchResol"/> Verifique documento: <a href="http://www.sii.cl" target="_blank">www.sii.cl</a>
																</font>
															</div>
															<!-- TIMBRE END -->
														</xsl:otherwise>
													</xsl:choose>
												</td>
												
												<td align="right" valign="top">
													<table class="textoclientes" border="0" width="100%" cellspacing="0" cellpadding="0" >
														<tr>
															<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado">
																<xsl:if test="sii:IdDoc/sii:TipoDTE = '33'">
																	<td class="DetalleB" colspan="2" style="border:0px solid BLACK; height: 1%; border-left: none; border-bottom: none;" valign="top">
																		<table style="border:0.5px solid BLACK; height: 1%;" cellpadding="3" cellspacing="1" bgcolor="black" width="100%">
																			<tr style="background-color: white;">
																				<td colspan="2" style="font-size: 2mm; font-family: Arial; border-left: 1px solid black; border-right: 1px solid black; border-top: 1px solid black; border-bottom: 1px solid black; width:60%;" align="LEFT">
																					El acuse de recibo que se declara en este acto, de acuerdo a lo dispuesto en la letra b) del Art. 4°, y la letra c) del Art. 5° de la Ley 19.983, acredita que la entrega de 
																					mercaderías o servicio(s) prestado(s) ha(n) sido recibido(s) en total conformidad.
																				</td>																				
																			</tr>
																			<tr style="background-color: white">
																				<td style="font-size: 2mm; font-family: Arial; border-left: 1px solid black; border-right: 1px solid black; border-top: 1px solid black; border-bottom: 1px solid black; width:10%;" align="LEFT">RUT:</td>
																				<td style="font-size: 2mm; font-family: Arial; border-left: 0px solid black; border-right: 1px solid black; border-top: 1px solid black; border-bottom: 1px solid black; " align="LEFT">&#160;</td>
																			</tr>
																			<tr style="background-color: white;">
																				<td style="font-size: 2mm; font-family: Arial; border-left: 1px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">FIRMA:</td>
																				<td style="font-size: 2mm; font-family: Arial; border-left: 0px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">&#160;</td>
																			</tr>
																			<tr style="background-color: white;">
																				<td style="font-size: 2mm; font-family: Arial; border-left: 1px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">NOMBRE:</td>
																				<td style="font-size: 2mm; font-family: Arial; border-left: 0px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">&#160;</td>
																			</tr>
																			<tr style="background-color: white;">
																				<td style="font-size: 2mm; font-family: Arial; border-left: 1px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; "  class="DetalleN" align="LEFT">RECINTO:</td>
																				<td style="font-size: 2mm; font-family: Arial; border-left: 0px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; "  class="DetalleN" align="LEFT">&#160;</td>
																			</tr>
																			<tr style="background-color: white;">
																				<td style="font-size: 2mm; font-family: Arial; border-left: 1px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">FECHA:</td>
																				<td style="font-size: 2mm; font-family: Arial; border-left: 0px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">&#160;</td>
																			</tr>
																			<tr style="background-color: white;">
																				<td colspan="2" class="DetalleN" align="right">CEDIBLE</td>
																			</tr>
																		</table>
																	</td>
																</xsl:if>
															</xsl:for-each>
														</tr>
													</table>
												</td>
											</tr>	

										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
