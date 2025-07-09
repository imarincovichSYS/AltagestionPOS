
function Verificar_Historico(){
  x_empresa = $("buscar_empresa").get("value")
  x_anio    = $("buscar_anio").get("value")
  x_mes     = $("buscar_mes").get("value")
  var jsonRequest = new Request.JSON({
    url: "cuentas_contables_verificar.asp",
    method: "post",
    data: "empresa="+x_empresa+"&anio="+x_anio+"&mes="+x_mes,
    onLoadstart: function(event, xhr)
    { 
      str_Msg    = "<img src='imagenes/new_loader_FFFFFF_9B9DAA.gif' width=16 height=16 border=0 align='top'>"
      str_Msg   += "&nbsp;&nbsp;&nbsp;<label style='color: #EEEEEE'>Actualizando histórico... </label>"
      $("td_lista").set("html", str_Msg);
    },
    onSuccess: function(datos){
      console.log(datos.resultado)
      console.log(datos.valor)
      if(datos.resultado=="ERROR")
      {
        str_msg = "Ha ocurrido un error al actualizar el histórico. Por favor, contáctese con el administrador del sistema"
        $("td_lista").set("html", "<label id='label_msg' name='label_msg' style='color:#AA0000;'>"+str_msg+"</label>");              
        clearTimeout(timeID);
        timeID = setTimeout("$('label_msg').set('tween', {duration: 2000}).fade('out');",5000)        
      }
      else
      {
        $("td_lista").set("html", "OK")
      }
    },
    onFailure: function(respuesta)
    {
      str_msg = "Ha ocurrido un error al actualizar el histórico. Por favor, contáctese con el administrador del sistema"
      console.log(respuesta)
      $("td_lista").set("html", "<label id='label_msg' name='label_msg' style='color:#AA0000;'>"+str_msg+"</label>");              
      clearTimeout(timeID);
      timeID = setTimeout("$('label_msg').set('tween', {duration: 2000}).fade('out');",5000)
    }
  })
  jsonRequest.send();
}

function Listar_Historico(){
  x_empresa = $("buscar_empresa").get("value")
  x_anio    = $("buscar_anio").get("value")
  x_mes     = $("buscar_mes").get("value")
  var myHTMLRequest = new Request.HTML({
    url: "cuentas_contables_listar_acumulado.asp",
    method: "post",
    data: "empresa="+x_empresa+"&anio="+x_anio+"&mes="+x_mes,
    update:$("td_lista"),
    onLoadstart: function(event, xhr)
    { 
      str_Msg    = "<br><br><center><img src='imagenes/loader_FFFFFF_444444.gif' width=32 height=32 border=0 align='top'>"
      str_Msg   += "<br><br><label style='color: #EEEEEE'><b>Cargando información... </b></label></center>"
      $("td_lista").set("html", str_Msg);
    },
    onSuccess: function(respuesta){
      //console.log($("tabla_resultado").getStyle("width"))
      v_table_width = $("tabla_resultado").getStyle("width").replace(/px/g,"")
      //console.log(v_table_width)
      $("tabla_form_buscar").setStyle("width",v_table_width)
    },
    onFailure: function(respuesta)
    {
      
      str_Msg  = "<br><br><center><img src='imagenes/Ico_Glyph_Warning_29X25.png' width=29 height=25 border=0 align='top'>"
      str_Msg += "<br><br><b>Ha ocurrido un error al listar la información. Por favor, contáctese con el administrador del sistema</b>"
      //console.log(respuesta)
      $("td_lista").set("html", "<label id='label_msg' name='label_msg' style='color:#FFFFFF;'>"+str_Msg+"</label>");              
      clearTimeout(timeID);
      timeID = setTimeout("$('label_msg').set('tween', {duration: 2000}).fade('out');",5000)
    }
  });
  myHTMLRequest.send();
}
var timeID;
window.addEvent("domready", function() {
  $("buscar_empresa").addEvent("change", function(){
    $("td_lista").set("html","")
  });
  $("buscar_anio").addEvent("change", function(){
    $("td_lista").set("html","")
  });
  $("buscar_mes").addEvent("change", function(){
    $("td_lista").set("html","")
  });
  $("label_cargar_datos").set("title","Cargar datos");
  $("label_cargar_datos").addEvents({
    mouseover: function(){
      this.setStyle("cursor","pointer");
      this.setStyle("background-color","#EFEFEF");
    },
    mouseout: function(){
      this.setStyle("background-color","#E6E6E6");
    },
    click: function(){
      Listar_Historico();
    }
  });
  //Verificar_Historico();
  //$(document.body).setStyle("color","#333333");
  //Listar_Historico();
});