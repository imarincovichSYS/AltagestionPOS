<%
titulo = "Administracion de Carpetas (v3)"
Session("Nombre_Aplicacion") = titulo
%>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
width   = "1240"
height  = "480"
fecha_hoy = Get_Fecha_Hoy()

OpenConn
'==============================================================================================================
'==============================================================================================================
'========================== Cargar matriz de proveedores para el AutoComplete =================================
strSQL="select entidad_comercial, ('(' + codigo_postal + ') ' + Apellidos_persona_o_nombre_empresa + ' ' + Nombres_persona) as nombre " &_
       "from entidades_comerciales where empresa = 'SYS' and (tipo_entidad_comercial = 'P' or tipo_entidad_comercial = 'A') " &_
       "and codigo_postal <> '' and (Apellidos_persona_o_nombre_empresa <> '' or Nombres_persona <> '')"
set rs = Conn.Execute(strSQL) : strJsonArrayProveedores = ""
do while not rs.EOF
  if strJsonArrayProveedores <> "" then strJsonArrayProveedores = strJsonArrayProveedores & ", "
  strJsonArrayProveedores = strJsonArrayProveedores & "{value: """ & trim(rs("entidad_comercial")) & """, label: """ & Left(trim(rs("nombre")),32) & """}"
  'strJsonArrayProveedores = strJsonArrayProveedores & "{value: """ & trim(rs("entidad_comercial")) & """, label: """ & trim(rs("nombre")) & """}"
  rs.MoveNext
loop
'==============================================================================================================
%>
<html>
<head>
<title>AltaGestión - <%=titulo%></title>
<script language="JavaScript">
var RutaProyecto  = "<%=RutaProyecto%>"; var resolucion_H  = "1024"; var fecha_hoy = "<%=fecha_hoy%>"
</script>
<link rel="stylesheet" type="text/css" href="<%=RutaProyecto%>css/style.css" type="text/css">
<link rel="stylesheet" type="text/css" href="<%=RutaProyecto%>css/ui/themes/base/jquery.ui.all.css">
<link rel="stylesheet" type="text/css" href="<%=RutaProyecto%>css/ui/demos.css">
<%
autocomplete_height = 300
autocomplete_width = 400
%>
<style>
.ui-autocomplete {
  max-height: <%=autocomplete_height%>px;
  max-width: <%=autocomplete_width%>px;
  overflow-y: auto;
  /* prevent horizontal scrollbar */
  overflow-x: hidden;
}
/* IE 6 doesn't support max-height
 * we use height instead, but this forces the menu to always be this tall
 */
* html .ui-autocomplete {
  height: <%=autocomplete_height%>px;
  width: <%=autocomplete_width%>px;
}
</style>

<script type="text/javascript" src="<%=RutaProyecto%>js/tools.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/jquery-1.7.2.min.js"></script>

<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery-ui-1.10.4.custom.min.js"></script>

<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.button.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.button.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.effect.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.menu.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/ui/jquery.ui.autocomplete.js"></script>
<!--<script type="text/javascript" src="<%=RutaProyecto%>js/jquery.limitkeypress.js"></script>--> <!-- No funciona bien-->
<script type="text/javascript" src="carpetas.js"></script>
</head>
<body bgcolor="#9B9DAA">
<table width="100%"align="center"><tr align="center"><td id="texto_2"></td></tr></table>
<table id="table_enc" width="<%=width%>" align="center" cellPadding=0 cellSpacing=0 border=0>
<tr>
  <td id="td_form" name="td_form"></td>
</tr>
</table>
<input type="hidden" id="anio_actual" name="anio_actual" value="<%=year(date())%>">
<input type="hidden" id="mes_actual" name="mes_actual" value="<%=month(date())%>">
<script type="text/javascript">
var navegador;
var arrayJsonProveedores = [<%=strJsonArrayProveedores%>];
</script>