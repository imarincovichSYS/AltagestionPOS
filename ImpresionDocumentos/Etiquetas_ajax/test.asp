<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
	OpenConn_Alta_Replica
%>
<HTML>
<HEAD>
	<TITLE>Test nuevo altagestion</TITLE>
	<meta charset="utf-8">﻿
	<META NAME="Generator" CONTENT="Sanchez&Sanchez">
	<META NAME="Author" CONTENT="Sanchez&Sanchez">
	<link rel="stylesheet" type="text/css" href="css/blue.css">
	<script type="text/javascript" src="js/jquery-1.7.2.js"></script>
	<script type="text/javascript" src="js/jquery.color.js"></script>
	<script type="text/javascript" src="js/jquery.hashchange.min.js" ></script>
	<script type="text/javascript" src="js/jquery.easytabs.js"></script>
	<script type="text/javascript">
		
		var v_id_buscar_x_cod_desc;
		var v_desc_buscar_x_cod_desc;
		$(document).ready( function(){
			$('#tab-container').easytabs();/*controla el menu para que no se descuadre*/						
		});/*FIN .ready*/
		function buscar_x_cod_desc(){
			var url = "buscar_x_cod_x_desc.asp";
			v_id_buscar_x_cod_des = $("#id_buscar_x_cod_desc").val()
			v_desc_buscar_x_cod_desc = $("#desc_buscar_x_cod_desc").val()
			$.ajax({
				url: url,
				data: "id_buscar_x_cod_desc="+v_id_buscar_x_cod_desc+"&desc_buscar_x_cod_desc="+v_desc_buscar_x_cod_desc,
				type: "POST",
				async: true,
				dataType: "html",
				succes:
				function(data){
					$("#div_buscar_x_cod_desc").html(data);
				}
			});/*FIN Ajax*/
		}/*FIN function buscar_x_cod_desc*/	
	</script>
</HEAD>
<body>
<!-- INICIO DEL MENU -->
<div class="degradado">
	<table class="styled-table">
		<tr>
			<td class="titulocab" align="right">
				EMPRESA:
			</td>
			<td>
				<div class="styled-select">
					<select id="test" name="test">
						<option value="1">JARDIN</option>
						<option value="2">SYSCHILE</option>
					</select>
				</div>
			</td>
			<td class="titulocab" align="right">
				A&Ntilde;O:
			</td>
			<td>
				<div class="styled-select">
					<select id="buscar_anio" name="buscar_anio">
						<%
							v_anio = year(date())
							for i=2009 to year(date())
						%>
							<option value="<%=v_anio%>"><%=v_anio%></option>
						<%v_anio = v_anio - 1
						next%>
					</select>
				</div>
			</td>
			<td class="titulocab" align="right">
				MES:
			</td>
			<td colspan=2>
				<div class="styled-selectM">
					<select id="buscar_mes" name="buscar_mes">
						<%for i=1 to 12%>
							<option value="<%=i%>"<%if i=month(date()) then%>selected<%end if%>><%=Ucase(GetMes(i))%></option>
						<%next%>
					</select>
				</div>
			</td>
			<td>
				<input type="button" id="transition" name="mostrar" value="Mostrar"/>
			</td>
			<td class="titulocab" align="right">
				BUSCAR:
			</td>
			<td>
				<input type="text" class="resizedTextbox" />&nbsp;<input type="button" id="transition" name="buscar" value="Buscar"/>
			</td>
		</tr>
	</table>
</div>
<!-- FIN DEL MENU -->
<!-- COMIENZO DEL BODY-->
<div id="boxinfo">
	<table align="right"><!-- INICIO Seleccion de la lista -->
		<tr>
			<td>
				<div id="textomenujq">
					Seleccione Lista:
				</div>
			</td>
			<td>
				<select id="buscar_lista" name="buscar_lista">
					<option value="lista1">Lista 1</option>
					<option value="lista2">Lista 2</option>
				</select>
			</td>
		</tr>
	</table><!-- FIN Seleccion de la lista -->
	<div id="tab-container" class='tab-container'>
		<ul class='etabs'>
			<li class='tab'><a href="#tabs1-prod">Producto</a></li>
			<li class='tab'><a href="#tabs1-estr">Estructura</a></li>
			<li class='tab'><a href="#tabs1-nume">Numero Folio</a></li>
			<li class='tab'><a href="#tabs1-ulti">Ultimo cambio precio</a></li>
			<li class='tab'><a href="#tabs1-prov">Proveedor</a></li>
		</ul>
		<div class='panel-container'>
			<div id="tabs1-prod">
				<h2>Ingrese los datos</h2>
				<table>
					<tr>
						<td>
							<div id="textomenujq">
								Codigo:
							</div>
						</td>
						<td>
							<input type="text" class="input" id="id_buscar_x_cod_desc" name="id_buscar_x_cod_desc">
						</td>
						<td>
							<div id="textomenujq">
								Descripci&oacute;n:
							</div>
						</td>
						<td>
							<input type="text" id="desc_buscar_x_cod_desc" name="desc_buscar_x_cod_desc" style="width:380px;">
						</td>
						<td>
							<input type="button" id="bot_buscar_x_cod_desc" name="bot_buscar_x_cod_desc" onclick="buscar_x_cod_desc();" value="Buscar">
						</td>
					</tr>
				</table>
				<!-- DIV que muestra la data de la consulta-->
				<div id="div_buscar_x_cod_desc" name="div_buscar_x_cod_desc" style="border:1 px solid #CCCCCC;">
				</div>
			</div>
			<div id="tabs1-estr">
				<h2>Seleccione la Familia</h2>
				<table>
					<tr>
						<td>
							<div id="textomenujq">
								Super Familia: 
							</div>
						</td>
						<td>
							<div id="div_superfamilia" name="div_superfamilia" class="styled-selectG">
								<select name="superfamilia" id="superfamilia">
									<option>test</option>
								</select>
							</div>
						</td>
						<td>
							<div id="textomenujq">
								Familia:
							</div>
						</td>
						<td>
							<div id="div_familia" name="div_familia" class="styled-selectG">
							</div>
						</td>
						<td>
							<div id="textomenujq">
								Sub Familia:
							</div>
						</td>
						<td>
							<div id="div_subfamilia" name="div_subfamilia" class="styled-selectG">
							</div>
						</td>
						<td>
							<input type="button" id="bot_buscar_x_estructura" name="bot_buscar_x_estructura" value="Buscar">
						</td>
					</tr>
				</table>
				<div id="div_lista_precios_estructura">
				</div>
			</div>
			<div id="tabs1-nume">
				<h2>Ingrese el folio</h2>
				<table>
					<tr>
						<td>
							<div id="textomenujq">
								Numero de Folio:
							</div>
						</td>
						<td>
							<input type="text" class="input" name="folio" value="Ingrese Numero de Folio..." style="width:380px;">
						</td>
						<td>
							<input type="button" id="bot_buscar_x_folio" name="bot_buscar_x_folio" value="Buscar">
						</td>
					</tr>
				</table>
			</div>
			<div id="tabs1-ulti">
				<h2>Lista de los ultimos precios al dia <%=Date%></h2>
			</div>
			<div id="tabs1-prov">
				<h2>CSS Styles for these tabs</h2>
			</div>
		</div><!-- FIN tabs1-nume -->
	</div><!-- FIN panel-container -->
</div><!-- FIN boxinfo -->
<!-- FIN DEL BODY-->
</body>
</HTML>
<!-- 
	esto va dentro del $(document).ready( function()

	$("#bot_buscar_x_cod_desc").click(function(){
	v_id_buscar_x_cod_desc = $("#id_buscar_x_cod_desc").val();
	v_desc_buscar_x_cod_desc = $("#desc_buscar_x_cod_desc").val();
	buscar_x_cod_desc(v_id_buscar_x_cod_desc, v_desc_buscar_x_cod_desc)
	});/*FIN .click*/	
-->

