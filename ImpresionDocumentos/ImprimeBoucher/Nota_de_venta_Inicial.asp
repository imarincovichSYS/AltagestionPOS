<%
titulo = "Consulta Precio"
Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"
conn1 = strConnect
Set rs1 = Server.CreateObject("ADODB.Recordset")
%>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
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

  <table id="table_enc" name = "table_enc" width="300" cellPadding="0" cellSpacing="0" align="center" border = 0>
  <tr align="center">
    <td id="texto_14" name = "texto_10" colspan = 2>
    <b>NOTAS DE VENTA</b>
    </td>
  </tr>
  <tr>
    <td id="texto_12" name = "texto_8" style="width:140px;">&nbsp;Número
    &nbsp;
    <input OnClick="this.value='';Cliente_nn.value=''" onkeyUp="SetKey(event);if(key==13)Datos_Producto(this.value);" onkeypress="return Valida_Digito(event);"
    type="text" id="codigo" name="codigo" maxlength="20" style="width:80px;" value="">
    </td>
  </tr>
  <tr>
    <td id="texto_12" name = "texto_8" style="width:140px;">&nbsp;Cliente&nbsp;&nbsp;&nbsp;&nbsp;
      <input OnClick="this.value='';codigo.value=''" onkeyUp="SetKey(event);if(key==13)inserta_nueva_nota_de_venta();" onkeypress="return Valida_Digito(event);"
      type="text" id="Cliente_nn" name="Cliente_nn" maxlength="20" style="width:80px;" value="">&nbsp;
    </td>
    <td style="width:120px;">
      <img 
      OnClick="inserta_nueva_nota_de_venta();"
      title="Nueva Nota de Venta" OnMOuseOver="this.style.cursor='hand'" src="Ico_Nuevo_24X24_on.gif" width="24" height="24" border=0>&nbsp;
    </td>
  </tr>
  
  <tr height="145" align="center">
    <td valign="top" id="td_datos" name="td_datos" colspan = 2></td>
  </tr>
  </table>
  <form id="form_nueva_Nota_de_venta" name="form_nueva_Nota_de_venta" method="post" action="Mantencion_productos_Nota_de_venta.asp"> 
      <input type="hidden" id="num_n_de_venta" name="num_n_de_venta" value="0">
      <input type="hidden" id="cliente_nota_de_venta" name="cliente_nota_de_venta" value ="0">
  </form>
<script language="javascript">

function Datos_Producto(codigo_tmp){
  Cliente_nn.value = "" 
  if (codigo.value != "")
  { 
    strCargando ="<center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' "
    strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Consultando...espere un momento</b></font><br><br></center>"
    td_datos.innerHTML    = strCargando
    var ajx = new Ajax("Busca_Nota_de_venta.asp",{
      method:'post', 
      data: 'numero_nota_de_venta='+codigo_tmp,
      update:$("td_datos"),
      onComplete: function(respuesta){
        //alert(respuesta)
        codigo.value=""
        codigo.focus()
      }
    });
    ajx.request();
  }
  else
  { 
    strCargando ="<center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' "
    strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Consultando...espere un momento</b></font><br><br></center>"
    td_datos.innerHTML    = strCargando
    var ajx = new Ajax("notas_de_venta_del_dia.asp",{
      method:'post', 
      data: 'numero_nota_de_venta='+codigo_tmp,
      update:$("td_datos"),
      onComplete: function(respuesta){
        //alert(respuesta)
        codigo.value=""
        codigo.focus()
      }
    });
    ajx.request();    
  }
}
function inserta_en_nota_de_venta(numero_nota_de_venta, cliente_nota_de_venta){
//alert("jfsoifjsof")
  parent.top[1].form_Nota_de_venta.num_n_de_venta.value = numero_nota_de_venta;
  parent.top[1].form_Nota_de_venta.cliente_nota_de_venta.value = cliente_nota_de_venta;  
  parent.top[1].form_Nota_de_venta.submit()

}
function inserta_nueva_nota_de_venta(){
  var x= confirm("¿Desea crear una nueva Nota de Venta?");
  if  (x==true){
    form_nueva_Nota_de_venta.num_n_de_venta.value = "-1";
    form_nueva_Nota_de_venta.cliente_nota_de_venta.value = Cliente_nn.value;  
    form_nueva_Nota_de_venta.submit()
  }
}
</script>
</body>
</html>
