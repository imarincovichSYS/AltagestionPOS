
// $(document).ready( function()
// function Cargar_Form_Buscar()
// function Listar_Carpetas()
// function Cancelar_Busqueda_Carpeta()
// function Cargar_Form_Ingresar(v_num_carpeta)
// function Actualizar_Datos_Generales(v_object)
// function Cargar_Form_Ingresar_Form_Ingreso(v_numero_linea)
// function Cargar_AutoCompleteProveedores()
// function Agregar_Factura()
// function Actualizar_Factura()
// function Listar_Carpetas_Detalle()
// function Cerrar_Form_Ingreso()
// function Calcular_Monto_Total_USD()
// function Calcular_Porcentaje_Prorrateo()
// function Eliminar_Factura(v_numero_linea)

$(document).ready( function(){ 
  Cargar_Form_Buscar("R", $("#anio_actual").val(), $("#mes_actual").val());
});

function Cargar_Form_Buscar(v_documento_respaldo, v_anio, v_mes){
  $.ajax({
    url     : "carpetas_form_buscar.asp",
    data    : "",
    type    : "POST",
    async   : true,
    dataType: "html",
    success : function(html){
      $("#td_form").html(html);
      
      $("#documento_respaldo").val(v_documento_respaldo);
      $("#anio").val(v_anio);
      $("#mes").val(v_mes);
      
      $("#documento_respaldo").change(function(){Listar_Carpetas();});
      $("#mes").change(function(){Listar_Carpetas();});
      $("#anio").change(function(){Listar_Carpetas();});
      
      $("#bot_buscar").click(function(){Listar_Carpetas();});
      $("#bot_nuevo").click(function(){Agregar_Carpeta();});
      
      Listar_Carpetas();
    },
    error: function(html){
      $("#td_form").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al buscar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
    }
  });
}

function Listar_Carpetas(){
  v_textoCargando     = "Listando carpetas"
  strCargando ="<br><center><img src=' "+ RutaProyecto + "imagenes/new_loader_000000_9B9DAA.gif' width=30 height=30 "
  strCargando+="border='0' align='top'><br><br><font color='#222222'><b>"+v_textoCargando+"...espere un momento</b></font></center>"
  $("#td_lista").html(strCargando);
  $.ajax({
    url     : "carpetas_form_buscar_listar.asp",
    data    : "documento_respaldo=" + $("#documento_respaldo").val() +
              "&mes="               + $("#mes").val() +
              "&anio="              + $("#anio").val() +
              "&num_carpeta="       + $("#num_carpeta").val(),
    type    : "POST",
    async   : true,
    dataType: "html",
    success : function(html){
      $("#td_lista").html(html);
    },
    error: function(html){
      $("#td_lista").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al buscar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
    }
  });
}

function Cancelar_Busqueda_Carpeta(){
  $("#documento_respaldo").attr("disabled",false);
  $("#num_carpeta").val()  = ""
  $("#num_carpeta").attr("disabled",false);
  $("#num_carpeta").css("background-color","");
  $("#anio").attr("disabled",false);
  $("#banio").css("background-color","");
  $("#mes").attr("disabled",false);
  $("#mes").css("background-color","");
  
  $("#bot_buscar").attr("disabled",false);
  $("#bot_nuevo").attr("disabled",false);
}

function Cargar_Form_Ingresar(v_num_carpeta){
  $.ajax({
    url     : "carpetas_form_ingresar.asp",
    data    : "documento_respaldo="  + $("#documento_respaldo").val() +
              "&anio="                + $("#anio").val()              +
              "&mes="                 + $("#mes").val()               +
              "&num_carpeta="         + v_num_carpeta,
    type    : "POST",
    async   : true,
    dataType: "html",
    success : function(html){
      $("#td_form").html(html);
      
      $("#label_volver").css("title","Volver al listado de carpetas");
      $("#label_volver").on({
        mouseover: function(){
          $(this).css("cursor","pointer");
          $(this).css("background-color","#828282");
        },
        mouseout: function(){
          $(this).css("background-color","#626262");
        },
        click: function(){
          Cargar_Form_Buscar($("#documento_respaldo").val(), $("#anio").val(), $("#mes").val());
        }
      });
      
      $("#id_origen").change(function(){Actualizar_Datos_Generales($(this));});
      $("#id_transporte").change(function(){Actualizar_Datos_Generales($(this));});
      $("#id_embarcador").change(function(){Actualizar_Datos_Generales($(this));});
      
      $("#fecha_salida").datepicker({
        dateFormat      : "dd-mm-yy",
        //maxDate         : "+1d",
        minDate         : "-60d",
        onSelect: function(selectedDate){Actualizar_Datos_Generales($(this));}
      });
      
      $("#fecha_llegada").datepicker({
        dateFormat      : "dd-mm-yy",
        //maxDate         : "+1d",
        minDate         : "-60d",
        onSelect: function(selectedDate){Actualizar_Datos_Generales($(this));}
      });
      $("#manifiesto").blur(function(){Actualizar_Datos_Generales($(this));});
      
      $("#label_agregar_factura").css("title","Agregar factura");
      $("#label_agregar_factura").on({
        mouseover: function(){
          $(this).css("cursor","pointer");
          $(this).css("background-color","#60B060");
        },
        mouseout: function(){
          $(this).css("background-color","#51A351");
        },
        click: function(){
          Agregar_Factura();
        }
      });
      
      Listar_Carpetas_Detalle();
    },
    error: function(html){
      $("#td_form").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al buscar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
    }
  });
}

function Actualizar_Datos_Generales(v_object){
  v_tipo_dato = v_object.attr("tipo_dato");
  v_nom_campo = v_object.attr("name");
  v_o_value   = v_object.attr("o_value");
  v_valor     = v_object.val();
  if(v_valor!=v_o_value)
  {
    $.ajax({
      url       : "carpetas_grabar.asp",
      data      : "accion=update"         +
                  "&documento_respaldo="  + $("#documento_respaldo").val()  +
                  "&anio="                + $("#anio").val()                +
                  "&mes="                 + $("#mes").val()                 +
                  "&num_carpeta="         + $("#num_carpeta").val()         +
                  "&nom_campo="           + v_nom_campo                     + 
                  "&valor="               + escape(v_valor)                 + 
                  "&tipo_dato="           + v_tipo_dato, 
      type      : "post", 
      async     : true,
      dataType  : "json",
      success   : function(data){
        //console.log(data.accion);
        //console.log(data.valor);
        v_object.attr("o_value",v_valor)
        $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#009933; background-color: #EEEEEE;'>Datos actualizados correctamente...</label></b></center>");
        setTimeout(function(){$("#label_msg").fadeOut(2000);}, 3000);
      },
      error: function(html){
        $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>Ha ocurrido un error al actualizar los datos.</label></b></center>");
        setTimeout(function(){$("#label_msg").fadeOut(2000);}, 5000);
      }
    });
  }
}

function Cargar_Form_Ingresar_Form_Ingreso(v_numero_linea){
  $.ajax({
    url     : "carpetas_form_ingresar_form_ingreso.asp",
    data    : "documento_respaldo=" + $("#documento_respaldo").val()  +
              "&anio="              + $("#anio").val()                +
              "&mes="               + $("#mes").val()                 +
              "&num_carpeta="       + $("#num_carpeta").val()         +
              "&numero_linea="      + v_numero_linea, 
    type    : "POST",
    async   : true,
    dataType: "html",
    success : function(html){
      $("#td_form_ingreso").html(html);
      Cargar_AutoCompleteProveedores();
      
      $("#label_actualizar").css("title","Actualizar datos");
      $("#label_actualizar").on({
        mouseover: function(){
          $(this).css("cursor","pointer");
          $(this).css("background-color","#60B060");
        },
        mouseout: function(){
          $(this).css("background-color","#51A351");
        },
        click: function(){
          Actualizar_Factura();
        }
      });
      
      $("#label_cancelar").css("title","Cancelar");
      $("#label_cancelar").on({
        mouseover: function(){
          $(this).css("cursor","pointer");
          $(this).css("background-color","#828282");
        },
        mouseout: function(){
          $(this).css("background-color","#626262");
        },
        click: function(){
          Cerrar_Form_Ingreso();
        }
      });
      
      $("#monto_moneda_origen").on({
        blur: function(){
          Calcular_Monto_Total_USD();
          Calcular_Porcentaje_Prorrateo();
        },
        focus: function(){
          $(this).select();
        },
        keypress: function(event){
          var v_keycode = (event.keyCode ? event.keyCode : event.which);
          if(v_keycode == "13")
            $("#paridad").focus();
        }
      });
      
      $("#paridad").on({
        blur: function(){
          Calcular_Monto_Total_USD();
          Calcular_Porcentaje_Prorrateo();
        },
        focus: function(){
          $(this).select();
        },
        keypress: function(event){
          var v_keycode = (event.keyCode ? event.keyCode : event.which);
          if(v_keycode == "13")
            $("#monto_final_usd").focus();
        }
      });
      
      $("#monto_final_usd").on({
        blur: function(){
          Calcular_Monto_Total_USD();
          Calcular_Porcentaje_Prorrateo();
        },
        focus: function(){
          $(this).select();
        },
        keypress: function(event){
          var v_keycode = (event.keyCode ? event.keyCode : event.which);
          if(v_keycode == "13")
            $("#porcentaje_prorrateo").focus();
        }
      });
    },
    error: function(html){
      $("#td_form_ingreso").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al buscar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
    }
  });
}

function Cargar_AutoCompleteProveedores(){
  $("#buscar_proveedor").autocomplete({
    minLength: 0,
    source: arrayJsonProveedores,
    focus: function( event, ui ) {
      $("#buscar_proveedor").val( ui.item.label );
      $("#entidad_comercial").val( ui.item.value );
      return false;
    },
    select: function( event, ui ) {
      $("#buscar_proveedor").val( ui.item.label );
      $("#entidad_comercial").val( ui.item.value );
      return false;
    },
    close: function( event, ui ) {
      //Set_Proveedor_en_Form($("#buscar_entidad_comercial").val(), $("#buscar_nombre").val());
    }
  })
  .data("ui-autocomplete")._renderItem = function( ul, item ) {
    return $( "<li style='font-size:9px;'>" )
      //.append( "<a>" + item.label + "<br>" + item.desc + "</a>" )
      .append( "<a>" + item.label + "</a>" )
      .appendTo( ul );
  };
}

function Agregar_Factura(){
  if(confirm("¿Está seguro que desea agregar una factura a la carpeta?"))
  {
    $.ajax({
      url       : "carpetas_grabar_detalle.asp",
      data      : "accion=insert"         +
                  "&documento_respaldo="  + $("#documento_respaldo").val()  +
                  "&anio="                + $("#anio").val()                +
                  "&mes="                 + $("#mes").val()                 +
                  "&num_carpeta="         + $("#num_carpeta").val(), 
      type      : "post", 
      async     : true,
      dataType  : "json",
      success   : function(data){
        //console.log(data.accion);
        //console.log(data.valor);
        x_numero_linea = data.valor;
        
        $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#009933; background-color: #EEEEEE;'>Factura agregada correctamente...</label></b></center>");
        setTimeout(function(){$("#label_msg").fadeOut(2000);}, 3000);
        
        Listar_Carpetas_Detalle();
        Cargar_Form_Ingresar_Form_Ingreso(x_numero_linea);
      },
      error: function(html){
        $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>Ha ocurrido un error al actualizar los datos.</label></b></center>");
        setTimeout(function(){$("#label_msg").fadeOut(2000);}, 5000);
      }
    });
  }
}

function Actualizar_Factura(){
  //Validaciones
  str_msg_error = ""
  if($("#entidad_comercial").val() == "")
    str_msg_error = "Ingrese proveedor"
  else if($("#numero_factura").val() == "")
    str_msg_error = "Ingrese n° factura"
  else if($("#monto_moneda_origen").val() == "")
    str_msg_error = "Ingrese monto moneda origen"
  else if($("#paridad").val() == "")
    str_msg_error = "Ingrese monto moneda origen"
  else if($("#monto_final_usd").val() == "")
    str_msg_error = "Ingrese monto moneda origen"
  else if(parseFloat($("#monto_total_usd").val()) == 0)
    str_msg_error = "Ingrese monto moneda origen"
  if(str_msg_error != "")
  {
    $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000;'>" + str_msg_error + "</label></b></center>");
    setTimeout(function(){$("#label_msg").fadeOut(2000);}, 5000);
    return false;
  }
  if(confirm("¿Está seguro que desea actualizar los datos de esta factura?"))
  {
    $.ajax({
      url       : "carpetas_grabar_detalle.asp",
      data      : "accion=update"           +
                  "&documento_respaldo="    + $("#documento_respaldo").val()      +
                  "&anio="                  + $("#anio").val()                    +
                  "&mes="                   + $("#mes").val()                     +
                  "&num_carpeta="           + $("#num_carpeta").val()             +
                  "&numero_linea="          + $("#numero_linea").val()            +
                  "&entidad_comercial="     + $("#entidad_comercial").val()       +
                  "&id_tipo_factura="       + $("#id_tipo_factura").val()         +
                  "&numero_factura="        + escape($("#numero_factura").val())  +
                  "&tipo_moneda="           + escape($("#tipo_moneda").val())     +
                  "&monto_moneda_origen="   + $("#monto_moneda_origen").val()     +
                  "&paridad="               + $("#paridad").val()   +
                  "&monto_total_usd="       + $("#monto_total_usd").val()         +
                  "&monto_final_usd="       + $("#monto_final_usd").val()         +
                  "&porcentaje_prorrateo="  + $("#porcentaje_prorrateo").val(), 
      type      : "post", 
      async     : true,
      dataType  : "json",
      success   : function(data){
        //console.log(data.accion);
        //console.log(data.valor);
        $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#009933; background-color: #EEEEEE;'>Datos actualizados correctamente...</label></b></center>");
        setTimeout(function(){$("#label_msg").fadeOut(2000);}, 3000);
        
        Cerrar_Form_Ingreso();
        Listar_Carpetas_Detalle();
      },
      error: function(html){
        $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>Ha ocurrido un error al actualizar los datos.</label></b></center>");
        setTimeout(function(){$("#label_msg").fadeOut(2000);}, 5000);
      }
    });
  }
}

function Listar_Carpetas_Detalle(){
  $.ajax({
    url     : "carpetas_form_ingresar_listar.asp",
    data    : "documento_respaldo=" + $("#documento_respaldo").val()  +
              "&anio="              + $("#anio").val()                +
              "&mes="               + $("#mes").val()                 +
              "&num_carpeta="       + $("#num_carpeta").val(),
    type    : "POST",
    async   : true,
    dataType: "html",
    success : function(html){
      $("#td_lista").html(html);
    },
    error: function(html){
      $("#td_lista").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al buscar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
    }
  });
}

function Cerrar_Form_Ingreso(){
  $("#td_form_ingreso").html("");
}

function Calcular_Monto_Total_USD(){
  if($("#monto_moneda_origen").val() == "")
    $("#monto_moneda_origen").val("0.00")
  if($("#paridad").val() == "")
    $("#paridad").val("0.00")
  v_monto_moneda_origen = $("#monto_moneda_origen").val().replace(/\,/g,".");
  v_paridad = $("#paridad").val().replace(/\,/g,".");
  v_monto_total_usd = roundNumber(parseFloat(v_monto_moneda_origen) * parseFloat(v_paridad) , 2);
  
  $("#monto_moneda_origen").val(roundNumber(v_monto_moneda_origen,2).toFixed(2));
  $("#paridad").val(roundNumber(v_paridad,2).toFixed(2));
  $("#monto_total_usd").val(v_monto_total_usd.toFixed(2));
}

function Calcular_Porcentaje_Prorrateo(){
  v_monto_total_usd = $("#monto_total_usd").val().replace(/\,/g,".");;
  if($("#monto_final_usd").val() == "")
    $("#monto_final_usd").val(v_monto_total_usd.toFixed(2));
  v_monto_final_usd = $("#monto_final_usd").val().replace(/\,/g,".");;
  if(parseFloat(v_monto_final_usd) > parseFloat(v_monto_total_usd))
    $("#monto_final_usd").val(v_monto_total_usd.toFixed(2));
  v_monto_final_usd = $("#monto_final_usd").val().replace(/\,/g,".");;
  $("#monto_final_usd").val(roundNumber(v_monto_final_usd,2).toFixed(2));
  
  if(parseFloat(v_monto_total_usd) == 0)
    $("#porcentaje_prorrateo").val("0.00");
  else
    $("#porcentaje_prorrateo").val((roundNumber(parseFloat(v_monto_final_usd) / parseFloat(v_monto_total_usd),2) * 100).toFixed(2));
}

function Eliminar_Factura(v_numero_linea){
  Cerrar_Form_Ingreso();
  if(confirm("¿Está seguro que desea eliminar esta factura?"))
  {
    $.ajax({
      url       : "carpetas_grabar_detalle.asp",
      data      : "accion=delete"         +
                  "&documento_respaldo="  + $("#documento_respaldo").val()  +
                  "&anio="                + $("#anio").val()                +
                  "&mes="                 + $("#mes").val()                 +
                  "&num_carpeta="         + $("#num_carpeta").val()         +
                  "&numero_linea="        + v_numero_linea, 
      type      : "post", 
      async     : true,
      dataType  : "json",
      success   : function(data){
        //console.log(data.accion);
        //console.log(data.valor);
        $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#009933; background-color: #EEEEEE;'>Factura eliminada correctamente...</label></b></center>");
        setTimeout(function(){$("#label_msg").fadeOut(2000);}, 3000);  
        Listar_Carpetas_Detalle();
      },
      error: function(html){
        $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>Ha ocurrido un error al actualizar los datos.</label></b></center>");
        setTimeout(function(){$("#label_msg").fadeOut(2000);}, 5000);
      }
    });
  }
}

function Agregar_Carpeta(){
  if(confirm("¿Está seguro que desea crear una nueva carpeta?"))
  {
    $.ajax({
      url       : "carpetas_grabar.asp",
      data      : "accion=insert"         +
                  "&documento_respaldo="  + $("#documento_respaldo").val()  +
                  "&anio="                + $("#anio").val()                +
                  "&mes="                 + $("#mes").val(), 
      type      : "post", 
      async     : true,
      dataType  : "json",
      success   : function(data){
        //console.log(data.accion);
        //console.log(data.valor);
        x_num_carpeta = data.valor;
        $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#009933; background-color: #EEEEEE;'>Carpeta creada correctamente...</label></b></center>");
        setTimeout(function(){$("#label_msg").fadeOut(2000);}, 3000);
        Cargar_Form_Ingresar(x_num_carpeta);
      },
      error: function(html){
        $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>Ha ocurrido un error al actualizar los datos.</label></b></center>");
        setTimeout(function(){$("#label_msg").fadeOut(2000);}, 5000);
      }
    });
  }
}