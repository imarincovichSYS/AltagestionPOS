<%
titulo = "Informe Recepciones"
Session("Nombre_Aplicacion") = titulo
%>
<!--#include file="../../../_private/config.asp" -->
<!--#include file="../../../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
color_border = "#999"
color_text_th = "#FFFFFF"
color_text_td = "#444444" 
color_border_tabla_ext = "#666666"

fecha_hoy = Replace(date(),"/","-")
mes_actual = month(fecha_hoy)
%>
<html>
<head>
<script type="text/javascript">
var RutaProyecto = "<%=RutaProyecto%>"
var fecha_hoy = "<%=fecha_hoy%>"
var mes_actual = "<%=mes_actual%>"
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
  
  input[type="button"]#bot_generar{
  	border-radius: 4px;
  	-moz-border-radius: 4px;
  	-webkit-border-radius: 4px;            
  	background: url(check_white_13X12.png) no-repeat left #5c5c5c;
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
  
  input[type="button"]#bot_generar:hover{
  	text-align: right;
  	background: url(check_white_13X12.png) no-repeat left #b8b8b8;
  	background-size: 16px 16px;
  	height: 20px;
  	border: 1px solid #242424;
  	color:#f7f7f7;
  	font-weight: bold;
  }  
	</style>
	<script type="text/javascript" src="<%=RutaProyecto%>js/jquery-1.7.2.js"></script>
	<script type="text/javascript" src="<%=RutaProyecto%>js/tools.js"></script>
	<script type="text/javascript">
		$(document).ready( function(){ 
      $("#mes").val(mes_actual)
      Cargar_Camion_X_Mes_y_Anio();
      
      $("#anio").change(function(){
          Cargar_Camion_X_Mes_y_Anio();
                                          $("#Numero_documento_respaldo").val(0)
      });
      $("#mes").change(function(){Cargar_Camion_X_Mes_y_Anio();
                                          $("#Numero_documento_respaldo").val(0)
      });

      $("#bot_generar").click(function(){Generar_Informe();});
      
      $("#check_solo_dif").attr("checked","checked");
		});
    
    function Cargar_Camion_X_Mes_y_Anio(){
      $("#bot_generar").attr("disabled",true);
			$.ajax({
				url: "descarga_camion_camiones_x_mes_y_anio.asp",
				data: "documento_respaldo=" + $("#documento_respaldo").val() + 
              "&anio=" + $("#anio").val()+
              "&mes=" + $("#mes").val()+
              "&Numero_documento_respaldo=" + $("#Numero_documento_respaldo").val(),
				type: "POST",
				async: true,
				dataType: "html",
				success: function(html){
				  $("#td_camion").html(html);
          if($("#camion option:selected" ).text() != "")
            $("#bot_generar").attr("disabled",false);
		    },
		    error: function(html){
		      $("#td_camion").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al buscar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
		    }
			});
		}
    
    function Generar_Informe(){
      //------------------------------------------
      k_currentTime = new Date()
      k_year    = k_currentTime.getFullYear().toString()
      k_month   = k_currentTime.getMonth().toString()
      k_day     = k_currentTime.getDate().toString()

      k_hours   = k_currentTime.getHours().toString()
      k_minutes = k_currentTime.getMinutes().toString()
      k_seconds = k_currentTime.getSeconds().toString()

      k_fecha_hora = k_year.toString() +"-" + k_month + "-" + k_day + "_" + k_hours +"-" + k_minutes + "-" + k_seconds
      v_check_solo_dif = 0
      if($("#check_solo_dif").is(':checked'))
        v_check_solo_dif = 1
      //------------------------------------------
      
      parametros = "documento_respaldo=" + $("#documento_respaldo").val() + 
                   "&anio=" + $("#anio").val() +
                   "&mes=" + $("#mes").val() +
                   "&camion=" + $("#camion").val() + 
                   "&check_solo_dif=" + v_check_solo_dif + 
                   "&fecha_hora="+k_fecha_hora+
                   "&Numero_documento_respaldo="+$("#Numero_documento_respaldo").val()       
      ruta_informe = "descarga_camion_informe.asp"
      
      var h = (screen.availHeight - 36), w = (screen.availWidth - 10),  x = 0 , y = 0
      str = "width=" + w + ", height=" + h + ", screenX=" + x + ", screenY=" + y + ", left=" + x + ", top=" + y + ", scrollbars=3,  menubar=no, toolbar=no, status=no"
      WinInforme = open(ruta_informe + "?" + parametros, "_top", str, "replace=1") // Se cambio "Inf" por "_top" para que no se abra el informe en nueva ventana
    }
	</script>
</head>
<body bgcolor="#9B9DAA">
<br><br>
<table width="100%" cellPadding=0 cellSpacing=0 align="center" border=0><tr><td style="font-size:1px;">&nbsp;</td></tr></table>
<table style="width:600px;" align="center" border=0 cellpadding=0 cellspacing=0>
<tr style="height: 24px;" align="center">
  <td style="border: 1px solid <%=color_border_tabla_ext%>;">
  <table style="width:100%;" align="center" border=0 cellpadding=0 cellspacing=0>
  <tr style="color:#222222; font-weight: bold; font-size:28px; height: 100px;">
    <td align="center">Informe de Recepciones<br>(etiquetado de bultos)</td>
  </tr>
  </table>
  <table style="width:100%;" align="center" border=0 cellpadding=0 cellspacing=0>
  <tr style="font-size: 11px; color:#FFFFFF; font-weight: bold; font-size:14px; height: 60px;">
    <td style="width:60px;" align="right">Doc.:&nbsp;</td>
    <td style="width:60px;">
    <select id="documento_respaldo" name="documento_respaldo" style="width:50px; font-size:16px; font-weight:bold;">
      <option value="R">R</option>
      <option value="TU">TU</option>
      <option value="Z">Z</option>
    </select>
    </td>
    <td style="width:60px;" align="right">Año:&nbsp;</td>
    <td style="width:70px;" id="td_anio" name="td_anio">
    <select id="anio" name="anio" style="width: 60px;">
    <%v_anio = year(date())
    for i=2014 to year(date())%>
      <option value="<%=v_anio%>"><%=v_anio%></option>
    <%v_anio = v_anio - 1
    next%>
    </select></td>
    <td style="width:60px;" align="right">Mes:&nbsp;</td>
    <td style="width:140px;" id="td_mes" name="td_mes">
    <select id="mes" name="mes" style="width:120px;">
    <%for i=1 to 12%>
      <option value="<%=i%>"><%=getMes(i)%></option>
    <%next%>
    
    </select></td>
    <td style="width:60px;" align="right">Transporte:&nbsp;</td>
    <td style="width:60px;" id="td_camion" name="td_camion"></td>
    <td>&nbsp;</td>
   

	</tr>
	</table>
  
  <table>
    <tr style="font-size: 11px; color:#FFFFFF; font-weight: bold; font-size:14px;">
      <td style="width:30px;" align="right">Documento:</td>
      <td style="width:30px;" id="td_Numero_documento_respaldo" name="td_Numero_documento_respaldo"></td>
      <td><input style="width:50px; text-align: right;" type="text" name="Numero_documento_respaldo" id="Numero_documento_respaldo" value="0" /></td>
    </tr>
  </table>

  <table style="width:100%;" align="center" border=0 cellpadding=0 cellspacing=0>
  <tr style="color:#222222; font-weight: bold; font-size:12px; height: 30px;">
    <td align="center"><input type="checkbox" id="check_solo_dif" name="check_solo_dif">Sólo cantidades descuadradas</td>
  </tr>
  </table>
  <table style="width:100%;" align="center" border=0 cellpadding=0 cellspacing=0>
  <tr style="font-size: 11px; color:#FFFFFF; font-weight: bold; font-size:14px; height: 30px;">
    <td>&nbsp;</td>
    <td style="width:100px;">
    <input type="button" id="bot_generar" name="bot_generar" value="Generar informe">
    </td>
    <td>&nbsp;</td>
  </tr>
  </table>
  </td>
</tr>
</table>
</body>
</html>