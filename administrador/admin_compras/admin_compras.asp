<%
titulo = "Actualizar RCP"
Session("Nombre_Aplicacion") = titulo
%>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
color_border = "#999"
color_text_th = "#FFFFFF"
color_text_td = "#444444" 
color_border_tabla_ext = "#666666"

fecha_ayer = Replace(dateadd("d",-1,date()),"/","-")
%>

<html>
<head>
<script type="text/javascript">
var RutaProyecto = "<%=RutaProyecto%>"
var fecha_ayer = "<%=fecha_ayer%>"
</script>
	<title><%=titulo%></title>
	<style>
	body
  {
    PADDING-RIGHT: 0px;
    PADDING-LEFT: 0px;
    PADDING-BOTTOM: 0px;
    MARGIN: 0px;
    PADDING-TOP: 0px;
    FONT-FAMILY: Arial, Helvetica, sans-serif;
    color: #333333;
  }
  .th_left{
    border-left: 1px solid <%=color_border%>;
    border-top: 1px solid <%=color_border%>;
    border-right: 1px solid <%=color_border%>;
    color: <%=color_text_th%>;
    font-weight: bold;
  }
  .th_middle{
    border-top: 1px solid <%=color_border%>;
    border-right: 1px solid <%=color_border%>;
    color: <%=color_text_th%>;
    font-weight: bold;
  }
  .td_left{
    border-left: 1px solid <%=color_border%>;
    border-bottom: 1px solid <%=color_border%>;
    border-right: 1px solid <%=color_border%>;
    color: <%=color_text_td%>;
  }
  .td_middle{
    border-bottom: 1px solid <%=color_border%>;
    border-right: 1px solid <%=color_border%>;
    color: <%=color_text_td%>;
  }
  .tf_left{
    border-top: 1px solid <%=color_border%>;
    border-left: 1px solid <%=color_border%>;
    border-right: 1px solid <%=color_border%>;
    color: <%=color_text_td%>;
  }
  .tf_middle{
    border-top: 1px solid <%=color_border%>;
    border-right: 1px solid <%=color_border%>;
    color: <%=color_text_td%>;
  }
  
  /*
  #################################################################
  #########################  Boton Buscar #########################
  #################################################################
  */
  input[type="button"]#bot_buscar{
  	border-radius: 4px;
  	-moz-border-radius: 4px;
  	-webkit-border-radius: 4px;            
  	background: url(search_white_13X14.png) no-repeat left #5c5c5c;
  	background-size: 16px 16px;
  	color:#f7f7f7;
  	height: 20px;
  	padding: 1px 1px 15px 20px; 
  	border: 1px solid #242424;
  	font-size: 13px;
  	text-align: right;
  	font-weight: bold;
  	cursor: pointer;
  	transition: all 0.1s linear;  
  	-moz-transition: all 0.1s linear;  
  	-webkit-transition: all 0.1s linear;
  }
  
  input[type="button"]#bot_buscar:hover{
  	text-align: right;
  	background: url(search_white_13X14.png) no-repeat left #b8b8b8;
  	background-size: 16px 16px;
  	height: 20px;
  	border: 1px solid #242424;
  	color:#f7f7f7;
  	font-weight: bold;
  }  
  
  /*
  #################################################################
  ######################  Boton Actualizar ########################
  #################################################################
  */
  input[type="button"]#bot_actualizar{
    border-radius: 4px;
    -moz-border-radius: 4px;
    -webkit-border-radius: 4px;
    background: url(check_white_13X12.png) no-repeat left #51a451;
    background-size: 16px 16px;
    color:#f7f7f9;
    height: 20px;
  	padding: 1px 1px 15px 20px; 
    border: 1px solid #52A552;
    font-size: 12px;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.2s linear;  
    -moz-transition: all 0.2s linear;  
    -webkit-transition: all 0.2s linear;  
  }
  
  input[type="button"]#bot_actualizar:hover{
    text-align: right;
  	background: url(check_white_13X12.png) no-repeat left #61c361;
  	border-color:#52A552;
  	background-size: 16px 16px;
  	height: 20px;
  	border: 1px solid #242424;
  	color:#FFFFFF;
  	font-weight: bold;
  }  
	</style>
	<link rel="stylesheet" href="<%=RutaProyecto%>css/calendario.css" type="text/css">  
	<script type="text/javascript" src="<%=RutaProyecto%>js/jquery-1.7.2.js"></script>
	<script type="text/javascript" src="<%=RutaProyecto%>js/tools.js"></script>
	<script language="javascript" src="<%=RutaProyecto%>js/calendario.js"></script>
	<script type="text/javascript" src="<%=RutaProyecto%>ACIDGrid3/grid_calendario.js"></script>
	<script type="text/javascript">
		$(document).ready( function(){ 
		  $("#bot_actualizar").css("visibility","hidden");
		  Config_Tabs("td_fecha_recepcion_y_paridad")
		  //Listar("")
		  $("#numero_interno_documento_no_valorizado").attr("disabled",false);
		  $("#numero_interno_documento_no_valorizado").val("");
		  
			$("#bot_buscar").click(function(){
			  $("#td_mensaje").html("&nbsp;");
			  Listar("")
			});
			
			$("#bot_actualizar").click(function(){
			  Actualizar_RCP()
			});
			
			
			/*
			//window.parent.Menu.location.href = "../../Empty.asp"
			//window.parent.frames[0].location.href = "../../Empty.asp"
			//window.parent.frames[0].document.body.style.backgroundColor = "#9B9DAA"
			
			//window.parent.Botones.location.href = "footer.asp" //frames[2]
			window.parent.frames[2].location.href = "footer.asp"
			//window.parent.Mensajes.location.href = "footer.asp" //frames[3]
			window.parent.frames[3].location.href = "footer.asp"
			*/
		});
		
		function Listar(v_estado){
		  $("#bot_actualizar").css("visibility","hidden");
		  if($("#numero_interno_documento_no_valorizado").val()=="")
		  {
		    alert("Ingrese numero documento no valorizado")
		    $("#numero_interno_documento_no_valorizado").focus();
		    return
		  }
		  
		  $("#td_listar").html("&nbsp;");
		  //$("#numero_interno_documento_no_valorizado").attr("disabled",true)
		  
		  if($("#tab_activo").val() == "td_fecha_recepcion_y_paridad"){
		    v_textoCargando = "Listando datos RCP"
		    v_url           = "admin_compras_listar.asp"
		    v_tipo_cambio   = "fecha_recepcion_y_paridad"
		  }
		  else if($("#tab_activo").val() == "td_proveedor"){
		    v_textoCargando = "Listando datos RCP"
		    v_url           = "admin_compras_listar.asp"
		    v_tipo_cambio   = "proveedor"
		  }
		  
		  strCargando ="<br><center><img src='new_loader_000000_9B9DAA.gif' width=30 height=30 "
      strCargando+="border='0' align='top'><br><br><font color='#222222'><b>"+v_textoCargando+"...espere un momento</b></font></center>"
			$("#td_listar").html(strCargando);
			$.ajax({
				url: v_url,
				data: "estado="+v_estado+"&tipo_cambio="+v_tipo_cambio+"&numero_interno_documento_no_valorizado="+$("#numero_interno_documento_no_valorizado").val(),
				type: "POST",
				async: true,
				dataType: "html",
				success: function(html){
				  $("#hidden_numero_interno_documento_no_valorizado").val($("#numero_interno_documento_no_valorizado").val())
				  $("#td_listar").html(html);
				  Cargar_Parametros(v_tipo_cambio);
		    },
		    error: function(html){
		      $("#td_listar").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al intentar cargar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
		    }
			});
		}
		
		function Cargar_Parametros(v_tipo_cambio){
		  v_url = "admin_compras_parametros.asp"
			$("#td_parametros").html("");
			$.ajax({
				url: v_url,
				data: "tipo_cambio="+v_tipo_cambio,
				type: "POST",
				async: true,
				dataType: "html",
				success: function(html){
				  $("#hidden_tipo_cambio").val(v_tipo_cambio);
				  $("#td_parametros").html(html);
				  if(v_tipo_cambio == "fecha_recepcion_y_paridad")
				  {
				    //Set_Paridad() //No se va a buscar la paridad según la fecha de recepción--> Se cargan los datos actuales de la RCP
				    v_fecha_recepcion_actual = $("#hidden_fecha_recepcion").val()
				    $("#fecha_recepcion").val($("#hidden_fecha_recepcion").val())
				    $("#fecha_recepcion").attr("o_value",$("#hidden_fecha_recepcion").val())
				    $("#paridad").val($("#hidden_paridad").val());
				  
				    //Puede actualizar
            //$("#bot_actualizar").css("visibility",""); //El botón de "Actualizar" se debe mostrar sólo cuando la fecha ingresada es distinta a la fecha actual de la RCP
				  
				    $("#fecha_recepcion").on({
				      focus: function (){
	          		$(this).trigger("blur");
	          	},
	          	blur: function (){
	          	  $("#td_mensaje").html("&nbsp;");
	          	  //if(Compara_Fechas(v_fecha_recepcion_actual,$(this).val()) || v_fecha_recepcion_actual==$(this).val())
	          	  if(Compara_Fechas(v_fecha_recepcion_actual,$(this).val())  || v_fecha_recepcion_actual==$(this).val())
	          	  {
	          	    //La fecha ingresada debe ser menor que la fecha actual --> No se puede actualizar una RCP con fecha mayor a la actual (pueden existir guías o ventas)
	          	    //console.log("OK")
	          	    if($(this).val() != "" && $(this).val() != $(this).attr("o_value"))
                  {
                    //console.log(GetFechaCompleta_Separador_Guion($(this).val(),v_fecha_recepcion_actual))
                    $(this).val(GetFechaCompleta_Separador_Guion($(this).val(),v_fecha_recepcion_actual));
                    if(IsDate_Separador_Guion($(this).val()))
                    {
                      $(this).attr("o_value",$(this).val())
                      Set_Paridad();
                    }
                    else
                      $("#bot_actualizar").css("visibility","hidden");
                  }
	          	  }
	          	  else
	          	  {
	          	    $(this).val($(this).attr("o_value"))
	          	    str_Msg = "No se puede actualizar a una fecha mayor que la fecha actual de la RCP."
	          	    $("#td_mensaje").html("<center><label id='label_mensaje' name='label_mensaje' style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'><b>"+str_Msg+"</b></label></center>");
	          	    setTimeout("$('#label_mensaje').hide(500)",5000);
	          	  }	        		
	          	}
	          });
	        }
	        else if(v_tipo_cambio == "proveedor")
	        {
	          $("#proveedor").val($("#hidden_proveedor").val());
	          $("#proveedor").attr("o_value",$("#hidden_proveedor").val())
	          $("#nombre_proveedor").val($("#hidden_nombre_proveedor").val());
	          $("#codigo_postal").val($("#hidden_codigo_postal").val());
	          
	          $("#proveedor").on({
	            keydown: function (event){
	              if(Navegador_No_IE)
                  x_codtecla = event.which
                else
                  x_codtecla = event.keyCode
				      	if(x_codtecla==13)
				          $(this).trigger("blur");
				      },
				      blur:function (event){
				        if($(this).val() != "" && $(this).val() != $(this).attr("o_value"))
				        {
				          $(this).attr("o_value",$(this).val())
				          Set_Proveedor()
				        }
				        else
				        {
				          v_proveedor_actual = $("#hidden_proveedor").val();
                  if(v_proveedor_actual != $("#proveedor").val())
                    $("#bot_actualizar").css("visibility","");
                  else
                    $("#bot_actualizar").css("visibility","hidden");
                }
				      }
				    });  
				    
				    $("#label_actualiza_detalle").on({
	            mouseover: function (event){
				        $(this).css("cursor","pointer");
				      },
				      click: function (event){
				        if($("#check_actualiza_detalle").is(":checked"))
				          $("#check_actualiza_detalle").attr("checked",false);
				        else
				          $("#check_actualiza_detalle").attr("checked",true);
				          
				      }
				    });
	        }
		    },
		    error: function(html){
		      $("#td_parametros").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al intentar cargar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
		    }
			});
		}
		
		function Set_Paridad(){
		  $("#bot_actualizar").css("visibility","hidden");
		  v_url = RutaProyecto + "funciones_SYS_AJAX/AJAX_JSON_Get_Paridad_X_Fecha.asp"
		  $.ajax({
        dataType: "json",
        type: "post",
        url: v_url,
        data: "fecha="+$("#fecha_recepcion").val(),
        success: function(data){
          $("#paridad").val(data.paridad_facturacion)
          //console.log(data.paridad_facturacion)
          //console.log(data.paridad_margen)
          v_fecha_recepcion_actual = $("#hidden_fecha_recepcion").val()
          //console.log($("#paridad").val())
          //console.log(v_fecha_recepcion_actual)
          if($("#paridad").val() != "" && $("#paridad").val() != "0" && v_fecha_recepcion_actual != $("#fecha_recepcion").val())
          {
            //Puede actualizar
            $("#bot_actualizar").css("visibility","");
          }
          else
          {
            //No Puede actualizar
            $("#bot_actualizar").css("visibility","hidden");
          }
        },
        error: function(html){
          str_Msg = "Ha ocurrido un error al intentar cargar la paridad. Por favor, consulte con el administrador del sistema."
	        $("#td_mensaje").html("<center><label id='label_mensaje' name='label_mensaje' style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'><b>"+str_Msg+"</b></label></center>");
	        setTimeout("$('#label_mensaje').hide(500)",5000);
		    }
      });
		}
		
		function Set_Proveedor(){
		  $("#bot_actualizar").css("visibility","hidden");
		  v_url = RutaProyecto + "funciones_SYS_AJAX/AJAX_JSON_Get_Nom_Prov_Cod_Postal.asp"
		  $.ajax({
        dataType: "json",
        type: "post",
        url: v_url,
        data: "proveedor="+$("#proveedor").val(),
        success: function(data){
          $("#nombre_proveedor").val(data.nombre_proveedor);
          $("#codigo_postal").val(data.codigo_postal);
          //console.log(data.nombre_proveedor);
          //console.log(data.codigo_postal);
          v_proveedor_actual = $("#hidden_proveedor").val();
          if($("#nombre_proveedor").val() != "" && v_proveedor_actual != $("#proveedor").val())
          {
            //Puede actualizar
            $("#bot_actualizar").css("visibility","");
          }
          else
          {
            //No Puede actualizar
            $("#bot_actualizar").css("visibility","hidden");
          }
        },
        error: function(html){
          str_Msg = "Ha ocurrido un error al intentar cargar los datos del proveedor. Por favor, consulte con el administrador del sistema."
	        $("#td_mensaje").html("<center><label id='label_mensaje' name='label_mensaje' style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'><b>"+str_Msg+"</b></label></center>");
	        setTimeout("$('#label_mensaje').hide(500)",5000);
		    }
      });
		}
		
		function Actualizar_RCP(){
		  z_tipo_cambio                             = $("#hidden_tipo_cambio").val();
		  z_numero_interno_documento_no_valorizado  = $("#hidden_numero_interno_documento_no_valorizado").val()
		  //console.log(z_tipo_cambio)
		  //console.log(z_numero_interno_documento_no_valorizado)
		  if(z_tipo_cambio)
		    v_msg = "¿Está seguro que desea actualizar la RCP con fecha de recepción ["+$("#fecha_recepcion").val()+"] y paridad ["+$("#paridad").val()+"]?"
		  if(confirm(v_msg))
		  {
		    
		    strCargando ="<br><center><img src='new_loader_000000_9B9DAA.gif' width=30 height=30 "
        strCargando+="border='0' align='top'><br><br><font color='#222222'><b>Actualizando RCP...espere un momento</b></font></center>"
			  $("#td_mensaje").html(strCargando);
		    v_url = "admin_compras_grabar.asp"
		    $.ajax({
          dataType  : "json",
          type      : "post",
          url       : v_url,
          data      : "tipo_cambio="+z_tipo_cambio+
                      "&numero_interno_documento_no_valorizado="+z_numero_interno_documento_no_valorizado+
                      "&fecha_recepcion="+$("#fecha_recepcion").val()+
                      "&paridad="+$("#paridad").val(),
          success   : function(data){
            $("#bot_actualizar").css("visibility","hidden");
            //console.log(data.accion)
            //console.log(data.valor)
            if(data.accion=="ERROR")
            {
              str_Msg = "Ha ocurrido un error al actualizar los datos. Error: "+ data.valor
	            $("#td_mensaje").html("<center><label id='label_mensaje' name='label_mensaje' style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'><b>"+str_Msg+"</b></label></center>");
	            setTimeout("$('#label_mensaje').hide(500)",5000);
            }
            else
            {//OK
              str_Msg = "&nbsp;&nbsp;&nbsp;RCP actualizada correctamente!&nbsp;&nbsp;&nbsp;"
	            $("#td_mensaje").html("<center><label id='label_mensaje' name='label_mensaje' style='font-size:12px; background-color: #FFFFFF; color:#008800;'><b>"+str_Msg+"</b></label></center>");
	            //Recargar datos RCP
	            $("#numero_interno_documento_no_valorizado").val(z_numero_interno_documento_no_valorizado)
	            Listar("actualizado")
            }
          },
          error     : function(html){
            str_Msg = "Ha ocurrido un error al intentar cargar la paridad. Por favor, consulte con el administrador del sistema."
	          $("#td_mensaje").html("<center><label id='label_mensaje' name='label_mensaje' style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'><b>"+str_Msg+"</b></label></center>");
	          setTimeout("$('#label_mensaje').hide(500)",5000);
		      }
        });
		  }
		}
		
		function Reset_Tab(x_id_td_tab){
		  color_activo    = "#FFFFFF"; color_inactivo  = "#444444"; color_border_tabla_ext = "#666666"
		  color_fondo_inactivo = "#AAAAAA"; color_fondo_hover = "#DDDDDD"
		  $("#"+x_id_td_tab).css("color",color_inactivo)
		  $("#"+x_id_td_tab).css("background-color",color_fondo_inactivo)
		  $("#"+x_id_td_tab).css("border-bottom","1px solid " + color_border_tabla_ext)
		  
		  $("#"+x_id_td_tab).off("mouseover");
		  $("#"+x_id_td_tab).off("mouseout");
		  $("#"+x_id_td_tab).off("click");
		  
      $("#"+x_id_td_tab).on({
	    	mouseover: function (){
	    		$("#"+x_id_td_tab).css("background-color",color_fondo_hover)
	    		$("#"+x_id_td_tab).css("cursor","pointer")
	    	},
	    	mouseout: function (){
	    		$("#"+x_id_td_tab).css("background-color",color_fondo_inactivo)
	    		$("#"+x_id_td_tab).css("cursor","default")
	    	},
	    	click: function (){
	    	  Config_Tabs(x_id_td_tab)
	    	}
	    });
		}
		
		function Config_Tabs(v_id_td_tab){
		  $("#td_listar").html("&nbsp;");
		  $("#td_parametros").html("&nbsp;");
		  $("#td_mensaje").html("&nbsp;");
		  $("#tab_activo").val(v_id_td_tab)
		  color_activo    = "#FFFFFF"; color_inactivo  = "#444444"; color_border_tabla_ext = "#666666"
		  color_fondo_inactivo = "#AAAAAA"; color_fondo_hover = "#DDDDDD"
		  
		  Reset_Tab("td_fecha_recepcion_y_paridad")
		  Reset_Tab("td_proveedor")
		  Reset_Tab("td_proveedor_2")
		  Reset_Tab("td_carpeta")
		  Reset_Tab("td_numero_factura")
		  
		  $("#"+v_id_td_tab).unbind("mouseover");
		  $("#"+v_id_td_tab).unbind("mouseout");
		  $("#"+v_id_td_tab).unbind("click");
		  $("#"+v_id_td_tab).css("color",color_activo)
		  $("#"+v_id_td_tab).css("background-color","")
		  $("#"+v_id_td_tab).css("cursor","default")
		  $("#"+v_id_td_tab).css("border-bottom","0px solid")
		  
		  /*
		  if($("#tab_activo").val() == "td_pagos_x_compras")
			{
		    $("#anio").attr("disabled",false)
		    $("#mes").attr("disabled",false)
		  }
		  */
		}
	</script>
</head>
<body bgcolor="#9B9DAA">
<table width="100%" cellPadding=0 cellSpacing=0 align="center" border=0><tr><td style="font-size:1px;">&nbsp;</td></tr></table>
<table style="width:1000px;" align="center" border=0 cellpadding=0 cellspacing=0>
<tr style="height: 24px;" align="center" bgcolor="#555555">
  <td style="font-size:16px; color:#FFFFFF; border-left: 1px solid <%=color_border_tabla_ext%>; border-top: 1px solid <%=color_border_tabla_ext%>; border-right: 1px solid <%=color_border_tabla_ext%>;"><b><%=titulo%></b></td>
</tr>
</table>
<table style="width:1000px;" align="center" border=0 cellpadding=0 cellspacing=0>
<tr style="height: 24px;" align="center">
	<td style="border-left: 1px solid <%=color_border_tabla_ext%>; border-top: 1px solid <%=color_border_tabla_ext%>; border-right: 1px solid <%=color_border_tabla_ext%>;">
  <table style="width:100%" border=0 cellpadding=0 cellspacing=0>
  <input type="hidden" id="tab_activo" name="tab_activo" value="td_fecha_recepcion_y_paridad">
  <tr align="center" style="height: 24px; font-weight: bold; font-size: 12px; color:#FFFFFF;">
    <td id="td_fecha_recepcion_y_paridad" name="td_fecha_recepcion_y_paridad" style="width: 200px;">Fecha y Paridad</td>
    <td id="td_proveedor" name="td_proveedor" style="width: 140px; color:#444444; border-left: 1px solid <%=color_border_tabla_ext%>; border-bottom: 1px solid <%=color_border_tabla_ext%>;">Proveedor</td>
    <td id="td_proveedor_2" name="td_proveedor_2" style="width: 140px; color:#444444; border-left: 1px solid <%=color_border_tabla_ext%>; border-bottom: 1px solid <%=color_border_tabla_ext%>;">2° Proveedor</td>
    <td id="td_carpeta"  name="td_carpeta" style="width: 140px; color:#444444; border-left: 1px solid <%=color_border_tabla_ext%>; border-bottom: 1px solid <%=color_border_tabla_ext%>;">Carpeta</td>
    <td id="td_numero_factura"  name="td_numero_factura" style="width: 140px; color:#444444; border-left: 1px solid <%=color_border_tabla_ext%>; border-bottom: 1px solid <%=color_border_tabla_ext%>;">N° Factura</td>
  </tr>
  </table>
  </td>
</tr>
<tr style="height: 24px;" align="center">
  <td style="border-left: 1px solid <%=color_border_tabla_ext%>; border-right: 1px solid <%=color_border_tabla_ext%>;">
  <table style="width:100%;" align="center" border=0 cellpadding=0 cellspacing=0>
  <tr style="height: 24px; font-size: 11px; color:#FFFFFF;">
    <td id="td_label_numero_interno_documento_no_valorizado" style="width:200px;" align="right"><b>Nro. Int. Doc. No Valorizado:</b>&nbsp;</td>
    <td style="width: 120px;" id="td_numero_interno_documento_no_valorizado">
    <input type="hidden" id="hidden_tipo_cambio" name="hidden_tipo_cambio">
    <input type="hidden" id="hidden_numero_interno_documento_no_valorizado" name="hidden_numero_interno_documento_no_valorizado">
    <input type="text" style="width:100px;" 
    OnKeyPress="return Valida_Digito(event)" maxlength=8
    id="numero_interno_documento_no_valorizado" name="numero_interno_documento_no_valorizado"></td>
	  <td><input type="button" id="bot_buscar" name="bot_buscar" value="Buscar"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td valign="top" id="td_listar" name="td_listar" style="border-left: 1px solid <%=color_border_tabla_ext%>; height: 80px; font-size: 12px; border-right: 1px solid <%=color_border_tabla_ext%>;">&nbsp;</td>
</tr>
<tr>
	<td valign="top" id="td_parametros" name="td_parametros" style="border-left: 1px solid <%=color_border_tabla_ext%>; height: 100px; font-size: 12px; border-right: 1px solid <%=color_border_tabla_ext%>;">&nbsp;</td>
</tr>
<tr>
	<td valign="top" id="td_mensaje" name="td_mensaje" style="border-left: 1px solid <%=color_border_tabla_ext%>; height: 100px; font-size: 12px; border-right: 1px solid <%=color_border_tabla_ext%>;">&nbsp;</td>
</tr>
<tr>
	<td valign="top" align="center" id="td_bot_actualizar" name="td_bot_actualizar" style="border-left: 1px solid <%=color_border_tabla_ext%>; height: 30px; font-size: 12px; border-bottom: 1px solid <%=color_border_tabla_ext%>; border-right: 1px solid <%=color_border_tabla_ext%>;">
	<input type="button" id="bot_actualizar" name="bot_actualizar" value="Actualizar" style="visibility: hidden;">
	</td>
</tr>
</table>
</body>
</html>