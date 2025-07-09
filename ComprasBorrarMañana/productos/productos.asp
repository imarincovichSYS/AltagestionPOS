<%
titulo = "Creacion de productos"
Session("Nombre_Aplicacion") = titulo
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
<body bgcolor="#9B9DAA">
<%
strSQL="select superfamilia, nombre from superfamilias order by superfamilia"
set rs = Conn.Execute(strSQL)
%>
<table width="100%"align="center"><tr align="center"><td id="texto_2"></td></tr></table>
<table id="table_enc" width="<%=width%>" cellPadding="0" cellSpacing="0" align="center">
<tr>
  <td>
  <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 >
  <tr bgcolor="#444444">
    <td align="center" style="font-size: 11px; color: #FFFFFF;"><b><%=Ucase(titulo)%>:&nbsp;
    <label id="label_accion_modulo" name="label_accion_modulo">CREAR PRODUCTOS</label></b></td>
    <td style="width: 5px;"><input type="text" name="celda_vacio" style="height:0px;width:0px; border-top:0; border-bottom:0; border-left:0; border-right:0">
  </td>
  </table>
</tr>
<tr>
  <td valign="top" height="380" bgcolor="#FFFFFF">
  <table width="100%" cellpadding=0 cellspacing=0 border=0>
  <tr height="30">
    <td align="center"><b>NUEVO PRODUCTO</b></td>
  </tr>
  </table>
  <table align="center" width="400" cellpadding=0 cellspacing=0 border=0>
  <tr height="26">
    <td align="right" style="width:180px;"><b>Superfamilia:</b>&nbsp;</td>
    <td>
    <select 
    OnKeyUp="SetKey(event);if(key==13)$('familia').focus();"
    OnChange="Cargar_Familias(td_familia);" 
    id="superfamilia" name="superfamilia" style="width:240px; overflow:hidden;">
    <%do while not rs.EOF%>
      <option 
      OnKeyUp="SetKey(event);if(key==13)$('familia').focus();"
      value="<%=trim(rs("superfamilia"))%>"><%=trim(rs("superfamilia"))%>-<%=trim(rs("nombre"))%></option>
    <%rs.MoveNext
    loop%>
    </select></td>
  </tr>
  <tr height="26">
    <td align="right"><b>Familia:</b>&nbsp;</td>
    <td id="td_familia" name="td_familia"></td>
  </tr>
  <tr height="26">
    <td align="right"><b>Subfamilia:</b>&nbsp;</td>
    <td id="td_subfamilia" name="td_subfamilia"></td>
  </tr>
  <tr height="26">
    <td align="right"><b>Código nuevo:</b>&nbsp;</td>
    <td><input id="producto_nuevo" name="producto_nuevo" type="text" style="width: 100px;" readonly class="text_readonly"></td>
  </tr>
  <tr height="26">
    <td align="right"><b>Nombre:</b>&nbsp;</td>
    <td><input 
    OnkeyUp="SetKey(event);if(key==13)Crear_Producto();"
    onkeypress="return Valida_Texto(event);" 
    id="nombre_producto_nuevo" name="nombre_producto_nuevo" type="text" maxlength="50" style="width: 240px;">
    </td>
  </tr>
<%
strSQL="select marca, nombre from marcas order by nombre"
set rs = Conn.Execute(strSQL)
%>
  <tr height="26">
    <td align="right">Marca:&nbsp;</td>
    <td>
    <select id="marca" name="marca" style="width:240px;">
    <option value=""></option>
    <%do while not rs.EOF%>
      <option value="<%=trim(rs("marca"))%>"><%=trim(rs("nombre"))%> (<%=trim(rs("marca"))%>)</option>
    <%rs.MoveNext
    loop%>
    </select></td>
  </tr>
<%
strSQL="select temporada from tb_temporadas where visible = 1 order by temporada"
set rs = Conn.Execute(strSQL)
%>
  <tr height="26">
    <td align="right">Temporada:&nbsp;</td>
    <td>
    <select id="temporada" name="temporada" style="width:70px;">
    <option value=""></option>
    <%do while not rs.EOF%>
      <option value="<%=trim(rs("temporada"))%>"><%=trim(rs("temporada"))%></option>
    <%rs.MoveNext
    loop%>
    </select></td>
  </tr>
  <tr height="26" id="tr_unidad_de_medida_venta_peso_en_grs" name="tr_unidad_de_medida_venta_peso_en_grs" style="visibility:hidden;">
    <td align="right">Peso unitario en grs.:&nbsp;</td>
    <td><input onkeypress="return Valida_Numerico(event);" maxlength="8" style="width: 40px;"
    type="text" value="0" id="unidad_de_medida_venta_peso_en_grs" name="unidad_de_medida_venta_peso_en_grs"></td>
  <tr height="26" id="tr_unidad_de_medida_venta_volumen_en_cc" name="tr_unidad_de_medida_venta_volumen_en_cc" style="visibility:hidden;">
    <td align="right">Volumen unitario en cc:&nbsp;</td>
    <td><input onkeypress="return Valida_Numerico(event);" maxlength="8" style="width: 40px;"
    type="text" value="0" id="unidad_de_medida_venta_volumen_en_cc" name="unidad_de_medida_venta_volumen_en_cc"></td>
  <tr height="26" id="tr_porcentaje_impuesto_1" name="tr_porcentaje_impuesto_1" style="visibility:hidden;">
    <td align="right">ILA:&nbsp;</td>
    <td>
    <select id="porcentaje_impuesto_1" name="porcentaje_impuesto_1" style="font-size: 12px; width: 54px;">
      <option value=""></option>
      <option value="13">13%</option>
      <option value="15">15%</option>
      <option value="27">27%</option>
    </select>
    </td>
  </tr>
  <tr height="40">
    <td align="center" colspan="2">
    <input class="boton_70" type="button" value="Crear" style="visibility:hidden;"
    OnClick="Crear_Producto()" id="bot_crear_nuevo_producto" name="bot_crear_nuevo_producto"></td>
  </tr>
  <tr height="30">
    <td id="td_creando_producto" name="td_creando_producto" align="center" colspan="2"></td>
  </tr>
  <tr height="30">
    <td align="center" colspan="2">
    <label class="msg_accion" id="msg_accion_3" name="msg_accion_3" style="font-size:11px;"></label>
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
//Cargar_SubFamilias(td_subfamilia)
</script>