//------------------------------------------------------------------------------------
//############################## FUNCIONES PRODUCTO ##################################
//------------------------------------------------------------------------------------
function Config_Msg_Accion(str_Msg_Accion,v_tiempo,id_msg_accion){
  id_msg_accion.innerHTML = str_Msg_Accion
  //if(id_msg_accion.name=="msg_accion_3")
  //  setTimeout("$('msg_accion_3').innerHTML=''",v_tiempo);
}

function Crear_Producto(){
  band_requiere_ILA = false
  if($("tr_porcentaje_impuesto_1").style.visibility != "hidden")
    band_requiere_ILA = true

  if(Trim(nombre_producto_nuevo.value)=="")
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
      $("td_creando_producto").innerHTML                  = strCargando
      $("superfamilia").disabled                          = true
      $("familia").disabled                               = true
      $("subfamilia").disabled                            = true
      $("nombre_producto_nuevo").disabled                 = true
      $("bot_crear_nuevo_producto").disabled              = true
      
      $("marca").disabled                                 = true
      $("temporada").disabled                             = true
      $("unidad_de_medida_venta_peso_en_grs").disabled    = true
      $("unidad_de_medida_venta_volumen_en_cc").disabled  = true
      $("porcentaje_impuesto_1").disabled                 = true
      
      v_producto_nuevo      = $("producto_nuevo").value
      v_nom_producto_nuevo  = $("nombre_producto_nuevo").value
      v_nom_producto_nuevo  = v_nom_producto_nuevo.replace(/[+]/gi,"§")
      
      var ajx = new Ajax(RutaProyecto+"comprasNEW/compras_productos_crear.asp",{
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
          }
          else
          {
            Get_Nuevo_Codigo($("superfamilia").value,$("familia").value,$("subfamilia").value)
            Config_Msg_Accion("Producto <b>" + v_producto_nuevo + "</b> creado correctamente...",3000,$("msg_accion_3"))
          }
        }
      });
      ajx.request();  
    }
  }
}

function Cargar_Familias(v_id_td){
  $("bot_crear_nuevo_producto").style.visibility = "hidden"
  var ajx = new Ajax(RutaProyecto+"comprasNEW/select_familias_x_superfamilia.asp",{
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
  var ajx = new Ajax(RutaProyecto+"comprasNEW/select_subfamilias_x_familia.asp",{
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
  var ajx = new Ajax(RutaProyecto+"comprasNEW/Get_Nuevo_Producto.asp",{
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
  var ajx = new Ajax(RutaProyecto+"comprasNEW/estructura_requiere_ILA.asp",{
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