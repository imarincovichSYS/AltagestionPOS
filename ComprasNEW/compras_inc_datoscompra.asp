<%
strSQL="select bodega, descripcion_breve from bodegas with(nolock) where empresa='SYS' and Tipo_de_bodega is not null and  ( descripcion_breve like '%Bodega%' or   descripcion_breve like '%CDM%') order by descripcion_breve "
set rs_bodegas = Conn.Execute(strSQL)

w_fieldset = 1238
height_grilla = 486
%>
<div id="capaDatosCompra" name="capaDatosCompra" style="position:absolute; width: <%=w_fieldset%>px; top: 22px; z-index:-1; visibility:hidden; background-color:#FFFFFF;">
  <fieldset id="fieldset_datos_generales" name="fieldset_datos_generales" align="center" style="width:<%=w_fieldset-8%>px;; height:62px; padding: 0px; padding-left: 2px;">
    <legend 
    OnClick="Config_Msg_Accion('Num_Int_DNV: ' + $('numero_interno_documento_no_valorizado').value + ', Num_DNV: ' + $('numero_documento_no_valorizado').value,10000,$('msg_accion_3'));"
    id="texto_10">CABECERA</legend>
    <table id="texto_11" width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
    <tr id="tr_cab_1" name="tr_cab_1" height="22">
      <input type="hidden" id="documento_no_valorizado" name="documento_no_valorizado">
      <input type="hidden" id="numero_documento_no_valorizado" name="numero_documento_no_valorizado">
      <input type="hidden" id="numero_interno_documento_no_valorizado" name="numero_interno_documento_no_valorizado">
      <input type="hidden" id="paridad_segun_fecha_recepcion" name="paridad_segun_fecha_recepcion">

      <!-- Carpeta -->
      <td id="td_cab_2_8" name="td_cab_2_8" align="right"><b>CARPETA:</b>&nbsp;</td>
      <td id="td_carpetas" name="td_carpetas"></td>

      <!-- Tipo -->
      <td style="width:100px; font-size:10px;">&nbsp;<b>TIPO:</b>
      <select id="documento_respaldo" name="documento_respaldo" style="width: 40px;">
      <option value="DS">DS</option><option value="R">R</option><option value="TU">TU</option><option value="Z">Z</option>
      </select></td>

      <!-- Año -->
      <td id="td_cab_0_1" name="td_cab_0_1" style="width:100px; font-size:10px;">&nbsp;<b>AÑO:</b>
      <select id="anio" name="anio" style="width: 50px;">
      <%
      v_anio = year(date())
      for i=2006 to year(date())%>
        <option value="<%=v_anio%>"><%=v_anio%></option>
      <%v_anio = v_anio - 1
      next%>
      </select>

      <!-- Fecha Recepcion -->
      <td id="td_cab_1_3" name="td_cab_1_3" xwidth="76" align="right" style='width: 100px;'><b>FEC. RECEP.:</b>&nbsp;</td>
      <td id="td_cab_1_4" name="td_cab_1_4" width="66"><input o_value=""
      onfocus="select();"
      onKeyUp="closeCalendar();SetKey(event);
      if(key==13)
      {
        if($('documento_respaldo').value=='Z')
          $('monto_adu_US$').focus()
        else
          $('fecha_factura').focus();
      }"
      onblur="javascript:
      if(this.value!='')
      {
        this.value=GetFechaCompleta(this.value,'<%=fecha_hoy%>');
        if(IsDate(this.value))
        {
          if(this.value!=this.getAttribute('o_value'))
          {
              Actualizar_Datos_Compra(this.name,this.value);
              Cargar_Paridades_X_Fecha();
            /*
            if(Compara_Fechas(this.value,fecha_cierre))
            {
              Actualizar_Datos_Compra(this.name,this.value);
              Cargar_Paridades_X_Fecha();
            }
            else
            {
              alert('La fecha de recepción debe ser mayor a la fecha de cierre actual ('+fecha_cierre+')')
              this.value=this.getAttribute('o_value')
              this.focus()
            }
            */
          }
        }
        else
        {
          alert('Formato de fecha incorrecto')
          this.value=this.getAttribute('o_value')
          this.focus()
        }        
      }
      else
        this.value=this.getAttribute('o_value');"
      onkeypress="return Valida_Caracteres_Fecha(event);" 
      onclick="displayCalendarEjectFunction(this,'dd/mm/yyyy',this,true);"
      onmouseup="return false;"
      type="text" id="fecha_recepcion" name="fecha_recepcion" maxlength="10" style="width: 64px;"></td>

      <!-- Fecha Aduana -->
      <td id="td_cab_1_1" name="td_cab_1_1" xwidth="160" align="right" style='width: 120px;'><b>FEC. ADUANA:</b>&nbsp;</td>
      <td id="td_cab_1_2" name="td_cab_1_2" width="68" align='right'><input o_value=""
      onfocus="select();"
      onblur="javascript:
      if(this.value!='')
      {
        this.value=GetFechaCompleta(this.value,'<%=fecha_hoy%>');
        if(IsDate(this.value))
        {
          if(this.value!=this.getAttribute('o_value'))
            if (validaFechaEmisionAduana(this,this.value, $('anio').value)) {
                Actualizar_Datos_Compra(this.name,this.value);
            }
        }
        else
        {
          alert('Formato de fecha incorrecto')
          this.value=this.getAttribute('o_value')
          this.focus()
        }
      }
      else
        this.value=this.getAttribute('o_value');"
      onKeyUp="closeCalendar();SetKey(event);if(key==13)$('fecha_recepcion').focus();"
      onkeypress="return Valida_Caracteres_Fecha(event);" 
      onclick="displayCalendarEjectFunction(this,'dd/mm/yyyy',this,true);"
      onmouseup="return false;"
      type="text" id="fecha_emision" name="fecha_emision" maxlength="10" style="width: 64px;"></td>

      <!-- Nro Aduana -->
      <td width="76" align="right"><b>N° ADUANA:</b>&nbsp;</td>
      <td width="48">
      <span id='TDNroAduana' style='display: block;'>
      <input o_value="" 
      <%if perfil = "NORMAL" then%>
      OnDblClick="if(this.readOnly && $('documento_no_valorizado').value!='RCP')Set_Cambiar_Numero_Aduana()" 
      <%end if%>
      OnClick="NroAduana(this.value);" 
      OnBlur="displayCalendarEjectFunction($('fecha_recepcion'),'dd/mm/yyyy',$('fecha_recepcion'),true);closeCalendar();if(this.value!='' && $('documento_no_valorizado').value!='RCP' && this.readOnly==false)
      {
        if($('numero_documento_no_valorizado').value=='') {
            Xdocumento_respaldo = $('buscar_documento_respaldo').value;
            Xcarpeta = $('carpeta').value;
            Xfecha_recepcion = $('fecha_recepcion').value;
            Xfecha_emision = $('fecha_emision').value;
            if (Xdocumento_respaldo=='TU') {
                if(Xcarpeta=='' || Xfecha_recepcion==''){ alert('Debe seleccionar una Carpeta y/o indicar la Fecha de Recepcion.'); $('numero_documento_respaldo').value='';}
                else {Grabar_Compra_Inicial();}
            } 
            else {
                if(Xcarpeta=='' || Xfecha_emision==''){ alert('Debe seleccionar una Carpeta y/o indicar la Fecha de Aduana.'); $('numero_documento_respaldo').value='';}
                else {Grabar_Compra_Inicial();}
            }
        }
        else
        {
          if($('numero_documento_respaldo').value!=$('numero_documento_respaldo').getAttribute('o_value'))
            Actualizar_Datos_Compra(this.name,this.value)
          else
          {
            Set_Cancelar_Cambio_Numero_Aduana()
            Config_Msg_Accion('SE INGRESO EL MISMO N° DE ADUANA, NO SE REALIZARON CAMBIOS...',3000,$('msg_accion_3'))
          }
        }
      }"
      OnFocus="select();"
      OnKeyUp="SetKey(event);if(key==13)$('celda_vacio').focus()"
      onkeypress="return Valida_Digito(event);" 
      onmouseup="return false;"
      type="text" id="numero_documento_respaldo" name="numero_documento_respaldo" maxlength="7" style="width: 45px;">
      </span>
      <span id='TDSPNAduana' style='display: none;'>
          <select>
              <option value=''></option>
          </select>
      </span>
      </td>

      <!-- -->
      <td width="80">&nbsp;</td>
      <td width="56">&nbsp;</td>

      <td id="td_cab_1_7" name="td_cab_1_7" width="120" align="right">
      <b>PARIDAD:</b>&nbsp;<input type="hidden" id="paridad_margen" name="paridad_margen"><label id="label_paridad_para_facturacion" name="label_paridad_para_facturacion" style="width: 36px; font-size:10px;"></label></td> 
      <td id="td_cab_1_8" name="td_cab_1_8" colspan="2">
      &nbsp;&nbsp;<b>PROV.:</b>&nbsp;<label id="label_proveedor_cabecera" name="label_proveedor_cabecera" rut="" inicial="" style="width: 100px;"></label></td>
    </tr>
    <tr id="tr_cab_2" name="tr_cab_2" style="height:30px;">
      <!-- Bodega -->
      <td id="td_cab_1_5" name="td_cab_1_5" width="70" align="right"><b>BODEGA:</b>&nbsp;</td>
      <td id="td_cab_1_6" name="td_cab_1_6" width="122">
     <select OnChange="CambiarBodega(this.value);" id="bodega" name="bodega" style="width: 120px;">
      <%do while not rs_bodegas.EOF%>
        <option value="<%=trim(rs_bodegas("bodega"))%>"><%=rs_bodegas("descripcion_breve")%></option>
      <%rs_bodegas.MoveNext
      loop%>
      </select></td>

      <!-- Tot Cif Ori -->
      <td id="td_cab_2_4" name="td_cab_2_4" align="right" style="font-size:10px;"><b>TOT. CIF ORI:</b>&nbsp;</td>
      <td id="td_cab_2_5" name="td_cab_2_5"><input o_value=""
      OnFocus="select();"
      OnKeyUp="SetKey(event);if(key==13)$('monto_adu_US$').focus();"
      OnBlur="javascript:
      if(this.value!='')
      {
        if(this.value!=this.getAttribute('o_value'))
          Actualizar_Datos_Compra(this.name,this.value)
      }
      else
        this.value=this.getAttribute('o_value');"
      onkeypress="return Valida_Numerico(event);" 
      onmouseup="return false;"
      type="text" id="monto_neto_US$" name="monto_neto_US$" maxlength="9" style="width: 64px;"></td>

      <!-- Tot Cif Adu -->
      <td id="td_cab_2_6" name="td_cab_2_6" align="right" style="font-size:10px;"><b>TOT. CIF ADU:</b>&nbsp;</td>
      <td id="td_cab_2_7" name="td_cab_2_7"><input o_value=""
      OnFocus="select();"
      OnKeyUp="javascript:SetKey(event);
      if(key==13)
      {
        if($('carpeta') && $('carpeta').disabled==false)
          $('carpeta').focus()
        else
          $('fecha_recepcion').focus();
      }"
      OnBlur="javascript:
      if(this.value!='')
      {
        if(this.value!=this.getAttribute('o_value'))
          Actualizar_Datos_Compra(this.name,this.value)
      }
      else
        this.value=this.getAttribute('o_value');"
      onkeypress="return Valida_Numerico(event);" 
      onmouseup="return false;"
      type="text" id="monto_adu_US$" name="monto_adu_US$" maxlength="9" style="width: 64px;"></td>

      <!-- Fecha Factura -->
      <td id="td_cab_2_1" name="td_cab_2_1" align="right" style='width: 190px;' colspan='2'>&nbsp;<b>FEC. FACTURA:</b>
      <input o_value=""
      onfocus="select();"
      onKeyUp="closeCalendar();SetKey(event);if(key==13)$('numero_factura').focus();"
      onblur="javascript:
      if(this.value!='')
      {
        this.value=GetFechaCompleta(this.value,'<%=fecha_hoy%>');
        if(IsDate(this.value))
        {
          if(this.value!=this.getAttribute('o_value'))
          {
            if(documento_respaldo.value=='TU' && false)
            {
              fecha_emision.value = this.value;
              Actualizar_Datos_Compra(fecha_emision.name,fecha_emision.value);
            }
            Actualizar_Datos_Compra(this.name,this.value);
          }
        }
        else
        {
          alert('Formato de fecha incorrecto')
          this.value=this.getAttribute('o_value')
          this.focus()
        }
      }
      else
        this.value=this.getAttribute('o_value');"
      onkeypress="return Valida_Caracteres_Fecha(event);" 
      onclick="displayCalendarEjectFunction(this,'dd/mm/yyyy',this,true);"
      onmouseup="return false;"
      type="text" id="fecha_factura" name="fecha_factura" maxlength="10" style="width: 64px;"></td>

      <!-- Numero Factura -->
      <td id="td_cab_2_2" name="td_cab_2_2" align="right" style='width: 90px;'><b>N° FACTURA:</b>&nbsp;</td>
      <td id="td_cab_2_3" name="td_cab_2_3"><input o_value=""
      onkeypress="return Valida_Digito(event);" 
      OnFocus="select();"
      OnKeyUp="SetKey(event);
      if(key==13)
      {
        if($('monto_neto_US$').disabled)
          $('monto_adu_US$').focus();
        else
          $('monto_neto_US$').focus();
      }"
      OnBlur="javascript:
      if(this.value!='')
      {
        if(this.value!=this.getAttribute('o_value'))
          Actualizar_Datos_Compra(this.name,this.value);
      }
      else
        this.value=this.getAttribute('o_value');"
      onmouseup="return false;"
      type="text" id="numero_factura" name="numero_factura" maxlength="8" style="width: 45px;"></td>

      <!-- Tot Ex Fab -->
      <td id="td_cab_2_12" name="td_cab_2_12" align="right" style="font-size:10px; visibility:hidden;"><b>TOT. EX FAB:</b>&nbsp;</td>
      <td id="td_cab_2_13" name="td_cab_2_13" style="visibility:hidden;"><input o_value=""
      OnFocus="select();"
      OnKeyUp="javascript:SetKey(event);
      if(key==13)
      {
        if($('carpeta') && $('carpeta').disabled==false)
          $('carpeta').focus()
        else
          $('fecha_recepcion').focus();
      }"
      OnBlur="javascript:
      if(this.value!='')
      {
        if(this.value!=this.getAttribute('o_value'))
          Actualizar_Datos_Compra(this.name,this.value)
      }
      else
        this.value=this.getAttribute('o_value');"
      onkeypress="return Valida_Numerico(event);" 
      onmouseup="return false;"
      type="text" id="total_ex_fab" name="total_ex_fab" maxlength="9" style="width: 64px;"></td>

      <!--<td id="td_cab_2_9" name="td_cab_2_9" align="right"><b>TRANSPORTE:</b>&nbsp;</td>
      <td id="td_cab_2_10" name="td_cab_2_10" style="width:54px;"><label id="label_transporte" name="label_transporte" style="width:50px;"></label></td>-->

      <!-- Bultos -->
      <td id="td_cab_2_9" name="td_cab_2_9" align="right"><b>BULTOS:</b>&nbsp;</td>
      <td id="td_cab_2_10" name="td_cab_2_10" style="width:54px;"><input o_value=""
      OnFocus="select();"
      OnKeyUp="SetKey(event);if(key==13)$('fecha_recepcion').focus();;"
      OnBlur="javascript:
      if(this.value!='')
      {
        if(this.value!=this.getAttribute('o_value'))
          Actualizar_Datos_Compra(this.name,this.value)
      }
      else
        this.value=this.getAttribute('o_value');"
      onkeypress="return Valida_Numerico(event);" 
      onmouseup="return false;"
      type="text" id="bultos" name="bultos" maxlength="4" style="width: 34px;">
      </td>

      <!-- Pedido -->
      <td id="td_cab_2_11" name="td_cab_2_11">
      <table width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
      <tr>
        <td style="width:18px;"><input 
        <%if perfil = "PEDIDO" then%> disabled <%end if%>
        <%if perfil = "NORMAL" then%>
          OnClick="javascript:
          if($('tipo_oc').checked)
            $('tipo_oc').value='P';
          else
            $('tipo_oc').value='O';
          Actualizar_Datos_Compra(this.name,this.value)"
          OnMouseOver="this.style.cursor='hand'"
        <%end if%>
        type="checkbox" id="tipo_oc" name="tipo_oc"></td>
        <td><label
      <%if perfil = "NORMAL" then%>
        OnMouseOver="this.style.cursor='hand'"
        OnClick="javascript:
        if($('tipo_oc').checked)
        {
          $('tipo_oc').checked=false;
          $('tipo_oc').value='O';
        }
        else
        {
          $('tipo_oc').checked=true;
          $('tipo_oc').value='P';
        }
        Actualizar_Datos_Compra($('tipo_oc').name,$('tipo_oc').value)" 
      <%end if%>
      id="label_tipo_oc" name="label_tipo_oc" style="font-size:10px;">Pedido</label></td>

      <td style="width:24px;"><input OnClick="Set_Ingresar_Info_Adicional()" class="boton_Info_Add_on" type="button" title="Información adicional" id="bot_info_add" name="bot_info_add" style="visibility:hidden;"></td>
      </tr>
      </table>
      </td>
    </tr>
    </table>
  </fieldset>
  <table id="texto_11" width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
  <tr>
    <td style="width: 700px;">
    <fieldset id="fieldset_proveedor" name="fieldset_proveedor" align="center" style="width:698px; height:40px; padding: 0px; padding-left: 2px;">
      <legend id="texto_10">PROVEEDOR</legend>
      <table id="texto_11" width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
      <tr>
        <td style="width:30px;">&nbsp;<b>Rut:</b></td>
        <td align="center" style="width:60px;"><input 
        OnFocus="select();" OnKeyUp="SetKey(event);if(key==13 && this.value!='')$('dig_verificador').focus();"
        OnBlur="if(this.value!=''){dig_verificador.value=Get_Digito_Verificador_Rut(this.value);Verificar_Proveedor();}" 
        onkeypress="return Valida_Digito(event);" 
        maxlength="8" type="text" id="entidad_comercial" name="entidad_comercial" o_value="" style="width: 56px;"></td>
        <td style="width:16px;"><input readonly class="text_readonly" style="text-align:center; width:14px;" 
        type="text" id="dig_verificador" name="dig_verificador"></td>
        <td style="width:28px;" id="td_buscar_proveedor" name="td_buscar_proveedor" style="visibility:hidden;">
        <input class="boton_Buscar" type="button" title="Buscar proveedor" 
        OnClick="Set_Buscar_Proveedor()" id="bot_buscar_proveedor" name="bot_buscar_proveedor"></td>
        <td style="width:28px;" id="td_cancelar_proveedor" name="td_cancelar_proveedor" style="visibility:hidden;">
        <input class="boton_Cancelar" type="button" title="Cancelar ingreso proveedor" 
        OnClick="Set_Cancelar_Proveedor()" id="bot_cancelar_proveedor" name="bot_cancelar_proveedor"></td>
        <td id="td_datos_proveedor" name="td_datos_proveedor" style="width: 40px; visibility:hidden;"><b>Prov.:</b></td>
        <td id="td_datos_codprov_proveedor" name="td_datos_codprov_proveedor" style="width:112px;"><input type="text" readonly id="codprov_proveedor" name="codprov_proveedor" style="width: 110px; font-size:10px; border:0px;"></label></td>
        <td align="right" id="td_bot_func_proveedor" name="td_bot_func_proveedor" style="visibility:hidden;">
        <table width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
        <tr>
          <td style="width:28px;">
          <input class="boton_Cambiar" type="button" title="Cambiar proveedor" 
          OnClick="Set_Cambiar_Proveedor()" id="bot_cambiar_proveedor" name="bot_cambiar_proveedor"></td>
          <td style="width:28px;">
          <input class="boton_Upload" type="button" title="Actualizar proveedor cabecera de la compra" 
          OnClick="Actualizar_Proveedor_Cabecera()" id="bot_actualizar_proveedor_cabecera" name="bot_actualizar_proveedor_cabecera"></td>
          <td style="width:28px;">
          <input class="boton_Actualizar" type="button" title="Actualizar proveedor de ítemes seleccionados" 
          OnClick="Actualizar_Proveedor_Items()" id="bot_actualizar_proveedor_items" name="bot_actualizar_proveedor_items"></td>
          <td>
          <input class="boton_Asignar" type="button" title="Asignar segundo proveedor" 
          OnClick="Grabar_Segundo_Proveedor('asignar')" id="bot_asignar_2_proveedor" name="bot_asignar_2_proveedor"></td>
          </td>
        </tr>
        </table>
        </td>
        <td align="center" id="td_datos_2_proveedor_1" name="td_datos_2_proveedor_1" style="width: 50px;" style="visibility:hidden;">&nbsp;<b>Prov.2:</b></td>
        <td align="center" id="td_datos_2_proveedor_2" name="td_datos_2_proveedor_2" style="width: 154px" style="visibility:hidden;">
        <input type="hidden" id="entidad_comercial_2" name="entidad_comercial_2">
        <input type="text" readonly id="codprov_proveedor_2" name="codprov_proveedor_2" style="width:100px; border:0px;"></td>
        <td id="td_datos_2_proveedor_3" name="td_datos_2_proveedor_3" style="width: 26px" style="visibility:;">
        <input class="boton_Eliminar2" type="button" title="Eliminar asignación segundo proveedor" 
        OnClick="Grabar_Segundo_Proveedor('eliminar')" id="bot_eliminar_2_proveedor" name="bot_eliminar_2_proveedor"></td>
      </tr>
      </table>
    </fieldset>
    </td>
    <td>
    <fieldset id="fieldset_items" name="fieldset_items" align="center" style="width:524px; height:40px; padding: 0px; padding-left: 2px;">
      <legend id="texto_10">ITEMES</legend>
      <table id="texto_11" width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
      <tr>
        <td align="center" id="td_items" name="td_items" width="76" style="visibility:hidden;">
        <b>Itemes:</b>
        <input onkeypress="return Valida_Digito(event);" 
        onkeyup="SetKey(event);if(key==13)Ingresar_Items_Productos();"
        type="text" id="items" name="items" maxlength="3" style="width: 24px;"></td>
        <td align="left" id="td_bot_agregar_items" name="td_bot_agregar_items" style="visibility:hidden;">
        <input class="boton_Agregar_on" type="button" title="Agregar ítemes" 
        OnClick="Ingresar_Items_Productos()" id="bot_agregar" name="bot_agregar">
        <input class="boton_Eliminar" type="button" title="Eliminar item" 
        OnClick="Eliminar_Limpiar_Items('ELIMINAR')" id="bot_eliminar_item" name="bot_eliminar_item">
        <input class="boton_Limpiar" type="button" title="Limpiar ítemes" 
        OnClick="Eliminar_Limpiar_Items('LIMPIAR')" id="bot_limpiar_item" name="bot_limpiar_item">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <input class="boton_Actualizar2 " type="button" title="Actualizar producto" 
        OnClick="Set_Actualizar_Producto()" id="bot_actualizar_producto" name="bot_actualizar_producto">
        </td>
        <td id="td_agrupar_items1" name="td_agrupar_items1" width="84" style="font-size:10px;" align="right">
        <b>Agrupar en:</b>&nbsp;</td>
        <td id="td_agrupar_items2" name="td_agrupar_items2" width="56"></td>
        <td id="td_agrupar_items3" name="td_agrupar_items3" width="40">
        <input class="boton_Eliminar2" type="button" title="Desagrupar ítemes" 
        OnClick="Desagrupar_Items()" id="bot_eliminar_agrupacion" name="bot_eliminar_agrupacion"></td>
        <td id="td_checktodos" name="td_checktodos" width="80" style="font-size:8px;" align="right">
        <table width="100%" align="center" cellPadding=0 cellSpacing=0 border=0>
        <tr>
          <td style="width:18px;"><input
          title="Visualizar todos las columnas"
          OnMouseOver="this.style.cursor='hand'"
          OnClick="Cargar_Items('EDITAR','')" 
          type="checkbox" id="checktodos" name="checktodos"></td>
          <td><label 
          title="Visualizar todos las columnas"
          OnMouseOver="this.style.cursor='hand'"
          OnClick="javascript:
          if(checktodos.checked)
            checktodos.checked=false;
          else
            checktodos.checked=true;
          Cargar_Items('EDITAR','');" id="label_checktodos" name="label_checktodos" style="font-size:10px;">Todos</label></td>
        </tr>
        </table>
        </td>
      </tr>
      </table>
    </fieldset>
    </td>
  </tr>
  </table>
  <fieldset id="fieldset_productos" name="fieldset_productos" align="center" style="width:<%=w_fieldset-8%>px; height:<%=height_grilla%>px; visibility: hidden; padding: 0px; padding-left: 0px;">
    <legend id="texto_10"><label id="label_legend_fieldset_productos" name="label_legend_fieldset_productos">PRODUCTOS</label></legend>
    <table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr><td id="grilla_productos" name="grilla_productos"></td></tr>
    </table>
  </fieldset>
  <table id="table_estado" name="table_estado" width="100%" align="center" cellPadding=0 cellSpacing=0 border=0 bgcolor="#DDDDDD">
  <tr>
    <td width="300"><label class="msg_accion" id="msg_accion_3" name="msg_accion_3"></label></td>
    <td width="310">
    <table id="tabla_form_traspaso_TCP" name="tabla_form_traspaso_TCP" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
    <tr style="font-size:10px;">
      <td>AÑO:
      <select OnChange="Buscar_TCP_de_Traspaso()"
      id="traspaso_anio" name="traspaso_anio" style="font-size:9px; width: 49px;">
      <%
      v_anio = year(date())
      for i=2006 to year(date())%>
        <option value="<%=v_anio%>"><%=v_anio%></option>
      <%v_anio = v_anio - 1
      next%>
      </select>
      &nbsp;
      TIPO:
      <select 
      OnChange="Buscar_TCP_de_Traspaso()"
      id="traspaso_documento_respaldo" name="traspaso_documento_respaldo" style="font-size:9px; width: 38px;">
      <option value="R">R</option><option value="TU">TU</option><option value="Z">Z</option><option value="DS">DS</option>
      </select>
      &nbsp;
      N° DA:
      <input 
      OnBlur="Buscar_TCP_de_Traspaso()"
      OnFocus="select();"
      OnKeyUp="SetKey(event);if(key==13)$('celda_vacio').focus()"
      onkeypress="return Valida_Digito(event);" 
      onmouseup="return false;"
      type="text" id="traspaso_numero_documento_respaldo" name="traspaso_numero_documento_respaldo" maxlength="7" style="width: 40px;"></td>
      <td>
      <input type="hidden" id="traspaso_numero_interno_documento_no_valorizado" name="traspaso_numero_interno_documento_no_valorizado">
      <input type="hidden" id="traspaso_numero_documento_no_valorizado"         name="traspaso_numero_documento_no_valorizado">
      <input type="hidden" id="traspaso_bodega"                                 name="traspaso_bodega">
      <input type="hidden" id="traspaso_proveedor"                              name="traspaso_proveedor">
      <input type="hidden" id="traspaso_fecha_movimiento"                       name="traspaso_fecha_movimiento">
      <input type="hidden" id="traspaso_paridad"                                name="traspaso_paridad">
      <input class="boton_Guardar_bg_DDD" type="button" title="Traspasar ítemes a TCP"
      OnClick="Traspasar_Itemes()" id="bot_traspasar_itemes" name="bot_traspasar_itemes">&nbsp;
      <input class="boton_Cancelar_bg_DDD" type="button" title="Cancelar traspaso de ítemes"
      OnClick="Cancelar_Traspaso()" id="bot_cancelar_traspaso" name="bot_cancelar_traspaso"></td>
    </tr>
    </table>
    </td>
    <%
    w_tot = 122
    font_size = 10
    %>
    <td id="td_total_cif_ori" name="td_total_cif_ori" width="<%=w_tot+20%>" style="font-size:<%=font_size%>px; visibility: hidden;"><b>Tot.Cif Ori:</b>&nbsp;<label id="label_total_cif_ori" name="label_total_cif_ori"></label></td>
    <td id="td_total_cif_adu" name="td_total_cif_adu" width="<%=w_tot%>" style="font-size:<%=font_size%>px; visibility: hidden;"><b>Tot.Cif Adu:</b>&nbsp;<label id="label_total_cif_adu" name="label_total_cif_adu"></label></td>
    <td id="td_total_ex_fab" name="td_total_ex_fab" width="<%=w_tot%>" style="font-size:<%=font_size%>px; visibility: hidden;"><b>Tot.Ex Fab:</b>&nbsp;<label id="label_total_ex_fab" name="label_total_ex_fab"></label></td>
    <!--<td id="td_total_fob" name="td_total_fob" width="<%=w_tot%>" style="font-size:<%=font_size%>px; visibility: hidden;"><b>Tot.Fob:</b>&nbsp;<label id="label_total_fob" name="label_total_fob"></label></td>-->
    <td align="right">
    <input class="boton_Verificar_on" type="button" title="Verificar ítemes" style="visibility:hidden;" 
    OnClick="Set_Totales_Costos()" id="bot_verificar_itemes" name="bot_verificar_itemes">&nbsp;
    <input class="boton_Informacion_on" type="button" title="" style="visibility:hidden;" campo_error=""
    OnClick="Set_Foco_Input_con_Error();Config_Msg_Accion(this.title,5000,msg_accion_3)" id="bot_informacion_to_RCP" name="bot_informacion_to_RCP">&nbsp;
    <input class="boton_Check_on" type="button" title="Finalizar compra" style="visibility:hidden;" advertencia="" 
    OnClick="Terminar_Compra()" id="bot_terminar_compra" name="bot_terminar_compra">&nbsp;
    <input class="boton_Atras_on" type="button" title="Volver atrás" 
    OnClick="Recargar_Pagina_Boton_Volver()" id="bot_cancelar_compra" name="bot_cancelar_compra">&nbsp;</td>
  </tr>
  </table>
</div>
<div class="div_ventana" id="capaDatosProveedor" name="capaDatosProveedor" style="position:absolute; width: 988px; top: 80px; z-index: 0; visibility:hidden;">  
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td align="center"><b>NUEVO PROVEEDOR</b></td>
  </tr>
  </table>
  <table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr height="20"><td align="right"><label class="msg_accion" id="msg_accion_2" name="msg_accion_2"></label></td></tr>
  </table>
  <table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr><td id="grilla_nuevo" name="grilla_nuevo"></td></tr>
  </table>
  <table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr height="40">
    <td align="center"><input class="boton_60" type="button" value="Cerrar" 
    OnClick="Cerrar_Nuevo_Proveedor()" id="bot_cerrar_nuevo_proveedor" name="bot_cerrar_nuevo_proveedor"></td>
  </tr>
  </table>
</div>
<%
strSQL="select superfamilia, nombre from superfamilias with(nolock) order by superfamilia"
set rs = Conn.Execute(strSQL)
%>
<div class="div_ventana" id="capaNuevoProducto" name="capaNuevoProducto" 
style="position:absolute; width: 500px; top: 100px; z-index:-1; visibility:hidden;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td align="center"><b>NUEVO PRODUCTO</b></td>
  </tr>
  </table>
  <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 >
  <tr height="26">
    <input type="hidden" id="hidden_celda_row" name="hidden_celda_row">
    <input type="hidden" id="hidden_celda_col" name="hidden_celda_col">
    <td align="right" style="width:180px;"><b>Superfamilia:</b>&nbsp;</td>
    <td>
    <select 
    OnKeyUp="SetKey(event);if(key==13)$('familia').focus();"
    OnChange="Cargar_Familias(td_familia);" 
    id="superfamilia" name="superfamilia" style="width:240px; overflow:hidden;">
    <%do while not rs.EOF%>
      <option value="<%=trim(rs("superfamilia"))%>"><%=trim(rs("superfamilia"))%>-<%=trim(rs("nombre"))%></option>
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
strSQL="select marca, nombre from marcas with(nolock) order by nombre"
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
strSQL="select temporada from tb_temporadas with(nolock) where visible = 1 order by temporada"
set rs = Conn.Execute(strSQL)
%>
  <tr height="26">
    <td align="right">Temporada:&nbsp;</td>
    <td>
    <select id="temporada" name="temporada" style="width:70px;">
    <!--<option value=""></option>-->
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
    <input class="boton_70" type="button" value="Crear" 
    OnClick="Crear_Producto()" id="bot_crear_nuevo_producto" name="bot_crear_nuevo_producto">
    &nbsp;
    <input class="boton_70" type="button" value="Cancelar" 
    OnClick="Cerrar_Nuevo_Producto()" id="bot_cerrar_nuevo_producto" name="bot_cerrar_nuevo_producto"></td>
  </tr>
  <tr height="30">
    <td id="td_creando_producto" name="td_creando_producto" align="center" colspan="2"></td>
  </tr>
  </table>
</div>
<div class="div_ventana" id="capaBuscarProveedor" name="capaBuscarProveedor" 
style="position:absolute; width: 550px; top: 80px; z-index: 0; visibility:hidden;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td align="center"><b>BUSCAR PROVEEDOR</b></td></tr>
  </table>
  <table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="114" align="right">&nbsp;<b>Nombre / Codprov :</b>&nbsp;</td>
    <td>
    <input 
    OnClick="if(this.value.length >= 3)Cargar_Busqueda_Proveedor(this);"
	  OnKeyUp="if(navegador=='IE')v_tecla=event.keyCode; else v_tecla=event.which;
	           if(v_tecla!=ENTER && v_tecla!=IZQUIERDA && v_tecla!=DERECHA && v_tecla!=ARRIBA && v_tecla!=ABAJO)
	           {
	             if(this.value=='')                
	               OcultarCapa('td_select_busqueda_proveedor');
	             else
	             {
	               if(this.value.length >= 3)
	                 Cargar_Busqueda_Proveedor(this);
	             }
	           }
	           else if(v_tecla==ENTER)
	           {
	             if($('select_busqueda_proveedor').options[0])
	               Seleccionar_Proveedor($('select_busqueda_proveedor'))
	           }"
	  OnkeyDown="if(navegador=='IE')v_tecla=event.keyCode; else v_tecla=event.which;
	             if($('select_busqueda_proveedor').options[0])
	             switch(v_tecla)
               {
                 default: 
                   Mover_Seleccionado_Select($('select_busqueda_proveedor'),v_tecla);
                   this.focus();
                   break;
                          
               }"
	  OnFocus="select();"
    type="text" id="datos_busqueda_proveedor" name="datos_busqueda_proveedor" style="height: 16px; width: 420px;">
    </td>
  </tr>
  <tr height="90">
    <td></td>
    <td id="td_select_busqueda_proveedor" name="td_select_busqueda_proveedor" style="visibility:hidden;">
    <select id="select_busqueda_proveedor" name="select_busqueda_proveedor"></select></td>
  </tr>
  <tr height="24">
    <td id="td_crear_proveedor" name="td_crear_proveedor" align="center" colspan="2" style="visibility:hidden;">
    <b>Rut siguiente proveedor extranjero:</b>&nbsp;
    <input type="text" id="rut_proveedor_extranjero" name="rut_proveedor_extranjero" style="text-align: center; width: 62px; background-color: #EEEEEE;" readonly>
    &nbsp;
    <input class="boton_70" type="button" value="Crear" 
    OnClick="Set_Crear_Proveedor_Extranjero()" id="bot_crear_proveedor" name="bot_crear_proveedor"></td>
  </tr>
  <tr height="30">
    <td align="center" colspan="2">
    <input class="boton_70" type="button" value="Cancelar" 
    OnClick="Cancelar_Busqueda_Proveedor()" id="bot_cancelar_busqueda_proveedor" name="bot_cancelar_busqueda_proveedor"></td>
  </tr>
  </table>
</div>

<div class="div_ventana" id="capaDatosInfoAdicional" name="capaDatosInfoAdicional" style="position:absolute; width: 600px; top: 30px; z-index: 0; visibility:hidden;">  
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td align="center"><b>Datos adicionales de compra</b></td>
  </tr>
  </table>
  <table align="center" width="100%" border=0 cellpadding=0 cellspacing=0>
  <tr style="height:20px;"><td align="right"><label class="msg_accion" id="msg_accion_4" name="msg_accion_4"></label></td></tr>
  </table>
  <table align="center" width="100%" border=0 cellpadding=0 cellspacing=0>
  <tr>
    <td id="grilla_info_adicional" name="grilla_info_adicional"></td>
  </tr>
  </table>
  <table align="center" width="100%" border=0 cellpadding=0 cellspacing=0>
  <tr height="40">
    <td align="center"><input class="boton_60" type="button" value="Cerrar" 
    OnClick="Cerrar_Info_Adicional()" id="bot_cerrar_info_adicional" name="bot_cerrar_info_adicional"></td>
  </tr>
  </table>
</div>

<!-- DIV DE ACTUALIZACION DE DATOS DE UN PRODUCTO (PRODUCTOS INVENTARIABLES)
modificación: cmartinez ; 20161101
-->
<%
strSQL="select superfamilia, nombre from superfamilias with(nolock) order by superfamilia"
set rs = Conn.Execute(strSQL)
%>
<div class="div_ventana" id="capaActualizarProducto" name="capaActualizarProducto" 
style="position:absolute; width: 500px; top: 100px; z-index:-1; visibility:hidden;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td align="center"><b>ACTUALIZAR PRODUCTO</b></td>
  </tr>
  </table>
  <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 >
  <tr height="26">
    <td align="right"><b>Código:</b>&nbsp;</td>
    <td><input id="producto_actualizar" name="producto_actualizar" type="text" style="width: 100px;" readonly class="text_readonly"></td>
  </tr>
  <tr height="26">
    <input type="hidden" id="hidden_num_linea1" name="hidden_num_linea1">
    <input type="hidden" id="hidden_celda_row1" name="hidden_celda_row1">
    <input type="hidden" id="hidden_celda_col1" name="hidden_celda_col1">
    <td align="right" style="width:180px;"><b>Superfamilia:</b>&nbsp;</td>
    <td>
    <select 
    OnKeyUp="SetKey(event);if(key==13)$('familia').focus();"
    OnChange="Cargar_Familias1(td_familia1, '', '');" 
    id="superfamilia1" name="superfamilia1" style="width:240px; overflow:hidden;">
    <%do while not rs.EOF%>
      <option value="<%=trim(rs("superfamilia"))%>"><%=trim(rs("superfamilia"))%>-<%=trim(rs("nombre"))%></option>
    <%rs.MoveNext
    loop%>
    </select></td>
  </tr>
  <tr height="26">
    <td align="right"><b>Familia:</b>&nbsp;</td>
    <td id="td_familia1" name="td_familia1"></td>
  </tr>
  <tr height="26">
    <td align="right"><b>Subfamilia:</b>&nbsp;</td>
    <td id="td_subfamilia1" name="td_subfamilia1"></td>
  </tr>
<%
strSQL="select marca, nombre from marcas with(nolock) order by nombre"
set rs = Conn.Execute(strSQL)
%>
  <tr height="26">
    <td align="right">Marca:&nbsp;</td>
    <td>
    <select id="marca1" name="marca1" style="width:240px;">
    <option value=""></option>
    <%do while not rs.EOF%>
      <option value="<%=trim(rs("marca"))%>"><%=trim(rs("nombre"))%> (<%=trim(rs("marca"))%>)</option>
    <%rs.MoveNext
    loop%>
    </select></td>
  </tr>
  <tr height="26">
    <td align="right">Género:&nbsp;</td>
    <td>
    <select id="genero1" name="genero1" style="font-size: 11px; width: <%=w_select%>px;">
      <option value=""></option>
      <option value="H">H - Hombre</option>
      <option value="M">M - Mujer</option>
      <option value="A">A - Niña</option>
      <option value="O">O - Niño</option>
      <option value="B">B - Bebe</option>
      <option value="U">U - Unisex</option>
    </select>
    </td>
  </tr>
  <tr height="26">
    <td align="right">Stock Min. Manual:&nbsp;</td>
    <td><input onkeypress="return Valida_Digito(event);" maxlength="8" style="width: 60px;"
    type="text" value="0" id="stock_minimo_manual1" name="stock_minimo_manual1">
    </td>
  </tr>
  <tr height="26">
    <td align="right">Contenido grs:&nbsp;</td>
    <td><input onkeypress="return Valida_Digito(event);" maxlength="8" style="width: 60px;"
    type="text" value="0" id="unidad_de_medida_venta_peso_en_grs1" name="unidad_de_medida_venta_peso_en_grs1">
    </td>
  </tr>
  <tr height="26">
    <td align="right">Contenido ml:&nbsp;</td>
    <td><input onkeypress="return Valida_Digito(event);" maxlength="8" style="width: 60px;"
    type="text" value="0" id="unidad_de_medida_venta_volumen_en_cc1" name="unidad_de_medida_venta_volumen_en_cc1">
    </td>
  </tr>
  <tr height="40">
    <td align="center" colspan="2">
    <input class="boton_70" type="button" value="Actualizar" 
    OnClick="Actualizar_Producto()" id="bot_actualizar_producto" name="bot_actualizar_producto">
    &nbsp;
    <input class="boton_70" type="button" value="Cancelar" 
    OnClick="Cerrar_Actualizar_Producto()" id="bot_cerrar_actualizar_producto" name="bot_cerrar_actualizar_producto"></td>
  </tr>
  <tr height="30">
    <td id="td_actualizando_producto" name="td_actualizando_producto" align="center" colspan="2"></td>
  </tr>
  </table>
</div>
