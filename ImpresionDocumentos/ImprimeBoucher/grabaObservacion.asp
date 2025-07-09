<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <meta http-equiv="content-type" content="text/html; charset=windows-1250">
  <meta http-equiv="Content-Language" content="sk">
  <meta name="generator" content="PSPad editor, www.pspad.com">
  <title></title>
	<link rel="stylesheet" type="text/css" href="css/main.css">
  </head>

<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
</body>

<%

Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=Vp?T+!mZpJds;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"
conn1 = strConnect


sql = "select numero_orden_de_venta from Ordenes_de_Ventas where numero_orden_de_venta = "& Request.Form("numero")
Set rs1 = Server.CreateObject("ADODB.Recordset") 
rs1.Open sql , conn1, , ,adCmdText
if rs1.eof then
  Response.Write("<script language=javascript> alert('Debe Agregar productos primero');window.close(); </script>")
  response.end 
end if

sql = "update Ordenes_de_Ventas set observacion = '"&Request.Form("obs")&"' where numero_orden_de_venta = "& Request.Form("numero")
'Conn1.execute(sql)
Set rs1 = Server.CreateObject("ADODB.Recordset") 
rs1.Open sql , conn1, , ,adCmdText
'response.write rs1("producto")
Response.Write("<script language=javascript> window.close(); </script>")
%>
</html>

