<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn_Alta
numero_interno_etiqueta	= Request.QueryString("numero_interno_etiqueta")

If numero_interno_etiqueta <> "" then
	strSQL="select A.fecha, A.nombre_etiqueta, A.detalle_etiqueta, A.responsable, A.tipo_etiqueta, B.n_responsable from " &_
				  "(select  numero_interno_etiqueta, fecha, nombre_etiqueta, detalle_etiqueta, responsable, tipo_etiqueta from etiquetas where numero_interno_etiqueta="&numero_interno_etiqueta&") A, " &_
				  "(select  entidad_comercial,  Apellidos_persona_o_nombre_empresa + ' ' + Nombres_persona as n_responsable from entidades_comerciales where empresa='SYS') B " &_
				  "where A.responsable=B.entidad_comercial"
	Set rs = ConnAlta.Execute(strSQL)
	If Not rs.EOF Then
		fecha						= Left(rs("fecha"),10)
		tipo_etiqueta		= rs("tipo_etiqueta")
		n_responsable		= rs("n_responsable")
		nombre_etiqueta	= rs("nombre_etiqueta")
		detalle_etiqueta	= rs("detalle_etiqueta")
		'response.write detalle_etiqueta
	    'response.end
	End If
End if
%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="css/style3.css">
	<link rel="stylesheet" type="text/css" href="css/jquery.toastmessage.css">
	<script type="text/javascript" src="ckeditor/ckeditor.js"></script>
	<script src="ckeditor/adapters/jquery.js"></script>
	<script type="text/javascript" src="js/tools.js"></script>
	<script type="text/javascript" src="js/jquery-1.7.2.js"></script>
	<script type="text/javascript" src="js/jquery.toastmessage.js"></script>
	<script src="ckeditor/adapters/jquery.js"></script>
	<script language="javascript">
		var global_tipo_etiqueta;
		$(document).ready( function(){
			$("#tipo_etiqueta").change(function(){
				if($("#tipo_etiqueta").val() != "")
						Crear_Etiqueta();
			});
			$("#bot_success").click(function(){
				Grabar_Etiqueta();
			});
			$("#bot_danger").click(function(){
					Eliminar_Etiqueta()	;
			});

			if($("#numero_interno_etiqueta").val() != "")
			{
				$("#tipo_etiqueta").val("<%=tipo_etiqueta%>")
				$("#td_label_nombre").css("visibility","");
				$("#nombre_etiqueta").css("visibility","");
				$("#bot_success").css("visibility","");
				$("#bot_danger").css("visibility","");
				$("#nombre_etiqueta").val("<%=nombre_etiqueta%>");
				$("#editor1").val("<%=detalle_etiqueta%>");
				Set_Config_CKEDITOR($("#tipo_etiqueta").val());
				window.parent.document.getElementById("a_homeetiqueta").style.visibility=""
				window.parent.document.getElementById("a_nuevaetiqueta").style.visibility="hidden"
			}
		});/*FIN .ready*/
		tipo_vista_adm = "administrador";
		if(tipo_vista_adm == "administrador"){
			function Crear_Etiqueta(){
				if(confirm("¿Está seguro que desea crear una nueva etiqueta?")){
					$.ajax({
						dataType: "json",
						type: "post",
						url: "etiquetas_grabar.asp",
						data: "accion=INSERT&tipo_etiqueta = "+escape($("#tipo_etiqueta").val()),
						success: function(data){
							console.log (data.valor)
							$("#numero_interno_etiqueta").val(data.valor)
							if(data.accion=="OK"){
								window.parent.document.getElementById("a_homeetiqueta").style.visibility=""
								Set_Config_CKEDITOR($("#tipo_etiqueta").val())
								$("#td_label_nombre").css("visibility","");
								$("#nombre_etiqueta").css("visibility","");
								$("#bot_success").css("visibility","");
								$("#bot_danger").css("visibility","");
								$('#tipo_etiqueta').attr('disabled', 'disabled');
							}
							else{
								alert("Ocurrió un error al intentar crear el registro de la etiqueta. Información técnica del error: \n"+data.valor)
							}
						}
					});
				}
			}
			function Set_Config_CKEDITOR(v_tipo_etiqueta){
				switch(v_tipo_etiqueta){
					case "3cm X 4cm":
							v_width = 200; v_height = 370;
							break;
					case "4cm X 6cm":
							v_width = 400; v_height = 300;
							break;
				    case "7cm X 3cm":
							v_width = 300; v_height = 150;
							break;
					case "10cm X 3cm":
							v_width = 400; v_height = 150;
							break;
					case "10cm X 2cm":
							v_width = 100; v_height = 300;
							break;
					case "10cm X 5cm":
							v_width = 400; v_height = 200;
							break;
				}
				var config = {height: v_height,width: v_width}
				global_tipo_etiqueta = v_tipo_etiqueta
				$( '#editor1' ).ckeditor(config); // creacion del ckeditor recibiendo los archivos de configuracion		
			}
			function Grabar_Etiqueta(){
				//console.log("Nombre etiqueta: "+$( "#nombre_etiqueta").val())
				//console.log("Detalle etiqueta: "+$( "#editor1").val())
				$.ajax({
					dataType: "json",
					type: "post",
					url: "etiquetas_grabar.asp",
					data: "accion=UPDATE"+
					"&numero_interno_etiqueta= "+$("#numero_interno_etiqueta").val()+
					"&nombre_etiqueta="+escape($("#nombre_etiqueta").val())+
					"&detalle_etiqueta="+escape($( "#editor1").val()),
					success: function(data){
						//console.log (data.valor)
						if (data.accion=="EXISTE"){
							$().toastmessage('showToast', {
								text:'El Nombre de etiqueta ya existe',
								sticky   : false,
								position : 'middle-center',
								type     : 'error'
							});	
						}
						else{
							$().toastmessage('showToast', {
								text:'Etiqueta grabada correctamente',
								sticky   : false,
								position : 'middle-center',
								type     : 'Notice'
							});
							window.parent.Listar();
						}
					}
				});
			}
			function Eliminar_Etiqueta()	{
				if(confirm("¿Está seguro que desea eliminar esta etiqueta?")){
					$.ajax({
						dataType: "json",
						type: "post",
						url: "etiquetas_grabar.asp",
						data: "accion=DELETE&numero_interno_etiqueta= "+$("#numero_interno_etiqueta").val(),
						success: function(data){
							window.parent.Listar();
						}
					});
				}
			}
			$("#tipo_etiqueta").attr("disabled",true);
		}
		else{
			function Set_Config_CKEDITOR(v_tipo_etiqueta){
				switch(v_tipo_etiqueta){
					case "3cm X 4cm":
							v_width = 200; v_height = 370;
							break;
					case "4cm X 6cm":
							v_width = 400; v_height = 300;
							break;
					case "7cm X 3cm":
							v_width = 300; v_height = 150;
							break;
					case "10cm X 3cm":
							v_width = 400; v_height = 150;
							break;
					case "10cm X 2cm":
							v_width = 100; v_height = 300;
							break;
					case "10cm X 5cm":
							v_width = 400; v_height = 200;
							break;
				}
				$("#bot_success").css("visibility","hidden");
				$("#bot_danger").css("visibility","hidden");
				var config = {height: v_height,width: v_width, toolbar_custom: [['Print']], readOnly:true}
				global_tipo_etiqueta = v_tipo_etiqueta
				$( '#editor1' ).ckeditor(config); // creacion del ckeditor recibiendo los archivos de configuracion		
			}
		}
</script>
</head>
<body>
	<input type="hidden" id="numero_interno_etiqueta" name="numero_interno_etiqueta" value="<%=numero_interno_etiqueta%>">
	<table style="width: 100%;">
		<tr>
			<td style="width: 80px; font-size:12px; color: #444444"><b>Tipo etiqueta: </b></td>
			<td style="width: 120px; ">
				<select style="width: 120px;"
				<%If numero_interno_etiqueta <> "" then%> disabled <%End if%>
				style="width: 100px;" id="tipo_etiqueta" name="tipo_etiqueta">
					<option value=""></option>
					<option value="3cm X 4cm">3cm X 4cm</option>
					<option value="4cm X 6cm">4cm X 6cm</option>
				    <option value="7cm X 3cm">7,5cm X 3,5cm</option> 
					<option value="10cm X 2cm">10cm X 2cm</option>
					<option value="10cm X 3cm">10cm X 3cm</option>
					<option value="10cm X 5cm">10cm X 5cm</option>
				</select>
			</td>
			<td id="td_label_nombre" name="td_label_nombre" style="width: 60px; font-size:12px; color: #444444; visibility: hidden;"><b>Nombre:</b></td>
			<td ><input type="text" id="nombre_etiqueta" name="nombre_etiqueta" style="width:240px; visibility: hidden;"></td>
			<td style="width: 80px;"><input type="button" id="bot_success" name="bot_success" value="Grabar" style="visibility: hidden;"></td>
			<td style="width: 80px;"><input type="button" id="bot_danger" name="bot_danger" value="Eliminar" style="visibility: hidden;"></td>
		</tr>
	</table>
	<table style="width: 100%;">
		<tr>
			<td valign="top">
				<textarea  name='editor1' id="editor1"  style="visibility: hidden;"></textarea>
			</td>
		</tr>
	</table>
</body>
</html>