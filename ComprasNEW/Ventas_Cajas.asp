<%
titulo = "Ventas Cajas"
%>
<!--#include file="../_private/config.asp" -->
<html>
<head>
<title>AltaGestión - <%=titulo%></title>
<script language="JavaScript">
var RutaProyecto  = "<%=RutaProyecto%>";
</script>
<link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">
<script language="JavaScript" src="<%=RutaProyecto%>js/tools.js"></script>
<script language="javascript" src="<%=RutaProyecto%>js/mootools-1.11.js"></script>
</head>
<body>
<br>
<table id="table_enc" width="100" border=1 bordercolor="#000000" cellPadding="0" cellSpacing="0" align="center">
<tr align="center">
  <td style="font-size:26px;"><b>1</b></td>
</tr>
<tr height="60">
  <td id="td_datos" name="td_datos"></td>
</tr>
</table>
<script language="javascript">
function Datos_Caja(){
  strCargando ="<center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Consultando caja...</b></font><br><br></center>"
  td_datos.innerHTML    = strCargando
  var ajx = new Ajax("ventas_cajas_datos.asp",{
    method:'post', 
    data: '',
    update:$("td_datos"),
    onComplete: function(respuesta){
      //alert(respuesta)
    }
  });
  ajx.request();
}
Datos_Caja()
</script>
</body>
</html>