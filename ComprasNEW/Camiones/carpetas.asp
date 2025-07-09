<%
titulo = "Administracion de Camiones"
Session("Nombre_Aplicacion") = titulo
%>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
width   = 1350
height  = 480
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
<body bgcolor="#9B9DAA">
<table width="100%"align="center"><tr align="center"><td id="texto_2"></td></tr></table>
<table id="table_enc" width="<%=width%>" cellPadding="0" cellSpacing="0" align="center">
<tr align="center">
  <td>
  <table width="100%" cellPadding="0" cellSpacing="0" align="center" border=0>
  <tr bgcolor="#444444" align="center">
    <td style="font-size: 11px; color:#FFFFFF;"><b><%=Ucase(titulo)%>:&nbsp;<label id="label_accion_modulo" name="label_accion_modulo">BUSCAR CAMIONES</label></b></td>
    <td width="5"><input type="text" name="celda_vacio" style="height:0px;width:0px; border-top:0; border-bottom:0; border-left:0; border-right:0;" maxlength="0"></td>
  </tr>
  </table>
  </td>
</tr>
<tr>
  <td valign="top" height="490" bgcolor="#FFFFFF">
  <table id="tabla_botonera_general" name="tabla_botonera_general" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr id="texto_11" height="30" bgcolor="#DDDDDD">
    <td width="120">&nbsp;<b>DOC.:</b>&nbsp;
    <select id="buscar_documento_respaldo" name="buscar_documento_respaldo" style="width: 60px;">
    <option value="R">R y DS</option><option value="TU">TU</option><option value="Z">Z</option>
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
    <select id="buscar_mes" name="buscar_mes" style="width: 80px;" disabled>
    <option value="" selected></option>
    <%for i=1 to 12%>
      <option value="<%=i%>"
      <%'if i=month(date()) then%>
         
      <%'end if%>
      ><%=GetMes(i)%></option>
    <%next%>
    </select></td>
    <td width="70">&nbsp;<b>N°:</b>&nbsp;
    <input onfocus="select();" onkeypress="return Valida_Digito(event);"
    OnKeyUp="SetKey(event);if(key==13)Buscar_Carpetas(true,1);"
    type="text" id="buscar_num_carpeta" name="buscar_num_carpeta" maxlength="7" style="width: 40px;"></td>
    <td width="70">
    <input class="boton_Buscar_on" type="button" title="Buscar camión" 
    OnClick="Buscar_Carpetas(true,1)" id="bot_buscar" name="bot_buscar">&nbsp;
    <input class="boton_Atras_off" type="button" title="Ir atrás" disabled 
    OnClick="Cancelar_Busqueda_Carpeta()" id="bot_atras" name="bot_atras">
    </td>
    <td>
    <input type=checkbox onclick="marcar(<%=month(date())%>)" name="pend" id="pend" checked>  <b>Solo Pendientes</b>
    </td>
  </tr>
  </table>
  <table width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr>
    <td bgcolor="#FFFFFF">
    <div id="grilla_carpetas" name="grilla_carpetas" style="width: <%=width-4%>px; height: 458px; overflow: scroll;"></div>
    </td>
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

window.parent.frames[2].location.href = "../../footer.asp"
window.parent.frames[3].location.href = "../../footer.asp"

Cancelar_Busqueda_Carpeta()
</script>
