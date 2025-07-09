<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
if len(trim( Session( "DataConn_ConnectionString") )) = 0 then%>
<script language=javascript>
		parent.top.location.href = "../../index.htm"
	</script>
<%end if

set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
'RutaVIRTUAL_ImagenesProductos = "http://"&Request.ServerVariables("HTTP_HOST")&"/altagestion/imagenes/productos/"
RutaVIRTUAL_ImagenesProductos = "http://"&Request.ServerVariables("HTTP_HOST")&"/Abonados/Sanchez_PtaArenas/imagenes/productos/"

'Imagen_actual = "../../imagenes/productos/sinimagen.jpg"
Imagen_actual = "../../imagenes/productos/sinimagen.gif"

on error resume next

function Get_Nombre_Empleado(z_id_rut)
  strSQL="select (apellidos_persona_o_nombre_empresa + ' ' + nombres_persona) nombre from " &_
         "entidades_comerciales with(nolock) where empresa='SYS' and entidad_comercial='"&z_id_rut&"'"
  set rs_nombre = Conn.Execute(strSQL) : v_nombre = ""
  if not rs_nombre.EOF then v_nombre = trim(rs_nombre("nombre"))
  Get_Nombre_Empleado = v_nombre
end function

function Get_Nombre_Cliente(z_id_rut)
  strSQL="select (apellidos_persona_o_nombre_empresa + ' ' + nombres_persona) nombre from " &_
         "entidades_comerciales with(nolock) where empresa='SYS' and entidad_comercial='"&z_id_rut&"'"
  set rs_nombre = Conn.Execute(strSQL) : v_nombre = ""
  if not rs_nombre.EOF then v_nombre = trim(rs_nombre("nombre"))
  Get_Nombre_Cliente = v_nombre
end function

Function CajaConBordes(nTop,nLeft,nWidth,nHeight)
  CajaConBordes = "<div style='position:absolute; top:" & (nTop - 10) & "px; left:" & (nLeft -10) & "px; width:" & (nWidth + 20) & "px; height:" & (nHeight + 20) & "px; z-index:0' style='border: 2px #808080 solid'></div>" & chr(13) & chr(10) & _
         "<div style='position:absolute; top:" & (nTop - 2) & "px; left:" & (nLeft - 2) & "px; width:" & (nWidth + 4) & "px; height:" & (nHeight + 4) & "px; z-index:0' style='border: 1px #999999 solid'></div>" & chr(13) & chr(10) & _
         "<div style='position:absolute; top:" & nTop & "px; left:" & nLeft & "px; width:" & nWidth & "px; height:" & nHeight & "px; z-index:0' style='background-color:#CCCD94;'></div>"
  CajaConBordes = replace( CajaConBordes , "'" , chr(34) )
End Function

function Existe_ImagenProducto(v_imagen_producto)
  'RutaFISICA_ImagenesProductos  = Request.ServerVariables("APPL_PHYSICAL_PATH") & "\Imagenes\Productos\"
  RutaFISICA_ImagenesProductos  = Request.ServerVariables("APPL_PHYSICAL_PATH") & "Abonados\Sanchez_PtaArenas\Imagenes\Productos\"

  SinImagen   = "noimagen.gif"  
  archivo     = RutaFISICA_ImagenesProductos & v_imagen_producto
  Set objFSO  = Server.CreateObject("Scripting.FileSystemObject")
  imagen      = v_imagen_producto
  if not objFSO.FileExists(archivo) then imagen = SinImagen
  Existe_ImagenProducto = imagen
end function

lStarttime = false
if Request("Accion") = "Consulta" then
   lStarttime = true 
   Set rs = Conn.execute("Exec MOP_Consulta_producto '" & _
                          trim(Session("xBodega")) & "','" & _
                          trim(Session("xCentro_de_venta")) & "','" & _
                          Session("Cliente_boleta") & "','" & _
                          "SYS" & "','" & _
                          Request("Producto") & "','" & _
                          Session("Login") & "'," & _
                          "1" )
   if Conn.Errors.Count = 0 then
      Codigo_producto                 = Ucase(trim( rs("Producto") ))
      'Imagen_actual                   = "../../imagenes/productos/" & Codigo_producto & ".jpg"
      'Imagen_actual                   = RutaVIRTUAL_ImagenesProductos & Existe_ImagenProducto(Codigo_producto & ".jpg")
      Imagen_actual                   = RutaVIRTUAL_ImagenesProductos & Existe_ImagenProducto(rs("Imagen_Producto"))
      Precio_venta_de_lista           = trim( rs("Precio_venta_de_lista_$") )
      Nombre_producto                 = trim( rs("Nombre_producto") )
      Stock_real_en_bodega            = trim( rs("Stock_real_en_bodega") )
      Porcentaje_descuento_promocion  = trim( rs("Porcentaje_descuento_promocion") )
      Nombre_promocion                = Ucase(trim( rs("Nombre_promocion") ))
      Monto_descuento                 = trim(rs("Monto_descuento"))
      precio_prom                     = Formatnumber(cdbl(Precio_venta_de_lista) - cdbl(Monto_descuento),0) 
      if cdbl(Monto_descuento) = 0 then precio_prom = 0 
       
      'Obtener información si el producto es Mayorista
      strSQL="select valor_unitario, limite_precio from productos_en_listas_de_precios with(nolock) " &_
	           "where empresa='SYS' and producto='"&Codigo_producto&"' " &_
	           "and lista_de_precios='LXMAY' and limite_precio>0 " &_
	           "and (select temporada from productos with(nolock) where empresa='SYS' and producto = '"&Codigo_producto&"') in ('XMAY','PATG','NOV','CHAO')"
      set rs_may = Conn.Execute(strSQL) : precio_may = 0 : dscto_may = 0 : limite_may = 0
      if not rs_may.EOF then
        precio_may  = cdbl(rs_may("valor_unitario"))
        'dscto_may   = Formatnumber(cdbl(Precio_venta_de_lista) - cdbl(precio_may),0)
        dscto_may   = Formatnumber(100 - 100*cdbl(precio_may)/cdbl(Precio_venta_de_lista),2)
        limite_may  = rs_may("limite_precio")
      end if
      
      'Almacenar bitacora consulta productos
      strSQL="insert into zbitacoraConsulta_productos (fecha_hora, empleado_responsable, producto, ip, centro_de_venta, cliente) " &_
             "values (getdate(), '"&Session("Login")&"', '"&Codigo_producto&"', " &_
             "'"&Request.ServerVariables("REMOTE_ADDR")&"', '"&trim(Session("xCentro_de_venta"))&"', '"&Session("Cliente_boleta")&"')"
      Conn.Execute(strSQL)
      
      strSQL="select top 3 fecha_hora, producto, " &_
             "precio = (select top 1 Valor_unitario from productos_en_listas_de_precios with(nolock) where empresa='SYS' and producto = zb.producto), " &_
             "Des = (select top 1 Nombre from productos with(nolock) where empresa='SYS' and producto = zb.producto) " &_
             "from zbitacoraConsulta_productos zb with(nolock) " &_
             "where day(fecha_hora) = day(getDate()) and empleado_responsable = '"&Session("Login")&"' and leido=0 order by fecha_hora desc"
      'response.write strsql
      'response.end
      set rs_bitacora = Conn.Execute(strSQL) : fecha_hora_1 = "" : fecha_hora_2 = "" : fecha_hora_3 = "" : cont = 0
      do while not rs_bitacora.EOF
        cont = cont + 1
        if cont = 1 then 
          fecha_hora_1  = rs_bitacora("fecha_hora")
          producto_1    = rs_bitacora("producto")
          precio_1      = rs_bitacora("precio")
          descripcion_1 = rs_bitacora("des")
        elseif cont = 2 then 
          fecha_hora_2  = rs_bitacora("fecha_hora")
          producto_2    = rs_bitacora("producto")
          precio_2      = rs_bitacora("precio")
          descripcion_2 = rs_bitacora("des")                    
        elseif cont = 3 then 
          fecha_hora_3  = rs_bitacora("fecha_hora")
          producto_3    = rs_bitacora("producto")
          precio_3      = rs_bitacora("precio")
          descripcion_3 = rs_bitacora("des")                    
        end if
        rs_bitacora.MoveNext
      loop
      
      envia_correo = false
      if cont = 3 then
        dif  = datediff("s",fecha_hora_3,fecha_hora_1)
        'Response.Write "seg: " & dif
        'Response.End
        if cint(dif) < 10 then envia_correo = true
      end if

      if envia_correo then
        '#######################################################################
        nombre_empleado = Get_Nombre_Empleado(Session("Login"))
        'Correo 
        set msg = Server.CreateObject("CDO.Message")
        msg.From = "altagestion@sanchezysanchez.cl"
        msg.To = "cbutendieck@sanchezysanchez.cl"
        msg.CC = "werazo@sanchezysanchez.cl"
        msg.Subject = "Notificación automática de consultas repetidas de productos, Cajero(a): " & nombre_empleado
        
        v_html = "Consulta de 3 productos en "&dif&" segundos, Cajero(a): " & nombre_empleado
        v_html = v_html & "<br>Producto: " & producto_1 & ", Precio: $" & FormatNumber(precio_1,0) & ", " & descripcion_1 & " -- leido a las " & Lpad(hour(fecha_hora_1),2,0) & ":" & Lpad(minute(fecha_hora_1),2,0) & ":" & Lpad(second(fecha_hora_1),2,0)
        v_html = v_html & "<br>Producto: " & producto_2 & ", Precio: $" & FormatNumber(precio_2,0) & ", " & descripcion_2 & " -- leido a las " & Lpad(hour(fecha_hora_2),2,0) & ":" & Lpad(minute(fecha_hora_2),2,0) & ":" & Lpad(second(fecha_hora_2),2,0)
        v_html = v_html & "<br>Producto: " & producto_3 & ", Precio: $" & FormatNumber(precio_3,0) & ", " & descripcion_3 & " -- leido a las " & Lpad(hour(fecha_hora_3),2,0) & ":" & Lpad(minute(fecha_hora_3),2,0) & ":" & Lpad(second(fecha_hora_3),2,0)
        
        nombre_cliente = "Cliente Boleta"
        if Session("Cliente_boleta") <> "CLI_BOLETA" then nombre_cliente = Get_Nombre_Cliente(Session("Cliente_boleta"))
        
        v_html = v_html & "<br>Cliente: " & nombre_cliente
        msg.HTMLBody = v_html
        msg.Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail.sanchezysanchez.cl"
        msg.Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 1
        msg.Configuration.Fields.Update
        msg.Send
        set msg = nothing
        '#######################################################################  
        
        'Actualizar los registros y dejarlos como leidos
        strSQL="update zbitacoraConsulta_productos set leido=1 where day(fecha_hora) = day(getDate())"
        Conn.Execute(strSQL)
      end if
   else
      MensajeError = LimpiaError(Err.Description)
   end if
end if

'if session("IP") = "192.168.0.50" then
'  Response.Write RutaVIRTUAL_ImagenesProductos & Existe_ImagenProducto("rocxl057.jpg")
'end if

%>
<html>
<head>
<title>Consulta producto</title>
	<link rel="stylesheet" type="text/css" href="estilos.css">	
</head>
<body bgcolor="#FF0000" leftmargin="0" topmargin="0" text="#000000" onfocus="document.formulario.Cantidad.focus();">
<form name="formulario" method="post" action="Consulta_PuntoVentaZF.asp">
<input type="hidden" name="Accion" id="Accion" value="">
<%
delta=15
ancho_caja_bg_derecha=574
%>
<%=CajaConBordes(24,27-delta,400,440)%>
<div style="position:absolute; top:45px; left:<%=28-delta%>px; z-index:1"><img id="imagen" src="<%=Imagen_actual%>" alt="Imagen producto" width="398" height="416" border="0"/></div>

<%=CajaConBordes(24,450-delta,ancho_caja_bg_derecha,120)%>
<div style="position:absolute; top:34px; left:<%=456-delta%>px; z-index:1" style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Precio<br>Descripción</div>
<div style="position:absolute; top:29px; left:<%=520-delta%>px; z-index:1; color=#000066; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 24px;"><%=formatnumber(Precio_venta_de_lista,0)%></div>
<div style="position:absolute; border: 0px solid #000000; top:80px; left:<%=456-delta%>px; width:568px; z-index:1; color=#006633; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=Nombre_producto%></div>
<div style="position:absolute; top:32px; left:700px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Código<br>Stock</div>
<div style="position:absolute; top:32px; left:780px; z-index:1; color=#993300; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 20px;"><%=Codigo_producto%></div>
<div style="position:absolute; top:55px; left:780px; z-index:1; color=#6699ff; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 19px;"><%=formatnumber(Stock_real_en_bodega,0)%></div>
<%if Monto_descuento>0 then%>
  <!-- ############### PROMOCION ########################-->
  <div style="position:absolute; top:102px; left:<%=456-delta%>px; z-index:1" style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  P.Prom.</div>
  <div style="position:absolute; top:100px; left:<%=520-delta%>px; z-index:1; color=#333366; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 20px;"><%=FormatNumber(precio_prom,0)%></div>
  <div style="position:absolute; top:102px; left:<%=630-delta%>px; z-index:1" style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  Dscto.</div>
  <div style="position:absolute; top:105px; left:<%=685-delta%>px; z-index:1; color=#333366; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 16px;"><%=Porcentaje_descuento_promocion%></div>
  <div style="position:absolute; top:98px; left:<%=790-delta%>px; z-index:1; color=#66cc00; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 20px;"><%=left(Nombre_promocion,15)%></div>
  <!-- ############### FIN PROMOCION ########################-->
<%end if%>
<%if precio_may > 0 then%>
  <!-- ############### MAYORISTA ########################-->
  <div style="position:absolute; top:120px; left:<%=456-delta%>px; z-index:1" style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  P.May.</div>
  <div style="position:absolute; top:118px; left:<%=520-delta%>px; z-index:1; color=#333366; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 20px;"><%=FormatNumber(precio_may,0)%></div>
  <div style="position:absolute; top:120px; left:<%=630-delta%>px; z-index:1" style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  Dscto.</div>
  <div style="position:absolute; top:123px; left:<%=685-delta%>px; z-index:1; color=#333366; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 16px;"><%=dscto_may%></div>
  <div style="position:absolute; top:120px; left:<%=780-delta%>px; z-index:1" style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  Cant. Mínima</div>
  <div style="position:absolute; top:118px; left:<%=884-delta%>px; z-index:1; color=#000066; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 20px;"><%=limite_may%></div>
  <!-- ############### FIN MAYORISTA ########################-->
<%end if%>
<div style="position:absolute; top:160px; left:<%=440-delta%>px; z-index:1" style="font-size: 30px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
<img src="consulta stock.gif">
</div>
<%=CajaConBordes(225,450-delta,ancho_caja_bg_derecha,38)%>
<div style="position:absolute; top:230px; left:<%=480-delta%>px; z-index:1" style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Producto
</div>
<div style="position:absolute; top:232px; left:555px; z-index:0; background-color:cccd94;">
     <input id="Cantidad" type="text" name="Cantidad" size="1" maxlength="1" value="" style="background-color:cccd94; border-width:0; color=cccd94;">
</div>
<div style="position:absolute; top:230px; left:560px; z-index:1">
     <input onkeypress="return Valida_AlfaNumerico(event);"
     id="Producto" type="text" name="Producto" size="22" maxlength="20" value="" 
     onchange="javascript:consulta_producto()">
</div>
<%=CajaConBordes(287,450-delta,ancho_caja_bg_derecha,177)%>
<%if Request("Accion") = "Consulta" then%>
<div style="position:absolute; top:287px; left:435px; height:177px; z-index:1; color=#66cc00; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 20px;">
<table width="420" border="0" cellspacing="1" cellpadding="0" bgcolor="#999966">
<tr class="FuenteInput" align="center">
<td width="320"><b>Ubicación</b></td>
<td><b>Stock</b></td>
</tr>
</table>
<div style="overflow:auto; width: 437; height:156px;">
<table width="420" border="0" cellspacing="1" cellpadding="0" bgcolor="#999966">
<%
if Conn.Errors.Count = 0 and Request("Accion") = "Consulta" then
   ColorLinea = "#dcdcbb"
   do while not rs.eof
      if ColorLinea = "#dcdcbb" then
         ColorLinea = "#ededbb"
      else
         ColorLinea = "#dcdcbb"
      end if%>
<tr bgcolor="<%=ColorLinea%>" class="FuenteInput">
    <td align="center" width="320" nowrap><%=replace( trim( rs("Nombre_de_bodega") ) , " ","&nbsp;")%></td>
    <td align="right"><%=trim( formatnumber(rs("Stock_real_en_bodega"),0) )%></td>
</tr> 
<%    rs.movenext
   loop
   rs.close
   set rs = nothing
end if%>
</table>
</div>
<%end if%>
<div style="position:absolute; top:80px; left:<%=450-delta%>px; width:120px; z-index:1; color=#ff0000; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 20px; text-decoration: blink;"><%=MensajeError%></div>
</form>
</body>
</html>
<%
conn.close
set conn = nothing
%>
<script language="JavaScript">
document.formulario.Cantidad.focus();
//document.formulario.Producto.focus();
document.all.Accion.value = "";
var ultimafila="";

function Venta()
{
parent.Botones.location.href = "Botones_Mant_PuntoVentaZF.asp"
window.location.href = 'Mant_PuntoVentaZF.asp'
}

function consulta_producto()
{
document.all.Accion.value = "Consulta";
document.formulario.submit();
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

		if ( TeclaPresionada == 113 ) // F2 vuelve a Ventas
		{
		   Venta();
		}
		if ( TeclaPresionada == 27 ) // Escape - Salida
		{
		   Venta();
		}
		if ( TeclaPresionada == 13 ) // F9 Termina e imprime
		{
		   document.formulario.Cantidad.focus();
		}
	}

	document.onkeydown = getKeycode;
	if (blnNN4) document.captureEvents(Event.KEYDOWN);

  function startTime(){
        var time= new Date();
        hours= time.getHours();
        mins= time.getMinutes();
        secs= time.getSeconds();
        closeTime=hours*3600+mins*60+secs;
        closeTime+=5;  
        Timer();
}

function Timer(){
        var time= new Date();
        hours= time.getHours();
        mins= time.getMinutes();
        secs= time.getSeconds();
        curTime=hours*3600+mins*60+secs
        if (curTime>=closeTime){
                self.close();}
        else{
            window.setTimeout("Timer()",1000)}
}

function Valida_AlfaNumerico(e){
  //Sólo para IE
  //regexp = /\w/;
  regexp = /^[\wñÑ]+$/;
  if(!regexp.test(String.fromCharCode(e.keyCode)))
    return false;
  else
    return true;
}

<%if lStarttime then%>
startTime();
<%end if%>
</script>
