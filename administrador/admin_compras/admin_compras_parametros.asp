<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

fecha_ayer = Replace(dateadd("d",-1,date()),"/","-")
tipo_cambio = Request.Form("tipo_cambio")
if tipo_cambio = "fecha_recepcion_y_paridad" then
%>
  <table style="width:340px;" align="center" border=0 cellpadding=0 cellspacing=0>
  <tr style="height: 30px; font-size:11px; color:#FFFFFF;">
    <td style="width:110px;" align="right"><b>Fecha recepción:</b>&nbsp;</td>
    <td style="width:78px;">
    <!--<input style="background-color:#EEEEEE; text-align: center; width:70px;" Onclick="displayCalendarEjectFunction(this,'dd-mm-yyyy',this,true);"
    type="text" id="fecha_recepcion" name="fecha_recepcion" o_value="<%=fecha_ayer%>" value="<%=fecha_ayer%>">-->
    <input style="font-size:14px; background-color:#EEEEEE; text-align: center; font-weight: bold; width:90px;" Onclick="displayCalendarEjectFunction(this,'dd-mm-yyyy',this,true);"
    type="text" id="fecha_recepcion" name="fecha_recepcion" o_value="">
    </td>
    <td style="width:60px;" align="right"><b>Paridad:</b>&nbsp;</td>
    <td><input readOnly type="text" id="paridad" name="paridad" style="font-size:14px; text-align: center; font-weight: bold; width:60px;"></td>
  </tr>
  </table>
<%elseif tipo_cambio = "proveedor" then%>
  <table style="width:870px;" align="center" border=0 cellpadding=0 cellspacing=0>
  <tr style="height: 30px; font-size:11px; color:#FFFFFF;">
    <td style="width:70px;" align="right"><b>Proveedor:</b>&nbsp;</td>
    <td style="width:78px;">
    <input 
    OnKeyPress="return Valida_Digito(event)" maxlength=12
    style="font-size: 14px; font-weight: bold; width:80px;" type="text" id="proveedor" name="proveedor" o_value="">
    </td>
    <td style="width:70px;" align="right"><b>Nombre:</b>&nbsp;</td>
    <td style="width:330px;"><input readOnly type="text" id="nombre_proveedor" name="nombre_proveedor" style="font-size:14px; font-weight: bold; background-color:#DDDDDD; width:320px;"></td>
    <td style="width:40px;" align="right"><b>Sigla:</b>&nbsp;</td>
    <td style="width:110px;"><input readOnly type="text" id="codigo_postal" name="codigo_postal" style="font-size:14px; text-align: center; font-weight: bold; background-color:#DDDDDD; width:100px;"></td>
    <td style="width:50px;" align="right"><input type="checkbox" id="check_actualiza_detalle" name="check_actualiza_detalle"></td>
    <td><label id="label_actualiza_detalle" name="label_actualiza_detalle">Actualiza detalle</label></td>
  </tr>
  </table>
<%end if%>
  
