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
<%
Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=Vp?T+!mZpJds;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"
conn1 = strConnect
sql = "select isnull(observacion,'') observacion from Ordenes_de_Ventas where numero_orden_de_venta = "& request("Numero_nota_de_venta")
Set rs1 = Server.CreateObject("ADODB.Recordset") 
rs1.Open sql , conn1, , ,adCmdText
if rs1.eof then
  Observacion = ""
else
  Observacion = rs1("observacion")
end if
%>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
 	<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr class="FuenteEncabezados"> 
				<td width=100% class="FuenteTitulosFunciones" align=center><a href="javascript:window.close();"><%=Session("title")%></a></td>
			</tr>
	</table>
	<form id="grabaObservacion" name="grabaObservacion" method="post" action="grabaObservacion.asp">
	 <input type = Hidden id="numero" name="numero" value = '<%=request("Numero_nota_de_venta")%>'>
  	<table border = 0 align="center">
  	  <tr>
  	    <td align="center">
  	      <textarea rows="2" cols="25" name = "obs" id="obs" maxlength=0 ><%=Observacion%></textarea>
        </td>
      </tr>
      <tr>
        <td align="center">
          <input type="button" value="Grabar Observación" OnClick="Graba_Observacion()">
        </td>
      </tr>
	 </table>
	</form>
</body>
</html>
<script>
function  Graba_Observacion(){
     
     grabaObservacion.submit()
}
</script>
