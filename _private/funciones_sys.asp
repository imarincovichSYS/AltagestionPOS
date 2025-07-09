<%
' function Get_Area_Bodega_Segun_Superfamilia_y_Familia(v_superfamilia, v_familia)
' function Estructura_Requiere_ILA(v_superfamilia, v_familia, v_subfamilia)
' function Get_Cod_Lista_Base()
' function Get_Nuevo_Producto(v_superfamilia,v_familia,v_subfamilia)
' function Get_CPA_Producto_Anterior_a_Fecha_en_RCP(v_producto, v_fecha)
' function GetParidad_X_Fecha(v_fecha)
' sub GetParidades_X_Fecha(v_fecha)
' function GetParidad_Para_Margen()
' function Get_Nuevo_Numero_Documento_no_Valorizado_X_Documento_Respaldo(v_documento_respaldo)
' function Get_Nuevo_Numero_Carpeta_X_Fec_Anio_y_Mes(v_documento_respaldo, v_fec_anio_mes)
' function Get_Nuevo_Codigo_EAN13()
' function Get_Precio_Normal_X_Producto(v_producto)
' function Get_Codigo_Lista_Precio_LP_BASE()
' function Get_Tasa_Impuesto_Aduanero()
' function Get_Numero_Interno_Pedido(v_anio,v_numero_pedido)
' function Get_Numero_Interno_Documento_No_Valorizado(v_documento_respaldo,v_numero_documento_respaldo,v_documento_no_valorizado,v_numero_documento_no_valorizado)
' function Get_Stock_En_Transito_X_Producto_y_Bodega(v_producto, v_bodega)
' function Get_Costo_Flete_Transporte_Dolar(v_parametro)
' function Get_Valor_Numerico_X_Parametro(v_parametro)
' function Get_Valor_Fecha_X_Parametro(v_parametro)
' function Get_Tasa_Rubro(v_rubro)
' function Get_Rut_Nuevo_Proveedor_Extranjero()
' function Get_Stock_En_Bodega(v_bodega, v_producto)
' function Get_Total_Cif_ORI_Y_ADU(v_documento_no_valorizado, v_numero_documento_no_valorizado, v_documento_respaldo, v_numero_documento_respaldo, v_numero_interno_documento_no_valorizado)
' sub Cargar_Matriz_Script_Tasas_Rubros()
' function Limpiar_TCP_en_Item_Pedido(v_documento_respaldo, v_numero_documento_respaldo, v_numero_de_linea)
' function Get_Precio_Total_From_Kit_Temporal(v_empleado_responsable)
' function Get_Producto_Final_From_Kit_Temporal(v_empleado_responsable)

' function Get_Nuevo_Codigo_EAN13_para_Producto_Numerico_Nuevo(v_producto_numerico)
' function Get_Nuevo_Producto_Numerico()

function Get_Superfamilia_X_Producto(v_producto)
  strSQL="select Superfamilia from productos where empresa='SYS' and Producto = '" & v_producto & "'"
  'Response.Write strSQL
  'Response.End       
  set v_rs = Conn.Execute(strSQL) : z_superfamilia = ""
  if not v_rs.EOF then z_superfamilia = v_rs("superfamilia")
  Get_Superfamilia_X_Producto = z_superfamilia
end function

function Get_Area_Bodega_Segun_Superfamilia_y_Familia(v_superfamilia, v_familia)
  x_area = 9
  strSQL="select area from areas_bodega where superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"'"
  set v_rs = Conn.Execute(strSQL)
  if not v_rs.EOF then 
    x_area = v_rs("area")
  else
    strSQL="select area from areas_bodega where superfamilia='"&v_superfamilia&"'"
    set v_rs = Conn.Execute(strSQL)
    if not v_rs.EOF then x_area = v_rs("area")
  end if
  Get_Area_Bodega_Segun_Superfamilia_y_Familia = x_area
end function

function Estructura_Requiere_ILA(v_superfamilia, v_familia, v_subfamilia)
  strSQL="select superfamilia from estructura_productos_ila where " &_
         "superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"' and subfamilia='"&v_subfamilia&"'"
  set v_rs = Conn.Execute(strSQL)
  if v_rs.EOF then 
    Estructura_Requiere_ILA = false
  else
    Estructura_Requiere_ILA = true
  end if
end function

function Get_Cod_Lista_Base()
  strSQL="select valor_texto from parametros where parametro='lp_base'"
  set v_rs = Conn.Execute(strSQL)
  if not v_rs.EOF then v_cod_lista_base = v_rs("valor_texto") 
  Get_Cod_Lista_Base = v_cod_lista_base
end function

function Get_Nuevo_Producto(v_superfamilia,v_familia,v_subfamilia)
  delimiter         = "~"
  'Esta función requiere llamar a _private/funciones_generales por el Lpad
  'strSQL="select (IsNull(max(right(producto,len(producto)-5)),0) + 1) codigo_nuevo from productos where " &_
  '       "superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"' and subfamilia='"&v_subfamilia&"'"
  
  'strSQL="select max(producto) codigo_nuevo from productos where " &_
  '       "superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"' and " &_
  '       "subfamilia='"&v_subfamilia&"' and substring(producto,4,2)<>'KI'"
  
  'strSQL="select A.codigo_nuevo, B.nombre from " &_
  '       "(select max(producto) codigo_nuevo from productos where " &_
  '       "superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"' and " &_
  '       "subfamilia='"&v_subfamilia&"' and substring(producto,4,2)<>'KI') A," &_
  '       "(select producto, nombre from productos where " &_
  '       "superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"' and " &_
  '       "subfamilia='"&v_subfamilia&"' and substring(producto,4,2)<>'KI') B " &_
  '       "where A.codigo_nuevo=B.producto"
  
  'strSQL="select A.ultimo_codigo, B.nombre from " &_
  '       "(select '" & v_superfamilia & v_familia & v_subfamilia &"' + " &_
  '       "right('00' + convert(varchar(20), max(convert(int, right(ltrim(rtrim(producto)),len(producto)-5)))),3) ultimo_codigo " &_
  '       "from productos where empresa='SYS' and " &_
  '       "superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"' and " &_
  '       "subfamilia='"&v_subfamilia&"' and substring(producto,4,2)<>'KI') A," &_
  '       "(select producto, nombre from productos where empresa='SYS' and " &_
  '       "superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"' and " &_
  '       "subfamilia='"&v_subfamilia&"' and substring(producto,4,2)<>'KI') B " &_
  '       "where A.ultimo_codigo=B.producto"
         
  'strSQL="select IsNull(max(convert(int, right(ltrim(rtrim(producto)),len(producto)-5))),0) ultimo_codigo " &_
  '       "from productos where empresa='SYS' and " &_
  '       "superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"' and " &_
  '       "subfamilia='"&v_subfamilia&"' and substring(producto,4,2)<>'KI'"
   
  'largo_caracteres_estructura = len(v_superfamilia) + len(v_familia) + len(v_subfamilia)
  strSQL="select IsNull(max(convert(int, right(ltrim(rtrim(producto)),len(producto)-5))),0) ultimo_codigo " &_
         "from productos where empresa='SYS' and " &_
         "superfamilia='" & v_superfamilia & "' and familia='" & v_familia & "' and " &_
         "subfamilia='" & v_subfamilia & "'"       
  'Response.Write strSQL
  'Response.End       
  set v_rs = Conn.Execute(strSQL) : cod_nuevo = "001" : v_nombre = ""
  if not v_rs.EOF then 
    num_ultimo  = cdbl(v_rs("ultimo_codigo"))
    cod_ultimo  = Lpad(num_ultimo,3,0)
    num_nuevo   = num_ultimo + 1
    cod_nuevo   = Lpad(num_nuevo,3,0)
    v_nombre    = Get_Nombre_Producto(v_superfamilia & v_familia & v_subfamilia & cod_ultimo)
  end if
  Get_Nuevo_Producto = v_superfamilia & v_familia & v_subfamilia & cod_nuevo & delimiter & v_nombre
end function

function Get_Nombre_Producto(v_producto)
  'strSQL= "select nombre from productos where empresa='SYS' and producto='"&v_producto&"'"
  strSQL= "select nombre from productos where producto='"&v_producto&"'"
  'Response.Write strSQL
  'Response.End       
  set v_rs = Conn.Execute(strSQL) : v_nombre = ""
  if not v_rs.EOF then v_nombre  = trim(v_rs("nombre"))
  Get_Nombre_Producto = v_nombre
end function

function Get_CPA_Producto_Anterior_a_Fecha_en_RCP(v_producto, v_fecha)
  r_fecha = year(cdate(v_fecha)) & "/" & month(cdate(v_fecha)) & "/" & day(cdate(v_fecha))
  strSQL="select top 1 fecha_movimiento, costo_cpa_us$ from movimientos_productos where empresa='SYS' and " &_
         "documento_no_valorizado='RCP' and producto='"&producto&"' and fecha_movimiento < '"&r_fecha&"' order by fecha_movimiento desc"
  'Response.Write strSQL
  'Response.End
  set v_rs = Conn.Execute(strSQL) : valor = 0
  if not v_rs.EOF then valor = v_rs("costo_cpa_us$")
  Get_CPA_Producto_Anterior_a_Fecha_en_RCP = valor
end function

function GetParidad_X_Fecha(v_fecha)
  r_fecha = year(cdate(v_fecha)) & "/" & month(cdate(v_fecha)) & "/" & day(cdate(v_fecha))
  strSQL="select IsNull(paridad_para_facturacion,0) valor from paridades " &_
         "where moneda='US$' and fecha_valor='"&r_fecha&"' and empresa='SYS'"
  set v_rs = Conn.Execute(strSQL) : valor = 0
  if not v_rs.EOF then valor = v_rs("valor")
  GetParidad_X_Fecha = FormatNumber(valor,2)
end function

sub GetParidades_X_Fecha(v_fecha)
  r_fecha = year(cdate(v_fecha)) & "/" & month(cdate(v_fecha)) & "/" & day(cdate(v_fecha))
  strSQL="select IsNull(paridad_para_facturacion,0) valor1 from paridades " &_
         "where moneda='US$' and fecha_valor='"&r_fecha&"' and empresa='SYS'"
  set v_rs = Conn.Execute(strSQL) : valor1 = 0
  if not v_rs.EOF then valor1 = v_rs("valor1")
  
  strSQL="select top 1 Paridad_para_calculo_de_margenes from paridades " &_
         "where moneda='US$' and empresa='SYS' order by fecha_valor desc"
  set v_rs = Conn.Execute(strSQL) : valor2 = 0
  if not v_rs.EOF then valor2 = v_rs("valor2")
  PARIDAD_FACTURACION = valor1
  PARIDAD_MARGEN      = valor2
end sub

function GetParidad_Para_Margen()
  strSQL="select top 1 Paridad_para_calculo_de_margenes from paridades " &_
         "where moneda='US$' and empresa='SYS' order by fecha_valor desc"
  set v_rs = Conn.Execute(strSQL) : valor = 0
  if not v_rs.EOF then valor = v_rs("Paridad_para_calculo_de_margenes")
  GetParidad_Para_Margen = FormatNumber(valor,2)
end function

function Get_Nuevo_Numero_Documento_no_Valorizado_X_Documento_Respaldo(v_documento_respaldo)
  strSQL="update documentos set folio_documento = folio_documento + 1 where documento='"&v_documento_respaldo&"'"
  set v_rs = Conn.Execute(strSQL)
  strSQL="select max(folio_documento) nuevo from documentos where documento='"&v_documento_respaldo&"'"
  set v_rs = Conn.Execute(strSQL) : v_nuevo = 1
  if not v_rs.EOF then v_nuevo = v_rs("nuevo")
  Get_Nuevo_Numero_Documento_no_Valorizado_X_Documento_Respaldo = v_nuevo
end function

function Get_Nuevo_Numero_Carpeta_X_Fec_Anio_y_Mes(v_documento_respaldo, v_fec_anio_mes)
  strSQL="select IsNull((max(num_carpeta) + 1),1) nuevo from carpetas_final " &_
         "where documento_respaldo='"&v_documento_respaldo&"' and anio_mes='"&v_fec_anio_mes&"'"
  set v_rs = Conn.Execute(strSQL) : v_nuevo = 1
  if not v_rs.EOF then v_nuevo = v_rs("nuevo")
  Get_Nuevo_Numero_Carpeta_X_Fec_Anio_y_Mes = v_nuevo
end function

function Get_Numero_Aleatorio(v_minimo,v_maximo)
  Randomize
  Get_Numero_Aleatorio = Int(((v_maximo - v_minimo+1) * Rnd) + v_minimo)
end function

function Get_Nuevo_Codigo_EAN13()
  cod_ini_CL = "25"
  'cod_ini = 1
  minimo  = 1
  maximo  = 9999999999
  do while true
    cod_ini = Get_Numero_Aleatorio(minimo,maximo)
    x_cod_EAN13_12  = cod_ini_CL & Lpad(cod_ini,10,0)
    x_cod_EAN13_13  = x_cod_EAN13_12 & Calcular_Digito_Verificador_EAN13(x_cod_EAN13_12)
    band_codEAN13_codAltPro = false : band_codEAN13_productos = false
    strSQL="select codigo_alternativo_producto from Codigos_alternativos_de_productos " &_
           "where codigo_alternativo_producto='" & x_cod_EAN13_13 & "'"
    set v_rs = Conn.Execute(strSQL)
    if v_rs.EOF then band_codEAN13_codAltPro = true
    strSQL="select codigo_ean13 from productos where empresa='SYS' and codigo_ean13='" & x_cod_EAN13_13 & "'"
    set v_rs = Conn.Execute(strSQL)
    if v_rs.EOF then band_codEAN13_productos = true
    if band_codEAN13_codAltPro and band_codEAN13_productos then exit do
  loop
  Get_Nuevo_Codigo_EAN13 = x_cod_EAN13_13
end function

function Get_Nuevo_Codigo_EAN13_BK20110620()
  cod_ini_CL = "21"
  cod_ini = 1
  do while true
    x_cod_EAN13_12  = cod_ini_CL & Lpad(cod_ini,10,0)
    x_cod_EAN13_13  = x_cod_EAN13_12 & Calcular_Digito_Verificador_EAN13(x_cod_EAN13_12)
    
    band_codEAN13_codAltPro = false
    band_codEAN13_productos = false
    
    strSQL="select codigo_alternativo_producto from Codigos_alternativos_de_productos " &_
           "where codigo_alternativo_producto='" & x_cod_EAN13_13 & "'"
    set v_rs = Conn.Execute(strSQL)
    if v_rs.EOF then band_codEAN13_codAltPro = true
    
    strSQL="select codigo_ean13 from productos where empresa='SYS' and codigo_ean13='" & x_cod_EAN13_13 & "'"
    set v_rs = Conn.Execute(strSQL)
    if v_rs.EOF then band_codEAN13_productos = true
    
    if band_codEAN13_codAltPro and band_codEAN13_productos then exit do
    cod_ini = cod_ini + 1
  loop
  Get_Nuevo_Codigo_EAN13 = x_cod_EAN13_13
end function

function Get_Nuevo_Codigo_EAN13_BK20110526()
  cod_ini_CL = "21"
  cod_ini = 1
  do while true
    x_cod_EAN13_12  = cod_ini_CL & Lpad(cod_ini,10,0)
    x_cod_EAN13_13  = x_cod_EAN13_12 & Calcular_Digito_Verificador_EAN13(x_cod_EAN13_12)
    'strSQL="select codigo_ean13 from productos where empresa='SYS' and codigo_ean13='"&Lpad(cod_ini,12,0)&"'"
    'strSQL="select codigo_alternativo_producto from Codigos_alternativos_de_productos where codigo_alternativo_producto='"&Lpad(cod_ini,12,0)&"'"
    strSQL="select codigo_alternativo_producto from Codigos_alternativos_de_productos " &_
           "where codigo_alternativo_producto='" & x_cod_EAN13_13 & "'"
    set v_rs = Conn.Execute(strSQL)
    if v_rs.EOF then exit do
    cod_ini = cod_ini + 1
  loop
  Get_Nuevo_Codigo_EAN13 = x_cod_EAN13_13
end function

function Calcular_Digito_Verificador_EAN13(v_cod_ean13_12)
  Val1 = 1 
  Val2 = 3 
  
  uno     = cdbl(Mid(v_cod_ean13_12, 1, 1))   * Val1 
  dos     = cdbl(Mid(v_cod_ean13_12, 2, 1))   * Val2 
  tres    = cdbl(Mid(v_cod_ean13_12, 3, 1))   * Val1 
  cuatro  = cdbl(Mid(v_cod_ean13_12, 4, 1))   * Val2 
  cinco   = cdbl(Mid(v_cod_ean13_12, 5, 1))   * Val1 
  seis    = cdbl(Mid(v_cod_ean13_12, 6, 1))   * Val2 
  siete   = cdbl(Mid(v_cod_ean13_12, 7, 1))   * Val1 
  ocho    = cdbl(Mid(v_cod_ean13_12, 8, 1))   * Val2 
  nueve   = cdbl(Mid(v_cod_ean13_12, 9, 1))   * Val1 
  diez    = cdbl(Mid(v_cod_ean13_12, 10, 1))  * Val2 
  once    = cdbl(Mid(v_cod_ean13_12, 11, 1))  * Val1 
  doce    = cdbl(Mid(v_cod_ean13_12, 12, 1))  * Val2
  
  v_suma1   = uno + dos + tres + cuatro + cinco + seis + siete + ocho + nueve + diez + once + doce
  v_suma2   = v_suma1 - v_suma1 mod 10 + 10
  'Response.Write "v_suma1: "&v_suma1&", v_suma2: "&v_suma2&" <br>"
  v_dif_ver = v_suma2 - v_suma1
  if (v_suma1 + v_suma2) > 9 then v_dif_ver = right(trim(v_suma1 - v_suma2),1)
  Calcular_Digito_Verificador_EAN13 = v_dif_ver
end function

function Get_Precio_Normal_X_Producto(v_producto)
	'strSQL="select B.valor_unitario resultado from " &_
	'       "(select valor_texto from parametros where parametro='lp_base') A," &_
	'       "(select lista_de_precios, valor_unitario from productos_en_listas_de_precios " &_
	'       "where empresa='SYS' and producto='"&v_producto&"' and limite_precio=0) B " &_
	'       "where A.valor_texto=B.lista_de_precios"
	strSQL="select valor_unitario resultado from productos_en_listas_de_precios where empresa='SYS' and " &_
         "producto='"&v_producto&"' and limite_precio=0 and lista_de_precios='L01'"
	set v_rs = Conn.Execute(strSQL) : resultado = 0
	if not v_rs.EOF then resultado = v_rs("resultado")
	Get_Precio_Normal_X_Producto = resultado
end function

function Get_Codigo_Lista_Precio_LP_BASE()
  strSQL="select valor_texto from parametros where parametro='lp_base'"
  set v_rs = Conn.Execute(strSQL) : v_codigo = 0
	if not v_rs.EOF then v_codigo = v_rs("valor_texto")
	Get_Codigo_Lista_Precio_LP_BASE = v_codigo
end function

function Get_Tasa_Impuesto_Aduanero()
  strSQL="Select IsNull(Valor_numerico,0) valor From Parametros where Parametro = 'TASAIMPADU'"
  set v_rs = Conn.Execute(strSQL) : v_tasa = 0
	if not v_rs.EOF then v_tasa = v_rs("valor")
	Get_Tasa_Impuesto_Aduanero = v_tasa
end function 

function Get_Numero_Interno_Pedido(v_anio,v_numero_pedido)
  strSQL="select numero_interno_pedido numero from pedidos " &_
         "where anio="&v_anio&" and numero_pedido="&v_numero_pedido
  set v_rs = Conn.Execute(strSQL) : v_numero = 0
	if not v_rs.EOF then v_numero = v_rs("numero")
	Get_Numero_Interno_Pedido = v_numero
end function 

function Get_Numero_Interno_Documento_No_Valorizado(v_documento_respaldo,v_numero_documento_respaldo,v_documento_no_valorizado,v_numero_documento_no_valorizado)
  strSQL="select numero_interno_documento_no_valorizado numero from documentos_no_valorizados where empresa='SYS' and " &_
         "documento_respaldo='"&v_documento_respaldo&"' and numero_documento_respaldo="&v_numero_documento_respaldo&" and " &_
         "documento_no_valorizado='"&v_documento_no_valorizado&"' and numero_documento_no_valorizado="&v_numero_documento_no_valorizado
  set v_rs = Conn.Execute(strSQL) : v_numero = 0
	if not v_rs.EOF then v_numero = v_rs("numero")
	Get_Numero_Interno_Documento_No_Valorizado = v_numero
end function 

function Get_Stock_En_Transito_X_Producto_y_Bodega(v_producto, v_bodega)
  strSQL="select Sum(A.cantidad_entrada) valor from " &_
         "(select numero_documento_no_valorizado, Tipo_documento_de_compra, numero_documento_de_compra, " &_
         "numero_interno_documento_no_valorizado, cantidad_entrada from movimientos_productos " &_
         "where empresa='SYS' and documento_no_valorizado='TCP' and " &_
         "producto='"&v_producto&"' and bodega='"&v_bodega&"') A, " &_
         "(select numero_documento_no_valorizado, documento_respaldo, numero_documento_respaldo, " &_
         "numero_interno_documento_no_valorizado from documentos_no_valorizados " &_
         "where empresa='SYS' and documento_no_valorizado='TCP') B " &_
         "where A.numero_documento_no_valorizado=B.numero_documento_no_valorizado and " &_
         "A.Tipo_documento_de_compra=B.documento_respaldo and " &_
         "A.numero_documento_de_compra=B.numero_documento_respaldo and " &_
         "A.numero_interno_documento_no_valorizado=B.numero_interno_documento_no_valorizado"
  set v_rs = Conn.Execute(strSQL) : valor = 0
  if not v_rs.EOF then valor = v_rs("valor")
  Get_Stock_En_Transito_X_Producto_y_Bodega = valor
end function

function Get_Costo_Flete_Transporte_Dolar(v_parametro)
  strSQL="select valor_numerico from parametros where parametro='"&v_parametro&"'"
  set v_rs = Conn.Execute(strsql) : v_valor=1
  if not v_rs.EOF then v_valor = v_rs("valor_numerico")
  Get_Costo_Flete_Transporte_Dolar = v_valor
end function

function Get_Valor_Numerico_X_Parametro(v_parametro)
  strSQL="select valor_numerico from parametros where parametro='"&v_parametro&"'"
  set v_rs = Conn.Execute(strsql) : v_valor=""
  if not v_rs.EOF then v_valor = v_rs("valor_numerico")
  Get_Valor_Numerico_X_Parametro = v_valor
end function

function Get_Valor_Fecha_X_Parametro(v_parametro)
  strSQL="select valor_fecha from parametros where parametro='"&v_parametro&"'"
  set v_rs = Conn.Execute(strsql) : v_fecha=""
  if not v_rs.EOF then v_fecha = v_rs("valor_fecha")
  Get_Valor_Fecha_X_Parametro = v_fecha
end function

function Get_Tasa_Rubro(v_rubro)
  if v_rubro = "O" then
    x_parametro = "TASARUBRO_O"
  end if
  strSQL="select valor_numerico from parametros where parametro='"&x_parametro&"'"
  set v_rs = Conn.Execute(strsql) : v_valor=1
  if not v_rs.EOF then v_valor = v_rs("valor_numerico")
  Get_Tasa_Rubro = v_valor
end function

function Get_Rut_Nuevo_Proveedor_Extranjero()
  strSQL="select max(right(rtrim(ltrim(entidad_comercial)),5)) valor from entidades_comerciales " &_
         "where empresa='SYS' and Tipo_entidad_comercial='P' and codigo_postal is not null and " &_
         "rtrim(ltrim(codigo_postal))<>'' and pais<>'cl' and substring(entidad_comercial,1,3) = '000' and " &_
         "len(entidad_comercial)=8"
  set v_rs = Conn.Execute(strsql) : v_valor="00000000"
  if not v_rs.EOF then v_valor = "000" & cdbl(v_rs("valor")) + 1
  Get_Rut_Nuevo_Proveedor_Extranjero = v_valor
end function

function Get_Stock_En_Bodega(v_bodega, v_producto)
  strSQL="select stock_real valor from productos_en_bodegas where empresa='SYS' and " &_
         "bodega='"&v_bodega&"' and producto='"&v_producto&"'"
  set v_rs = Conn.Execute(strsql) : v_valor="0"
  if not v_rs.EOF then v_valor = v_rs("valor")
  Get_Stock_En_Bodega = v_valor
end function

function Get_Total_Cif_ORI_Y_ADU(v_documento_no_valorizado, v_numero_documento_no_valorizado, v_documento_respaldo, v_numero_documento_respaldo, v_numero_interno_documento_no_valorizado)
  delimiter         = "~"
  strSQL="select IsNull(sum(Round(costo_cif_ori_us$*cantidad_entrada,2)),0) total_cif_ori, " &_
         "IsNull(sum(Round(costo_cif_adu_us$*cantidad_entrada,2)),0) total_cif_adu from " &_
         "movimientos_productos where empresa='SYS' and " &_
         "documento_no_valorizado='"&v_documento_no_valorizado&"' and " &_
         "numero_documento_no_valorizado="&v_numero_documento_no_valorizado&" and " &_
         "Tipo_documento_de_compra='"&v_documento_respaldo&"' and " &_
         "numero_documento_de_compra="&v_numero_documento_respaldo&" and " &_
         "numero_interno_documento_no_valorizado="&v_numero_interno_documento_no_valorizado
  set v_rs = Conn.Execute(strsql) : v_total_cif_ori=0 : v_total_cif_adu = 0
  if not v_rs.EOF then 
    v_total_cif_ori = v_rs("total_cif_ori")
    v_total_cif_adu = v_rs("total_cif_adu")
  end if
  Get_Total_Cif_ORI_Y_ADU = v_total_cif_ori & delimiter & v_total_cif_adu
end function

function Get_Total_Cif_ORI_ADU_EXFAB_FOB(v_documento_no_valorizado, v_numero_documento_no_valorizado, v_documento_respaldo, v_numero_documento_respaldo, v_numero_interno_documento_no_valorizado)
  delimiter         = "~"
  strSQL="select " &_
         "IsNull(sum(Round(costo_cif_ori_us$            * cantidad_entrada,2)),0) total_cif_ori, " &_
         "IsNull(sum(Round(costo_cif_adu_us$            * cantidad_entrada,2)),0) total_cif_adu, " &_
         "IsNull(sum(Round(costo_ex_fab_moneda_origen   * cantidad_origen,2)),0) total_ex_fab, " &_
         "IsNull(sum(Round(costo_fob_us$                * cantidad_origen,2)),0) total_fob " &_
         "from " &_
         "movimientos_productos where empresa='SYS' and " &_
         "documento_no_valorizado                 = '" & v_documento_no_valorizado & "' and " &_
         "numero_documento_no_valorizado          = " & v_numero_documento_no_valorizado & " and " &_
         "Tipo_documento_de_compra                = '" & v_documento_respaldo & "' and " &_
         "numero_documento_de_compra              = " & v_numero_documento_respaldo & " and " &_
         "numero_interno_documento_no_valorizado  = " & v_numero_interno_documento_no_valorizado
  set v_rs = Conn.Execute(strsql) : v_total_cif_ori=0 : v_total_cif_adu = 0 : v_total_ex_fab = 0 : v_total_fob = 0
  if not v_rs.EOF then 
    v_total_cif_ori = v_rs("total_cif_ori")
    v_total_cif_adu = v_rs("total_cif_adu")
    v_total_ex_fab  = v_rs("total_ex_fab")
    v_total_fob     = v_rs("total_fob")
  end if
  Get_Total_Cif_ORI_ADU_EXFAB_FOB = v_total_cif_ori & delimiter & v_total_cif_adu & delimiter & v_total_ex_fab & delimiter & v_total_fob
end function

sub Cargar_Matriz_Script_Tasas_Rubros()
  strSQL="select rubro, tasa from tasas_rubros order by rubro"
  set v_rs = Conn.Execute(strSQL)
  %>
  <script language="JavaScript">
  function genera_obj_tasa_rubro(v_rubro, v_tasa) {
    this.rubro  = v_rubro;
    this.tasa   = v_tasa;    
  }

  function Agregar_Tasa_Rubro(v_tasasRubros, v_rubro, v_tasa){
    v_tasasRubros.push(new genera_obj_tasa_rubro(v_rubro, v_tasa))
  }
  
  var tasasRubros = new Array();
  <%
  do while not v_rs.EOF
    v_rubro = v_rs("rubro")
    v_tasa  = v_rs("tasa")
    %>
    Agregar_Tasa_Rubro(tasasRubros, "<%=v_rubro%>", "<%=v_tasa%>")
    <%
    v_rs.MoveNext
  loop
  %>
  //alert(tasasRubros.length)
  //alert("Rubro: "+tasasRubros[0].rubro+", Tasa: "+tasasRubros[0].tasa)
  </script>
  <%
end sub

function Limpiar_TCP_en_Item_Pedido(v_documento_respaldo, v_numero_documento_respaldo, v_numero_de_linea)

  'Tipo_documento_de_compra='"&trim(rs_itemes("documento_respaldo_2"))&"' and " &_
  '         "numero_documento_de_compra="&rs_itemes("numero_documento_respaldo_2")&" and " &_
  '         "Numero_de_linea_en_RCP_o_documento_de_compra="&rs_itemes("numero_de_linea_2")
  '         
  strSQL="update movimientos_pedidos set año_"&v_num_TCP&"=null, documento_respaldo_"&v_num_TCP&"=null, " &_
         "numero_documento_respaldo_"&v_num_TCP&"=null, numero_de_linea_"&v_num_TCP&"=null, " &_
         "cantidad_entrada_"&v_num_TCP&"=null where " &_
         "numero_interno_pedido="&v_numero_interno_pedido&" and " &_
         "numero_pedido="&v_numero_pedido&" and " &_
         "Numero_de_linea="&v_num_linea
  'Response.Write strSql & "<br><br>"
  set rs_update = Conn.Execute(strSql)
end function

function Get_Precio_Total_From_Kit_Temporal(v_empleado_responsable)
  strSQL="select IsNull(sum(precio_unitario * cantidad),0) total from composicion_tmp where empleado_responsable = '"&v_empleado_responsable&"'"
  set v_rs = Conn.Execute(strSQL) : v_total = 0
  if not v_rs.EOF then v_total = v_rs("total")
  Get_Precio_Total_From_Kit_Temporal = v_total
end function

function Get_Producto_Final_From_Kit_Temporal(v_empleado_responsable)
  delimiter = "~"
  set v_rs = server.CreateObject("ADODB.RECORDSET")
  strSQL="select top 1 producto_insumo from composicion_tmp where " &_
         "empleado_responsable = '"&v_empleado_responsable&"' and producto_insumo is not null " &_
         "order by precio_unitario desc, producto_insumo"
  'Response.Write strSQL
  'Response.End
  set v_rs = Conn.Execute(strSQL) : nuevo_codigo = ""
  if not v_rs.EOF then
    letras              = Left(trim(v_rs("producto_insumo")),5)
    superfamilia        = Left(letras,1)
    familia             = Mid(letras,2,2)
    subfamilia          = "KI"
    array_nuevo_codigo  = split(Get_Nuevo_Producto(superfamilia,familia,subfamilia),delimiter)
    nuevo_codigo        = array_nuevo_codigo(0)
  end if
  Get_Producto_Final_From_Kit_Temporal = nuevo_codigo
end function

function Get_Nuevo_Codigo_EAN13_para_Producto_Numerico_Nuevo(v_producto_numerico)
  '================================================================================================
  '========================== Nueva estructura código de barra EAN13 ==============================
  '================================================================================================
  ' ______________________________________________________________________________________________
  '| Cod INI CL (2) | Cod tmp (1) | Cod prod Numerico (6) | Cod color y talla (3) | Dig Verif (1) |
  '|________________|_____________|_______________________|_______________________|_______________|
  '|      26        |      0      |         150000        |         000           |        1      |
  '|________________|_____________|_______________________|_______________________|_______________|
  '================================================================================================
  cod_ini_CL        = "26"
  cod_tmp           = "0"
  cod_prod_numerico = v_producto_numerico
  cod_color_talla   = "000"
  
  x_cod_EAN13_12    = cod_ini_CL & cod_tmp & cod_prod_numerico & cod_color_talla
  x_cod_EAN13_13    = x_cod_EAN13_12 & Calcular_Digito_Verificador_EAN13(x_cod_EAN13_12)
  
  Get_Nuevo_Codigo_EAN13_para_Producto_Numerico_Nuevo = x_cod_EAN13_13
end function


function Get_Nuevo_Codigo_EAN13_para_Producto_AlfaNumerico_Nuevo(v_producto_numerico)
  '================================================================================================
  '========================== Nueva estructura código de barra EAN13 ==============================
  '================================================================================================
  ' ______________________________________________________________________________________________
  '| Cod INI CL (2) | Cod tmp (1) | Cod prod Numerico (6) | Cod color y talla (3) | Dig Verif (1) |
  '|________________|_____________|_______________________|_______________________|_______________|
  '|      26        |      0      |         150000        |       0+  ascii       |        1      |
  '|________________|_____________|_______________________|_______________________|_______________|
  '================================================================================================
  cod_ini_CL        = "26"
  cod_tmp           = "0"
  cod_prod_numerico = v_producto_numerico
  'cod_color_talla   = "0"
  
  x_cod_EAN13_12    = cod_ini_CL & cod_tmp & cod_prod_numerico 
  x_cod_EAN13_13    = x_cod_EAN13_12 & Calcular_Digito_Verificador_EAN13(x_cod_EAN13_12)
  
  Get_Nuevo_Codigo_EAN13_para_Producto_AlfaNumerico_Nuevo = x_cod_EAN13_13
end function



function Get_Nuevo_Producto_Numerico()
  correlativo_numerico_inicial = "150000"
  strSQL="select max(producto) as producto_numerico from productos (nolock) where substring(producto,2,1) not LIKE '[A-Z]' and substring(producto,7,1) not LIKE '[A-Z]' and empresa = 'SYS' "
  'Response.Write strSQL
  'Response.End       
  set v_rs = Conn.Execute(strSQL) : z_nuevo_producto_numerico = correlativo_numerico_inicial
  if not v_rs.EOF then 
    if cdbl(v_rs("producto_numerico")) > 0 then z_nuevo_producto_numerico = cdbl(v_rs("producto_numerico")) + 1
  end if
  Get_Nuevo_Producto_Numerico = z_nuevo_producto_numerico
end function


function Get_Nuevo_Producto_AlfaNumerico(producto)
  strSQL="select isnull(max('"&producto& "'+ CHAR(ASCII(substring(producto,LEN(producto),1))+1)),'"&producto&"'+'A') Producto_Abrir from productos (nolock) where Producto like '"&producto&"' + '[A-Z]'" 
  set v_rs = Conn.Execute(strSQL) 
  if not v_rs.EOF then 
    z_nuevo_producto_numerico = v_rs("Producto_Abrir")
    Get_Nuevo_Producto_AlfaNumerico = z_nuevo_producto_numerico  
  end if
end function


' -------------------- Estas son funciones clonadas y modificadas, se le agrego la palabra _KIT( ------------------------------------
'
function Get_Producto_Final_From_Kit_Temporal_KIT(v_empleado_responsable)
  delimiter = "~"
  set v_rs = server.CreateObject("ADODB.RECORDSET")
  'strSQL="select top 1 producto_insumo from composicion_tmp where " &_
  '       "empleado_responsable = '"&v_empleado_responsable&"' and producto_insumo is not null " &_
  '       "order by precio_unitario desc, producto_insumo"
  strSQL = "select top 1 c.producto_insumo, P.Superfamilia "
  strSQL = strSQL & "from composicion_tmp c (nolock), Productos P (nolock) "
  strSQL = strSQL & "where c.empleado_responsable = '" & v_empleado_responsable & "' and c.producto_insumo is not null "
  strSQL = strSQL & "and C.producto_insumo = P.Producto "
  strSQL = strSQL & "order by c.precio_unitario desc, c.producto_insumo "
  'Response.Write strSQL
  'Response.End
  set v_rs = Conn.Execute(strSQL) : nuevo_codigo = ""
  if not v_rs.EOF then
    'letras              = Left(trim(v_rs("producto_insumo")),5)
    'superfamilia        = Left(letras,1)
    'familia             = Mid(letras,2,2)
    'subfamilia          = "KI"
    'array_nuevo_codigo  = split(Get_Nuevo_Producto(superfamilia,familia,subfamilia),delimiter)
    'nuevo_codigo        = array_nuevo_codigo(0)

    letras = "KIT"
    superfamilia = v_rs( "Superfamilia" )
    familia = "KI"
    subfamilia = "KIT"
    array_nuevo_codigo  = split(Get_Nuevo_Producto_KIT(superfamilia,familia,subfamilia),delimiter)
    nuevo_codigo        = array_nuevo_codigo(0)
  end if
  Get_Producto_Final_From_Kit_Temporal_KIT = nuevo_codigo
end function

function Get_Nuevo_Producto_KIT(v_superfamilia,v_familia,v_subfamilia)
  delimiter         = "~"
  'strSQL="select IsNull(max(convert(int, right(ltrim(rtrim(producto)),len(producto)-5))),0) ultimo_codigo " &_
  '       "from productos where empresa='SYS' and " &_
  '       "superfamilia='"&v_superfamilia&"' and familia='"&v_familia&"' and " &_
  '       "subfamilia='"&v_subfamilia&"'"       
  strSQL = "SELECT Ultimo_codigo = Producto FROM Productos (nolock) WHERE Producto like '" & v_subfamilia & v_superfamilia & "%' ORDER BY Producto DESC "
  'Response.Write strSQL
  'Response.End       
  set v_rs = Conn.Execute(strSQL) : cod_nuevo = "001" : v_nombre = ""
  if not v_rs.EOF then 
    num_ultimo  = cdbl( mid( v_rs("ultimo_codigo"),  6, 10 ) )
    cod_ultimo  = Lpad(num_ultimo,4,0)
    num_nuevo   = num_ultimo + 1
    cod_nuevo   = Lpad(num_nuevo,4,0)
    v_nombre    = Get_Nombre_Producto_KIT(v_subfamilia & v_superfamilia & cod_ultimo)
  else
    num_ultimo  =  0
    cod_ultimo  = Lpad(num_ultimo,4,0)
    num_nuevo   = num_ultimo + 1
    cod_nuevo   = Lpad(num_nuevo,4,0)
    v_nombre    = Get_Nombre_Producto_KIT(v_subfamilia & v_superfamilia & cod_ultimo)
  end if
  'Get_Nuevo_Producto = v_superfamilia & v_familia & v_subfamilia & cod_nuevo & delimiter & v_nombre
  Get_Nuevo_Producto_KIT = v_subfamilia & v_superfamilia & cod_nuevo & delimiter & v_nombre
end function

function Get_Nombre_Producto_KIT(v_producto)
  'strSQL= "select nombre from productos where empresa='SYS' and producto='"&v_producto&"'"
  strSQL= "select nombre from productos where producto='"&v_producto&"'"
  'Response.Write strSQL
  'Response.End       
  set v_rs = Conn.Execute(strSQL) : v_nombre = ""
  if not v_rs.EOF then v_nombre  = trim(v_rs("nombre"))
  Get_Nombre_Producto_KIT = v_nombre
end function
%>
