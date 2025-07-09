<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
Cache
set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 3600

MensajeError = ""

on error resume next


sql = "exec CAJ_Obtener_por_direccion_IP '"&session("IP")&"'"

Set Rs = Conn.Execute ( sql )
If Not Rs.Eof then
   bodega = Rs("bodega")
   caja_numero = Rs("caja_numero")
   FolioBoleta = Rs("numero_documento_valorizado")
end if
Rs.Close
Rs = nothing

conn.close
set conn = nothing

location.href = "Mant_PuntoVentaZF.asp?Boleta_actual="&FolioBoleta&"&Fiscal_actual="&caja_numero&"&msg="

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Chequea impresora fiscal</title>
  <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
</head>
<body leftmargin=0 topmargin=0 text="#000000">

<script language="VbScript">
 On Error resume next

 
</script>
</body>
</html>