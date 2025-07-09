<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
Cache
set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 3600

MensajeError = ""

on error resume next

cSql = "Exec PAR_ListaParametros 'IMPBOLEVTA'"
Set Rs = Conn.Execute ( cSql )
If Not Rs.Eof then
   Puerto = Rs("Valor_Texto")
else
   Puerto = "COM1"
end if
Rs.Close
Puerto = trim( replace( ucase( Puerto ) , "COM" , "" ) )

conn.close
set conn = nothing
if session("IP") = "192.168.0.218" or Session("Login") = "10027765" or Session("Login") = "13971354" or Session("Login") = "15308847" or Session("Login") = "15309968" or Session("Login") = "15711196" or Session("Login") = "15923212" or Session("Login") = "13859206"  or Session("Login") = "17629393" or Session("Login") = "17587517" or Session("Login") = "9926612" then
  '*************************************************************************
  'Comentar esta línea para que funciones la validación de la impresora
  'Response.Redirect "Mant_PuntoVentaZF.asp?Boleta_actual=0&Fiscal_actual=0"
  '************************************************************************
end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Chequea impresora fiscal</title>
  <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
</head>
<body leftmargin=0 topmargin=0 text="#000000">

<script language="VbScript">
 
    parent.top.frames(1).location.href = "Mant_IF.asp"
 
</script>
</body>
</html>
