// $(document).ready( function()
// function Cargar_Form_Buscar()
// function Listar_Carpetas()
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

var ftop
var fleft
var fwidth
var fheight

var ltop
var lleft
var lwidth
var lheight

var itop
var ileft
var iwidth
var iheight

$(document).ready(function () {
    //alert(document.body.clientWidth);
    //alert(document.body.clientHeight);
    //$('#table_enc').attr('width', document.body.clientWidth - 20);
    $('#table_enc').attr('width', 1480);
    Cargar_Form_Buscar("R", $("#anio_actual").val(), $("#mes_actual").val());
});

function Cargar_Form_Buscar(v_documento_respaldo, v_anio, v_mes){
    $.ajax({
        url: "carpetas_form_buscar.asp",
        data: "",
        type: "POST",
        async: true,
        dataType: "html",
        success: function (html) {
            $("#td_form").html(html);

            $("#documento_respaldo").val(v_documento_respaldo);
            $("#anio").val(v_anio);
            $("#mes").val(v_mes);

            $("#documento_respaldo").change(function () { Listar_Carpetas(); });
            $("#mes").change(function () { Listar_Carpetas(); });
            $("#anio").change(function () { Listar_Carpetas(); });

            $("#bot_buscar").click(function () { Listar_Carpetas(); });
            $("#bot_nuevo").click(function () { Agregar_Carpeta(); });

            Listar_Carpetas();
        },
        error: function (html) {
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

function Cargar_Form_Ingresar(v_num_carpeta, v_numero_documento_respaldo) {
    if (v_numero_documento_respaldo == undefined) { v_numero_documento_respaldo = ""; }
    $.ajax({
        url: "carpetas_form_ingresar.asp",
        data: "documento_respaldo=" + $("#documento_respaldo").val() +
              "&anio=" + $("#anio").val() +
              "&mes=" + $("#mes").val() +
              "&num_carpeta=" + v_num_carpeta +
              "&numero_documento_respaldo=" + v_numero_documento_respaldo,
        type: "POST",
        async: true,
        dataType: "html",
        success: function (html) {
            $("#td_form").html(html);

            $("#label_ico").on({
                mouseover: function () {
                    $(this).css("cursor", "pointer");
                    $(this).css("background-color", "#828282");
                },
                mouseout: function () {
                    $(this).css("background-color", "#626262");
                },
                click: function () {
                    //validarEstados();
                    validarFechas();
                }
            });


            $("#label_volver").css("title", "Volver al listado de carpetas");
            $("#label_volver").on({
                mouseover: function () {
                    $(this).css("cursor", "pointer");
                    $(this).css("background-color", "#828282");
                },
                mouseout: function () {
                    $(this).css("background-color", "#626262");
                },
                click: function () {
                    Cargar_Form_Buscar($("#documento_respaldo").val(), $("#anio").val(), $("#mes").val());
                }
            });

            $("#id_origen").change(function () { Actualizar_Datos_Generales($(this)); });
            $("#id_transporte").change(function () {
                Actualizar_Datos_Generales($(this));
                if (this.value == 2) {
                    $("#TD_fecha_sanantonio").css("display", "block");
                    $("#TD_fecha_transbordo").css("display", "block");
                }
                else {
                    $("#TD_fecha_sanantonio").css("display", "none");
                    $("#TD_fecha_transbordo").css("display", "none");
                }
            });
            $("#manifiesto").blur(function () { Actualizar_Datos_Generales($(this)); });
            $("#id_embarcador").change(function () { Actualizar_Datos_Generales($(this)); });
            $("#id_puerto").change(function () { Actualizar_Datos_Generales($(this)); });
            $("#id_estado").change(function () { Actualizar_Datos_Generales($(this)); });
            $("#Numero_aduana").change(function () { Actualizar_Datos_Generales($(this)); });
            $("#NDP").change(function () { Actualizar_Datos_Generales($(this)); });

            $("#CamionPatente").change(function () { Actualizar_Datos_Generales($(this)); });
            $("#CamionAlto").change(function () { Actualizar_Datos_Generales($(this)); });
            $("#CamionAncho").change(function () { Actualizar_Datos_Generales($(this)); });
            $("#CamionLargo").change(function () { Actualizar_Datos_Generales($(this)); });
            $("#CamionChofer").change(function () { Actualizar_Datos_Generales($(this)); });

            $("#Factor_recibir").blur(function () { Actualizar_Datos_Generales($(this)); });
			
            if (false) {
                $("#fecha_salida").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate: "+1d",
                    minDate: "-120d",
                    onSelect: function (selectedDate) { Actualizar_Datos_Generales($(this)); }
                });
                $("#fecha_sanantonio").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate: "+1d",
                    minDate: "-120d",
                    onSelect: function (selectedDate) { Actualizar_Datos_Generales($(this)); }
                });
                $("#fecha_transbordo").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate: "+1d",
                    minDate: "-120d",
                    onSelect: function (selectedDate) { Actualizar_Datos_Generales($(this)); }
                });
                $("#fecha_ptaarenas").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate: "+1d",
                    minDate: "-120d",
                    onSelect: function (selectedDate) { Actualizar_Datos_Generales($(this)); }
                });
                $("#fecha_aduana").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate: "+1d",
                    minDate: "-120d",
                    onSelect: function (selectedDate) { Actualizar_Datos_Generales($(this)); Actualiza_Estado(); }
                });
                $("#fecha_llegada").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate: "+1d",
                    minDate: "-120d",
                    onSelect: function (selectedDate) { Actualizar_Datos_Generales($(this)); }
                });
                $("#fecha_recepcion").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate: "+1d",
                    minDate: "-120d",
                    onSelect: function (selectedDate) {
                        Actualizar_Datos_Generales($(this));
                        Actualiza_Estado();
                    }
                });
                $("#fecha_grabacion").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate: "+1d",
                    minDate: "-120d",
                    onSelect: function (selectedDate) { Actualizar_Datos_Generales($(this)); Actualiza_Estado(); }
                });
                $("#fecha_guia").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate: "+1d",
                    minDate: "-120d",
                    onSelect: function (selectedDate) { Actualizar_Datos_Generales($(this)); }
                });
            }
            else {
                $("#fecha_salida").on({
                    blur: function () {
                        if (CompletarFecha(this) !== undefined) { Actualizar_Datos_Generales($(this)); }
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }

                    }
                });
                $("#fecha_sanantonio").on({
                    blur: function () {
                        if (CompletarFecha(this) !== undefined) { Actualizar_Datos_Generales($(this)); }
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }

                    }
                });
                $("#fecha_transbordo").on({
                    blur: function () {
                        if (CompletarFecha(this) !== undefined) { Actualizar_Datos_Generales($(this)); }
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }

                    }
                });
                $("#fecha_ptaarenas").on({
                    blur: function () {
                        if (CompletarFecha(this) !== undefined) { Actualizar_Datos_Generales($(this)); }
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }

                    }
                });
                $("#fecha_aduana").on({
                    blur: function () {
                        if (CompletarFecha(this) !== undefined) { Actualizar_Datos_Generales($(this)); }
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }

                    }
                });
                $("#fecha_llegada").on({
                    blur: function () {
                        if (CompletarFecha(this) !== undefined) {
                            if (validarFechas(this) == true) { Actualizar_Datos_Generales($(this));}
                        }
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }
                    }
                });
                $("#fecha_recepcion").on({
                    blur: function () {
                        if (CompletarFecha(this) !== undefined) {
                            if (validarFechas(this) == true) {
                                Actualizar_Datos_Generales($(this));
                                $("#fecha_llegada").val(this.value);
                                Actualizar_Datos_Generales($("#fecha_llegada"));
                            }
                        }
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }

                    }
                });
                $("#fecha_grabacion").on({
                    blur: function () {
                        if (CompletarFecha(this) !== undefined) { Actualizar_Datos_Generales($(this)); }
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }

                    }
                });
                $("#fecha_guia").on({
                    blur: function () {
                        if (CompletarFecha(this) !== undefined) { Actualizar_Datos_Generales($(this)); }
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }

                    }
                });
            }


            if ($("#documento_respaldo").val() != "Z") {
                $("#TD_fecha_aduana").css("display", "none");
            }

            $("#label_agregar_factura").css("title", "Agregar factura");
            $("#label_agregar_factura").on({
                mouseover: function () {
                    $(this).css("cursor", "pointer");
                    $(this).css("background-color", "#60B060");
                },
                mouseout: function () {
                    $(this).css("background-color", "#51A351");
                },
                click: function () {
                    Agregar_Factura();
                }
            });

            f = $("#fecha_salida").val(); if (f == "01-01-1900") { $("#fecha_salida").val(""); }
            f = $("#fecha_sanantonio").val(); if (f == "01-01-1900") { $("#fecha_sanantonio").val(""); }
            f = $("#fecha_transbordo").val(); if (f == "01-01-1900") { $("#fecha_transbordo").val(""); }
            f = $("#fecha_ptaarenas").val(); if (f == "01-01-1900") { $("#fecha_ptaarenas").val(""); }
            f = $("#fecha_aduana").val(); if (f == "01-01-1900") { $("#fecha_aduana").val(""); }
            f = $("#fecha_llegada").val(); if (f == "01-01-1900") { $("#fecha_llegada").val(""); }
            f = $("#fecha_recepcion").val(); if (f == "01-01-1900") { $("#fecha_recepcion").val(""); }
            f = $("#fecha_grabacion").val(); if (f == "01-01-1900") { $("#fecha_grabacion").val(""); }
            f = $("#fecha_guia").val(); if (f == "01-01-1900") { $("#fecha_guia").val(""); }

            // 
            /*
            f_aduana = $("#fecha_aduana").val();
            f_recepcion = $("#fecha_recepcion").val();
            f_grabacion = $("#fecha_grabacion").val();
            if (f_aduana == "") { $("#id_estado").val(1); } // FAC
            if (f_aduana != "" && f_recepcion == "") { $("#id_estado").val(3); } // DAT
            if (f_aduana != "" && f_recepcion != "") { $("#id_estado").val(2); } // DAI
            if (f_grabacion != "") { $("#id_estado").val(4); } // RCP
            */

            // Verificar si se debe bloquear esta linea
            Actualiza_Estado();

            idt = $("#id_transporte").val();
            if (idt == 2) {
                $("#TD_fecha_sanantonio").css("display", "block");
                $("#TD_fecha_transbordo").css("display", "block");
            }
            else {
                $("#TD_fecha_sanantonio").css("display", "none");
                $("#TD_fecha_transbordo").css("display", "none");
            }
            saveIngreso();
            if( $("#id_transporte").val() == 2 && $("#id_embarcador").val() == 3)
                Cargar_AutoCompleteBuques();

            Listar_Carpetas_Detalle();
        },
        error: function (html) {
            $("#td_form").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al buscar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
        }
    });
}

function Actualizar_Datos_Generales(v_object) {
  v_tipo_dato = v_object.attr("tipo_dato");
  v_nom_campo = v_object.attr("name");
  v_o_value   = v_object.attr("o_value");
  v_valor = v_object.val();

  var auxFecha_recepcion = document.getElementById("fecha_recepcion");
  var ya_existe_RCP = document.getElementById("ya_existe_RCP");

  // Esto se hace para que siempre actualice la Fecha de Recepcion
  //if (v_nom_campo == "fecha_recepcion") {v_o_value = ""; }

  var volverLBL = document.getElementById("label_volver");
  if (v_valor != v_o_value) {
      //if (v_nom_campo == "fecha_recepcion" && v_o_value != '01-01-1900') {
      if (v_nom_campo == "fecha_recepcion" && ya_existe_RCP.value == 'S') {
          volverLBL.style.visibility = "hidden"
          $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #EEEEEE;'>No se puede cambiar la Fecha de Recepcion.</label></b></center>");
          var auxFecha_recepcion = document.getElementById("fecha_recepcion");
          auxFecha_recepcion.value = v_o_value
          volverLBL.style.visibility = "";
      }
      else {
          if (v_nom_campo == "fecha_recepcion") {
              volverLBL.style.visibility = "hidden"
              $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#009933; background-color: #EEEEEE;'>Actualizando documentos, espere por favor...</label></b></center>");
          }
          $.ajax({
              url: "carpetas_grabar.asp",
              data: "accion=update" +
                  "&documento_respaldo=" + $("#documento_respaldo").val() +
                  "&anio=" + $("#anio").val() +
                  "&mes=" + $("#mes").val() +
                  "&num_carpeta=" + $("#num_carpeta").val() +
                  "&nom_campo=" + v_nom_campo +
                  "&valor=" + escape(v_valor) +
                  "&tipo_dato=" + v_tipo_dato,
              type: "post",
              async: true,
              dataType: "json",
              success: function (data) {
                  volverLBL.style.visibility = "";

                  //console.log(data.accion);
                  //console.log(data.valor);
                  v_object.attr("o_value", v_valor)
                  $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#009933; background-color: #EEEEEE;'>Datos actualizados correctamente...</label></b></center>");
                  setTimeout(function () { $("#label_msg").fadeOut(2000); }, 3000);
                  if (v_nom_campo == "CamionAlto") { Cargar_Form_Ingresar($("#num_carpeta").val(), "") }
                  if (v_nom_campo == "CamionAncho") { Cargar_Form_Ingresar($("#num_carpeta").val(), "") }
                  if (v_nom_campo == "CamionLargo") { Cargar_Form_Ingresar($("#num_carpeta").val(), "") }
                  if (v_nom_campo == "id_transporte") { Cargar_Form_Ingresar($("#num_carpeta").val(), "") }
                  if (v_nom_campo == "id_embarcador") { Cargar_Form_Ingresar($("#num_carpeta").val(), "") }
                  if (v_nom_campo == "fecha_ptaarenas") { Cargar_Form_Ingresar($("#num_carpeta").val(), "") }
                  if (v_nom_campo == "Id_Buque_Viaje_San_Antonio" || v_nom_campo == "Id_Buque_Viaje_Punta_Arenas") {
                    Actualizar_Fecha_Desde_Buque($("#auxCarpeta").val(), "") 
                 }
                  if (v_nom_campo == "Factor_recibir") { Cargar_Form_Ingresar($("#num_carpeta").val(), "") }

              },
              error: function (html) {
                  volverLBL.style.visibility = "";

                  if (html.responseText.indexOf('La Fecha de') != -1) {
                      $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>La Fecha de Recepcion no puede ser menor que la Fecha de Aduana de las TCP.</label></b></center>");
                      setTimeout(function () { $("#label_msg").fadeOut(2000); }, 5000);
                  }
                  else {
                      $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>Ha ocurrido un error al actualizar los datos.</label></b></center>");
                      setTimeout(function () { $("#label_msg").fadeOut(2000); }, 5000);
                  }
              }
          });
      }
  }
}
function Actualizar_Fecha_Desde_Buque(num_carpeta){
    $.ajax({
        url: "actualizar_fecha_desde_buque.asp",
        data: "carpeta=" + num_carpeta,
        type: "post",
        async: true,
        dataType: "json",
        success: function (data) {
            Cargar_Form_Ingresar($("#num_carpeta").val(), "") 
        },
        error: function (html) {
            $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>Ha ocurrido un error al actualizar los datos.</label></b></center>");
            setTimeout(function () { $("#label_msg").fadeOut(2000); }, 5000);
        }
    });

}

function Cargar_Form_Ingresar_Form_Ingreso(v_numero_linea){
    var auxNumero_aduana = document.getElementById("Numero_aduana");

    $.ajax({
        url: "carpetas_form_ingresar_form_ingreso.asp",
        data: "documento_respaldo=" + $("#documento_respaldo").val() +
              "&anio=" + $("#anio").val() +
              "&mes=" + $("#mes").val() +
              "&num_carpeta=" + $("#num_carpeta").val() +
              "&Numero_aduana=" + auxNumero_aduana.value +
              "&numero_linea=" + v_numero_linea,
        type: "POST",
        async: true,
        dataType: "html",
        success: function (html) {
            $("#td_form_ingreso").html(html);
            Cargar_AutoCompleteProveedores();

            $("#label_actualizar").css("title", "Actualizar datos");
            $("#label_actualizar").on({
                mouseover: function () {
                    $(this).css("cursor", "pointer");
                    $(this).css("background-color", "#60B060");
                },
                mouseout: function () {
                    $(this).css("background-color", "#51A351");
                },
                click: function () {
                    Actualizar_Factura();
                }
            });

            $("#label_cancelar").css("title", "Cancelar");
            $("#label_cancelar").on({
                mouseover: function () {
                    $(this).css("cursor", "pointer");
                    $(this).css("background-color", "#828282");
                },
                mouseout: function () {
                    $(this).css("background-color", "#626262");
                },
                click: function () {
                    Cerrar_Form_Ingreso();
                    saveIngreso();
                }
            });

            if (false) {
                $("#fecha_factura").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate         : "+1d",
                    minDate: "-9m"
                    //onSelect: function(selectedDate){//Actualizar_Datos_Generales($(this));}
                });
                $("#Fecha_aduana").datepicker({
                    dateFormat: "dd-mm-yy",
                    //maxDate         : "+1d",
                    minDate: "-9m"
                    //onSelect: function(selectedDate){//Actualizar_Datos_Generales($(this));}
                });
            }
            else {
                $("#fecha_factura").on({
                    blur: function () {
                        CompletarFecha(this);
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }

                    }
                });
                $("#Fecha_aduana").on({
                    blur: function () {
                        CompletarFecha(this);
                    },
                    focus: function () {
                        $(this).select();
                    },
                    keypress: function (event) {
                        var v_keycode = (event.keyCode ? event.keyCode : event.which);
                        if (v_keycode >= "48" && v_keycode <= "57") { if (v_keycode == "13") { CompletarFecha(this); } }
                        else { return false; }

                    }
                });
            }

            $("#monto_total_usd").on({
                focus: function () {
                    $(this).select();
                },
                change: function () {
                    //alert("change: " + $("#tipo_moneda").val());
                    if ($("#tipo_moneda").val() == "$") {
//                        $("#monto_moneda_origen").val($("#monto_total_usd").val());
//                        $("#paridad").val(1.00);
                    }
                    if ($("#tipo_moneda").val() == "US$") {
                        $("#monto_moneda_origen").val($("#monto_total_usd").val());
                        $("#paridad").val(1.00);
                    }
                    if ($("#tipo_moneda").val() == "Y$") {
                    }
                },
                blur: function () {
                    //alert("blur: " + $("#monto_moneda_origen").val());
                    if ($("#monto_moneda_origen").val() != 0) {
                        Calcular_Monto_Total_USD();
                        Calcular_Porcentaje_Prorrateo();
                    }
                },
                keypress: function (event) {
                    var v_keycode = (event.keyCode ? event.keyCode : event.which);
                    if (v_keycode == "13")
                        $("#paridad").focus();
                }
            });

            $("#monto_moneda_origen").on({
                focus: function () {
                    $(this).select();
                },
                change: function () {
                    if ($("#tipo_moneda").val() == "Y$") {
                    }
                },
                blur: function () {
                    if ($("#monto_total_usd").val() != 0) {
                        Calcular_Monto_Total_USD();
                        Calcular_Porcentaje_Prorrateo();
                    }
                },
                keypress: function (event) {
                    var v_keycode = (event.keyCode ? event.keyCode : event.which);
                    if (v_keycode == "13")
                        $("#paridad").focus();
                }
            });

            $("#paridad").on({
                blur: function () {
                    //Calcular_Monto_Total_USD();
                    //Calcular_Porcentaje_Prorrateo();
                },
                focus: function () {
                    $(this).select();
                },
                keypress: function (event) {
                    var v_keycode = (event.keyCode ? event.keyCode : event.which);
                    if (v_keycode == "13")
                        $("#monto_final_usd").focus();
                }
            });

            $("#id_tipo_factura").on({
                blur: function () {
                    if (this.value == "$") { }
                    if (this.value == "US$") { }
                    if (this.value == "Y$") { }
                },
                change: function () {
                    changeTipoFactura($("#id_tipo_factura"));
                },
                focus: function () {
                    $(this).select();
                }
            });

            $("#tipo_docto_aduana").on({
                blur: function () {
                    if (this.value == "$") { }
                    if (this.value == "US$") { }
                    if (this.value == "Y$") { }
                },
                change: function () {
                    changeTipoDoctoAduana($("#tipo_docto_aduana"));
                },
                focus: function () {
                    $(this).select();
                }
            });

            $("#tipo_moneda").on({
                blur: function () {
                    if (this.value == "$") { }
                    if (this.value == "US$") { }
                    if (this.value == "Y$") { }
                },
                change: function () {
                    changeTipoMoneda($("#tipo_moneda"));
                },
                focus: function () {
                    $(this).select();
                }
            });


            $("#CBM").on({
                blur: function () {
                    Formato_Numeros();
                },
                focus: function () {
                    $(this).select();
                },
                keypress: function (event) {
                    var v_keycode = (event.keyCode ? event.keyCode : event.which);
                    if (v_keycode == "13")
                        $("#KG").focus();
                }
            });
            $("#KG").on({
                blur: function () {
                    Formato_Numeros();
                },
                focus: function () {
                    $(this).select();
                },
                keypress: function (event) {
                    var v_keycode = (event.keyCode ? event.keyCode : event.which);
                    if (v_keycode == "13")
                        $("#Fisico").focus();
                }
            });

            $("#ProrrateoCBM").on({
                blur: function () {
                    Formato_Prorrateo();
                },
                focus: function () {
                    $(this).select();
                },
                keypress: function (event) {
                    var v_keycode = (event.keyCode ? event.keyCode : event.which);
                    if (v_keycode == "13")
                        $("#ProrrateoKG").focus();
                }
            });
            $("#ProrrateoKG").on({
                blur: function () {
                    Formato_Prorrateo();
                },
                focus: function () {
                    $(this).select();
                },
                keypress: function (event) {
                    var v_keycode = (event.keyCode ? event.keyCode : event.which);
                    if (v_keycode == "13")
                        $("#ProrrateoUSD").focus();
                }
            });
            $("#ProrrateoUSD").on({
                blur: function () {
                    Formato_Prorrateo();
                },
                focus: function () {
                    $(this).select();
                },
                keypress: function (event) {
                    var v_keycode = (event.keyCode ? event.keyCode : event.which);
                    if (v_keycode == "13")
                        $("#ProrrateoItems").focus();
                }
            });

            changeTipoFactura($("#id_tipo_factura"));
            changeTipoDoctoAduana($("#tipo_docto_aduana"));
            changeTipoMoneda($("#tipo_moneda"));

            changeProrrateo($("#documento_respaldo"));

            restoreIngreso();
        },
        error: function (html) {
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
function Cargar_AutoCompleteBuques(){
  $("#buscar_buque_san_antonio").autocomplete({
    minLength: 0,
    source: arrayJsonBuquesSanAntonio,
    focus: function( event, ui ) {
      $("#buscar_buque_san_antonio").val( ui.item.label );
      $("#Id_Buque_Viaje_San_Antonio").val( ui.item.value );
      return false;
    },
    select: function( event, ui ) {
      $("#buscar_buque_san_antonio").val( ui.item.label );
      $("#Id_Buque_Viaje_San_Antonio").val( ui.item.value );
      Actualizar_Datos_Generales($("#Id_Buque_Viaje_San_Antonio"));
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
  /*--------  --------*/
  $("#buscar_buque_punta_arenas").autocomplete({
    minLength: 0,
    source: arrayJsonBuquesPuntaArenas,
    focus: function( event, ui ) {
      $("#buscar_buque_punta_arenas").val( ui.item.label );
      $("#Id_Buque_Viaje_Punta_Arenas").val( ui.item.value );
      return false;
    },
    select: function( event, ui ) {
      $("#buscar_buque_punta_arenas").val( ui.item.label );
      $("#Id_Buque_Viaje_Punta_Arenas").val( ui.item.value );
      Actualizar_Datos_Generales($("#Id_Buque_Viaje_Punta_Arenas"));
      
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

function Agregar_Factura() {
    var msg = "";
    var flag = false;

    var auxDocumento_respaldo = document.getElementById("documento_respaldo");
    var auxNumero_aduana = document.getElementById("Numero_aduana");
    if (auxDocumento_respaldo.value == "Z") {
        /*
        if (auxNumero_aduana.value == "") {
            flag = true;
            msg = "Debe ingresar el Numero de Aduana.";
        }
        */
    }

    if (flag) { alert(msg); }
    else {
        if (confirm("¿Está seguro que desea agregar una factura a la carpeta?")) {
            $.ajax({
                url: "carpetas_grabar_detalle.asp",
                data: "accion=insert" +
                  "&documento_respaldo=" + $("#documento_respaldo").val() +
                  "&anio=" + $("#anio").val() +
                  "&mes=" + $("#mes").val() +
                  "&num_carpeta=" + $("#num_carpeta").val(),
                type: "post",
                async: true,
                dataType: "json",
                success: function (data) {
                    //console.log(data.accion);
                    //console.log(data.valor);
                    x_numero_linea = data.valor;

                    $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#009933; background-color: #EEEEEE;'>Factura agregada correctamente...</label></b></center>");
                    setTimeout(function () { $("#label_msg").fadeOut(2000); }, 3000);

                    Listar_Carpetas_Detalle();
                    Cargar_Form_Ingresar_Form_Ingreso(x_numero_linea);
                },
                error: function (html) {
                    $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>Ha ocurrido un error al actualizar los datos.</label></b></center>");
                    setTimeout(function () { $("#label_msg").fadeOut(2000); }, 5000);
                }
            });
        }
    }
}

function Actualizar_Factura() {
    var auxdocumento_respaldo = document.getElementById("documento_respaldo");
    var auxNumeroAduana = document.getElementById("NumeroAduana");
    if ($("#NumeroAduana").val() == "") {
        $("#NumeroAduana").val(auxNumeroAduana.value);
    }

  //Validaciones
  str_msg_error = ""
  if($("#entidad_comercial").val() == "")
    str_msg_error = "Ingrese proveedor"
  else if ($("#numero_factura").val() == "")
      str_msg_error = "Ingrese n° factura"
  //else if ($("#NumeroAduana").val() == "")
  //    str_msg_error = "Ingrese n° aduana"
  else if ($("#fecha_factura").val() == "")
    str_msg_error = "Ingrese fecha factura"
  else if($("#monto_moneda_origen").val() == "")
    str_msg_error = "Ingrese monto moneda origen"
  else if($("#paridad").val() == "")
    str_msg_error = "Ingrese monto moneda origen"
  else if($("#monto_final_usd").val() == "")
    str_msg_error = "Ingrese monto moneda origen"
  else if (parseFloat($("#monto_total_usd").val()) == 0)
      str_msg_error = "Ingrese monto moneda origen"

  if (parseFloat($("#id_tipo_factura").val()) == 1 && $("#documento_respaldo").val() != "TU" ) {
      if (parseFloat($("#Bultos").val()) == 0 || $("#Bultos").val() == "") { str_msg_error = "Ingrese los bultos."; }
  }

  /*
  if (auxdocumento_respaldo.value == "Z") {
      if ($("#NumeroAduana").val() == "") {str_msg_error = ""; }
  }
  */

  if(str_msg_error != "")
  {
    $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000;'>" + str_msg_error + "</label></b></center>");
    setTimeout(function(){$("#label_msg").fadeOut(2000);}, 5000);
    return false;
  }
if (confirm("¿Está seguro que desea actualizar los datos de esta factura?")) {
    $.ajax({
        url: "carpetas_grabar_detalle.asp",
        data: "accion=update" +
                  "&documento_respaldo=" + $("#documento_respaldo").val() +
                  "&anio=" + $("#anio").val() +
                  "&mes=" + $("#mes").val() +
                  "&num_carpeta=" + $("#num_carpeta").val() +
                  "&numero_linea=" + $("#numero_linea").val() +
                  "&entidad_comercial=" + $("#entidad_comercial").val() +
                  "&id_tipo_factura=" + $("#id_tipo_factura").val() +
                  "&numero_factura=" + escape($("#numero_factura").val()) +
                  "&tipo_docto_aduana=" + escape($("#tipo_docto_aduana").val()) +
                  "&numero_aduana=" + auxNumeroAduana.value +
        //"&numero_aduana=" + escape($("#NumeroAduana").val()) +
                  "&fecha_factura=" + escape($("#fecha_factura").val()) +
                  "&fecha_aduana=" + escape($("#Fecha_aduana").val()) +
                  "&tipo_moneda=" + escape($("#tipo_moneda").val()) +
                  "&monto_moneda_origen=" + $("#monto_moneda_origen").val() +
                  "&paridad=" + $("#paridad").val() +
                  "&monto_total_usd=" + $("#monto_total_usd").val() +
                  "&monto_final_usd=" + $("#monto_final_usd").val() +
                  "&porcentaje_prorrateo=" + $("#porcentaje_prorrateo").val() +
                  "&Bultos=" + $("#Bultos").val() +
                  "&CBM=" + $("#CBM").val() +
                  "&KG=" + $("#KG").val() +
                  "&Fisico=" + $("#Fisico").val() +
                  "&ProrrateoCBM=" + $("#ProrrateoCBM").val() +
                  "&ProrrateoKG=" + $("#ProrrateoKG").val() +
                  "&ProrrateoUSD=" + $("#ProrrateoUSD").val() +
                  "&ProrrateoItems=" + $("#ProrrateoItems").val() +
                  "&Numero_lineas_factura=" + $("#Numero_lineas_factura").val(),
        type: "post",
        async: true,
        dataType: "json",
        success: function (data) {
            //alert("accion: " + data.accion);
            //alert("valor: " + data.valor);
            //console.log(data.accion);
            //console.log(data.valor);
            if (data.accion == "OK") {
                $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#009933; background-color: #EEEEEE;'>Datos actualizados correctamente...</label></b></center>");
                setTimeout(function () { $("#label_msg").fadeOut(2000); }, 3000);

                Cerrar_Form_Ingreso();
                Listar_Carpetas_Detalle();
                saveIngreso();
                Mostrar_totales();
            }
            if (data.accion == "ERR") {
                $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>" + data.valor + "</label></b></center>");
                setTimeout(function () { $("#label_msg").fadeOut(2000); }, 5000);
            }
        },
        error: function (html) {
            //alert("accion: " + errorThrown.accion);
            //alert("valor: " + errorThrown.valor);
            $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#AA0000; background-color: #FFCC33;'>Ha ocurrido un error al actualizar los datos.</label></b></center>");
            setTimeout(function () { $("#label_msg").fadeOut(2000); }, 5000);
        }
    });
  }
}

function Listar_Carpetas_Detalle(){
    $.ajax({
        url: "carpetas_form_ingresar_listar.asp",
        data: "documento_respaldo=" + $("#documento_respaldo").val() +
              "&anio=" + $("#anio").val() +
              "&mes=" + $("#mes").val() +
              "&num_carpeta=" + $("#num_carpeta").val(),
        type: "POST",
        async: true,
        dataType: "html",
        success: function (html) {
            $("#td_lista").html(html);
        },
        error: function (html) {
            $("#td_lista").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al buscar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
        }
    });
}

function Cerrar_Form_Ingreso(){
  $("#td_form_ingreso").html("");
}

function Calcular_Monto_Total_USD() {
  if($("#monto_moneda_origen").val() == "")
    $("#monto_moneda_origen").val("0.00")
  if ($("#paridad").val() == "")
    $("#paridad").val("0.0000")

  v_monto_total_usd = $("#monto_total_usd").val().replace(/\,/g, ".");
  v_monto_moneda_origen = $("#monto_moneda_origen").val().replace(/\,/g, ".");
  v_paridad = roundNumber(parseFloat(v_monto_moneda_origen) / parseFloat(v_monto_total_usd), 7);

  $("#monto_moneda_origen").val(roundNumber(v_monto_moneda_origen, 2).toFixed(2));
  $("#paridad").val(roundNumber(v_paridad, 7).toFixed(7));
  $("#monto_total_usd").val(parseFloat(v_monto_total_usd).toFixed(2));
  $("#monto_final_usd").val(parseFloat(v_monto_total_usd).toFixed(2));
}

function Calcular_Porcentaje_Prorrateo(){
  v_monto_total_usd = $("#monto_total_usd").val().replace(/\,/g,".");;
  if ($("#monto_final_usd").val() == "")
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
  if(confirm("¿Está seguro que desea eliminar esta factura?")) {
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

function Actualiza_Estado() {
    // 
    f_estado = $("#id_estado");
    f_aduana = $("#fecha_aduana").val();
    f_recepcion = $("#fecha_recepcion").val();
    f_grabacion = $("#fecha_grabacion").val();
    if (f_aduana == "") { $("#id_estado").val(1); } // FAC
    /*
    if (f_aduana != "" && f_recepcion == "") { $("#id_estado").val(3); } // DAT
    if (f_aduana != "" && f_recepcion != "") { $("#id_estado").val(2); } // DAI
    if (f_grabacion != "") { $("#id_estado").val(4); } // RCP
    */

    Actualizar_Datos_Generales(f_estado);
}

function CompletarFecha(obj) {
    var sValue = obj.value;

    if (sValue != "") {
        var Fecha = new Date();
        iYear = Fecha.getFullYear();
        iMonth = Fecha.getMonth() + 1;
        iDate = Fecha.getDate();
        iHours = Fecha.getHours();
        iMinutes = Fecha.getMinutes();
        iSeconds = Fecha.getSeconds();

        if (sValue.length == 3 || sValue.length == 5) {
            $("#td_msg").html("<center><b><label id='label_msg' name='label_msg' style='font-size:11px; color:#009933; background-color: #EEEEEE;'>Error, ingrese fecha en caracteres de a par, ej.: 1309, 0511, 050916, etc.</label></b></center>");
            obj.value = "";
        }
        else {
            /* Digitacion
            1
            13
            139
            1309
            13916
            290216
            */
            if (sValue.length == 1) { iDate = parseFloat(sValue); }
            if (sValue.length == 2) { iDate = parseFloat(sValue); }
            if (sValue.length == 4) { iDate = parseFloat(sValue.substr(0, 2)); iMonth = parseFloat(sValue.substr(2, 2)); }
            if (sValue.length == 6) { iDate = parseFloat(sValue.substr(0, 2)); iMonth = parseFloat(sValue.substr(2, 2)); iYear = 2000 + parseFloat(sValue.substr(4, 2)); }
            if (sValue.length == 10) { iDate = parseFloat(sValue.substr(0, 2)); iMonth = parseFloat(sValue.substr(3, 2)); iYear = parseFloat(sValue.substr(6, 4)); }

            iMonth = (iMonth < 10) ? '0' + iMonth : iMonth;
            iDate = (iDate < 10) ? '0' + iDate : iDate;
            iHours = (iHours < 10) ? '0' + iHours : iHours;
            iMinutes = (iMinutes < 10) ? '0' + iMinutes : iMinutes;
            iSeconds = (iSeconds < 10) ? '0' + iSeconds : iSeconds;

            fecAduana = iDate + "-" + iMonth + "-" + iYear;

            obj.value = fecAduana;
            
            return fecAduana;
        }
    }
}

function changeTipoFactura(obj) {

    if (obj.val() == "1") {
        $("#TRBultos").css("display", "block");
        //$("#Bultos").css("display", "block");
    }
    else {
        $("#TRBultos").css("display", "none");
        //$("#Bultos").css("display", "none");
    }
}

function changeTipoDoctoAduana(obj) {

    if (obj.value == "$") {
        $("#TRMonto_moneda_origen").css("display", "none"); $("#TRParidad").css("display", "none");
        $("#monto_moneda_origen").css("display", "none"); $("#paridad").css("display", "none");
    }
    if (obj.value == "US$") {
        $("#TRMonto_moneda_origen").css("display", "none"); $("#TRParidad").css("display", "none");
        $("#monto_moneda_origen").css("display", "none"); $("#paridad").css("display", "none");
    }
    if (obj.value == "Y$") {
        $("#TRMonto_moneda_origen").css("display", "block"); $("#TRParidad").css("display", "block");
        $("#monto_moneda_origen").css("display", "block"); $("#paridad").css("display", "block");
    }
}

function changeTipoMoneda(obj) {

    if (obj.val() == "$") {
        $("#TRMonto_moneda_origen").css("display", "none"); $("#TRParidad").css("display", "none");
        $("#monto_moneda_origen").css("display", "none"); $("#paridad").css("display", "none");
    }
    if (obj.val() == "US$") {
        $("#TRMonto_moneda_origen").css("display", "none"); $("#TRParidad").css("display", "none");
        $("#monto_moneda_origen").css("display", "none"); $("#paridad").css("display", "none");
    }
    if (obj.val() == "Y$") {
        $("#TRMonto_moneda_origen").css("display", "block"); $("#TRParidad").css("display", "block");
        $("#monto_moneda_origen").css("display", "block"); $("#paridad").css("display", "block");
    }
}

function changeProrrateo(obj) {

    if (obj.val() == "Z") {
        $("#TRProrrateoCBM").css("display", "block");
        $("#TRProrrateoKG").css("display", "block");
        $("#TRProrrateoUSD").css("display", "block");
        $("#TRProrrateoItems").css("display", "block");
    }
    else {
        $("#TRProrrateoCBM").css("display", "none");
        $("#TRProrrateoKG").css("display", "none");
        $("#TRProrrateoUSD").css("display", "none");
        $("#TRProrrateoItems").css("display", "none");
    }
}


function saveIngreso() {

    var p;

    p = $("#fieldset_gastos");
    ftop = p.css("top");
    fleft = p.css("left");
    fwidth = p.css("width");
    fheight = p.css("height");

    p = $("#td_lista");
    ltop = p.css("top");
    lleft = p.css("left");
    lwidth = p.css("width");
    lheight = p.css("height");

    p = $("#td_form_ingreso");
    itop = p.css("top");
    ileft = p.css("left");
    iwidth = p.css("width");
    iheight = p.css("height");

    nwidth = parseFloat(lwidth) + parseFloat(iwidth);

    $("#td_form_ingreso").css("display", "none");
    $("#td_lista").css("width", nwidth + "px");
    $("#td_lista").css("visibility", "visible");
}

function restoreIngreso() {

    $("#td_lista").css("width", lwidth);
    $("#td_lista").css("visibility", "hidden");
    $("#td_lista").css("display", "block");
    $("#td_form_ingreso").css("width", "680px");
    $("#td_form_ingreso").css("display", "block");
}


function Mostrar_totales() {
    $.ajax({
        url: "carpetas_Mostrar_totales.asp",
        data: "documento_respaldo=" + $("#documento_respaldo").val() +
              "&anio=" + $("#anio").val() +
              "&mes=" + $("#mes").val() +
              "&num_carpeta=" + $("#num_carpeta").val(),
        type: "POST",
        async: true,
        dataType: "html",
        success: function (html) {
            arrayTot = html.split('|');
            $("#TotalBultos").val(arrayTot[0]);
            $("#TotalCBM").val(arrayTot[1]);
            $("#TotalKG").val(arrayTot[2]);
        }
    });
}


function Formato_Numeros(){
  v_CBM = $("#CBM").val().replace(/\,/g,".");;
  $("#CBM").val(roundNumber(v_CBM,2).toFixed(2));
  
  v_KG = $("#KG").val().replace(/\,/g,".");;
  $("#KG").val(roundNumber(v_KG,2).toFixed(2));
}

function Formato_Prorrateo() {
    v_ProrrateoCBM = $("#ProrrateoCBM").val().replace(/\,/g, "."); ;
    $("#ProrrateoCBM").val(roundNumber(v_ProrrateoCBM, 2).toFixed(2));

    v_ProrrateoKG = $("#ProrrateoKG").val().replace(/\,/g, "."); ;
    $("#ProrrateoKG").val(roundNumber(v_ProrrateoKG, 2).toFixed(2));

    v_ProrrateoUSD = $("#ProrrateoUSD").val().replace(/\,/g, "."); ;
    $("#ProrrateoUSD").val(roundNumber(v_ProrrateoUSD, 2).toFixed(2));
}


function fncMasDctos(NroInterno) {
    var URL = "DocumentosPago.asp";
    URL += "?NroInterno=" + NroInterno;

    var hora = new Date();
    vHours = hora.getHours();
    vMinute = hora.getMinutes();
    vSecond = hora.getSeconds();
    hora = "H" + vHours + "" + vMinute + "" + vSecond;

    URL += "&Hora=" + hora;

    var winURL = URL;
    var winName = "DocumentosPago";

    var winFeatures = "status=no,";
    winFeatures += "resizable=no,";
    winFeatures += "toolbar=no,";
    winFeatures += "location=no,";
    winFeatures += "scrollbars=yes,";
    winFeatures += "menubar=0,";
    winFeatures += "target=top,";
    winFeatures += "width=790,";
    winFeatures += "height=270,";
    winFeatures += "top=200,";
    winFeatures += "left=200";

    var wclcl = window.open(winURL, winName, winFeatures);
}


function validarEstados() {
    /*
        1: FAC
        2: DAI
        3: DAT
        4: RCP

        Fecha recepcion  = Null    -> DAT
        Fecha recepcion != Null    -> DAI
        Fecha recepcion < F.Actual -> RCP
    */

    var nEstado = 0;
    var fActual = new Date();
    var fRecepc = $("#fecha_recepcion").val(); if (fRecepc == "01-01-1900") { fRecepc = ""; }

    var fRecepcion = "";
    if (fRecepc != "") { fRecepcion = Fecha_A_Java(fRecepc); }

    if (fRecepcion == "") { nEstado = 3; }
    if (fRecepcion != "") { nEstado = 2; }
    if (fRecepcion < fActual) { nEstado = 4; }
    //alert(nEstado);

    return nEstado;
}


function validarFechas(obj) {
    /*
        Fecha salida < Fecha estimada llegada
        Estim.llegada <= Fecha recepcion
    */
    var flgError = "N";
    var msgError = ""
    v_o_value = obj.getAttribute("o_value")
    //alert(v_o_value);
    if (v_o_value == "01-01-1900") { v_o_value = "" }
    if (v_o_value == "01/01/1900") { v_o_value = "" }

    var fSalida = $("#fecha_salida").val(); if (fSalida == "01-01-1900") { fSalida = ""; }
    var fLlegad = $("#fecha_llegada").val(); if (fLlegad == "01-01-1900") { fLlegad = ""; }
    var fRecepc = $("#fecha_recepcion").val(); if (fRecepc == "01-01-1900") { fRecepc = ""; }

    var dSalida = "";
    var dLlegada = "";
    var dRecepcion = "";
    if (fSalida != "") { dSalida = Fecha_A_Java(fSalida); }
    if (fLlegad != "") { dLlegada = Fecha_A_Java(fLlegad); }
    if (fRecepc != "") { dRecepcion = Fecha_A_Java(fRecepc); }

    var auxDocumento_respaldo = document.getElementById("documento_respaldo");

    if (auxDocumento_respaldo.value == "TU") {
        if (flgError == "N") {
            if (fLlegad != "") {
                if (dLlegada < dSalida) { flgError = "S"; msgError = "La Fecha de Llegada no puede ser menor que la Fecha de Salida..."; }
            }
        }
        if (flgError == "N") {
            if (fRecepc != "" && fLlegad != "") {
                if (dRecepcion < dLlegada) { flgError = "S"; msgError = "La Fecha de Recepcion no puede ser menor que la Fecha de Llegada."; }
            }
        }
    }
    else {
        if (flgError == "N") {
            if (fLlegad != "") {
                if (dLlegada <= dSalida) { flgError = "S"; msgError = "La Fecha de Llegada no puede ser menor que la Fecha de Salida."; }
            }
        }
        if (flgError == "N") {
            if (fRecepc != "" && fLlegad != "") {
                if (dRecepcion < dLlegada) { flgError = "S"; msgError = "La Fecha de Recepcion no puede ser menor que la Fecha de Llegada."; }
            }
        }
    }

    if (flgError == "S") {
        obj.value = v_o_value;
        alert(msgError);
        return false;
    }
    else {
        return true;
    }
}

// Rutina : convierte la fecha a formato JAVASCRIPT.
// Entrada: valor
// Salida : fecha en formato JAVASCRIPT.
function Fecha_A_Java(valor) {
    var nDia;
    var nMes;
    var nAno;
    var nPos;
    var dFecha;

    if (valor.indexOf("/") != -1) {
        nPos = valor.indexOf("/");
        nDia = valor.substr(0, nPos);
        valor = valor.substr(nPos + 1);

        nPos = valor.indexOf("/");
        nMes = valor.substr(0, nPos);

        nAno = valor.substr(nPos + 1);
    }
    else {
        if (valor.indexOf("-") != -1) {
            nPos = valor.indexOf("-");
            nDia = valor.substr(0, nPos);
            valor = valor.substr(nPos + 1);

            nPos = valor.indexOf("-");
            nMes = valor.substr(0, nPos);

            nAno = valor.substr(nPos + 1);
        }
    }

    dFecha = ((parseFloat(nMes) < 10) ? "0" : "") + parseFloat(nMes) + "/";
    dFecha += ((parseFloat(nDia) < 10) ? "0" : "") + parseFloat(nDia) + "/";
    dFecha += nAno;
    dFecha = new Date(dFecha);

    return (dFecha);
}
