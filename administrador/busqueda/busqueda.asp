<%
titulo = "Buscar productos"
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
	<script type="text/javascript" src="<%=RutaProyecto%>js/jquery-1.7.2.js"></script>
	<script type="text/javascript" src="<%=RutaProyecto%>js/tools.js"></script>
	<script type="text/javascript">
		$(document).ready( function(){ 
			/*
      $("#bot_buscar").click(function(){
			  Listar("")
			});
      */
      $("#nombre_codigo").on({
        keyup: function (event){
          if (event.which==13)
            Listar("")
        }
      });
      $("input:radio[name=tipo_busqueda]").on({
        click: function (event){
          $("#nombre_codigo").val("");
          $("#td_listar").html("&nbsp;");
        }
      });
      $("#label_codigo").on({
        mouseover: function (event){
          $("#label_codigo").css("cursor","pointer");
        },
        click: function (event){
          $("#nombre_codigo").val("");
          $("input:radio[value=codigo]").attr("checked",true)
          $("#td_listar").html("&nbsp;");
        }
      });
      $("#label_nombre").on({
        mouseover: function (event){
          $("#label_nombre").css("cursor","pointer");
        },
        click: function (event){
          $("#nombre_codigo").val("");
          $("input:radio[value=nombre]").attr("checked",true)
          $("#td_listar").html("&nbsp;");
        }
      });
      
			$("#nombre_codigo").val("")
      $("#nombre_codigo").focus()
		});
		
		function Listar(){
      w_screen = window.screen.availWidth
      if($("#nombre_codigo").val() == "")
        return;
      
      if(parseInt($("#nombre_codigo").val().length) < 4)
      {
        $("#td_listar").html("<br><center><b>Ingrese al menos 4 caracteres para poder realizar la búsqueda</center></b>");
        return
      }
      $("#td_listar").html("&nbsp;");
      
		  strCargando ="<br><center><img src='new_loader_000000_9B9DAA.gif' width=30 height=30 "
      strCargando+="border='0' align='top'><br><br><font color='#222222'><b>Buscando...espere un momento</b></font></center>"
			$("#td_listar").html(strCargando);
      $("#para_focus").focus()
      
      v_url = "busqueda_detalle.asp"
      if($("input:radio[name=tipo_busqueda]:checked").val() == "nombre")
        v_url = "busqueda_listar.asp"
			$.ajax({
				url: v_url,
				data: "nombre_codigo=" + escape($("#nombre_codigo").val()) + 
        "&tipo_busqueda=" + $("input:radio[name=tipo_busqueda]:checked").val() + "&w_screen=" + w_screen,
				type: "POST",
				async: true,
				dataType: "html",
				success: function(html){
				  $("#td_listar").html(html);
		    },
		    error: function(html){
		      $("#td_listar").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al buscar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
		    }
			});
		}
    
    function Set_Busqueda_Codigo(v_producto){
      $("input:radio[value=codigo]").attr("checked",true)
      $("#nombre_codigo").val(v_producto)
      Listar();
    }
	</script>
</head>
<body bgcolor="#9B9DAA">
<table width="100%" cellPadding=0 cellSpacing=0 align="center" border=0><tr><td style="font-size:1px;">&nbsp;</td></tr></table>
<table style="width:500px;" align="center" border=0 cellpadding=0 cellspacing=0>
<tr style="height: 24px;" align="center">
  <td style="border: 1px solid <%=color_border_tabla_ext%>;">
  <table style="width:100%;" align="center" border=0 cellpadding=0 cellspacing=0>
  <tr style="font-size: 11px; color:#FFFFFF;">
    <td style="width:40px;">&nbsp;</td>
    <td style="width:24px;"><input id="tipo_busqueda" name="tipo_busqueda" type="radio" value="codigo" checked></td>
    <td style="width:80px;"><b><label id="label_codigo" name="label_codigo">Código</label><b></td>
    <td style="width:24px;"><input id="tipo_busqueda" name="tipo_busqueda" type="radio" value="nombre"></td>
    <td style="width:80px;"><b><label id="label_nombre" name="label_nombre">Nombre</label><b></td>
    <td style="width:230px;"><input type="text" style="width:140px;" OnKeyPress="//return Valida_AlfaNumerico(event)" maxlength=15 id="nombre_codigo" name="nombre_codigo"></td>
	  <!--<td style="width:120px;"><input type="button" id="bot_buscar" name="bot_buscar" value="Buscar"></td>-->
    <td style="width:40px;"><input type="text" readonly id="para_focus" name="para_focus" style="width:5px; border:0px; background-color:#9B9DAA;"></td>
	</tr>
	</table>
	</td>
</tr>
<tr>
	<td valign="top" id="td_listar" name="td_listar" style="border: 1px solid <%=color_border_tabla_ext%>; height: 520px; font-size: 12px;">&nbsp;</td>
</tr>
</table>
</body>
</html>