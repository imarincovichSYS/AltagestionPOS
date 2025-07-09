<div id="capaDatosPedido" name="capaDatosPedido" style="position:absolute; width: 988px; top: 30px; z-index:-1; visibility:hidden;">
  <fieldset id="fieldset_datos_generales" name="fieldset_datos_generales" align="center" style="width:100%; height:50px;">
    <legend id="texto_10">CABECERA</legend>
    <table id="texto_11" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
    <tr id="tr_cab_1" name="tr_cab_1" height="22">
      <input type="hidden" id="numero_interno_pedido" name="numero_interno_pedido">
      <td width="36">&nbsp;<b>AÑO:</b></td>
      <td width="60">
      <select id="anio" name="anio" style="width: 50px;">
      <%
      v_anio = year(date())
      for i=2006 to year(date())%>
        <option value="<%=v_anio%>"><%=v_anio%></option>
      <%v_anio = v_anio - 1
      next%>
      </select>
      </td>
      <td width="64">&nbsp;<b>N° PEDIDO:</b></td>
      <td width="60"><input o_value="" 
      OnDblClick="if(this.readOnly)Set_Cambiar_Numero_Pedido()" 
      OnBlur="if(this.value!='' && this.readOnly==false)
      {
        if(numero_interno_pedido.value=='')
          Grabar_Pedido_Inicial()
        else
        {
          if(numero_pedido.value!=numero_pedido.o_value)
            Actualizar_Datos_Pedido(this.name,this.value)
          else
          {
            Set_Cancelar_Cambio_Numero_Pedido()
            Config_Msg_Accion('SE INGRESO EL MISMO N° DE PEDIDO, NO SE REALIZARON CAMBIOS...',3000,msg_accion_3)
          }
        }
      }"
      OnFocus="select();"
      OnKeyUp="SetKey(event);if(key==13)celda_vacio.focus()"
      onkeypress="return Valida_Digito(event);" 
      type="text" id="numero_pedido" name="numero_pedido" maxlength="7" style="width: 38px;"></td>
      <td id="td_cab_1_1" name="td_cab_1_1" width="40"><b>FECHA:</b></td>
      <td id="td_cab_1_2" name="td_cab_1_2" width="80"><input o_value=""
      onfocus="select();"
      onKeyUp="closeCalendar();SetKey(event);
      if(key==13)
      {
        if(entidad_comercial.disabled)
          moneda_origen.focus()
        else
          entidad_comercial.focus();
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
              Actualizar_Datos_Pedido(this.name,this.value);
            else
            {
              alert('La fecha debe ser mayor a la fecha de cierre actual ('+fecha_cierre+')')
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
      type="text" id="fecha" name="fecha" maxlength="10" style="width: 64px;"></td>
      <td id="td_cab_1_3" name="td_cab_1_3" width="30">&nbsp;<b>RUT:</b></td>
      <td id="td_cab_1_4" name="td_cab_1_4" align="center" width="80"><input 
      OnFocus="select();" 
      OnKeyUp="SetKey(event);if(key==13 && this.value!='')dig_verificador.focus();"
      OnBlur="if(this.value!=''){dig_verificador.value=Get_Digito_Verificador_Rut(this.value);Verificar_Proveedor();}" 
      onkeypress="return Valida_Digito(event);" 
      maxlength="8" type="text" id="entidad_comercial" name="entidad_comercial" o_value="" style="width: 56px;">
      <input readonly class="text_readonly" style="text-align:center;" 
      type="text" id="dig_verificador" name="dig_verificador" style="width: 14px;"></td>
      <td id="td_buscar_proveedor" name="td_buscar_proveedor" width="28">
      <input class="boton_Buscar" type="button" title="Buscar proveedor" 
      OnClick="Set_Buscar_Proveedor()" id="bot_buscar_proveedor" name="bot_buscar_proveedor"></td>
      <td width="28" id="td_cancelar_proveedor" name="td_cancelar_proveedor" style="visibility:hidden;">
      <input class="boton_Cancelar" type="button" title="Cancelar ingreso proveedor" 
      OnClick="Set_Cancelar_Proveedor()" id="bot_cancelar_proveedor" name="bot_cancelar_proveedor"></td>
      <td id="td_datos_proveedor" name="td_datos_proveedor" width="152" style="visibility:hidden;">
      <b>PROV.:</b>
      <input type="text" readonly id="codprov_proveedor" name="codprov_proveedor" style="width: 110px; font-size:10px; border:0px;"></td>
      <td width="40" id="td_bot_cambiar_proveedor" name="td_bot_cambiar_proveedor" style="visibility:hidden;">
      <input class="boton_Cambiar" type="button" title="Cambiar proveedor" 
      OnClick="Set_Cambiar_Proveedor()" id="bot_cambiar_proveedor" name="bot_cambiar_proveedor">&nbsp;
      </td>
      <td id="td_cab_1_5" name="td_cab_1_5" width="54"><b>MONEDA:</b></td>
      <td id="td_cab_1_6" name="td_cab_1_6" width="100">
      <select 
      OnChange="Actualizar_Datos_Pedido(this.name,this.value);"
      id="moneda_origen" name="moneda_origen" style="width: 90px; font-family: courier new; font-size: 12px;">
        <option title="PESO ARGENTINO"  value="ARS">$&nbsp;&nbsp;&nbsp;(ARS)</option>
        <option title="REAL BRASILEÑO"  value="BRL">R$&nbsp;&nbsp;(BRL)</option>
        <option title="PESO CHILENO"    value="CLP">$&nbsp;&nbsp;&nbsp;(CLP)</option>
        <option title="PESO EUROPEO"    value="EUR">€&nbsp;&nbsp;&nbsp;(EUR)</option>
        <option title="BALBOA PANAMEÑO" value="PAL">B$&nbsp;&nbsp;(PAB)</option>
        <option title="YUAN CHINO"      value="RMB">¥&nbsp;&nbsp;&nbsp;(RMB)</option>
        <option title="DOLAR USA"       value="USD">US$&nbsp;(USD)</option>
      </select></td>
      <td id="td_cab_1_7" name="td_cab_1_7" width="56"><b>PARIDAD:</b></td>
      <td id="td_cab_1_8" name="td_cab_1_8" ><input maxlength="6" type="text" 
      OnFocus="select();"
      OnKeyUp="SetKey(event);if(key==13)moneda_origen.focus();"
      OnBlur="javascript:
      if(this.value!='')
      {
        if(this.value!=this.o_value)
          Actualizar_Datos_Pedido(this.name,this.value);
      }
      else
        this.value=this.o_value;"
      onkeypress="return Valida_Numerico(event);" 
      id="paridad_moneda_origen" name="paridad_moneda_origen" o_value="" style="width: 50px;">
      </td>
    </tr>
    </table>
  </fieldset>
  <table id="texto_11" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr>
    <td>
    <fieldset id="fieldset_datos_TCP" name="fieldset_datos_TCP" align="center" style="width:100%; height:40px;">
      <legend id="texto_10">TCP</legend>
      <table id="texto_11" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
      <tr>
        <td width="34">&nbsp;<b>AÑO:</b></td>
        <td width="60">
        <input type="hidden" id="numero_documento_no_valorizado" name="numero_documento_no_valorizado">
        <input type="hidden" id="numero_interno_documento_no_valorizado" name="numero_interno_documento_no_valorizado">
        <input type="hidden" id="fecha_recepcion" name="fecha_recepcion">
        <input type="hidden" id="bodega" name="bodega">
        <input type="hidden" id="proveedor" name="proveedor">
        <input type="hidden" id="paridad" name="paridad">
        <select id="anio_TCP" name="anio_TCP" style="width: 50px;">
        <%
        v_anio = year(date())
        for i=2006 to year(date())%>
          <option value="<%=v_anio%>"><%=v_anio%></option>
        <%v_anio = v_anio - 1
        next%>
        </select></td>
        <td width="36">&nbsp;<b>TIPO:</b>
        <td width="50">
        <select id="documento_respaldo" name="documento_respaldo" style="width: 40px;">
        <option value="R">R</option><option value="TU">TU</option><option value="Z">Z</option>
        </select></td>
        <td width="56">&nbsp;<b>NUMERO:</b></td>
        <td width="60">
        <input 
        OnBlur="if(this.value!='' && this.disabled==false)Verificar_TCP();"
        OnFocus="select();"
        OnKeyUp="SetKey(event);if(key==13)documento_respaldo.focus()"
        onkeypress="return Valida_Digito(event);" 
        type="text" id="numero_documento_respaldo" name="numero_documento_respaldo" 
        style="width: 50px; font-size:10px;"></td>
        <td width="28">
        <input class="boton_Cambiar" type="button" title="Cambiar TCP" style="visibility:hidden;"
        OnClick="Set_Cambiar_TCP()" id="bot_cambiar_TCP" name="bot_cambiar_TCP"></td>
        <td width="28">
        <input class="boton_Traspasar" type="button" title="Traspasar ítemes a TCP" style="visibility:hidden;"
        OnClick="Traspasar_Items()" id="bot_traspasar" name="bot_traspasar"></td>
        <td width="28">
        <input class="boton_Preview" type="button" title="Visualizar TCP" style="visibility:hidden;"
        OnClick="Visualizar_TCP()" id="bot_visualizar" name="bot_visualizar"></td>
        <td width="150">&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      </table>
    </fieldset>
    </td>
    <td style="width: 4px;"></td>
    <td>
    <fieldset id="fieldset_items" name="fieldset_items" align="center" style="width:100%; height:40px; visibilty:hidden;">
      <legend id="texto_10">ITEMES</legend>
      <table id="texto_11" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
      <tr>
        <td align="center" id="td_items" name="td_items" width="80" style="visibility:hidden;">
        <b>ITEMES:</b>
        <input onkeypress="return Valida_Digito(event);" 
        onkeyup="SetKey(event);if(key==13)Ingresar_Items_Productos();"
        type="text" id="items" name="items" maxlength="3" style="width: 24px;"></td>
        <td align="center" id="td_bot_agregar_items" name="td_bot_agregar_items">
        <input class="boton_Agregar_on" type="button" title="Agregar ítemes" 
        OnClick="Ingresar_Items_Productos()" id="bot_agregar" name="bot_agregar">
        <input class="boton_Eliminar" type="button" title="Eliminar item" 
        OnClick="Eliminar_Limpiar_Items('ELIMINAR')" id="bot_eliminar_item" name="bot_eliminar_item">
        <input class="boton_Limpiar" type="button" title="Limpiar ítemes" 
        OnClick="Eliminar_Limpiar_Items('LIMPIAR')" id="bot_limpiar_item" name="bot_limpiar_item"></td>
        <td width="240" style="font-size:8px;" align="right">
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
  <fieldset id="fieldset_productos" name="fieldset_productos" align="center" style="width:100%; height:348px; visibility: hidden;">
    <legend id="texto_10"><label id="label_legend_fieldset_productos" name="label_legend_fieldset_productos">PRODUCTOS PEDIDO</label></legend>
    <table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr><td id="grilla_productos" name="grilla_productos"></td></tr>
    </table>
  </fieldset>
  <table id="table_estado" name="table_estado" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0 bgcolor="#DDDDDD">
  <tr>
    <td width="560"><label class="msg_accion" id="msg_accion_3" name="msg_accion_3"></label></td>
    <td width="200" style="font-size: 9px;"><label id="msg_return_ajax" name="msg_return_ajax"></label></td>
    <td align="right">
    <input class="boton_Verificar_on" type="button" title="Verificar ítemes" style="visibility:hidden;" 
    OnClick="" id="bot_verificar_itemes" name="bot_verificar_itemes">&nbsp;
    <input class="boton_Informacion_on" type="button" title="" style="visibility:hidden;" campo_error=""
    OnClick="Set_Foco_Input_con_Error();Config_Msg_Accion(this.title,5000,msg_accion_3)" id="bot_informacion_cerrar_pedido" name="bot_informacion_cerrar_pedido">&nbsp;
    <input class="boton_Check_on" type="button" title="Finalizar pedido" style="visibility:hidden;" advertencia="" 
    OnClick="Terminar_Pedido()" id="bot_terminar_pedido" name="bot_terminar_pedido">&nbsp;
    <input class="boton_Atras_on" type="button" title="Volver atrás" 
    OnClick="Cancelar_Ingreso_Pedido()" id="bot_cancelar_pedido" name="bot_cancelar_pedido">&nbsp;</td>
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