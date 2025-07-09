<%
strSQL="select bodega, descripcion_breve from bodegas where empresa='SYS' and descripcion_breve like '%Bodega%' order by descripcion_breve"
set rs_bodegas = Conn.Execute(strSQL)
%>
<div id="capaDatosCompra" name="capaDatosCompra" style="position:absolute; width: 988px; top: 30px; z-index:-1; visibility:hidden;">
  <fieldset id="fieldset_datos_generales" name="fieldset_datos_generales" align="center" style="width:100%; height:50px;">
    <legend id="texto_10">CABECERA</legend>
    <table id="texto_11" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
    <tr id="tr_cab_1" name="tr_cab_1" height="22">
      <input type="hidden" id="documento_no_valorizado" name="documento_no_valorizado">
      <input type="hidden" id="numero_documento_no_valorizado" name="numero_documento_no_valorizado">
      <input type="hidden" id="numero_interno_documento_no_valorizado" name="numero_interno_documento_no_valorizado">
      <td width="156">&nbsp;<b>AÑO:</b>
      <select id="anio" name="anio" style="width: 48px;">
      <%
      v_anio = 2011
      for i=2006 to year(date())%>
        <option value="<%=v_anio%>"><%=v_anio%></option>
      <%v_anio = v_anio - 1
      next%>
      </select>
      <b>TIPO:</b>
      <select id="documento_respaldo" name="documento_respaldo" style="width: 40px;">
      <option value="R">R</option><option value="TU">TU</option><option value="Z">Z</option>
      </select></td>
      <td width="70">&nbsp;<b>N° ADUANA:</b></td>
      <td width="42"><input o_value="" 
      OnDblClick="if(this.readOnly && documento_no_valorizado.value!='RCP')Set_Cambiar_Numero_Aduana()" 
      OnBlur="if(this.value!='' && documento_no_valorizado.value!='RCP' && this.readOnly==false)
      {
        if(numero_documento_no_valorizado.value=='')
          Grabar_Compra_Inicial()
        else
        {
          if(numero_documento_respaldo.value!=numero_documento_respaldo.o_value)
            Actualizar_Datos_Compra(this.name,this.value)
          else
          {
            Set_Cancelar_Cambio_Numero_Aduana()
            Config_Msg_Accion('SE INGRESO EL MISMO N° DE ADUANA, NO SE REALIZARON CAMBIOS...',3000,msg_accion_3)
          }
        }
      }"
      OnFocus="select();"
      OnKeyUp="SetKey(event);if(key==13)celda_vacio.focus()"
      onkeypress="return Valida_Digito(event);" 
      type="text" id="numero_documento_respaldo" name="numero_documento_respaldo" maxlength="7" style="width: 38px;"></td>
      <td id="td_cab_1_1" name="td_cab_1_1" width="76"><b>FEC. ADUANA:</b></td>
      <td id="td_cab_1_2" name="td_cab_1_2" width="68"><input o_value=""
      onfocus="select();"
      onblur="javascript:
      if(this.value!='')
      {
        this.value=GetFechaCompleta(this.value,'<%=fecha_hoy%>');
        if(IsDate(this.value))
        {
          if(this.value!=this.o_value)
            Actualizar_Datos_Compra(this.name,this.value);
        }
        else
        {
          alert('Formato de fecha incorrecto')
          this.value=this.o_value
          this.focus()
        }
      }
      else
        this.value=this.o_value;"
      onKeyUp="closeCalendar();SetKey(event);if(key==13)fecha_recepcion.focus();"
      onkeypress="return Valida_Caracteres_Fecha(event);" 
      onclick="displayCalendarEjectFunction(this,'dd/mm/yyyy',this,true)"
      type="text" id="fecha_emision" name="fecha_emision" maxlength="10" style="width: 64px;"></td>
      <td id="td_cab_1_3" name="td_cab_1_3" width="74"><b>FEC. RECEP.:</b></td>
      <td id="td_cab_1_4" name="td_cab_1_4" width="70"><input o_value=""
      onfocus="select();"
      onKeyUp="closeCalendar();SetKey(event);
      if(key==13)
      {
        if(documento_respaldo.value=='Z')
          monto_adu_US$.focus()
        else
          fecha_factura.focus();
      }"
      onblur="javascript:
      if(this.value!='')
      {
        this.value=GetFechaCompleta(this.value,'<%=fecha_hoy%>');
        if(IsDate(this.value))
        {
          if(this.value!=this.o_value)
          {
            if(Compara_Fechas(this.value,fecha_cierre))
            {
              Actualizar_Datos_Compra(this.name,this.value);
              Cargar_Paridades_X_Fecha();
            }
            else
            {
              alert('La fecha de recepción debe ser mayor a la fecha de cierre actual ('+fecha_cierre+')')
              this.value=this.o_value
              this.focus()
            }
          }
        }
        else
        {
          alert('Formato de fecha incorrecto')
          this.value=this.o_value
          this.focus()
        }        
      }
      else
        this.value=this.o_value;"
      onkeypress="return Valida_Caracteres_Fecha(event);" 
      onclick="displayCalendarEjectFunction(this,'dd/mm/yyyy',this,true)"
      type="text" id="fecha_recepcion" name="fecha_recepcion" maxlength="10" style="width: 64px;"></td>
      <td id="td_cab_1_5" name="td_cab_1_5" width="56"><b>BODEGA:</b></td>
      <td id="td_cab_1_6" name="td_cab_1_6" width="124">
      <select OnChange="Actualizar_Datos_Compra(this.name,this.value);" id="bodega" name="bodega" style="width: 120px;">
      <%do while not rs_bodegas.EOF%>
        <option value="<%=trim(rs_bodegas("bodega"))%>"><%=rs_bodegas("descripcion_breve")%></option>
      <%rs_bodegas.MoveNext
      loop%>
      </select></td>
      <td id="td_cab_1_7" name="td_cab_1_7" width="88">
      <b>PARIDAD:</b>&nbsp;<input type="hidden" id="paridad_margen" name="paridad_margen"><label id="label_paridad_para_facturacion" name="label_paridad_para_facturacion" style="width: 36px;"></label></td> 
      <td id="td_cab_1_8" name="td_cab_1_8" colspan="2">
      <b>PROV.:</b>&nbsp;<label id="label_proveedor_cabecera" name="label_proveedor_cabecera" rut="" inicial="" style="width: 122px;"></label></td>
    </tr>
    <tr id="tr_cab_2" name="tr_cab_2" height="22">
      <td id="td_cab_2_1" name="td_cab_2_1">&nbsp;<b>FEC. FACTURA:</b>&nbsp;
      <input o_value=""
      onfocus="select();"
      onKeyUp="closeCalendar();SetKey(event);if(key==13)numero_factura.focus();"
      onblur="javascript:
      if(this.value!='')
      {
        this.value=GetFechaCompleta(this.value,'<%=fecha_hoy%>');
        if(IsDate(this.value))
        {
          if(this.value!=this.o_value)
            Actualizar_Datos_Compra(this.name,this.value);
        }
        else
        {
          alert('Formato de fecha incorrecto')
          this.value=this.o_value
          this.focus()
        }
      }
      else
        this.value=this.o_value;"
      onkeypress="return Valida_Caracteres_Fecha(event);" 
      onclick="displayCalendarEjectFunction(this,'dd/mm/yyyy',this,true)"
      type="text" id="fecha_factura" name="fecha_factura" maxlength="10" style="width: 64px;"></td>
      <td id="td_cab_2_2" name="td_cab_2_2"><b>N° FACTURA:</b></td>
      <td id="td_cab_2_3" name="td_cab_2_3"><input o_value=""
      onkeypress="return Valida_Digito(event);" 
      OnFocus="select();"
      OnKeyUp="SetKey(event);
      if(key==13)
      {
        if(monto_neto_US$.disabled)
          monto_adu_US$.focus();
        else
          monto_neto_US$.focus();
      }"
      OnBlur="javascript:
      if(this.value!='')
      {
        if(this.value!=this.o_value)
          Actualizar_Datos_Compra(this.name,this.value);
      }
      else
        this.value=this.o_value;"
      type="text" id="numero_factura" name="numero_factura" maxlength="8" style="width: 38px;"></td>
      <td id="td_cab_2_4" name="td_cab_2_4"><b>TOT. CIF ORI:</b></td>
      <td id="td_cab_2_5" name="td_cab_2_5"><input o_value=""
      OnFocus="select();"
      OnKeyUp="SetKey(event);if(key==13)monto_adu_US$.focus();"
      OnBlur="javascript:
      if(this.value!='')
      {
        if(this.value!=this.o_value)
          Actualizar_Datos_Compra(this.name,this.value)
      }
      else
        this.value=this.o_value;"
      onkeypress="return Valida_Numerico(event);" 
      type="text" id="monto_neto_US$" name="monto_neto_US$" maxlength="9" style="width: 64px;"></td>
      <td id="td_cab_2_6" name="td_cab_2_6"><b>TOT. CIF ADU:</b></td>
      <td id="td_cab_2_7" name="td_cab_2_7"><input o_value=""
      OnFocus="select();"
      OnKeyUp="javascript:SetKey(event);
      if(key==13)
      {
        if(carpeta && carpeta.disabled==false)
          carpeta.focus()
        else
          fecha_emision.focus();
      }"
      OnBlur="javascript:
      if(this.value!='')
      {
        if(this.value!=this.o_value)
          Actualizar_Datos_Compra(this.name,this.value)
      }
      else
        this.value=this.o_value;"
      onkeypress="return Valida_Numerico(event);" 
      type="text" id="monto_adu_US$" name="monto_adu_US$" maxlength="9" style="width: 64px;"></td>
      <td id="td_cab_2_8" name="td_cab_2_8"><b>CARPETA:</b></td>
      <td id="td_carpetas" name="td_carpetas"></td>
      <td id="td_cab_2_9" name="td_cab_2_9" align="right"><b>TRANSPORTE:</b></td>
      <td id="td_cab_2_10" name="td_cab_2_10">&nbsp;<label id="label_transporte" name="label_transporte" style="width:134px;"></label></td>
      <td id="td_cab_2_11" name="td_cab_2_11"><input class="boton_Info_Add_on" type="button" title="Agregar información adicional" 
      OnFocus="" id="bot_info_add" name="bot_info_add"></td>
    </tr>
    </table>
  </fieldset>
  <table id="texto_11" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr>
    <td width="620">
    <fieldset id="fieldset_proveedor" name="fieldset_proveedor" align="center" style="width:100%; height:40px;">
      <legend id="texto_10">PROVEEDOR</legend>
      <table id="texto_11" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
      <tr>
        <td width="30">&nbsp;<b>RUT:</b></td>
        <td align="center" width="80"><input 
        OnFocus="select();" OnKeyUp="SetKey(event);if(key==13 && this.value!='')dig_verificador.focus();"
        OnBlur="if(this.value!=''){dig_verificador.value=Get_Digito_Verificador_Rut(this.value);Verificar_Proveedor();}" 
        onkeypress="return Valida_Digito(event);" 
        maxlength="8" type="text" id="entidad_comercial" name="entidad_comercial" o_value="" style="width: 56px;">
        <input readonly class="text_readonly" style="text-align:center;" 
        type="text" id="dig_verificador" name="dig_verificador" style="width: 14px;"></td>
        <td width="28" id="td_buscar_proveedor" name="td_buscar_proveedor" style="visibility:hidden;">
        <input class="boton_Buscar" type="button" title="Buscar proveedor" 
        OnClick="Set_Buscar_Proveedor()" id="bot_buscar_proveedor" name="bot_buscar_proveedor"></td>
        <td width="28" id="td_cancelar_proveedor" name="td_cancelar_proveedor" style="visibility:hidden;">
        <input class="boton_Cancelar" type="button" title="Cancelar ingreso proveedor" 
        OnClick="Set_Cancelar_Proveedor()" id="bot_cancelar_proveedor" name="bot_cancelar_proveedor"></td>
        <td id="td_datos_proveedor" name="td_datos_proveedor" width="152" style="visibility:hidden;">
        <b>PROV.:</b>
        <input type="text" readonly id="codprov_proveedor" name="codprov_proveedor" style="width: 110px; font-size:10px; border:0px;"></label></td>
        <td align="right" id="td_bot_func_proveedor" name="td_bot_func_proveedor" style="visibility:hidden;">
        <input class="boton_Cambiar" type="button" title="Cambiar proveedor" 
        OnClick="Set_Cambiar_Proveedor()" id="bot_cambiar_proveedor" name="bot_cambiar_proveedor">&nbsp;
        <input class="boton_Upload" type="button" title="Actualizar proveedor cabecera de la compra" 
        OnClick="Actualizar_Proveedor_Cabecera()" id="bot_actualizar_proveedor_cabecera" name="bot_actualizar_proveedor_cabecera">&nbsp;
        <input class="boton_Actualizar" type="button" title="Actualizar proveedor de ítemes seleccionados" 
        OnClick="Actualizar_Proveedor_Items()" id="bot_actualizar_proveedor_items" name="bot_actualizar_proveedor_items">&nbsp;
        <input class="boton_Asignar" type="button" title="Asignar segundo proveedor" 
        OnClick="Grabar_Segundo_Proveedor('asignar')" id="bot_asignar_2_proveedor" name="bot_asignar_2_proveedor"></td>
        <td align="center" id="td_datos_2_proveedor_1" name="td_datos_2_proveedor_1" width="50" style="visibility:hidden;">&nbsp;
        <b>PROV.2:</b></td>
        <td align="center" id="td_datos_2_proveedor_2" name="td_datos_2_proveedor_2" width="104" style="visibility:hidden;">
        <input type="hidden" id="entidad_comercial_2" name="entidad_comercial_2">
        <input type="text" readonly id="codprov_proveedor_2" name="codprov_proveedor_2" style="width:100px; border:0px;"></td>
        <td id="td_datos_2_proveedor_3" name="td_datos_2_proveedor_3" width="26" style="visibility:;">
        <input class="boton_Eliminar2" type="button" title="Eliminar asignación segundo proveedor" 
        OnClick="Grabar_Segundo_Proveedor('eliminar')" id="bot_eliminar_2_proveedor" name="bot_eliminar_2_proveedor"></td>
      </tr>
      </table>
    </fieldset>
    </td>
    <td style="width: 4px;"></td>
    <td>
    <fieldset id="fieldset_items" name="fieldset_items" align="center" style="width:100%; height:40px;">
      <legend id="texto_10">ITEMES</legend>
      <table id="texto_11" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
      <tr>
        <td align="center" id="td_items" name="td_items" width="76" style="visibility:hidden;">
        <b>ITEMES:</b>
        <input onkeypress="return Valida_Digito(event);" 
        onkeyup="SetKey(event);if(key==13)Ingresar_Items_Productos();"
        type="text" id="items" name="items" maxlength="3" style="width: 24px;"></td>
        <td align="center" id="td_bot_agregar_items" name="td_bot_agregar_items" style="visibility:hidden;">
        <input class="boton_Agregar_on" type="button" title="Agregar ítemes" 
        OnClick="Ingresar_Items_Productos()" id="bot_agregar" name="bot_agregar">
        <input class="boton_Eliminar" type="button" title="Eliminar item" 
        OnClick="Eliminar_Limpiar_Items('ELIMINAR')" id="bot_eliminar_item" name="bot_eliminar_item">
        <input class="boton_Limpiar" type="button" title="Limpiar ítemes" 
        OnClick="Eliminar_Limpiar_Items('LIMPIAR')" id="bot_limpiar_item" name="bot_limpiar_item"></td>
        <td id="td_agrupar_items1" name="td_agrupar_items1" width="74" style="font-size:10px;" align="right">
        <b>AGRUPAR EN:</b></td>
        <td id="td_agrupar_items2" name="td_agrupar_items2" width="46"></td>
        <td id="td_agrupar_items3" name="td_agrupar_items3" width="26">
        <input class="boton_Eliminar2" type="button" title="Desagrupar ítemes" 
        OnClick="Desagrupar_Items()" id="bot_eliminar_agrupacion" name="bot_eliminar_agrupacion"></td>
        <td width="60" style="font-size:8px;" align="right">
        <input
        title="Visualizar todos las columnas"
        OnMouseOver="this.style.cursor='hand'"
        OnClick="Cargar_Items('EDITAR','')" 
        type="checkbox" id="checktodos" name="checktodos"><label 
        title="Visualizar todos las columnas"
        OnMouseOver="this.style.cursor='hand'"
        OnClick="javascript:
        if(checktodos.checked)
          checktodos.checked=false;
        else
          checktodos.checked=true;
        Cargar_Items('EDITAR','');" id="label_checktodos" name="label_checktodos">TODOS</label></td>
      </tr>
      </table>
    </fieldset>
    </td>
  </tr>
  </table>
  <fieldset id="fieldset_productos" name="fieldset_productos" align="center" style="width:100%; height:340px; visibility: hidden;">
    <legend id="texto_10"><label id="label_legend_fieldset_productos" name="label_legend_fieldset_productos">PRODUCTOS</label></legend>
    <table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr><td id="grilla_productos" name="grilla_productos"></td></tr>
    </table>
  </fieldset>
  <table id="table_estado" name="table_estado" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0 bgcolor="#DDDDDD">
  <tr>
    <td width="560"><label class="msg_accion" id="msg_accion_3" name="msg_accion_3"></label></td>
    <td id="td_total_cif_ori" name="td_total_cif_ori" width="150" style="font-size:11px; visibility: hidden;"><b>TOTAL CIF ORI:</b>&nbsp;<label id="label_total_cif_ori" name="label_total_cif_ori"></label></td>
    <td id="td_total_cif_adu" name="td_total_cif_adu" width="150" style="font-size:11px; visibility: hidden;"><b>TOTAL CIF ADU:</b>&nbsp;<label id="label_total_cif_adu" name="label_total_cif_adu"></label></td>
    <td align="right">
    <input class="boton_Verificar_on" type="button" title="Verificar ítemes" style="visibility:hidden;" 
    OnClick="Set_Totales_Costos()" id="bot_verificar_itemes" name="bot_verificar_itemes">&nbsp;
    <input class="boton_Informacion_on" type="button" title="" style="visibility:hidden;" campo_error=""
    OnClick="Set_Foco_Input_con_Error();Config_Msg_Accion(this.title,5000,msg_accion_3)" id="bot_informacion_to_RCP" name="bot_informacion_to_RCP">&nbsp;
    <input class="boton_Check_on" type="button" title="Finalizar compra" style="visibility:hidden;" advertencia="" 
    OnClick="Terminar_Compra()" id="bot_terminar_compra" name="bot_terminar_compra">&nbsp;
    <input class="boton_Atras_on" type="button" title="Volver atrás" 
    OnClick="Cancelar_Ingreso_Compra()" id="bot_cancelar_compra" name="bot_cancelar_compra">&nbsp;</td>
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
strSQL="select superfamilia, nombre from superfamilias order by superfamilia"
set rs = Conn.Execute(strSQL)
%>
<div class="div_ventana" id="capaNuevoProducto" name="capaNuevoProducto" 
style="position:absolute; width: 320px; top: 200px; z-index:-1; visibility:hidden;">
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td align="center"><b>NUEVO PRODUCTO</b></td>
  </tr>
  </table>
  <table align="center" width="300" border="0" cellpadding="0" cellspacing="0">
  <tr height="26">
    <input type="hidden" id="hidden_celda_row" name="hidden_celda_row">
    <input type="hidden" id="hidden_celda_col" name="hidden_celda_col">
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
	  OnKeyUp="if(event.keyCode!=ENTER && event.keyCode!=IZQUIERDA && event.keyCode!=DERECHA && event.keyCode!=ARRIBA && event.keyCode!=ABAJO)
	           {
	             if(this.value=='')                
	               OcultarCapa('td_select_busqueda_proveedor');
	             else
	             {
	               if(this.value.length >= 3)
	                 Cargar_Busqueda_Proveedor(this);
	             }
	           }
	           else if(event.keyCode==ENTER)
	           {
	             if(select_busqueda_proveedor.options(0))
	               Seleccionar_Proveedor(select_busqueda_proveedor)
	           }"
	  OnkeyDown="
	  if(select_busqueda_proveedor.options(0))
	    switch(event.keyCode)
      {
        default: 
          Mover_Seleccionado_Select(select_busqueda_proveedor,event.keyCode);
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