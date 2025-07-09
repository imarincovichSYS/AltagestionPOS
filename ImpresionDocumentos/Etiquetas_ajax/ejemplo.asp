<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
	OpenConn_Alta
%>
<html>
<head>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"  "http://www.w3.org/TR/html4/strict.dtd">
<meta charset="ASCII">
<link rel="stylesheet" type="text/css" href="css/blue.css">
<script type="text/javascript" src="js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="js/jquery.color.js"></script>
<script type="text/javascript" src="js/jquery.hashchange.min.js" ></script>
<script type="text/javascript" src="js/jquery.easytabs.js"></script>
<script type="text/javascript" src="js/jquery-migrate-1.1.1.js"></script>
<script language="javascript">
	function Cargar_Familia_X_Superfamilia(x_superfamilia){
		$.ajax({
			url: "familias.asp", /*ASP para dibujar el select*/
			data: "superfamilia="+x_superfamilia, /*variable que le entrego*/
			type: "POST", /*metodo*/
			async: true,
			dataType: "html", /*tipo de documento para recibir la data*/
		}).done(function( html ){
		  $("#div_familia").append(html);
		  $("#familia").change(function(){
				v_superfamilia = $("#superfamilia").val()
				v_familia = $("#familia").val()
				Cargar_Subfamilia_X_Familia_X_Superfamilia(v_superfamilia, v_familia)
			});
			v_superfamilia = $("#superfamilia").val()
			v_familia = $("#familia").val()
			Cargar_Subfamilia_X_Familia_X_Superfamilia(v_superfamilia, v_familia)
		});
	}
	function Cargar_Subfamilia_X_Familia_X_Superfamilia(x_superfamilia, x_familia){
		$.ajax({
			url: "subfamilias.asp",
			data: "superfamilia="+x_superfamilia+"&familia="+x_familia,
			type: "POST",
			async: true,
			dataType: "html",
			success:
			function(data){
				$("#div_subfamilia").html(data)
			}
		});
	}
	function Cargar_Seleccion(x_superfamilia, x_familia, x_subfamilia){
		$.ajax({
			url: "lista_precios.asp",
			data: "superfamilia="+x_superfamilia+"&familia="+x_familia+"&subfamilia="+x_subfamilia,
			type: "POST",
			async: true,
			dataType: "html",
			succes:
			function(data){
				$("#div_lista_precios_estructura").html(data)
			}
		});
	}
$(document).ready(function(){
	$('#menu-jquery li a').hover(
		function(){
			$(this).css('padding', '5px 15px').animate({
				'paddingLeft':'25px','paddingRight':'25px','backgroundColor':'rgba(0,0,0,0.5)'
			},'fast');
		},
		function(){
			$(this).css('padding', '5px 25px').animate({
				'paddingLeft':'15px','paddingRight':'15px','backgroundColor':'rgba(0,0,0,0.2)'
			},'fast');
		}
	);
	$("#superfamilia").change(function(){
		v_superfamilia = $(this).val();
		Cargar_Familia_X_Superfamilia(v_superfamilia);
	});
	$("#tab-container").easytabs();
	$("#superfamilia").val("7");
		Cargar_Familia_X_Superfamilia($("#superfamilia").val());
	$("#bot_buscar_x_estructura").click(function(){
		v_superfamilia = $("#superfamilia").val();
		v_familia = $("#familia").val();
		v_subfamilia = $("#subfamilia").val();
		Cargar_Seleccion(v_superfamilia, v_familia, v_subfamilia);
	});
});
</script>
</head>
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
							<%v_anio = year(date())
							for i=2009 to year(date())%>
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
	<table align="right">
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
	</table>
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
					<input type="text" class="input" name="codigo" value="Ingrese codigo...">
				</td>
				<td>
					<div id="textomenujq">
						Descripci&oacute;n:
					</div>
				</td>
				<td>
					<input type="text" class="input" name="descripcion" value="Ingrese descripcion..." style="width:380px;">
				</td>
				<td>
					<input type="button" id="transitionazul" name="buscar1" value="Buscar">
				</td>
			</tr>
		</table>
	</div>
	<div id="tabs1-estr">
		<h2>Seleccione la Familia</h2>
		<%
			strSQL="select superfamilia, (superfamilia+' - '+nombre) as nombre from superfamilias order by nombre"
			Set rs = ConnAlta.Execute(strSQL)
		%>
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
							<%Do While Not rs.EOF%>
							<option value="<%=rs("superfamilia")%>"><%=Left(rs("nombre"),35)%></option>
							<%rs.MoveNext
							loop%>
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
<!-- FIN DEL BODY-->
</body>
</html>