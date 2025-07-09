<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../_private/funciones_sys.asp" -->
<%
Cache

    LOCAL_ADDR = Request.ServerVariables( "LOCAL_ADDR" )
    SERVER_NAME = Request.ServerVariables( "SERVER_NAME" )

	' 111 - ws02
	URLProductos = "http://cajas.sanchez.local/Altagestion/Imagenes/Productos/"
	IF  LOCAL_ADDR = "192.168.0.112" or SERVER_NAME = "cajas" THEN
		URLProductos = "http://cajas.sanchez.local/Altagestion/Imagenes/Productos/"
	END IF
	
	
	'IF Session("Login") = "10948121" THEN
	'	Response.Write( LOCAL_ADDR & "<BR>" )
	'	Response.Write( SERVER_NAME & "<BR>" )
	'	Response.Write( URLProductos & "<BR>" )
	'END IF

if len(trim( Session( "DataConn_ConnectionString") )) = 0 then%>
<script language=javascript>
		parent.top.location.href = "../../index.htm"
	</script>
<%end if

Set Conn = Server.CreateObject("ADODB.Connection")
Conn.Open Session( "DataConn_ConnectionString" )
Conn.CommandTimeout = 270

Set Conn1 = Server.CreateObject("ADODB.Connection")
Conn1.Open Session( "DataConn_ConnectionString" )
Conn1.CommandTimeout = 270

IF LEN(URLProductos) = 0 THEN
Imagen_actual = "../../imagenes/productos/noimagen.gif"
session("ruta_imagen") = "../../imagenes/productos/noimagen.gif"
ELSE
Imagen_actual = URLProductos & "noimagen.gif"
session("ruta_imagen") = URLProductos & "noimagen.gif"
END IF
Trae_imagen = true
MensajeError = ""
Nombre = ""
Precio = ""

session("Imprimiendo_boleta") = "No"

SessionLogin = Session("Login")
SessionTipo_documento_venta = Session("Tipo_documento_venta")
SessionCliente_boleta = Session("Cliente_boleta")
		
On Error Resume Next

'almacenar string impresora
strSQL="insert into msg_impresora(login,ip,msg) values ('"&SessionLogin&"','"&session("IP")&"','"&request("msg")&"')"
'Response.Write strSQL
'Response.End
'Conn.Execute(strSQL)

Function StrZero(Numero,Posiciones)
   StrZero = Right( "0000000000000000000000000000" & Numero , Posiciones)
End Function

Function CajaConBordes(nTop,nLeft,nWidth,nHeight)
  CajaConBordes = "<div style='position:absolute; top:" & (nTop - 10) & "px; left:" & (nLeft -10) & "px; width:" & (nWidth + 20) & "px; height:" & (nHeight + 20) & "px; z-index:0' style='border: 2px #808080 solid'></div>" & chr(13) & chr(10) & _
         "<div style='position:absolute; top:" & (nTop - 2) & "px; left:" & (nLeft - 2) & "px; width:" & (nWidth + 4) & "px; height:" & (nHeight + 4) & "px; z-index:0' style='border: 1px #999999 solid'></div>" & chr(13) & chr(10) & _
         "<div style='position:absolute; top:" & nTop & "px; left:" & nLeft & "px; width:" & nWidth & "px; height:" & nHeight & "px; z-index:0' style='background-color:#CCCD94;'></div>"
  CajaConBordes = replace( CajaConBordes , "'" , chr(34) )
End Function

'Numero de boleta actual
if len(trim(request("Boleta_actual"))) <> 0 then
   session("Boleta_actual") = request("Boleta_actual")
	 session("Fiscal_actual") = request("Fiscal_actual")
else
   'session("Boleta_actual") = "0"
	 'session("Fiscal_actual") = "0"
end if

'MOP_lista_detalle_DVT
Dim Detalle_Producto(1000)
Dim Detalle_Cantidad_salida(1000)
Dim Detalle_Costo_cif_ori_US(1000)
Dim Detalle_Porcentaje_descuento_1(1000)
Dim Detalle_Porcentaje_descuento_2(1000)
Dim Detalle_Temporada(1000)
Dim Detalle_KIT(1000)
Dim Detalle_Precio_de_lista_modificado(1000)
Dim Detalle_Imagen_producto(1000)
Dim Detalle_Nombre_producto(1000)
Detalle_lineas = 0
Detalle_leido = false

Sub LeeDetalle()

    If not Detalle_leido then
       'response.write "Exec MOP_Lista_detalle_DVT '" & trim(SessionLogin) & "'<br>"
        Set rs1 = Conn.execute("Exec MOP_Lista_detalle_DVT '" & trim(SessionLogin) & "'" )
        'response.write  ( rs1.eof ) & "<br>"
        do while not rs1.eof
           Detalle_lineas = Detalle_lineas + 1
           Detalle_Producto(Detalle_lineas)                     = ucase( trim( rs1("Producto") ) )
           Detalle_Cantidad_salida(Detalle_lineas)              = cint( rs1("Cantidad_salida") )
           Detalle_Costo_cif_ori_US(Detalle_lineas)             = cdbl( rs1("Costo_cif_ori_US$") )
           Detalle_Porcentaje_descuento_1(Detalle_lineas)       = cdbl( rs1("Porcentaje_descuento_1") )
           Detalle_Porcentaje_descuento_2(Detalle_lineas)       = cdbl( rs1("Porcentaje_descuento_2") )
           Detalle_Precio_de_lista_modificado(Detalle_lineas)   = cdbl( rs1("Precio_de_lista_modificado") )
           Detalle_Temporada(Detalle_lineas)					          = ucase( trim( rs1("temporada") ) )
           Detalle_KIT(Detalle_lineas)					                = Ucase(trim(rs1("Es_KIT")))
           Detalle_Imagen_producto(Detalle_lineas)              = ltrim( trim( rs1("Imagen_producto")) )
           Detalle_Nombre_producto(Detalle_lineas)              = trim( rs1("Nombre_producto") )
           rs1.movenext
        loop
        rs1.close
        set rs1 = nothing
        Detalle_leido = true
    End If
End Sub

function Get_Numero_Interno_DVT_Activa_X_Login(v_login)
	strSQL="select numero_interno_dvt_activa resultado from entidades_comerciales with(nolock) " &_
	       "where empresa='SYS' and rtrim(ltrim(entidad_comercial))='"&v_login&"'"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	rs_get.Close
	Set rs_get = Nothing
	Get_Numero_Interno_DVT_Activa_X_Login = resultado
end function
function Get_Cantidad_productos_eliminados_DVT_Activa_X_Login(v_login)
	strSQL="select isNull( Cantidad_productos_eliminados, 0 ) resultado from entidades_comerciales with(nolock) " &_
	       "where empresa='SYS' and rtrim(ltrim(entidad_comercial))='"&v_login&"'"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	rs_get.Close
	Set rs_get = Nothing
	Get_Cantidad_productos_eliminados_DVT_Activa_X_Login = resultado
end function

function Get_Cod_Temporada_X_Producto(v_producto)
	strSQL="select temporada resultado from productos with(nolock) where empresa='SYS' and producto='"&v_producto&"'"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = Ucase(trim(rs_get("resultado")))
	rs_get.Close
	Set rs_get = Nothing
	Get_Cod_Temporada_X_Producto = resultado
end function

function Get_Tipo_Lista_Precio_X_Cliente(v_rut_cliente)
	strSQL="select lista_de_precios resultado from vigencias_de_listas_de_precios with(nolock) " &_
	       "where empresa='SYS' and entidad_comercial='"&v_rut_cliente&"' and estado_vigencia='V'"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	rs_get.Close
	Set rs_get = Nothing
	Get_Tipo_Lista_Precio_X_Cliente = resultado
end function

function Get_Precio_Normal_X_Producto(v_producto)
	strSQL="select B.valor_unitario resultado from " &_
	       "(select valor_texto from parametros with(nolock) where parametro='lp_base') A," &_
	       "(select lista_de_precios, valor_unitario from productos_en_listas_de_precios with(nolock) " &_
	       "where empresa='SYS' and producto='"&v_producto&"' and limite_precio=0) B " &_
	       "where A.valor_texto=B.lista_de_precios"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	rs_get.Close
	Set rs_get = Nothing
	Get_Precio_Normal_X_Producto = resultado
end function

function Existe_Producto_Mayorista_En_Lista_DVT(v_num_int_DVT_activa)
	strSQL="select producto from movimientos_productos with(nolock) " &_
	       "where empresa='SYS' and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" " &_
	       "and (temporada is not null and temporada <> 'ECO')"
	set rs_get = Conn.Execute(strSQL) : resultado = false
	if not rs_get.EOF then resultado = true
	rs_get.Close
	Set rs_get = Nothing
	Existe_Producto_Mayorista_En_Lista_DVT = resultado
end function

function Get_Total_Precio_Normal_Lista_DVT(v_num_int_DVT_activa)
  strSQL="select Sum(Floor " &_
         "( " &_
         "  cantidad_salida * " &_
         "  ( " &_
         "     Round(precio_de_lista * ((100-(porcentaje_descuento_1+porcentaje_descuento_2))/100) ,0)  " &_
         "  ) " &_
         ")) resultado " &_
         " from movimientos_productos with(nolock) where empresa='SYS' and documento_no_valorizado='DVT' " &_
         " and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	rs_get.Close
	Set rs_get = Nothing
	Get_Total_Precio_Normal_Lista_DVT = resultado
end function

function Get_Total_Precio_Mayoristas_Lista_DVT(v_num_int_DVT_activa)
	'#### Total precio con descuento productos mayoristas ####
	'strSQL="select Sum(cantidad_salida*precio_de_lista_modificado) resultado from movimientos_productos with(nolock) " &_
	'       "where empresa='SYS' and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" " &_
	'       "and (temporada='XMAY' or temporada='PATG' or temporada='NOV' or temporada='CHAO')"
	'--------------------------------------------------------------------------------------------------------
	'#### Total precio normal productos mayoristas ####
  strSQL="select Sum(cantidad_salida*precio_de_lista) resultado from movimientos_productos with(nolock) " &_
	       "where empresa='SYS' and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" " &_
	       "and (temporada='XMAY' or temporada='PATG' or temporada='NOV' or temporada='CHAO' or temporada='500AÑOS')"
	'--------------------------------------------------------------------------------------------------------
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	rs_get.Close
	Set rs_get = Nothing
	Get_Total_Precio_Mayoristas_Lista_DVT = resultado
end function

if Request("Accion") = "Agregar" then
  Conn.BeginTrans
  cSql = "Exec MOP_Graba_detalle_DVT_en_RCP '" & _
                         trim(Session("xBodega")) & "'," & _
                         ( Request("Cantidad") \ 1 ) & ",'" & _
                         trim(Session("xCentro_de_venta")) & "','" & _
                         SessionCliente_boleta & "','" & _
                         Session("Empresa_usuario") & "','" & _
                         Request("Producto") & "'," & _
                         "null" & ",'" & _
                         SessionLogin & "',0" & _
                         Session("Tipo_cambio_boleta") & " , '"  & _
                         SessionTipo_documento_venta & "'"
  Set rs = Conn.execute( cSql )	
  if Conn.Errors.Count = 0 then
     Codigo_producto = trim( rs("Producto") )
     session("Codigo_ultimo_producto") = ucase(trim(Codigo_producto))
     Precio = rs("Precio")
     Nombre = rs("Nombre")
     if len(ltrim(trim(rs("Imagen_producto")))) > 0 then
    		IF LEN(URLProductos) = 0 THEN
            Imagen_actual = "../../imagenes/productos/" & ltrim(rs("Imagen_producto"))
    		ELSE
            Imagen_actual = URLProductos & ltrim(rs("Imagen_producto"))
    		END IF
     end if
     rs.close
     set rs = nothing
     Trae_imagen = false
     Total_cif_ori = 0
     LeeDetalle()
     For n = 1 To Detalle_lineas
        Total_cif_ori = Total_cif_ori + ( Detalle_Cantidad_salida(n) * Detalle_Costo_cif_ori_US(n) )
     Next

     if Total_cif_ori >= Session("Maximo_cif_bov") and SessionTipo_documento_venta = "BOV" then
        MensajeError = "Boleta supera los US$ " & Session("Maximo_cif_bov") & " costo CIF"
        Conn.RollbackTrans
     elseif Total_cif_ori >= Session("Maximo_cif_fav") and SessionTipo_documento_venta = "FAV" then
        MensajeError = "Factura supera los US$ " & Session("Maximo_cif_fav") & " costo CIF"
        Conn.RollbackTrans
     else
        Conn.CommitTrans
     end if
     
     if SessionCliente_boleta <> "CLI_BOLETA" and MensajeError="" then
       v_tipEntComer    = Session("tipo_entidad_comercial")
       v_clasDeEmpleado = Session("clasificacion_de_empleado")
       'if v_tipEntComer <> "A" and v_tipEntComer <> "E" and v_tipEntComer <> "U" then
       'Response.Write "v_tipEntComer:"&v_tipEntComer&", v_clasDeEmpleado: ("&v_clasDeEmpleado&")"
       'Response.End
       if v_tipEntComer = "C" or (v_tipEntComer = "A" and v_clasDeEmpleado = "") then  
          'Sólo se pueden aplicar descuentos de mayoristas a Clientes
          'NO SE PUEDE aplicar descuento mayorista a tipo Empleados (E), Usuarios (U) o Ambos (cliente o proveedor)=(A)
          'En el caso del tipo (A), se puede aplicar descuento cuando es (A) y no tiene clasificacion de empleado (Session("clasificacion_de_empleado")="")
          v_temporada			    = Get_Cod_Temporada_X_Producto(Codigo_producto)
          v_tipo_lista_precio = Get_Tipo_Lista_Precio_X_Cliente(SessionCliente_boleta)
          if (v_temporada="XMAY" or v_temporada="PATG" or v_temporada="NOV" or v_temporada="CHAO" or v_temporada="500AÑOS") and v_tipo_lista_precio="LXMAY" then 'Es producto Mayorista y el cliente está asociado a una lista mayorista
            
	          v_num_int_DVT_activa = Get_Numero_Interno_DVT_Activa_X_Login(SessionLogin)
	          session("producto_eliminado") = Get_Cantidad_productos_eliminados_DVT_Activa_X_Login(SessionLogin)
	          strSQL="select IsNull(A.cantidad_salida,0) cantidad, B.valor_unitario,B.limite_precio from " &_
	                 "(select cantidad_salida from movimientos_productos with(nolock) " &_
	                 "where empresa='SYS' and documento_no_valorizado='DVT' and producto='"&Codigo_producto&"' " &_
	                 "and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&") A," &_
	                 "(select valor_unitario, limite_precio from productos_en_listas_de_precios with(nolock) " &_
	                 "where empresa='SYS' and producto='"&Codigo_producto&"' " &_
	                 "and lista_de_precios='LXMAY' and limite_precio>0) B"
	          set rs_cant = Conn.Execute(strSQL)
	          if not rs_cant.EOF then 
	             v_cant				= rs_cant("cantidad")
	          	 v_valor_unitario	= rs_cant("valor_unitario")
	          	 v_limite_precio		= rs_cant("limite_precio")				
	          	 if cdbl(v_cant) >= cdbl(v_limite_precio) then
	          		  v_precio_normal = Get_Precio_Normal_X_Producto(Codigo_producto)
	          		  strSQL="update movimientos_productos set precio_de_lista="&v_precio_normal&", " &_
	          		         "precio_de_lista_modificado="&v_valor_unitario&", temporada='"&v_temporada&"', producto=producto " &_
	          		         "where empresa='SYS' and documento_no_valorizado='DVT' and producto='"&Codigo_producto&"' " &_
	          		         "and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
	          		  Conn.Execute(strSQL)
	          		  Detalle_Precio_de_lista_modificado(Detalle_lineas) = cdbl(v_valor_unitario)
	          		  Detalle_Temporada(Detalle_lineas) = v_temporada
	          		  'Verificar el tramo del "total de venta mayorista" para aplicar el descuento correspondiente al Tramo (update A todos los productos MAY)
	          		  Total_Precio_Mayoristas = Get_Total_Precio_Mayoristas_Lista_DVT(v_num_int_DVT_activa)
	          		  'Total_Precio_Mayoristas = 250000
	          		  Tramos = split(session("TramosMayorista"),"@")
	          		  for t = 0 to Ubound(Tramos)
	          		    aValores      = split(Tramos(t),"#")
	          		    Desde         = aValores(0)
	          		    Hasta         = aValores(1)
	          		    Descuento_May = aValores(2)
	          		    'Response.Write "Total_Precio_Mayoristas: "&Total_Precio_Mayoristas&", Desde: "&Desde&", Hasta: " & Hasta & ", Descuento_May: "&Descuento_May&"<br>"
	          		    if cdbl(Total_Precio_Mayoristas) >= cdbl(Desde) and cdbl(Total_Precio_Mayoristas) < cdbl(Hasta) then
	                    strSQL="update movimientos_productos set precio_de_lista_modificado = " &_
	                           "(select Round(valor_unitario*(100-"&replace(Descuento_May,",",".")&")/100,0) - " &_
	                           "Convert(int, Round(valor_unitario*(100-"&replace(Descuento_May,",",".")&")/100,0)) % Convert(int,10) " &_
	                           "from productos_en_listas_de_precios with(nolock) where empresa='SYS' and lista_de_precios='LXMAY' and limite_precio>0 and " &_
	                           "productos_en_listas_de_precios.producto=movimientos_productos.producto), producto=producto " &_
	                           "where empresa='SYS' and documento_no_valorizado='DVT' and " &_
	                           "numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" and (temporada is not null and temporada<>'ECO'"
	          		      'Response.Write strSQL
	          		      'Response.End
	          		      Conn.Execute(strSQL)
	          		      v_valor_unitario = Round(cdbl(v_valor_unitario)*(100-cdbl(Descuento_May))/100,0)
	          		      v_valor_unitario = cdbl(v_valor_unitario) - cdbl(v_valor_unitario Mod 10)
	          		      Detalle_Precio_de_lista_modificado(Detalle_lineas) = cdbl(v_valor_unitario)
	          		      exit for
	          		    end if
	          		  next
	          		  '********************************************************************
	          		  'Forzar a que guarde nuevamente los valores en el arreglo 
	          		  'debido a que se hizo un cambio en los precios mayoristas
	          		  Detalle_leido = false : Detalle_lineas = 0 : LeeDetalle() 
	          		  '********************************************************************
	          	  end if
	          end if
	        end if
	     end if
	   end if
  else
     Conn.RollbackTrans
     Codigo_producto = left(Request("Producto"),13)
     strSQL = "select Vista_max_exterior, Nombre from productos with(nolock) where producto = '"&Codigo_producto&"' "
	'strSQL = "select producto, nombre, nombre, superfamilia, familia, subfamilia, Vista_max_exterior, " &_
	'		 "PProm = (select valor_unitario from productos_en_listas_de_precios (nolock) where empresa='SYS' and producto = PROD.producto " &_
	'		 "and lista_de_precios = (select LTRIM(RTRIM(valor_texto)) from parametros with(nolock) where parametro = 'LP_BASE')) - IsNull((select monto_descuento from " &_ 
	'		 "productos_en_promociones (nolock) where empresa='SYS' and producto = PROD.producto), 0) " &_
	'		 "from productos PROD (nolock) " &_
	'		 "where producto = '"&Codigo_producto&"' "
	
'Response.write strSQL
'Response.End
	 set rs_imag = Conn.Execute(strSQL)
	          if not rs_imag.EOF then 
	 nombre_imagen   = rs_imag("Vista_max_exterior")
	 nombre_Producto = rs_imag("Nombre")
    	 IF LEN(URLProductos) = 0 THEN
    	 Imagen_actual_error = "../../imagenes/productos/" & nombre_imagen
    	 session("ruta_imagen") = Imagen_actual_error 
    	 ELSE
    	 Imagen_actual_error = URLProductos & nombre_imagen
    	 session("ruta_imagen") = Imagen_actual_error 
    	 END IF
    End If	 
	 MensajeError = Err.Description
  end if
end if


if Request("Accion") = "Modificar" then
   Conn.execute( "Exec MOP_Modifica_descuento_linea_DVT '" & _
                          SessionLogin & "'," & _
                          Request("Linea") & "," & _
                          Request("Descuento_linea_" & Request("Linea")) )
end if

'Descuento documento
if Session("Descuento_cliente") = 0 then
   Descuento_documento = cdbl( request("Descuento_documento") )
else
   Descuento_documento = Session("Descuento_cliente")
end if

Cantidad_ultimo_producto = 0
Total_pesos = 0
Total_cif_ori = 0

'Rescatando el último producto ingresado
if session("Codigo_ultimo_producto") = "" then
   LeeDetalle()
   For n = 1 To Detalle_lineas
       session("Codigo_ultimo_producto") = Detalle_Producto(n)
   Next
   'session("Codigo_ultimo_producto") = Detalle_Producto(Detalle_lineas)
end if
LeeDetalle()
Total_pesos = 0
'Descuento = 0
Es_Kit = true

sql = "exec MOP_actualiza_descripcion_KITAR '" & SessionLogin & "'"
conn.execute(sql)

For n = 1 To Detalle_lineas
  Descuento = 0
  'Descuento = Descuento_documento + Detalle_Porcentaje_descuento_2(n)
  Descuento1 = Descuento_documento + Detalle_Porcentaje_descuento_1(n)
  Descuento2 = Descuento_documento + Detalle_Porcentaje_descuento_2(n)
  Precio_final = Detalle_Precio_de_lista_modificado(n)

  'Precio_final = ( Precio_final * ( ( 100 - Descuento1 ) / 100 ) \ 1 )
    
  '********************************************************************************
  '***************** MODIFICACION PARA PRODUCTOS MAYORISTAS EN PROMOCION **********
  '********************************************************************************
  temporada = Detalle_Temporada(n)
  if temporada = "XMAY" or temporada = "PATG" or temporada="NOV" or temporada="CHAO" or temporada="500AÑOS" then 
		Descuento1 = 0 : Descuento2 = 0
	end if
	'Precio_final = ( Precio_final * ( ( 100 - (Descuento1+Descuento2) ) / 100 )  \ 1 )
	Precio_final = ( Precio_final * ( ( 100 - (Descuento1+Descuento2) ) / 100 )  \ 1 )
	'Response.Write "Producto: " & Detalle_Producto(n) & ", Precio_final: " & Precio_final & ", Cantidad: " & Detalle_Cantidad_salida(n) & "<br>"
	'Response.Write trim(Detalle_KIT(n)) & "<br>"
	'####################################################################################################################
	'No se debe hacer mod 10 cuando los productos son KIT porque a veces los precios unitarios están con pesos (casos de $195 0 $265)
	'if Ucase(trim(Detalle_KIT(n))) = "N" then Precio_final = cdbl(Precio_final) - cdbl(Precio_final Mod 10) 'MODIFICACION
	'Se comentó la línea porque se considerará mostrar los pesos al igual que en el listado de productos (pagos)
	'####################################################################################################################
	
	Total_pesos = Total_pesos + ( Detalle_Cantidad_salida(n) * Precio_final )
	Total_cif_ori = Total_cif_ori + ( Detalle_Cantidad_salida(n) * Detalle_Costo_cif_ori_US(n) )
	
  if Ucase(trim(session("Codigo_ultimo_producto"))) = Ucase(trim(Detalle_Producto(n))) then
    Cantidad_ultimo_producto = Cantidad_ultimo_producto + Detalle_Cantidad_salida(n)
    Codigo_producto = Detalle_Producto(n)
    Precio = Precio_final
    Nombre = Detalle_Nombre_producto(n)
    if len( Detalle_Imagen_producto(n) ) > 0 then
    	  IF LEN(URLProductos) = 0 THEN
          Imagen_actual = "../../imagenes/productos/" & Detalle_Imagen_producto(n)
    	  ELSE
          Imagen_actual = URLProductos & Detalle_Imagen_producto(n)
    	  END IF
    end if
    Es_Kit = false    
  end if
Next
'Response.Write trim(session("Codigo_ultimo_producto"))
if Detalle_lineas > 0 then
  if Es_Kit then 'No se encontró el último producto ingresado puede ser un KIT o el ultimo eliminado fue un KIT
    strSQL="select A.total_precio, B.producto_insumo, C.nombre from " &_
           "(select sum(precio_unitario * cantidad) total_precio from composicion with(nolock) where producto_final='"&trim(session("Codigo_ultimo_producto"))&"') A," &_
           "(select top 1 producto_insumo from composicion with(nolock) where producto_final='"&trim(session("Codigo_ultimo_producto"))&"' order by precio_unitario desc) B," &_
           "(select nombre from productos with(nolock) where producto='"&trim(session("Codigo_ultimo_producto"))&"') C"
    Set rs = Conn.execute(strSQL)
    if not rs.EOF then
      Codigo_producto = trim(session("Codigo_ultimo_producto"))
      Precio          = rs("total_precio")
      Nombre          = rs("nombre")
      'Buscar la cantidad e imagen del producto de mayor valor dentro del KIT (total_precio)
      For n = 1 To Detalle_lineas
        if trim(rs("producto_insumo")) = trim(Detalle_Producto(n)) then
          Cantidad_ultimo_producto = Detalle_Cantidad_salida(n)
    		  IF LEN(URLProductos) = 0 THEN
              Imagen_actual = "../../imagenes/productos/"&Detalle_Imagen_producto(n)
    		  ELSE
              Imagen_actual = URLProductos & Detalle_Imagen_producto(n)
    		  END IF
          exit for
        end if
      next
      if Cantidad_ultimo_producto = 0 then
        session("Codigo_ultimo_producto") = "" : Precio = "" : Codigo_producto = "" : Cantidad_ultimo_producto = "" : Nombre = ""
      end if
      Response.Write Cantidad_ultimo_producto
    end if
  else
    session("Codigo_ultimo_producto") = "" 
  end if
else
  session("Codigo_ultimo_producto") = "" : Precio = "" : Codigo_producto = "" : Cantidad_ultimo_producto = "" : Nombre = ""
end if
'Response.Write Total_pesos & " ****** "
'Response.End

Session("MensajeError") = LimpiaError(MensajeError)
if len(trim(Session("MensajeError"))) > 0 then MensajeError = "ERROR : " & left( Session("MensajeError") , 35 )

if Session("MensajeError") <> "" then
   Precio = ""
   Codigo_producto = ""
   Cantidad_ultimo_producto = ""
   Nombre = ""
end if

v_num_int_DVT_activa = Get_Numero_Interno_DVT_Activa_X_Login(SessionLogin)
if v_num_int_DVT_activa <> "" then
	strSQL="select count(numero_interno_movimiento_producto) as numLineas from movimientos_productos with (nolock) where numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
	set rsNumLineas = Conn.Execute(strSQL)
	if not rsNumLineas.EOF then 
   	numero_de_lineas = rsNumLineas("numLineas")
	else 
		numero_de_lineas = 0
	end if
	rsNumLineas.close
	set rsNumLineas = nothing
else 
	numero_de_lineas = 0
end if

DELCANTPROD  = Get_Valor_Numerico_X_Parametro("DELCANTPROD")
v_tipo_lista_precio = Get_Tipo_Lista_Precio_X_Cliente(SessionCliente_boleta)
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Maqueta punto de venta</title>
	<link rel="stylesheet" type="text/css" href="estilos.css">	
</head>
<body bgcolor="" leftmargin="0" topmargin="0" text="#000000" onclick="document.formulario.Cantidad.focus();" >

<form name="formulario" method="post" action="Mant_PuntoVentaZF.asp">

<input type="hidden" name="Accion" id="Accion" value="">
<input type="hidden" id="tecla">
<%delta=17
'show_image = false
show_image = true
%>
<%if show_image then%>
	<%=CajaConBordes(24,12,400,418)%>
	<div style="position:absolute; top:27px; left:<%=28-delta%>px; z-index:1">
     <img id="imagen" src="<%=Imagen_actual%>" alt="Imagen producto" width="398" height="416" border="0"/>
	</div>
<%end if%>
<%delta=35
ancho_caja_bg_derecha=574%>
<%=CajaConBordes(24,470-delta,ancho_caja_bg_derecha,120)%>
<div style="position:absolute; top:35px; left:<%=480-delta%>px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Precio<br>
Descripción<br>
</div>
<div style="position:absolute; top:35px; left:<%=670-delta%>px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
&nbsp;Código
</div>
	<div style="position:absolute; top:35px; left:<%=940-delta%>px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">&nbsp;N&ordm;Lin		
</div>
<div style="position:absolute; top:30px; left:<%=540-delta%>px; z-index:1; color=#000066; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 24px;"><%=replace(formatnumber(Precio,0),",",".")%></div>
<div style="position:absolute; top:34px; left:<%=750-delta%>px; z-index:1; color=#993300; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=Codigo_producto%></div>
<div style="position:absolute; top:34px; left:<%=880-delta%>px; z-index:1; color=#993300; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=Cantidad_ultimo_producto%></div>

<div style="position:absolute; top:34px; left:<%=1000-delta%>px; z-index:1; color=#993300; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=numero_de_lineas%></div>
<div style="border: 0px solid #000000; position:absolute; top:80px; left:<%=480-delta%>px; width=560px; z-index:1; color=#006633; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=Nombre%></div>

<%=CajaConBordes(180,470-delta,ancho_caja_bg_derecha,80)%>
<div style="position:absolute; top:195px; left:<%=480-delta%>px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Cantidad<br>
Producto
</div>
<div style="position:absolute; top:194px; left:<%=560-delta%>px; z-index:1">
     <input onkeypress="return Valida_Digito(event);"
     id="Cantidad" type="text" name="Cantidad" size="6" maxlength="6" value="1"><br>

   <%if numero_de_lineas >= 12 and SessionTipo_documento_venta = "FAV"  then%>
   	<input id="Producto" type="text" name="Producto" size="22" maxlength="20" value="" onchange="javascript:limite_lineas_factura()">
   <%else%>
   	<input id="Producto" type="text" name="Producto" size="22" maxlength="20" value="" onchange="javascript:agrega_producto()">
   <%end if%>
</div>
<%=CajaConBordes(297,470-delta,ancho_caja_bg_derecha,145)%>
<div style="position:absolute; top:298px; left:<%=474-delta%>px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Total $<br><br>
Cliente<br>
Cajera<br>
Valor US$<br>
Economato
</div>
<div style="position:absolute; top:297px; left:<%=560-delta%>px; z-index:1"  style="color=#666666; font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
<br><br>
<%=Session("Nombre_cliente_boleta")%> ( <%=SessionCliente_boleta%> )<br>
<%=left(session("Nombre_usuario_boleta"),20)%><br>
<%=Session("Tipo_cambio_boleta")%><br>
<%=Session("xEconomato_nombre")%>
</div>
<div style="position:absolute; top:373px; left:<%=840-delta%>px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Doc.<br>
Fecha
</div>
<div style="position:absolute; top:373px; left:<%=900-delta%>px; z-index:1"  style="color=#666666; font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
<%if SessionTipo_documento_venta = "FAV" then response.write "Factura" else response.write "Bol:" & session("Boleta_Actual")%><br>
<%=strzero(day( Session( "Fecha_boleta" ) ),2)&"/"&strzero(month( Session( "Fecha_boleta" ) ),2)&"/"&strzero(year( Session( "Fecha_boleta" ) ),4)%>
</div>
<%
session("producto_eliminado") = Get_Cantidad_productos_eliminados_DVT_Activa_X_Login(SessionLogin)
if SessionCliente_boleta <> "CLI_BOLETA" then
  v_num_int_DVT_activa	  = Get_Numero_Interno_DVT_Activa_X_Login(SessionLogin)
  v_existe_prod_mayorista	= Existe_Producto_Mayorista_En_Lista_DVT(v_num_int_DVT_activa)
  Total_Precio_Normal		  = Get_Total_Precio_Normal_Lista_DVT(v_num_int_DVT_activa)
  if Total_Precio_Mayoristas = "" then Total_Precio_Mayoristas = Get_Total_Precio_Mayoristas_Lista_DVT(v_num_int_DVT_activa)
  Piso_Mayorista          = Session("BASETOTMAY")
  'Piso_Mayorista			    = 30000 'Parametro Global , session
  dif_piso_mayorista		  = cdbl(Piso_Mayorista) - cdbl(Total_Precio_Mayoristas)
else
  Total_Precio_Normal     = Total_pesos
end if
%>
<div style="position:absolute; top:288px; left:<%=530-delta%>px; z-index:1; color=#993300; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 40px;">
    <%=replace(formatnumber(Total_Precio_Normal,0),",",".")%>
</div>
<%if v_existe_prod_mayorista then%>
	<!-- Precios MAYORISTA-->
	<div style="position:absolute; top:301px; left:<%=766-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
	May.$</div>
	<div style="position:absolute; top:290px; left:<%=810-delta%>px; z-index:1; color=#0B3861; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 30px;">
	    <%=replace(formatnumber(Total_pesos,0),",",".")%>
	</div>
	<%if dif_piso_mayorista>0 then%>
		<div style="position:absolute; top:297px; left:<%=936-delta%>px; z-index:1"  style="font-size: 12px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
		Dif.$</div>
		<div title="<%=Total_Precio_Mayoristas%>" style="position:absolute; top:292px; left:<%=964-delta%>px; z-index:1; color=#B45F04; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 20px;">
		    <%=replace(formatnumber(dif_piso_mayorista,0),",",".")%>
		</div>
	<%end if%>
<%end if%>

<%if Session("Ver_CIF") = "S" then%>
<div style="position:absolute; top:422px; left:<%=650 + (650-ancho_caja_bg_derecha+20)%>px; text-align=right; width=250; z-index:1; color=#aaaaaa; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 17px;"><%=formatnumber(Total_cif_ori,2)%></div>
<%end if%>

<div style="position:absolute; top:120px; left:<%=480-delta%>px; width=510px; z-index:1;">
 <a href="javascript:ventanitaerror()" style="color=#ff0000; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 16px; text-decoration: blink;"><%=MensajeError%></a>
</div>

</form>
</body>
</html>
<%
conn.close
set conn = nothing

conn1.close
set conn1 = nothing
%>
<script language="JavaScript">
document.formulario.Cantidad.focus();
document.formulario.Cantidad.select();
document.all.Accion.value = "";
<%if Session("MensajeError") <> "" then%>
ventanitaerror();
<%end if%>
var ultimafila="";
var producto_eliminado = "<%=session("producto_eliminado")%>"
var DELCANTPROD = "<%=DELCANTPROD%>"
//alert(producto_eliminado + ' - ' + DELCANTPROD);
function salidafila() {
if ( ultimafila == "" ) {} else {
  ultimafila.className='normal';}
}
function cambio_imagen(fila,codigo)
{
  salidafila();
  document.all[fila].className='seleccionado';
  ultimafila=document.all[fila];
  document.all.imagen.src=codigo+'.jpg';
}
function fObservaciones()
{
  var sValue = window.showModalDialog ("Observaciones_ZF.asp", "valor", "dialogWidth:30;dialogHeight:15;center:yes;edge:sunken;unadorned:yes;status:no;help:no;")
}

function Pagos()
{
  parent.Botones.location.href = "Botones_Pagos_PuntoVentaZF.asp"
  window.location.href = 'Pagos_PuntoVentaZF.asp'
}
function Consulta()
{
  <%if v_tipo_lista_precio = "LXMAY" or session("elimina_producto") = "S" or session("IP")= "192.168.2.110" then %>
    //session("IP")= "192.168.2.110" es para que la caja 33 pueda consultar ya que con lo Argentinos se trababan muchas las ventas --FRANCISCO 23-10-2012 
    parent.Botones.location.href = "Botones_Consulta_PuntoVentaZF.asp"
    window.location.href = 'Consulta_PuntoVentaZF.asp'
  <%end if%>
}

function Eliminar()
{
  //alert(producto_eliminado+" "+DELCANTPROD)
  <%if Detalle_lineas > 0 then %>
    sValue = 1
    <%if session("elimina_producto") = "N" then%>
      if(parseInt(producto_eliminado) >= parseInt(DELCANTPROD))
      {
        var sValue = undefined;        
        do
        {
            var sValue = window.showModalDialog ("LoginSupervisor_PuntoVentaZF.asp", "valor", "dialogWidth:20;dialogHeight:20;center:yes;edge:sunken;unadorned:yes;status:no;help:no;")
        }
        while(sValue == undefined);
      }
    <%end if%>
    
    if ( sValue != 2 )
    {
      parent.Botones.location.href = "Botones_Elimina_PuntoVentaZF.asp"
      window.location.href         = "Elimina_PuntoVentaZF.asp"
    }
  <%end if%>
}
function Descuento()
{
parent.Botones.location.href = "Botones_Descuento_PuntoVentaZF.asp"
window.location.href = 'Descuento_PuntoVentaZF.asp';
}
function limite_lineas_factura()
{
	alert("No se puede agregar mas lineas a la factura (Máximo 12). Por Favor Terminar Venta, que tenga un buen dia.");
	Pagos();
}

function agrega_producto()
{
document.all.Accion.value = "Agregar";
document.formulario.submit();
}
function agrega_cheques()
{
document.all.Accion.value = "AgregaCheques";
document.formulario.submit();
}
function modifica_descuento_linea(Linea)
{
document.all.Accion.value = "Modificar";
document.all.Linea.value = Linea;
document.formulario.submit();
}
function dummy()
{
}

	var blnDOM = false, blnIE4 = false, blnNN4 = false; 

	if (document.layers) blnNN4 = true;
	else if (document.all) blnIE4 = true;
	else if (document.getElementById) blnDOM = true;

	function getKeycode(e)
	{
		var TeclaPresionada = ""
		
		if (blnNN4)
		{
			var NN4key = e.which
			TeclaPresionada = NN4key;
		}
		if (blnDOM)
		{
			var blnkey = e.which
			TeclaPresionada = blnkey;
		}
		if (blnIE4)
		{
			var IE4key = event.keyCode
			TeclaPresionada = IE4key
		}

		if ( TeclaPresionada == 113 ) // F2 Consulta de producto
		{
		   Consulta();
		}
		if ( TeclaPresionada == 119 ) // F8 Elimina producto
		{
		   Eliminar();
 		}
		/*if ( TeclaPresionada == 120 ) // F9 
		{
		   Descuento();
 		}*/
		if ( TeclaPresionada == 13 ) // F9 Termina e imprime
		{
		   document.formulario.Cantidad.focus();
		}
		if ( TeclaPresionada == 27 ) // ESC Pasa a tomar productos
		{
		   Pagos();
		}
		if ( TeclaPresionada == 118 ) // F7 Observaciones
		{
		   fObservaciones();
		}

		
    document.all.tecla.value = TeclaPresionada;
	}

	document.onkeydown = getKeycode;
	if (blnNN4) document.captureEvents(Event.KEYDOWN);

function ventanitaerror()
{
//var ventana = window.open('Ventanita_error_PuntoVentaZF.asp','error','height=200,width=500,scrollbars=no,location=no,directories=no,status=yes,menubar=no,toolbar=no,resizable=yes,title=no,dependent=yes');
popup('Ventanita_error_PuntoVentaZF.asp',350,600);
}

function popup(page,h,w) {
var winl = (screen.width-w)/2;
var wint = (screen.height-h)/2;
if (winl < 0) winl = 0;
if (wint < 0) wint = 0;
windowprops = "height="+h+",width="+w+",top="+ wint +",left="+ winl +",location=no,"
+ "scrollbars=yes,menubars=no,toolbars=no,resizable=no,status=yes";
window.open(page, "Popup", windowprops);
}

function Valida_Digito(e){
  //Sólo para IE
  regexp = /\d/;
  if(!regexp.test(String.fromCharCode(e.keyCode)))
    return false;
  else
    return true;
}
</script>
