// function Set_Cambiar_TCP()
// function Verificar_TCP()
// function Set_Opciones_Pedido(v_fila_pedido)
// function Terminar_Pedido()
// function Config_Msg_Accion(str_Msg_Accion,v_tiempo,id_msg_accion){
// function Grabar_Pedido_Inicial()
// function Mostrar_Form_Pedido(v_band)
// function Editar_Pedido()
// function Eliminar_Pedido()
// function Generar_Informe(v_para)
// function Cancelar_Ingreso_Pedido()
// function Set_Nuevo()
// function Cancelar_Busqueda_Pedido()
// function Buscar_Pedidos(v_async,v_busqueda_aprox,v_campo_order_by)
//------------------------------------------------------------------------------------
//############################## FUNCIONES PROVEEDOR #################################
//------------------------------------------------------------------------------------
// function Set_Crear_Proveedor_Extranjero()
// function Cargar_Busqueda_Proveedor(id_text_tmp)
// function Mover_Seleccionado_Select(id_select_tmp,mov_tmp)
// function Seleccionar_Proveedor(id_select_tmp)
// function Cancelar_Busqueda_Proveedor()
// function Set_Buscar_Proveedor()
// function Set_CODPROV(v_proveedor,v_id_input)
// function Set_Cancelar_Proveedor()
// function Set_Cambiar_Proveedor()
// function Cerrar_Nuevo_Proveedor()
// function Cargar_Datos_Proveedor()
// function Verificar_Proveedor()
// function Ingresar_Datos_Proveedor()
//------------------------------------------------------------------------------------
//############################## FUNCIONES ITEMES #################################
//------------------------------------------------------------------------------------
// function Traspasar_Items()
// function Verificar_Check_Tuplas()
// function Ingresar_Items_Productos()
// function Cargar_Items(v_accion,v_num_linea)
// function Eliminar_Limpiar_Items(v_accion_general)
// function SaveChanges(cell, c_row, c_col, c_type, c_name, c_scale, c_maxlength, c_null)
// function Bloquea_Celda(v_row,v_col,v_bloquea,v_es_select)
// function Set_Deshabilitar_Celdas_Edicion_Items(c_row,v_band)
//------------------------------------------------------------------------------------
//############################## FUNCIONES PRODUCTO ##################################
//------------------------------------------------------------------------------------
// function Cerrar_Nuevo_Producto()
// function Crear_Producto()
// function Cargar_Familias(v_id_td)
// function Cargar_SubFamilias(v_id_td)
// function Get_Nuevo_Codigo(v_superfamilia,v_familia,v_subfamilia)


var C_CHECKBOX        = 1,    C_ITEMS       = 2,    C_PRODUCTO    = 3,    C_PRODUCTO_COD_PROV = 4
var C_NOMBRE          = 5,    C_CANT_M      = 6,    C_UN_PEDIDO   = 7,    C_CANT_X_M          = 8
var C_TCP_1           = 9,    C_CANT_1      = 10,   C_TCP_2       = 11,   C_CANT_2            = 12
var C_TCP_3           = 13,   C_CANT_3      = 14,   C_TCP_4       = 15,   C_CANT_4            = 16
var C_TCP_5           = 17,   C_CANT_5      = 18

//var C_UN_VENTA        = 9,    C_CANT_X_UN   = 10,   C_CANT_VENTA  = 11   
//var C_ALTO            = 9,    C_ANCHO       = 10,   C_LARGO       = 11,   C_CANT_X_CAJA       = 12
//var C_VOLUMEN         = 13,   C_PESO_X_CAJA = 14,   C_PESO        = 15

var C_CANT_ANULADOS   = 9,   C_DIFERENCIA          = 10 //Utilizan las posiciones de columnas iniciales 
//después de la 1° TCP-->Internamente se van desplazando de acuerdo a la cantidad de TCP máxima agregadas para un item del pedido 

function Set_Cambiar_TCP(){
  anio_TCP.disabled                               = false
  documento_respaldo.disabled                     = false
  numero_documento_respaldo.disabled              = false
  anio_TCP.style.backgroundColor                  = ""
  documento_respaldo.style.backgroundColor        = ""
  numero_documento_respaldo.style.backgroundColor = ""
  bot_cambiar_TCP.style.visibility                = "hidden"
  bot_traspasar.style.visibility                  = "hidden"
  bot_visualizar.style.visibility                 = "hidden"
  numero_documento_respaldo.value                 = ""
  numero_documento_no_valorizado.value            = ""
  numero_interno_documento_no_valorizado.value    = ""
  fecha_recepcion.value                           = ""
  numero_documento_respaldo.focus()
}

function Verificar_TCP(){
  document.body.style.cursor = "wait"
  var ajx = new Ajax("pedidos_verificar_TCP.asp",{
    method:'post', 
    data: 'anio='+anio.value+
    '&numero_interno_pedido='+numero_interno_pedido.value+
    '&numero_pedido='+numero_pedido.value+
    '&anio_TCP='+anio_TCP.value+
    '&documento_respaldo='+documento_respaldo.value+
    '&numero_documento_respaldo='+numero_documento_respaldo.value, 
    onComplete: function(respuesta){
      document.body.style.cursor = "default"
      //msg_return_ajax.innerHTML=respuesta
      if(respuesta=="NO_EXISTE")
      {
        numero_documento_respaldo.focus()
        Config_Msg_Accion("TCP INEXISTENTE...",3000,msg_accion_3)
      }
      else
      {
        var claves_TCP = respuesta.split("~")
        numero_documento_no_valorizado.value            = claves_TCP[0]
        numero_interno_documento_no_valorizado.value    = claves_TCP[1]
        fecha_recepcion.value                           = claves_TCP[2]
        bodega.value                                    = claves_TCP[3]
        proveedor.value                                 = claves_TCP[4]
        paridad.value                                   = claves_TCP[5]
        anio_TCP.disabled                               = true
        documento_respaldo.disabled                     = true
        numero_documento_respaldo.disabled              = true
        anio_TCP.style.backgroundColor                  = "#EEEEEE"
        documento_respaldo.style.backgroundColor        = "#EEEEEE"
        numero_documento_respaldo.style.backgroundColor = "#EEEEEE"
        bot_cambiar_TCP.style.visibility                = ""
        bot_traspasar.style.visibility                  = ""
        bot_visualizar.style.visibility                 = ""
      }
    }
  });
  ajx.request();
}

function Set_Opciones_Pedido(v_fila_pedido){
  SetChecked_Radio(radio_pedidos,v_fila_pedido)
  SetBackgroundImageInput(bot_eliminar,RutaProyecto+"imagenes/ico_eliminar_24X24_on.gif")
  bot_eliminar.disabled = false
}

function Terminar_Pedido(){
  if(confirm("¿Está seguro que desea finalizar el pedido?"))
  {
    if(bot_terminar_pedido.advertencia!="")
    {
      Config_Msg_Accion("ADVERTENCIA: "+bot_terminar_pedido.advertencia+"...",3000,msg_accion_3)
      if(confirm("ADVERTENCIA: "+bot_terminar_pedido.advertencia+"\n¿Desea cancelar el ingreso de la pedido RCP?\n(Para finalizar la pedido haga clic en \"Cancelar\")"))
        return;
    }
    document.body.style.cursor = "wait"
    strCargando ="<br><br><br><br><br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
    strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Finalizando pedido...espere un momento</b></font><br><br></center>"
    grilla_productos.innerHTML                = strCargando
    label_accion_modulo.innerText             = "FINALIZANDO pedido..."
    fieldset_datos_generales.style.visibility = "hidden"
    fieldset_proveedor.style.visibility       = "hidden"
    fieldset_items.style.visibility           = "hidden"
    table_estado.style.visibility             = "hidden"
    label_legend_fieldset_productos.innerText = ""
    //async:false,
    var ajx = new Ajax("pedidos_grabar.asp",{
      method:'post', 
      data: 'documento_respaldo='+documento_respaldo.value+
      '&numero_documento_respaldo='+numero_documento_respaldo.value+
      '&documento_no_valorizado='+documento_no_valorizado.value+
      '&numero_documento_no_valorizado='+numero_documento_no_valorizado.value+
      '&numero_interno_documento_no_valorizado='+numero_interno_documento_no_valorizado.value+
      '&bodega='+bodega.value, 
      update:$("grilla_productos"),
      onComplete: function(respuesta){
        //alert(respuesta)
        document.body.style.cursor = "default"
        if(respuesta=="")
        {
          alert("pedido grabada satisfactoriamente!!!")
          window.location.reload()
        }
        else if(respuesta!="")
        {
          msg_error = "Ocurrió un error al tratar de finalizar el pedido\n"
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
  id_msg_accion.innerText = str_Msg_Accion
  if(id_msg_accion.name=="msg_accion_1")
    setTimeout("msg_accion_1.innerText=''",v_tiempo);
  else if(id_msg_accion.name=="msg_accion_2")
    setTimeout("msg_accion_2.innerText=''",v_tiempo);
  else if(id_msg_accion.name=="msg_accion_3")
    setTimeout("msg_accion_3.innerText=''",v_tiempo);
}

function Actualizar_Datos_Pedido(v_nom_campo,v_valor){
  document.body.style.cursor = "wait"
  var ajx4 = new Ajax("pedidos_grabar.asp",{
    method:'post', 
    async:false,
    data: 'accion=actualizar&anio='+anio.value+
    '&numero_interno_pedido='+numero_interno_pedido.value+
    '&numero_pedido='+numero_pedido.value+
    '&nom_campo='+v_nom_campo+'&valor='+v_valor,
    onComplete: function(respuesta){
      //alert(respuesta)
      //msg_accion_3.innerHTML=respuesta
      //return
      document.body.style.cursor = "default"
      if(v_nom_campo=="numero_pedido")
      {
        if(respuesta=="EXISTE")
        {
          alert("YA EXISTE EL N° ("+numero_pedido.value+") EN OTRO PEDIDO DEL AÑO ("+anio.value+")")
          Config_Msg_Accion("YA EXISTE EL N° ("+numero_pedido.value+") EN OTRO PEDIDO DEL AÑO ("+anio.value+")...",3000,msg_accion_3)
          numero_pedido.focus()
        }
        else
        {
          Set_Cancelar_Cambio_Numero_Pedido()
          numero_pedido.setAttribute("o_value", numero_pedido.value.toString())
          Config_Msg_Accion("N° PEDIDO ACTUALIZADO...",3000,msg_accion_3)
        }
      }
      else if(v_nom_campo=="proveedor")
        entidad_comercial.setAttribute("o_value", v_valor.toString());
      else if(v_nom_campo=="fecha")
      {
        cell_campo_fecha = eval(v_nom_campo)
        cell_campo_fecha.setAttribute("o_value", v_valor.toString())
      }
      Config_Msg_Accion("DATOS ACTUALIZADOS...",3000,msg_accion_3)
    }
  });
  ajx4.request();
}

function Grabar_Pedido_Inicial(){
  //Primero se debe chequear si existe el numero_pedido que se está ingresando-->Si existe
  //se debe cargar el pedido y configurar el formulario como si se estuviera
  //editando el pedido
  document.body.style.cursor = "wait"
  var ajx = new Ajax("pedidos_existe.asp",{
    method:'post', 
    async:false,
    data: 'anio='+anio.value+'&numero_pedido='+numero_pedido.value,
    onComplete: function(respuesta){
      document.body.style.cursor = "default"
      //alert(respuesta)
      //msg_accion_3.innerText=respuesta
      if(respuesta=="EXISTE")
      {
        //Configurar formulario a edición de pedido
        buscar_anio.value           = anio.value
        buscar_numero_pedido.value  = numero_pedido.value
        Buscar_Pedidos(false,0,'')
        Editar_Pedido()
        Config_Msg_Accion("PEDIDO EXISTENTE...",3000,msg_accion_3)
      }
      else
      {
        if(confirm("¿Está seguro que desea grabar este pedido?"))
        {
          document.body.style.cursor = "wait"
          var ajx1 = new Ajax("pedidos_grabar.asp",{
            method:'post', 
            async:false,
            data: 'accion=insertar&anio='+anio.value+'&numero_pedido='+numero_pedido.value,
            onComplete: function(respuesta){
              //alert(respuesta)
              //msg_accion_3.innerText=respuesta
              document.body.style.cursor          = "default"
              anio.disabled                       = true
              anio.style.backgroundColor          = "#EEEEEE"
              numero_pedido.readOnly              = true
              numero_pedido.style.backgroundColor = "#EEEEEE"
              numero_pedido.setAttribute("o_value", numero_pedido.value.toString())
              var claves_pedido = respuesta.split("~")
              numero_interno_pedido.value         = claves_pedido[0]
              fecha.value                         = ""
              Mostrar_Form_Pedido(true)
              Config_Msg_Accion("PEDIDO GRABADO SATISFACTORIAMENTE...",3000,msg_accion_3)
            }
          });
          ajx1.request();
        }
        else
        {
          numero_pedido.value=""
          numero_pedido.focus()
        }
      }
    }
  });
  ajx.request();
}

function Mostrar_Form_Pedido(v_band){
  if(v_band)
  {
    td_cab_1_1.style.visibility=""
    td_cab_1_2.style.visibility=""
    td_cab_1_3.style.visibility=""
    td_cab_1_4.style.visibility=""
    td_cab_1_5.style.visibility=""
    td_cab_1_6.style.visibility=""
    td_cab_1_7.style.visibility=""
    td_cab_1_8.style.visibility=""
  }
  else
  {
    td_cab_1_1.style.visibility="hidden"
    td_cab_1_2.style.visibility="hidden"
    td_cab_1_3.style.visibility="hidden"
    td_cab_1_4.style.visibility="hidden"
    td_cab_1_5.style.visibility="hidden"
    td_cab_1_6.style.visibility="hidden"
    td_cab_1_7.style.visibility="hidden"
    td_cab_1_8.style.visibility="hidden"
  }
}

function Editar_Pedido(){
  if(Radio_Es_Arreglo(radio_pedidos))
  {
    for(i=0;i<=radio_pedidos.length-1;i++)
      if(radio_pedidos[i].checked==true)
      { 
        v_anio                  = radio_pedidos[i].anio
        v_numero_interno_pedido = radio_pedidos[i].numero_interno_pedido
        v_numero_pedido         = radio_pedidos[i].numero_pedido
        v_proveedor             = radio_pedidos[i].proveedor
        v_nombre_proveedor      = radio_pedidos[i].nombre_proveedor
        v_fecha                 = radio_pedidos[i].fecha
        v_moneda_origen         = radio_pedidos[i].moneda_origen
        v_paridad_moneda_origen = radio_pedidos[i].paridad_moneda_origen
        break;
      }
  }
  else
  {
    v_anio                  = radio_pedidos.anio
    v_numero_interno_pedido = radio_pedidos.numero_interno_pedido
    v_numero_pedido         = radio_pedidos.numero_pedido
    v_proveedor             = radio_pedidos.proveedor
    v_nombre_proveedor      = radio_pedidos.nombre_proveedor
    v_fecha                 = radio_pedidos.fecha
    v_moneda_origen         = radio_pedidos.moneda_origen
    v_paridad_moneda_origen = radio_pedidos.paridad_moneda_origen
  }
  numero_interno_pedido.value = v_numero_interno_pedido
  anio.value                  = v_anio
  anio.disabled               = true
  anio.style.backgroundColor  = "#EEEEEE"

  numero_pedido.readOnly              = true
  numero_pedido.style.backgroundColor = "#EEEEEE"
  numero_pedido.value                 = v_numero_pedido
  numero_pedido.setAttribute("o_value", v_numero_pedido.toString())
  fecha.value                         = v_fecha
  fecha.o_value                       = v_fecha
  moneda_origen.value                 = v_moneda_origen
  paridad_moneda_origen.value         = v_paridad_moneda_origen
  paridad_moneda_origen.o_value       = v_paridad_moneda_origen
  
  Mostrar_Form_Pedido(true)
  td_buscar_proveedor.style.visibility      = ""
  if(v_proveedor!="")
  {
    entidad_comercial.disabled                = true
    entidad_comercial.style.backgroundColor   = "#EEEEEE"
    entidad_comercial.value                   = v_proveedor
    entidad_comercial.setAttribute("o_value", v_proveedor.toString())

    dig_verificador.value                     = Get_Digito_Verificador_Rut(v_proveedor);
    td_buscar_proveedor.style.visibility      = "hidden"
    td_datos_proveedor.style.visibility       = ""
    td_bot_cambiar_proveedor.style.visibility = ""
    Set_CODPROV(v_proveedor,codprov_proveedor)
  }
  td_items.style.visibility                 = ""
  grilla_pedidos.style.visibility           = "hidden"
  tabla_botonera_general.style.visibility   = "hidden"
  capaDatosPedido.style.visibility          = ""
  capaDatosPedido.style.zIndex              = 1
  label_accion_modulo.innerText             = "EDITANDO PEDIDO - "+v_numero_pedido
  fieldset_datos_TCP.style.visibility       = ""
  fieldset_items.style.visibility           = ""
  fieldset_productos.style.visibility       = ""
  Cargar_Items("EDITAR","")
}

function Eliminar_Pedido(){
  if(confirm("¿Está seguro que desea eliminar este pedido?"))
  {
    if(Radio_Es_Arreglo(radio_pedidos))
    {
      for(i=0;i<=radio_pedidos.length-1;i++)
        if(radio_pedidos[i].checked==true)
        { 
          v_anio                  = radio_pedidos[i].anio
          v_numero_interno_pedido = radio_pedidos[i].numero_interno_pedido
          v_numero_pedido         = radio_pedidos[i].numero_pedido
          break;
        }
    }
    else
    {
      v_anio                  = radio_pedidos.anio
      v_numero_interno_pedido = radio_pedidos.numero_interno_pedido
      v_numero_pedido         = radio_pedidos.numero_pedido
    }
    document.body.style.cursor = "wait"
    var ajx = new Ajax("pedidos_grabar.asp",{
      method:'post', 
      async:false,
      data: 'accion=eliminar&anio='+v_anio+
      '&numero_pedido='+v_numero_pedido+
      '&numero_interno_pedido='+v_numero_interno_pedido,
      onComplete: function(respuesta){
        //alert(respuesta)
        document.body.style.cursor = "default"
        Buscar_Pedidos(true,1,'')
      }
    });
    ajx.request();
  }
}

function Generar_Informe(v_para){
  if(Radio_Es_Arreglo(radio_pedidos))
  {
    for(i=0;i<=radio_pedidos.length-1;i++)
      if(radio_pedidos[i].checked==true)
      {      
        v_documento_no_valorizado   = radio_pedidos[i].documento_no_valorizado
        v_numero_pedido = radio_pedidos[i].numero_pedido
        v_documento_respaldo        = radio_pedidos[i].documento_respaldo
        v_proveedor                 = radio_pedidos[i].proveedor
        v_nombre_proveedor          = radio_pedidos[i].nombre_proveedor
        v_fecha             = radio_pedidos[i].fecha
        v_fecha_recepcion           = radio_pedidos[i].fecha_recepcion
        v_paridad                   = radio_pedidos[i].paridad
        v_total_cif_ori             = radio_pedidos[i].total_cif_ori
        v_total_cif_adu             = radio_pedidos[i].total_cif_adu
        break;
      }
  }
  else
  {
    v_documento_no_valorizado   = radio_pedidos.documento_no_valorizado
    v_numero_pedido = radio_pedidos.numero_pedido
    v_documento_respaldo        = radio_pedidos.documento_respaldo
    v_proveedor                 = radio_pedidos.proveedor
    v_nombre_proveedor          = radio_pedidos.nombre_proveedor
    v_fecha             = radio_pedidos.fecha
    v_fecha_recepcion           = radio_pedidos.fecha_recepcion
    v_paridad                   = radio_pedidos.paridad
    v_total_cif_ori             = radio_pedidos.total_cif_ori
    v_total_cif_adu             = radio_pedidos.total_cif_adu
  }
  parametros ="para="+v_para+"&documento_no_valorizado="+v_documento_no_valorizado+"&numero_pedido="+v_numero_pedido
  parametros+="&documento_respaldo="+v_documento_respaldo+"&proveedor="+v_proveedor+"&nombre_proveedor="+escape(v_nombre_proveedor)
  parametros+="&fecha_recepcion="+v_fecha_recepcion+"&fecha="+v_fecha+"&paridad="+v_paridad+"&total_cif_ori="+v_total_cif_ori+"&total_cif_adu="+v_total_cif_adu
  ruta_informe = "pedidos_listar_detalle"
  var h = (screen.availHeight - 36), w = (screen.availWidth - 10),  x = 0 , y = 0
  str = "width="+w+", height="+h+", screenX="+x+", screenY="+y+", left="+x+", top="+y+", scrollbars=3,  menubar=no, toolbar=no, status=no"
  WinInforme = open(ruta_informe+".asp?"+parametros, "Inf", str, "replace=1")
}

function Cancelar_Ingreso_Pedido(){
  numero_interno_pedido.value         = ""
  anio.disabled                       = false
  anio.style.backgroundColor          = ""
  numero_pedido.title                 = ""
  numero_pedido.readOnly              = false
  numero_pedido.value                 = ""
  numero_pedido.setAttribute("o_value", "")
  numero_pedido.style.backgroundColor = ""
  fecha.value                         = ""
  fecha.setAttribute("o_value", "")
  fecha.disabled                      = false
  fecha.style.backgroundColor         = ""
  entidad_comercial.disabled                      = false
  entidad_comercial.value                         = ""
  entidad_comercial.setAttribute("o_value","")
  entidad_comercial.style.backgroundColor         = ""
  dig_verificador.value                           = ""
  td_buscar_proveedor.style.visibility            = "hidden"
  td_cancelar_proveedor.style.visibility          = "hidden"
  td_datos_proveedor.style.visibility             = "hidden"
  td_bot_cambiar_proveedor.style.visibility       = "hidden"
  label_accion_modulo.innerText                   = ""
  grilla_productos.innerHTML                      = ""
  bot_informacion_cerrar_pedido.style.visibility  = "hidden"
  
  tabla_botonera_general.style.visibility         = ""
  label_accion_modulo.innerText                   = "BUSCAR PEDIDO"
  capaDatosPedido.style.visibility                = "hidden"
  capaDatosPedido.style.zIndex                    = -1
  fieldset_datos_TCP.style.visibility             = "hidden"
  fieldset_items.style.visibility                 = "hidden"
  grilla_pedidos.style.visibility                 = ""
  bot_verificar_itemes.style.visibility           = "hidden"
  Cancelar_Busqueda_Pedido()
  t_rows = 0
}

function Set_Nuevo(){
  Mostrar_Form_Pedido(false)
  fieldset_datos_TCP.style.visibility     = "hidden"
  fieldset_productos.style.visibility     = "hidden"
  fieldset_items.style.visibility         = "hidden"
  tabla_botonera_general.style.visibility = "hidden"
  label_accion_modulo.innerText           = "INGRESAR NUEVO PEDIDO"
  capaDatosPedido.style.visibility        = ""
  capaDatosPedido.style.zIndex            = 1
  anio.value                              = buscar_anio.value
  numero_pedido.focus()
}

function Cancelar_Busqueda_Pedido(){
  buscar_numero_pedido.value                              = ""
  buscar_anio.disabled                                    = false
  buscar_mes.disabled                                     = false
  buscar_numero_pedido.disabled                           = false
  buscar_anio.style.backgroundColor                       = ""
  buscar_mes.style.backgroundColor                        = ""
  buscar_numero_pedido.style.backgroundColor              = ""
  SetBackgroundImageInput(bot_buscar,RutaProyecto+"imagenes/ico_buscar_24X24_on.gif")
  SetBackgroundImageInput(bot_nuevo,RutaProyecto+"imagenes/ico_nuevo_24X24_on.gif")
  SetBackgroundImageInput(bot_editar,RutaProyecto+"imagenes/ico_editar_24X24_off.gif")
  SetBackgroundImageInput(bot_eliminar,RutaProyecto+"imagenes/ico_eliminar_24X24_off.gif")
  SetBackgroundImageInput(bot_excel,RutaProyecto+"imagenes/ico_excel_24X24_off.gif")
  SetBackgroundImageInput(bot_email,RutaProyecto+"imagenes/ico_email_24X24_off.gif")
  SetBackgroundImageInput(bot_atras,RutaProyecto+"imagenes/ico_atras_24X24_off.gif")
  
  bot_buscar.disabled   = false
  bot_nuevo.disabled    = false
  bot_editar.disabled   = true
  bot_eliminar.disabled = true
  bot_excel.disabled    = true
  bot_email.disabled    = true
  bot_atras.disabled    = true
  
  grilla_pedidos.innerHTML = ""
}

function Buscar_Pedidos(v_async,v_busqueda_aprox,v_campo_order_by){
  strCargando ="<br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Listando pedidos...espere un momento</b></font><br><br></center>"
  grilla_pedidos.innerHTML                  = strCargando
  document.body.style.cursor                = "wait"
  grilla_pedidos.style.cursor               = "wait"
  buscar_anio.disabled                      = true
  buscar_mes.disabled                       = true
  buscar_numero_pedido.disabled = true
  buscar_anio.style.backgroundColor           = "#EEEEEE"
  buscar_mes.style.backgroundColor            = "#EEEEEE"
  buscar_numero_pedido.style.backgroundColor  = "#EEEEEE"
  
  bot_buscar.disabled = true
  bot_nuevo.disabled  = true
  SetBackgroundImageInput(bot_buscar,RutaProyecto+"imagenes/ico_buscar_24X24_off.gif")
  SetBackgroundImageInput(bot_nuevo,RutaProyecto+"imagenes/ico_nuevo_24X24_off.gif")
  var ajx = new Ajax("pedidos_listar.asp",{
    method:'post', 
    async:eval(v_async),
    data: 'busqueda_aprox='+v_busqueda_aprox+
    '&anio='+buscar_anio.value+
    '&mes='+buscar_mes.value+
    '&numero_pedido='+buscar_numero_pedido.value+
    '&campo_order_by='+v_campo_order_by,
    update:$("grilla_pedidos"),
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor  = "default"
      grilla_pedidos.style.cursor = "default"
      if(respuesta=="")
        Cancelar_Busqueda_Pedido()
      else
      {
        SetChecked_Radio(radio_pedidos,0)
        bot_eliminar.disabled = true
        estado_pedido = 1
        if(estado_pedido)
        {
          SetBackgroundImageInput(bot_eliminar,RutaProyecto+"imagenes/ico_eliminar_24X24_on.gif")
          bot_eliminar.disabled = false
          
        }
        SetBackgroundImageInput(bot_editar,RutaProyecto+"imagenes/ico_editar_24X24_on.gif")
        SetBackgroundImageInput(bot_excel,RutaProyecto+"imagenes/ico_excel_24X24_on.gif")
        SetBackgroundImageInput(bot_email,RutaProyecto+"imagenes/ico_email_24X24_on.gif")
        SetBackgroundImageInput(bot_atras,RutaProyecto+"imagenes/ico_atras_24X24_on.gif")
        bot_editar.disabled   = false
        bot_excel.disabled    = false
        bot_email.disabled    = false
        bot_atras.disabled    = false
      }
    }
  });
  ajx.request();
}
//------------------------------------------------------------------------------------
//############################## FUNCIONES PROVEEDOR #################################
//------------------------------------------------------------------------------------
function Set_Crear_Proveedor_Extranjero(){
  entidad_comercial.value = rut_proveedor_extranjero.value
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
      if(select_busqueda_proveedor.options(0))
        td_select_busqueda_proveedor.style.visibility = ""
    }
  });
  ajx.request();
}

function Mover_Seleccionado_Select(id_select_tmp,mov_tmp){
  if(mov_tmp==ARRIBA){
    if(parseInt(id_select_tmp.selectedIndex)>0)
      id_select_tmp.options(parseInt(id_select_tmp.selectedIndex)-1).selected=true}
  else if(mov_tmp==ABAJO){
    if(parseInt(id_select_tmp.selectedIndex)<parseInt(id_select_tmp.total_lista_select))
      id_select_tmp.options(parseInt(id_select_tmp.selectedIndex)+1).selected=true}
}

function Seleccionar_Proveedor(id_select_tmp){
  if(id_select_tmp.value!="")
  {
    entidad_comercial.value = id_select_tmp.value
    dig_verificador.value   = Get_Digito_Verificador_Rut(entidad_comercial.value)
    Cancelar_Busqueda_Proveedor()
    Verificar_Proveedor()
  }
}

function Cancelar_Busqueda_Proveedor(){
  datos_busqueda_proveedor.value                = ""
  rut_proveedor_extranjero.value                = ""
  td_crear_proveedor.style.visibility           = "hidden"
  td_select_busqueda_proveedor.style.visibility = "hidden"
  capaBuscarProveedor.style.visibility          = "hidden"
  capaDatosPedido.style.visibility              = ""
  capaDatosPedido.style.zIndex                  = 1
}

function Set_Buscar_Proveedor(){
  if(documento_respaldo.value=="Z")
  {
    document.body.style.cursor="wait"
    var ajx = new Ajax(RutaProyecto+"funciones_SYS_AJAX/AJAX_Get_Rut_Nuevo_Prov_Extanjero.asp",{
      method:'post', 
      async:false,
      onComplete: function(respuesta){
        //alert(respuesta)
        document.body.style.cursor          = "default"
        rut_proveedor_extranjero.value      = respuesta
        td_crear_proveedor.style.visibility = ""
      }
    });
    ajx.request();
  }
  capaDatosPedido.style.visibility      = "hidden"
  capaDatosPedido.style.zIndex          = -1
  capaBuscarProveedor.style.visibility  = ""
  datos_busqueda_proveedor.focus()
}

function Set_CODPROV(v_proveedor,v_id_input){
  var ajx = new Ajax(RutaProyecto+"comprasNEW/compras_proveedor_get_codprov.asp",{
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

function Set_Cancelar_Proveedor(){
  td_bot_cambiar_proveedor.style.visibility = ""
  td_datos_proveedor.style.visibility       = ""
  entidad_comercial.value                   = entidad_comercial.o_value
  Set_CODPROV(entidad_comercial.value,codprov_proveedor)
  entidad_comercial.disabled                = true
  dig_verificador.value                     = Get_Digito_Verificador_Rut(entidad_comercial.value)
  entidad_comercial.style.backgroundColor   = "#EEEEEE"
  td_buscar_proveedor.style.visibility      = "hidden"
  td_cancelar_proveedor.style.visibility    = "hidden"
}

function Set_Cambiar_Proveedor(){
  td_datos_proveedor.style.visibility       = "hidden"
  td_bot_cambiar_proveedor.style.visibility = "hidden"
  entidad_comercial.value                   = ""
  entidad_comercial.disabled                = false
  entidad_comercial.style.backgroundColor   = ""
  dig_verificador.value                     = ""
  td_buscar_proveedor.style.visibility      = ""
  td_cancelar_proveedor.style.visibility    = ""
  entidad_comercial.focus()
}

function Cerrar_Nuevo_Proveedor(){
  if(label_proveedor_cabecera.innerText=="")
    Actualizar_Datos_Pedido("proveedor",entidad_comercial.value)
  Set_CODPROV(entidad_comercial.value,codprov_proveedor)
  td_datos_proveedor.style.visibility     = ""
  OcultarCapa("capaDatosProveedor");
  grilla_nuevo.innerHTML                  = ""
  capaDatosPedido.style.visibility        = ""
  capaDatosPedido.style.zIndex            = 1
  entidad_comercial.style.backgroundColor = "#EEEEEE"
  td_buscar_proveedor.style.visibility    = "hidden"
  td_cancelar_proveedor.style.visibility  = "hidden"
  fieldset_productos.style.visibility     = ""
}

function Cargar_Datos_Proveedor(){
  var ajx = new Ajax(RutaProyecto+"comprasNEW/compras_proveedor_datos.asp",{
    method:'post', 
    async:false,
    data: 'entidad_comercial='+entidad_comercial.value+'&fecha_recepcion='+fecha_recepcion.value,
    evalScripts:true,
    onComplete: function(respuesta){
      //alert(respuesta)
    }
  });
  ajx.request();
}

function Verificar_Proveedor(){
  document.body.style.cursor  = "wait"
  //entidad_comercial.value     = LPad(entidad_comercial.value,8,0)
  entidad_comercial.disabled  = true
  var ajx = new Ajax(RutaProyecto+"comprasNEW/compras_proveedor_verificar.asp",{
    method:'post', 
    async:false,
    data: 'entidad_comercial='+entidad_comercial.value,
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor = "default"
      if(respuesta=="EXISTE")
      {
        
        Actualizar_Datos_Pedido("proveedor",entidad_comercial.value)
        Set_CODPROV(entidad_comercial.value,codprov_proveedor)
        td_buscar_proveedor.style.visibility      = "hidden"
        td_cancelar_proveedor.style.visibility    = "hidden"
        td_datos_proveedor.style.visibility       = ""
        td_bot_cambiar_proveedor.style.visibility = ""
      }
      else
      {
        if(confirm("No existe el proveedor Rut "+entidad_comercial.value+". ¿Desea agregarlo al sistema?"))
        {
          var ajx1 = new Ajax(RutaProyecto+"comprasNEW/compras_proveedor_grabar.asp",{
            method:'post', 
            async:false,            
            data: 'accion=insertar&entidad_comercial='+entidad_comercial.value,
            onComplete: function(respuesta){
              if(respuesta!="")
              {
                alert(respuesta)
                Set_Cambiar_Proveedor()
              }
              else
              {
                capaDatosPedido.style.visibility    = "hidden"
                capaDatosPedido.style.zIndex        = -1
                capaDatosProveedor.style.visibility = ""
                Ingresar_Datos_Proveedor()
              }
            }
          });
          ajx1.request();
        }
        else
        {
          entidad_comercial.disabled  = false
          entidad_comercial.value     = ""
          dig_verificador.value       = ""
          entidad_comercial.focus()
        }
      }
    }
  });
  ajx.request();
}

function Ingresar_Datos_Proveedor(){
  strCargando ="<br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Cargando datos...espere un momento</b></font><br><br></center>"
  grilla_nuevo.innerHTML      = strCargando
  document.body.style.cursor  = "wait"
  grilla_nuevo.style.cursor   = "wait"
  grilla_productos.innerHTML  = ""
  var ajx10 = new Ajax(RutaProyecto+"comprasNEW/compras_oveedor_grilla.asp",{
    method:'post', 
    data: 'entidad_comercial='+entidad_comercial.value,
    update:$("grilla_nuevo"),
    evalScripts:true,
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor  = "default"
      grilla_nuevo.style.cursor   = "default"
    }
  });
  ajx10.request();
}

//------------------------------------------------------------------------------------
//############################## FUNCIONES ITEMES #################################
//------------------------------------------------------------------------------------
function Traspasar_Items(){
  strNum_Lineas = ""; strProductos = "";
  strCantidad_mercancias                      = ""
  strUnidad_de_medida_compra                  = ""
  strCantidad_um_compra_en_caja_envase_compra = ""
  /*
  strUnidad_de_medida_consumo                 = ""
  strCantidad_x_un_consumo                    = ""
  strCantidad_entrada                         = ""
  strAlto                                     = ""
  strAncho                                    = ""
  strLargo                                    = ""
  strCantidad_x_caja                          = ""
  strPeso_x_caja                              = ""
  strPeso = ""
  */
  for(i=1;i<=t_rows;i++)
    if(eval("document.all.celda_" + i + "_" + C_CHECKBOX).checked==true)
    {
      if(eval("document.all.celda_" + i + "_" + C_PRODUCTO).readOnly)
      {
        if(strNum_Lineas!="")
        {
          strNum_Lineas                               = strNum_Lineas+delimiter
          strProductos                                = strProductos+delimiter
          strCantidad_mercancias                      = strCantidad_mercancias+delimiter
          strUnidad_de_medida_compra                  = strUnidad_de_medida_compra+delimiter
          strCantidad_um_compra_en_caja_envase_compra = strCantidad_um_compra_en_caja_envase_compra+delimiter
          /*
          strUnidad_de_medida_consumo                 = strUnidad_de_medida_consumo+delimiter
          strCantidad_x_un_consumo                    = strCantidad_x_un_consumo+delimiter
          strCantidad_entrada                         = strCantidad_entrada+delimiter
          strAlto                                     = strAlto+delimiter
          strAncho                                    = strAncho+delimiter
          strLargo                                    = strLargo+delimiter
          strCantidad_x_caja                          = strCantidad_x_caja+delimiter
          strPeso_x_caja                              = strPeso_x_caja+delimiter
          strPeso                                     = strPeso+delimiter
          */
        }
        strNum_Lineas                               = strNum_Lineas+eval("document.all.celda_" + i + "_" + C_ITEMS).value
        strProductos                                = strProductos+eval("document.all.celda_" + i + "_" + C_PRODUCTO).value
        strCantidad_mercancias                      = strCantidad_mercancias+eval("document.all.celda_" + i + "_" + C_CANT_M).value
        strUnidad_de_medida_compra                  = strUnidad_de_medida_compra+eval("document.all.celda_" + i + "_" + C_UN_PEDIDO).value
        strCantidad_um_compra_en_caja_envase_compra = strCantidad_um_compra_en_caja_envase_compra+eval("document.all.celda_" + i + "_" + C_CANT_X_M).value
        /*
        strUnidad_de_medida_consumo                 = strUnidad_de_medida_consumo+eval("document.all.celda_" + i + "_" + C_UN_VENTA).value
        strCantidad_x_un_consumo                    = strCantidad_x_un_consumo+eval("document.all.celda_" + i + "_" + C_CANT_X_UN).value
        strCantidad_entrada                         = strCantidad_entrada+eval("document.all.celda_" + i + "_" + C_CANT_VENTA).value
        strAlto                                     = strAlto+eval("document.all.celda_" + i + "_" + C_ALTO).value
        strAncho                                    = strAncho+eval("document.all.celda_" + i + "_" + C_ANCHO).value
        strLargo                                    = strLargo+eval("document.all.celda_" + i + "_" + C_LARGO).value
        strCantidad_x_caja                          = strCantidad_x_caja+eval("document.all.celda_" + i + "_" + C_CANT_X_CAJA).value
        strPeso_x_caja                              = strPeso_x_caja+eval("document.all.celda_" + i + "_" + C_PESO_X_CAJA).value
        strPeso                                     = strPeso+eval("document.all.celda_" + i + "_" + C_PESO).value
        */
      }
      else
        eval("document.all.celda_" + i + "_" + C_CHECKBOX).checked=false
    }
  if(strNum_Lineas=="")
  {
    Config_Msg_Accion("NO SE HAN SELECCIONADO ITEMES...",3000,msg_accion_3)
    return;
  }
  if(confirm("¿Está seguro que desea traspasar estos ítemes a la TCP: "+documento_respaldo.value+"-"+numero_documento_respaldo.value))
  {
    bot_cambiar_TCP.disabled    = true
    bot_traspasar.disabled      = true
    bot_visualizar.disabled     = true
    items.disabled              = true
    bot_agregar.disabled        = true
    bot_eliminar_item.disabled  = true
    bot_limpiar_item.disabled   = true
    checktodos.disabled         = true
    
    
    /*
      '&strUnidad_de_medida_consumo='+strUnidad_de_medida_consumo+
      '&strCantidad_x_un_consumo='+strCantidad_x_un_consumo+
      '&strCantidad_entrada='+strCantidad_entrada+
      '&strAlto='+strAlto+
      '&strAncho='+strAncho+
      '&strLargo='+strLargo+
      '&strCantidad_x_caja='+strCantidad_x_caja+
      '&strPeso_x_caja='+strPeso_x_caja+
      '&strPeso='+strPeso,
    */
    var ajx = new Ajax("pedidos_productos_traspasar_a_TCP.asp",{
      method:'post', 
      async:false,
      data: 'anio='+anio.value+
      '&numero_interno_pedido='+numero_interno_pedido.value+
      '&numero_pedido='+numero_pedido.value+
      '&anio_TCP='+anio_TCP.value+
      '&documento_respaldo='+documento_respaldo.value+
      '&numero_documento_respaldo='+numero_documento_respaldo.value+
      '&numero_documento_no_valorizado='+numero_documento_no_valorizado.value+
      '&numero_interno_documento_no_valorizado='+numero_interno_documento_no_valorizado.value+
      '&fecha_recepcion='+fecha_recepcion.value+
      '&bodega='+bodega.value+
      '&proveedor='+proveedor.value+
      '&paridad='+paridad.value+
      '&strNum_Lineas='+strNum_Lineas+
      '&strProductos='+escape(strProductos)+
      '&strCantidad_mercancias='+strCantidad_mercancias+
      '&strUnidad_de_medida_compra='+strUnidad_de_medida_compra+
      '&strCantidad_um_compra_en_caja_envase_compra='+strCantidad_um_compra_en_caja_envase_compra,
      onComplete: function(respuesta){
        //msg_return_ajax.innerHTML=respuesta
        //return
        Cargar_Items("EDITAR","")
        bot_cambiar_TCP.disabled    = false
        bot_traspasar.disabled      = false
        bot_visualizar.disabled     = false
        items.disabled              = false
        bot_agregar.disabled        = false
        bot_eliminar_item.disabled  = false
        bot_limpiar_item.disabled   = false
        checktodos.disabled         = false
        Config_Msg_Accion("Itemes traspasados a TCP",3000,msg_accion_3)
      }
    });
    ajx.request();
  }
  else
    strNum_Lineas=""
}

function Verificar_Check_Tuplas(){
  for(k=1;k<=t_rows;k++) 
  {
    if(eval("document.all.celda_" + k + "_" + C_CHECKBOX).checked==true)
      return true;
  }
  return false;
}

function Ingresar_Items_Productos(){
  if(items.value!="")
  {
    for(k=1;k<=t_rows;k++) 
    {
      if(eval("document.all.celda_" + k + "_" + C_CHECKBOX).checked==true)
      {
        if(confirm("¿Está seguro que desea agregar "+items.value+" línea(s) después del item ("+k+")?"))
        {
          items.disabled              = true
          bot_agregar.disabled        = true
          bot_eliminar_item.disabled  = true
          var ajx = new Ajax("pedidos_productos_grabar.asp",{
            method:'post', 
            async:false,
            data: 'accion=agregar&anio='+anio.value+
            '&numero_interno_pedido='+numero_interno_pedido.value+
            '&numero_pedido='+numero_pedido.value+
            '&numero_linea='+k+
            '&items='+items.value,
            onComplete: function(respuesta){
              //alert(respuesta)
              //msg_return_ajax.innerText=respuesta
              Cargar_Items("EDITAR","")
              items.disabled              = false
              bot_agregar.disabled        = false
              bot_eliminar_item.disabled  = false
              Config_Msg_Accion("Itemes agregados después del item "+k,3000,msg_accion_3)
            }
          });
          ajx.request();
        }
        items.value=""
        return;
      }
      
    }
    Cargar_Items("NUEVO","")
  }
  else  
    Config_Msg_Accion("INGRESE ITEMES...",3000,msg_accion_3)
}

function Cargar_Items(v_accion,v_num_linea){
  strCargando ="<br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Cargando datos...espere un momento</b></font><br><br></center>"
  grilla_productos.innerHTML    = strCargando
  document.body.style.cursor    = "wait"
  grilla_productos.style.cursor = "wait"
  items.disabled        = true
  bot_agregar.disabled  = true
  var ajx = new Ajax("pedidos_productos_grilla.asp",{
    method:'post', 
    data: 'accion='+v_accion+'&anio='+anio.value+
    '&numero_pedido='+numero_pedido.value+
    '&numero_interno_pedido='+numero_interno_pedido.value+
    '&items='+items.value+'&numero_linea='+v_num_linea+
    '&checktodos='+checktodos.checked,
    evalScripts:true,
    update:$("grilla_productos"),
    onComplete: function(respuesta){
      //alert(respuesta)
      items.value           = ""
      items.disabled        = false
      bot_agregar.disabled  = false
      grilla_productos.style.visibility = ""
      
      grilla_productos.style.visibility = "hidden"
      for(i=1;i<=t_rows;i++)
        if(eval("document.all.celda_" + i + "_" + C_PRODUCTO).value=="")
        {
          Bloquea_Celda(i,C_PRODUCTO,false,false)
          Set_Deshabilitar_Celdas_Edicion_Items(i,true)
        }
        else
        {
          if(cant_TCP > 0)
          {
            if(cant_TCP==1)
            {
              //Cant 1
              col_tmp = C_CANT_1
              if(eval("document.all.celda_" + i + "_" + C_TCP_1).value=="")
                Bloquea_Celda(i,col_tmp,true,false)
            }
            if(cant_TCP==2)
            {
              //Cant 2
              col_tmp = C_CANT_2
              if(eval("document.all.celda_" + i + "_" + C_TCP_2).value=="")
                Bloquea_Celda(i,col_tmp,true,false)
            }
            if(cant_TCP==3)
            {
              //Cant 3
              col_tmp = C_CANT_3
              if(eval("document.all.celda_" + i + "_" + C_TCP_3).value=="")
                Bloquea_Celda(i,col_tmp,true,false)
            }
            if(cant_TCP==4)
            {
              //Cant 4
              col_tmp = C_CANT_4
              if(eval("document.all.celda_" + i + "_" + C_TCP_4).value=="")
                Bloquea_Celda(i,col_tmp,true,false)
            }
            if(cant_TCP==5)
            {
              //Cant 5
              col_tmp = C_CANT_5
              if(eval("document.all.celda_" + i + "_" + C_TCP_5).value=="")
                Bloquea_Celda(i,col_tmp,true,false)
              //Cant anulados
            }
            //col_tmp = C_CANT_ANULADOS + cant_TCP * 2
            //Bloquea_Celda(i,col_tmp,false,false)
          }
        }
      grilla_productos.style.visibility = ""      
      if(t_rows > 0)
        bot_verificar_itemes.style.visibility   = ""
      document.body.style.cursor    = "default"
      grilla_productos.style.cursor = "default"
    }
  });
  ajx.request();
}

function Eliminar_Limpiar_Items(v_accion_general){
  if(t_rows>=1)
  {
    if(v_accion_general=="ELIMINAR")
    {
      strNum_Lineas = ""; v_num_linea = ""
      for(i=1;i<=t_rows;i++)
        if(eval("document.all.celda_" + i + "_" + C_CHECKBOX).checked==true)
        {
          v_num_linea = strNum_Lineas+eval("document.all.celda_" + i + "_" + C_ITEMS).value
          break;
        }
      if(v_num_linea=="")
      {
        v_msg         = "¿Está seguro que desea eliminar el último item?"
        v_msg_accion  = "ULTIMO ITEM ELIMINADO..."
        v_num_linea   = eval("document.all.celda_" + t_rows + "_" + C_ITEMS).value
        v_accion      = "eliminar_ultimo"
      }
      else
      {
        v_msg         = "¿Está seguro que desea eliminar el item "+v_num_linea+"?"
        v_msg_accion  = "ITEM ELIMINADO..."
        v_accion      = "eliminar_item"
      }
    }
    else //Limpiar Itemes
    {
      strNum_Lineas = ""
      for(i=1;i<=t_rows;i++)
        if(eval("document.all.celda_" + i + "_" + C_CHECKBOX).checked==true)
        {
          if(strNum_Lineas!="")
            strNum_Lineas     = strNum_Lineas+delimiter
          strNum_Lineas     = strNum_Lineas+eval("document.all.celda_" + i + "_" + C_ITEMS).value
        }
      if(strNum_Lineas=="")
      {
        Config_Msg_Accion("NO SE HAN SELEECCIONADO ITEMES...",3000,msg_accion_3)
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
      items.disabled              = true
      bot_agregar.disabled        = true
      bot_eliminar_item.disabled  = true
      bot_limpiar_item.disabled   = true
      var ajx = new Ajax("pedidos_productos_grabar.asp",{
        method:'post', 
        async:false,
        data: 'accion='+v_accion+
        '&numero_interno_pedido='+numero_interno_pedido.value+
        '&numero_pedido='+numero_pedido.value+
        '&numero_linea='+v_num_linea+
        '&strNum_Lineas='+strNum_Lineas+
        '&items='+items.value,
        onComplete: function(respuesta){
          //msg_return_ajax.innerText=respuesta
          //***************************************************************************************
          //Ocultar el botón información y de Termino de pedido por si cambio algo en la validación de los ítemes
          bot_terminar_pedido.style.visibility            = "hidden"
          bot_informacion_cerrar_pedido.style.visibility  = "hidden"
          //***************************************************************************************
          
          Cargar_Items("EDITAR","")
          items.disabled              = false
          bot_agregar.disabled        = false
          bot_eliminar_item.disabled  = false
          bot_limpiar_item.disabled   = false
          Config_Msg_Accion(v_msg_accion,3000,msg_accion_3)
        }
      });
      ajx.request();
    }
  }
  else
    Config_Msg_Accion("NO SE HAN AGREGADO ITEMES...",3000,msg_accion_3)
}

function SaveChanges(cell, c_row, c_col, c_type, c_name, c_scale, c_maxlength, c_null){
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
  if(c_type == 0) /*number*/
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
  else if(c_type == 2 && c_value!="") /*date*/
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
  c_name1 = "" ; c_value1 = ""; c_name2 = "" ; c_value2 = ""; 
  c_name3 = "" ; c_value3 = ""; c_name4 = "" ; c_value4 = ""; 
  v_producto    = eval("document.all.celda_" + c_row + "_" + C_PRODUCTO).value
  y_col_todos_1 = 0;
  if(checktodos.checked)
    y_col_todos_1 = 1
  if(c_name=="unidad_de_medida_compra" || c_name=="cantidad_mercancias" || c_name=="cantidad_um_compra_en_caja_envase_compra" || c_name=="unidad_de_medida_consumo" || c_name=="cantidad_x_un_consumo")
  {
    if(c_name=="cantidad_mercancias")
    {
      col_tmp     = C_CANT_M
      v_cant_m    = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
      if(v_cant_m==0)
      {
        alert("La cantidades de mercancias debe ser mayor que 0")
        Config_Msg_Accion("LA CANTIDAD DE MERCANCIAS DEBE SER MAYOR QUE 0...",3000,msg_accion_3)
        cell.value = cell.getAttribute("o_value");
        cell.focus();
        return;
      }
    }
    else if(c_name=="unidad_de_medida_compra")
    {
      col_tmp     = C_UN_PEDIDO
      v_un_c      = eval("document.all.celda_" + c_row + "_" + col_tmp).value
      col_tmp     = C_CANT_X_M
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
        
      c_name1             = "cantidad_um_compra_en_caja_envase_compra"
      c_value1            = v_cant_x_m
      
      cell_cant_x_m       = eval("document.all.celda_" + c_row + "_" + col_tmp);
      cell_cant_x_m.value = v_cant_x_m.toString()
      cell_cant_x_m.setAttribute("o_value",v_cant_x_m.toString());
    }
    /*else if(c_name=="unidad_de_medida_consumo")
    {
      col_tmp     = C_UN_VENTA
      v_un_v      = eval("document.all.celda_" + c_row + "_" + col_tmp).value
      v_cant_x_un = 1
      col_tmp     = C_CANT_X_UN
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
      c_name1               = "cantidad_x_un_consumo"
      c_value1              = v_cant_x_un
      
      col_tmp               = C_CANT_X_UN
      cell_cant_x_un        = eval("document.all.celda_" + c_row + "_" + col_tmp);
      cell_cant_x_un.value  = v_cant_x_un.toString()
      cell_cant_x_un.setAttribute("o_value",v_cant_x_un.toString());
    }*/
    
    /*col_tmp     = C_CANT_M
    v_cant_m    = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
    col_tmp     = C_CANT_X_M
    v_cant_x_m  = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
    /*col_tmp     = C_CANT_X_UN
    v_cant_x_un = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
      
    v_cantidad  = 0
    if(v_cant_x_un > 0)
      v_cantidad  = roundNumber(parseFloat(v_cant_m * v_cant_x_m / v_cant_x_un),0)
    if(v_cantidad > 0)
    {
      c_name2             = "cantidad_entrada"
      c_value2            = v_cantidad
      col_tmp             = C_CANT_VENTA
      cell_cantidad       = eval("document.all.celda_" + c_row + "_" + col_tmp);
      cell_cantidad.value = Formateo_Completo_Numero(v_cantidad).toString()
      cell_cantidad.setAttribute("o_value",Formateo_Completo_Numero(v_cantidad).toString());
    }
    */
  }
  /*else if(c_name=="alto" || c_name=="ancho" || c_name=="largo" || c_name=="cantidad_x_caja")
  {
    col_tmp     = C_CANT_VENTA
    v_cantidad  = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
    if(v_cantidad==0)
    {
      alert("La cantidad de venta debe ser mayor que 0")
      Config_Msg_Accion("LA CANTIDAD DE VENTA DEBE SER MAYOR QUE 0...",3000,msg_accion_3)
      cell.value = cell.getAttribute("o_value");
      cell.focus();
      return;
    }
    
    col_tmp       = C_CANT_X_CAJA
    v_cant_x_caja = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
    if(v_cant_x_caja == 0)
    {
      alert("La cantidad por caja debe ser mayor que 0")
      Config_Msg_Accion("LA CANTIDAD POR CAJA DEBE SER MAYOR QUE 0...",3000,msg_accion_3)
      cell.value = cell.getAttribute("o_value");
      cell.focus();
      return;
    }
    col_tmp   = C_ALTO
    v_alto    = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
    col_tmp   = C_ANCHO
    v_ancho   = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
    col_tmp   = C_LARGO
    v_largo   = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
      
    v_volumen = roundNumber( ( (v_alto * v_ancho * v_largo) /1000000) / v_cant_x_caja,6)
      
    col_tmp             = C_VOLUMEN 
    cell_volumen        = eval("document.all.celda_" + c_row + "_" + col_tmp);
    cell_volumen.value  = Formateo_Completo_Numero(v_volumen.toFixed(6)).toString()
    cell_volumen.setAttribute("o_value",Formateo_Completo_Numero(v_volumen.toFixed(6)).toString());
    
    col_tmp       = C_CANT_X_CAJA
    v_cant_x_caja = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
    if(v_cant_x_caja == 0)
    {
      alert("La cantidad por caja debe ser mayor que 0")
      Config_Msg_Accion("LA CANTIDAD POR CAJA DEBE SER MAYOR QUE 0...",3000,msg_accion_3)
      cell.value = cell.getAttribute("o_value");
      cell.focus();
      return;
    }
    col_tmp       = C_PESO_X_CAJA
    v_peso_x_caja = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))  
    v_peso        = roundNumber(v_peso_x_caja/v_cant_x_caja,1)
    c_name3       = "peso"
    c_value3      = v_peso
      
    col_tmp          = C_PESO
    cell_peso        = eval("document.all.celda_" + c_row + "_" + col_tmp);
    cell_peso.value  = Formateo_Completo_Numero(v_peso.toFixed(1)).toString()
    cell_peso.setAttribute("o_value",Formateo_Completo_Numero(v_peso.toFixed(1)).toString());
    
  }*/
  /*else if(c_name=="peso_x_caja")
  {
    col_tmp       = C_CANT_X_CAJA
    v_cant_x_caja = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))
    if(v_cant_x_caja == 0)
    {
      alert("La cantidad por caja debe ser mayor que 0")
      Config_Msg_Accion("LA CANTIDAD POR CAJA DEBE SER MAYOR QUE 0...",3000,msg_accion_3)
      cell.value = cell.getAttribute("o_value");
      cell.focus();
      return;
    }
    col_tmp       = C_PESO_X_CAJA
    v_peso_x_caja = parseFloat(Replace(eval("document.all.celda_" + c_row + "_" + col_tmp).value,",",""))  
    v_peso        = roundNumber(v_peso_x_caja/v_cant_x_caja,1)
    c_name3       = "peso"
    c_value3      = v_peso
      
    col_tmp          = C_PESO
    cell_peso        = eval("document.all.celda_" + c_row + "_" + col_tmp);
    cell_peso.value  = Formateo_Completo_Numero(v_peso.toFixed(1)).toString()
    cell_peso.setAttribute("o_value",Formateo_Completo_Numero(v_peso.toFixed(1)).toString());
  }*/
  v_url           = RutaProyecto+"comprasNEW/pedidos/pedidos_productos_grabar.asp"
  v_num_linea     = eval("document.all.celda_" + c_row + "_" + C_ITEMS).value
  if(nom_tabla=="entidades_comerciales")
    v_url = RutaProyecto+"comprasNEW/compras_proveedor_grabar.asp"
  document.body.style.cursor="wait"  
  var ajx = new Ajax(v_url,{
    method:'post', 
    async:false,
    data: 'accion=actualizar&entidad_comercial='+entidad_comercial.value+
    '&numero_pedido='+numero_pedido.value+
    '&numero_interno_pedido='+numero_interno_pedido.value+
    '&numero_linea='+v_num_linea+
    '&producto='+escape(v_producto)+
    '&tipo_dato='+c_type+
    '&nom_campo='+escape(c_name)+'&valor='+escape(c_value)+
    '&nom_campo1='+escape(c_name1)+'&valor1='+escape(c_value1)+
    '&nom_campo2='+escape(c_name2)+'&valor2='+escape(c_value2)+
    '&nom_campo3='+escape(c_name3)+'&valor3='+escape(c_value3),
    onComplete: function(respuesta){
      //alert(respuesta)
      //msg_return_ajax.innerText=respuesta
      
      if(nom_tabla=="entidades_comerciales")
      {
        cell.value = c_value.toString();
        cell.setAttribute("o_value", c_value.toString());
        Config_Msg_Accion("DATOS ACTUALIZADOS...",3000,msg_accion_2)
      }
      else
      {//Movimientos pedidos
        
        //***************************************************************************************
        //Ocultar el botón información y de Termino de pedido por si cambio algo en la validación de los ítemes
        bot_terminar_pedido.style.visibility            = "hidden"
        bot_informacion_cerrar_pedido.style.visibility  = "hidden"
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
            //v_cant_m              = parseFloat(atributos[2]).toFixed(2)
            v_cant_m              = 0
            v_un_pedido           = atributos[3]
            v_cant_x_m            = atributos[4]
            /*
            v_alto                = parseFloat(atributos[5]).toFixed(1)
            v_ancho               = parseFloat(atributos[6]).toFixed(1)
            v_largo               = parseFloat(atributos[7]).toFixed(1)
            v_volumen             = parseFloat(atributos[8]).toFixed(6)
            v_peso                = parseFloat(atributos[9]).toFixed(2)
            v_cant_x_caja         = atributos[10]
            v_peso_x_caja         = parseFloat(atributos[11]).toFixed(2)
            */
            
            col_tmp                     = C_NOMBRE
            cell_nombre_final           = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_nombre_final.value     = v_nombre_final.toString()
            cell_nombre_final.setAttribute("o_value",v_nombre_final.toString());
            
            col_tmp                     = C_UN_PEDIDO
            cell_un_pedido              = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_un_pedido.value        = v_un_pedido.toString()
            cell_un_pedido.setAttribute("o_value",v_un_pedido.toString());
            
            col_tmp                     = C_CANT_M
            cell_cant_m                 = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_cant_m.value           = v_cant_m.toString()
            cell_cant_m.setAttribute("o_value",v_cant_m.toString());
            
            col_tmp                     = C_CANT_X_M
            cell_cant_x_m                 = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_cant_x_m.value           = v_cant_x_m.toString()
            cell_cant_x_m.setAttribute("o_value",v_cant_x_m.toString());
            Bloquea_Celda(c_row,col_tmp,false,false)
            
            /*
            col_tmp                     = C_UN_VENTA
            v_un_venta                  = "UN"
            cell_un_venta               = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_un_venta.value         = v_un_venta.toString()
            cell_un_venta.setAttribute("o_value",v_un_venta.toString());
            
            col_tmp                     = C_ALTO
            cell_alto                   = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_alto.value             = v_alto.toString()
            cell_alto.setAttribute("o_value",v_alto.toString());
            
            col_tmp               = C_ANCHO
            cell_ancho            = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_ancho.value      = v_ancho.toString()
            cell_ancho.setAttribute("o_value",v_ancho.toString());
            
            col_tmp               = C_LARGO
            cell_largo            = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_largo.value      = v_largo.toString()
            cell_largo.setAttribute("o_value",v_largo.toString());
            
            col_tmp               = C_VOLUMEN
            cell_volumen          = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_volumen.value    = v_volumen.toString()
            cell_volumen.setAttribute("o_value",v_volumen.toString());
            
            col_tmp               = C_PESO
            cell_peso             = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_peso.value       = v_peso.toString()
            cell_peso.setAttribute("o_value",v_peso.toString());
            
            col_tmp                       = C_CANT_X_CAJA
            cell_cant_x_caja              = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_cant_x_caja.value        = v_cant_x_caja.toString()
            cell_cant_x_caja.setAttribute("o_value",v_cant_x_caja.toString());
            
            col_tmp                       = C_PESO_X_CAJA
            cell_peso_x_caja              = eval("document.all.celda_" + c_row + "_" + col_tmp);
            cell_peso_x_caja.value        = v_peso_x_caja.toString()
            cell_peso_x_caja.setAttribute("o_value",v_peso_x_caja.toString());
            */
            
            cell.value = Ucase(c_value.toString());
            cell.setAttribute("o_value", Ucase(c_value.toString()));
            Config_Msg_Accion("DATOS CARGADOS...",3000,msg_accion_3)
                       
            //col_tmp                     = C_NOMBRE
            //cell_nombre_final           = eval("document.all.celda_" + c_row + "_" + col_tmp);
            //cell_nombre_final.focus()
            cell_cant_m.focus()
          }
          else
          {
            Config_Msg_Accion("PRODUCTO NO EXISTE...",3000,msg_accion_3)
            if(confirm("El producto NO existe. ¿Desea crearlo?"))
            {
              OcultarCapa("capaDatosPedido")
              capaNuevoProducto.style.visibility = ""
              capaNuevoProducto.style.zIndex     = 1
              //Cargar familias y subfamilias
              Cargar_Familias(td_familia)
              Cargar_SubFamilias(td_subfamilia)
              hidden_celda_row.value = c_row
              hidden_celda_col.value = C_PRODUCTO
            }
            else
              cell.value = cell.getAttribute("o_value");
          }
        }
        else
        {
          if(c_type==0)
          {
            if(c_scale > 0)
            {
              c_value = roundNumber(c_value,c_scale)
              c_value = c_value.toFixed(c_scale)
            }
            if(parseFloat(c_value)==0 && c_scale>0)
              c_value = parseFloat(c_value).toFixed(c_scale)
            else
              c_value = Formateo_Completo_Numero(c_value)
            cell.value = Ucase(c_value.toString());
            cell.setAttribute("o_value", Ucase(c_value.toString()));
          }
          else
          {
            cell.value = Ucase(c_value.toString());
            cell.setAttribute("o_value", Ucase(c_value.toString()));
          }
          Config_Msg_Accion("DATOS ACTUALIZADOS...",3000,msg_accion_3)
        }
      }
      document.body.style.cursor="default"
    }
  });
  ajx.request();
}

function Bloquea_Celda(v_row,v_col,v_bloquea,v_es_select){
  if(v_es_select)
  {
    if(v_bloquea)
    {
      eval("document.all.celda_" + v_row + "_" + v_col).disabled    = true
      eval("grid_TD_" + v_row + "_" + v_col).style.backgroundColor  = "#EEEEEE"
    }
    else
    {
      eval("document.all.celda_" + v_row + "_" + v_col).disabled    = false
      eval("grid_TD_" + v_row + "_" + v_col).style.backgroundColor  = ""
    }
  }
  else
  {
    if(v_bloquea)
    {
      eval("document.all.celda_" + v_row + "_" + v_col).readOnly              = true
      eval("document.all.celda_" + v_row + "_" + v_col).style.backgroundColor = "#EEEEEE"
      eval("grid_TD_" + v_row + "_" + v_col).style.backgroundColor            = "#EEEEEE"
    }
    else
    {
      eval("document.all.celda_" + v_row + "_" + v_col).readOnly              = false
      eval("document.all.celda_" + v_row + "_" + v_col).style.backgroundColor = ""
      eval("grid_TD_" + v_row + "_" + v_col).style.backgroundColor            = ""
    }
  }
}

function Set_Deshabilitar_Celdas_Edicion_Items(c_row,v_band){
  /*x_col_todos_1 = 0; x_col_todos_2 = 0;
  if(checktodos.checked)
  {
    x_col_todos_1 = 1
    x_col_todos_2 = 2  
  }*/
  
  //Prod Cod prov
  col_tmp = C_PRODUCTO_COD_PROV
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  
  //Unidad pedido
  col_tmp = C_UN_PEDIDO
  Bloquea_Celda(c_row,col_tmp,v_band,true)
  //Cant. M.
  col_tmp = C_CANT_M
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  //Cant. X M.
  col_tmp = C_CANT_X_M
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  
  /*
  //Unidad venta
  col_tmp = C_UN_VENTA
  Bloquea_Celda(c_row,col_tmp,v_band,true)
  //Cant x UN
  col_tmp = C_CANT_X_UN
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  //Alto
  col_tmp = C_ALTO
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  //Ancho
  col_tmp = C_ANCHO
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  //Largo
  col_tmp = C_LARGO
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  //Cantidad X Caja
  col_tmp = C_CANT_X_CAJA
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  //Peso X Caja
  col_tmp = C_PESO_X_CAJA
  Bloquea_Celda(c_row,col_tmp,v_band,false)
  */
  
  if(cant_TCP > 0)
  { 
    if(cant_TCP>=1)
    {
      //Cant 1
      col_tmp = C_CANT_1
      Bloquea_Celda(c_row,col_tmp,v_band,false)
    }
    if(cant_TCP>=2)
    {
      //Cant 2
      col_tmp = C_CANT_2
      Bloquea_Celda(c_row,col_tmp,v_band,false)
    }
    if(cant_TCP>=3)
    {
      //Cant 3
      col_tmp = C_CANT_3
      Bloquea_Celda(c_row,col_tmp,v_band,false)
    }
    if(cant_TCP>=4)
    {
      //Cant 4
      col_tmp = C_CANT_4
      Bloquea_Celda(c_row,col_tmp,v_band,false)
    }
    if(cant_TCP>=5)
    {
      //Cant 5
      col_tmp = C_CANT_5
      Bloquea_Celda(c_row,col_tmp,v_band,false)
    }
    //Cant anulados
    col_tmp = C_CANT_ANULADOS + cant_TCP * 2
    Bloquea_Celda(c_row,col_tmp,v_band,false)
  }
}

//------------------------------------------------------------------------------------
//############################## FUNCIONES PRODUCTO ##################################
//------------------------------------------------------------------------------------

function Cerrar_Nuevo_Producto(){
  v_row = hidden_celda_row.value
  eval("document.all.celda_" + v_row + "_" + C_PRODUCTO).value = ""
  hidden_celda_row.value  = ""
  hidden_celda_col.value  = ""
  capaNuevoProducto.style.visibility  = "hidden"
  capaNuevoProducto.style.zIndex      = -1
  capaDatosPedido.style.visibility    = ""
  capaDatosPedido.style.zIndex        = 1
}

function Crear_Producto(){
  if(Trim(nombre_producto_nuevo.value)=="")
  {
    alert("Ingrese el nombre del nuevo producto!")
    nombre_producto_nuevo.focus()
    return
  }
  else
  {
    if(confirm("Está seguro que desea crear este producto?"))
    {
      strCargando ="<img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' border='0' align='top'>&nbsp;Creando producto..."
      td_creando_producto.innerHTML = strCargando
      superfamilia.disabled               = true
      familia.disabled                    = true
      subfamilia.disabled                 = true
      nombre_producto_nuevo.disabled      = true
      bot_crear_nuevo_producto.disabled   = true
      bot_cerrar_nuevo_producto.disabled  = true
      var ajx = new Ajax(RutaProyecto+"comprasNEW/compras_productos_crear.asp",{
        method:'post', 
        data: 'producto='+producto_nuevo.value+'&nombre='+escape(nombre_producto_nuevo.value)+'&superfamilia='+escape(superfamilia.value)+
        '&familia='+escape(familia.value)+'&subfamilia='+escape(subfamilia.value),
        async:false,
        onComplete: function(respuesta){
          //alert(respuesta)
          if(respuesta!="")
          {
            msg_error = "Ocurrió un error al tratar de crear el producto\n"
            msg_error+= "Información técnica del error:\n"+respuesta+"\n"
            msg_error+= "Consulte con el administrador del sistema"
            td_creando_producto.innerHTML = ""
            alert(msg_error)
            superfamilia.disabled               = false
            nombre_producto_nuevo.disabled      = false
            nombre_producto_nuevo.value         = ""
            bot_crear_nuevo_producto.disabled   = false
            bot_cerrar_nuevo_producto.disabled  = false
            Config_Msg_Accion("SE PRODUJO UN ERROR AL CREAR EL NUEVO PRODUCTO...",3000,msg_accion_3)
            Cerrar_Nuevo_Producto()
          }
          else
          {
            //td_creando_producto.innerHTML=respuesta
            //return;
            v_row = hidden_celda_row.value
            v_col = hidden_celda_col.value
            td_creando_producto.innerHTML = ""
            superfamilia.disabled               = false
            nombre_producto_nuevo.disabled      = false
            nombre_producto_nuevo.value         = ""
            bot_crear_nuevo_producto.disabled   = false
            bot_cerrar_nuevo_producto.disabled  = false
            Config_Msg_Accion("PRODUCTO CREADO...",3000,msg_accion_3)
            Bloquea_Celda(v_row,C_PRODUCTO,true,false)
            Cerrar_Nuevo_Producto()
            v_celda_producto = eval("document.all.celda_" + v_row + "_" + v_col)
            v_celda_producto.value = producto_nuevo.value
            v_celda_producto.focus()
            v_celda_nombre_original = eval("document.all.celda_" + v_row + "_" + C_NOMBRE)
            v_celda_nombre_original.focus()
          }
        }
      });
      ajx.request();  
    }
  }
}

function Cargar_Familias(v_id_td){
  //strCargando ="<img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' border='0' align='top'>"
  //v_id_td.innerHTML = strCargando
  var ajx = new Ajax(RutaProyecto+"comprasNEW/select_familias_x_superfamilia.asp",{
    method:'post', 
    data: 'superfamilia='+escape(superfamilia.value),
    async:false,
    update:$(v_id_td),
    onComplete: function(respuesta){
      //alert(respuesta)
      familia.focus()
    }
  });
  ajx.request();
}

function Cargar_SubFamilias(v_id_td){
  //strCargando ="<img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' border='0' align='top'>"
  //v_id_td.innerHTML = strCargando
  var ajx = new Ajax(RutaProyecto+"comprasNEW/select_subfamilias_x_familia.asp",{
    method:'post', 
    data: 'superfamilia='+escape(superfamilia.value)+'&familia='+escape(familia.value),
    async:false,
    update:$(v_id_td),
    onComplete: function(respuesta){
      //alert(respuesta)
      Get_Nuevo_Codigo(superfamilia.value,familia.value,subfamilia.value)
    }
  });
  ajx.request();
}

function Get_Nuevo_Codigo(v_superfamilia,v_familia,v_subfamilia){
  //strCargando ="<img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' border='0' align='top'>"
  //v_id_td.innerHTML = strCargando
  var ajx = new Ajax(RutaProyecto+"comprasNEW/Get_Nuevo_Producto.asp",{
    method:'post', 
    data: 'superfamilia='+escape(v_superfamilia)+'&familia='+escape(v_familia)+'&subfamilia='+escape(v_subfamilia),
    async:false,
    onComplete: function(respuesta){
      //alert(respuesta)
      v_a_producto_nuevo          = respuesta.split("~")
      producto_nuevo.value        = v_a_producto_nuevo[0]
      nombre_producto_nuevo.value = v_a_producto_nuevo[1]
    }
  });
  ajx.request();
}