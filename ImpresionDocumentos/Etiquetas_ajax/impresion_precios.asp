<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

	OpenConn_Alta
%>
<HTML>
<HEAD>
	<TITLE>Test nuevo altagestion</TITLE>
	<META NAME="Generator" CONTENT="Sanchez&Sanchez">
	<META NAME="Author" CONTENT="Sanchez&Sanchez">
	<link rel="stylesheet" type="text/css" href="css/style2.css">
	<link rel="stylesheet" type="text/css" href="css/jquery.toastmessage.css">
	<script type="text/javascript" src="js/jquery-1.7.2.js"></script>
	<script type="text/javascript" src="js/jquery.easytabs.js"></script>
	<script type="text/javascript" src="js/jquery.toastmessage.js"></script>
	<script type="text/javascript" src="js/comprobarnavegador.js"></script>
	<script type="text/javascript" src="js/tools.js"></script>
	<script type="text/javascript">
		$(document).ready( function(){
			$('#tab-container').easytabs();/*controla el menu para que no se descuadre*/						
			Cargar_Tab('producto.asp');
			 $(document).bind("contextmenu",function(e){
				return false;
			});
		});/*FIN .ready*/

		function selectAllRadio(){
			var dim_radio, tot_filas, i;
			//Faltan 2 cosas
			//correr el puntero para las dimensiones de los demas radios (fleje, gancho, grande
			//falta unchequear cuando se presiona nuevamente el radio button general
			dim_radio = 0				
			if(document.getElementsByName("todos_radio")[1].checked)
				dim_radio = 1
			else if(document.getElementsByName("todos_radio")[2].checked)
				dim_radio = 2

			tot_filas = parseFloat($("#total_filas").val());
			for (i=1; i<=tot_filas;i++)
			{			
				var radioBtns = document.getElementsByName('radio_tipo_precio_' + i);
				radioBtns[dim_radio].checked = true;
			}
		}
		function selectAllcheck(opcion){
			var tot_filas, i;
			if(opcion == 1){
				$("input[name=todos_imprimir]").change(function(){
					$('input[class=imprimir_all]').each( function() {			
						if($("input[name=todos_imprimir]:checked").length == 1 ){
							this.checked = true;
						}else {
							this.checked = false;
						}
					});
				});
			}
			if(opcion == 2){
				tot_filas = parseFloat($("#total_filas").val());
				for(i=1;i<=tot_filas;i++)
					if(!$("#oferta_"+i).attr("disabled"))
					{
						if($("#todos_oferta").attr("checked"))
							$("#oferta_"+i).attr("checked",true);
						else
							$("#oferta_"+i).attr("checked",false);
					}
			}
		}
		function Cargar_Tab(v_url){
			$("#form_buscar").html("");//limpio las ventanas
			$("#form_listar").html("");//limpio las ventanas
			$("#boton_imprimir").html("");
			$.ajax({
				url: v_url,
				async: true,
				dataType: "html"
			}).done(function(html){
				var v_tipo_busqueda;
				$("#form_buscar").html(html);
				if(v_url=="estructura.asp"){
					$("#superfamilia").change(function(){
						$("#form_listar").html("");//limpio las ventanas
						$("#tope_tabla").html("");
						$("#boton_imprimir").html("");
						Cargar_Familia_X_Superfamilia($("#superfamilia").val());
					});/*Fin .change*/
					Cargar_Familia_X_Superfamilia($("#superfamilia").val());
				}
				if(v_url!="ultimocambio.asp")
				{
					$("#bot_buscar").click(function(){
						if(v_url=="producto.asp")
						{
							if($("#producto").val()=="" && $("#nombre").val() ==""){
								$().toastmessage('showToast', {
									text:'Los campos no pueden estar vacios',
									sticky   : false,
									position : 'middle-center',
									type     : 'error'
								});
								return;
							}
							v_tipo_busqueda = "producto"
						}
						else if(v_url=="estructura.asp")
							v_tipo_busqueda = "estructura"
						else if(v_url=="numerofolio.asp"){
							if($("#folio").val()==""){
								$().toastmessage('showToast', {
									text:'Los campos no pueden estar vacios',
									sticky   : false,
									position : 'middle-center',
									type     : 'error'
								});
								return;
							}
							v_tipo_busqueda = "folio"
						}
						else if(v_url=="ultimocambio.asp")
							v_tipo_busqueda = "ultimo_cambio"
						else if(v_url=="proveedor.asp")
							v_tipo_busqueda = "proveedor"
						else if(v_url=="numeroguia.asp")
							v_tipo_busqueda = "numeroguia"
						Listar(v_tipo_busqueda);
					});
				}
			});/*fin del done*/
		}/*Fin del function*/
		function Listar(v_tipo_busqueda){
			var strCargando, tot_filas, total_promociones, solo_promocion
			solo_promocion	= "NO"
			strCargando = "<br><br><center><img src='images/ajax-loader.gif' width=32 heigth=32 border=0>"
			strCargando+= "<br><br><label style='font-size:12px; color:#444444;'><b>Listando productos...</b><label></center>"
			$("#form_listar").html(strCargando);
			var v_producto, v_nombre, v_superfamilia, v_familia, v_subfamilia, v_folio, v_proveedor, v_numeroguia
			if(v_tipo_busqueda=="producto")
			{
				v_producto	= $("#producto").val()
				v_nombre	= $("#nombre").val()
			}
			else if(v_tipo_busqueda=="estructura")
			{
				v_superfamilia	= $("#superfamilia").val()
				v_familia		= $("#familia").val()
				v_subfamilia	= $("#subfamilia").val()
				if($("#check_solo_promocion").attr("checked"))
					solo_promocion = "SI"
			}
			else if(v_tipo_busqueda=="folio"){
				v_folio	= $("#folio").val();
			}
			else if(v_tipo_busqueda=="numeroguia"){
				v_numeroguia	= $("#numeroguia").val();
			}
			else if(v_tipo_busqueda=="ultimocambio")
				$("#form_buscar").html("");//limpio las ventanas
				$("#boton_imprimir").html("");
			$.ajax({
				url: "listar.asp",
				data: "tipo_busqueda="+v_tipo_busqueda+
				"&producto="+escape(v_producto)+
				"&nombre="+escape(v_nombre)+
				"&superfamilia="+escape(v_superfamilia)+
				"&familia="+escape(v_familia)+
				"&subfamilia="+escape(v_subfamilia)+
				"&folio="+escape(v_folio)+
				"&numeroguia="+escape(v_numeroguia)+
				"&proveedor="+escape(v_proveedor)+
				"&solo_promocion="+solo_promocion,
				type: "POST",
				async: true,
				dataType: "html"
			}).done(function(html){
				$("#form_listar").html(html);
				tot_filas = parseFloat($("#total_filas").val());
				if(tot_filas > 0)
				{
					document.getElementsByName("todos_radio")[0].checked = true
					selectAllRadio();
					$("#boton_imprimir").html("<input type='button' id='bot_imprimir' name='imprimir' value='Imprimir' onclick='imprimir_seleccion();'>");
					$("#todos_cantidad").keyup(function(event){
						if(event.which == 13){
							tot_filas = parseFloat($("#total_filas").val());
							var value = $("#todos_cantidad").val();
							for (i=1; i<=tot_filas;i++){			
								$("#cantidad_"+i).val(value);
							}
						}
					});
					$("#todos_oferta").attr("disabled",true)
					total_promociones = parseFloat($("#total_promociones").val());
					if(total_promociones > 0)
						$("#todos_oferta").attr("disabled",false)
				}
				else
				{
					$().toastmessage('showToast', {
						text:'No se encontraron coincidencias',
						sticky   : false,
						position : 'middle-center',
						type     : 'Notice'
					});
					$("#form_listar").html("");
				}
			});/*fin del done*/
		}/*Fin del function*/

		function Cargar_Familia_X_Superfamilia(x_superfamilia){
			$("#form_listar").html("");//limpio las ventanas
			var v_familia, v_superfamilia;
			$.ajax({
				url: "familias.asp", /*ASP para dibujar el select*/
				data: "superfamilia="+x_superfamilia, /*variable que le entrego*/
				type: "POST", /*metodo*/
				async: true,
				dataType: "html", /*tipo de documento para recibir la data*/
			}).done(function( html ){
			  $("#div_familia").html(html);
			  $("#familia").change(function(){
					v_superfamilia = $("#superfamilia").val()
					v_familia = $("#familia").val()
					Cargar_Subfamilia_X_Familia_X_Superfamilia(v_superfamilia, v_familia)
			  });/*Fin .Change*/
				v_superfamilia = $("#superfamilia").val()
				v_familia = $("#familia").val()
				Cargar_Subfamilia_X_Familia_X_Superfamilia(v_superfamilia, v_familia)
			});/*Fin del Done*/
		}/*Fin Function Cargar_Familia*/
		function Cargar_Subfamilia_X_Familia_X_Superfamilia(x_superfamilia, x_familia){
			$("#form_listar").html("");//limpio las ventanas
			$("#boton_imprimir").html("");
			$.ajax({
				url: "subfamilias.asp",
				data: "superfamilia="+x_superfamilia+"&familia="+x_familia,
				type: "POST",
				async: true,
				dataType: "html",
			}).done(function(data){
				$("#div_subfamilia").html(data);
			});/*fin .done*/
		}/*Fin Cargar_subfamilia*/
		function imprimir_seleccion(){
			var imprimir_marcados=0;
			tot_filas = parseFloat($("#total_filas").val());
			for(i=1;i<=tot_filas;i++){
				if($("#imprimir_"+i).attr("checked")){
					var tipo_precio, cantidad_imprimir;
					cantidad_imprimir	=$("#cantidad_"+i).val();
					tipo_precio			=$("input:radio[name=radio_tipo_precio_"+i+"]:checked'").val();
					precio_venta		=$("#precio_venta_"+i).val();
					cod_producto		=$("#cod_producto_"+i).val();
					desc_prod			=$("#desc_prod_"+i).val();
					if(cantidad_imprimir == ""){
						$().toastmessage('showToast', {
							text:'La cantidad de etiquetas a imprimir debe ser mas que 1.',
							sticky   : false,
							position : 'middle-center',
							type     : 'error'
						});
						break;
					}
					if($("#imprimir_"+i).attr("checked")){
						oferta="no";
						for(k=1;k<=cantidad_imprimir;k++){
							zebra(tipo_precio, precio_venta, cod_producto, desc_prod, oferta);
						}
					}			
				}
				if($("#oferta_"+i).attr("checked")){
					var tipo_precio, cantidad_imprimir;
					cantidad_imprimir	=$("#cantidad_"+i).val();
					tipo_precio			=$("input:radio[name=radio_tipo_precio_"+i+"]:checked'").val();
					precio_promocion	=$("#precio_promocion_"+i).val();
					cod_producto		=$("#cod_producto_"+i).val();
					desc_prod			=$("#desc_prod_"+i).val();
					if(cantidad_imprimir == ""){
						$().toastmessage('showToast', {
							text:'La cantidad de etiquetas a imprimir debe ser mas que 1.',
							sticky   : false,
							position : 'middle-center',
							type     : 'error'
						});
						break;
					}
					if($("#oferta_"+i).attr("checked")){
						oferta="si";
						for(j=1;j<=cantidad_imprimir;j++){
							zebra(tipo_precio, precio_promocion, cod_producto, desc_prod, oferta);
						}
					}
				}
			}	
		}
		function zebra(tipo_precio, precio, cod_producto, desc_prod, oferta){
			if(tipo_precio == "fleje"){
				tamagno=precio.length;
				precio2 = precio.replace(",",".");
				precio3 = precio2.replace(",",".");
				if(oferta=="si"){
					if(tamagno>6){
						var etiquetas = "\""+"^XA^FO220,60^ARN,130,135^FD"+precio3+"^FS^FO350,190^ARN,2,2^FD"+cod_producto+"^FS^FO200,230^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraFleje"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno==6){
						var etiquetas = "\""+"^XA^FO270,20^ARN,200,150^FD"+precio3+"^FS^FO350,190^ARN,2,2^FD"+cod_producto+"^FS^FO200,230^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraFleje"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();/*se imprime*/
					}
					if(tamagno<6){
						var etiquetas = "\""+"^XA^FO320,20^ARN,200,150^FD"+precio3+"^FS^FO350,190^ARN,2,2^FD"+cod_producto+"^FS^FO200,230^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraFleje"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();/*se imprime*/
					}
				}
				else{
					if(tamagno>6){
						var etiquetas = "\""+"^XA^FO220,50^ARN,150,125^FD"+precio3+"^FS^FO350,190^ARN,2,2^FD"+cod_producto+"^FS^FO200,230^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraFleje"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno==6){
						var etiquetas = "\""+"^XA^FO270,20^ARN,200,150^FD"+precio3+"^FS^FO350,190^ARN,2,2^FD"+cod_producto+"^FS^FO200,230^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraFleje"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();/*se imprime*/
					}
					if(tamagno<6){
						var etiquetas = "\""+"^XA^FO320,20^ARN,200,150^FD"+precio3+"^FS^FO350,190^ARN,2,2^FD"+cod_producto+"^FS^FO200,230^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraFleje"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();/*se imprime*/
					}
				}
			}
			if(tipo_precio=="gancho"){
				tamagno=precio.length;
				precio2 = precio.replace(",",".");
				precio3 = precio2.replace(",",".");
				if(oferta=="si"){
					if(tamagno>=6){
						var etiquetas = "\""+"^XA^FO100,30^ARN,130,100^FD"+precio3+"^FS^FO150,150^ARN,2,2^FD"+cod_producto+"^FS^FO60,200^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGancho"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno<6){
						var etiquetas = "\""+"^XA^FO100,30^ARN,130,130^FD"+precio3+"^FS^FO150,150^ARN,2,2^FD"+cod_producto+"^FS^FO60,200^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGancho"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
				}
				else{
					if(tamagno>6){
						var etiquetas = "\""+"^XA^FO100,5^ARN,130,110^FD"+precio3+"^FS^FO150,150^ARN,2,2^FD"+cod_producto+"^FS^FO60,200^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGancho"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno==6){
						var etiquetas = "\""+"^XA^FO100,5^ARN,150,130^FD"+precio3+"^FS^FO150,150^ARN,2,2^FD"+cod_producto+"^FS^FO60,200^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGancho"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno<6){
						var etiquetas = "\""+"^XA^FO100,5^ARN,150,150^FD"+precio3+"^FS^FO150,150^ARN,2,2^FD"+cod_producto+"^FS^FO60,200^A0,17,17^FD"+desc_prod+"^FS^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGancho"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
				}
			}
			if(tipo_precio=="grande"){
				tamagno=precio.length;
				precio2 = precio.replace(",",".");
				precio3 = precio2.replace(",",".");
				if(oferta=="si"){
					if(tamagno>=9){
						var etiquetas = "\""+"^XA^FO140,350^ARN,250,170^FD"+precio3+"^FS^FO600,730^A0,30,30^FD"+cod_producto+"^FS^FO30,650^ARN,2,2^FD"+desc_prod+"^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGrande"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno==7){
						var etiquetas = "\""+"^XA^FO110,350^ARN,300,230^FD"+precio3+"^FS^FO600,730^A0,30,30^FD"+cod_producto+"^FS^FO30,650^ARN,2,2^FD"+desc_prod+"^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGrande"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno==6){
						var etiquetas = "\""+"^XA^FO120,350^ARN,300,230^FD"+precio3+"^FS^FO600,730^A0,30,30^FD"+cod_producto+"^FS^FO30,650^ARN,2,2^FD"+desc_prod+"^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGrande"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno==5){
						var etiquetas = "\""+"^XA^FO120,350^ARN,300,230^FD"+precio3+"^FS^FO600,730^A0,30,30^FD"+cod_producto+"^FS^FO30,650^ARN,2,2^FD"+desc_prod+"^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGrande"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno<5){
						console.log("grande, oferta, menor a 5");
						var etiquetas = "\""+"^XA^FO200,350^ARN,300,230^FD"+precio3+"^FS^FO600,730^A0,30,30^FD"+cod_producto+"^FS^FO30,650^ARN,2,2^FD"+desc_prod+"^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGrande"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
				}
				else{
					if(tamagno>=9){
						var etiquetas = "\""+"^XA^FO120,450^ARN,250,170^FD"+precio3+"^FS^FO610,790^A0,30,30^FD"+cod_producto+"^FS^FO30,720^ARN,2,2^FD"+desc_prod+"^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGrande"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print(); /*se imprime*/
					}
					if(tamagno==7){
						var etiquetas = "\""+"^XA^FO120,430^ARN,300,230^FD"+precio3+"^FS^FO610,790^A0,30,30^FD"+cod_producto+"^FS^FO30,720^ARN,2,2^FD"+desc_prod+"^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGrande"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno==6){
						var etiquetas = "\""+"^XA^FO120,430^ARN,300,230^FD"+precio3+"^FS^FO610,790^A0,30,30^FD"+cod_producto+"^FS^FO30,720^ARN,2,2^FD"+desc_prod+"^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGrande"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno==5){
						var etiquetas = "\""+"^XA^FO120,430^ARN,300,260^FD"+precio3+"^FS^FO610,790^A0,30,30^FD"+cod_producto+"^FS^FO30,720^ARN,2,2^FD"+desc_prod+"^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGrande"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
					if(tamagno<5){
						var etiquetas = "\""+"^XA^FO200,430^ARN,300,260^FD"+precio3+"^FS^FO610,790^A0,30,30^FD"+cod_producto+"^FS^FO30,720^ARN,2,2^FD"+desc_prod+"^XZ"+"\"";
						document.jzebra.findPrinter("ZebraGrande"); /*busco la impresora por nombre*/
						document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/ 
						document.jzebra.print();		      /*se imprime*/
					}
				}
			}			
		}
	</script>
</HEAD>
<BODY bgcolor="#DDDDDD">
<!--<div id="boxmenutop">
</div>-->
<!-- Menu del medio el cual controla las opciones que queremos consultar-->
<div id="boxmenumiddle">
	<div id="menuhorizontal" class='menuhorizontal'>
		<ul id="nav">
			<li><a href="javascript:Cargar_Tab('producto.asp');" id="a_producto">&nbsp;&nbsp;&nbsp;Producto&nbsp;&nbsp;&nbsp;</a></li>
			<li><a href="javascript:Cargar_Tab('estructura.asp');" id="a_estructura">&nbsp;&nbsp;&nbsp;Estructura&nbsp;&nbsp;&nbsp;</a></li>
			<li><a href="javascript:Cargar_Tab('numerofolio.asp');">&nbsp;&nbsp;&nbsp;Numero Folio&nbsp;&nbsp;&nbsp;</a></li>
			<li><a href="javascript:Listar('ultimocambio');">&nbsp;&nbsp;&nbsp;Ultimo cambio precio&nbsp;&nbsp;&nbsp;</a></li>
			<li><a href="javascript:Cargar_Tab('numeroguia.asp');">&nbsp;&nbsp;&nbsp;Numero Guia&nbsp;&nbsp;&nbsp;</a></li>
			<!-- <li><a href="javascript:Cargar_Tab('proveedor.asp');">Proveedor</a></li> -->
		</ul>
	</div>
</div>
<table align="center">
<tr>
	<td>
		<div id="form_buscar"></div>
	</td>
</tr>
<tr>
	<td>
		<div id="form_listar"></div>
	</td>
</tr>
<tr align="center">
	<td><div id="boton_imprimir"></div></td>
</tr>
</table>
<applet name="jzebra" id="jzebra" code="jzebra.PrintApplet.class" archive="js/jzebra.jar" width="1" height="1">
      <param name="printer" value="zebra">
</applet>
</BODY>
</HTML>