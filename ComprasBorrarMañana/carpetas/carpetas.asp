<%
titulo = "Administracion de Carpetas"
Session("Nombre_Aplicacion") = titulo
%>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
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

<link rel="stylesheet" href="<%=RutaProyecto%>ACIDgrid3/grid.css" type="text/css">
<script language="JavaScript" src="<%=RutaProyecto%>ACIDGrid3/grid.js"></script>
<script language="JavaScript" src="<%=RutaProyecto%>ACIDGrid3/grid_calendario.js"></script>
<script language="javascript" src="carpetas.js"></script>
</head>
<body bgcolor="#9B9DAA">
<table width="100%"align="center"><tr align="center"><td id="texto_2"></td></tr></table>
<table id="table_enc" width="<%=width%>" cellPadding="0" cellSpacing="0" align="center">
<tr align="center">
  <td>
  <table width="100%" cellPadding="0" cellSpacing="0" align="center" border=0>
  <tr align="center" bgcolor="#444444">
    <td style="width: 100px;">&nbsp;</td>
    <td style="font-size: 11px; color:#FFFFFF;"><b><%=Ucase(titulo)%>:&nbsp;
    <label id="label_accion_modulo" name="label_accion_modulo">BUSCAR CARPETAS</label></b></td>
    <!-- En chrome para cambiar el focus() al input celda_vacio se debe poner height:1px;width:1px; -->
    <td style="width: 5px;"><input type="text" id="celda_vacio" name="celda_vacio" style="height:1px;width:1px; border:0; background-color:#444444;" maxlength="0"></td>
    <td style="width: 100px;"><a class="linkmenuprincipal" href="<%=RutaProyecto%>index.htm">Menú principal</a></td>
  </tr>
  </table>
  </td>
</tr>
<tr>
  <td valign="top" height="490" bgcolor="#FFFFFF">
  <table id="tabla_botonera_general" name="tabla_botonera_general" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr id="texto_11" height="30" bgcolor="#DDDDDD">
    <td width="100">&nbsp;<b>DOC.:</b>&nbsp;
    <select id="buscar_documento_respaldo" name="buscar_documento_respaldo" style="width: 40px;">
    <option value="R">R</option><option value="TU">TU</option><option value="Z">Z</option>
    </select></td>
    <td width="100"><b>AÑO:</b>&nbsp;
       <select id="buscar_anio" name="buscar_anio" style="width: 50px;">
        <%
        v_anio = year(date())
        for i=2006 to year(date())%>
          <option value="<%=v_anio%>"><%=v_anio%></option>
        <%v_anio = v_anio - 1
        next%>
        </select></td>
    <td width="130">&nbsp;<b>MES:</b>&nbsp;
    <select id="buscar_mes" name="buscar_mes" style="width: 80px;">
    <%for i=1 to 12%>
      <option value="<%=i%>"
      <%if i=month(date()) then%>
        selected 
      <%end if%>
      ><%=GetMes(i)%></option>
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
var navegador;
navegador = Get_Navegador()

CentrarCapa("capaDatosCarpeta")
document.getElementById("capaDatosCarpeta").style.left = parseInt(document.getElementById("capaDatosCarpeta").style.left) - 11
CentrarCapa("capaFrame")
document.getElementById("capaFrame").style.left = parseInt(document.getElementById("capaFrame").style.left) - 11
CentrarCapa("capaLoadFile")
document.getElementById("capaLoadFile").style.left = parseInt(document.getElementById("capaLoadFile").style.left) - 11

Cancelar_Busqueda_Carpeta()
</script>
