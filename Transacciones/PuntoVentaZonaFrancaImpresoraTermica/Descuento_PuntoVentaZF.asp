<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")

Imagen_actual = "sinimagen.jpg"
Linea = 0

on error resume next

Function CajaConBordes(nTop,nLeft,nWidth,nHeight)
  CajaConBordes = "<div style='position:absolute; top:" & (nTop - 10) & "px; left:" & (nLeft -10) & "px; width:" & (nWidth + 20) & "px; height:" & (nHeight + 20) & "px; z-index:0' style='border: 2px #808080 solid'></div>" & chr(13) & chr(10) & _
         "<div style='position:absolute; top:" & (nTop - 2) & "px; left:" & (nLeft - 2) & "px; width:" & (nWidth + 4) & "px; height:" & (nHeight + 4) & "px; z-index:0' style='border: 1px #999999 solid'></div>" & chr(13) & chr(10) & _
         "<div style='position:absolute; top:" & nTop & "px; left:" & nLeft & "px; width:" & nWidth & "px; height:" & nHeight & "px; z-index:0' style='background-color:#CCCD94;'></div>"
  CajaConBordes = replace( CajaConBordes , "'" , chr(34) )
End Function

' Descuento Funcionario
Porcentaje_descuento_institucional = 0
Set rs = Conn.execute("EXEC PUN_Descuento_institucional '" & Session("Cliente_boleta") & "'" )
if not rs.eof then
   Porcentaje_descuento_institucional = cdbl( rs("Maximo_porcentaje_descuento_autorizado") )
end if
rs.close
set rs = nothing

' Descuento Cajera 
Maximo_descuento_cajera = 0
Set rs = Conn.execute("EXEC PUN_Descuentos_cajera '" & trim(Session("Login")) & "'" )
if not rs.eof then
   Maximo_descuento_cajera = cdbl( rs("Porcentaje_descuento_maximo_permitido_para_vender") )
end if
rs.close
set rs = nothing

' Descuento Cliente - En esta pantalla corresponde al descuento del documento si Forma de Pago lo permite
Descuento_documento = 0
Set rs = Conn.execute("EXEC PUN_Descuento_cliente '" & Session("Cliente_boleta") & "'" )
if not rs.eof then
   Descuento_documento = cdbl( rs("Maximo_porcentaje_descuento_autorizado") )
end if
rs.close
set rs = nothing

Maximo_descuento_cabecera = 0
Set rs = Conn.execute("EXEC PUN_Maximo_descuento_cabecera" )
if not rs.eof then
   Maximo_descuento_cabecera = cdbl( rs("Valor_numerico") )
end if
rs.close
set rs = nothing

Maximo_descuento_linea = 0
Set rs = Conn.execute("EXEC PUN_Maximo_descuento_linea" )
if not rs.eof then
   Maximo_descuento_linea = cdbl( rs("Valor_numerico") )
end if
rs.close
set rs = nothing

Precio_de_lista_modificado = 0
Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'" )
do while not rs.eof
   Codigo_producto = trim( rs("Producto") )
   Imagen_actual = Codigo_producto & ".jpg"
   Nombre_producto = trim( rs("Nombre_producto") )
   Precio_de_lista_modificado = cdbl( rs("Precio_de_lista_modificado") )
   Porcentaje_descuento_promocion = cdbl( rs("Porcentaje_descuento_1") )
   Nombre_promocion = trim( rs("Nombre_promocion") )
   rs.movenext
loop
rs.close
set rs = nothing

if Precio_de_lista_modificado > 0 then
   if Request("Accion") = "CambiaPrecio" then
      'Descuento = ( 1 - ( cdbl( Request("Precio") ) / Precio_de_lista_modificado ) ) * 100
      Descuento = ( 1 - ( cdbl( Request("Precio") ) / Precio_de_lista_modificado ) ) * 100 - Descuento_documento
   else
      Descuento = cdbl( Request("Descuento") )
   end if
   if Porcentaje_descuento_institucional > Descuento then
      Descuento = Porcentaje_descuento_institucional
   end if
   if Porcentaje_descuento_promocion > Descuento then
      Descuento = Porcentaje_descuento_promocion
   end if
   if Descuento < 0 then
      Descuento = 0
   end if
   Conn.execute( "Exec MOP_Modifica_descuento_linea_DVT '" & _
                          Session("Login") & "',0" & _
                          Request("Linea") & ",0" & _
                          Descuento )
end if

Descuento_linea = 0
Precio = 0
Total_pesos = 0

Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'" )
do while not rs.eof
   Precio_de_lista_modificado = trim( rs("Precio_de_lista_modificado") )
   Descuento_linea = Descuento_documento + cdbl(rs("Porcentaje_descuento_2"))
   Precio = cdbl( rs("Precio_de_lista_modificado") )
   Precio = ( Precio * ( ( 100 - Descuento_linea ) / 100 ) \ 1 )
   Total_pesos = Total_pesos + ( cint(rs("Cantidad_salida")) * Precio )
   
   Linea = rs("Numero_de_linea")
   rs.movenext
loop
rs.close
set rs = nothing

Session("MensajeError") = LimpiaError(MensajeError)
if len(trim(Session("MensajeError"))) > 0 then MensajeError = "ERROR : " & left( Session("MensajeError") , 35 )

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Descuento producto</title>
	<link rel="stylesheet" type="text/css" href="estilos.css">	
</head>
<body bgcolor="" leftmargin="0" topmargin="0" text="#000000">

<form name="formulario" method="post" action="Descuento_PuntoVentaZF.asp">

<input type="hidden" name="Accion" id="Accion" value="">
<input type="hidden" name="Linea" id="Linea" value="<%=Linea%>">

<%=CajaConBordes(24,27,400,418)%>
<div style="position:absolute; top:25px; left:28px; z-index:1"><img id="imagen" src="<%=Imagen_actual%>" alt="Imagen producto" width="398" height="416" border="0"/></div>

<%=CajaConBordes(25,470,450,120)%>
<div style="position:absolute; top:35px; left:480px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Precio<br>
Descripción<br>
</div>
<div style="position:absolute; top:35px; left:670px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
&nbsp;Código
</div>
<div style="position:absolute; top:35px; left:540px; z-index:1; color=#ffff99; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 20px;"><%=formatnumber(Precio_de_lista_modificado,0)%></div>
<div style="position:absolute; top:35px; left:760px; z-index:1; color=#6699ff; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=Codigo_producto%></div>
<div style="position:absolute; top:80px; left:480px; width=420px; z-index:1; color=#66cc00; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=Nombre_producto%></div>

<%=CajaConBordes(190,470,450,250)%>
<div style="position:absolute; top:200px; left:480px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 170%;">
% Descuento documento<br>
Precio con descuento<br>
% Descuento aplicado<br>
% Descuento institucional<br>
% Descuento promocional<br><br>
Precio final
</div>
<div style="position:absolute; top:35px; left:670px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
&nbsp;Código
</div>
<div style="position:absolute; top:200px; left:720px; z-index:1; color=#ffff33; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=Descuento_documento%></div>

<div style="position:absolute; top:230px; left:720px; z-index:1">
     <input id="Precio" type="text" name="Precio" size="12" maxlength="10" value="<%=Precio%>" onchange="javascript:cambia_precio()"><br>
     <input id="Descuento" type="text" name="Descuento" size="12" maxlength="10" value="<%=formatnumber(Descuento,2)%>" onchange="javascript:cambia_descuento()" onblur="document.formulario.Precio.focus();">
</div>
<div style="position:absolute; top:280px; left:720px; z-index:1; color=#ffff33; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=Porcentaje_descuento_institucional%></div>
<div style="position:absolute; top:305px; left:720px; z-index:1; color=#ffff33; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=Porcentaje_descuento_promocion%></div>
<div style="position:absolute; top:330px; left:480px; z-index:1; color=#66cc00; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px;"><%=Nombre_promocion%>promocion</div>
<div style="position:absolute; top:380px; left:480px; z-index:1; color=#ffff33; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 40px;"><%=replace(formatnumber(Total_pesos,0),",",".")%></div>

<div style="position:absolute; top:60px; left:520px; width=320px; z-index:1; color=#ff0000; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 20px; text-decoration: blink;"><%=MensajeError%></div>

<div style="position:absolute; top:60px; left:520px; width=320px; z-index:1;">
 <a href="javascript:ventanitaerror()" style="color:#ff0000; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 16px; text-decoration: blink;"><%=MensajeError%></a>
</div>

</form>

</body>
</html>
<%
conn.close
set conn = nothing
%>
<script language="JavaScript">
document.formulario.Precio.focus();
document.all.Accion.value = "";
var ultimafila="";

function cambia_precio()
{
document.all.Accion.value = "CambiaPrecio";
document.formulario.submit();
}
function cambia_descuento()
{
document.all.Accion.value = "CambiaDescuento";
document.formulario.submit();
}
function Venta()
{
parent.Botones.location.href = "Botones_Mant_PuntoVentaZF.asp"
window.location.href = 'Mant_PuntoVentaZF.asp'
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

		if ( TeclaPresionada == 120 ) // F9 Vuelve a ventas
		{
		   Venta();
		}
		if ( TeclaPresionada == 27 ) // Escape - Salida
		{
		   Venta();
		}

	}

	document.onkeydown = getKeycode;
	if (blnNN4) document.captureEvents(Event.KEYDOWN);

function ventanitaerror()
{
var ventana = window.open('Ventanita_error_PuntoVentaZF.asp','error','height=200,width=500,scrollbars=no,location=no,directories=no,status=yes,menubar=no,toolbar=no,resizable=yes,title=no,dependent=yes');
}
</script>
