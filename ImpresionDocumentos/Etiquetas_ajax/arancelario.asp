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
	<script type="text/javascript" src="js/tools.js"></script>
	<script type="text/javascript">
		$(document).ready( function(){
			$('#tab-container').easytabs();/*controla el menu para que no se descuadre*/						
			Cargar_Tab('producto_arancelario.asp');
			 $(document).bind("contextmenu",function(e){
				return false;
			});
		});/*FIN .ready*/
		function selectAllRadio(){
			var dim_radio, tot_filas, i;
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
				if(v_url=="estructura_arancelario.asp")
				{
					$("#superfamilia").change(function(){
						$("#form_listar").html("");//limpio las ventanas
						$("#tope_tabla").html("");
						$("#boton_imprimir").html("");
						Cargar_Familia_X_Superfamilia($("#superfamilia").val());
					});/*Fin .change*/
					Cargar_Familia_X_Superfamilia($("#superfamilia").val());
				}
				if(v_url!="ultimocambio_arancelario.asp")
				{
					$("#bot_buscar").click(function(){
						if(v_url=="producto_arancelario.asp")
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
						else if(v_url=="estructura_arancelario.asp")
							v_tipo_busqueda = "estructura"
						else if(v_url=="numerofolio_arancelario.asp"){
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
						else if(v_url=="ultimocambio_arancelario.asp")
							v_tipo_busqueda = "ultimo_cambio"
						else if(v_url=="proveedor_arancelario.asp")
							v_tipo_busqueda = "proveedor"
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
			var v_producto, v_nombre, v_superfamilia, v_familia, v_subfamilia, v_folio, v_proveedor
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
			else if(v_tipo_busqueda=="proveedor"){
				v_proveedor=$("#proveedor").val();
			}
			else if(v_tipo_busqueda=="ultimocambio")
				$("#form_buscar").html("");//limpio las ventanas
				$("#boton_imprimir").html("");
			$.ajax({
				url: "listar_arancelario.asp",
				data: "tipo_busqueda="+v_tipo_busqueda+
				"&producto="+escape(v_producto)+
				"&nombre="+escape(v_nombre)+
				"&superfamilia="+escape(v_superfamilia)+
				"&familia="+escape(v_familia)+
				"&subfamilia="+escape(v_subfamilia)+
				"&folio="+escape(v_folio)+
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
					//$("#boton_imprimir").html("<input type='button' id='bot_imprimir' name='imprimir' value='Imprimir' onclick='imprimir_seleccion();'>");
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
				url: "familias_arancelario.asp", /*ASP para dibujar el select*/
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
				url: "subfamilias_arancelario.asp",
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
					//¬ separador de linea
					//~ separador de atributo (producto, cantidad, tipoprecio)
					//seleccionar el precio para pasar por parametro
					var tipo_precio, cantidad_imprimir;
					cantidad_imprimir	=$("#cantidad_"+i).val();
					tipo_precio			=$("input:radio[name=radio_tipo_precio_"+i+"]:checked'").val();
					precio_venta		=$("#precio_venta_"+i).val();
					precio_promocion	=$("#precio_promocion_"+i).val();
					cod_producto		=$("#cod_producto_"+i).val();
					desc_prod			=$("#desc_prod_"+i).val();
					/*Aqui se discrimina si la opcion */
					if($("#oferta_"+i).attr("checked")){
						for(j=1;j<=cantidad_imprimir;j++){
							zebra(tipo_precio, precio_promocion, cod_producto, desc_prod);
						}
					}
					if($("#imprimir_"+i).attr("checked")){
						for(k=1;k<=cantidad_imprimir;k++){
							zebra(tipo_precio, precio_venta, cod_producto, desc_prod);
						}
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
			<li><a href="javascript:Cargar_Tab('producto_arancelario.asp');" id="a_producto">&nbsp;&nbsp;&nbsp;Producto&nbsp;&nbsp;&nbsp;</a></li>
			<li><a href="javascript:Cargar_Tab('estructura_arancelario.asp');" id="a_estructura">&nbsp;&nbsp;&nbsp;Estructura&nbsp;&nbsp;&nbsp;</a></li>
			<li><a href="javascript:Cargar_Tab('proveedor_arancelario.asp');" id="a_proveedor">&nbsp;&nbsp;&nbsp;Proveedor&nbsp;&nbsp;&nbsp;</a></li>
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
</table>
</BODY>
</HTML>