<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<html>
<head>
<style type="text/css" media="print">
@media print {
  /*
  #bot_imprimir {display:none;}
  #tabla_titulos {display:none;}
  #tabla_filtros {display:none;}
  #td_banner_reporte {
    background-image:url(../imagenes/Header_1024X112.jpg);
  }
  #table_enc{
    border: 0px #FFFFFF;
    width: 800px;
  }
  */
  #bot_imprimir {display:none;}
  #Selector {display:none;}
}
</style>
<style type="text/css">
/*
body{
  font-family:Arial;
}
*/

#label_15X21_precio{
  display:inline-block;
  -webkit-transform:scale(1,2);
  -moz-transform:scale(1,2);
  -ms-transform:scale(1,2);
  font-size:200px; 
  font-family:Britannic Bold;
  /*font-weight:bold;*/
  
  /*
  -webkit-transform: rotate(-90deg);
  -moz-transform: rotate(-90deg);
  -ms-transform: rotate(-90deg);
  -o-transform: rotate(-90deg);
  transform: rotate(-90deg);
  */
}

#label_15X21_descripcion{
  display:inline-block;
  -webkit-transform:scale(1,2);
  -moz-transform:scale(1,2);
  -ms-transform:scale(1,2);
  font-size:24px; 
  font-family:Britannic Bold;
}

#label_15X21_codigo{
  display:inline-block;
  -webkit-transform:scale(1,2);
  -moz-transform:scale(1,2);
  -ms-transform:scale(1,2);
  font-size:24px; 
  font-family:Britannic Bold;
}
</style>
<script type="text/javascript" src="<%=RutaProyecto%>js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="<%=RutaProyecto%>js/tools.js"></script>
<script type="text/javascript">
$(document).ready( function(){ 
  $("#bot_buscar").click(function(){
    if($("#codigo").val() == "")
    {
      alert("Ingrese un código")
      $("#codigo").focus()
    }
    else
      Cargar_Precio();}
  );
});
  
function Imprimir(){
  window.print();
}

function Cargar_Precio(){
  $.
  ajax({
    url:  "impresion_precios_listar.asp",
    data: "tipo_precio=" + $("#tipo_precio").val() + "&codigo=" + $("#codigo").val(),
    type: "POST",
    async:true,
    dataType: "html",
    success: function(html){
      $("#td_precio").html(html);
    },
    error: function(html){
      //$("#td_camion").html("<br><br><center><b><label style='font-size:12px; background-color: #FFFFFF; color:#AA0000;'>Ha ocurrido un error al buscar los datos. Por favor, consulte con el administrador del sistema.</label></b></center>");
    }
  });
}
</script>
</head>
<body>
<input type="button" id="bot_imprimir" name="bot_imprimir" value="Imprimir" Onclick="Imprimir()">
<br>
<table align="center" width="600px;" border=0>
<tr>
  <td style="width:100px;" align="right">Tipo precio:&nbsp;</td>
  <td style="width:90px;"><select id="tipo_precio" name="tipo_precio" style="width:80px;">
    <option value="15X21">15 X 21</option>
    <option value="31X12">31 X 12</option>
  </select></td>
  <td style="width:60px;" align="right">Código:&nbsp;</td>
  <td style="width:100px;"><input type="text" id="codigo" name="codigo" style="width:100px; font-size:14px;"></td>
  <td style="width:70px;"><input type="button" id="bot_buscar" name="bot_buscar" value="Buscar" style="width:100px; font-size:12px;"></td>
  <td>&nbsp;</td>
</tr>
</table>
<table align="center" width="600px;" border=0>
<tr>
  <td id="td_precio"></td>
</tr>
</table>
</body>
</html>