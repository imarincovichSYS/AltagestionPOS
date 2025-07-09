<%
titulo = "Creacion de productos"
%>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
width   = "600"
height  = "480"
fecha_hoy = Get_Fecha_Hoy()
openConn
%>
<html>
<head>
<title>AltaGestión - <%=titulo%></title>
<script language="JavaScript">
var RutaProyecto  = "<%=RutaProyecto%>", resolucion_H  = "1024", fecha_hoy = "<%=fecha_hoy%>", fecha_cierre = "<%=fecha_cierre%>"
</script>
<link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">
<script language="javascript" src="<%=RutaProyecto%>js/mootools-1.11.js"></script>
<script language="JavaScript" src="<%=RutaProyecto%>js/tools.js"></script>
<script language="javascript" src="productos.js"></script>
</head>
<body>
<%
strSQL="select superfamilia, nombre from superfamilias order by superfamilia"
set rs = Conn.Execute(strSQL)
%>
<table width="100%"align="center"><tr align="center"><td id="texto_2"></td></tr></table>
<table id="table_enc" width="<%=width%>" cellPadding="0" cellSpacing="0" align="center">
<tr>
  <td>
  <table width="100%" cellPadding="0" cellSpacing="0" align="center" border=0>
  <tr bgcolor="#CECF94" height="20">
    <td width="21" background="<%=RutaProyecto%>imagenes/ico_SYS_21X20_bg.gif">
    <td align="" id="texto_12">&nbsp;&nbsp;<b><%=Ucase(titulo)%>:&nbsp;
    <font color="#990000"><label id="label_accion_modulo" name="label_accion_modulo">CREAR PRODUCTOS</label></font></b></td>
    <td width="5"><input type="text" name="celda_vacio" style="height:0px;width:0px">
  </td>
  </table>
</tr>
<tr>
  <td valign="top" height="280">
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr height="50">
    <td align="center"><b>NUEVO PRODUCTO</b></td>
  </tr>
  </table>
  <table align="center" width="300" border="0" cellpadding="0" cellspacing="0">
  <tr height="26">
    <td width="50">&nbsp;<b>Rubro:</b></td>
    <td>
    <select 
    OnkeyUp="SetKey(event);if(key==13)familia.focus();"
    OnChange="Cargar_Familias(td_familia);Cargar_SubFamilias(td_subfamilia);" 
    id="superfamilia" name="superfamilia" style="width:240px; overflow:hidden;">
    <%do while not rs.EOF%>
      <option value="<%=trim(rs("superfamilia"))%>"><%=trim(rs("superfamilia"))%>-<%=trim(rs("nombre"))%></option>
    <%rs.MoveNext
    loop%>
    </select></td>
  </tr>
  <tr height="26">
    <td>&nbsp;<b>Marca:</b></td>
    <td id="td_familia" name="td_familia"></td>
  </tr>
  <tr height="26">
    <td>&nbsp;<b>Item:</b></td>
    <td id="td_subfamilia" name="td_subfamilia"></td>
  </tr>
  <tr height="26">
    <td align="center" colspan="2">
    <b>Código nuevo:</b>&nbsp;<input id="producto_nuevo" name="producto_nuevo" type="text" style="width: 100px;" readonly class="text_readonly">
    </td>
  </tr>
  <tr height="26">
    <td>&nbsp;<b>Nombre:</b></td>
    <td><input 
    OnkeyUp="SetKey(event);if(key==13)Crear_Producto();"
    onkeypress="return Valida_Texto(event);" 
    id="nombre_producto_nuevo" name="nombre_producto_nuevo" type="text" maxlength="50" style="width: 240px;">
    </td>
  </tr>
  <tr height="40">
    <td align="center" colspan="2">
    <input class="boton_70" type="button" value="Crear" 
    OnClick="Crear_Producto()" id="bot_crear_nuevo_producto" name="bot_crear_nuevo_producto"></td>
  </tr>
  <tr height="30">
    <td id="td_creando_producto" name="td_creando_producto" align="center" colspan="2"></td>
  </tr>
  <tr height="30">
    <td align="center" colspan="2">
    <label class="msg_accion" id="msg_accion_3" name="msg_accion_3"></label>
    </td>
  </tr>
  </table>
  </td>
</tr>
</table>
</body>
</html>
<script language="Javascript">
Cargar_Familias(td_familia)
Cargar_SubFamilias(td_subfamilia)
</script>