<%
titulo = "Administracion de Carpetas"
%>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
session("entidad_comercial") = "13512435"
width   = "1000"
height  = "480"
fecha_hoy = Get_Fecha_Hoy()
openConn
%>
<html>
<head>
<title>AltaGestión - <%=titulo%></title>
<script language="JavaScript">
var RutaProyecto  = "<%=RutaProyecto%>"; var resolucion_H  = "1024"; var fecha_hoy = "<%=fecha_hoy%>"
</script>
<link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">
<link rel="stylesheet" href="<%=RutaProyecto%>css/calendario.css" type="text/css">
<script language="javascript" src="<%=RutaProyecto%>js/mootools-1.11.js"></script>
<script language="JavaScript" src="<%=RutaProyecto%>js/tools.js"></script>
<script language="javascript" src="<%=RutaProyecto%>js/calendario.js"></script>

<link rel="stylesheet" href="<%=RutaProyecto%>ACIDgrid/grid.css" type="text/css">
<script language="JavaScript" src="<%=RutaProyecto%>ACIDGrid/grid.js"></script>
<script language="JavaScript" src="<%=RutaProyecto%>ACIDGrid/grid_calendario.js"></script>
<script language="javascript" src="carpetas.js"></script>
</head>
<body>
<table width="100%"align="center"><tr align="center"><td id="texto_2"></td></tr></table>
<table id="table_enc" width="<%=width%>" cellPadding="0" cellSpacing="0" align="center">
<tr align="center">
  <td>
  <table width="100%" cellPadding="0" cellSpacing="0" align="center" border=0>
  <tr bgcolor="#CECF94" height="20">
    <td width="21" background="<%=RutaProyecto%>imagenes/ico_SYS_21X20_bg.gif">
    <td align="" id="texto_12">&nbsp;&nbsp;<b><%=Ucase(titulo)%>:&nbsp;
    <font color="#990000"><label id="label_accion_modulo" name="label_accion_modulo">BUSCAR CARPETAS</label></font></b></td>
    <td width="5"><input type="text" name="celda_vacio" style="height:0px;width:0px; border-top:0; border-bottom:0; border-left:0; border-right:0;" maxlength="0"></td>
    <td width="15" valign="top"><img OnClick="document.location.href='#'" OnMouseOver="this.style.cursor='hand'" 
    title="Cerrar Módulo" src="<%=RutaProyecto%>imagenes/new_cerrar.jpg" width="15" height="13" border="0"></td>
  </tr>
  </table>
  </td>
</tr>
<tr>
  <td valign="top" height="490">
  <table id="tabla_botonera_general" name="tabla_botonera_general" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr id="texto_11" height="30" bgcolor="#DDDDDD">
    <td width="100">&nbsp;<b>DOC.:</b>&nbsp;
    <select id="buscar_documento_respaldo" name="buscar_documento_respaldo" style="width: 40px;">
    <option value="R">R</option><option value="TU">TU</option><option value="Z">Z</option>
    </select></td>
    <td width="100"><b>AÑO:</b>&nbsp;
    <select id="buscar_anio" name="buscar_anio" style="width: 50px;">
    <option value="2011">2011</option>
    <option value="2010">2010</option>
    </select></td>
    <td width="130">&nbsp;<b>MES:</b>&nbsp;
    <select id="buscar_mes" name="buscar_mes" style="width: 80px;">
    <%for i=1 to 12%>
      <option value="<%=i%>"><%=GetMes(i)%></option>
    <%next%>
    </select></td>
    <td width="70">&nbsp;<b>N°:</b>&nbsp;
    <input onfocus="select();" onkeypress="return Valida_Digito(event);"
    OnKeyUp="SetKey(event);if(key==13)Buscar_Carpetas(true,1);"
    type="text" id="buscar_num_carpeta" name="buscar_num_carpeta" maxlength="7" style="width: 40px;"></td>
    <td>
    <input class="boton_Buscar_on" type="button" title="Buscar carpeta" 
    OnClick="Buscar_Carpetas(true,1)" id="bot_buscar" name="bot_buscar">&nbsp;
    <input class="boton_Nuevo_on" type="button" title="Ingresar nueva carpeta" 
    OnClick="Set_Nuevo()" id="bot_nuevo" name="bot_nuevo">&nbsp;
    <input class="boton_Editar_off" type="button" title="Editar carpeta" disabled 
    OnClick="Editar_Carpeta()" id="bot_editar" name="bot_editar">&nbsp;
    <input class="boton_Eliminar_off" type="button" title="Eliminar carpeta" disabled 
    OnClick="Eliminar_Carpeta()" id="bot_eliminar" name="bot_eliminar">&nbsp;
    <input class="boton_Atras_off" type="button" title="Ir atrás" disabled 
    OnClick="Cancelar_Busqueda_Carpeta()" id="bot_atras" name="bot_atras">
    </td>
  </tr>
  </table>
  <table width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr>
    <td id="grilla_carpetas" name="grilla_carpetas"></td>
  </tr>
  </table>
  </td>
</tr>
</table>
<!--#include file="carpetas_inc_datoscarpeta.asp" -->
<script language="Javascript">
CentrarCapa("capaDatosCarpeta")
document.getElementById("capaDatosCarpeta").style.left = parseInt(document.getElementById("capaDatosCarpeta").style.left) - 11
CentrarCapa("capaFrame")
document.getElementById("capaFrame").style.left = parseInt(document.getElementById("capaFrame").style.left) - 11
CentrarCapa("capaLoadFile")
document.getElementById("capaLoadFile").style.left = parseInt(document.getElementById("capaLoadFile").style.left) - 11

</script>