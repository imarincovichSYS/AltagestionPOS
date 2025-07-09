<%
titulo = "Administracion de Compras"
Session("Nombre_Aplicacion") = titulo
%>
<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'if Request.ServerVariables("REMOTE_ADDR") <> "192.168.0.209" then 
'  Response.Write "<center><b>Srta. Carolina. En estos momentos estoy modificando el sistema, por favor intenta ingresar mas tarde</b></center>"
'  Response.end
'end if


width   = "1250"
height  = "620"
fecha_hoy = Get_Fecha_Hoy()
openConn

'session("Login") = "18184487s"
strSQL="select vista_modulo_compras from entidades_comerciales " &_
       "where empresa = 'SYS' and entidad_comercial = '"&session("Login")&"' and " &_
       "vista_modulo_compras='S'"
perfil = "NORMAL"
set rs = Conn.Execute(strSQL)
if not rs.EOF then perfil = "PEDIDO"


'-------------------------------------------------------------------------------------------------
TasaImpAdu = Get_Valor_Numerico_X_Parametro("TASAIMPADU")
if TasaImpAdu = "" then
  Response.Write "<center><b>NO SE HA DEFINIDO LA TASA DE IMPUESTO ADUANERO EN EL SISTEMA (Parámetro: 'TASAIMPADU')</b></center>"
  Response.End
end if
TasaImpAdu = cdbl(TasaImpAdu)/100
'-------------------------------------------------------------------------------------------------
'-------------------------------------------------------------------------------------------------
Cargar_Matriz_Script_Tasas_Rubros

'-------------------------------------------------------------------------------------------------
factor_volumen_en_cero = Get_Valor_Numerico_X_Parametro("TASAVCERO")
if factor_volumen_en_cero = "" then
  Response.Write "<center><b>NO SE HA DEFINIDO LA TASA PARA VOLUMENES MARGINALES EN EL SISTEMA (Parámetro: 'TASAVCERO')</b></center>"
  Response.End
end if
factor_volumen_en_cero = 1 + cdbl(factor_volumen_en_cero)/100
'-------------------------------------------------------------------------------------------------
'-------------------------------------------------------------------------------------------------

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
var RutaProyecto  = "<%=RutaProyecto%>", resolucion_H  = "1024", fecha_hoy = "<%=fecha_hoy%>"
var factor_volumen_en_cero = "<%=factor_volumen_en_cero%>", fecha_cierre = "<%=fecha_cierre%>"
var perfil = "<%=perfil%>"
</script>
<link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">
<link rel="stylesheet" href="<%=RutaProyecto%>css/calendario.css" type="text/css">
<script language="javascript" src="<%=RutaProyecto%>js/mootools-1.11.js"></script>
<script language="JavaScript" src="<%=RutaProyecto%>js/tools.js"></script>
<script language="javascript" src="<%=RutaProyecto%>js/calendario.js"></script>

<link rel="stylesheet" href="<%=RutaProyecto%>ACIDgrid3/grid.css" type="text/css">
<script language="JavaScript" src="<%=RutaProyecto%>ACIDGrid3/grid.js"></script>
<script language="JavaScript" src="<%=RutaProyecto%>ACIDGrid3/grid_calendario.js"></script>
<script language="javascript" src="compras.js"></script>
</head>
<body bgcolor="#9B9DAA">
<table width="100%"align="center"><tr align="center"><td id="texto_2"></td></tr></table>
<table id="table_enc" width="<%=width%>" cellPadding="0" cellSpacing="0" align="center">
<tr align="center">
  <td>
  <table width="100%" cellPadding="0" cellSpacing="0" align="center" border=0>
  <tr bgcolor="#444444">
    <td style="width: 100px;">&nbsp;</td>
    <td align="center" id="texto_12" style="font-size: 11px; color: #FFFFFF;"><b><%=Ucase(titulo)%>:&nbsp;
    <label id="label_accion_modulo" name="label_accion_modulo">BUSCAR COMPRAS</label></b></td>
    <!-- En chrome para cambiar el focus() al input celda_vacio se debe poner height:1px;width:1px; -->
    <td style="width: 5px;"><input type="text" id="celda_vacio" name="celda_vacio" style="height:1px;width:1px; border:0; background-color:#444444;" maxlength="0"></td>
    <td style="width: 100px;"><a class="linkmenuprincipal" href="<%=RutaProyecto%>index.htm">Menú principal</a></td>
  </tr>
  </table>
  </td>
</tr>
<tr bgcolor="#FFFFFF">
  <td valign="top" height="<%=height%>"><input type="hidden" id="tasaimpadu" name="tasaimpadu" value="<%=TasaImpAdu%>">
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
    <option value=""></option>
    <%for i=1 to 12%>
      <option value="<%=i%>"
      <%if i=month(date()) then%>
        selected 
      <%end if%>
      ><%=GetMes(i)%></option>
    <%next%>
    </select></td>
    <td width="100">&nbsp;<b>TIPO:</b>&nbsp;
    <select id="buscar_documento_respaldo" name="buscar_documento_respaldo" style="width: 40px;">
    <option value="R">R</option><option value="TU">TU</option><option value="Z">Z</option><option value="DS">DS</option>
    </select></td>
    <td width="120">&nbsp;<b>FOLIO:</b>&nbsp;
    <input onfocus="select();" onkeypress="return Valida_Digito(event);"
    OnKeyUp="SetKey(event);if(key==13)Buscar_Compras(true,1,'');"
    type="text" id="buscar_numero_documento_respaldo" name="buscar_numero_documento_respaldo" maxlength="7" style="width: 60px;"></td>
    <td style="width:24px;">
    <input 
    <%if perfil = "PEDIDO" then%> disabled <%end if%>
    <%if perfil = "NORMAL" then%>
      OnClick="if(buscar_documento_respaldo.disabled)Buscar_Compras(true,1,'');"
      OnMouseOver="this.style.cursor='pointer'"
    <%end if%>
    type="checkbox" id="buscar_check_TCP" name="buscar_check_TCP" checked></td>
    <td><b><label 
    <%if perfil = "NORMAL" then%>
      OnMouseOver="this.style.cursor='pointer'"
      OnClick="javascript:
      if(buscar_check_TCP.checked)
        buscar_check_TCP.checked=false;
      else
        buscar_check_TCP.checked=true;
      if(buscar_documento_respaldo.disabled)Buscar_Compras(true,1,'');" 
    <%end if%>
    id="buscar_label_check_TCP" name="buscar_label_check_TCP">TCP</label></td>
    <td style="width:24px;">
    <input 
    <%if perfil = "PEDIDO" then%> disabled <%end if%>
    <%if perfil = "NORMAL" then%>
      OnClick="if(buscar_documento_respaldo.disabled)Buscar_Compras(true,1,'');"
      OnMouseOver="this.style.cursor='pointer'"
    <%end if%>
    type="checkbox" id="buscar_check_RCP" name="buscar_check_RCP"></td>
    <td><b><label     
    <%if perfil = "NORMAL" then%>
      OnMouseOver="this.style.cursor='pointer'"
      OnClick="javascript:
      if(buscar_check_RCP.checked)
        buscar_check_RCP.checked=false;
      else
        buscar_check_RCP.checked=true;
      if(buscar_documento_respaldo.disabled)Buscar_Compras(true,1,'');" 
    <%end if%>
    id="buscar_label_check_RCP" name="buscar_label_check_RCP">RCP</label></b>
    </td>
    <td width="300">
    <input class="boton_Buscar_on" type="button" title="Buscar documento de compra" 
    OnClick="Buscar_Compras(true,1,'')" id="bot_buscar" name="bot_buscar">&nbsp;
    <input class="boton_Nuevo_on" type="button" title="Ingresa nuevo documento de compra" 
    OnClick="Set_Nuevo()" id="bot_nuevo" name="bot_nuevo">&nbsp;
    <input class="boton_Editar_off" type="button" title="Editar documento de compra" disabled 
    OnClick="Editar_Compra()" id="bot_editar" name="bot_editar">&nbsp;
    <input class="boton_Eliminar_off" type="button" title="Eliminar documento de compra" disabled 
    OnClick="Eliminar_Compra()" id="bot_eliminar" name="bot_eliminar">&nbsp;
    <input class="boton_Excel_off" type="button" title="Exportar documento de compra a Excel" disabled 
    OnClick="Generar_Informe('')" id="bot_excel" name="bot_excel">&nbsp;
    <input class="boton_Excel_B_off" type="button" title="Exportar documento de compra para Bodega a Excel" disabled 
    OnClick="Generar_Informe('bodega')" id="bot_excel_b" name="bot_excel_b">&nbsp;
    <input class="boton_Excel_C_off" type="button" title="Exportar documento de compra de cambio unidad a Excel" disabled 
    OnClick="Generar_Informe('cambio_unidad')" id="bot_excel_c" name="bot_excel_c">&nbsp;
    <input class="boton_Atras_off" type="button" title="Ir atrás" disabled 
    OnClick="Cancelar_Busqueda_Compra()" id="bot_atras" name="bot_atras">
    </td>
    <td style="width:24px;">
    <input 
    <%if perfil = "PEDIDO" then%> disabled <%end if%>
    type="checkbox" id="checkbox_vista_pedidos" name="checkbox_vista_pedidos"></td>
    <td><b><label 
    <%if perfil = "NORMAL" then%>
      OnMouseOver="this.style.cursor='pointer'"
      OnClick="javascript:
      if(checkbox_vista_pedidos.checked)
        checkbox_vista_pedidos.checked=false;
      else
        checkbox_vista_pedidos.checked=true;" 
    <%end if%> id="label_vista_pedidos" name="label_vista_pedidos">
    Vista pedidos</label></b>
    </td>
  </tr>
  </table>
  <table width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr>
    <td id="grilla_compras" name="grilla_compras"></td>
  </tr>
  </table>
  </td>
</tr>
</table>
<!--#include file="compras_inc_datoscompra.asp" -->
<script language="Javascript">
var navegador;
navegador = Get_Navegador()
w_left_ajuste_capas = 0
if(navegador=="IE")
  w_left_ajuste_capas = 11

CentrarCapa("capaDatosCompra")
document.getElementById("capaDatosCompra").style.left = parseInt(document.getElementById("capaDatosCompra").style.left) - w_left_ajuste_capas
CentrarCapa("capaDatosProveedor")
document.getElementById("capaDatosProveedor").style.left = parseInt(document.getElementById("capaDatosProveedor").style.left) - w_left_ajuste_capas
CentrarCapa("capaNuevoProducto")
document.getElementById("capaNuevoProducto").style.left = parseInt(document.getElementById("capaNuevoProducto").style.left) - w_left_ajuste_capas
CentrarCapa("capaBuscarProveedor")
document.getElementById("capaBuscarProveedor").style.left = parseInt(document.getElementById("capaBuscarProveedor").style.left) - w_left_ajuste_capas
CentrarCapa("capaDatosInfoAdicional")
document.getElementById("capaDatosInfoAdicional").style.left = parseInt(document.getElementById("capaDatosInfoAdicional").style.left) - w_left_ajuste_capas

CentrarCapa("capaActualizarProducto")
document.getElementById("capaActualizarProducto").style.left = parseInt(document.getElementById("capaActualizarProducto").style.left) - w_left_ajuste_capas


Cancelar_Ingreso_Compra()

function Verificar_Configuracion_Regional(){
  x_valor = "1.1"
  x_resultado = parseFloat(x_valor)
  //alert(x_resultado)
  if(x_resultado==11)
  {
    x_MsgStr= "Para trabajar en este programa debe cambiar los siguientes parámetros de la configuración regional:\n"
    x_MsgStr+="Separador de decimales = '.' (punto) \n"
    x_MsgStr+="Separador de miles =  ',' (coma)"
    alert(x_MsgStr)
  }
}
Verificar_Configuracion_Regional()

if(perfil=="PEDIDO")
{
  $("bot_nuevo").style.visibility     = "hidden"
  $("bot_editar").style.visibility    = "hidden"
  $("bot_eliminar").style.visibility  = "hidden"
  $("bot_excel").style.visibility     = "hidden"
  $("bot_excel_b").style.visibility   = "hidden"
  $("bot_excel_c").style.visibility   = "hidden"
  $("checkbox_vista_pedidos").checked = true
  
}
var today = new Date();

var mm = today.getMonth()+1; 
var yyyy = today.getFullYear()
$("buscar_anio").value = yyyy
$("buscar_mes").value = mm
//Buscar_Compras(true,1,'')
</script>
