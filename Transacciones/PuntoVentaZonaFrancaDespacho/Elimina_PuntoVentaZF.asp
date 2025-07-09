<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../_private/funciones_sys.asp" -->
<%
    Cache

   if len(trim( Session( "DataConn_ConnectionString") )) = 0 then%>
    <script language=javascript>
    	parent.top.location.href = "../../index.htm"
    </script>
<% end if

set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")

'**********************************************
on error resume next 
'No sacar porque hay un error en la eliminacion de 1 producto "PPE_Modificacion_en_producto_vendido"
'La solución es pasarle el "Codigo_producto = trim( rs("Producto") )" y no el request("producto")
'se cae porque intenta grabar el codigo de producto con numeros del codigo de barra
'**********************************************

Function CajaConBordes(nTop,nLeft,nWidth,nHeight)
  CajaConBordes = "<div style='position:absolute; top:" & (nTop - 10) & "px; left:" & (nLeft -10) & "px; width:" & (nWidth + 20) & "px; height:" & (nHeight + 20) & "px; z-index:0' style='border: 2px #808080 solid'></div>" & chr(13) & chr(10) & _
         "<div style='position:absolute; top:" & (nTop - 2) & "px; left:" & (nLeft - 2) & "px; width:" & (nWidth + 4) & "px; height:" & (nHeight + 4) & "px; z-index:0' style='border: 1px #999999 solid'></div>" & chr(13) & chr(10) & _
         "<div style='position:absolute; top:" & nTop & "px; left:" & nLeft & "px; width:" & nWidth & "px; height:" & nHeight & "px; z-index:0' style='background-color:#CCCD94;'></div>"
  CajaConBordes = replace( CajaConBordes , "'" , chr(34) )
End Function

lStarttime = false

' La cajera tiene permiso para eliminar
Maximo_descuento_cajera = 0
Set rs = Conn.execute("EXEC PUN_Permite_eliminar_cajera '" & trim(Session("Login")) & "'" )
if not rs.eof then
   Elimina_producto = rs("Elimina_producto")
end if
rs.close
set rs = nothing

' Clave del sistema para eliminar si la cajera no tiene permiso
if Elimina_producto = "N" then
   Set rs = Conn.execute("EXEC PUN_Clave_eliminacion_producto_supervisor" )
   if not rs.eof then
      Password = trim( rs("Valor_texto") )
   else
      Password = "***"
   end if
   rs.close
   set rs = nothing
else
   Password = ""
end if

function Get_Numero_Interno_DVT_Activa_X_Login(v_login)
	'strSQL="select numero_interno_dvt_activa resultado from entidades_comerciales " &_
	'       "where empresa='SYS' and rtrim(ltrim(entidad_comercial))='"&trim(v_login)&"'"
  strSQL="select numero_interno_dvt_activa resultado from entidades_comerciales with(nolock) " &_
	       "where empresa='SYS' and entidad_comercial='"&trim(v_login)&"'"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	Get_Numero_Interno_DVT_Activa_X_Login = resultado
end function

function Get_Cod_Temporada_X_Producto(v_producto)
	strSQL="select temporada resultado from productos with(nolock) where empresa='SYS' and producto='"&v_producto&"'"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = Ucase(trim(rs_get("resultado")))
	Get_Cod_Temporada_X_Producto = resultado
end function

function Get_Tipo_Lista_Precio_X_Cliente(v_rut_cliente)
	strSQL="select lista_de_precios resultado from vigencias_de_listas_de_precios with(nolock) " &_
	       "where empresa='SYS' and entidad_comercial='"&v_rut_cliente&"'"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
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
	Get_Precio_Normal_X_Producto = resultado
end function

function Get_Total_Precio_Mayoristas_Lista_DVT(v_num_int_DVT_activa)
	strSQL="select Sum(cantidad_salida*precio_de_lista_modificado) resultado from movimientos_productos with(nolock) " &_
	       "where empresa='SYS' and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" " &_
	       "and (temporada='XMAY' or temporada='PATG' or temporada='NOV' or temporada='CHAO')"
	set rs_get = Conn.Execute(strSQL) : resultado = ""
	if not rs_get.EOF then resultado = rs_get("resultado")
	Get_Total_Precio_Mayoristas_Lista_DVT = resultado
end function

'if Request("Accion") & Request("Password") = "Elimina" & Password then
if Request("Accion") = "Elimina_Todos" then
	v_num_int_DVT_activa = Get_Numero_Interno_DVT_Activa_X_Login(Session("Login"))
	strSQL="delete movimientos_productos where empresa='SYS' and documento_no_valorizado='DVT' and " &_
	       "numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
	set rs_graba = Conn.execute(strSQL)
	strSQL="update entidades_comerciales set numero_interno_dvt_activa=null " &_
	       "where empresa='SYS' and entidad_comercial='"&Session("Login")&"'"
	set rs_graba = Conn.execute(strSQL)
	
	'################################################################
  '##### RESETEA LA OPCION DE DESCUENTOS MANUALES DE CAJERA #######
  if Session("Login") <> "10027765" and Session("Login") <> "13884785" and Session("Login") <> "15308847" and Session("Login") = "15309968" and Session("Login") = "15711196" and Session("Login") = "15923212" and Session("Login") = "13859206"  and Session("Login") = "17629393" and Session("Login") = "17587517" and Session("Login") = "9926612" then
    Session("Muestra_descuentos") = ""
  end if
  '################################################################
	
	Response.Redirect "Main_PuntoVentaZF.asp"
elseif Request("Accion") = "Elimina" then
    lStarttime = true 

    cSql = "Exec MOP_Consulta_producto '" 
    cSql = cSql & trim(Session("xBodega")) & "', '"
    cSql = cSql & trim(Session("xCentro_de_venta")) & "', '"
    cSql = cSql & Session("Cliente_boleta") & "', '"
    cSql = cSql & Session("Empresa_usuario") & "', '"
    cSql = cSql & Request("Producto") & "', '"
    cSql = cSql & Session("Login") & "', 1"
 
   Set rs = Conn.execute( cSql )

    if Conn.Errors.Count = 0 then
        v_num_int_DVT_activa  = Get_Numero_Interno_DVT_Activa_X_Login(Session("Login"))
        
        Es_Kit = rs("Es_KIT")
        Codigo_producto = trim( rs("Producto") )
        Stock_real_en_bodega = trim( rs("Stock_real_en_bodega") )
        Porcentaje_descuento_promocion = trim( rs("Porcentaje_descuento_promocion") )
        Nombre_promocion = trim( rs("Nombre_promocion") )
        rs.close
        set rs = nothing

        cSql = "Exec PPE_Modificacion_en_producto_vendido '" & Session("Empresa_usuario") & "', "
        cSql = cSql & "'" & Session("Login")    & "', "
        cSql = cSql & "'" & Request("Producto") & "', "
        cSql = cSql & "0" & ( Request("Cantidad") \ 1 ) & ", "
        cSql = cSql & "'" & Session("Supervisor_elimina") & "'"
        Conn.Execute ( cSql )

        'Sql = "Exec MOP_Elimina_detalle_DVT_en_RCP '" & _
        Sql = "Exec MOP_Elimina_detalle_DVT_en_RCP '" & _
                              trim(Session("xBodega")) & "'," & _
                              ( Request("Cantidad") \ 1 ) & ",'" & _
                              trim(Session("xCentro_de_venta")) & "','" & _
                              Session("Cliente_boleta") & "', '" & _
                              Session("Empresa_usuario") & "', '" & _
                              Request("Producto") & "', " & _
                              "null" & ", '" & _
                              Session("Login") & "'," & _
                              "0" & cDbl(Session("Tipo_cambio_boleta")) & ", '" & Es_Kit & "'"
                       
        Conn.execute( Sql )
        if Conn.Errors.Count <> 0 then
          MensajeError = Err.Description
          Eliminado = false
        else  
          'Response.Write v_num_int_DVT_activa
          'Response.End
		      if Session("Cliente_boleta") <> "CLI_BOLETA" then
            v_tipEntComer = Session("tipo_entidad_comercial")
            v_clasDeEmpleado = Session("clasificacion_de_empleado")
            'if v_tipEntComer <> "A" and v_tipEntComer <> "E" and v_tipEntComer <> "U" then
            if v_tipEntComer = "C" or (v_tipEntComer = "A" and v_clasDeEmpleado="") then
              v_temporada			      = Get_Cod_Temporada_X_Producto(Codigo_producto)
		          v_tipo_lista_precio	  = Get_Tipo_Lista_Precio_X_Cliente(Session("Cliente_boleta"))    
		          if (v_temporada="XMAY" or v_temporada="PATG" or v_temporada="NOV" or v_temporada="CHAO") and v_tipo_lista_precio="LXMAY" then 'Es producto Mayorista y el cliente está asociada a una lista mayorista
			          strSQL="select IsNull(A.cantidad_salida,0) cantidad, B.valor_unitario,B.limite_precio from " &_
			                 "(select cantidad_salida from movimientos_productos with(nolock) " &_
			                 "where empresa='SYS' and documento_no_valorizado='DVT' and producto='"&Codigo_producto&"' " &_
			                 "and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&") A," &_
			                 "(select valor_unitario, limite_precio from productos_en_listas_de_precios with(nolock) " &_
			                 "where empresa='SYS' and producto='"&Codigo_producto&"' " &_
			                 "and lista_de_precios='LXMAY' and limite_precio>0) B"
			          set rs_cant = Conn.Execute(strSQL)
			          if not rs_cant.EOF then 
				          v_cant				    = rs_cant("cantidad")
				          v_valor_unitario  = rs_cant("valor_unitario")
				          v_limite_precio		= rs_cant("limite_precio")				
				          v_precio_normal   = Get_Precio_Normal_X_Producto(Codigo_producto)
				          if cdbl(v_limite_precio) > cdbl(v_cant) then
				          	'Se disminuyo la cantidad mas que el limite, no corresponde precio mayorista
				          	'-->Se debe volver al precio normal
				          	'El campo temporada se hace nulo cada vez que se elimina un producto a través de un 
				          	'trigger o procedure (no encontrado aún) pero de todas maneras se vuelve a poner en null
				          	strSQL="update movimientos_productos set precio_de_lista="&v_precio_normal&", " &_
				          	       "precio_de_lista_modificado="&v_precio_normal&", " &_
				          	       "temporada=null, producto=producto where empresa='SYS' and " &_
				          	       "documento_no_valorizado='DVT' and producto='"&Codigo_producto&"' " &_
				          	       "and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
				          else
				            'Se debe actualizar el campo temporada y precio_de_lista ya que existe un trigger o procedimiento (no encontrado aún)
				            'que actualizar el campo y lo deja como NULL, lo que hace que se pierdan los movimientos que cumplen
				            'la condición de mayorista. Este evento valida de todas formas el precio_de_lista_modificado y lo deja 
				            'con el valor que corresponde (en este caso con el precio de la condición mayorista)
				            strSQL="update movimientos_productos set precio_de_lista="&v_precio_normal&", " &_
				          	       "precio_de_lista_modificado="&v_valor_unitario&", temporada='"&v_temporada&"', producto=producto " &_
				          	       "where empresa='SYS' and documento_no_valorizado='DVT' and producto='"&Codigo_producto&"' " &_
				          	       "and numero_interno_documento_no_valorizado="&v_num_int_DVT_activa
				          end if
				          Conn.Execute(strSQL)
			          end if
			          'Verificar el tramo del "total de venta mayorista" para aplicar el descuento correspondiente al Tramo (update A todos los productos MAY)
	          		Total_Precio_Mayoristas = Get_Total_Precio_Mayoristas_Lista_DVT(v_num_int_DVT_activa)
	          		'Total_Precio_Mayoristas = 250000
	          		Tramos = split(session("TramosMayorista"),"@")
	          		Band_Aplico_Dscto_Tramo = false
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
	                         "numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" and (temporada is not null and temporada <> 'ECO')"
	          		    Conn.Execute(strSQL)
	          		    Band_Aplico_Dscto_Tramo = true
	          		    exit for
	          		  end if
	          		next
	          		if not Band_Aplico_Dscto_Tramo then 'No se aplicó el descuento del tramo porque el total precio mayorista está entre 30.000 y el piso del primer tramo (por ahora 50.000)
	          		  strSQL="update movimientos_productos set precio_de_lista_modificado = " &_
	                       "(select valor_unitario from productos_en_listas_de_precios with(nolock) where empresa='SYS' and lista_de_precios='LXMAY' and limite_precio>0 and " &_
	                       "productos_en_listas_de_precios.producto=movimientos_productos.producto), producto=producto " &_
	                       "where empresa='SYS' and documento_no_valorizado='DVT' and " &_
	                       "numero_interno_documento_no_valorizado="&v_num_int_DVT_activa&" and (temporada is not null and temporada<>'ECO')"
	          		  'Response.Write strSQL
	          		  'Response.End
	          		  Conn.Execute(strSQL)
	          		end if
		          end if
		        end if
		      end if
		      
		      if session("elimina_producto") = "N" then 
		        'BITACORARIZAR
		        strSQL="insert into zbitacoraElimina_productos(numero_interno_documento_no_valorizado, fecha_hora, producto, cantidad, " &_
		               "empleado_responsable, cliente, ip, centro_de_venta, autorizadopor) " &_
                   "values ("&v_num_int_DVT_activa&", getdate(), '"&Codigo_producto&"', "&Request("Cantidad")&", " &_
                   "'"&Session("Login")&"', '"&Session("Cliente_boleta")&"', " &_
                   "'"&Request.ServerVariables("REMOTE_ADDR")&"', '"&trim(Session("xCentro_de_venta"))&"','"&session("autorizadopor")&"')"
            'Response.Write strSQL & " " & session("producto_eliminado")
            'Response.End
            Conn.Execute(strSQL)
          end if
		      session("producto_eliminado") = cdbl(session("producto_eliminado")) + 1
			    Eliminado = true
        end if          
   else
      MensajeError = Err.Description
      Eliminado = false
   end if
   
Session("MensajeError") = LimpiaError(MensajeError)
if len(trim(Session("MensajeError"))) > 0 then MensajeError = "ERROR : " & left( Session("MensajeError") , 80 )
end if

'Obtener parametros de eliminación
DELCANTXPROD  = Get_Valor_Numerico_X_Parametro("DELCANTXPROD")
DELPRECIO     = Get_Valor_Numerico_X_Parametro("DELPRECIO")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Elimina producto</title>
	<link rel="stylesheet" type="text/css" href="estilos.css">
	<script language="javascript" src="../../js/mootools-1.11.js"></script>
</head>
<%if lStarttime then%>
  <body bgcolor="" leftmargin="0" topmargin="0" text="#000000" onLoad="startTime();document.formulario.Cantidad.focus();">
<%else%>
  <body bgcolor="" leftmargin="0" topmargin="0" text="#000000">
<%end if%>
<form name="formulario" method="post" action="Elimina_PuntoVentaZF.asp">
<input type="hidden" name="Accion" id="Accion" value="">

<div style="position:absolute; top:70px; left:260px; z-index:1" style="font-size: 22px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
  <img SRC="ELIMINA PRODUCTO.gif">
</div>

<%if Elimina_producto = "S" then%>
  <%=CajaConBordes(180,300,400,120)%>
<%else %>
  <%=CajaConBordes(180,300,400,120)%>  
<%end if%>
<div style="position:absolute; top:217px; left:310px; z-index:1" style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Cantidad<br>
Producto
</div>
<div style="position:absolute; top:217px; left:390px; z-index:2">
     <input onkeypress="return Valida_Digito(event);"
     id="Cantidad" OnFocus="select()" type="text" name="Cantidad" size="6" maxlength="6" value="1"><br>
     <input onkeypress="return Valida_AlfaNumerico(event);"
     id="Producto" type="text" name="Producto" size="22" maxlength="20" value="" onchange="javascript:elimina_producto()">
</div>
<div style="position:absolute; top:280px; left:350px; z-index:1">

</div>

<div align="center" style="position:absolute; top:320px; left:290px; z-index:2">
<input type="button" style="width: 420px; font-size: 22px;"
OnClick="javascript:Eliminar_Todos()" OnMouseOver="this.style.cursor='hand'"
value="ELIMINAR TODOS LOS PRODUCTOS" id="bot_eliminar_todos" name="bot_eliminar_todos">
</div>
<div style="position:absolute; top:360px; left:100px; width=810px; z-index:1;">
 <a href="javascript:ventanitaerror()" 
 style="color:#ff0000; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 16px; text-decoration: blink;">
 <label id="label_MensajeError" name="label_MensajeError"><%=MensajeError%></label></a>
</div>

</form>

</body>
</html>
<%
conn.close
set conn = nothing
%>
<script language="JavaScript">
var DELCANTXPROD  = "<%=DELCANTXPROD%>"
var DELPRECIO     = "<%=DELPRECIO%>"

<%if Eliminado then%>
  Venta();
<%elseif Elimina_producto = "S" then%>
  document.formulario.Cantidad.focus();
<%end if%>

document.formulario.Cantidad.focus();
document.all.Accion.value = "";

function Venta()
{
  parent.Botones.location.href = "Botones_Mant_PuntoVentaZF.asp"
  window.location.href = 'Mant_PuntoVentaZF.asp'
}

function Solicita_Autorizacion(){
  var sValue = undefined;        
  do
  {
      var sValue = window.showModalDialog ("LoginSupervisor_PuntoVentaZF.asp", "valor", "dialogWidth:20;dialogHeight:20;center:yes;edge:sunken;unadorned:yes;status:no;help:no;")
  }
  while(sValue == undefined);
  return sValue
}

function elimina_producto(){
  if(document.formulario.Producto.value!="")
  {
    <%if session("elimina_producto") = "N" then%>
      band_pide_pass_supervisor = false
      var ajx = new Ajax("Elimina_PuntoVentaZF_Consulta.asp",{
        method:'post', 
        data: 'producto='+escape(document.formulario.Producto.value),
        async:false,
        onComplete: function(respuesta)
        {
          //alert(respuesta)
          var array1 = respuesta.split("~")
          v_accion  = array1[0]
          v_msg     = array1[1]
          if(v_accion == "OK")
          {
            precio_producto = parseFloat(v_msg)
            if(parseInt(document.formulario.Cantidad.value) > parseInt(DELCANTXPROD))
            {
              band_pide_pass_supervisor = true
              v_msg = "No se puede eliminar mas de "+DELCANTXPROD+" unidades. Solicite autorización de supervisor"
            }
            else if(precio_producto > parseFloat(DELPRECIO))
            {
              band_pide_pass_supervisor = true
              v_msg = "Precio supera el máximo permitido para eliminar. Solicite autorización de supervisor"
            }
            
            if(band_pide_pass_supervisor)
            {
              label_MensajeError.innerText  = v_msg
              resp = Solicita_Autorizacion()
              if ( resp != 2 )
              {
                label_MensajeError.innerText  = ""
                document.all.Accion.value     = "Elimina";
                document.formulario.submit();
              }
              else
              {
                document.all.Accion.value = ""
                document.formulario.submit()
              }
            }
            else
            {
              label_MensajeError.innerText  = ""
              document.all.Accion.value     = "Elimina";
              document.formulario.submit();
            }
          }
          else
          {
            label_MensajeError.innerText  = v_msg
            document.formulario.Cantidad.focus()
          }
        }
      });
      ajx.request();
    <%else ' S %>
      label_MensajeError.innerText  = ""
      document.all.Accion.value     = "Elimina";
      document.formulario.submit();
    <%end if%>
  }
}

/*function elimina_producto()
{
  document.all.Accion.value = "Elimina";
  document.formulario.submit();
}*/

var blnDOM = false, blnIE4 = false, blnNN4 = false; 

if (document.layers) 
  blnNN4 = true;
else if (document.all) 
  blnIE4 = true;
else if (document.getElementById) 
  blnDOM = true;

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

	if (TeclaPresionada == 119 || TeclaPresionada == 27) // F8 Vuelve a Ventas || Escape - Salida
	  Venta();
}

document.onkeydown = getKeycode;
if (blnNN4) document.captureEvents(Event.KEYDOWN);

function startTime(){
  var time= new Date();
  hours= time.getHours();
  mins= time.getMinutes();
  secs= time.getSeconds();
  closeTime=hours*3600+mins*60+secs;
  closeTime+=2;  
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

function ventanitaerror()
{
  var ventana = window.open('Ventanita_error_PuntoVentaZF.asp','error','height=200,width=500,scrollbars=no,location=no,directories=no,status=yes,menubar=no,toolbar=no,resizable=yes,title=no,dependent=yes');
}

function Eliminar_Todos(){
  resp = 1
  <%if session("elimina_producto") = "N" then%>
    //resp = Solicita_Autorizacion()
  <%end if%>
  if ( resp != 2 )
  {
	  if(confirm("¿Está seguro que desea eliminar todos los productos?"))
	  {
	  	document.all.Accion.value	= "Elimina_Todos";
      document.formulario.submit();
	  }
	}
}

function Valida_Digito(e){
  //Sólo para IE
  regexp = /\d/;
  if(!regexp.test(String.fromCharCode(e.keyCode)))
    return false;
  else
    return true;
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
</script>
