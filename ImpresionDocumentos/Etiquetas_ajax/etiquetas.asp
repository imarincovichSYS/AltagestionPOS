<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
%>
<HTML>
<HEAD>
	<TITLE>Test nuevo altagestion</TITLE>
	<META NAME="Generator" CONTENT="Sanchez&Sanchez">
	<META NAME="Author" CONTENT="Sanchez&Sanchez">
	<link rel="stylesheet" type="text/css" href="css/style3.css">
	<link rel="stylesheet" type="text/css" href="css/jquery.toastmessage.css">
	<script type="text/javascript" src="js/jquery-1.7.2.js"></script>
	<script type="text/javascript" src="js/jquery.toastmessage.js"></script>
	<script type="text/javascript" src="js/tools.js"></script>
	<script type="text/javascript">
	$(document).ready( function(){
		tipo_vista_adm = "administrador";/*esta variable es la que me permite determinar que usuario es*/
		if(tipo_vista_adm == "administrador"){
			$("#a_homeetiqueta").css("visibility","hidden");
		}else{
			$("#a_homeetiqueta").css("visibility","hidden");
			$("#a_nuevaetiqueta").css("visibility","hidden");
		}
		Listar();
	});/*FIN .ready*/
	tipo_vista_adm = "administrador";/*esta variable es la que me permite determinar que usuario es*/
	if(tipo_vista_adm == "administrador"){
		function HomeEtiqueta(){
			$("#a_homeetiqueta").css("visibility","hidden");
			$("#a_nuevaetiqueta").css("visibility","");
			Listar();
		}
		function NuevaEtiqueta(){
			$("#div_ckeditor").html("<iframe src='etiquetas_form.asp' width='95%' height='90%' frameborder='no'></iframe>");
			window.parent.document.getElementById("a_nuevaetiqueta").style.visibility="hidden";
		}
		function Cargar_Etiqueta(v_numero_interno_etiqueta){
			$("#div_ckeditor").html("<iframe src='etiquetas_form.asp?numero_interno_etiqueta="+v_numero_interno_etiqueta+"' width='95%' height='90%' frameborder='no'></iframe>");
		}
		function Listar(){
			$.ajax({
				url: "etiquetas_listar.asp",
				data: "",
				type: "POST",
				async: true,
				dataType: "html"
			}).done(function(html){
				$("#div_ckeditor").html(html);
			});/*fin del done*/
		}
	}else{
		console.log(tipo_vista_adm);
		function HomeEtiqueta(){
			$("#a_homeetiqueta").css("visibility","hidden");
			$("#a_nuevaetiqueta").css("visibility","hidden");
			Listar();
		}
		function Cargar_Etiqueta(v_numero_interno_etiqueta){
			$("#div_ckeditor").html("<iframe src='etiquetas_form.asp?numero_interno_etiqueta="+v_numero_interno_etiqueta+"' width='95%' height='90%' frameborder='no'></iframe>");
		}
		function Listar(){
			$.ajax({
				url: "etiquetas_listar.asp",
				data: "",
				type: "POST",
				async: true,
				dataType: "html"
			}).done(function(html){
				$("#div_ckeditor").html(html);
			});/*fin del done*/
		}
	}
	</script>
</HEAD>
<BODY bgcolor="#DDDDDD">
<table align="center" style="width:880px;">
<tr>
	<td>
	<div id="areaetiqueta" style="height:550px; width: 840px;">
		<div id="menuchico">
			<div id="tablemenu">
				<table>
					<tr>
						<td><a href="javascript:HomeEtiqueta();" id="a_homeetiqueta" style="cursor: pointer;"><img src="images/home_29X24.png" height=24 width=29 title="Listado de etiquetas"></a></td>
						<td><a href="javascript:NuevaEtiqueta();" id="a_nuevaetiqueta" style="cursor: pointer;"><img id="img_nuevaetiqueta" name="img_nuevaetiqueta" src="images/plus2_24X24.png" height=24 width=24 title="Crear nueva etiqueta"></a></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="div_ckeditor" style="height:585px;"></div>
	</div>
	</td>
</tr>
</table>
</BODY>
</HTML>