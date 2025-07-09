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
  margin-left: 0.7cm;
  margin-right: 0.7cm;
  margin-top: 0.7cm;
  margin-bottom: 1.2cm;
  size: 21.6cm 27.9cm;
}

.DTEPage {
  background-image   : url("http://www.altagestion.cl/imagenes/fondo1.gif");
  background-position: center;
  background-repeat  : repeat;
  position           : relative;
  width              : 19cm;
  height             : 26cm;
}

.DTEidTable {
  border: 1mm solid red;
  width: 8cm;
  height: 4cm;
  font-family: arial;
  font-size: 0.5cm;
  font-weight: bold; 
  color: red;
  text-align: center;
}

.letraRazon {
  font-style  : normal;
  font-size   : 6mm;
  font-family : Arial, Helvetica;
  font-weight : bold;
  color       : black;
}

.letraGiro {
  font-style  : normal;
  font-size   : 3.5mm;
  font-family : Arial, Helvetica;
  color       : black;
}

.letraDireccion {
  font-style  : normal;
  font-size   : 3mm;
  font-family : Arial, Helvetica;
  color       : black;
}

.tablaFactura {
  border-style: solid;
  border-color: red;
  width	      : 100%;
}

.tablaDatos {
  border-style: solid;
  border-width: 1;
  border-color: darkblue;
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
  border-right: 1px solid rgb(49,66,132);
}

.textoReferencia {
  font-family : arial;
  font-size   : 12px;
  text-align  : left;
}

.cabeceraDetallesB {
  border-right  : 1px solid black;
  font-family   : arial;
  font-size     : 12px;  
  text-align    : center;
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
  font-size    : 12px;
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
  text-align  :left;
  vertical-align: bottom;
  color       :black;
}

.TotalMonto {
  font-family :Courier New;
  font-size   :3.5mm;
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
  color: red; 
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

					function setRowsBgcolor() {
						for(i=0;i<this.rows.length;i++) {
							if(this.rows[i].rowIndex % 2 == 0)
								this.rows[i].style.backgroundColor="#CAE7EF";
							else
								this.rows[i].style.backgroundColor="#DEEBF1";
						}
					}

]]></xsl:comment>
				</script>
			</head>
			<body style="margin: 0; text-align: center; background-color: white;">
				<table class="DTEPage" border="0">
					<tr>
						<td valign="top">
							<table border="0">
								<tr>
									<td rowspan="2" valign="top" align="left" width="50%">
										<xsl:choose>
											<xsl:when test="Document/Content/DatosAdjuntos/LogoURL[.!='']">
												<img style="border: 0; width: 5cm; height: 2cm;">
													<xsl:attribute name="src"><xsl:value-of select="Document/Content/DatosAdjuntos/LogoURL"/></xsl:attribute>
												</img>
												<br/>
											</xsl:when>
										</xsl:choose>
										<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado/sii:Emisor">
											<font class="letraRazon">
												<!-- <xsl:value-of select="sii:RznSoc"/> -->
												<xsl:value-of select="/Document/Content/DatosAdjuntos/xRazonSocial"/>
											</font>
											<br/>
											<font class="letraGiro">
												<!-- <xsl:value-of select="sii:GiroEmis"/> -->
												<xsl:value-of select="/Document/Content/DatosAdjuntos/xGiro"/>
											</font>
											<br/>
											<font class="letraDireccion">
												<xsl:value-of select="sii:DirOrigen"/>
												<br/>
												<xsl:value-of select="/Document/Content/DatosAdjuntos/xComuna"/>&#160;-&#160;<xsl:value-of select="/Document/Content/DatosAdjuntos/xCiudad"/>
												<br/>
											</font>
										</xsl:for-each>
										<font class="letraDireccion">
											<xsl:value-of select="/Document/Content/DatosAdjuntos/DatosEmpresa"/>
											<br/>
										</font>
									</td>
									<td style="width: 1%; text-align: right;">
										<table class="DTEidTable">
											<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado">
												<tr>
													<td>R.U.T.: <script>"<xsl:value-of select="sii:Emisor/sii:RUTEmisor"/>".formRut()</script>
													</td>
												</tr>
												<tr>
													<td>
														<script>"<xsl:value-of select="sii:IdDoc/sii:TipoDTE"/>".formDTEName()</script>
													</td>
												</tr>
												<tr>
													<td>N<span style="border-bottom: 0.7mm solid; font-size: 3.7mm; position: relative; bottom: 1.5mm;">o</span>&#160;<xsl:value-of select="format-number(sii:IdDoc/sii:Folio, '.##0', 'clp')"/>
													</td>
												</tr>
											</xsl:for-each>
										</table>
										<div class="espacio"/>
										<div class="oficina-sii">
											<xsl:value-of select="Document/Content/DatosAdjuntos/SIIAgencia"/>
										</div>
									</td>
								</tr>
							</table>
							<!--COMIENZO tabla datos receptor-->
							<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado">
								<table class="tablaDatos" style="width: 100%;" cellspacing="1" cellpadding="2" border="0">
									<tr style="height: 5mm;">
										<td style="width: 3.5cm;" class="cabeceraClientes">RAZON SOCIAL:</td>
										<td class="textoClientes">
											<xsl:value-of select="sii:Receptor/sii:RznSocRecep"/>
										</td>
										<td style="width: 3.5cm;" class="cabeceraClientes">FECHA DE EMISION:</td>
										<td style="width: 2.8cm; text-align: left;" class="textoClientes">
											<script>"<xsl:value-of select="sii:IdDoc/sii:FchEmis"/>".formFecha()</script>
										</td>
									</tr>
									<tr style="height: 5mm;">
										<td style="width: 3.5cm;" class="cabeceraClientes">R.U.T.:</td>
										<td class="textoClientes">
											<script>"<xsl:value-of select="sii:Receptor/sii:RUTRecep"/>".formRut()</script>
										</td>
										<td style="width: 3.5cm;" class="cabeceraClientes">FECHA DE VENCIMIENTO:</td>
										<td style="width: 2.8cm; text-align: left;" class="textoClientes">
											<script>"<xsl:value-of select="/Document/Content/DatosAdjuntos/xFechaVencimiento"/>".formFecha()</script>
										</td>
									</tr>
									<tr style="height: 5mm;">
										<td style="width: 3.5cm;" class="cabeceraClientes">DIRECCION:</td>
										<td class="textoClientes">
											<xsl:value-of select="sii:Receptor/sii:DirRecep"/>
										</td>
										<td style="width: 3.5cm;" class="cabeceraClientes">COMUNA:</td>
										<td class="textoClientes">
											<xsl:value-of select="sii:Receptor/sii:CmnaRecep"/>
										</td>
									<!--
										<td style="width: 3.5cm;" class="cabeceraClientes">MEDIO DE PAGO:</td>
										<td style="width: 2.8cm; text-align: right;" class="textoClientes">
											<script>"<xsl:value-of select="sii:IdDoc/sii:MedioPago"/>".formMedioPago()</script>
										</td>
									-->
									</tr>
									<tr style="height: 5mm;">
										<td style="width: 3.5cm;" class="cabeceraClientes">GIRO:</td>
										<td class="textoClientes">
											<xsl:value-of select="sii:Receptor/sii:GiroRecep"/>
										</td>
									<!--
										<td style="width: 3.5cm;" class="cabeceraClientes">TIPO TRASLADO:</td>
										<td style="width: 2.8cm; text-align: right;" class="textoClientes">
											<script>"<xsl:value-of select="sii:IdDoc/sii:IndTraslado"/>".formTraslado()</script>
										</td>
									-->
									</tr>
								</table>
							</xsl:for-each>
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
										<table border="0" style="width: 100%; height: 10.5cm; border-left: 1px solid rgb(49,66,132); border-bottom: 1px solid rgb(49,66,132);" cellspacing="0" cellpaddin="0" id="mitabla">
											<tr style="height: 5mm;">
												<td class="cabeceraDetallesB" style="width: 5mm; border-right: none;">&#160;</td>
												<td class="cabeceraDetallesB" style="width: 5mm; border-left: none; border-right: none;">DESCRIPCION</td>
												<td class="cabeceraDetallesB" style="width: 5mm;">&#160;</td>
												<td class="cabeceraDetallesB" style="width: 25mm;">VALOR</td>
											</tr>
											<tr style="height: 1mm;">
												<td class="DetalleB" style="width: 5mm; border-left: none; border-right: none; font-size: 1mm;">&#160;</td>
												<td class="DetalleB" style="width: 5mm; border-left: none; border-right: none; font-size: 1mm;">&#160;</td>
												<td class="DetalleB" style="font-size: 1mm;">&#160;</td>
												<td class="DetalleB" style="font-size: 1mm;">&#160;</td>
											</tr>

											<tr style="height: 5mm;">
												<td class="DetalleB" align="right" valign="top" style="border-left: none; border-right: none; ">&#160;</td>
												<td class="DetalleB" align="left" valign="top" style="border-left: none; border-right: none; ">
													<xsl:value-of select="/Document/Content/DatosAdjuntos/xDetalle"/>
												</td>
												<td class="DetalleB" align="right" valign="top">&#160;</td>
												<td class="DetalleB" align="right" valign="top">&#160;
													<xsl:value-of select='format-number(/Document/Content/DatosAdjuntos/xMontoDetalle, ".##0", "clp")'/>
												</td>
											</tr>
											
											<tr>
												<td class="DetalleB" style="width: 5mm; border-left: none; border-right: none; font-size: 1mm;">&#160;</td>
												<td class="DetalleB" style="width: 5mm; border-left: none; border-right: none; font-size: 1mm;">&#160;</td>
												<td class="DetalleB">&#160;</td>
												<td class="DetalleB">&#160;</td>
											</tr>
											<xsl:variable name="hasReferences" select="boolean(Document/Content/sii:DTE/sii:Documento/sii:Referencia)"/>
											<xsl:variable name="hasDscRcgGlobales" select="boolean(Document/Content/sii:DTE/sii:Documento/sii:DscRcgGlobal)"/>
											<xsl:if test="$hasReferences or $hasDscRcgGlobales">
												<tr>
													<td class="DetalleB" colspan="7" style="border:1px solid rgb(49,66,132); height: 1%; border-left: none; border-bottom: none;" valign="top">
														<span style="width: 49%; vertical-align: top;">
															<xsl:if test="$hasReferences">
														DOCUMENTO(S) DE REFERENCIA:<br/>
																<div class="espacio"/>
																<table cellpadding="3" cellspacing="1" bgcolor="black" width="95%">
																	<tr style="background-color: #CAE7EF;">
																		<td class="DetalleN" align="left">Tipo Doc.</td>
																		<td class="DetalleN" align="center">Fecha Emisión</td>
																		<td class="DetalleN" align="right">Folio&#160;&#160;&#160;</td>
																		<td class="DetalleN">Razon de Referencia</td>
																	</tr>
																	<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Referencia">
																		<tr style="background-color: #CAE7EF;">
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
																	<tr style="background-color: #CAE7EF;">
																		<td class="DetalleN">Glosa&#160;&#160;&#160;</td>
																		<td class="DetalleN" align="right">Valor&#160;&#160;&#160;</td>
																		<td class="DetalleN">Afecta Item(s)&#160;&#160;&#160;</td>
																	</tr>
																	<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:DscRcgGlobal">
																		<tr style="background-color: #CAE7EF;">
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
												<td align="left" width="58%" height="150">
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
																<object style="width: 9cm; height: 3.3cm" classid="clsid:60C81663-2604-4469-917B-5CA34A0C30B4" codebase="http://www.custodium.com/cabs/custodium.cab#version=1,0,0,33">
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
																<font face="arial" size="2" color="red">
																	<b>Timbre Electrónico SII</b>
																</font>
																<br/>
																<font face="arial" size="1" color="red">Res.&#160;<xsl:value-of select="Document/Content/DatosAdjuntos/NroResol"/> de <xsl:value-of select="Document/Content/DatosAdjuntos/FchResol"/> Verifique documento: <a href="http://www.sii.cl" target="_blank">www.sii.cl</a>
																</font>
															</div>
															<!-- TIMBRE END -->
														</xsl:otherwise>
													</xsl:choose>
												</td>

												<td align="right" valign="top">
													<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado/sii:Totales">
														<table class="TablaTotales" border="0" width="211.5" cellspacing="0" cellpadding="2" style="border-top: 1px solid rgb(49,66,132);">
															<xsl:if test="boolean(sii:MntNeto)">
																<tr>
																	<td class="TotalGlosa">NETO</td>
																	<td class="TotalMonto">
																		<xsl:value-of select='format-number(sii:MntNeto, ".##0", "clp")'/>
																	</td>
																</tr>
															</xsl:if>
															<xsl:if test="sii:MntExe[.!='0']">
																<tr>
																	<td class="TotalGlosa">EXENTO</td>
																	<td class="TotalMonto">
																		<xsl:value-of select='format-number(sii:MntExe, ".##0", "clp")'/>
																	</td>
																</tr>
															</xsl:if>
															<xsl:if test="sii:IVA[.!='0']">
																<tr>
																	<td class="TotalGlosa">I.V.A. <xsl:value-of select="sii:TasaIVA"/>%</td>
																	<td class="TotalMonto">
																		<xsl:value-of select='format-number(sii:IVA, ".##0", "clp")'/>
																	</td>
																</tr>
															</xsl:if>
															<xsl:if test="sii:GrntDep[.!='0']">
																<tr>
																	<td class="TotalGlosa">GAR. DEP. ENV.</td>
																	<td class="TotalMonto">
																		<xsl:value-of select='format-number(sii:GrntDep, ".##0", "clp")'/>
																	</td>
																</tr>
															</xsl:if>
															<tr>
																<td class="TotalGlosa">TOTAL</td>
																<td class="TotalMonto">
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
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>

					<xsl:for-each select="Document/Content/sii:DTE/sii:Documento/sii:Encabezado">
						<xsl:if test="sii:IdDoc/sii:TipoDTE = '33'">
							<tr>
								<td class="DetalleB" colspan="1" style="border:0px solid BLACK; height: 1%; border-left: none; border-bottom: none;" valign="top">
									<table style="border:0.5px solid BLACK; height: 1%;" cellpadding="3" cellspacing="1" bgcolor="black" width="100%">
										<tr style="background-color: white">
											<td style="border-left: 1px solid black; border-right: 1px solid black; border-top: 1px solid black; border-bottom: 1px solid black; width:10%;" class="DetalleN" align="LEFT">RUT:</td>
											<td style="border-left: 0px solid black; border-right: 1px solid black; border-top: 1px solid black; border-bottom: 1px solid black; width:60%;" class="DetalleN" align="left">&#160;</td>
											<td rowspan="6" valign="top" style="border-left: 0px solid black; border-right: 0px solid black; border-top: 0px solid black; border-bottom: 0px solid black; font-weight: bold;" class="DetalleB" align="RIGHT">CEDIBLE</td>
										</tr>
										<tr style="background-color: white;">
											<td style="border-left: 1px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">FIRMA:</td>
											<td style="border-left: 0px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">&#160;</td>
										</tr>
										<tr style="background-color: white;">
											<td style="border-left: 1px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">NOMBRE:</td>
											<td style="border-left: 0px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">&#160;</td>
										</tr>
										<tr style="background-color: white;">
											<td style="border-left: 1px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; "  class="DetalleN" align="LEFT">RECINTO:</td>
											<td style="border-left: 0px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; "  class="DetalleN" align="LEFT">&#160;</td>
										</tr>
										<tr style="background-color: white;">
											<td style="border-left: 1px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">FECHA:</td>
											<td style="border-left: 0px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">&#160;</td>
										</tr>
										<tr style="background-color: white;">
											<td colspan="2" style="border-left: 1px solid black; border-right: 1px solid black; border-top: 0px solid black; border-bottom: 1px solid black; " class="DetalleN" align="LEFT">
												El acuse de recibo que se declara en este acto, de acuerdo a lo dispuesto en la letra b) del Art. 4°, y la letra c) del Art. 5° de la Ley 19.983, acredita que la entrega de 
												mercaderías o servicio(s) prestado(s) ha(n) sido recibido(s) en total conformidad.
											</td>											
										</tr>
									</table>
								</td>
							</tr>
						</xsl:if>
					</xsl:for-each>

				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
