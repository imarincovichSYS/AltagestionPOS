<%
titulo = "Consulta"
%>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
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
<body onload="codigo.focus()">
<br>
<table id="table_enc" width="220" cellPadding="0" cellSpacing="0" align="center">
<tr align="center">
  <td id="texto_10">
  <b>CONSULTA PRODUCTO</b>
  </td>
</tr>
<tr>
  <td id="texto_8">&nbsp;PRODUCTO:
  &nbsp;
  <input OnClick="this.value=''" onkeyUp="SetKey(event);if(key==13)Datos_Producto();"
  type="text" id="codigo" name="codigo" maxlength="20" style="width:100px;">
  </td>
</tr>
<tr height="166">
  <td id="td_datos" name="td_datos"></td>
</tr>
</table>
<script language="javascript">
function Datos_Producto(){
  codigo_tmp = $("codigo").value
  //codigo.value = ""
  strCargando ="<center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Consultando...espere un momento</b></font><br><br></center>"
  td_datos.innerHTML    = strCargando
  var ajx = new Ajax("lector_consulta_productos_datos.asp",{
    method:'post', 
    data: 'codigo='+codigo_tmp,
    update:$("td_datos"),
    onComplete: function(respuesta){
      //alert(respuesta)
      $("codigo").value=""
    }
  });
  ajx.request();
}
</script>
</body>
</html>