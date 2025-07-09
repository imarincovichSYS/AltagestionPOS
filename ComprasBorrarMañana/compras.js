// function Get_Total_Cif_ORI_Y_ADU()
// function Get_Total_Cif_ORI_ADU_EXFAB_FOB()
// function Set_Restaurar_td_fec_aduana_y_bot_cancelar_cambio_num_aduana()
// function Set_Cancelar_Cambio_Numero_Aduana()
// function Set_Cambiar_Numero_Aduana()
// function Set_Opciones_Compra(v_fila_compra)
// function Terminar_Compra()
// function Config_Msg_Accion(str_Msg_Accion,id_msg_accion)
// function Actualizar_Datos_Compra(v_nom_campo,v_valor)
// function Cargar_Carpetas()
// function Asignar_Carpeta()
// function Set_Total_CIF_ADU_From_Facturas_Carpeta(x_carpeta)
// function Get_Atributo_Radio_Compras_Checked(v_atributo)
// function Cargar_Paridades_X_Fecha()
// function Grabar_Compra_Inicial()
// function Mostrar_Form_Compra(v_band)
// function Editar_Compra()
// function Eliminar_Compra()
// function Generar_Informe(v_para)
// function Cancelar_Ingreso_Compra()
// function Set_Nuevo()
// function Cancelar_Busqueda_Compra()
// function Buscar_Compras(v_async,v_busqueda_aprox,v_campo_order_by)
// ########### FUNCIONES PROVEEDOR ###########
// function Set_Crear_Proveedor_Extranjero()
// function Cargar_Busqueda_Proveedor(id_text_tmp)
// function Mover_Seleccionado_Select(id_select_tmp,mov_tmp)
// function Seleccionar_Proveedor(id_select_tmp)
// function Cancelar_Busqueda_Proveedor()
// function Set_Buscar_Proveedor()
// function Actualizar_Proveedor_Cabecera()
// function Get_Datos_Segundo_Proveedor()
// function Set_CODPROV(v_proveedor,v_id_input)
// function Grabar_Segundo_Proveedor(v_accion)
// function Set_Cancelar_Proveedor()
// function Set_Cambiar_Proveedor()
// function Cerrar_Nuevo_Proveedor()
// function Cargar_Datos_Proveedor()
// function Verificar_Proveedor()
// function Ingresar_Datos_Proveedor()
// ########### FUNCIONES ITEMS ###############
// function Get_Tasa_Rubro(x_rubro)
// function Get_CPA_Producto_Anterior_a_Fecha(x_producto,x_fecha_recepcion)
// function Desagrupar_Items()
// function Agrupar_Items(v_item)
// function Cargar_Items_Agrupar()
// function Actualizar_Proveedor_Items()
// function Verificar_Check_Tuplas()
// function Ingresar_Items_Productos()
// function Cargar_Items(v_accion,v_num_linea)
// function Set_Calcula_Margen_Item(x_fila, x_factor_rubro)
// function Set_Calcula_Margen_y_CPA_Item(x_fila)
// function Eliminar_Limpiar_Items(v_accion_general)
// function Verificar_Totales_Costos()
// function Set_Totales_Costos()
// function Get_Totales_Costos_Chequea_Items_Para_Pasar_Compra_a_RCP()
// function Set_Foco_Input_con_Error()
// function SaveChanges(cell, c_row, c_col, c_type, c_name, c_scale, c_maxlength, c_null, n_tabla)
// function Bloquea_Celda(v_row,v_col,v_bloquea,v_es_select)
// function Set_Deshabilitar_Celdas_Edicion_Items(c_row,v_band)
// ########### FUNCIONES PRODUCTO #############
// function Cerrar_Nuevo_Producto()
// function Crear_Producto()
// function Cargar_Familias(v_id_td)
// function Cargar_SubFamilias(v_id_td)
// function Get_Nuevo_Codigo(v_superfamilia,v_familia,v_subfamilia)
// function Estructura_Producto_Requiere_Ingreso_de_ILA(v_superfamilia,v_familia,v_subfamilia)
// ########### FUNCIONES INFO ADICIONAL #############

var C_CHECKBOX  = 1,    C_ITEMS       = 2,    C_ITEMS_PADRE = 3,    C_PRODUCTO    = 4,    C_NOMBRE_ORIGINAL = 5,    C_NOMBRE_FINAL  = 5
var C_CANT_M    = 6,    C_UN_COMPRA   = 7,    C_CANT_X_M    = 8,    C_UN_VENTA    = 9,    C_CANT_X_UN       = 10,   C_CANT_VENTA    = 11
var C_CIF_ORI   = 12,   C_TOT_CIF_ORI = 13,   C_CIF_ADU     = 12,   C_TOT_CIF_ADU = 13
var C_DELTA_CPA = 14,   C_OBS_CPA     = 16,   C_CPA         = 15,   C_PRECIO      = 16,   C_MARGEN          = 17
var C_ALTO      = 18,   C_ANCHO       = 19,   C_LARGO       = 20,   C_CANT_X_CAJA = 21,   C_VOLUMEN         = 22,   C_PESO_X_CAJA   = 23
var C_PESO      = 24,   C_FEC_VENC    = 25,   C_TEMP        = 26,   C_ILA         = 27,   C_COD_ARAN        = 28,   C_COD_PROV      = 29
var C_PROD_PROV = 30,   C_PROV_ORI    = 31,   C_COD_CAJA    = 32,   C_COD_ANTIGUO = 33
var C_CANT_ORI  = 34,   C_UN_ORI      = 35,   C_EX_FAB      = 36,   C_TOT_EX_FAB  = 37
//var C_FOB             = 38,   C_TOT_FOB       = 39

var C_PROD_PROV_VISTA_PEDIDO  = 7,  C_PROV_ORI_VISTA_PEDIDO   = 8
var C_FOB_VISTA_PEDIDO        = 9,  C_TOT_FOB_VISTA_PEDIDO    = 10
var C_EX_FAB_VISTA_PEDIDO     = 11, C_TOT_EX_FAB_VISTA_PEDIDO = 12

//------------------------------------------------------------------------------------
//######################### FUNCIONES TRASPASO DE ITEMES #############################
//------------------------------------------------------------------------------------
var C_TRASP_ITEM = 1, C_TRASP_ITEM_DESTINO = 2, C_TRASP_PRODUCTO = 3, C_TRASP_DESCRIPCION = 4, C_TRASP_CANT_M  = 5, C_TRASP_CANT_TRASPASO = 6

function Existe_Linea_de_Destino(z_row, z_num_linea_destino){
  v_num_grid = 1
  for(i=1;i<=t_rows;i++)
    if(i!=z_row && $("celda_" + v_num_grid + "_" + i + "_" + C_TRASP_ITEM_DESTINO).value==z_num_linea_destino)
      return true
  return false
}

function Valida_Traspaso_Itemes(){
  strNum_Lineas = ""
  v_num_grid = 1
  for(i=1;i<=t_rows;i++)  
  {
    if($("celda_" + v_num_grid + "_" + i + "_" + C_TRASP_ITEM_DESTINO).value!="")
    {
      if(parseFloat(Replace($("celda_" + v_num_grid + "_" + i + "_" + C_TRASP_CANT_TRASPASO).value,",","")) == 0)
      {
        Config_Msg_Accion(" Cantidad de traspaso en cero...",4000,$("msg_accion_3"))
        $("celda_" + v_num_grid + "_" + i + "_" + C_TRASP_CANT_TRASPASO).focus()
        return false
      }
      if(strNum_Lineas!="")
        strNum_Lineas = strNum_Lineas+delimiter
      strNum_Lineas = strNum_Lineas+$("celda_" + v_num_grid + "_" + i + "_" + C_TRASP_ITEM).value
    }
  }
  if(strNum_Lineas=="")
  {
    Config_Msg_Accion(" No ha ingresado itemes de destino...",4000,$("msg_accion_3"))
    return false
  }
  return true
}

function Traspasar_Itemes(){
  if(Valida_Traspaso_Itemes())
  {
    if(confirm("¿Está seguro que desea traspasar los ítemes a la TCP destino?."))
    {
      document.body.style.cursor = "wait"
      strCargando ="<br><br><br><br><br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
      strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Traspasando ítemes a TCP destino...espere un momento</b></font><br><br></center>"
      grilla_productos.innerHTML                = strCargando
      label_accion_modulo.innerHTML             = "TRASPASANDO ITEMES A TCP DESTINO..."
      fieldset_datos_generales.style.visibility = "hidden"
      fieldset_proveedor.style.visibility       = "hidden"
      fieldset_items.style.visibility           = "hidden"
      table_estado.style.visibility             = "hidden"
      label_legend_fieldset_productos.innerHTML = ""
      //async:false,
      var ajx = new Ajax("compras_traspasar_TCP.asp",{
        method:'post', 
        data: 'anio='+$("anio").value+
        '&documento_respaldo='+$("documento_respaldo").value+
        '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
        '&documento_no_valorizado='+$("documento_no_valorizado").value+
        '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
        '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value+
        '&traspaso_anio='+$("traspaso_anio").value+
        '&traspaso_documento_respaldo='+$("traspaso_documento_respaldo").value+
        '&traspaso_numero_documento_respaldo='+$("traspaso_numero_documento_respaldo").value+
        '&traspaso_numero_interno_documento_no_valorizado='+$("traspaso_numero_interno_documento_no_valorizado").value+
        '&traspaso_numero_documento_no_valorizado='+$("traspaso_numero_documento_no_valorizado").value+
        '&traspaso_bodega='+$("traspaso_bodega").value+
        '&traspaso_proveedor='+$("traspaso_proveedor").value+
        '&traspaso_fecha_movimiento='+$("traspaso_fecha_movimiento").value+
        '&traspaso_paridad='+$("traspaso_paridad").value,
        update:$("grilla_productos"),
        onComplete: function(respuesta){
          //alert(respuesta)
          //return
          document.body.style.cursor = "default"
          if(respuesta=="")
          {
            alert("Itemes traspasados correctamente!!!")
            window.location.reload()
          }
          else if(respuesta!="")
          {
            msg_error = "Ocurrió un error al tratar de traspasar los ítemes a la TCP destino\n"
            msg_error+= "Información técnica del error:\n"+respuesta+"\n"
            msg_error+= "Consulte con el administrador del sistema"
            alert(msg_error)
          }
        }
      });
      ajx.request();
    }
  }
}

function Cargar_Itemes_Traspaso(){
  strCargando ="<br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Cargando datos...espere un momento</b></font><br><br></center>"
  $("grilla_productos").innerHTML    = strCargando
  document.body.style.cursor    = "wait"
  $("grilla_productos").style.cursor = "wait"
  var ajx = new Ajax("compras_productos_grilla_traspaso.asp",{
    method:'post', 
    data: 'anio='+$("anio").value+
    '&documento_no_valorizado='+$("documento_no_valorizado").value+
    '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
    '&documento_respaldo='+$("documento_respaldo").value+
    '&numero_documento_respaldo='+$("numero_documento_respaldo").value,
    evalScripts:true,
    update:$("grilla_productos"),
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor    = ""
      $("grilla_productos").style.cursor = ""
      $("bot_traspasar_itemes").style.visibility   = ""
      $("bot_cancelar_traspaso").style.visibility  = ""
    }
  });
  ajx.request();
}

function Cancelar_Traspaso(){
  if(confirm("¿Está seguro que desea cancelar el traspaso de ítemes?. Se perderán los datos de ítemes de destino y cantidades de traspaso."))
  {
    
    $("fieldset_items").style.visibility             = ""
    $("traspaso_anio").disabled                      = false
    $("traspaso_documento_respaldo").disabled        = false
    $("traspaso_numero_documento_respaldo").disabled = false
    $("traspaso_numero_documento_respaldo").value    = ""
    $("bot_traspasar_itemes").style.visibility       = "hidden"
    $("bot_cancelar_traspaso").style.visibility      = "hidden"
    if(!$("checkbox_vista_pedidos").checked)
    {
      Mostrar_Form_Compra(true)
      $("fieldset_proveedor").style.visibility         = ""
      if($("documento_respaldo").value != "Z")
        $("td_total_cif_ori").style.visibility           = ""
      $("td_total_cif_adu").style.visibility           = ""
      if($("documento_respaldo").value == "Z")
      {
        $("td_total_ex_fab").style.visibility            = ""
        //$("td_total_fob").style.visibility               = ""
      }
      $("bot_verificar_itemes").style.visibility       = ""
    }
    if(perfil=="NORMAL")
      $("bot_cancelar_compra").style.visibility        = ""  
    Cargar_Items("EDITAR","")
  }
}
function Set_Traspaso_TCP(){
  Mostrar_Form_Compra(false)
  $("fieldset_proveedor").style.visibility         = "hidden"
  $("fieldset_items").style.visibility             = "hidden"
  $("td_total_cif_ori").style.visibility           = "hidden"
  $("td_total_cif_adu").style.visibility           = "hidden"
  $("td_total_ex_fab").style.visibility            = "hidden"
  //$("td_total_fob").style.visibility               = "hidden"
  $("traspaso_anio").disabled                      = true
  $("traspaso_documento_respaldo").disabled        = true
  $("traspaso_numero_documento_respaldo").disabled = true
  $("bot_verificar_itemes").style.visibility       = "hidden"
  $("bot_cancelar_compra").style.visibility        = "hidden"
  Cargar_Itemes_Traspaso()
}

function Buscar_TCP_de_Traspaso(){
  //Validar que la TCP destino no sea la misma que la TCP origen
  if($("anio").value == $("traspaso_anio").value && $("documento_respaldo").value == $("traspaso_documento_respaldo").value && $("numero_documento_respaldo").value == $("traspaso_numero_documento_respaldo").value)
  {
    Config_Msg_Accion(" TCP destino debe ser distinta a TCP origen...",5000,$("msg_accion_3"))
    return
  }
  if($("traspaso_numero_documento_respaldo").value=="")
    return
  var ajx_buscar_tcp_traspaso = new Ajax("compras_existe_TCP.asp",{
    method:'post', 
    async:false,
    data: 'traspaso_anio='+$("traspaso_anio").value+
    '&traspaso_documento_respaldo='+$("traspaso_documento_respaldo").value+
    '&traspaso_numero_documento_respaldo='+$("traspaso_numero_documento_respaldo").value+
    '&documento_no_valorizado='+$("documento_no_valorizado").value+
    '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
    '&documento_respaldo='+$("documento_respaldo").value+
    '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
    '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value,
    onComplete: function(respuesta){
      //alert(respuesta)
      if(respuesta!="")
      {
        $("msg_accion_3").innerHTML=""
        var array_doc_no_valorizado = respuesta.split("~")
        $("traspaso_numero_interno_documento_no_valorizado").value = array_doc_no_valorizado[0]
        $("traspaso_numero_documento_no_valorizado").value         = array_doc_no_valorizado[1]
        $("traspaso_bodega").value                                 = array_doc_no_valorizado[2]
        $("traspaso_proveedor").value                              = array_doc_no_valorizado[3]
        $("traspaso_fecha_movimiento").value                       = array_doc_no_valorizado[4]
        $("traspaso_paridad").value                                = array_doc_no_valorizado[5]
        Set_Traspaso_TCP()
      }
      else
      {
        $("traspaso_numero_documento_respaldo").value = ""
        Config_Msg_Accion(" No existe el documento TCP...",5000,$("msg_accion_3"))
      }
    }
  });
  ajx_buscar_tcp_traspaso.request();
}

//------------------------------------------------------------------------------------
//############################## FUNCIONES GENERALES #################################
//------------------------------------------------------------------------------------

function Get_Total_Cif_ORI_Y_ADU(){
  var ajx_get_total_cif_ori_y_adu = new Ajax(RutaProyecto+"compras/compras_get_total_cif_ORI_Y_ADU.asp",{
    method:'post', 
    async:false,
    data: 'documento_respaldo='+$("documento_respaldo").value+
    '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
    '&documento_no_valorizado='+$("documento_no_valorizado").value+
    '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
    '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value,
    onComplete: function(respuesta){
      //alert(respuesta)
      //Cargar los totales cif ori y adu, valores retornados desde ajax
      var x_totales = respuesta.split("~")
      $("label_total_cif_ori").innerHTML=Formateo_Completo_Numero(parseFloat(x_totales[0]).toFixed(2))
      $("label_total_cif_adu").innerHTML=Formateo_Completo_Numero(parseFloat(x_totales[1]).toFixed(2))
      Verificar_Totales_Costos()
    }
  });
  ajx_get_total_cif_ori_y_adu.request();
}

function Get_Total_Cif_ORI_ADU_EXFAB_FOB(){
  var ajx_get_total_cif_ori_adu_exfab_fob = new Ajax(RutaProyecto+"compras/compras_get_total_cif_ORI_ADU_EXFAB_FOB.asp",{
    method:'post', 
    async:false,
    data: 'documento_respaldo='+$("documento_respaldo").value+
    '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
    '&documento_no_valorizado='+$("documento_no_valorizado").value+
    '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
    '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value,
    onComplete: function(respuesta){
      //alert(respuesta)
      //Cargar los totales cif ori y adu, valores retornados desde ajax
      var x_totales = respuesta.split("~")
      
      cant_decimales_tot_cif_ori = 2
      if($("documento_respaldo").value=="DS")
        cant_decimales_tot_cif_ori = 4
      $("label_total_cif_ori").innerHTML=Formateo_Completo_Numero(parseFloat(x_totales[0]).toFixed(cant_decimales_tot_cif_ori));
      $("label_total_cif_adu").innerHTML=Formateo_Completo_Numero(parseFloat(x_totales[1]).toFixed(2));
      $("label_total_ex_fab").innerHTML=Formateo_Completo_Numero(parseFloat(x_totales[2]).toFixed(2));
      //$("label_total_fob").innerHTML=Formateo_Completo_Numero(parseFloat(x_totales[3]).toFixed(2));
      Verificar_Totales_Costos();
    }
  });
  ajx_get_total_cif_ori_adu_exfab_fob.request();
}

function Set_Restaurar_td_fec_aduana_y_bot_cancelar_cambio_num_aduana(){
  $("td_cab_1_1").innerHTML="<b>FEC. ADUANA:</b>"
}

function Set_Cancelar_Cambio_Numero_Aduana(){
  $("fieldset_proveedor").style.visibility             = ""
  $("fieldset_items").style.visibility                 = ""
  $("fieldset_productos").style.visibility             = ""
  $("table_estado").style.visibility                   = ""
  Mostrar_Form_Compra(true)
  if($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="DS")
  {
    $("td_cab_1_1").style.visibility="hidden"
    $("td_cab_1_2").style.visibility="hidden"
  }
  $("numero_documento_respaldo").readOnly              = true
  $("numero_documento_respaldo").style.backgroundColor = "#EEEEEE"
  Set_Restaurar_td_fec_aduana_y_bot_cancelar_cambio_num_aduana()
}

function Set_Cambiar_Numero_Aduana(){
  if(confirm("¿Está seguro que desea cambiar el N° ADUANA (N° de compra)?"))
  {
    $("fieldset_proveedor").style.visibility             = "hidden"
    $("fieldset_items").style.visibility                 = "hidden"
    $("fieldset_productos").style.visibility             = "hidden"
    $("table_estado").style.visibility                   = "hidden"
    Mostrar_Form_Compra(false)
    $("numero_documento_respaldo").readOnly              = false
    //$("numero_documento_respaldo").value                 = ""
    $("numero_documento_respaldo").style.backgroundColor = ""
    $("numero_documento_respaldo").focus()
    
    strCancelaNumAduana = "<input class='boton_Cancelar' type='button' title='Cancelar cambio N° ADUANA' "
    strCancelaNumAduana+= "OnClick='$(\'numero_documento_respaldo\').value=$(\'numero_documento_respaldo\').getAttribute(\'o_value\');"
    strCancelaNumAduana+= "Set_Cancelar_Cambio_Numero_Aduana()' "
    strCancelaNumAduana+= "id='bot_cancelar_num_aduana' name='bot_cancelar_num_aduana'>"
    $("td_cab_1_1").innerHTML= strCancelaNumAduana
    $("td_cab_1_1").style.visibility = ""
  }
}

function Set_Opciones_Compra(v_fila_compra){
  SetChecked_Radio(document.getElementsByName("radio_compras"),v_fila_compra)
  doc_no_valorizado = Get_Atributo_Radio_Compras_Checked("DOCUMENTO_NO_VALORIZADO")
  SetBackgroundImageInput($("bot_eliminar"),RutaProyecto+"imagenes/ico_eliminar_24X24_off.gif")
  $("bot_eliminar").disabled = true
  if(doc_no_valorizado=="TCP")
  {
    SetBackgroundImageInput($("bot_eliminar"),RutaProyecto+"imagenes/ico_eliminar_24X24_on.gif")
    $("bot_eliminar").disabled = false
  }
}

function Terminar_Compra(){
  if(confirm("¿Está seguro que desea finalizar la compra?.\n(Traspasar a RCP)"))
  {
    if($("bot_terminar_compra").getAttribute("advertencia")!="")
    {
      Config_Msg_Accion(" Advertencia: "+bot_terminar_compra.advertencia+"...",5000,$("msg_accion_3"))
      if(confirm("ADVERTENCIA: "+bot_terminar_compra.advertencia+"\n¿Desea cancelar el ingreso de la compra RCP?\n(Para finalizar la compra haga clic en \"Cancelar\")"))
        return;
    }
    document.body.style.cursor = "wait"
    strCargando ="<br><br><br><br><br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
    strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Finalizando compra...espere un momento</b></font><br><br></center>"
    $("grilla_productos").innerHTML                = strCargando
    $("label_accion_modulo").innerHTML             = "FINALIZANDO COMPRA..."
    $("fieldset_datos_generales").style.visibility = "hidden"
    $("fieldset_proveedor").style.visibility       = "hidden"
    $("fieldset_items").style.visibility           = "hidden"
    $("table_estado").style.visibility             = "hidden"
    $("label_legend_fieldset_productos").innerHTML = ""
    //async:false,
    var ajx = new Ajax("compras_grabar_RCP.asp",{
      method:'post', 
      data: 'documento_respaldo='+$("documento_respaldo").value+
      '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
      '&documento_no_valorizado='+$("documento_no_valorizado").value+
      '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
      '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value+
      '&bodega='+$("bodega").value, 
      update:$("grilla_productos"),
      onComplete: function(respuesta){
        //alert(respuesta)
        document.body.style.cursor = "default"
        if(respuesta=="")
        {
          alert("Compra grabada satisfactoriamente!!!")
          document.location.href=RutaProyecto+"compras/compras.asp"
          //Puede que el evento "reload" esté generando un problema en la ejecucíón de los scripts (Mensaje: Ejecución de script con lentitud, desea detener "SI" "NO")
          //Se cambio por "location.href"
          //window.location.reload() 
        }
        else if(respuesta!="")
        {
          msg_error = "Ocurrió un error al tratar de finalizar la compra\n"
          msg_error+= "Información técnica del error:\n"+respuesta+"\n"
          msg_error+= "Consulte con el administrador del sistema"
          alert(msg_error)
        }
      }
    });
    ajx.request();
  }
}

function Config_Msg_Accion(str_Msg_Accion,v_tiempo,id_msg_accion){
  id_msg_accion.innerHTML = str_Msg_Accion
  //alert(id_msg_accion.id)
  if(id_msg_accion.id=="msg_accion_1")
    setTimeout("$('msg_accion_1').innerHTML=''",v_tiempo);
  else if(id_msg_accion.id=="msg_accion_2")
    setTimeout("$('msg_accion_2').innerHTML=''",v_tiempo);
  else if(id_msg_accion.id=="msg_accion_3")
    setTimeout("$('msg_accion_3').innerHTML=''",v_tiempo);
}

function Actualizar_Datos_Compra(v_nom_campo,v_valor){
  //alert(v_nom_campo+": "+v_valor)
  if(v_nom_campo=="monto_neto_US$" || v_nom_campo=="monto_adu_US$" || v_nom_campo=="total_ex_fab")
    v_valor = Replace(v_valor,",","")
  document.body.style.cursor = "wait"
  var ajx4 = new Ajax("compras_grabar.asp",{
    method:'post', 
    async:false,
    data: 'accion=actualizar&anio='+$("anio").value+'&documento_respaldo='+$("documento_respaldo").value+
    '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
    '&documento_no_valorizado='+$("documento_no_valorizado").value+
    '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
    '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value+
    '&monto_ADU='+$("monto_adu_US$").value+
    '&paridad='+$("label_paridad_para_facturacion").innerHTML+
    '&proveedor='+$("label_proveedor_cabecera").getAttribute("rut")+
    '&proveedor_2='+$("entidad_comercial_2").value+
    '&nom_campo='+v_nom_campo+'&valor='+v_valor,
    onComplete: function(respuesta){
      //alert(respuesta)
      //$("msg_accion_3").innerHTML=respuesta
      //return
      document.body.style.cursor = "default"
      if(v_nom_campo=="numero_documento_respaldo")
      {
        if(respuesta=="EXISTE")
        {
          alert("YA EXISTE EL N° ("+$("numero_documento_respaldo").value+") EN OTRO DOCUMENTO ("+$("documento_respaldo").value+") DEL AÑO ("+$("anio").value+")")
          Config_Msg_Accion(" Ya existe el n° ("+$("numero_documento_respaldo").value+") en otro documento ("+$("documento_respaldo").value+") del año ("+$("anio").value+")...",5000,$("msg_accion_3"))
          numero_documento_respaldo.focus()
        }
        else
        {
          Set_Cancelar_Cambio_Numero_Aduana()
          $("numero_documento_respaldo").setAttribute("o_value", $("numero_documento_respaldo").value.toString())
          Config_Msg_Accion(" N° aduana actualizado...",5000,$("msg_accion_3"))
        }
      }
      else if(v_nom_campo=="proveedor")
      {
        $("td_cab_1_8").style.visibility                     = ""
        if($("label_proveedor_cabecera").innerHTML=="")
          Config_Msg_Accion(" Proveedor inicial ingresado...",5000,$("msg_accion_3"))
        else
          Config_Msg_Accion(" Proveedor incial actualizado...",5000,$("msg_accion_3"))
        $("label_proveedor_cabecera").innerHTML              = $("codprov_proveedor").value
        $("label_proveedor_cabecera").setAttribute("inicial", $("codprov_proveedor").value.toString())
        $("label_proveedor_cabecera").setAttribute("rut", $("entidad_comercial").value.toString())
        $("entidad_comercial").setAttribute("o_value", v_valor.toString());
        Cargar_Items("EDITAR","")
      }
      else if(v_nom_campo=="proveedor_2")
      {
        if(v_valor!="")
        {
          $("td_datos_2_proveedor_1").style.visibility = ""
          $("td_datos_2_proveedor_2").style.visibility = ""
          $("td_datos_2_proveedor_3").style.visibility = ""
          $("entidad_comercial_2").value               = $("entidad_comercial").value
          $("codprov_proveedor_2").value               = $("codprov_proveedor").value
          Config_Msg_Accion(" Proveedor secundario asignado...",5000,$("msg_accion_3"))
        }
        else
        {
          $("td_datos_2_proveedor_1").style.visibility = "hidden"
          $("td_datos_2_proveedor_2").style.visibility = "hidden"
          $("td_datos_2_proveedor_3").style.visibility = "hidden"
          $("entidad_comercial_2").value               = ""
          $("codprov_proveedor_2").value               = ""
          Config_Msg_Accion(" Proveedor secundario eliminado...",5000,$("msg_accion_3"))
        }
        $("entidad_comercial").setAttribute("o_value",$("label_proveedor_cabecera").getAttribute("rut").toString());
        Set_Cancelar_Proveedor()
        Cargar_Items("EDITAR","")
      }
      else if(v_nom_campo=="carpeta")
      {
        $("td_cab_2_9").style.visibility   = ""
        $("td_cab_2_10").style.visibility  = ""
        //$("label_transporte").innerHTML    = $("carpeta").options[$("carpeta").options.selectedIndex].getAttribute("transporte")
        $("carpeta").disabled              = true
        $("carpeta").style.backgroundColor = "#EEEEEE"
        $("carpeta").setAttribute("old_value", v_valor.toString());
        $("fieldset_proveedor").style.visibility = ""
        $("td_buscar_proveedor").style.visibility = ""
        Config_Msg_Accion(" Carpeta asignada correctamente...",5000,$("msg_accion_3"))
        
        if($("documento_no_valorizado").value=="TCP" && $("documento_respaldo").value=="Z")
          Set_Total_CIF_ADU_From_Facturas_Carpeta($("carpeta").value)
      }
      else if(v_nom_campo=="paridad_conversion_a_dolar")
        Cargar_Items("EDITAR","")
      else if(v_nom_campo=="fecha_emision" || v_nom_campo=="fecha_recepcion" || v_nom_campo=="fecha_factura")
      {
        cell_campo_fecha = eval(v_nom_campo)
        cell_campo_fecha.setAttribute("o_value", v_valor.toString())
        Config_Msg_Accion(" Datos actualizados...",5000,$("msg_accion_3"))
      }
      else if(v_nom_campo=="numero_factura")
        $("numero_factura").setAttribute("o_value", v_valor.toString())
      else
      {
        if(v_nom_campo=="monto_neto_US$" || v_nom_campo=="monto_adu_US$" || v_nom_campo=="total_ex_fab")
        {
          if(v_nom_campo=="monto_neto_US$")
          {
            $("monto_neto_US$").value    = Formateo_Completo_Numero(parseFloat(v_valor).toFixed(2))
            $("monto_neto_US$").setAttribute("o_value", $("monto_neto_US$").value.toString())
          }
          else if(v_nom_campo=="monto_adu_US$")
          {
            $("monto_adu_US$").value     = Formateo_Completo_Numero(parseFloat(v_valor).toFixed(2))
            $("monto_adu_US$").setAttribute("o_value", $("monto_adu_US$").value.toString())
          }
          else if(v_nom_campo=="total_ex_fab")
          {
            $("total_ex_fab").value     = Formateo_Completo_Numero(parseFloat(v_valor).toFixed(2))
            $("total_ex_fab").setAttribute("o_value", $("total_ex_fab").value.toString())
          }
          if($("documento_respaldo").value!="TU" && $("documento_respaldo").value!="DS")
          {
            $("monto_neto_US$").value    = $("monto_adu_US$").value
            $("monto_neto_US$").setAttribute("o_value", $("monto_neto_US$").value.toString())
          }
          //Set_Totales_Costos()
        }
        else
          $("bultos").setAttribute("o_value", $("bultos").value.toString())
        Config_Msg_Accion(" Datos actualizados...",5000,$("msg_accion_3"))
      }
      
      //####################################################################################################################################
      //Cualquier cambio que se haga en los valores generales de la compra se debe limpiar los botones de validación y termino de compra
      $("bot_informacion_to_RCP").title            = ""
      $("bot_informacion_to_RCP").setAttribute("campo_error","")
      $("bot_informacion_to_RCP").style.visibility = "hidden"
      $("bot_terminar_compra").style.visibility    = "hidden"
      //####################################################################################################################################
    }
  });
  ajx4.request();
}

function Cargar_Carpetas(){
  var ajx = new Ajax("compras_cargar_select_carpetas.asp",{
    method:'post', 
    async:false,
    data: 'documento_respaldo='+$("documento_respaldo").value+'&anio='+$("anio").value, 
    update:$("td_carpetas"),
    onComplete: function(respuesta){
      //alert(respuesta)
    }
  });
  ajx.request();
}

function Asignar_Carpeta(){
  //Validar campos de cabecera necesarios
  if($("fecha_emision").value=="" && ($("documento_respaldo").value!="TU" && $("documento_respaldo").value!="DS"))
  {
    Config_Msg_Accion(" Ingrese fecha aduana...",5000,$("msg_accion_3"))
    $("carpeta").value = $("carpeta").getAttribute("old_value")
    return;
  }
  else if($("fecha_recepcion").value=="")
  {
    Config_Msg_Accion(" Ingrese fecha recepción...",5000,$("msg_accion_3"))
    $("carpeta").value = $("carpeta").getAttribute("old_value")
    return;
  }
  else if(parseFloat($("monto_neto_US$").value)==0)
  {
    Config_Msg_Accion(" Ingrese Total Cif Ori...",5000,$("msg_accion_3"))
    $("carpeta").value = $("carpeta").getAttribute("old_value")
    return;
  }
  else if(parseFloat($("monto_adu_US$").value)==0)
  {
    Config_Msg_Accion(" Ingrese Total Cif Adu...",5000,$("msg_accion_3"))
    $("carpeta").value = $("carpeta").getAttribute("old_value")
    return;
  }
  else if(parseFloat($("label_paridad_para_facturacion").innerHTML) <= 1)
  {
    Config_Msg_Accion(" Paridad incorrecta...",5000,$("msg_accion_3"))
    $("carpeta").value = $("carpeta").getAttribute("old_value")
    return;
  }
  if(confirm("¿Está seguro que desea asignar esta carpeta a la compra?"))
    Actualizar_Datos_Compra("carpeta",$("carpeta").value)
  else
    $("carpeta").value = $("carpeta").getAttribute("old_value")
}

function Set_Total_CIF_ADU_From_Facturas_Carpeta(x_carpeta){
  var ajx = new Ajax(RutaProyecto+"compras/compras_get_total_cif_adu_from_facturas_carpeta.asp",{
    method:'post', 
    async:false,
    data: 'carpeta='+x_carpeta,
    onComplete: function(respuesta){
      //alert(respuesta)
      //console.log(respuesta)
      if($("monto_adu_US$").value != respuesta)
      {
        $("monto_neto_US$").value = respuesta
        $("monto_neto_US$").setAttribute("o_value",respuesta)
        $("monto_adu_US$").value = respuesta
        $("monto_adu_US$").setAttribute("o_value",respuesta)
        
        Actualizar_Datos_Compra("monto_adu_US$",$("monto_adu_US$").value)
      }
    }
  });
  ajx.request();
}

function Get_Atributo_Radio_Compras_Checked(v_atributo){
  if(Radio_Es_Arreglo(document.getElementsByName("radio_compras")))
  {
    for(i=0;i<=document.getElementsByName("radio_compras").length-1;i++)
      if(document.getElementsByName("radio_compras")[i].checked==true)
      {      
        v_documento_no_valorizado   = document.getElementsByName("radio_compras")[i].getAttribute("documento_no_valorizado")
        v_numero_documento_respaldo = document.getElementsByName("radio_compras")[i].getAttribute("numero_documento_respaldo")
        v_documento_respaldo        = document.getElementsByName("radio_compras")[i].getAttribute("documento_respaldo")
        v_proveedor                 = document.getElementsByName("radio_compras")[i].getAttribute("proveedor")
        v_nombre_proveedor          = document.getElementsByName("radio_compras")[i].getAttribute("nombre_proveedor")
        v_fecha_emision             = document.getElementsByName("radio_compras")[i].getAttribute("fecha_emision")
        v_paridad                   = document.getElementsByName("radio_compras")[i].getAttribute("paridad")
        v_total_cif_ori             = document.getElementsByName("radio_compras")[i].getAttribute("total_cif_ori")
        v_total_cif_adu             = document.getElementsByName("radio_compras")[i].getAttribute("total_cif_adu")
        break;
      }
  }
  else
  {
    v_documento_no_valorizado   = document.getElementsByName("radio_compras").getAttribute("documento_no_valorizado")
    v_numero_documento_respaldo = document.getElementsByName("radio_compras").getAttribute("numero_documento_respaldo")
    v_documento_respaldo        = document.getElementsByName("radio_compras").getAttribute("documento_respaldo")
    v_proveedor                 = document.getElementsByName("radio_compras").getAttribute("proveedor")
    v_nombre_proveedor          = document.getElementsByName("radio_compras").getAttribute("nombre_proveedor")
    v_fecha_emision             = document.getElementsByName("radio_compras").getAttribute("fecha_emision")
    v_paridad                   = document.getElementsByName("radio_compras").getAttribute("paridad")
    v_total_cif_ori             = document.getElementsByName("radio_compras").getAttribute("total_cif_ori")
    v_total_cif_adu             = document.getElementsByName("radio_compras").getAttribute("total_cif_adu")
  }
  if(v_atributo=="DOCUMENTO_NO_VALORIZADO")
    valor = v_documento_no_valorizado
  return valor;
}

function Cargar_Paridades_X_Fecha(){
  var ajx = new Ajax(RutaProyecto+"funciones_SYS_AJAX/AJAX_Get_Paridad_X_Fecha.asp",{
    method:'post', 
    async:false,
    data: 'fecha='+$("fecha_recepcion").value,
    onComplete: function(respuesta){
      //alert(respuesta)
      var paridades = respuesta.split("~")
      $("label_paridad_para_facturacion").innerHTML  = paridades[0]
      $("paridad_margen").value                      = paridades[1]
      Actualizar_Datos_Compra("paridad_conversion_a_dolar",paridades[0])
    }
  });
  ajx.request();
}

function Grabar_Compra_Inicial(){
  //Primero se debe chequear si existe el numero_respaldo que se está ingresando-->Si existe
  //se deben cargar la compra del numero de respaldo y configurar el formulario como si se estuviera
  //editando la compra
  document.body.style.cursor = "wait"
  var ajx = new Ajax("compras_existe.asp",{
    method:'post', 
    async:false,
    data: 'anio='+$("anio").value+'&documento_respaldo='+$("documento_respaldo").value+'&numero_documento_respaldo='+$("numero_documento_respaldo").value,
    onComplete: function(respuesta){
      document.body.style.cursor = "default"
      //alert(respuesta)
      if(respuesta=="EXISTE")
      {
        //Configurar formulario a edición de compra
        $("buscar_anio").value                       = $("anio").value
        $("buscar_documento_respaldo").value         = $("documento_respaldo").value
        $("buscar_numero_documento_respaldo").value  = $("numero_documento_respaldo").value
        $("buscar_check_RCP").checked                = true
        Buscar_Compras(false,0,'')
        Editar_Compra()
        Config_Msg_Accion(" Compra existente...",5000,$("msg_accion_3"))
      }
      else
      {
        if(confirm("¿Está seguro que desea grabar esta compra?"))
        {
          document.body.style.cursor = "wait"
          var ajx1 = new Ajax("compras_grabar.asp",{
            method:'post', 
            async:false,
            data: 'accion=insertar&documento_respaldo='+$("documento_respaldo").value+
            '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
            '&documento_no_valorizado=TCP',
            onComplete: function(respuesta){
              //alert(respuesta)
              //$("msg_accion_3").innerHTML=respuesta
              document.body.style.cursor                      = "default"
              $("anio").disabled                                   = true
              $("anio").style.backgroundColor                      = "#EEEEEE"
              $("documento_respaldo").disabled                     = true
              $("documento_respaldo").style.backgroundColor        = "#EEEEEE"
              $("numero_documento_respaldo").readOnly              = true
              $("numero_documento_respaldo").style.backgroundColor = "#EEEEEE"
              $("numero_documento_respaldo").setAttribute("o_value", $("numero_documento_respaldo").value.toString())
              $("documento_no_valorizado").value                   = "TCP" //Ojo!! que este valor puede cambiar a PCP cuando se comiencen a guardar los pedidos
              var claves_compra = respuesta.split("~")
              $("numero_documento_no_valorizado").value            = claves_compra[0]
              $("numero_interno_documento_no_valorizado").value    = claves_compra[1]
              Mostrar_Form_Compra(true)
              if($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="DS")
              {
                $("td_cab_1_1").style.visibility="hidden"
                $("td_cab_1_2").style.visibility="hidden"
              }
              $("td_cab_2_1").style.visibility   = "hidden"
              $("td_cab_2_2").style.visibility   = "hidden"
              $("td_cab_2_3").style.visibility   = "hidden"
              $("td_cab_1_8").style.visibility   = "hidden"
              $("td_cab_2_9").style.visibility   = "hidden"
              $("td_cab_2_10").style.visibility  = "hidden"
              $("bot_actualizar_proveedor_items").style.visibility  = ""
              if($("documento_respaldo").value!="Z")
              {
                $("td_cab_2_1").style.visibility=""
                $("td_cab_2_2").style.visibility=""
                $("td_cab_2_3").style.visibility=""
                $("bot_actualizar_proveedor_items").style.visibility  = "hidden"
              }
              //Cargar_Paridades_X_Fecha() //--> No se van a buscar la paridades, porque la fecha de recepción no se ha ingresado
              Cargar_Carpetas()
              $("monto_neto_US$").disabled               = true
              $("monto_neto_US$").style.backgroundColor  = "#EEEEEE"
              $("fecha_emision").value                   = ""
              $("fecha_recepcion").value                 = ""
              $("fecha_factura").value                   = ""
              if($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="DS")
              {
                $("monto_neto_US$").disabled               = false
                $("monto_neto_US$").style.backgroundColor  = ""
              }
              Config_Msg_Accion(" Compra grabada satisfactoriamente...",5000,$("msg_accion_3"))
            }
          });
          ajx1.request();
        }
        else
        {
          $("numero_documento_respaldo").value=""
          $("numero_documento_respaldo").focus()
        }
      }
    }
  });
  ajx.request();
}

function Mostrar_Form_Compra(v_band){
  if(v_band)
  {
    $("td_cab_1_1").style.visibility=""
    $("td_cab_1_2").style.visibility=""
    $("td_cab_1_3").style.visibility=""
    $("td_cab_1_4").style.visibility=""
    $("td_cab_1_5").style.visibility=""
    $("td_cab_1_6").style.visibility=""
    $("td_cab_1_7").style.visibility=""
    $("td_cab_1_8").style.visibility=""
    $("tr_cab_2").style.visibility=""
  }
  else
  {
    $("td_cab_1_1").style.visibility="hidden"
    $("td_cab_1_2").style.visibility="hidden"
    $("td_cab_1_3").style.visibility="hidden"
    $("td_cab_1_4").style.visibility="hidden"
    $("td_cab_1_5").style.visibility="hidden"
    $("td_cab_1_6").style.visibility="hidden"
    $("td_cab_1_7").style.visibility="hidden"
    $("td_cab_1_8").style.visibility="hidden"
    $("tr_cab_2").style.visibility="hidden"
  }
}

function Editar_Compra(){
  if(Radio_Es_Arreglo(document.getElementsByName("radio_compras")))
  {
    for(i=0;i<=document.getElementsByName("radio_compras").length-1;i++)
      if(document.getElementsByName("radio_compras")[i].checked==true)
      { 
        v_anio                                    = document.getElementsByName("radio_compras")[i].getAttribute("anio")
        v_numero_interno_documento_no_valorizado  = document.getElementsByName("radio_compras")[i].getAttribute("numero_interno_documento_no_valorizado")
        v_documento_no_valorizado                 = document.getElementsByName("radio_compras")[i].getAttribute("documento_no_valorizado")
        v_numero_documento_no_valorizado          = document.getElementsByName("radio_compras")[i].getAttribute("numero_documento_no_valorizado")
        v_numero_documento_respaldo               = document.getElementsByName("radio_compras")[i].getAttribute("numero_documento_respaldo")
        v_documento_respaldo                      = document.getElementsByName("radio_compras")[i].getAttribute("documento_respaldo")
        v_proveedor                               = document.getElementsByName("radio_compras")[i].getAttribute("proveedor")
        v_proveedor_2                             = document.getElementsByName("radio_compras")[i].getAttribute("proveedor_2")
        v_nombre_proveedor                        = document.getElementsByName("radio_compras")[i].getAttribute("nombre_proveedor")
        v_codigo_postal                           = document.getElementsByName("radio_compras")[i].getAttribute("codigo_postal")
        v_fecha_emision                           = document.getElementsByName("radio_compras")[i].getAttribute("fecha_emision")
        v_fecha_recepcion                         = document.getElementsByName("radio_compras")[i].getAttribute("fecha_recepcion")
        v_numero_factura                          = document.getElementsByName("radio_compras")[i].getAttribute("numero_factura")
        v_fecha_factura                           = document.getElementsByName("radio_compras")[i].getAttribute("fecha_factura")
        v_paridad                                 = document.getElementsByName("radio_compras")[i].getAttribute("paridad")
        v_paridad_margen                          = document.getElementsByName("radio_compras")[i].getAttribute("paridad_margen")
        v_total_cif_ori                           = document.getElementsByName("radio_compras")[i].getAttribute("total_cif_ori")
        v_total_cif_adu                           = document.getElementsByName("radio_compras")[i].getAttribute("total_cif_adu")
        v_total_ex_fab                            = document.getElementsByName("radio_compras")[i].getAttribute("total_ex_fab")
        v_bodega                                  = document.getElementsByName("radio_compras")[i].getAttribute("bodega")
        v_carpeta                                 = document.getElementsByName("radio_compras")[i].getAttribute("carpeta")
        v_tipo_oc                                 = document.getElementsByName("radio_compras")[i].getAttribute("tipo_oc")
        v_bultos                                  = document.getElementsByName("radio_compras")[i].getAttribute("bultos")
        break;
      }
  }
  else
  {
    v_anio                                    = document.getElementsByName("radio_compras").getAttribute("anio")
    v_numero_interno_documento_no_valorizado  = document.getElementsByName("radio_compras").getAttribute("numero_interno_documento_no_valorizado")
    v_documento_no_valorizado                 = document.getElementsByName("radio_compras").getAttribute("documento_no_valorizado")
    v_numero_documento_no_valorizado          = document.getElementsByName("radio_compras").getAttribute("numero_documento_no_valorizado")
    v_numero_documento_respaldo               = document.getElementsByName("radio_compras").getAttribute("numero_documento_respaldo")
    v_documento_respaldo                      = document.getElementsByName("radio_compras").getAttribute("documento_respaldo")
    v_proveedor                               = document.getElementsByName("radio_compras").getAttribute("proveedor")
    v_proveedor_2                             = document.getElementsByName("radio_compras").getAttribute("proveedor_2")
    v_nombre_proveedor                        = document.getElementsByName("radio_compras").getAttribute("nombre_proveedor")
    v_codigo_postal                           = document.getElementsByName("radio_compras").getAttribute("codigo_postal")
    v_fecha_emision                           = document.getElementsByName("radio_compras").getAttribute("fecha_emision")
    v_fecha_recepcion                         = document.getElementsByName("radio_compras").getAttribute("fecha_recepcion")
    v_numero_factura                          = document.getElementsByName("radio_compras").getAttribute("numero_factura")
    v_fecha_factura                           = document.getElementsByName("radio_compras").getAttribute("fecha_factura")
    v_paridad                                 = document.getElementsByName("radio_compras").getAttribute("paridad")
    v_paridad_margen                          = document.getElementsByName("radio_compras").getAttribute("paridad_margen")
    v_total_cif_ori                           = document.getElementsByName("radio_compras").getAttribute("total_cif_ori")
    v_total_cif_adu                           = document.getElementsByName("radio_compras").getAttribute("total_cif_adu")
    v_total_ex_fab                            = document.getElementsByName("radio_compras").getAttribute("total_ex_fab")
    v_bodega                                  = document.getElementsByName("radio_compras").getAttribute("bodega")
    v_carpeta                                 = document.getElementsByName("radio_compras").getAttribute("carpeta")
    v_tipo_oc                                 = document.getElementsByName("radio_compras").getAttribute("tipo_oc")
    v_bultos                                  = document.getElementsByName("radio_compras").getAttribute("bultos")
  }
  $("numero_interno_documento_no_valorizado").value    = v_numero_interno_documento_no_valorizado
  //console.log($("numero_interno_documento_no_valorizado").value)
  $("anio").value                                      = v_anio
  $("anio").disabled                                   = true
  $("anio").style.backgroundColor                      = "#EEEEEE"
  $("documento_no_valorizado").value                   = v_documento_no_valorizado
  $("numero_documento_no_valorizado").value            = v_numero_documento_no_valorizado
  $("documento_respaldo").disabled                     = true
  $("documento_respaldo").style.backgroundColor        = "#EEEEEE"
  $("documento_respaldo").value                        = v_documento_respaldo
  
  $("numero_documento_respaldo").readOnly              = true
  $("numero_documento_respaldo").style.backgroundColor = "#EEEEEE"
  $("numero_documento_respaldo").value                 = v_numero_documento_respaldo
  $("numero_documento_respaldo").setAttribute("o_value", v_numero_documento_respaldo.toString())
  $("fecha_emision").value                             = v_fecha_emision //FECHA LEG. ADUANA
  $("fecha_emision").setAttribute("o_value",v_fecha_emision) //FECHA LEG. ADUANA
  $("fecha_recepcion").value                           = v_fecha_recepcion
  $("fecha_recepcion").setAttribute("o_value",v_fecha_recepcion)
  
  
  //No se hace esta carga--> Se agregó la validación con ajax cuando se está verificando la compra
  //if($("fecha_recepcion").value!="")
  //  Set_PARIDAD_para_validacion_segun_FECHA_RECEPCION()
  
  $("numero_factura").value                            = v_numero_factura
  $("numero_factura").setAttribute("o_value", v_numero_factura)
  $("fecha_factura").value                             = v_fecha_factura
  $("fecha_factura").setAttribute("o_value", v_fecha_factura)
  $("monto_neto_US$").value                            = v_total_cif_ori
  $("monto_neto_US$").setAttribute("o_value", v_total_cif_ori)
  $("monto_adu_US$").value                             = v_total_cif_adu
  $("monto_adu_US$").setAttribute("o_value", v_total_cif_adu)
  $("total_ex_fab").value                             = v_total_ex_fab
  $("total_ex_fab").setAttribute("o_value", v_total_ex_fab)
  $("bodega").value                                    = v_bodega
  $("label_paridad_para_facturacion").innerHTML        = v_paridad
  $("paridad_margen").value                            = v_paridad_margen
  
  $("bultos").value                                    = v_bultos
  $("bultos").setAttribute("o_value", v_bultos)
  
  Mostrar_Form_Compra(true)
  if($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="DS")
  {
    $("td_cab_1_1").style.visibility="hidden"
    $("td_cab_1_2").style.visibility="hidden"
  }
  $("td_cab_1_8").style.visibility="hidden"
  if(v_proveedor!="")
  {
    $("entidad_comercial").value                         = v_proveedor
    $("entidad_comercial").setAttribute("o_value", v_proveedor.toString())
  
    //SE BLOQUEA LA BODEGA PORQUE NO SE PERMITE ACTUALIZARLA DEBIDO A LAS ASOCIACIONES QUE EXISTEN EN PRODUCTOS_EN_BODEGAS (STOCK_EN_TRANSITO)
    $("bodega").disabled                                 = true
    $("bodega").style.backgroundColor                    = "#EEEEEE"
    $("entidad_comercial").disabled                      = true
    $("entidad_comercial").style.backgroundColor         = "#EEEEEE"
    $("dig_verificador").value                           = Get_Digito_Verificador_Rut(v_proveedor);
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //Set_CODPROV(v_proveedor,$("codprov_proveedor"))
    $("codprov_proveedor").value                         = v_codigo_postal
    ///////////////////////////////////////////////////////////////////////////////////////////////
    $("td_datos_proveedor").style.visibility             = ""
    $("td_datos_codprov_proveedor").style.visibility     = ""
    $("td_cab_1_8").style.visibility                     = ""
    $("label_proveedor_cabecera").innerHTML              = $("codprov_proveedor").value
    $("label_proveedor_cabecera").setAttribute("rut", v_proveedor.toString())
    $("label_proveedor_cabecera").setAttribute("inicial", $("codprov_proveedor").value.toString())
    //$("codprov_proveedor").value = "WWWWWWWWWWWW"
    
    if(v_documento_no_valorizado=="TCP")
    {
	    $("td_bot_func_proveedor").style.visibility  = ""
	    $("td_agrupar_items1").style.visibility      = ""
	    $("td_agrupar_items2").style.visibility      = ""
	    $("td_agrupar_items3").style.visibility      = ""
      $("td_items").style.visibility               = ""
      $("td_bot_agregar_items").style.visibility   = ""
    }
    if(v_proveedor_2!="")
    {
      Set_CODPROV(v_proveedor_2,$("codprov_proveedor_2"))
      $("entidad_comercial_2").value               = v_proveedor_2
      $("td_datos_2_proveedor_1").style.visibility = ""
      $("td_datos_2_proveedor_2").style.visibility = ""
      if(v_documento_no_valorizado=="TCP")
        $("td_datos_2_proveedor_3").style.visibility = ""
    }
  }
  
  $("grilla_compras").style.visibility                 = "hidden"
  $("tabla_botonera_general").style.visibility         = "hidden"
  
  $("capaDatosCompra").style.visibility                = ""
  $("capaDatosCompra").style.zIndex                    = 1
  $("td_cab_2_1").style.visibility="hidden"
  $("td_cab_2_2").style.visibility="hidden"
  $("td_cab_2_3").style.visibility="hidden"
  if($("documento_respaldo").value!="Z")
  {
    $("td_cab_2_1").style.visibility=""
    $("td_cab_2_2").style.visibility=""
    $("td_cab_2_3").style.visibility=""
  }
  $("monto_neto_US$").disabled               = true
  $("monto_neto_US$").style.backgroundColor  = "#EEEEEE"
  if( ($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="DS") && v_documento_no_valorizado=="TCP")
  {
    $("monto_neto_US$").disabled               = false
    $("monto_neto_US$").style.backgroundColor  = ""
  }
  Cargar_Carpetas()
  $("carpeta").value                   = v_carpeta
  //if(v_carpeta!="")
  //  $("label_transporte").innerHTML      = $("carpeta").options[$("carpeta").options.selectedIndex].getAttribute("transporte")
  $("tipo_oc").value = v_tipo_oc
  $("tipo_oc").checked = false
  if($("tipo_oc").value=="P")
    $("tipo_oc").checked = true
  $("td_cab_2_9").style.visibility     = "hidden"
  $("td_cab_2_10").style.visibility    = "hidden"
  $("fieldset_items").style.visibility = "hidden"
  if(v_documento_no_valorizado=="TCP")
  {
    $("label_accion_modulo").innerHTML         = "EDITANDO COMPRA - "+v_documento_no_valorizado
    $("numero_documento_respaldo").title       = "Haga doble clic para editar el N° ADUANA"
    if($("carpeta").value!="")
    {
      $("carpeta").setAttribute("old_value",$("carpeta").value)
      $("carpeta").disabled                    = true
      $("carpeta").style.backgroundColor       = "#EEEEEE"
      $("td_cab_2_9").style.visibility         = ""
      $("td_cab_2_10").style.visibility        = ""
      $("fieldset_proveedor").style.visibility = ""
      if(v_proveedor!="")
      {
        $("fieldset_productos").style.visibility = ""
        $("fieldset_items").style.visibility     = ""
        if($("documento_respaldo").value != "Z")
          $("td_total_cif_ori").style.visibility   = ""
        $("td_total_cif_adu").style.visibility   = ""
        if($("documento_respaldo").value == "Z")
          $("td_total_ex_fab").style.visibility    = ""
        //$("td_total_fob").style.visibility       = ""
      }
      else
        $("td_buscar_proveedor").style.visibility = ""
    } 
    else
    {
      $("fieldset_proveedor").style.visibility = "hidden"
      $("fieldset_productos").style.visibility = "hidden"
      $("fieldset_items").style.visibility     = "hidden"
    }
    
  }
  else
  {
    $("fecha_emision").disabled                        = true
    $("fecha_emision").style.backgroundColor           = "#EEEEEE"
    $("fecha_recepcion").disabled                      = true
    $("fecha_recepcion").style.backgroundColor         = "#EEEEEE"
    $("numero_factura").disabled                       = true
    $("numero_factura").style.backgroundColor          = "#EEEEEE"
    $("fecha_factura").disabled                        = true
    $("fecha_factura").style.backgroundColor           = "#EEEEEE"
    $("monto_neto_US$").disabled                       = true
    $("monto_neto_US$").style.backgroundColor          = "#EEEEEE"
    $("monto_adu_US$").disabled                        = true
    $("monto_adu_US$").style.backgroundColor           = "#EEEEEE"
    $("bodega").disabled                               = true
    $("bodega").style.backgroundColor                  = "#EEEEEE"
    $("label_accion_modulo").innerHTML                 = "VISUALIZANDO COMPRA - "+v_documento_no_valorizado
    $("bultos").disabled                               = true
    $("bultos").style.backgroundColor                  = "#EEEEEE"
    
    $("td_cab_2_9").style.visibility         = ""
    $("td_cab_2_10").style.visibility        = ""
    $("carpeta").disabled                    = true
    $("carpeta").style.backgroundColor       = "#EEEEEE"
    $("fieldset_proveedor").style.visibility = ""
    $("fieldset_productos").style.visibility = ""
    if($("documento_respaldo").value != "Z")
      $("td_total_cif_ori").style.visibility   = ""
    $("td_total_cif_adu").style.visibility   = ""
    if($("documento_respaldo").value == "Z")
      $("td_total_ex_fab").style.visibility    = ""
    //$("td_total_fob").style.visibility       = ""
  }
  Cargar_Items("EDITAR","")
  $("bot_actualizar_proveedor_items").style.visibility  = ""
  if($("documento_respaldo").value!="Z")
    $("bot_actualizar_proveedor_items").style.visibility  = "hidden"
  if(v_documento_no_valorizado=="TCP")
    $("tabla_form_traspaso_TCP").style.visibility        = ""
  
  $("td_cab_2_4").style.visibility   = ""
  $("td_cab_2_5").style.visibility   = ""
  $("td_cab_2_6").style.visibility   = ""
  $("td_cab_2_7").style.visibility   = ""
  $("td_cab_2_8").style.visibility   = ""
  $("td_cab_2_9").style.visibility   = ""
  
  $("td_cab_2_12").style.visibility   = ""
  $("td_cab_2_13").style.visibility   = ""
  
  $("td_carpetas").style.visibility  = ""
  if($("checkbox_vista_pedidos").checked)
  {
    $("td_cab_1_1").style.visibility   ="hidden"
    $("td_cab_1_2").style.visibility   ="hidden"
    $("td_cab_1_3").style.visibility   ="hidden"
    $("td_cab_1_4").style.visibility   ="hidden"
    $("td_cab_1_5").style.visibility   ="hidden"
    $("td_cab_1_6").style.visibility   ="hidden"
    $("td_cab_1_7").style.visibility   ="hidden"
    
    $("td_cab_2_1").style.visibility   = "hidden"
    $("td_cab_2_2").style.visibility   = "hidden"
    $("td_cab_2_3").style.visibility   = "hidden"
    $("td_cab_2_4").style.visibility   = "hidden"
    $("td_cab_2_5").style.visibility   = "hidden"
    $("td_cab_2_6").style.visibility   = "hidden"
    $("td_cab_2_7").style.visibility   = "hidden"
    $("td_cab_2_8").style.visibility   = "hidden"
    $("td_cab_2_9").style.visibility   = "hidden"
    $("td_carpetas").style.visibility  = "hidden"
    $("td_cab_2_10").style.visibility  = "hidden"
    
    $("td_cab_2_12").style.visibility   = "hidden"
    $("td_cab_2_13").style.visibility   = "hidden"
    
    $("bot_actualizar_proveedor_items").style.visibility = "hidden"
    if(perfil=="PEDIDO")
      $("tabla_form_traspaso_TCP").style.visibility        = "hidden"
    $("td_total_cif_ori").style.visibility   = "hidden"
    $("td_total_cif_adu").style.visibility   = "hidden"
    $("td_total_ex_fab").style.visibility    = "hidden"
    //$("td_total_fob").style.visibility       = "hidden"
    $("fieldset_proveedor").style.visibility = "hidden"
    $("td_agrupar_items1").style.visibility  = "hidden"
    $("td_agrupar_items2").style.visibility  = "hidden"
    $("td_agrupar_items3").style.visibility  = "hidden"
    $("td_checktodos").style.visibility      = "hidden"
    $("checktodos").checked                  = false
  }
  
  if($("documento_respaldo").value == "Z")
  {
    $("td_cab_2_4").style.visibility   = "hidden"
    $("td_cab_2_5").style.visibility   = "hidden"
    
    $("td_cab_2_12").style.visibility   = ""
    $("td_cab_2_13").style.visibility   = ""
  }
  else
  {
    $("td_cab_2_12").style.visibility   = "hidden"
    $("td_cab_2_13").style.visibility   = "hidden"
  }
  //Cargar grilla actualización datos proveedor (PRUEBAS)
  //$("capaDatosCompra").style.visibility    = "hidden"
  //$("capaDatosCompra").style.zIndex        = -1
  //$("capaDatosProveedor").style.visibility = ""
  //Ingresar_Datos_Proveedor();
}

function Eliminar_Compra(){
  if(confirm("¿Está seguro que desea eliminar esta compra?"))
  {
    if(Radio_Es_Arreglo(document.getElementsByName("radio_compras")))
    {
      for(i=0;i<=document.getElementsByName("radio_compras").length-1;i++)
        if(document.getElementsByName("radio_compras")[i].checked==true)
        { 
          v_anio                                    = document.getElementsByName("radio_compras")[i].getAttribute("anio")
          v_numero_interno_documento_no_valorizado  = document.getElementsByName("radio_compras")[i].getAttribute("numero_interno_documento_no_valorizado")
          v_documento_no_valorizado                 = document.getElementsByName("radio_compras")[i].getAttribute("documento_no_valorizado")
          v_numero_documento_no_valorizado          = document.getElementsByName("radio_compras")[i].getAttribute("numero_documento_no_valorizado")
          v_numero_documento_respaldo               = document.getElementsByName("radio_compras")[i].getAttribute("numero_documento_respaldo")
          v_documento_respaldo                      = document.getElementsByName("radio_compras")[i].getAttribute("documento_respaldo")
          v_proveedor                               = document.getElementsByName("radio_compras")[i].getAttribute("proveedor")
          v_nombre_proveedor                        = document.getElementsByName("radio_compras")[i].getAttribute("nombre_proveedor")
          v_fecha_emision                           = document.getElementsByName("radio_compras")[i].getAttribute("fecha_emision")
          v_fecha_recepcion                         = document.getElementsByName("radio_compras")[i].getAttribute("fecha_recepcion")
          v_numero_factura                          = document.getElementsByName("radio_compras")[i].getAttribute("numero_factura")
          v_fecha_factura                           = document.getElementsByName("radio_compras")[i].getAttribute("fecha_factura")
          v_paridad                                 = document.getElementsByName("radio_compras")[i].getAttribute("paridad")
          v_total_cif_ori                           = document.getElementsByName("radio_compras")[i].getAttribute("total_cif_ori")
          v_bodega                                  = document.getElementsByName("radio_compras")[i].getAttribute("bodega")
          v_carpeta                                 = document.getElementsByName("radio_compras")[i].getAttribute("carpeta")
          break;
        }
    }
    else
    {
      v_anio                                    = document.getElementsByName("radio_compras").getAttribute("anio")
      v_numero_interno_documento_no_valorizado  = document.getElementsByName("radio_compras").getAttribute("numero_interno_documento_no_valorizado")
      v_documento_no_valorizado                 = document.getElementsByName("radio_compras").getAttribute("documento_no_valorizado")
      v_numero_documento_no_valorizado          = document.getElementsByName("radio_compras").getAttribute("numero_documento_no_valorizado")
      v_numero_documento_respaldo               = document.getElementsByName("radio_compras").getAttribute("numero_documento_respaldo")
      v_documento_respaldo                      = document.getElementsByName("radio_compras").getAttribute("documento_respaldo")
      v_proveedor                               = document.getElementsByName("radio_compras").getAttribute("proveedor")
      v_nombre_proveedor                        = document.getElementsByName("radio_compras").getAttribute("nombre_proveedor")
      v_fecha_emision                           = document.getElementsByName("radio_compras").getAttribute("fecha_emision")
      v_fecha_recepcion                         = document.getElementsByName("radio_compras").getAttribute("fecha_recepcion")
      v_numero_factura                          = document.getElementsByName("radio_compras").getAttribute("numero_factura")
      v_fecha_factura                           = document.getElementsByName("radio_compras").getAttribute("fecha_factura")
      v_paridad                                 = document.getElementsByName("radio_compras").getAttribute("paridad")
      v_total_cif_ori                           = document.getElementsByName("radio_compras").getAttribute("total_cif_ori")
      v_bodega                                  = document.getElementsByName("radio_compras").getAttribute("bodega")
      v_carpeta                                 = document.getElementsByName("radio_compras").getAttribute("carpeta")
    }
    document.body.style.cursor = "wait"
    var ajx = new Ajax("compras_grabar.asp",{
      method:'post', 
      async:false,
      data: 'accion=eliminar&documento_respaldo='+v_documento_respaldo+'&numero_documento_respaldo='+v_numero_documento_respaldo+
      '&documento_no_valorizado='+v_documento_no_valorizado+'&numero_documento_no_valorizado='+v_numero_documento_no_valorizado+
      '&numero_interno_documento_no_valorizado='+v_numero_interno_documento_no_valorizado+
      '&bodega='+v_bodega,
      onComplete: function(respuesta){
        //alert(respuesta)
        document.body.style.cursor = "default"
        Buscar_Compras(true,1,'')
      }
    });
    ajx.request();
  }
}

function Generar_Informe(v_para){
  if(Radio_Es_Arreglo(document.getElementsByName("radio_compras")))
  {
    for(i=0;i<=document.getElementsByName("radio_compras").length-1;i++)
      if(document.getElementsByName("radio_compras")[i].checked==true)
      {      
        v_documento_no_valorizado   = document.getElementsByName("radio_compras")[i].getAttribute("documento_no_valorizado")
        v_numero_documento_respaldo = document.getElementsByName("radio_compras")[i].getAttribute("numero_documento_respaldo")
        v_documento_respaldo        = document.getElementsByName("radio_compras")[i].getAttribute("documento_respaldo")
        v_proveedor                 = document.getElementsByName("radio_compras")[i].getAttribute("proveedor")
        v_nombre_proveedor          = document.getElementsByName("radio_compras")[i].getAttribute("nombre_proveedor")
        v_fecha_emision             = document.getElementsByName("radio_compras")[i].getAttribute("fecha_emision")
        v_fecha_recepcion           = document.getElementsByName("radio_compras")[i].getAttribute("fecha_recepcion")
        v_fecha_factura             = document.getElementsByName("radio_compras")[i].getAttribute("fecha_factura")
        v_paridad                   = document.getElementsByName("radio_compras")[i].getAttribute("paridad")
        v_total_cif_ori             = document.getElementsByName("radio_compras")[i].getAttribute("total_cif_ori")
        v_total_cif_adu             = document.getElementsByName("radio_compras")[i].getAttribute("total_cif_adu")
        v_total_ex_fab              = document.getElementsByName("radio_compras")[i].getAttribute("total_ex_fab")
        v_carpeta                   = document.getElementsByName("radio_compras")[i].getAttribute("carpeta")
        break;
      }
  }
  else
  {
    v_documento_no_valorizado   = document.getElementsByName("radio_compras").getAttribute("documento_no_valorizado")
    v_numero_documento_respaldo = document.getElementsByName("radio_compras").getAttribute("numero_documento_respaldo")
    v_documento_respaldo        = document.getElementsByName("radio_compras").getAttribute("documento_respaldo")
    v_proveedor                 = document.getElementsByName("radio_compras").getAttribute("proveedor")
    v_nombre_proveedor          = document.getElementsByName("radio_compras").getAttribute("nombre_proveedor")
    v_fecha_emision             = document.getElementsByName("radio_compras").getAttribute("fecha_emision")
    v_fecha_recepcion           = document.getElementsByName("radio_compras").getAttribute("fecha_recepcion")
    v_fecha_factura             = document.getElementsByName("radio_compras").getAttribute("fecha_factura")
    v_paridad                   = document.getElementsByName("radio_compras").getAttribute("paridad")
    v_total_cif_ori             = document.getElementsByName("radio_compras").getAttribute("total_cif_ori")
    v_total_cif_adu             = document.getElementsByName("radio_compras").getAttribute("total_cif_adu")
    v_total_ex_fab              = document.getElementsByName("radio_compras").getAttribute("total_ex_fab")
    v_carpeta                   = document.getElementsByName("radio_compras").getAttribute("carpeta")
  }
  parametros ="para="+v_para+"&documento_no_valorizado="+v_documento_no_valorizado+"&numero_documento_respaldo="+v_numero_documento_respaldo
  parametros+="&documento_respaldo="+v_documento_respaldo+"&proveedor="+v_proveedor+"&nombre_proveedor="+escape(v_nombre_proveedor)
  parametros+="&fecha_recepcion="+v_fecha_recepcion+"&fecha_emision="+v_fecha_emision+"&fecha_factura="+v_fecha_factura+"&paridad="+v_paridad
  parametros+="&total_cif_ori="+v_total_cif_ori+"&total_cif_adu="+v_total_cif_adu+"&total_ex_fab="+v_total_ex_fab + "&carpeta="+v_carpeta
  
  //------------------------------------------
  k_currentTime = new Date()
  k_year    = k_currentTime.getFullYear().toString()
  k_month   = k_currentTime.getMonth().toString()
  k_day     = k_currentTime.getDate().toString()

  k_hours   = k_currentTime.getHours().toString()
  k_minutes = k_currentTime.getMinutes().toString()
  k_seconds = k_currentTime.getSeconds().toString()

  k_fecha_hora = k_year.toString() +"-" + k_month + "-" + k_day + "_" + k_hours +"-" + k_minutes + "-" + k_seconds
  //------------------------------------------
  parametros+="&fecha_hora="+k_fecha_hora
  
  ruta_informe = "compras_listar_detalle"
  if(v_para=="cambio_unidad")
    ruta_informe = "compras_listar_cambio_unidad"
  
  var h = (screen.availHeight - 36), w = (screen.availWidth - 10),  x = 0 , y = 0
  str = "width="+w+", height="+h+", screenX="+x+", screenY="+y+", left="+x+", top="+y+", scrollbars=3,  menubar=no, toolbar=no, status=no"
  //WinInforme = open(ruta_informe+".asp?"+parametros, "Inf", str, "replace=1")
  WinInforme = open(ruta_informe+".asp?"+parametros, "_top", str, "replace=1") // Se cambio "Inf" por "_top" para que no se abra el informe en nueva ventana
}

function Recargar_Pagina_Boton_Volver(){
  //Por el mensaje de lentitud en la ejeución de un script, se probará un tiempo recargar la página completa cada vez que 
  //se vuelve hacia atrás en las compras (botón volver)
  document.location.href=RutaProyecto+"compras/compras.asp"
}

function Cancelar_Ingreso_Compra(){
  $("numero_interno_documento_no_valorizado").value    = ""
  $("anio").disabled                                   = false
  $("anio").style.backgroundColor                      = ""
  $("documento_no_valorizado").value                   = ""
  $("numero_documento_no_valorizado").value            = ""
  $("documento_respaldo").disabled                     = false
  $("documento_respaldo").value                        = "R"
  $("documento_respaldo").style.backgroundColor        = ""
  $("numero_documento_respaldo").title                 = ""
  $("numero_documento_respaldo").readOnly              = false
  $("numero_documento_respaldo").value                 = ""
  $("numero_documento_respaldo").setAttribute("o_value", "")
  $("numero_documento_respaldo").style.backgroundColor = ""
  $("fecha_emision").value                             = ""
  $("fecha_emision").setAttribute("o_value", "")
  $("fecha_emision").disabled                          = false
  $("fecha_emision").style.backgroundColor             = ""
  $("fecha_recepcion").value                           = ""
  $("fecha_recepcion").setAttribute("o_value", "")
  $("fecha_recepcion").disabled                        = false
  $("fecha_recepcion").style.backgroundColor           = ""
  $("numero_factura").value                            = ""
  $("numero_factura").setAttribute("o_value", "")
  $("numero_factura").disabled                         = false
  $("numero_factura").style.backgroundColor            = ""
  $("fecha_factura").value                             = ""
  $("fecha_factura").setAttribute("o_value", "")
  $("fecha_factura").disabled                          = false
  $("fecha_factura").style.backgroundColor             = ""
  $("monto_neto_US$").value                            = ""
  $("monto_neto_US$").setAttribute("o_value", "")
  $("monto_neto_US$").disabled                         = false
  $("monto_neto_US$").style.backgroundColor            = ""
  $("monto_adu_US$").value                             = ""
  $("monto_adu_US$").setAttribute("o_value", "")
  $("monto_adu_US$").disabled                          = false
  $("monto_adu_US$").style.backgroundColor             = ""
  if($("documento_respaldo").value=="Z")
  {
    $("monto_adu_US$").disabled                          = true
    $("monto_adu_US$").style.backgroundColor             = "#EEEEEE"
  }
  $("bodega").value                                    = "0010"
  $("bodega").disabled                                 = false
  $("bodega").style.backgroundColor                    = ""
  $("label_paridad_para_facturacion").innerHTML        = ""
  $("paridad_margen").value                            = ""
  $("entidad_comercial").disabled                      = false
  $("entidad_comercial").value                         = ""
  $("entidad_comercial").setAttribute("o_value","")
  $("entidad_comercial").style.backgroundColor         = ""
  $("td_cab_1_8").style.visibility                     = "hidden"
  $("td_cab_2_9").style.visibility                     = "hidden"
  $("td_cab_2_10").style.visibility                    = "hidden"
  $("label_proveedor_cabecera").innerHTML              = ""
  $("label_proveedor_cabecera").setAttribute("inicial", "")
  $("label_proveedor_cabecera").setAttribute("rut", "")
  $("dig_verificador").value                           = ""
  $("td_buscar_proveedor").style.visibility            = "hidden"
  $("td_cancelar_proveedor").style.visibility          = "hidden"
  $("td_datos_proveedor").style.visibility             = "hidden"
  $("td_datos_codprov_proveedor").style.visibility     = "hidden"
  $("td_bot_func_proveedor").style.visibility          = "hidden"
  $("td_datos_2_proveedor_1").style.visibility         = "hidden"
  $("td_datos_2_proveedor_2").style.visibility         = "hidden"
  $("td_datos_2_proveedor_3").style.visibility         = "hidden"
  $("entidad_comercial_2").value                       = ""
  $("td_agrupar_items1").style.visibility              = "hidden"
  $("td_agrupar_items2").style.visibility              = "hidden"
  $("td_agrupar_items3").style.visibility              = "hidden"
  $("td_items").style.visibility                       = "hidden"
  $("td_bot_agregar_items").style.visibility           = "hidden"
  $("label_accion_modulo").innerHTML                   = ""
  $("grilla_productos").innerHTML                      = ""
  $("label_total_cif_ori").innerHTML                   = ""
  $("label_total_cif_adu").innerHTML                   = ""
  $("label_total_ex_fab").innerHTML                    = ""
  //$("label_total_fob").innerHTML                       = ""
  $("bot_informacion_to_RCP").style.visibility         = "hidden"
  
  $("tabla_botonera_general").style.visibility         = ""
  $("label_accion_modulo").innerHTML                   = "BUSCAR COMPRA"
  $("capaDatosCompra").style.visibility                = "hidden"
  $("capaDatosCompra").style.zIndex                    = -1
  $("grilla_compras").style.visibility                 = ""
  $("bot_verificar_itemes").style.visibility           = "hidden"
  Cancelar_Busqueda_Compra()
  t_rows = 0
  
  $("tabla_form_traspaso_TCP").style.visibility        = "hidden"
  $("traspaso_anio").disabled                          = false
  $("traspaso_documento_respaldo").disabled            = false
  $("traspaso_numero_documento_respaldo").disabled     = false
  $("traspaso_numero_documento_respaldo").value        = ""
  $("bot_traspasar_itemes").style.visibility           = "hidden"
  $("bot_cancelar_traspaso").style.visibility          = "hidden"
  
  $("tipo_oc").value                                   = "O" //valor por defecto tipo_oc (campo utilizado para marca TCP como pedido)
}

function Set_Nuevo(){
  Mostrar_Form_Compra(false)
  $("fieldset_proveedor").style.visibility       = "hidden"
  $("fieldset_productos").style.visibility       = "hidden"
  $("fieldset_items").style.visibility           = "hidden"
  $("td_total_cif_ori").style.visibility         = "hidden"
  $("td_total_cif_adu").style.visibility         = "hidden"
  $("td_total_ex_fab").style.visibility          = "hidden"
  //$("td_total_fob").style.visibility             = "hidden"
  $("tabla_botonera_general").style.visibility   = "hidden"
  $("label_accion_modulo").innerHTML             = "INGRESAR NUEVA COMPRA"
  $("capaDatosCompra").style.visibility          = ""
  $("capaDatosCompra").style.zIndex              = 1
  $("anio").value                                = $("buscar_anio").value
  $("documento_respaldo").value                  = $("buscar_documento_respaldo").value
  $("tabla_form_traspaso_TCP").style.visibility  = "hidden"
  $("numero_documento_respaldo").focus()
}

function Cancelar_Busqueda_Compra(){
  $("buscar_numero_documento_respaldo").value                  = ""
  $("buscar_documento_respaldo").disabled                      = false
  $("buscar_anio").disabled                                    = false
  $("buscar_mes").disabled                                     = false
  $("buscar_numero_documento_respaldo").disabled               = false
  $("buscar_documento_respaldo").style.backgroundColor         = ""
  $("buscar_anio").style.backgroundColor                       = ""
  $("buscar_mes").style.backgroundColor                        = ""
  $("buscar_numero_documento_respaldo").style.backgroundColor  = ""
  SetBackgroundImageInput($("bot_buscar"),RutaProyecto+"imagenes/ico_buscar_24X24_on.gif")
  SetBackgroundImageInput($("bot_nuevo"),RutaProyecto+"imagenes/ico_nuevo_24X24_on.gif")
  SetBackgroundImageInput($("bot_editar"),RutaProyecto+"imagenes/ico_editar_24X24_off.gif")
  SetBackgroundImageInput($("bot_eliminar"),RutaProyecto+"imagenes/ico_eliminar_24X24_off.gif")
  SetBackgroundImageInput($("bot_excel"),RutaProyecto+"imagenes/ico_excel_24X24_off.gif")
  SetBackgroundImageInput($("bot_excel_b"),RutaProyecto+"imagenes/ico_excel_B_24X24_off.gif")
  SetBackgroundImageInput($("bot_excel_c"),RutaProyecto+"imagenes/ico_excel_C_24X24_off.gif")
  SetBackgroundImageInput($("bot_atras"),RutaProyecto+"imagenes/ico_atras_24X24_off.gif")
  
  $("bot_buscar").disabled   = false
  $("bot_buscar").style.cursor="pointer"
  $("bot_nuevo").disabled    = false
  $("bot_nuevo").style.cursor="pointer"
  $("bot_editar").disabled   = true
  $("bot_editar").style.cursor="default"
  $("bot_eliminar").disabled = true
  $("bot_eliminar").style.cursor="default"
  $("bot_excel").disabled    = true
  $("bot_excel").style.cursor="default"
  $("bot_excel_b").disabled  = true
  $("bot_excel_b").style.cursor="default"
  $("bot_excel_c").disabled  = true
  $("bot_excel_c").style.cursor="default"
  $("bot_atras").disabled    = true
  $("bot_atras").style.cursor="default"
  
  $("grilla_compras").innerHTML = ""
}

function Buscar_Compras(v_async,v_busqueda_aprox,v_campo_order_by){
  strCargando ="<br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Listando compras...espere un momento</b></font><br><br></center>"
  $("grilla_compras").innerHTML                  = strCargando
  document.body.style.cursor                = "wait"
  $("grilla_compras").style.cursor               = "wait"
  $("buscar_documento_respaldo").disabled        = true
  $("buscar_anio").disabled                      = true
  $("buscar_mes").disabled                       = true
  $("buscar_numero_documento_respaldo").disabled = true
  $("buscar_documento_respaldo").style.backgroundColor         = "#EEEEEE"
  $("buscar_anio").style.backgroundColor                       = "#EEEEEE"
  $("buscar_mes").style.backgroundColor                        = "#EEEEEE"
  $("buscar_numero_documento_respaldo").style.backgroundColor  = "#EEEEEE"
  
  $("bot_buscar").disabled = true
  $("bot_buscar").style.cursor="default"
  $("bot_nuevo").disabled  = true
  $("bot_nuevo").style.cursor="default"
  SetBackgroundImageInput($("bot_buscar"),RutaProyecto+"imagenes/ico_buscar_24X24_off.gif")
  SetBackgroundImageInput($("bot_nuevo"),RutaProyecto+"imagenes/ico_nuevo_24X24_off.gif")
  
  z_numero_documento_respaldo = $("buscar_numero_documento_respaldo").value
  v_vista = "NORMAL"
  if($("checkbox_vista_pedidos").checked)
    v_vista = "PEDIDO"
  var ajx = new Ajax("compras_listar.asp",{
    method:'post', 
    async:eval(v_async),
    data: 'busqueda_aprox='+v_busqueda_aprox+
    '&documento_respaldo='+$("buscar_documento_respaldo").value+
    '&anio='+$("buscar_anio").value+
    '&mes='+$("buscar_mes").value+
    '&numero_documento_respaldo='+$("buscar_numero_documento_respaldo").value+
    '&check_TCP='+$("buscar_check_TCP").checked+'&check_RCP='+$("buscar_check_RCP").checked+
    '&campo_order_by='+v_campo_order_by+
    '&vista='+v_vista,
    update:$("grilla_compras"),
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor  = "default"
      $("grilla_compras").style.cursor = "default"
      if(respuesta=="")
      {
        Cancelar_Busqueda_Compra()
        $("buscar_numero_documento_respaldo").value = z_numero_documento_respaldo
      }
      else
      {
        SetChecked_Radio(document.getElementsByName("radio_compras"),0)
        doc_no_valorizado = Get_Atributo_Radio_Compras_Checked("DOCUMENTO_NO_VALORIZADO")
        $("bot_eliminar").disabled = true
        if(doc_no_valorizado=="TCP")
        {
          SetBackgroundImageInput($("bot_eliminar"),RutaProyecto+"imagenes/ico_eliminar_24X24_on.gif")
          $("bot_eliminar").disabled = false
          
        }
        SetBackgroundImageInput($("bot_editar"),RutaProyecto+"imagenes/ico_editar_24X24_on.gif")
        SetBackgroundImageInput($("bot_excel"),RutaProyecto+"imagenes/ico_excel_24X24_on.gif")
        SetBackgroundImageInput($("bot_excel_b"),RutaProyecto+"imagenes/ico_excel_B_24X24_on.gif")
        SetBackgroundImageInput($("bot_excel_c"),RutaProyecto+"imagenes/ico_excel_C_24X24_on.gif")
        SetBackgroundImageInput($("bot_atras"),RutaProyecto+"imagenes/ico_atras_24X24_on.gif")
        $("bot_editar").disabled   = false
        $("bot_editar").style.cursor="pointer"
        $("bot_eliminar").style.cursor="pointer"
        $("bot_excel").disabled    = false
        $("bot_excel").style.cursor="pointer"
        $("bot_excel_b").disabled  = false
        $("bot_excel_b").style.cursor="pointer"
        $("bot_excel_c").disabled  = false
        $("bot_excel_c").style.cursor="pointer"
        $("bot_atras").disabled    = false
        $("bot_atras").style.cursor="pointer"
      }
    }
  });
  ajx.request();
}

//------------------------------------------------------------------------------------
//############################## FUNCIONES PROVEEDOR #################################
//------------------------------------------------------------------------------------
function Set_Crear_Proveedor_Extranjero(){
  $("entidad_comercial").value = $("rut_proveedor_extranjero").value
  Cancelar_Busqueda_Proveedor()
  Verificar_Proveedor()
}

function Cargar_Busqueda_Proveedor(id_text_tmp){
  str_datos = Trim(id_text_tmp.value)
  var ajx = new Ajax(RutaProyecto+"funciones_sys_ajax/AJAX_Cargar_select_buscar_proveedores.asp",{
    method:'post', 
    data: 'datos='+escape(str_datos)+'&nom_campo=select_busqueda_proveedor&width_campo=420',
    update:$("td_select_busqueda_proveedor"),
    onComplete: function(respuesta){
      //alert(respuesta)
      if($("select_busqueda_proveedor").options[0])
        $("td_select_busqueda_proveedor").style.visibility = ""
    }
  });
  ajx.request();
}

function Mover_Seleccionado_Select(id_select_tmp,mov_tmp){
  if(mov_tmp==ARRIBA){
    if(parseInt(id_select_tmp.selectedIndex)>0)
      id_select_tmp.options[parseInt(id_select_tmp.selectedIndex)-1].selected=true
  }
  else if(mov_tmp==ABAJO){
    if(parseInt(id_select_tmp.selectedIndex)<parseInt(id_select_tmp.getAttribute("total_lista_select")))
      id_select_tmp.options[parseInt(id_select_tmp.selectedIndex)+1].selected=true
  }
}

function Seleccionar_Proveedor(id_select_tmp){
  if(id_select_tmp.value!="")
  {
    $("entidad_comercial").value = id_select_tmp.value
    $("dig_verificador").value   = Get_Digito_Verificador_Rut($("entidad_comercial").value)
    Cancelar_Busqueda_Proveedor()
    Verificar_Proveedor()
  }
}

function Cancelar_Busqueda_Proveedor(){
  $("datos_busqueda_proveedor").value                = ""
  $("rut_proveedor_extranjero").value                = ""
  $("td_crear_proveedor").style.visibility           = "hidden"
  $("td_select_busqueda_proveedor").style.visibility = "hidden"
  $("capaBuscarProveedor").style.visibility          = "hidden"
  $("capaDatosCompra").style.visibility              = ""
  $("capaDatosCompra").style.zIndex                  = 1
}

function Set_Buscar_Proveedor(){
  if($("documento_respaldo").value=="Z")
  {
    document.body.style.cursor="wait"
    var ajx = new Ajax(RutaProyecto+"funciones_SYS_AJAX/AJAX_Get_Rut_Nuevo_Prov_Extanjero.asp",{
      method:'post', 
      async:false,
      onComplete: function(respuesta){
        //alert(respuesta)
        document.body.style.cursor          = "default"
        $("rut_proveedor_extranjero").value      = respuesta
        $("td_crear_proveedor").style.visibility = ""
      }
    });
    ajx.request();
  }
  $("capaDatosCompra").style.visibility      = "hidden"
  $("capaDatosCompra").style.zIndex          = -1
  $("capaBuscarProveedor").style.visibility  = ""
  $("datos_busqueda_proveedor").focus()
}

function Actualizar_Proveedor_Cabecera(){
  if($("entidad_comercial").value==$("label_proveedor_cabecera").getAttribute("rut"))
  {
    Config_Msg_Accion(" El proveedor "+$("codprov_proveedor").value+" ya está ingresado en la cabecera de la compra...",5000,$("msg_accion_3"))
    return;
  }
  else if($("entidad_comercial_2").value==$("entidad_comercial").value)
  {
    Config_Msg_Accion(" El proveedor "+$("codprov_proveedor").value+" está asignado como segundo proveedor...",5000,$("msg_accion_3"))
    return;
  }
  else
  {
    if($("entidad_comercial_2").value=="")
      v_msgConfirm="¿Está seguro que desea actualizar el proveedor de la cabecera de la compra?\nEste proceso actualizará el proveedor de todos los ítemes de la compra."
    else
      v_msgConfirm="¿Está seguro que desea actualizar el proveedor de la cabecera de la compra?"
    if(confirm(v_msgConfirm))
      Actualizar_Datos_Compra("proveedor",$("entidad_comercial").value)
  }
}
function Get_Datos_Segundo_Proveedor(){
  document.body.style.cursor="wait"
  var ajx = new Ajax("compras_proveedor_2_datos.asp",{
    method:'post', 
    async:false,
    data: 'accion=asignar&documento_no_valorizado='+$("documento_no_valorizado").value+
          '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
          '&documento_respaldo='+$("documento_respaldo").value+
          '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
          '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value,
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor              = "default"
      if(respuesta!="")
      {
        var datos_2_proveedor                   = respuesta.split("~")
        $("td_datos_2_proveedor_1").style.visibility = ""
        $("td_datos_2_proveedor_2").style.visibility = ""
        $("td_datos_2_proveedor_3").style.visibility = ""
        $("entidad_comercial_2").value               = datos_2_proveedor[0]
      }
    }
  });
  ajx.request();
}

function Set_CODPROV(v_proveedor,v_id_input){
  var ajx = new Ajax("compras_proveedor_get_codprov.asp",{
    method:'post', 
    async:false,
    evalScripts:true,
    data: 'proveedor='+v_proveedor+'&id_input='+v_id_input.name,
    onComplete: function(respuesta){
      //alert(respuesta)
      //v_id_input.value = respuesta
    }
  });
  ajx.request();
}

function Grabar_Segundo_Proveedor(v_accion){
  if(v_accion=="asignar")
  {
    if($("entidad_comercial").value==$("label_proveedor_cabecera").getAttribute("rut"))
    {
      Config_Msg_Accion(" El proveedor "+$("codprov_proveedor").value+" ya está ingresado en la cabecera de la compra...",5000,$("msg_accion_3"))
      return
    }
    else if($("entidad_comercial_2").value==$("entidad_comercial").value)
    {
      Config_Msg_Accion(" El proveedor "+$("codprov_proveedor").value+" ya está asignado como segundo proveedor...",5000,$("msg_accion_3"))
      return;
    }
    strMensaje = "¿Está seguro que desea asignar el rut "+$("entidad_comercial").value+", "+$("codprov_proveedor").value+" como segundo proveedor?\nEste proceso actualizará todos los ítemes de la compra con el segundo proveedor."
  }
  else
    strMensaje = "¿Está seguro que desea eliminar la asignación al segundo proveedor?\nEste proceso actualizará todos los ítemes con el proveedor de cabecera de la compra."
  if(confirm(strMensaje))
  {
    if(v_accion=="asignar")
      Actualizar_Datos_Compra("proveedor_2",$("entidad_comercial").value)
    else
      Actualizar_Datos_Compra("proveedor_2","") //Eliminar
  }
}

function Set_Cancelar_Proveedor(){
  $("td_bot_func_proveedor").style.visibility  = ""
  $("td_datos_proveedor").style.visibility     = ""
  $("td_datos_codprov_proveedor").style.visibility = ""
  if($("entidad_comercial_2").value!="")
  {
    $("td_datos_2_proveedor_1").style.visibility = ""
    $("td_datos_2_proveedor_2").style.visibility = ""
    $("td_datos_2_proveedor_3").style.visibility = ""  
  }
  $("fieldset_items").style.visibility         = ""
  $("td_agrupar_items1").style.visibility      = ""
  $("td_agrupar_items2").style.visibility      = ""
  $("td_agrupar_items3").style.visibility      = ""
  $("td_items").style.visibility               = ""
  $("td_bot_agregar_items").style.visibility   = ""
  $("entidad_comercial").value                 = $("entidad_comercial").getAttribute("o_value")
  $("codprov_proveedor").value                 = $("label_proveedor_cabecera").innerHTML
  $("entidad_comercial").disabled              = true
  $("dig_verificador").value                   = Get_Digito_Verificador_Rut($("entidad_comercial").value)
  $("entidad_comercial").style.backgroundColor = "#EEEEEE"
  $("td_buscar_proveedor").style.visibility    = "hidden"
  $("td_cancelar_proveedor").style.visibility  = "hidden"
}

function Set_Cambiar_Proveedor(){
  $("td_bot_func_proveedor").style.visibility  = "hidden"
  $("td_datos_proveedor").style.visibility     = "hidden"
  $("td_datos_codprov_proveedor").style.visibility  = "hidden"
  $("td_datos_2_proveedor_1").style.visibility = "hidden"
  $("td_datos_2_proveedor_2").style.visibility = "hidden"
  $("td_datos_2_proveedor_3").style.visibility = "hidden"  
  $("fieldset_items").style.visibility         = "hidden"
  $("td_agrupar_items1").style.visibility      = "hidden"
  $("td_agrupar_items2").style.visibility      = "hidden"
  $("td_agrupar_items3").style.visibility      = "hidden"
  $("td_items").style.visibility               = "hidden"
  $("td_bot_agregar_items").style.visibility   = "hidden"
  $("entidad_comercial").value                 = ""
  $("entidad_comercial").disabled              = false
  $("entidad_comercial").style.backgroundColor = ""
  $("dig_verificador").value                   = ""
  $("td_buscar_proveedor").style.visibility    = ""
  $("td_cancelar_proveedor").style.visibility  = ""
  $("entidad_comercial").focus()
}

function Cerrar_Nuevo_Proveedor(){
  if($("label_proveedor_cabecera").innerHTML=="")
    Actualizar_Datos_Compra("proveedor",$("entidad_comercial").value)
  Set_CODPROV($("entidad_comercial").value,codprov_proveedor)
  $("td_bot_func_proveedor").style.visibility  = ""
  $("td_datos_proveedor").style.visibility     = ""
  $("td_datos_codprov_proveedor").style.visibility = ""
  OcultarCapa("capaDatosProveedor");
  $("grilla_nuevo").innerHTML                  = ""
  $("capaDatosCompra").style.visibility        = ""
  $("capaDatosCompra").style.zIndex            = 1
  if($("entidad_comercial_2").value!="")
  {
    $("td_datos_2_proveedor_1").style.visibility = ""
    $("td_datos_2_proveedor_2").style.visibility = ""
    $("td_datos_2_proveedor_3").style.visibility = ""  
  }
  $("fieldset_items").style.visibility         = ""
  $("td_agrupar_items1").style.visibility      = ""
  $("td_agrupar_items2").style.visibility      = ""
  $("td_agrupar_items3").style.visibility      = ""
  $("td_items").style.visibility               = ""
  $("td_bot_agregar_items").style.visibility   = ""
  $("entidad_comercial").style.backgroundColor = "#EEEEEE"
  $("td_buscar_proveedor").style.visibility    = "hidden"
  $("td_cancelar_proveedor").style.visibility  = "hidden"
  $("fieldset_productos").style.visibility     = ""
  Cargar_Items("EDITAR","")
}

function Cargar_Datos_Proveedor(){
  var ajx = new Ajax("compras_proveedor_datos.asp",{
    method:'post', 
    async:false,
    data: 'entidad_comercial='+$("entidad_comercial").value+'&fecha_recepcion='+$("fecha_recepcion").value,
    evalScripts:true,
    onComplete: function(respuesta){
      //alert(respuesta)
    }
  });
  ajx.request();
}

function Verificar_Proveedor(){
  document.body.style.cursor  = "wait"
  //$("entidad_comercial").value     = LPad($("entidad_comercial").value,8,0)
  $("entidad_comercial").disabled  = true
  var ajx = new Ajax("compras_proveedor_verificar.asp",{
    method:'post', 
    async:false,
    data: 'entidad_comercial='+$("entidad_comercial").value,
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor = "default"
      if(respuesta=="EXISTE")
      {
        if($("label_proveedor_cabecera").innerHTML=="")
          Actualizar_Datos_Compra("proveedor",$("entidad_comercial").value)
        Set_CODPROV($("entidad_comercial").value,codprov_proveedor)
        $("td_buscar_proveedor").style.visibility    = "hidden"
        $("td_cancelar_proveedor").style.visibility  = "hidden"
        $("td_bot_func_proveedor").style.visibility  = ""
        $("td_datos_proveedor").style.visibility     = ""
        $("td_datos_codprov_proveedor").style.visibility = ""
        $("fieldset_productos").style.visibility     = ""
        $("fieldset_items").style.visibility         = ""
        
        if($("documento_no_valorizado").value=="TCP")
          $("tabla_form_traspaso_TCP").style.visibility = ""
        
        Cargar_Items_Agrupar()
        $("td_agrupar_items1").style.visibility      = ""
        $("td_agrupar_items2").style.visibility      = ""
        $("td_agrupar_items3").style.visibility      = ""
        if($("documento_respaldo").value != "Z")
          $("td_total_cif_ori").style.visibility       = ""
        $("td_total_cif_adu").style.visibility       = ""
        if($("documento_respaldo").value == "Z")
          $("td_total_ex_fab").style.visibility        = ""
        //$("td_total_fob").style.visibility           = ""
        if($("entidad_comercial_2").value!="")
        {
          $("td_datos_2_proveedor_1").style.visibility = ""
          $("td_datos_2_proveedor_2").style.visibility = ""
          $("td_datos_2_proveedor_3").style.visibility = ""
        }
        $("td_items").style.visibility               = ""
        $("td_bot_agregar_items").style.visibility   = ""
      }
      else
      {
        if(confirm("No existe el proveedor Rut "+$("entidad_comercial").value+". ¿Desea agregarlo al sistema?"))
        {
          var ajx1 = new Ajax("compras_proveedor_grabar.asp",{
            method:'post', 
            async:false,            
            data: 'accion=insertar&entidad_comercial='+$("entidad_comercial").value,
            onComplete: function(respuesta){
              if(respuesta!="")
              {
                alert(respuesta)
                Set_Cambiar_Proveedor()
              }
              else
              {
                $("capaDatosCompra").style.visibility    = "hidden"
                $("capaDatosCompra").style.zIndex        = -1
                $("capaDatosProveedor").style.visibility = ""
                Ingresar_Datos_Proveedor()
              }
            }
          });
          ajx1.request();
        }
        else
        {
          $("entidad_comercial").disabled  = false
          //$("entidad_comercial").value   = $("entidad_comercial").getAttribute("o_value")
          $("entidad_comercial").value     = ""
          $("dig_verificador").value       = ""
          $("entidad_comercial").focus()
          if($("label_proveedor_cabecera").innerHTML!="")
            Set_Cancelar_Proveedor()
        }
      }
    }
  });
  ajx.request();
}

function Ingresar_Datos_Proveedor(){
  strCargando ="<br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Cargando datos...espere un momento</b></font><br><br></center>"
  $("grilla_nuevo").innerHTML      = strCargando
  document.body.style.cursor  = "wait"
  $("grilla_nuevo").style.cursor   = "wait"
  $("grilla_productos").innerHTML  = ""
  var ajx10 = new Ajax("compras_proveedor_grilla.asp",{
    method:'post', 
    data: 'entidad_comercial='+$("entidad_comercial").value,
    update:$("grilla_nuevo"),
    evalScripts:true,
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor  = "default"
      $("grilla_nuevo").style.cursor   = "default"
    }
  });
  ajx10.request();
}

//------------------------------------------------------------------------------------
//############################## FUNCIONES ITEMES #################################
//------------------------------------------------------------------------------------
function Get_Tasa_Rubro(x_rubro){
  for(x_pos=0; x_pos < tasasRubros.length; x_pos++)
  {
    //console.log(tasasRubros[x_pos].rubro)
    if(tasasRubros[x_pos].rubro == x_rubro)
      return (1 + parseFloat(tasasRubros[x_pos].tasa)/100);
  }
  return 1;
}

function Get_CPA_Producto_Anterior_a_Fecha(x_producto,x_fecha_recepcion){
  var ajx = new Ajax(RutaProyecto+"compras/compras_get_cpa_anterior_producto.asp",{
    method:'post', 
    async:false,
    data: 'producto='+x_producto+'&fecha_recepcion='+x_fecha_recepcion,
    onComplete: function(respuesta){
      //alert(respuesta)
      Config_Msg_Accion(" Datos actualizados..., CPA anterior: "+respuesta,5000,$("msg_accion_3"))
    }
  });
  ajx.request();
}

function Desagrupar_Items(){
  strNum_Lineas = ""
  v_num_grid = 1
  for(i=1;i<=t_rows;i++)  
  {
    if($("celda_" + v_num_grid + "_" + i + "_" + C_CHECKBOX).checked==true)
    {
      if($("celda_" + v_num_grid + "_" + i + "_" + C_ITEMS_PADRE).value!="")
      {
        if(strNum_Lineas!="")
          strNum_Lineas     = strNum_Lineas+delimiter
        strNum_Lineas     = strNum_Lineas+$("celda_" + v_num_grid + "_" + i + "_" + C_ITEMS).value
      }
      else
        $("celda_" + v_num_grid + "_" + i + "_" + C_CHECKBOX).checked=false
    }
  }
  //alert(strNum_Lineas)
  if(strNum_Lineas=="")
  {
    Config_Msg_Accion(" No ha seleccionado itemes agrupados...",5000,$("msg_accion_3"))
    return;
  }
  if(confirm("¿Está seguro que desea desagrupar estos ítemes?"))
  {
    items_grupos.disabled=true
    var ajx = new Ajax("compras_productos_grabar.asp",{
      method:'post', 
      async:false,
      data: 'accion=desagrupar&documento_no_valorizado='+$("documento_no_valorizado").value+
            '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
            '&documento_respaldo='+$("documento_respaldo").value+
            '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
            '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value+
            '&strNum_Lineas='+strNum_Lineas,
      onComplete: function(respuesta){
        //alert(respuesta)
        Config_Msg_Accion(" Itemes desagrupados...",5000,$("msg_accion_3"))
        Cargar_Items("EDITAR","")
      }
    });
    ajx.request();
  }
}

function Agrupar_Items(v_item){
  strNum_Lineas = ""
  v_num_grid = 1
  for(i=1;i<=t_rows;i++)  
  {
    if($("celda_" + v_num_grid + "_" + i + "_" + C_CHECKBOX).checked==true && $("celda_" + v_num_grid + "_" + i + "_" + C_ITEMS_PADRE).value=="")
    {
      //Chequear que el item no sea padre de un grupo de itemes
      item_tmp = $("celda_" + v_num_grid + "_" + i + "_" + C_ITEMS).value
      for(j=1;j<=t_rows;j++) 
      {
        if(item_tmp==$("celda_" + v_num_grid + "_" + j + "_" + C_ITEMS_PADRE).value)
        {
          alert("No se puede agrupar el item "+item_tmp+" porque es un item padre de otro grupo")
          Config_Msg_Accion(" No se puede agrupar el item "+item_tmp+"...",5000,$("msg_accion_3"))
          $("celda_" + v_num_grid + "_" + i + "_" + C_CHECKBOX).checked=false
          $("items_grupos").value = ""
          return;
        }
        if(item_tmp==v_item)
        {
          alert("No se puede agrupar el item "+v_item+" con el mismo item")
          Config_Msg_Accion(" No se puede agrupar el item "+item_tmp+"...",5000,$("msg_accion_3"))
          $("celda_" + v_num_grid + "_" + i + "_" + C_CHECKBOX).checked=false
          $("items_grupos").value = ""
          return;
        }
      }
      
      if(strNum_Lineas!="")
        strNum_Lineas     = strNum_Lineas+delimiter
      strNum_Lineas     = strNum_Lineas+$("celda_" + v_num_grid + "_" + i + "_" + C_ITEMS).value
    }
  }
  //alert(strNum_Lineas)
  if(strNum_Lineas=="")
  {
    Config_Msg_Accion(" No ha seleccionado itemes...",5000,$("msg_accion_3"))
    $("items_grupos").value = ""
    return;
  }
  if(confirm("¿Está seguro que desea agrupar estos ítemes en el item "+v_item+"?"))
  {
    items_grupos.disabled=true
    var ajx = new Ajax("compras_productos_grabar.asp",{
      method:'post', 
      async:false,
      data: 'accion=agrupar&documento_no_valorizado='+$("documento_no_valorizado").value+
            '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
            '&documento_respaldo='+$("documento_respaldo").value+
            '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
            '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value+
            '&numero_linea_padre='+v_item+'&strNum_Lineas='+strNum_Lineas,
      onComplete: function(respuesta){
        //alert(respuesta)
        Config_Msg_Accion(" Itemes agrupados...",5000,$("msg_accion_3"))
        Cargar_Items("EDITAR","")
      }
    });
    ajx.request();
  }
  else
    $("items_grupos").value = ""
}

function Cargar_Items_Agrupar(){
  var ajx_cargar_items = new Ajax("compras_cargar_select_items_agrupar.asp",{
    method:'post', 
    async:false,
    data: 'documento_no_valorizado='+$("documento_no_valorizado").value+
          '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
          '&documento_respaldo='+$("documento_respaldo").value+
          '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
          '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value, 
    update:$("td_agrupar_items2"),
    onComplete: function(respuesta){
      //alert(respuesta)
      //$("label_total_cif_ori").innerHTML=respuesta
    }
  });
  ajx_cargar_items.request();
}

function Actualizar_Proveedor_Items(){
  if(!Verificar_Check_Tuplas()){
    Config_Msg_Accion(" No ha seleccionado itemes...",5000,$("msg_accion_3"))
    return;
  }
  v_num_grid = 1
  if(confirm("¿Está seguro que desea actualizar el proveedor de los ítemes seleccionados?"))
  {
    document.body.style.cursor="wait"
    strNum_Lineas = ""
    for(i=1;i<=t_rows;i++)  
      if($("celda_" + v_num_grid + "_" + i + "_" + C_CHECKBOX).checked==true)
      {
        if(strNum_Lineas!="")
          strNum_Lineas     = strNum_Lineas+delimiter
        strNum_Lineas     = strNum_Lineas+$("celda_" + v_num_grid + "_" + i + "_" + C_ITEMS).value
        $("celda_" + v_num_grid + "_" + i + "_" + C_CHECKBOX).checked=false
      }
    
    var ajx = new Ajax("compras_productos_grabar.asp",{
      method:'post', 
      data: 'accion=actualizar_proveedor&documento_no_valorizado='+$("documento_no_valorizado").value+
          '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
          '&documento_respaldo='+$("documento_respaldo").value+
          '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
          '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value+
          '&proveedor='+$("entidad_comercial").value+
          '&strNum_Lineas='+escape(strNum_Lineas),
      onComplete: function(respuesta){
        //alert(respuesta)
        document.body.style.cursor="default"
        entidad_comercial.setAttribute("o_value",$("label_proveedor_cabecera").getAttribute("rut").toString());
        Set_Cancelar_Proveedor()
        Cargar_Items("EDITAR","")
        Config_Msg_Accion(" Itemes actualizados...",5000,$("msg_accion_3"))
      }
    });
    ajx.request();
  }
}

function Verificar_Check_Tuplas(){
  v_num_grid = 1
  for(k=1;k<=t_rows;k++) 
  {
    if($("celda_" + v_num_grid + "_" + k + "_" + C_CHECKBOX).checked==true)
      return true;
  }
  return false;
}

function Ingresar_Items_Productos(){
  v_num_grid = 1
  if($("items").value!="")
  {
    for(k=1;k<=t_rows;k++) 
    {
      if($("celda_" + v_num_grid + "_" + k + "_" + C_CHECKBOX).checked==true)
      {
        if(confirm("¿Está seguro que desea agregar "+$("items").value+" línea(s) después del item ("+k+")?"))
        {
          items.disabled              = true
          bot_agregar.disabled        = true
          bot_eliminar_item.disabled  = true
          var ajx = new Ajax("compras_productos_grabar.asp",{
            method:'post', 
            async:false,
            data: 'accion=agregar&documento_no_valorizado='+$("documento_no_valorizado").value+
            '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
            '&documento_respaldo='+$("documento_respaldo").value+
            '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
            '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value+
            '&numero_linea='+k+
            '&anio='+$("anio").value+'&bodega='+$("bodega").value+
            '&entidad_comercial='+$("entidad_comercial").value+
            '&entidad_comercial_2='+$("entidad_comercial_2").value+
            '&fecha_recepcion='+$("fecha_recepcion").value+
            '&paridad='+$("label_paridad_para_facturacion").innerHTML+
            '&items='+$("items").value,
            onComplete: function(respuesta){
              //alert(respuesta)
              //$("label_total_cif_ori").innerHTML=respuesta
              //return
              Cargar_Items("EDITAR","")
              items.disabled              = false
              bot_agregar.disabled        = false
              bot_eliminar_item.disabled  = false
              Config_Msg_Accion(" Itemes agregados después del item "+k,5000,$("msg_accion_3"))
            }
          });
          ajx.request();
        }
        $("items").value=""
        return;
      }
      
    }
    Cargar_Items("NUEVO","")
  }
  else  
    Config_Msg_Accion(" Ingrese itemes...",5000,$("msg_accion_3"))
}

function Cargar_Items(v_accion,v_num_linea){
  v_num_grid = 1
  strCargando ="<br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Cargando datos...espere un momento</b></font><br><br></center>"
  $("grilla_productos").innerHTML    = strCargando
  document.body.style.cursor    = "wait"
  $("grilla_productos").style.cursor = "wait"
  $("items").disabled        = true
  $("bot_agregar").disabled  = true
  v_vista = "NORMAL"
  if($("checkbox_vista_pedidos").checked)
    v_vista = "PEDIDO"
  //async:false,
  var ajx = new Ajax("compras_productos_grilla.asp",{
    method:'post', 
    data: 'accion='+v_accion+'&anio='+$("anio").value+'&bodega='+$("bodega").value+
    '&entidad_comercial='+$("entidad_comercial").value+
    '&entidad_comercial_2='+$("entidad_comercial_2").value+
    '&fecha_recepcion='+$("fecha_recepcion").value+
    '&documento_no_valorizado='+$("documento_no_valorizado").value+
    '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
    '&documento_respaldo='+$("documento_respaldo").value+
    '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
    '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value+
    '&paridad='+$("label_paridad_para_facturacion").innerHTML+
    '&items='+$("items").value+'&numero_linea='+v_num_linea+
    '&checktodos='+$("checktodos").checked+
    '&vista='+v_vista,
    evalScripts:true,
    update:$("grilla_productos"),
    onComplete: function(respuesta){
      //alert(respuesta)
      $("items").value           = ""
      $("items").disabled        = false
      $("bot_agregar").disabled  = false
      
      if($("documento_no_valorizado").value=="TCP")
      {
        x_col_todos = 0
        if($("checktodos").checked)
          x_col_todos = 1
        v_C_UN_COMPRA = C_UN_COMPRA + x_col_todos
        v_C_CANT_X_M  = C_CANT_X_M + x_col_todos
        
        $("grilla_productos").style.visibility = "hidden"
        for(i=1;i<=t_rows;i++)
          if($("celda_" + v_num_grid + "_" + i + "_" + C_PRODUCTO).value=="")
          {
            Bloquea_Celda(i,C_PRODUCTO,false,false)
            Set_Deshabilitar_Celdas_Edicion_Items(i,true)
          }
          else
          {
            if(v_vista == "NORMAL")
            {
              x_un_compra= $("celda_" + v_num_grid + "_" + i + "_" + v_C_UN_COMPRA).value
              //if(x_un_compra=="DOC" || x_un_compra=="GSA" || x_un_compra=="PAR")
              if(x_un_compra=="DOC" || x_un_compra=="GSA")
                Bloquea_Celda(i,v_C_CANT_X_M,true,false)
            }
          }
        $("grilla_productos").style.visibility = ""
        if(v_vista == "NORMAL")
        {
          Cargar_Items_Agrupar()
          if(t_rows > 0)
            $("bot_verificar_itemes").style.visibility   = ""
        }
        //##################################################################################
        //############## Verificar si la paridad está bien ingresada (<> 0), ###############
        //###### caso cuando se colocan fechas de recepción del futuro (paridad = 0) #######
        //##################################################################################
        //alert($("label_paridad_para_facturacion").innerHTML)
        if($("label_paridad_para_facturacion").innerHTML=="0.00")
          Cargar_Paridades_X_Fecha()
        //##################################################################################
      }
      if(t_rows > 0)
        Get_Total_Cif_ORI_ADU_EXFAB_FOB() //Get_Total_Cif_ORI_Y_ADU()
      document.body.style.cursor    = "default"
      $("grilla_productos").style.cursor = "default"
    }
  });
  ajx.request();
}

function Set_Calcula_Margen_Item(x_fila, x_factor_rubro){
  v_num_grid = 1
  //############## Calcular Margen #############
  x_col_todos_1 = 0; x_col_todos_2 = 0;
  if($("checktodos").checked)
  {
    x_col_todos_1 = 1
    x_col_todos_2 = 2
  }
    
  if($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="DS")
  {
    col_dif = 2
    col_tmp = C_TOT_CIF_ORI + x_col_todos_1
    x_total_cif_ori = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  }
  else
  {
    col_dif = 0
    col_tmp = C_TOT_CIF_ADU + x_col_todos_1
    x_total_cif_ori = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  }
  
  x_paridad_mg  = parseFloat($("paridad_margen").value)
  col_tmp       = C_PRECIO + x_col_todos_2 + col_dif
  x_precio      = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  
  //#################################################################
  //No se utiliza el valor cargado en la celda desde ASP para CIF_ORI, VOLUMEN y CPA
  //Se calculan para utilizar todos los decimales
  
  col_tmp         = C_TOT_CIF_ADU + col_dif + x_col_todos_1
  x_total_cif_adu = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  col_tmp         = C_CANT_VENTA + x_col_todos_1
  x_cantidad      = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  x_cif_ori       = 0
  if(x_cantidad > 0)
    x_cif_ori     = roundNumber(x_total_cif_ori/x_cantidad,7)
  x_costo_flete_transporte = 80 //Por defecto el flete es 80 (Terrestre). Se utiliza para las compras históricas que no tengan asociadas carpetas
  if($("carpeta").value!="")
    x_costo_flete_transporte  = parseFloat($("carpeta").options[$("carpeta").options.selectedIndex].getAttribute("costo_flete_transporte"))
  col_tmp       = C_ALTO + col_dif + x_col_todos_2
  x_alto        = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  col_tmp       = C_ANCHO + col_dif + x_col_todos_2
  x_ancho       = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  col_tmp       = C_LARGO + col_dif + x_col_todos_2
  x_largo       = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  col_tmp       = C_CANT_X_CAJA + col_dif + x_col_todos_2
  x_cant_x_caja = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  if(x_cant_x_caja==0)
    x_cant_x_caja = 1
  x_volumen     = roundNumber( ( (x_alto * x_ancho * x_largo) /1000000) / x_cant_x_caja,6)
  col_tmp       = C_CIF_ADU + col_dif + x_col_todos_1
  x_cif_adu     = 0
  if(x_cantidad > 0)
    x_cif_adu     = roundNumber(x_total_cif_adu/x_cantidad,7)
  col_tmp       = C_DELTA_CPA + col_dif + x_col_todos_1
  x_delta_cpa   = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  x_cpa         = (x_volumen * x_costo_flete_transporte + x_cif_adu) * x_factor_rubro
  x_cpa         = roundNumber(x_cpa,7)
  x_cpa         = x_cpa + x_delta_cpa
    
  //#################################################################
  col_tmp       = C_ILA + col_dif + x_col_todos_2
  x_ila         = parseFloat(Replace($("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp).value,",",""))
  x_TasaImpADU  = parseFloat($("tasaimpadu").value)
  
  x_rel_1   = x_precio/x_paridad_mg - x_cif_ori * x_TasaImpADU
  x_rel_ila = 1 + x_ila/100
  x_rel_1_sobre_ila = x_rel_1 / x_rel_ila
  if(x_ila > 0)
  {
    x_rel_2 = x_rel_1_sobre_ila  - x_cpa
    x_mg    = roundNumber(x_rel_2 / x_rel_1_sobre_ila * 100,2)
  }
  else
  {
    x_rel_2 = x_rel_1            - x_cpa
    x_mg    = roundNumber(x_rel_2 / x_rel_1           * 100,2)
  }
  //alert("x_TasaImpADU: "+x_TasaImpADU+", x_precio: "+x_precio+", x_paridad_mg: "+x_paridad_mg+", x_cpa: "+x_cpa+", x_cif_ori: "+x_cif_ori+", x_rel_1: "+x_rel_1)
  x_mg          = x_mg.toFixed(2)
  col_tmp       = C_MARGEN + col_dif + x_col_todos_2
  cell_mg       = $("celda_" + v_num_grid + "_" + x_fila + "_" + col_tmp);
  cell_mg.value = Formateo_Completo_Numero(x_mg).toString();
  cell_mg.setAttribute("o_value",Formateo_Completo_Numero(x_mg).toString());
  
}

function Eliminar_Limpiar_Items(v_accion_general){
  v_num_grid = 1
  if(t_rows>=1)
  {
    if(v_accion_general=="ELIMINAR")
    {
      strNum_Lineas = ""; v_num_linea = ""
      for(i=1;i<=t_rows;i++)
        if($("celda_" + v_num_grid + "_" + i + "_" + C_CHECKBOX).checked==true)
        {
          v_num_linea = strNum_Lineas+$("celda_" + v_num_grid + "_" + i + "_" + C_ITEMS).value
          break;
        }
      if(v_num_linea=="")
      {
        v_msg         = "¿Está seguro que desea eliminar el último item?"
        v_msg_accion  = " Ultimo item eliminado..."
        v_num_linea   = $("celda_" + v_num_grid + "_" + t_rows + "_" + C_ITEMS).value
        v_accion      = "eliminar_ultimo"
      }
      else
      {
        v_msg         = "¿Está seguro que desea eliminar el item "+v_num_linea+"?"
        v_msg_accion  = " Item eliminado..."
        v_accion      = "eliminar_item"
      }
    }
    else //Limpiar Itemes
    {
      strNum_Lineas = ""
      for(i=1;i<=t_rows;i++)
        if($("celda_" + v_num_grid + "_" + i + "_" + C_CHECKBOX).checked==true)
        {
          if(strNum_Lineas!="")
            strNum_Lineas     = strNum_Lineas+delimiter
          strNum_Lineas     = strNum_Lineas+$("celda_" + v_num_grid + "_" + i + "_" + C_ITEMS).value
        }
      if(strNum_Lineas=="")
      {
        Config_Msg_Accion(" No se han seleccionado itemes...",5000,$("msg_accion_3"))
        return;
      }
      v_msg         = "¿Está seguro que desea limpiar estos ítemes?"
      v_msg_accion  = "ITEMES LIMPIADOS..."
      v_num_linea   = ""
      v_accion      = "limpiar_items"
    }
    //alert("v_accion: "+v_accion+", v_num_linea: "+v_num_linea+", strNum_Lineas: "+strNum_Lineas)
    if(confirm(v_msg))
    {
      $("items").disabled              = true
      $("bot_agregar").disabled        = true
      $("bot_eliminar_item").disabled  = true
      $("bot_limpiar_item").disabled   = true
      $("bot_actualizar_producto").disabled   = true
      
      
      z_proveedor = $("entidad_comercial").value
      if($("codprov_proveedor_2").value!="")
        z_proveedor = $("entidad_comercial_2").value
      var ajx = new Ajax("compras_productos_grabar.asp",{
        method:'post', 
        async:false,
        data: 'accion='+v_accion+'&documento_no_valorizado='+$("documento_no_valorizado").value+
        '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
        '&documento_respaldo='+$("documento_respaldo").value+
        '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
        '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value+
        '&bodega='+$("bodega").value+
        '&proveedor='+z_proveedor+
        '&numero_linea='+v_num_linea+
        '&strNum_Lineas='+strNum_Lineas+
        '&items='+$("items").value,
        onComplete: function(respuesta){
          //alert(respuesta)
          //$("label_total_cif_ori").innerHTML=respuesta
          //return
          
          //***************************************************************************************
          //Ocultar el botón información y de Termino de compra por si cambio algo en la validación de los ítemes
          $("bot_terminar_compra").style.visibility    = "hidden"
          $("bot_informacion_to_RCP").style.visibility = "hidden"
          //***************************************************************************************
          
          Cargar_Items("EDITAR","")
          $("items").disabled              = false
          $("bot_agregar").disabled        = false
          $("bot_eliminar_item").disabled  = false
          $("bot_limpiar_item").disabled   = false
          $("bot_actualizar_producto").disabled   = false
          
          Config_Msg_Accion(v_msg_accion,5000,$("msg_accion_3"))
        }
      });
      ajx.request();
    }
  }
  else
    Config_Msg_Accion(" No se han agregado itemes...",5000,$("msg_accion_3"))
}

function Verificar_Totales_Costos(){
  x_TOTAL_COSTO_CIF_ORI         = parseFloat(Replace($("label_total_cif_ori").innerHTML,",",""))
  x_TOTAL_COSTO_CIF_ADU         = parseFloat(Replace($("label_total_cif_adu").innerHTML,",",""))
  x_TOTAL_COSTO_EX_FAB          = parseFloat(Replace($("label_total_ex_fab").innerHTML,",",""))
  TOTAL_COSTO_CIF_ORI_CABECERA  = parseFloat(Replace($("monto_neto_US$").value,",",""))
  TOTAL_COSTO_CIF_ADU_CABECERA  = parseFloat(Replace($("monto_adu_US$").value,",",""))
  TOTAL_COSTO_EX_FAB_CABECERA   = parseFloat(Replace($("total_ex_fab").value,",",""))
  
  $("label_total_cif_ori").style.color  = "#CC0000"
  if(x_TOTAL_COSTO_CIF_ORI==TOTAL_COSTO_CIF_ORI_CABECERA)
    $("label_total_cif_ori").style.color  = "#000099"
  
  $("label_total_cif_adu").style.color  = "#CC0000"
  if(x_TOTAL_COSTO_CIF_ADU==TOTAL_COSTO_CIF_ADU_CABECERA)
    $("label_total_cif_adu").style.color  = "#000099"
  
  if($("documento_respaldo").value=="Z")
  {
    $("label_total_ex_fab").style.color  = "#CC0000"
    if(x_TOTAL_COSTO_EX_FAB==TOTAL_COSTO_EX_FAB_CABECERA)
      $("label_total_ex_fab").style.color  = "#000099"
  }
}

function Set_Totales_Costos(){
  v_num_grid = 1
  Get_Totales_Costos_Chequea_Items_Para_Pasar_Compra_a_RCP()
  
  cant_decimales_tot_cif_ori = 2
  if($("documento_respaldo").value=="DS")
    cant_decimales_tot_cif_ori = 4
  
  //alert("TOTAL_COSTO_CIF_ORI: "+TOTAL_COSTO_CIF_ORI+", TOTAL_COSTO_CIF_ADU: "+TOTAL_COSTO_CIF_ADU)
  $("label_total_cif_ori").innerHTML  = Formateo_Completo_Numero(parseFloat(TOTAL_COSTO_CIF_ORI).toFixed(cant_decimales_tot_cif_ori))
  $("label_total_cif_adu").innerHTML  = Formateo_Completo_Numero(parseFloat(TOTAL_COSTO_CIF_ADU).toFixed(2))
  $("label_total_ex_fab").innerHTML   = Formateo_Completo_Numero(parseFloat(TOTAL_COSTO_EX_FAB).toFixed(2))
  TOTAL_COSTO_CIF_ORI_CABECERA = parseFloat(Replace($("monto_neto_US$").value,",",""))
  TOTAL_COSTO_CIF_ADU_CABECERA = parseFloat(Replace($("monto_adu_US$").value,",",""))
  TOTAL_COSTO_EX_FAB           = parseFloat(Replace($("total_ex_fab").value,",",""))
  TOTAL_BULTOS                 = $("bultos").value
  //alert(TOTAL_COSTO_CIF_ORI+"=="+TOTAL_COSTO_CIF_ORI_CABECERA)
  $("label_total_cif_ori").style.color  = "#CC0000"
  if(TOTAL_COSTO_CIF_ORI==TOTAL_COSTO_CIF_ORI_CABECERA)
    $("label_total_cif_ori").style.color  = "#000099"
  $("label_total_cif_adu").style.color  = "#CC0000"
  if(TOTAL_COSTO_CIF_ADU==TOTAL_COSTO_CIF_ADU_CABECERA)
    $("label_total_cif_adu").style.color  = "#000099"
  
  if($("documento_respaldo").value=="Z")
  {
    $("label_total_ex_fab").style.color  = "#CC0000"
    if(TOTAL_COSTO_EX_FAB==TOTAL_COSTO_EX_FAB_CABECERA)
      $("label_total_ex_fab").style.color  = "#000099"
  }
  
  $("bot_terminar_compra").style.visibility = "hidden"
  $("bot_informacion_to_RCP").setAttribute("campo_error","")
  if($("documento_no_valorizado").value=="TCP" && t_rows>0)
  {
    //console.log($("label_paridad_para_facturacion").innerHTML)
    if($("label_paridad_para_facturacion").innerHTML == 0)
    {
      $("bot_informacion_to_RCP").title = "Paridad en cero (0)"
      $("bot_informacion_to_RCP").setAttribute("campo_error","")
      $("bot_informacion_to_RCP").style.visibility = ""
      Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
      return;
    }
    else if(BAND_ITEMS_OK_TO_RCP==false)
    {
      $("bot_informacion_to_RCP").title = MSG_INFORMACION_TO_RCP
      $("bot_informacion_to_RCP").setAttribute("campo_error","celda_" + v_num_grid + "_" + MSG_INFORMACION_TO_RCP_ROW + "_" + MSG_INFORMACION_TO_RCP_COL)
      $("bot_informacion_to_RCP").style.visibility = ""
      Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
      return;
    }
    else if(TOTAL_COSTO_CIF_ORI_CABECERA == 0)
    {
      $("bot_informacion_to_RCP").title = "Total costo cif ori de encabezado de compra igual a cero"
      //$("bot_informacion_to_RCP").setAttribute("campo_error","")
      $("bot_informacion_to_RCP").style.visibility = ""
      Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
      return;
    }
    else if(TOTAL_COSTO_CIF_ADU_CABECERA == 0)
    {
      $("bot_informacion_to_RCP").title            = "Total costo cid adu de encabezado de compra igual a cero"
      $("bot_informacion_to_RCP").setAttribute("campo_error","monto_adu_US$")
      $("bot_informacion_to_RCP").style.visibility = ""
      Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
      return;
    }
    else if($("documento_respaldo").value=="Z" &&  TOTAL_COSTO_EX_FAB_CABECERA == 0)
    {
      $("bot_informacion_to_RCP").title            = "Total costo ex fab de encabezado de compra igual a cero"
      $("bot_informacion_to_RCP").setAttribute("campo_error","total_ex_fab")
      $("bot_informacion_to_RCP").style.visibility = ""
      Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
      return;
    }
    else if(TOTAL_COSTO_CIF_ORI != TOTAL_COSTO_CIF_ORI_CABECERA)
    {
      $("bot_informacion_to_RCP").title            = "Totales de costo cif ori distintos"
      $("bot_informacion_to_RCP").setAttribute("campo_error","monto_adu_US$")
      $("bot_informacion_to_RCP").style.visibility = ""
      Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
      return;
    }
    else if(TOTAL_COSTO_CIF_ADU != TOTAL_COSTO_CIF_ADU_CABECERA)
    {
      $("bot_informacion_to_RCP").title            = "Totales de costo cid adu distintos"
      $("bot_informacion_to_RCP").setAttribute("campo_error","monto_adu_US$")
      $("bot_informacion_to_RCP").style.visibility = ""
      Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
      return;
    }
    else if($("documento_respaldo").value=="Z" && TOTAL_COSTO_EX_FAB != TOTAL_COSTO_EX_FAB_CABECERA)
    {
      $("bot_informacion_to_RCP").title            = "Totales de costo ex fab distintos"
      $("bot_informacion_to_RCP").setAttribute("campo_error","total_ex_fab")
      $("bot_informacion_to_RCP").style.visibility = ""
      Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
      return;
    }
    else if($("documento_respaldo").value != "TU" && TOTAL_BULTOS == "")
    {
      $("bot_informacion_to_RCP").title            = "Ingrese Total Bultos"
      $("bot_informacion_to_RCP").setAttribute("campo_error","bultos")
      $("bot_informacion_to_RCP").style.visibility = ""
      Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
      return;
    }
    else if($("documento_respaldo").value != "TU" && parseInt(TOTAL_BULTOS) == 0)
    {
      $("bot_informacion_to_RCP").title            = "Total de Bultos debe ser mayor a 0"
      $("bot_informacion_to_RCP").setAttribute("campo_error","bultos")
      $("bot_informacion_to_RCP").style.visibility = ""
      Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
      return;
    }
    
    //alert("Validacion paridad")
    //Verificar que la paridad cargada corresponde a la paridad según la fecha de recepción ingresada en valores diarios de moneda
    //esta validación se debe hacer porque existen casos en donde la paridad no se cargo bien cuando se ingresó la fecha de recepción (calendario)
    var ajx_par = new Ajax(RutaProyecto+"funciones_SYS_AJAX/AJAX_Get_Paridad_Facturacion_X_Fecha.asp",{
      method:'post', 
      async:false,
      data: 'fecha='+$("fecha_recepcion").value,
      onComplete: function(respuesta){
        //alert(respuesta)
              
        $("paridad_segun_fecha_recepcion").value = respuesta
        //console.log(respuesta)
              
        z_paridad_para_facturacion      = $("label_paridad_para_facturacion").innerHTML.toString()
        z_paridad_segun_fecha_recepcion = $("paridad_segun_fecha_recepcion").value.toString()
        //alert($("paridad_segun_fecha_recepcion").value)
    
        if(z_paridad_segun_fecha_recepcion != z_paridad_para_facturacion)
        {
          $("bot_informacion_to_RCP").title            = "Paridad NO corresponde a la fecha de recepción ("+z_paridad_segun_fecha_recepcion+")"
          $("bot_informacion_to_RCP").setAttribute("campo_error","")
          $("bot_informacion_to_RCP").style.visibility = ""
          Config_Msg_Accion(" "+$("bot_informacion_to_RCP").title,5000,$("msg_accion_3"))
          return;
        }
        else
        {          
          $("bot_informacion_to_RCP").style.visibility = "hidden"
          $("bot_terminar_compra").style.visibility    = ""
          Config_Msg_Accion(" Datos de compra válidos...ya puede finalizar al compra",5000,$("msg_accion_3"))
        }
      }
    });
    ajx_par.request();
  }
}

var TOTAL_COSTO_CIF_ORI=0, TOTAL_COSTO_CIF_ADU=0, TOTAL_COSTO_EX_FAB = 0, BAND_ITEMS_OK_TO_RCP=false; 
var MSG_INFORMACION_TO_RCP = "", MSG_INFORMACION_TO_RCP_ROW = 1, MSG_INFORMACION_TO_RCP_COL = 1;
function Get_Totales_Costos_Chequea_Items_Para_Pasar_Compra_a_RCP(){
  v_num_grid = 1
  v_msg = ""
  $("bot_terminar_compra").setAttribute("advertencia","");
  v_TOTAL_COSTO_CIF_ORI   = 0
  v_TOTAL_COSTO_CIF_ADU   = 0
  v_TOTAL_COSTO_EX_FAB    = 0
  v_BAND_ITEMS_OK_TO_RCP  = true
  v_msg_col = 1
  v_msg_row = 1
  
  x_col_todos_1 = 0; x_col_todos_2 = 0;
  if($("checktodos").checked)
  {
    x_col_todos_1 = 1
    x_col_todos_2 = 2
  }
  
  col_tmp = 0
  if($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="DS")
    col_tmp = 2
  col_cif_adu     = C_CIF_ADU     + col_tmp + x_col_todos_1
  col_tot_cif_ori = C_TOT_CIF_ORI + x_col_todos_1
  col_tot_cif_adu = C_TOT_CIF_ADU + col_tmp + x_col_todos_1
  if($("documento_respaldo").value=="Z")
  {
    col_ex_fab     = C_EX_FAB     + col_tmp + x_col_todos_1
    col_tot_ex_fab = C_TOT_EX_FAB + col_tmp + x_col_todos_1
  }
    
  col_cpa         = C_CPA         + col_tmp + x_col_todos_2
  col_volumen     = C_VOLUMEN     + col_tmp + x_col_todos_2
  col_cod_aran    = C_COD_ARAN    + col_tmp + x_col_todos_2
  //col_fob         = C_FOB         + col_tmp + x_col_todos_2
  for(k=1;k<=t_rows;k++) 
  {
    if($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="DS")
    {
      v_TOTAL_COSTO_CIF_ORI = v_TOTAL_COSTO_CIF_ORI + parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_tot_cif_ori).value,",",""))
      v_TOTAL_COSTO_CIF_ADU = v_TOTAL_COSTO_CIF_ADU + parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_tot_cif_adu).value,",",""))
    }
    else
    {
      v_TOTAL_COSTO_CIF_ADU = v_TOTAL_COSTO_CIF_ADU + parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_tot_cif_adu).value,",",""))
      v_TOTAL_COSTO_CIF_ORI = v_TOTAL_COSTO_CIF_ADU
      if($("documento_respaldo").value=="Z")
        v_TOTAL_COSTO_EX_FAB  = v_TOTAL_COSTO_EX_FAB + parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_tot_ex_fab).value,",",""))
    }
    if(v_BAND_ITEMS_OK_TO_RCP == true)
    {
      v_nom_original = ""
      if($("checktodos").checked)
      {
        v_col             = C_NOMBRE_ORIGINAL
        v_nom_original    = $("celda_" + v_num_grid + "_" + k + "_" + v_col).value
      }
      v_volumen         = parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_volumen).value,",",""))
      col_cantidad      = C_CANT_VENTA + x_col_todos_1
      v_cantidad        = parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_cantidad).value,",",""))
      v_cif_adu         = parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_cif_adu).value,",",""))
      v_ex_fab = 0
      v_tot_ex_fab = 0
      if($("documento_respaldo").value=="Z")
      {
        v_ex_fab        = parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_ex_fab).value,",",""))
        v_tot_ex_fab    = parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_tot_ex_fab).value,",",""))
      }
      v_cpa             = parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_cpa).value,",",""))
      v_cod_arancelario = $("celda_" + v_num_grid + "_" + k + "_" + col_cod_aran).value
        
      //v_fob             = parseFloat(Replace($("celda_" + v_num_grid + "_" + k + "_" + col_fob).value,",",""))
      if($("celda_" + v_num_grid + "_" + k + "_" + C_PRODUCTO).value=="")
      {
        v_msg = "ITEM "+k+" EN BLANCO"
        v_msg_row = k
        v_msg_col = C_PRODUCTO
        v_BAND_ITEMS_OK_TO_RCP = false
      }
      else if(v_nom_original == "" && $("checktodos").checked)
      {
        v_msg = "NOMBRE ORIGINAL VACIO. ITEM: "+k
        v_msg_row = k
        v_msg_col = C_NOMBRE_ORIGINAL
        v_BAND_ITEMS_OK_TO_RCP = false
      }
      else if( ($("documento_respaldo").value=="R" || $("documento_respaldo").value=="DS") && v_volumen == 0)
      {
        v_msg = "VOLUMEN IGUAL A CERO. ITEM: "+k
        v_msg_row = k
        v_msg_col = col_volumen
        v_BAND_ITEMS_OK_TO_RCP = false
      }
      else if( ($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="Z") && v_volumen == 0)
      {
        v_msg = "VOLUMEN IGUAL A CERO. ITEM: "+k
        v_msg_row = k
        v_msg_col = col_volumen
        //v_BAND_ITEMS_OK_TO_RCP = false
        $("bot_terminar_compra").setAttribute("advertencia",v_msg.toString());
      }
      else if(v_cantidad == 0)
      {
        v_msg = "CANTIDAD DE VENTA IGUAL A CERO. ITEM: "+k
        v_msg_row = k
        v_msg_col = col_cantidad
        v_BAND_ITEMS_OK_TO_RCP = false
      }
      else if(v_cif_adu == 0)
      {
        v_msg = "CIF ADU IGUAL A CERO. ITEM: "+k
        v_msg_row = k
        v_msg_col = col_cif_adu
        //v_BAND_ITEMS_OK_TO_RCP = false
        $("bot_terminar_compra").setAttribute("advertencia",v_msg.toString());
      }
      else if(v_cpa == 0)
      {
        v_msg = "CPA IGUAL A CERO. ITEM: "+k
        v_msg_row = k
        v_msg_col = col_cpa
        v_BAND_ITEMS_OK_TO_RCP = false
      }
      else if(v_cod_arancelario == "")
      {
        v_msg = "CODIGO ARANCELARIO VACIO. ITEM: "+k
        v_msg_row = k
        v_msg_col = col_cod_aran
        v_BAND_ITEMS_OK_TO_RCP = false
      }
      else if(v_ex_fab == 0)
      {
        v_msg = "EX FAB IGUAL A CERO. ITEM: "+k
        v_msg_row = k
        v_msg_col = col_cif_adu
        //v_BAND_ITEMS_OK_TO_RCP = false
        $("bot_terminar_compra").setAttribute("advertencia",v_msg.toString());
      }
      /*
      if($("documento_respaldo").value =="Z" && v_fob == 0)
      {
        v_msg = "FOB IGUAL A CERO. ITEM: "+k
        v_msg_row = k
        v_msg_col = col_fob
        v_BAND_ITEMS_OK_TO_RCP = false
      }
      */
    }
  }
  TOTAL_COSTO_CIF_ORI         = roundNumber(v_TOTAL_COSTO_CIF_ORI,2)
  TOTAL_COSTO_CIF_ADU         = roundNumber(v_TOTAL_COSTO_CIF_ADU,2)
  TOTAL_COSTO_EX_FAB          = roundNumber(v_TOTAL_COSTO_EX_FAB,2)
  BAND_ITEMS_OK_TO_RCP        = v_BAND_ITEMS_OK_TO_RCP
  MSG_INFORMACION_TO_RCP      = v_msg
  MSG_INFORMACION_TO_RCP_ROW  = v_msg_row
  MSG_INFORMACION_TO_RCP_COL  = v_msg_col
}

function Set_Foco_Input_con_Error(){
  if($("bot_informacion_to_RCP").getAttribute("campo_error")!="")
  {
    v_campo_error = $("bot_informacion_to_RCP").getAttribute("campo_error")
    //alert(v_campo_error)
    $(v_campo_error).focus()
  }
}

function SaveChanges(cell, c_row, c_col, c_type, c_name, c_scale, c_maxlength, c_null, n_tabla){
  if(cell.readOnly)
    return;
  total_filas = $("t1").getAttribute("t_rows")
  v_num_grid  = 1
  c_value   = cell.value; c_ovalue  = cell.getAttribute("o_value");
  if(c_type == 0)
  {
    c_value   = Replace(cell.value, ",", "");
    c_ovalue  = Replace(cell.getAttribute("o_value"), ",","");
  }
  if(c_value == c_ovalue) 
    return;
  if(!c_null && c_value == "")
  {
    alert("Debe ingresar un valor")
    cell.value = cell.getAttribute("o_value");
    cell.focus();
    return;   
  }
    
  if(c_type == 0 && !c_null) //number
  {
    if(!IsNum(Replace(c_value,",", ".")))
    {
      alert("Ingrese un valor numérico")
      cell.value = cell.getAttribute("o_value");
      cell.focus();
      return;   
    }
             
    //Armar string de rango maximo
    if( parseFloat(c_scale)>0 )
      rango_maximo=LPad("9",parseInt(c_maxlength)-parseInt(c_scale) - 1,"9")+"."+LPad("9",parseInt(c_scale),"9")
    else
      rango_maximo=LPad("9",parseInt(c_maxlength)-parseInt(c_scale),"9")
    c_value = roundNumber(parseFloat(c_value), parseInt(c_scale));
    //if( parseFloat(c_value) < 0 || parseFloat(c_value) > parseFloat(rango_maximo)) //Por validación de expresiones regulares sólo para el campo delta_cpa se pueden ingresar valores negativos
    if( parseFloat(c_value) > parseFloat(rango_maximo))
    {
      alert("Valor fuera de Rango")
      cell.value = cell.getAttribute("o_value");
      cell.focus();
      return;
    }
  }
  else if(c_type == 2 && c_value!="") //date
  {
    c_value = Completar_Fecha_Corta(c_value)
    if(IsDate(c_value)==false)
    {
      alert("Formato de fecha incorrecta (dd/mm/yyyy)")
      cell.value = cell.getAttribute("o_value");
      cell.focus();
      return;
    }
  }
  
  v_producto    = $("celda_" + v_num_grid + "_" + c_row + "_" + C_PRODUCTO).value
  
  //**********************************************************************************************************************
  //Modificacion: Cmartinez 20160822, Se debe consultar el rubro del producto (ajax) y con ese valor calcular calcular el factor Tasa por Rubro
  //x_factor_rubro  = Get_Tasa_Rubro($("superfamilia").value)
  //console.log($("superfamilia").value + "x_factor_rubro: " + x_factor_rubro)
  
  var ajx1 = new Ajax("Get_superfamilia_x_producto.asp",{
    method:'post', 
    async:false,
    data: 'producto=' + v_producto,
    onComplete: function(respuesta1){
      factor_rubro  = Get_Tasa_Rubro(respuesta1)
      c_name1 = "" ; c_value1 = ""; c_name2 = "" ; c_value2 = ""; c_name3 = "" ; c_value3 = ""; 
      c_name4 = "" ; c_value4 = ""; c_name5 = "" ; c_value5 = ""; c_name6 = "" ; c_value6 = ""; 
      c_name7 = "" ; c_value7 = ""; c_name8 = "" ; c_value8 = ""; 
      col_dif = 0 ;  band_cpa_actualizado = false;
      
      
      if($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="DS")
        col_dif = 2
      y_col_todos_1 = 0; y_col_todos_2 = 0;
      if($("checktodos").checked)
      {
        y_col_todos_1 = 1
        y_col_todos_2 = 2
      }
      
      if(c_name=="numero_de_linea_destino")
      {
        if(c_value!="" && Existe_Linea_de_Destino(c_row, c_value))
        {
          //alert("Item de destino existente")
          Config_Msg_Accion(" Item de destino existente...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        c_name1   = "cantidad_traspaso" 
        c_value1  = Replace($("celda_" + v_num_grid + "_" + c_row + "_" + C_TRASP_CANT_M).value,",","")
      }
      if(c_name=="unidad_de_medida_compra" || c_name=="cantidad_mercancias" || c_name=="cantidad_um_compra_en_caja_envase_compra" || c_name=="unidad_de_medida_consumo" || c_name=="cantidad_x_un_consumo")
      {
        if(c_name=="cantidad_mercancias")
        {
          col_tmp     = C_CANT_M + y_col_todos_1
          v_cant_m    = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
          if(v_cant_m==0)
          {
            alert("La cantidades de mercancias debe ser mayor que 0")
            Config_Msg_Accion(" La cantidad de mercancias debe ser mayor que 0...",5000,$("msg_accion_3"))
            cell.value = cell.getAttribute("o_value");
            cell.focus();
            return;
          }
        }
        else if(c_name=="unidad_de_medida_compra")
        {
          col_tmp     = C_UN_COMPRA + y_col_todos_1
          v_un_c      = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value
          col_tmp     = C_CANT_X_M + y_col_todos_1
          v_cant_x_m  = 1
          if(v_un_c=="UN")
          {  
            v_cant_x_m  = 1
            Bloquea_Celda(c_row,col_tmp,false,false)
          }
          else if(v_un_c=="PAR")
          {
            v_cant_x_m  = 2
            Bloquea_Celda(c_row,col_tmp,true,false)
          }
          else if(v_un_c=="DOC")
          {
            v_cant_x_m = 12
            Bloquea_Celda(c_row,col_tmp,true,false)
          }
          else if(v_un_c=="GSA")
          {
            v_cant_x_m = 144
            Bloquea_Celda(c_row,col_tmp,true,false)
          }
          else
            Bloquea_Celda(c_row,col_tmp,false,false)
            
          c_name4             = "cantidad_um_compra_en_caja_envase_compra"
          c_value4            = v_cant_x_m
          
          cell_cant_x_m       = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
          cell_cant_x_m.value = v_cant_x_m.toString()
          cell_cant_x_m.setAttribute("o_value",v_cant_x_m.toString());
        }
        else if(c_name=="unidad_de_medida_consumo")
        {
          col_tmp     = C_UN_VENTA + y_col_todos_1
          v_un_v      = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value
          v_cant_x_un = 1
          col_tmp     = C_CANT_X_UN + y_col_todos_1
          if(v_un_v=="UN")
          {
            v_cant_x_un = 1
            Bloquea_Celda(c_row,col_tmp,true,false)
          }
          else if(v_un_v=="PAR")
          {
            v_cant_x_un = 2
            Bloquea_Celda(c_row,col_tmp,false,false)
          }
          else
            Bloquea_Celda(c_row,col_tmp,false,false)
          
          c_name4               = "cantidad_x_un_consumo"
          c_value4              = v_cant_x_un
          
          col_tmp               = C_CANT_X_UN + y_col_todos_1
          cell_cant_x_un        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
          cell_cant_x_un.value  = v_cant_x_un.toString()
          cell_cant_x_un.setAttribute("o_value",v_cant_x_un.toString());
        }
        if(!$("checkbox_vista_pedidos").checked)
        {//Vista Normal
          col_tmp     = C_CANT_M + y_col_todos_1
          v_cant_m    = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
          col_tmp     = C_CANT_X_M + y_col_todos_1
          v_cant_x_m  = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
          col_tmp     = C_CANT_X_UN + y_col_todos_1
          v_cant_x_un = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        
          v_cantidad  = 0
          if(v_cant_x_un > 0)
            v_cantidad  = roundNumber(parseFloat(v_cant_m * v_cant_x_m / v_cant_x_un),0) //Cálculo cantidad venta
          if(v_cantidad > 0)
          {
            //Recalcular totales y almacenar valores para pasarlos como parámetros y actualizar en BD
            if(col_dif==2)
            {
              cant_decimales_cif_ori = 4
              if($("documento_respaldo").value=="DS")
                  cant_decimales_cif_ori = 7
              col_tmp             = C_TOT_CIF_ORI + y_col_todos_1
              v_total_cif_ori     = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
              v_cif_ori           = roundNumber(v_total_cif_ori/v_cantidad,7)
              c_name2             = "costo_cif_ori_us$"
              c_value2            = v_cif_ori
              col_tmp             = C_CIF_ORI
              v_cif_ori           = roundNumber(v_cif_ori,cant_decimales_cif_ori)
              v_cif_ori           = v_cif_ori.toFixed(cant_decimales_cif_ori)
              cell_cif_ori        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
              cell_cif_ori.value  = Formateo_Completo_Numero(v_cif_ori).toString()
              cell_cif_ori.setAttribute("o_value",Formateo_Completo_Numero(v_cif_ori).toString());
              
            }
            
            col_tmp             = C_TOT_CIF_ADU + col_dif + y_col_todos_1
            v_total_cif_adu     = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
            v_cif_adu           = roundNumber(v_total_cif_adu/v_cantidad,7)
            c_name1             = "costo_cif_adu_us$"
            c_value1            = v_cif_adu
            col_tmp             = C_CIF_ADU + col_dif
            v_cif_adu           = roundNumber(v_cif_adu,4)
            v_cif_adu           = v_cif_adu.toFixed(4)
            cell_cif_adu        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
            cell_cif_adu.value  = Formateo_Completo_Numero(v_cif_adu).toString()
            cell_cif_adu.setAttribute("o_value",Formateo_Completo_Numero(v_cif_adu).toString());
            
            col_tmp         = C_VOLUMEN + col_dif + y_col_todos_2
            v_volumen       = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
            v_costo_flete_transporte = parseFloat(carpeta.options[carpeta.options.selectedIndex].getAttribute("costo_flete_transporte"))
            v_factor_volumen_en_cero  = 1
            if(roundNumber(v_volumen,7)!=0 && roundNumber(v_volumen,4)==0)
              v_factor_volumen_en_cero = parseFloat(factor_volumen_en_cero)
            v_cpa           = (v_volumen * v_costo_flete_transporte + parseFloat(v_cif_adu)) * factor_rubro * v_factor_volumen_en_cero
            v_cpa           = roundNumber(v_cpa,7)
            if($("documento_respaldo").value!="R" && $("documento_respaldo").value!="DS")
              v_cpa = roundNumber(v_total_cif_adu/v_cantidad,7) * factor_rubro
            c_name5         = "costo_cpa_us$"
            c_value5        = v_cpa
            col_tmp         = C_CPA + col_dif + y_col_todos_2
            v_cpa           = roundNumber(v_cpa,4)
            v_cpa           = v_cpa.toFixed(4)
            cell_cpa        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp)
            cell_cpa.value  = Formateo_Completo_Numero(v_cpa).toString()
            cell_cpa.setAttribute("o_value",Formateo_Completo_Numero(v_cpa).toString());
            band_cpa_actualizado = true
            
            c_name3             = "cantidad_entrada"
            c_value3            = v_cantidad
            col_tmp             = C_CANT_VENTA + y_col_todos_1
            cell_cantidad       = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
            cell_cantidad.value = Formateo_Completo_Numero(v_cantidad).toString()
            cell_cantidad.setAttribute("o_value",Formateo_Completo_Numero(v_cantidad).toString());
            
            Set_Calcula_Margen_Item(c_row, factor_rubro)
          }
        }
        else
        {
          c_name3             = "cantidad_entrada"
          c_value3            = v_cant_m //En este caso se asume que cantidad de mercancias = cantidad de venta por que las unidades de compra y venta son "UN" y las cant X M = 1
        }
      }
      else if(c_name=="cantidad_entrada")
      {
        v_cantidad  = parseFloat(cell.value)
        if(v_cantidad==0)
        {
          alert("La cantidad de venta debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad de venta debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        if(col_dif==2)
        {
          cant_decimales_cif_ori = 4
          if($("documento_respaldo").value=="DS")
              cant_decimales_cif_ori = 7
          col_tmp         = C_TOT_CIF_ORI + y_col_todos_1
          v_total_cif_ori = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
          v_cif_ori       = roundNumber(v_total_cif_ori/v_cantidad,7)
          c_name2         = "costo_cif_ori_us$"
          c_value2        = v_cif_ori
          col_tmp         = C_CIF_ORI
          v_cif_ori       = roundNumber(v_cif_ori,cant_decimales_cif_ori)
          v_cif_ori       = v_cif_ori.toFixed(cant_decimales_cif_ori)
          cell_cif_ori    = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
          cell_cif_ori.value = Formateo_Completo_Numero(v_cif_ori).toString()
          cell_cif_ori.setAttribute("o_value",Formateo_Completo_Numero(v_cif_ori).toString());
          
        }
        col_tmp         = C_TOT_CIF_ADU + col_dif + y_col_todos_1
        v_total_cif_adu = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        v_cif_adu       = roundNumber(v_total_cif_adu/v_cantidad,7)
        c_name1         = "costo_cif_adu_us$"
        c_value1        = v_cif_adu
        col_tmp         = C_CIF_ADU + col_dif
        v_cif_adu       = roundNumber(v_cif_adu,4)
        v_cif_adu       = v_cif_adu.toFixed(4)
        cell_cif_adu    = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_cif_adu.value = Formateo_Completo_Numero(v_cif_adu).toString()
        cell_cif_adu.setAttribute("o_value",Formateo_Completo_Numero(v_cif_adu).toString());
        
        col_tmp         = C_VOLUMEN + col_dif + y_col_todos_2
        v_volumen       = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        v_costo_flete_transporte = parseFloat(carpeta.options[carpeta.options.selectedIndex].getAttribute("costo_flete_transporte"))
        v_factor_volumen_en_cero  = 1
        if(roundNumber(v_volumen,7)!=0 && roundNumber(v_volumen,4)==0)
          v_factor_volumen_en_cero = parseFloat(factor_volumen_en_cero)
        v_cpa           = (v_volumen * v_costo_flete_transporte + parseFloat(v_cif_adu)) * factor_rubro * v_factor_volumen_en_cero
        v_cpa           = roundNumber(v_cpa,7)
        if($("documento_respaldo").value!="R" && $("documento_respaldo").value!="DS")
          v_cpa = roundNumber(v_total_cif_adu/v_cantidad,7) * factor_rubro
        c_name5         = "costo_cpa_us$"
        c_value5        = v_cpa
        col_tmp         = C_CPA + col_dif + y_col_todos_2
        v_cpa           = roundNumber(v_cpa,4)
        v_cpa           = v_cpa.toFixed(4)
        cell_cpa        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_cpa.value  = Formateo_Completo_Numero(v_cpa).toString()
        cell_cpa.setAttribute("o_value",Formateo_Completo_Numero(v_cpa).toString());
        band_cpa_actualizado = true
        
        Set_Calcula_Margen_Item(c_row, factor_rubro)
      }
      else if(c_name=="costo_cif_ori_us$")
      {
        col_tmp     = C_CANT_VENTA + y_col_todos_1
        v_cantidad  = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        if(v_cantidad==0)
        {
          alert("La cantidad de venta debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad de venta debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        cant_decimales_tot_cif_ori = 2
        if($("documento_respaldo").value=="DS")
          cant_decimales_tot_cif_ori = 4
        v_cif_ori       = parseFloat(Replace(cell.value,",",""))
        v_total_cif_ori = roundNumber(v_cif_ori * v_cantidad,cant_decimales_tot_cif_ori)
        //console.log("v_cif_ori: (" + v_cif_ori + ") * v_cantidad (" + v_cantidad + ") = " + v_total_cif_ori);
        col_tmp         = C_TOT_CIF_ORI + y_col_todos_1
        v_total_cif_ori = roundNumber(v_total_cif_ori,cant_decimales_tot_cif_ori)
        v_total_cif_ori = v_total_cif_ori.toFixed(cant_decimales_tot_cif_ori)
        cell_total_cif_ori = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_total_cif_ori.value = Formateo_Completo_Numero(v_total_cif_ori).toString()
        cell_total_cif_ori.setAttribute("o_value",Formateo_Completo_Numero(v_total_cif_ori).toString());
        Set_Calcula_Margen_Item(c_row, factor_rubro)
      }
      else if(c_name=="total_cif_ori")
      {
        col_tmp     = C_CANT_VENTA + y_col_todos_1
        v_cantidad  = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        if(v_cantidad==0)
        {
          alert("La cantidad de venta debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad de venta debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        cant_decimales_tot_cif_ori = 2
        if($("documento_respaldo").value=="DS")
            cant_decimales_tot_cif_ori = 4
        v_total_cif_ori = parseFloat(Replace(cell.value,",",""))
        v_cif_ori       = roundNumber(v_total_cif_ori/v_cantidad,7)
        col_tmp         = C_CIF_ORI + y_col_todos_1
        cell            = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp)
        c_name          = "costo_cif_ori_us$"
        c_value         = v_cif_ori
        col_tmp         = C_TOT_CIF_ORI + y_col_todos_1
        v_total_cif_ori = roundNumber(v_total_cif_ori,cant_decimales_tot_cif_ori)
        v_total_cif_ori = v_total_cif_ori.toFixed(cant_decimales_tot_cif_ori)
        cell_total_cif_ori = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_total_cif_ori.value = Formateo_Completo_Numero(v_total_cif_ori).toString()
        cell_total_cif_ori.setAttribute("o_value",Formateo_Completo_Numero(v_total_cif_ori).toString());
        Set_Calcula_Margen_Item(c_row, factor_rubro)
      }
      else if(c_name=="total_cif_adu")
      {
        col_tmp     = C_CANT_VENTA + y_col_todos_1
        v_cantidad  = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        if(v_cantidad==0)
        {
          alert("La cantidad de venta debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad de venta debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        v_total_cif_adu = parseFloat(Replace(cell.value,",",""))
        v_cif_adu       = roundNumber(v_total_cif_adu/v_cantidad,7)
        col_tmp         = C_CIF_ADU + col_dif + y_col_todos_1
        cell            = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp)
        c_name          = "costo_cif_adu_us$"
        c_value         = v_cif_adu
        col_tmp         = C_TOT_CIF_ADU + col_dif + y_col_todos_1
        v_total_cif_adu = roundNumber(v_total_cif_adu,2)
        v_total_cif_adu = v_total_cif_adu.toFixed(2)
        cell_total_cif_adu = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_total_cif_adu.value = Formateo_Completo_Numero(v_total_cif_adu).toString()
        cell_total_cif_adu.setAttribute("o_value",Formateo_Completo_Numero(v_total_cif_adu).toString());
        
        col_tmp         = C_VOLUMEN + col_dif + y_col_todos_2
        v_volumen       = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        v_costo_flete_transporte = parseFloat(carpeta.options[carpeta.options.selectedIndex].getAttribute("costo_flete_transporte"))
        v_factor_volumen_en_cero  = 1
        if(roundNumber(v_volumen,7)!=0 && roundNumber(v_volumen,4)==0)
          v_factor_volumen_en_cero = parseFloat(factor_volumen_en_cero)
        v_cpa           = (v_volumen * v_costo_flete_transporte + parseFloat(v_cif_adu)) * factor_rubro * v_factor_volumen_en_cero
        v_cpa           = roundNumber(v_cpa,7)
        if($("documento_respaldo").value!="R" && $("documento_respaldo").value!="DS")
          v_cpa = roundNumber(v_total_cif_adu/v_cantidad,7) * factor_rubro
        c_name5         = "costo_cpa_us$"
        c_value5        = v_cpa
        col_tmp         = C_CPA + col_dif + y_col_todos_2
        v_cpa           = roundNumber(v_cpa,4)
        v_cpa           = v_cpa.toFixed(4)
        cell_cpa        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_cpa.value  = Formateo_Completo_Numero(v_cpa).toString()
        cell_cpa.setAttribute("o_value",Formateo_Completo_Numero(v_cpa).toString());
        band_cpa_actualizado = true
        
        Set_Calcula_Margen_Item(c_row, factor_rubro)
      }
      else if(c_name=="alto" || c_name=="ancho" || c_name=="largo" || c_name=="cantidad_x_caja")
      {
        col_tmp     = C_CANT_VENTA + y_col_todos_1
        v_cantidad  = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        if(v_cantidad==0)
        {
          alert("La cantidad de venta debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad de venta debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        
        col_tmp       = C_CANT_X_CAJA + col_dif + y_col_todos_2
        v_cant_x_caja = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        if(v_cant_x_caja == 0)
        {
          alert("La cantidad por caja debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad por caja debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        col_tmp   = C_ALTO + col_dif + y_col_todos_2
        v_alto    = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        col_tmp   = C_ANCHO + col_dif + y_col_todos_2
        v_ancho   = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        col_tmp   = C_LARGO + col_dif + y_col_todos_2
        v_largo   = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
          
        v_volumen = roundNumber( ( (v_alto * v_ancho * v_largo) /1000000) / v_cant_x_caja,6)
          
        col_tmp             = C_VOLUMEN + col_dif + y_col_todos_2
        cell_volumen        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_volumen.value  = Formateo_Completo_Numero(v_volumen.toFixed(6)).toString()
        cell_volumen.setAttribute("o_value",Formateo_Completo_Numero(v_volumen.toFixed(6)).toString());
        
        if($("documento_respaldo").value=="R"  || $("documento_respaldo").value=="DS")
        {   
          //Recalcular CPA
          col_tmp                   = C_TOT_CIF_ADU + col_dif + y_col_todos_1
          v_total_cif_adu           = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
          col_tmp                   = C_CIF_ADU + col_dif + y_col_todos_1
          v_cif_adu                 = roundNumber(v_total_cif_adu/v_cantidad,7)
          v_costo_flete_transporte  = parseFloat(carpeta.options[carpeta.options.selectedIndex].getAttribute("costo_flete_transporte"))
          v_factor_volumen_en_cero  = 1
          if(roundNumber(v_volumen,7)!=0 && roundNumber(v_volumen,4)==0)
            v_factor_volumen_en_cero = parseFloat(factor_volumen_en_cero)
          v_cpa                     = (v_volumen * v_costo_flete_transporte + v_cif_adu) * factor_rubro * v_factor_volumen_en_cero
          v_cpa                     = roundNumber(v_cpa,7)
          c_name5                   = "costo_cpa_us$"
          c_value5                  = v_cpa
          v_cpa = roundNumber(v_cpa,4)
          v_cpa = v_cpa.toFixed(4)
          col_tmp                   = C_CPA + col_dif + y_col_todos_2
          cell_cpa                  = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
          cell_cpa.value            = Formateo_Completo_Numero(v_cpa).toString()
          cell_cpa.setAttribute("o_value",Formateo_Completo_Numero(v_cpa).toString());
          band_cpa_actualizado = true
          
          Set_Calcula_Margen_Item(c_row, factor_rubro)
        }
        
        col_tmp       = C_CANT_X_CAJA + col_dif + y_col_todos_2
        v_cant_x_caja = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        if(v_cant_x_caja == 0)
        {
          alert("La cantidad por caja debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad de caja debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        col_tmp       = C_PESO_X_CAJA + col_dif + y_col_todos_2
        v_peso_x_caja = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))  
        v_peso        = roundNumber(v_peso_x_caja/v_cant_x_caja,1)
        c_name6       = "peso"
        c_value6      = v_peso
          
        col_tmp          = C_PESO + col_dif + y_col_todos_2
        cell_peso        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_peso.value  = Formateo_Completo_Numero(v_peso.toFixed(1)).toString()
        cell_peso.setAttribute("o_value",Formateo_Completo_Numero(v_peso.toFixed(1)).toString());
        
      }
      else if(c_name=="peso_x_caja")
      {
        col_tmp       = C_CANT_X_CAJA + col_dif + y_col_todos_2
        v_cant_x_caja = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        if(v_cant_x_caja == 0)
        {
          alert("La cantidad por caja debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad de caja debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        col_tmp       = C_PESO_X_CAJA + col_dif + y_col_todos_2
        v_peso_x_caja = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))  
        v_peso        = roundNumber(v_peso_x_caja/v_cant_x_caja,1)
        c_name6       = "peso"
        c_value6      = v_peso
          
        col_tmp          = C_PESO + col_dif + y_col_todos_2
        cell_peso        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_peso.value  = Formateo_Completo_Numero(v_peso.toFixed(1)).toString()
        cell_peso.setAttribute("o_value",Formateo_Completo_Numero(v_peso.toFixed(1)).toString());
      }
      else if(c_name=="delta_cpa_us$")
        Set_Calcula_Margen_Item(c_row, factor_rubro)
      else if(c_name=="precio_de_lista_modificado")
        Set_Calcula_Margen_Item(c_row, factor_rubro)
      else if(c_name=="cantidad_origen")
      {
        v_cantidad  = parseFloat(Replace(cell.value,",",""))
        if(v_cantidad==0)
        {
          alert("La cantidad de origen debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad de origen debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        
        //EX FAB
        col_tmp         = C_TOT_EX_FAB + col_dif + y_col_todos_1
        v_total_ex_fab  = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        v_ex_fab        = roundNumber(v_total_ex_fab/v_cantidad,7)
        c_name7         = "costo_ex_fab_moneda_origen"
        c_value7        = v_ex_fab
        col_tmp         = C_EX_FAB + col_dif
        v_ex_fab        = roundNumber(v_ex_fab,7)
        v_ex_fab        = v_ex_fab.toFixed(7)
        cell_ex_fab     = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_ex_fab.value = Formateo_Completo_Numero(v_ex_fab).toString()
        cell_ex_fab.setAttribute("o_value",Formateo_Completo_Numero(v_ex_fab).toString());
        
        //FOB
        //col_tmp     = C_TOT_FOB + col_dif + y_col_todos_1
        //v_total_fob = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        //v_fob       = roundNumber(v_total_fob/v_cantidad,7)
        //c_name8     = "costo_fob_us$"
        //c_value8    = v_fob
        //col_tmp     = C_FOB + col_dif
        //v_fob       = roundNumber(v_fob,7)
        //v_fob       = v_fob.toFixed(7)
        //cell_fob    = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        //cell_fob.value = Formateo_Completo_Numero(v_fob).toString()
        //cell_fob.setAttribute("o_value",Formateo_Completo_Numero(v_fob).toString());
      }
      else if(c_name=="total_ex_fab")
      {
        col_tmp     = C_CANT_ORI + y_col_todos_1
        v_cantidad  = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        if(v_cantidad==0)
        {
          alert("La cantidad de origen debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad de origen debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        v_total_ex_fab  = parseFloat(Replace(cell.value,",",""))
        v_ex_fab        = roundNumber(v_total_ex_fab/v_cantidad,7)
        col_tmp         = C_EX_FAB + y_col_todos_1
        cell            = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp)
        c_name          = "costo_ex_fab_moneda_origen"
        c_value         = v_ex_fab
        col_tmp         = C_TOT_EX_FAB + y_col_todos_1
        v_total_ex_fab  = roundNumber(v_total_ex_fab,2)
        v_total_ex_fab  = v_total_ex_fab.toFixed(2)
        cell_total_ex_fab = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_total_ex_fab.value = Formateo_Completo_Numero(v_total_ex_fab).toString()
        cell_total_ex_fab.setAttribute("o_value",Formateo_Completo_Numero(v_total_ex_fab).toString());
      }
      /*
      else if(c_name=="total_fob_us$")
      {
        col_tmp     = C_CANT_ORI + y_col_todos_1
        v_cantidad  = parseFloat(Replace($("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp).value,",",""))
        if(v_cantidad==0)
        {
          alert("La cantidad de origen debe ser mayor que 0")
          Config_Msg_Accion(" La cantidad de origen debe ser mayor que 0...",5000,$("msg_accion_3"))
          cell.value = cell.getAttribute("o_value");
          cell.focus();
          return;
        }
        v_total_fob = parseFloat(Replace(cell.value,",",""))
        v_fob       = roundNumber(v_total_fob/v_cantidad,7)
        col_tmp     = C_FOB + y_col_todos_1
        cell        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp)
        c_name      = "costo_fob_us$"
        c_value     = v_fob
        col_tmp     = C_TOT_FOB + y_col_todos_1
        v_total_fob = roundNumber(v_total_fob,2)
        v_total_fob  = v_total_fob.toFixed(2)
        cell_total_fob = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
        cell_total_fob.value = Formateo_Completo_Numero(v_total_fob).toString()
        cell_total_fob.setAttribute("o_value",Formateo_Completo_Numero(v_total_fob).toString());
      }
      */
      
      v_url           = "compras_productos_grabar.asp"
      v_num_linea     = $("celda_" + v_num_grid + "_" + c_row + "_" + C_ITEMS).value
      if($("traspaso_numero_documento_respaldo").disabled)
        v_num_linea = $("celda_" + v_num_grid + "_" + c_row + "_" + C_TRASP_ITEM).value
      if(nom_tabla=="entidades_comerciales")
        v_url = "compras_proveedor_grabar.asp"
      
      if(c_name=="nombre_producto_proveedor" || c_name=="nombre_producto")
      {
        //************************************************************************************************************************
        //El caracter "+" no pasa a través de post o get con Ajax--> se cambia por el caracter especial "§"
        c_value = c_value.replace(/[+]/gi,"§") //El replace se hace con expresión regular para que cambie todas las coincidencias
        //************************************************************************************************************************
      }
      
      //######################################################################################################################
      //SE ALMACENAN LOS DATOS DE VALOR (c_value) Y OBJETO CELDA (cell) PARA LLAMARLO EN LA RESPUESTA DEL AJAX
      //PARA CUANDO EL TIEMPO DE RESPUESTA ES MAYOR QUE EL SALTO DE CELDA (recordar que en cada onblir de celda
      //las variables cell y c_value (parametros de esta función) se sobreescriben y pasan a ser varibales globales que 
      //cambian su valor por cada llamada
      cell_actual     = cell
      c_value_actual  = c_value
      //######################################################################################################################
      

      v_vista = "NORMAL"
      if($("checkbox_vista_pedidos").checked)
        v_vista = "PEDIDO"
      document.body.style.cursor="wait"  
      var ajx = new Ajax(RutaProyecto+"compras/"+v_url,{
        method:'post', 
        async:false,
        data: 'accion=actualizar&entidad_comercial='+$("entidad_comercial").value+
        '&documento_no_valorizado='+$("documento_no_valorizado").value+
        '&numero_documento_no_valorizado='+$("numero_documento_no_valorizado").value+
        '&documento_respaldo='+$("documento_respaldo").value+
        '&numero_documento_respaldo='+$("numero_documento_respaldo").value+
        '&numero_interno_documento_no_valorizado='+$("numero_interno_documento_no_valorizado").value+
        '&numero_linea='+v_num_linea+
        '&paridad='+$("label_paridad_para_facturacion").innerHTML+
        '&fecha_recepcion='+$("fecha_recepcion").value+
        '&bodega='+$("bodega").value+
        '&proveedor='+$("entidad_comercial").value+
        '&entidad_comercial_2='+$("entidad_comercial_2").value+
        '&producto='+escape(v_producto)+
        '&tipo_dato='+c_type+
        '&nom_campo='+escape(c_name)+'&valor='+escape(c_value)+
        '&nom_campo1='+escape(c_name1)+'&valor1='+escape(c_value1)+
        '&nom_campo2='+escape(c_name2)+'&valor2='+escape(c_value2)+
        '&nom_campo3='+escape(c_name3)+'&valor3='+escape(c_value3)+
        '&nom_campo4='+escape(c_name4)+'&valor4='+escape(c_value4)+
        '&nom_campo5='+escape(c_name5)+'&valor5='+escape(c_value5)+
        '&nom_campo6='+escape(c_name6)+'&valor6='+escape(c_value6)+
        '&nom_campo7='+escape(c_name7)+'&valor7='+escape(c_value7)+
        '&nom_campo8='+escape(c_name8)+'&valor8='+escape(c_value8)+
        '&traspaso_anio='+$("traspaso_anio").value+
        '&traspaso_documento_respaldo='+$("traspaso_documento_respaldo").value+
        '&traspaso_numero_documento_respaldo='+$("traspaso_numero_documento_respaldo").value+
        '&traspaso_numero_interno_documento_no_valorizado='+$("traspaso_numero_interno_documento_no_valorizado").value+
        '&traspaso_numero_documento_no_valorizado='+$("traspaso_numero_documento_no_valorizado").value+
        '&vista='+v_vista,
        onComplete: function(respuesta){
          if(c_name=="nombre_producto_proveedor" || c_name=="nombre_producto")
            c_value = c_value.replace(/[§]/gi,"+")
          
          //alert(respuesta)
          //$("label_total_cif_ori").innerHTML=respuesta
          //return
          document.body.style.cursor="default"
          
          if(nom_tabla=="entidades_comerciales")
          {
            cell.value = c_value.toString();
            cell.setAttribute("o_value", c_value.toString());
            Config_Msg_Accion(" Datos actualizados...",5000,msg_accion_2)
          }
          else
          {//Movimientos productos
            
            //***************************************************************************************
            //Ocultar el botón información y de Termino de compra por si cambio algo en la validación de los ítemes
            $("bot_terminar_compra").style.visibility    = "hidden"
            $("bot_informacion_to_RCP").style.visibility = "hidden"
            //***************************************************************************************
          
            if(c_name=="producto")
            {
              if(respuesta!="NO_EXISTE")
              {
                Bloquea_Celda(c_row,C_PRODUCTO,true,false)
                Set_Deshabilitar_Celdas_Edicion_Items(c_row,false)
                            
                //Cargar los atributos del producto
                var atributos = respuesta.split("~")
                //alert(respuesta)
                //for(i=0;i<atributos.length;i++)
                //  alert(i+": "+atributos[i])
                v_nombre_final        = atributos[0]
                v_nombre_original     = atributos[1]
                v_alto                = parseFloat(atributos[2]).toFixed(1)
                v_ancho               = parseFloat(atributos[3]).toFixed(1)
                v_largo               = parseFloat(atributos[4]).toFixed(1)
                v_volumen             = parseFloat(atributos[5]).toFixed(6)
                v_peso                = parseFloat(atributos[6]).toFixed(2)
                v_ila                 = parseFloat(atributos[7]).toFixed(2)
                v_temporada           = atributos[8]
                v_precio              = atributos[9]
                v_codigo_arancelario  = atributos[10]
                v_cant_x_caja         = atributos[11]
                v_peso_x_caja         = parseFloat(atributos[12]).toFixed(2)
                v_unidad_de_medida_compra                   = atributos[13]
                v_unidad_de_medida_consumo                  = atributos[14]
                v_cantidad_um_compra_en_caja_envase_compra  = atributos[15]
                v_cantidad_x_un_consumo                     = atributos[16]
                v_producto_proveedor                        = atributos[17]
                v_proveedor_origen                          = atributos[18]
                
                
                if($("checktodos").checked)
                {
                  col_tmp                     = C_NOMBRE_ORIGINAL
                  cell_nombre_original        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_nombre_original.value  = v_nombre_original.toString()
                  cell_nombre_original.setAttribute("o_value",v_nombre_original.toString());
                }
                
                col_tmp                     = C_NOMBRE_FINAL + y_col_todos_1
                cell_nombre_final           = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                cell_nombre_final.value     = v_nombre_final.toString()
                cell_nombre_final.setAttribute("o_value",v_nombre_final.toString());
                
                col_tmp                     = C_CANT_M + y_col_todos_1
                v_cant_m                    = "0"
                cell_cant_m                 = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                cell_cant_m.value           = v_cant_m.toString()
                cell_cant_m.setAttribute("o_value",v_cant_m.toString());
                
                if(!$("checkbox_vista_pedidos").checked)
                {
                  col_tmp                     = C_UN_COMPRA + y_col_todos_1
                  v_un_compra                 = v_unidad_de_medida_compra
                  cell_un_compra              = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_un_compra.value        = v_un_compra.toString()
                  cell_un_compra.setAttribute("o_value",v_un_compra.toString());
                
                  col_tmp                     = C_CANT_X_M + y_col_todos_1
                  v_cant_x_m                  = v_cantidad_um_compra_en_caja_envase_compra
                  cell_cant_x_m               = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_cant_x_m.value         = v_cant_x_m.toString()
                  cell_cant_x_m.setAttribute("o_value",v_cant_x_m.toString());
                
                  Bloquea_Celda(c_row,col_tmp,false,false)
                  if(v_un_compra=="DOC" || v_un_compra=="GSA" || v_un_compra=="PAR")
                    Bloquea_Celda(c_row,col_tmp,true,false)
                
                  col_tmp                     = C_UN_VENTA + y_col_todos_1
                  v_un_venta                  = v_unidad_de_medida_consumo
                  cell_un_venta               = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_un_venta.value         = v_un_venta.toString()
                  cell_un_venta.setAttribute("o_value",v_un_venta.toString());
                
                  col_tmp                     = C_CANT_X_UN + y_col_todos_1
                  v_cant_x_un_venta           = v_cantidad_x_un_consumo
                  cell_cant_x_un_venta        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_cant_x_un_venta.value  = v_cant_x_un_venta.toString()
                  cell_cant_x_un_venta.setAttribute("o_value",v_cant_x_un_venta.toString());
                
                  col_tmp                     = C_ALTO + col_dif + y_col_todos_2
                  cell_alto                   = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_alto.value             = v_alto.toString()
                  cell_alto.setAttribute("o_value",v_alto.toString());
                
                  col_tmp               = C_ANCHO + col_dif + y_col_todos_2
                  cell_ancho            = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_ancho.value      = v_ancho.toString()
                  cell_ancho.setAttribute("o_value",v_ancho.toString());
                
                  col_tmp               = C_LARGO + col_dif + y_col_todos_2
                  cell_largo            = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_largo.value      = v_largo.toString()
                  cell_largo.setAttribute("o_value",v_largo.toString());
                
                  col_tmp               = C_VOLUMEN + col_dif + y_col_todos_2
                  cell_volumen          = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_volumen.value    = v_volumen.toString()
                  cell_volumen.setAttribute("o_value",v_volumen.toString());
                
                  col_tmp               = C_PESO + col_dif + y_col_todos_2
                  cell_peso             = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_peso.value       = v_peso.toString()
                  cell_peso.setAttribute("o_value",v_peso.toString());
                
                  col_tmp               = C_PRECIO + col_dif + y_col_todos_2
                  cell_precio           = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_precio.value     = Formateo_Completo_Numero(v_precio).toString()
                  cell_precio.setAttribute("o_value",Formateo_Completo_Numero(v_precio).toString());
                
                  col_tmp               = C_TEMP + col_dif + y_col_todos_2
                  cell_temporada        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_temporada.value  = v_temporada.toString()
                  cell_temporada.setAttribute("o_value",v_temporada.toString());
                
                  col_tmp                       = C_ILA + col_dif + y_col_todos_2
                  cell_codigo_arancelario       = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_codigo_arancelario.value = v_ila.toString()
                  cell_codigo_arancelario.setAttribute("o_value",v_ila.toString());
                
                  col_tmp                       = C_COD_ARAN + col_dif + y_col_todos_2
                  cell_codigo_arancelario       = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_codigo_arancelario.value = v_codigo_arancelario.toString()
                  cell_codigo_arancelario.setAttribute("o_value",v_codigo_arancelario.toString());
                
                  col_tmp                       = C_CANT_X_CAJA + col_dif + y_col_todos_2
                  cell_cant_x_caja              = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_cant_x_caja.value        = v_cant_x_caja.toString()
                  cell_cant_x_caja.setAttribute("o_value",v_cant_x_caja.toString());
                
                  col_tmp                       = C_PESO_X_CAJA + col_dif + y_col_todos_2
                  cell_peso_x_caja              = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_peso_x_caja.value        = v_peso_x_caja.toString()
                  cell_peso_x_caja.setAttribute("o_value",v_peso_x_caja.toString());
                  
                  col_tmp                       = C_PROD_PROV + col_dif + y_col_todos_2
                  cell_prod_prov                = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_prod_prov.value          = v_producto_proveedor.toString()
                  cell_prod_prov.setAttribute("o_value",v_producto_proveedor.toString());
                  
                  col_tmp                       = C_PROV_ORI + col_dif + y_col_todos_2
                  cell_prod_ori                 = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_prod_ori.value           = v_proveedor_origen.toString()
                  cell_prod_ori.setAttribute("o_value",v_proveedor_origen.toString());
                }
                else
                {
                  col_tmp                       = C_PROD_PROV_VISTA_PEDIDO
                  cell_prod_prov                = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_prod_prov.value          = v_producto_proveedor.toString()
                  cell_prod_prov.setAttribute("o_value",v_producto_proveedor.toString());
                  
                  col_tmp                       = C_PROV_ORI_VISTA_PEDIDO
                  cell_prod_ori                 = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                  cell_prod_ori.value           = v_proveedor_origen.toString()
                  cell_prod_ori.setAttribute("o_value",v_proveedor_origen.toString());
                }
                
                cell.value = Ucase(c_value.toString());
                cell.setAttribute("o_value", Ucase(c_value.toString()));
                Config_Msg_Accion(" Datos cargados...",5000,$("msg_accion_3"))
                           
                col_tmp                     = C_NOMBRE_FINAL + y_col_todos_1
                cell_nombre_final           = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                cell_nombre_final.focus()
              }
              else
              {
                cell.value = cell.value.toUpperCase()
                Config_Msg_Accion(" Producto no existe...",5000,$("msg_accion_3"))
                if(perfil=="NORMAL")
                {
                  if(confirm("El producto NO existe. ¿Desea crearlo?"))
                  {
                    OcultarCapa("capaDatosCompra")
                    $("capaNuevoProducto").style.visibility = ""
                    $("capaNuevoProducto").style.zIndex     = 1
                    //Obtener superfamilia
                    if(cell.value.length>=1)
                      $("superfamilia").value = cell.value.substr(0,1)
                    
                    //Cargar familias y subfamilias
                    Cargar_Familias(td_familia)
                    
                    $("hidden_celda_row").value = c_row
                    $("hidden_celda_col").value = C_PRODUCTO
                  }
                  else
                    cell.value = cell.getAttribute("o_value");
                }
                else
                  cell.value = cell.getAttribute("o_value");
              }
            }
            else
            {
              if(c_name == "numero_de_linea_destino")
              {
                if(respuesta == "LINEA_BLOQUEADA")
                {
                  //Existe y tiene ingresado un producto <> '00000000'
                  Config_Msg_Accion(" El item ya tiene ingresado un producto en TCP destino...",6000,$("msg_accion_3"))
                  cell.value = cell.getAttribute("o_value")
                  cell.focus()
                  return;
                }
                else
                {
                  if(c_value_actual=="")
                  {
                    col_tmp                   = C_TRASP_CANT_TRASPASO
                    cell_cant_traspaso        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                    cell_cant_traspaso.value  = "0.00"
                    cell_cant_traspaso.setAttribute("o_value","0.00");
                  }
                  else
                  {
                    col_tmp                   = C_TRASP_CANT_TRASPASO
                    cell_cant_traspaso        = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                    Bloquea_Celda(c_row,col_tmp,false,false)
                    col_tmp                   = C_TRASP_CANT_M
                    cell_cant_m               = $("celda_" + v_num_grid + "_" + c_row + "_" + col_tmp);
                    cell_cant_traspaso.value  = cell_cant_m.value
                    cell_cant_traspaso.focus()
                  }
                }
              }
              if(c_type==0)
              {
                if(c_scale > 0)
                {
                  if(c_name=="costo_cif_ori_us$" || c_name=="costo_cif_adu_us$")
                  {
                    if(c_name=="costo_cif_ori_us$")
                    {
                      cant_decimales_cif_ori = 4
                      if($("documento_respaldo").value=="DS")
                        cant_decimales_cif_ori = 7
                      c_value_actual = roundNumber(c_value_actual,cant_decimales_cif_ori)
                      c_value_actual = c_value_actual.toFixed(cant_decimales_cif_ori)
                    }
                    else
                    {
                      c_value_actual = roundNumber(c_value_actual,4)
                      c_value_actual = c_value_actual.toFixed(4)
                    }
                  }
                  else if(c_name=="costo_ex_fab_moneda_origen" || c_name=="costo_fob_us$")
                  {
                    c_value_actual = roundNumber(c_value_actual,7)
                    c_value_actual = c_value_actual.toFixed(7)
                  }
                  else
                  {
                    c_value_actual = roundNumber(c_value_actual,c_scale)
                    c_value_actual = c_value_actual.toFixed(c_scale)
                  }
                }
                if(parseFloat(c_value)==0 && c_scale>0)
                  c_value_actual = parseFloat(c_value_actual).toFixed(c_scale)
                else
                  c_value_actual = Formateo_Completo_Numero(c_value_actual)
                
                cell_actual.value = Ucase(c_value_actual.toString());
                cell_actual.setAttribute("o_value", Ucase(c_value_actual.toString()));
              }
              else
              {
                cell_actual.value = Ucase(c_value_actual.toString());
                cell_actual.setAttribute("o_value", Ucase(c_value_actual.toString()));
              }
              
              //#####################################################################################
              //YA NO SE RECORRE LA GRILLA PARA VALIDAR CADA VEZ QUE SE INGRESA UN VALOR EN UNA CELDA
              //AHORA SE VALIDA CON UN BOTÓN QUE VALIDAR LA GRILLA COMPLETA 
              //Set_Totales_Costos()
              
              //Cargar los totales cif ori y adu, valores retornados desde ajax
              var a_totales = respuesta.split("~")
              $("label_total_cif_ori").innerHTML=Formateo_Completo_Numero(parseFloat(a_totales[0]).toFixed(2))
              $("label_total_cif_adu").innerHTML=Formateo_Completo_Numero(parseFloat(a_totales[1]).toFixed(2))
              $("label_total_ex_fab").innerHTML=Formateo_Completo_Numero(parseFloat(a_totales[2]).toFixed(2))
              //$("label_total_fob").innerHTML=Formateo_Completo_Numero(parseFloat(a_totales[3]).toFixed(2))
              Verificar_Totales_Costos()
              //#####################################################################################
              Config_Msg_Accion(" Datos actualizados...",5000,$("msg_accion_3"))
            }
          }
        }
      });
      ajx.request();
    }
  });
  ajx1.request();  
}

function Bloquea_Celda(v_row,v_col,v_bloquea,v_es_select){
  v_num_grid = 1
  if(v_es_select)
  {
    if(v_bloquea)
    {
      $("celda_" + v_num_grid + "_" + v_row + "_" + v_col).disabled                 = true
      $("grid_TD_" + v_num_grid + "_" + v_row + "_" + v_col).style.backgroundColor  = "#EEEEEE"
    }
    else
    {
      $("celda_" + v_num_grid + "_" + v_row + "_" + v_col).disabled                 = false
      $("grid_TD_" + v_num_grid + "_" + v_row + "_" + v_col).style.backgroundColor  = ""
    }
  }
  else
  {
    if(v_bloquea)
    {
      $("celda_" + v_num_grid + "_" + v_row + "_" + v_col).readOnly                 = true
      $("celda_" + v_num_grid + "_" + v_row + "_" + v_col).style.backgroundColor    = "#EEEEEE"
      $("grid_TD_" + v_num_grid + "_" + v_row + "_" + v_col).style.backgroundColor  = "#EEEEEE"
    }
    else
    {
      $("celda_" + v_num_grid + "_" + v_row + "_" + v_col).readOnly                 = false
      $("celda_" + v_num_grid + "_" + v_row + "_" + v_col).style.backgroundColor    = ""
      $("grid_TD_" + v_num_grid + "_" + v_row + "_" + v_col).style.backgroundColor  = ""
    }
  }
}

function Set_Deshabilitar_Celdas_Edicion_Items(c_row,v_band){
  col_dif = 0
  if($("documento_respaldo").value=="TU" || $("documento_respaldo").value=="DS")
    col_dif = 2
  
  x_col_todos_1 = 0; x_col_todos_2 = 0;
  if($("checktodos").checked)
  {
    x_col_todos_1 = 1
    x_col_todos_2 = 2  
  }
  
  if($("checktodos").checked)
  {
    //Nombre original
    col_tmp = C_NOMBRE_ORIGINAL
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    
    //OBS DELTA CPA
    col_tmp = C_OBS_CPA + col_dif
    Bloquea_Celda(c_row,col_tmp,v_band,false)
  }
  if(!$("checkbox_vista_pedidos").checked)
  {
    if($("documento_respaldo").value=="TU")
    {
      //TOTAL CIF ORI    
      col_tmp = C_TOT_CIF_ORI + x_col_todos_1
      Bloquea_Celda(c_row,col_tmp,v_band,false)
    }
    
    if($("documento_respaldo").value=="DS")
    {
      //CIF ORI    
      col_tmp = C_CIF_ORI + x_col_todos_1
      Bloquea_Celda(c_row,col_tmp,v_band,false)
    }
  }
  
  //Nombre final
  col_tmp = C_NOMBRE_FINAL + x_col_todos_1
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  
  //Cant. M.
  col_tmp = C_CANT_M + x_col_todos_1
  
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  if(!$("checkbox_vista_pedidos").checked)
  {
    //Unidad compra
    col_tmp = C_UN_COMPRA + x_col_todos_1
    Bloquea_Celda(c_row,col_tmp,v_band,true)
    //Cant. X M.
    col_tmp = C_CANT_X_M + x_col_todos_1
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Unidad venta
    col_tmp = C_UN_VENTA + x_col_todos_1
    Bloquea_Celda(c_row,col_tmp,v_band,true)
    //Cant x UN
    col_tmp = C_CANT_X_UN + x_col_todos_1
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Alto
    col_tmp = C_ALTO + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Ancho
    col_tmp = C_ANCHO + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Largo
    col_tmp = C_LARGO + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Cantidad X Caja
    col_tmp = C_CANT_X_CAJA + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Peso X Caja
    col_tmp = C_PESO_X_CAJA + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Peso 
    //col_tmp = C_PESO + col_dif + x_col_todos_2
    //Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Fecha Vencimiento 
    col_tmp = C_FEC_VENC + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //TOTAL CIF ADU    
    col_tmp = C_TOT_CIF_ADU + col_dif + x_col_todos_1
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //DELTA CPA
    col_tmp = C_DELTA_CPA + col_dif + x_col_todos_1
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Precio
    col_tmp = C_PRECIO + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Temporada --> ???La temporada solo se habilita para productos nuevos???
    col_tmp = C_TEMP + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,true)
    //Cod Arancelario
    col_tmp = C_COD_ARAN + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Producto Proveeedor
    col_tmp = C_PROD_PROV + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Proveedor origen
    col_tmp = C_PROV_ORI + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Cod Caja
    col_tmp = C_COD_CAJA + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Proveedor Antiguo
    col_tmp = C_COD_ANTIGUO + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Cantidad origen
    col_tmp = C_CANT_ORI + col_dif + x_col_todos_2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
    //Total EXFAB Moneda Origen
    if($("documento_respaldo").value == "Z")
    {
      col_tmp = C_TOT_EX_FAB + col_dif + x_col_todos_2
      Bloquea_Celda(c_row,col_tmp,v_band,false)
    }
    //Total FOB US$
    //col_tmp = C_TOT_FOB + col_dif + x_col_todos_2
    //Bloquea_Celda(c_row,col_tmp,v_band,false)
  }
}

//------------------------------------------------------------------------------------
//############################## FUNCIONES PRODUCTO ##################################
//------------------------------------------------------------------------------------

function Cerrar_Nuevo_Producto(){
  v_num_grid = 1
  v_row = $("hidden_celda_row").value
  $("celda_" + v_num_grid + "_" + v_row + "_" + C_PRODUCTO).value = ""
  $("hidden_celda_row").value  = ""
  $("hidden_celda_col").value  = ""
  $("capaNuevoProducto").style.visibility  = "hidden"
  $("capaNuevoProducto").style.zIndex      = -1
  $("capaDatosCompra").style.visibility    = ""
  $("capaDatosCompra").style.zIndex        = 1
}

function Crear_Producto(){
  v_num_grid = 1
  
  band_requiere_ILA = false
  if($("tr_porcentaje_impuesto_1").style.visibility != "hidden")
    band_requiere_ILA = true
  
  if(Trim($("nombre_producto_nuevo").value)=="")
  {
    alert("Ingrese el nombre del nuevo producto!")
    $("nombre_producto_nuevo").focus()
    return
  }
  else if($("marca").value == "")
  {
    alert("Seleccione Marca del producto!")
    $("nombre_producto_nuevo").focus()
    return
  }
  else
  {
    if($("superfamilia").value == "O" && !IsNum(Replace($("unidad_de_medida_venta_peso_en_grs").value,",", ".")))
    {
      alert("Ingrese un valor numérico de peso y volumen")
      return;   
    }
    str_msg = "¿Está seguro que desea crear este producto?"
    if(band_requiere_ILA)
    {
      if($("porcentaje_impuesto_1").value == "")
        str_msg = "La estructura del producto requiere que se seleccione %ILA. ¿Está seguro que desea crear el producto sin ingresar %ILA?"
    }
    if(confirm(str_msg))
    {
      strCargando ="<img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' border='0' align='top'>&nbsp;Creando producto..."
      $("td_creando_producto").innerHTML = strCargando
      $("superfamilia").disabled               = true
      $("familia").disabled                    = true
      $("subfamilia").disabled                 = true
      $("nombre_producto_nuevo").disabled      = true
      $("bot_crear_nuevo_producto").disabled   = true
      $("bot_cerrar_nuevo_producto").disabled  = true
      
      $("marca").disabled                                 = true
      $("temporada").disabled                             = true
      $("unidad_de_medida_venta_peso_en_grs").disabled    = true
      $("unidad_de_medida_venta_volumen_en_cc").disabled  = true
      $("porcentaje_impuesto_1").disabled                 = true
      
      v_producto_nuevo      = $("producto_nuevo").value
      v_nom_producto_nuevo  = $("nombre_producto_nuevo").value
      v_nom_producto_nuevo  = v_nom_producto_nuevo.replace(/[+]/gi,"§")
      
      var ajx = new Ajax(RutaProyecto+"compras/compras_productos_crear.asp",{
        method:'post', 
        data: 'producto='+escape($("producto_nuevo").value)+
        '&nombre='+escape(v_nom_producto_nuevo)+
        '&superfamilia='+escape($("superfamilia").value)+
        '&familia='+escape($("familia").value)+
        '&subfamilia='+escape($("subfamilia").value)+
        '&marca='+escape($("marca").value)+
        '&temporada='+escape($("temporada").value)+
        '&unidad_de_medida_venta_peso_en_grs='+escape($("unidad_de_medida_venta_peso_en_grs").value)+
        '&unidad_de_medida_venta_volumen_en_cc='+escape($("unidad_de_medida_venta_volumen_en_cc").value)+
        '&porcentaje_impuesto_1='+escape($("porcentaje_impuesto_1").value),
        async:false,
        onComplete: function(respuesta){
          $("td_creando_producto").innerHTML                  = ""
          $("superfamilia").disabled                          = false
          $("familia").disabled                               = false
          $("subfamilia").disabled                            = false
          $("nombre_producto_nuevo").disabled                 = false
          $("nombre_producto_nuevo").value                    = ""
          $("bot_crear_nuevo_producto").disabled              = false
          
          $("marca").disabled                                 = false
          $("temporada").disabled                             = false
          $("unidad_de_medida_venta_peso_en_grs").disabled    = false
          $("unidad_de_medida_venta_volumen_en_cc").disabled  = false
          $("porcentaje_impuesto_1").disabled                 = false
          
          $("marca").value                                    = ""
          $("temporada").value                                = ""
          $("unidad_de_medida_venta_peso_en_grs").value       = 0
          $("unidad_de_medida_venta_volumen_en_cc").value     = 0
          $("porcentaje_impuesto_1").value                    = ""
          if(respuesta!="")
          {
            msg_error = "Ocurrió un error al tratar de crear el producto\n"
            msg_error+= "Información técnica del error:\n"+respuesta+"\n"
            msg_error+= "Consulte con el administrador del sistema"
            alert(msg_error)
            Config_Msg_Accion("Se produjo un error al crear el producto...",3000,$("msg_accion_3"))
            Cerrar_Nuevo_Producto()
          }
          else
          {
            v_row = $("hidden_celda_row").value
            v_col = $("hidden_celda_col").value
            Cerrar_Nuevo_Producto()
            Config_Msg_Accion("Producto <b>" + v_producto_nuevo + "</b> creado correctamente...",3000,$("msg_accion_3"))
            v_celda_producto = $("celda_" + v_num_grid + "_" + v_row + "_" + v_col)
            v_celda_producto.value = $("producto_nuevo").value
            v_celda_producto.focus()
            v_celda_nombre_original = $("celda_" + v_num_grid + "_" + v_row + "_" + C_NOMBRE_FINAL)
            v_celda_nombre_original.focus()
          }
        }
      });
      ajx.request();  
    }
  }
}

function Cargar_Familias(v_id_td){
  $("bot_crear_nuevo_producto").style.visibility = "hidden"
  var ajx = new Ajax(RutaProyecto+"compras/select_familias_x_superfamilia.asp",{
    method:'post', 
    data: 'superfamilia='+escape($("superfamilia").value),
    async:false,
    update:$(v_id_td),
    onComplete: function(respuesta){
      Cargar_SubFamilias(td_subfamilia);
      $("familia").focus()
    }
  });
  ajx.request();
}

function Cargar_SubFamilias(v_id_td){
  var ajx = new Ajax(RutaProyecto+"compras/select_subfamilias_x_familia.asp",{
    method:'post', 
    data: 'superfamilia='+escape(superfamilia.value)+'&familia='+escape(familia.value),
    async:false,
    update:$(v_id_td),
    onComplete: function(respuesta){
      Get_Nuevo_Codigo($("superfamilia").value,$("familia").value,$("subfamilia").value)
    }
  });
  ajx.request();
} 

function Get_Nuevo_Codigo(v_superfamilia,v_familia,v_subfamilia){
  var ajx = new Ajax(RutaProyecto+"compras/Get_Nuevo_Producto.asp",{
    method:'post', 
    data: 'superfamilia='+escape(v_superfamilia)+'&familia='+escape(v_familia)+'&subfamilia='+escape(v_subfamilia),
    async:false,
    onComplete: function(respuesta){
      v_a_producto_nuevo          = respuesta.split("~")
      producto_nuevo.value        = v_a_producto_nuevo[0]
      nombre_producto_nuevo.value = v_a_producto_nuevo[1]
      $("bot_crear_nuevo_producto").style.visibility = ""
      //Verificar si la estructura del producto requiere que se ingrese ILA para el producto
      Estructura_Producto_Requiere_Ingreso_de_ILA(v_superfamilia,v_familia,v_subfamilia);
      if($("superfamilia").value == "O")
      {
        $("tr_unidad_de_medida_venta_peso_en_grs").style.visibility   = ""
        $("tr_unidad_de_medida_venta_volumen_en_cc").style.visibility = ""
      }
      else
      {
        $("tr_unidad_de_medida_venta_peso_en_grs").style.visibility   = "hidden"
        $("tr_unidad_de_medida_venta_volumen_en_cc").style.visibility = "hidden"
      }
    }
  });
  ajx.request();
}

function Estructura_Producto_Requiere_Ingreso_de_ILA(v_superfamilia,v_familia,v_subfamilia){
  var ajx = new Ajax(RutaProyecto+"compras/estructura_requiere_ILA.asp",{
    method:'post', 
    data: 'superfamilia='+escape(v_superfamilia)+'&familia='+escape(v_familia)+'&subfamilia='+escape(v_subfamilia),
    async:false,
    onComplete: function(respuesta){
      //alert(respuesta)
      if(respuesta=="TRUE")
        $("tr_porcentaje_impuesto_1").style.visibility = ""
      else
        $("tr_porcentaje_impuesto_1").style.visibility = "hidden"
    }
  });
  ajx.request();
}

// ##################################################
// ########### FUNCIONES INFO ADICIONAL #############
// ##################################################

function Set_Ingresar_Info_Adicional(){
  $("capaDatosCompra").style.visibility         = "hidden"
  $("capaDatosCompra").style.zIndex             = -1
  $("capaDatosInfoAdicional").style.visibility  = ""
}

function Cerrar_Info_Adicional(){ 
  $("capaDatosInfoAdicional").style.visibility  = "hidden"
  $("capaDatosInfoAdicional").style.zIndex      = -1 
  $("capaDatosCompra").style.visibility         = ""
  $("capaDatosCompra").style.zIndex             = 1
}

////////////////////////////////////////
//Funciones Actualizar producto
////////////////////////////////////////
function Set_Actualizar_Producto(){  
  v_num_grid = 1
  strNum_Lineas = ""; v_num_linea = ""; v_producto = ""
  for(i=1;i<=t_rows;i++)
    if($("celda_" + v_num_grid + "_" + i + "_" + C_CHECKBOX).checked==true)
    {
      v_num_linea = $("celda_" + v_num_grid + "_" + i + "_" + C_ITEMS).value
      v_producto  = $("celda_" + v_num_grid + "_" + i + "_" + C_PRODUCTO).value
      break;
    }
  if(v_num_linea=="")
  {
    Config_Msg_Accion(" No ha seleccionado un item...",5000,$("msg_accion_3"))
    return;
  }
  $("producto_actualizar").value = v_producto
  
  //Obtener datos producto
  var ajx = new Ajax(RutaProyecto+"compras/compras_get_datos_producto.asp",{
    method:'post', 
    data: 'producto='+v_producto,
    async:false,
    onComplete: function(respuesta){
      var array_datos_producto = respuesta.split("~")
      z_superfamilia        = array_datos_producto[0]
      z_familia             = array_datos_producto[1]
      z_subfamilia          = array_datos_producto[2]
      z_marca               = array_datos_producto[3]
      z_genero              = array_datos_producto[4]
      z_stock_minimo_manual = array_datos_producto[5]
      z_unidad_de_medida_venta_peso_en_grs    = array_datos_producto[6]
      z_unidad_de_medida_venta_volumen_en_cc  = array_datos_producto[7]
      
      $("marca1").value               = z_marca;
      $("genero1").value              = z_genero;
      $("stock_minimo_manual1").value = z_stock_minimo_manual;
      $("unidad_de_medida_venta_peso_en_grs1").value    = z_unidad_de_medida_venta_peso_en_grs;
      $("unidad_de_medida_venta_volumen_en_cc1").value  = z_unidad_de_medida_venta_volumen_en_cc;
      $("superfamilia1").value  = z_superfamilia;
      Cargar_Familias1(td_familia1, z_familia, z_subfamilia);
    }
  });
  ajx.request();
  
  $("hidden_num_linea1").value = v_num_linea;
  
  OcultarCapa("capaDatosCompra")
  $("capaActualizarProducto").style.visibility  = ""
  $("capaActualizarProducto").style.zIndex     = 1
}

function Cargar_Familias1(v_id_td, z_familia, z_subfamilia){
  $("bot_actualizar_producto").style.visibility = "hidden"
  var ajx = new Ajax(RutaProyecto+"compras/select_familias_x_superfamilia1.asp",{
    method:'post', 
    data: 'superfamilia='+escape($('superfamilia1').value),
    async:false,
    update:$(v_id_td),
    onComplete: function(respuesta){
      if(z_familia!="")
        $("familia1").value=z_familia
      Cargar_SubFamilias1(td_subfamilia1, z_subfamilia);
    }
  });
  ajx.request();
}

function Cargar_SubFamilias1(v_id_td, z_subfamilia){
  var ajx = new Ajax(RutaProyecto+"compras/select_subfamilias_x_familia1.asp",{
    method:'post', 
    data: 'superfamilia='+escape($('superfamilia1').value)+'&familia='+escape($('familia1').value),
    async:false,
    update:$(v_id_td),
    onComplete: function(respuesta){
      if(z_subfamilia!="")
        $("subfamilia1").value=z_subfamilia;
      $("bot_actualizar_producto").style.visibility = "";
    }
  });
  ajx.request();
} 

function Cerrar_Actualizar_Producto(){ 
  $("capaActualizarProducto").style.visibility  = "hidden"
  $("capaActualizarProducto").style.zIndex      = -1
  $("capaDatosCompra").style.visibility    = ""
  $("capaDatosCompra").style.zIndex        = 1
}

function Actualizar_Producto(){
  if(stock_minimo_manual1.value == "")
  {
    $("td_actualizando_producto").innerHTML = "&nbsp;Ingrese stock min. manual"
    $("td_actualizando_producto").focus();
    return;
  }
  else if(unidad_de_medida_venta_peso_en_grs1.value == "")
  {
    $("td_actualizando_producto").innerHTML = "&nbsp;Ingrese contenido grs"
    $("td_actualizando_producto").focus();
    return;
  }
  else if(unidad_de_medida_venta_volumen_en_cc1.value == "")
  {
    $("td_actualizando_producto").innerHTML = "&nbsp;Ingrese contenido ml"
    $("td_actualizando_producto").focus();
    return;
  }
  
  if(confirm("¿Está seguro que desea actualizar este producto?"))
  { 
    strCargando ="<img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' border='0' align='top'>&nbsp;Actualizando producto..."
    $("td_actualizando_producto").innerHTML = strCargando;
    v_num_linea = $("hidden_num_linea1").value;
    var ajx = new Ajax(RutaProyecto+"compras/compras_actualizar_producto.asp",{
      method:'post', 
      data: 'documento_no_valorizado='                  + $('documento_no_valorizado').value+
            '&numero_documento_no_valorizado='          + $('numero_documento_no_valorizado').value+
            '&documento_respaldo='                      + $('documento_respaldo').value+
            '&numero_documento_respaldo='               + $('numero_documento_respaldo').value+
            '&numero_interno_documento_no_valorizado='  + $('numero_interno_documento_no_valorizado').value+
            '&numero_linea='                            + v_num_linea+
            '&producto='            + escape($('producto_actualizar').value) + 
            '&superfamilia='        + escape($('superfamilia1').value) + 
            '&familia='             + escape($('familia1').value) + 
            '&subfamilia='          + escape($('subfamilia1').value) + 
            '&marca='               + escape($('marca1').value) + 
            '&genero='              + escape($('genero1').value) + 
            '&stock_minimo_manual=' + $('stock_minimo_manual1').value + 
            '&unidad_de_medida_venta_peso_en_grs='    + $('unidad_de_medida_venta_peso_en_grs1').value + 
            '&unidad_de_medida_venta_volumen_en_cc='  + $('unidad_de_medida_venta_volumen_en_cc1').value,
      async:false,
      onComplete: function(respuesta){
        $("producto_actualizar").value=""
        $("stock_minimo_manual1").value="0"
        $("unidad_de_medida_venta_peso_en_grs1").value="0"
        $("unidad_de_medida_venta_volumen_en_cc1").value="0"
        $("td_actualizando_producto").innerHTML = ""
        Cerrar_Actualizar_Producto();
        Config_Msg_Accion(" Producto actualizado...",5000,msg_accion_3);
        $("celda_" + v_num_grid + "_" + v_num_linea + "_" + C_CHECKBOX).focus()
        $("celda_" + v_num_grid + "_" + v_num_linea + "_" + C_CHECKBOX).style.backgroundColor = "#bfefff"
        $("celda_" + v_num_grid + "_" + v_num_linea + "_" + C_ITEMS).style.backgroundColor = "#bfefff"
        $("celda_" + v_num_grid + "_" + v_num_linea + "_" + C_ITEMS_PADRE).style.backgroundColor = "#bfefff"
        $("celda_" + v_num_grid + "_" + v_num_linea + "_" + C_PRODUCTO).style.backgroundColor = "#bfefff"
        $("celda_" + v_num_grid + "_" + v_num_linea + "_" + C_NOMBRE_ORIGINAL).style.backgroundColor = "#bfefff"
        $("celda_" + v_num_grid + "_" + v_num_linea + "_" + C_CANT_M).style.backgroundColor = "#bfefff"        
      }
    });
    ajx.request();
  }
}