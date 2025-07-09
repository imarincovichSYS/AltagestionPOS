//------------------------------------------------------------------------------------
//############################## FUNCIONES PRODUCTO ##################################
//------------------------------------------------------------------------------------
function Config_Msg_Accion(str_Msg_Accion,v_tiempo,id_msg_accion){
  id_msg_accion.innerText = str_Msg_Accion
  if(id_msg_accion.name=="msg_accion_1")
    setTimeout("msg_accion_1.innerText=''",v_tiempo);
  else if(id_msg_accion.name=="msg_accion_2")
    setTimeout("msg_accion_2.innerText=''",v_tiempo);
  else if(id_msg_accion.name=="msg_accion_3")
    setTimeout("msg_accion_3.innerText=''",v_tiempo);
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
      var ajx = new Ajax(RutaProyecto+"compras/compras_productos_crear.asp",{
        method:'post', 
        data: 'producto='+producto_nuevo.value+'&nombre='+encodeURIComponent(nombre_producto_nuevo.value)+'&superfamilia='+escape(superfamilia.value)+
        '&familia='+escape(familia.value)+'&subfamilia='+escape(subfamilia.value),
        async:false,
        onComplete: function(respuesta){
          //alert(respuesta)
          //return
          if(respuesta!="")
          {
            msg_error = "Ocurrió un error al tratar de crear el producto\n"
            msg_error+= "Información técnica del error:\n"+respuesta+"\n"
            msg_error+= "Consulte con el administrador del sistema"
            td_creando_producto.innerHTML = ""
            alert(msg_error)
            superfamilia.disabled               = false
            familia.disabled                    = false
            subfamilia.disabled                 = false
            nombre_producto_nuevo.disabled      = false
            nombre_producto_nuevo.value         = ""
            bot_crear_nuevo_producto.disabled   = false
            Config_Msg_Accion("SE PRODUJO UN ERROR AL CREAR EL NUEVO PRODUCTO...",3000,msg_accion_3)
          }
          else
          {
            //td_creando_producto.innerHTML=respuesta
            //return;
            td_creando_producto.innerHTML       = ""
            superfamilia.disabled               = false
            familia.disabled                    = false
            subfamilia.disabled                 = false
            nombre_producto_nuevo.disabled      = false
            nombre_producto_nuevo.value         = ""
            bot_crear_nuevo_producto.disabled   = false
            Get_Nuevo_Codigo(superfamilia.value,familia.value,subfamilia.value)
            Config_Msg_Accion("PRODUCTO CREADO...",3000,msg_accion_3)
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
  var ajx = new Ajax(RutaProyecto+"compras/select_familias_x_superfamilia.asp",{
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
  var ajx = new Ajax(RutaProyecto+"compras/select_subfamilias_x_familia.asp",{
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
  var ajx = new Ajax(RutaProyecto+"compras/Get_Nuevo_Producto.asp",{
    method:'post', 
    data: 'superfamilia='+escape(v_superfamilia)+'&familia='+escape(v_familia)+'&subfamilia='+escape(v_subfamilia),
    async:false,
    onComplete: function(respuesta){
      //alert(respuesta)
      //td_creando_producto.innerHTML = respuesta
      v_a_producto_nuevo          = respuesta.split("~")
      producto_nuevo.value        = v_a_producto_nuevo[0]
      nombre_producto_nuevo.value = v_a_producto_nuevo[1]
    }
  });
  ajx.request();
}