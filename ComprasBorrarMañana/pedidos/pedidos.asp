<%
titulo = "Administracion de Pedidos"
%>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
width   = "1000"
height  = "480"
fecha_hoy = Get_Fecha_Hoy()
openConn
'-------------------------------------------------------------------------------------------------
fecha_cierre  = Get_Valor_Fecha_X_Parametro("FECHCIERVTMP")
if fecha_cierre = "" then
  Response.Write "<center><b>NO SE HA DEFINIDO UNA FECHA DE CIERRE EN EL SISTEMA (Parámetro: 'FECHCIERVTMP')</b></center>"
  Response.End
end if
fecha_cierre = left(fecha_cierre,10)
'-------------------------------------------------------------------------------------------------
'-------------------------------------------------------------------------------------------------

%>
<html>
<head>
<title>AltaGestión - <%=titulo%></title>
<script language="JavaScript">
var RutaProyecto  = "<%=RutaProyecto%>", resolucion_H  = "1024", fecha_hoy = "<%=fecha_hoy%>", fecha_cierre = "<%=fecha_cierre%>"
</script>
<link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">
<link rel="stylesheet" href="<%=RutaProyecto%>css/calendario.css" type="text/css">
<script language="javascript" src="<%=RutaProyecto%>js/mootools-1.11.js"></script>
<script language="JavaScript" src="<%=RutaProyecto%>js/tools.js"></script>
<script language="javascript" src="<%=RutaProyecto%>js/calendario.js"></script>

<link rel="stylesheet" href="<%=RutaProyecto%>ACIDgrid/grid.css" type="text/css">
<script language="JavaScript" src="<%=RutaProyecto%>ACIDGrid/grid.js"></script>
<script language="JavaScript" src="<%=RutaProyecto%>ACIDGrid/grid_calendario.js"></script>
<script language="javascript" src="pedidos.js"></script>
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
    <font color="#990000"><label id="label_accion_modulo" name="label_accion_modulo">BUSCAR PEDIDOS</label></font></b></td>
    <td width="5"><input type="text" name="celda_vacio" style="height:0px;width:0px; border-top:0; border-bottom:0; border-left:0; border-right:0;" maxlength="0"></td>
    <td width="15" valign="top"><img OnClick="document.location.href='#'" OnMouseOver="this.style.cursor='hand'" 
    title="Cerrar Módulo" src="<%=RutaProyecto%>imagenes/new_cerrar.jpg" width="15" height="13" border="0"></td>
  </tr>
  </table>
  </td>
</tr>
<tr>
  <td valign="top" height="468">
  <table id="tabla_botonera_general" name="tabla_botonera_general" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr id="texto_11" height="30" bgcolor="#DDDDDD">
    <td width="100">&nbsp;<b>AÑO:</b>&nbsp;
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
    <td width="130">&nbsp;<b>Número:</b>&nbsp;
    <input onfocus="select();" onkeypress="return Valida_Digito(event);"
    OnKeyUp="SetKey(event);if(key==13)Buscar_Pedidos(true,1,'');"
    type="text" id="buscar_numero_pedido" name="buscar_numero_pedido" maxlength="7" style="width: 60px;"></td>
    <td>
    <input class="boton_Buscar_on" type="button" title="Buscar pedido" 
    OnClick="Buscar_Pedidos(true,1,'')" id="bot_buscar" name="bot_buscar">&nbsp;
    <input class="boton_Nuevo_on" type="button" title="Ingresar nuevo pedido" 
    OnClick="Set_Nuevo()" id="bot_nuevo" name="bot_nuevo">&nbsp;
    <input class="boton_Editar_off" type="button" title="Editar pedido" disabled 
    OnClick="Editar_Pedido()" id="bot_editar" name="bot_editar">&nbsp;
    <input class="boton_Eliminar_off" type="button" title="Eliminar pedido" disabled 
    OnClick="Eliminar_Pedido()" id="bot_eliminar" name="bot_eliminar">&nbsp;
    <input class="boton_Excel_off" type="button" title="Exportar pedido a Excel" disabled 
    OnClick="Generar_Informe('')" id="bot_excel" name="bot_excel">&nbsp;
    <input class="boton_Email_off" type="button" title="Enviar pedido Excel" disabled 
    OnClick="" id="bot_email" name="bot_email">&nbsp;
    <input class="boton_Atras_off" type="button" title="Ir atrás" disabled 
    OnClick="Cancelar_Busqueda_Pedido()" id="bot_atras" name="bot_atras">
    </td>
  </tr>
  </table>
  <table width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr>
    <td id="grilla_pedidos" name="grilla_pedidos"></td>
  </tr>
  </table>
  </td>
</tr>
</table>
<!--#include file="pedidos_inc_datospedidos.asp" -->
<script language="Javascript">
CentrarCapa("capaDatosPedido")
document.getElementById("capaDatosPedido").style.left = parseInt(document.getElementById("capaDatosPedido").style.left) - 11
CentrarCapa("capaDatosProveedor")
document.getElementById("capaDatosProveedor").style.left = parseInt(document.getElementById("capaDatosProveedor").style.left) - 11
CentrarCapa("capaNuevoProducto")
document.getElementById("capaNuevoProducto").style.left = parseInt(document.getElementById("capaNuevoProducto").style.left) - 11
CentrarCapa("capaBuscarProveedor")
document.getElementById("capaBuscarProveedor").style.left = parseInt(document.getElementById("capaBuscarProveedor").style.left) - 11
Cancelar_Ingreso_Pedido()
</script>