<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
	'*********** Especifica la codificación y evita usar caché **********
	Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
	Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
	NomFun = Request.QueryString("NomFun")
	tipo_usuario = "adm" 'se dejara como adm, pero el valor default es visita'
	If  NomFun="ETIQJRAJAXA" Then tipo_usuario= "adm"
	OpenConn_Alta
	fecha_hoy_YYYY_MM_DD = Get_Fecha_Formato_YYYY_MM_DD(Date)
	nom_dia_semana = GetDiaSemana(Weekday(date,0))
	strSQL="select A.numero_interno_etiqueta, A.fecha, A.nombre_etiqueta, A.responsable, A.tipo_etiqueta, B.n_responsable from " &_
	"(select  numero_interno_etiqueta, fecha, nombre_etiqueta, responsable, tipo_etiqueta from etiquetas) A, " &_
	"(select  entidad_comercial,  Apellidos_persona_o_nombre_empresa + ' ' + Nombres_persona as n_responsable from entidades_comerciales where empresa='SYS') B " &_
	"where A.responsable=B.entidad_comercial order by nombre_etiqueta"
	'and A.numero_interno_etiqueta=C.numero_interno_etiqueta
	' "(select numero_interno_etiqueta, detalle from etiquetas_detalle) C " &_
	'response.write strSQL
	'response.end
	Set rs = ConnAlta.Execute(strSQL)
	If Not rs.EOF Then
		w_fecha=150
		w_nombre_etiqueta=230
		w_tipo_etiqueta=230
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
		<link rel="stylesheet" type="text/css" href="css/etiqueta.css">
		<script type="text/javascript" src="js/jquery-1.9.1.js"></script>
		<script src="js/tools.js"></script>
		<script type="text/javascript" src="js/tools.js"></script>
	</head>
	<script type="text/javascript">
		var MaxInputs=20;//cantidad maxima de lineas en una etiqueta
		var LineaEtiqueta=new Array();
		$(document).ready(function(){
			$("#nueva_etiqueta").click(function(){
				v_url="etiqueta_nueva.asp";
				cargar_pagina(v_url);
			});
			
		}); //fin ready
		function resaltar_linea(fila_resaltar){
			$("#trfontlistar_"+fila_resaltar).mouseover(function(){
	    	    $("#trfontlistar_"+fila_resaltar).css("background-color", "#56ABF0");
	  		})
	  		.mouseout(function() {
	    		$("#trfontlistar_"+fila_resaltar).css("background-color", "#666666");
	  		});
		}
		function cargar_pagina(v_url){
			$("#cuerpo").html(" ");//vacio el div que contiene la lista para dibujar
			$("#encabezado_tabla").remove();//remueve el div cabecera de tabla
			$("#cabecera").remove();//remueve el div cabecera de tabla
			$.ajax({
				url: v_url,
				type: "POST",
				async: true,
				dataType: "html"
			}).done(function(html){
				$("#cuerpo").html(html);
			});
		}
		function crear_etiqueta_tamano(){
			$("#tamagnoEtiqueta").change(function(){
				optionTamagno=$("#tamagnoEtiqueta").val();
				if(optionTamagno=="3X2"){
					crearEtiqueta=confirm("Desea crear etiqueta "+optionTamagno+".");
					if(crearEtiqueta){
						insertar_etiqueta_bd(optionTamagno);
					}
					else
						location.href='newetiquetas_index.asp';
				} // fin 3x2
				if(optionTamagno=="4X3"){
					crearEtiqueta=confirm("Desea crear etiqueta "+optionTamagno+".");
					if(crearEtiqueta){
						insertar_etiqueta_bd(optionTamagno);
					}
					else
						location.href='newetiquetas_index.asp';
				}
				if(optionTamagno=="4X10"){
					crearEtiqueta=confirm("Desea crear etiqueta "+optionTamagno+".");
					if(crearEtiqueta){
						insertar_etiqueta_bd(optionTamagno);
					}
					else
						location.href='newetiquetas_index.asp';
				}
				if(optionTamagno=="10X5"){
					crearEtiqueta=confirm("Desea crear etiqueta "+optionTamagno+".");
					if(crearEtiqueta){
						insertar_etiqueta_bd(optionTamagno);
					}
					else
						location.href='newetiquetas_index.asp';
				}

			});
		}
		function insertar_etiqueta_bd(optionTamagno){
			$.ajax({
				dataType: "json",
				type: "post",
				url: "etiqueta_grabar.asp",
				data: "accion=INSERT&tipo_etiqueta="+escape($("#tamagnoEtiqueta").val()),
				success: function(data){
					$("#numero_interno_etiqueta").val(data.valor);
					numero_interno_etiqueta=data.valor;
					if(data.accion=="OK"){
						cargar_ultimo_creado(numero_interno_etiqueta);
					}
					else{
						alert("Ocurrió un error al intentar crear el registro de la etiqueta. Información técnica del error: \n"+data.valor);
					}//Fin Else
				}//Fin succes
			});//Fin ajax
		}
		function cargar_ultimo_creado(numero_interno_etiqueta){
			$.ajax({
				dataType: "html",
				type: "post",
				url: "cargar_ultimo_creado.asp",
				data: "numero_interno_etiqueta="+numero_interno_etiqueta,
				success: function(html){
					$("#cuerpo").html(html);
				}
			});//Fin AJAX
		}
		function AgregarCampos(opcion){
			etiqueta_dimension=$("#tamagnoEtiqueta").val();
			etiqueta_orientacion=$("#orientacion").val();
			//validacion para las cantidades de lineas en una etiqueta
			//MaxInputs significa la cantidad maxima de lineas que soporta una etiqueta
			if(etiqueta_dimension=="3X2" && etiqueta_orientacion=="vertical")
				MaxInputs=11;
			if(etiqueta_dimension=="3X2" && etiqueta_orientacion=="horizontal")
				MaxInputs=17;
			if(etiqueta_dimension=="4X3" && etiqueta_orientacion=="vertical")
				MaxInputs=20;
			if(etiqueta_dimension=="4X3" && etiqueta_orientacion=="horizontal")
				MaxInputs=15;
			if(etiqueta_dimension=="10X5" && etiqueta_orientacion=="vertical")
				MaxInputs=27;
			if(etiqueta_dimension=="10X5" && etiqueta_orientacion=="horizontal")
				MaxInputs=40;
			if(opcion==1){
				var v_lineaEditar=$(".linea_editar");
				totalLineas=v_lineaEditar.length;//total de text boxes en la pagina que tienen como class linea_editar	
				cuentaLinea=parseInt(totalLineas)+1;
				if(cuentaLinea<=MaxInputs){
					campo="<input type='text' style='width:250px; font-family:courier;' class='linea_editar' id='campo_"+cuentaLinea+"' name='campo_"+cuentaLinea+"' onkeypress='dibujarLetra("+cuentaLinea+");'><select name='tamanolinea_"+cuentaLinea+"' id='tamanolinea_"+cuentaLinea+"'><option value='8'>8</option><option value='12'>12</option><option value='16'>16</option><option value='15'>20</option><option value='18'>24</option><option value='24'>32</option></select><br id=br_"+cuentaLinea+">";
					$("#added").append(campo);
				}
				else
					alert("No es posible agregar mas lineas, ya que podrian no ser impresas en la etiqueta.");
			}
			if(opcion==2){
				var v_lineaEditar=$(".linea_editar");
				totalLineas=v_lineaEditar.length;//total de text boxes en la pagina que tienen como class linea_editar
				var res_cuentaLinea=parseInt(totalLineas);
				if(res_cuentaLinea<=totalLineas){
					$("#campo_"+res_cuentaLinea+"").remove();
					$("#br_"+res_cuentaLinea+"").remove();
					$("#tamanolinea_"+res_cuentaLinea+"").remove();
					res_cuentaLinea=parseInt(res_cuentaLinea)-1;
				}					
			}
		}
		function dibujarLetra(cuentaLinea){
			tamanoEtiqueta=$("#tamagnoEtiqueta").val();
			etiqueta_orientacion=$("#orientacion").val();
			if(tamanoEtiqueta=="3X2")
				$("#word_preview").css({"background-image":"url('./images/background3x2.png')", "background-repeat":"no-repeat"});
			if(tamanoEtiqueta=="4X3")
				$("#word_preview").css({"background-image":"url('./images/background4x3.png')", "background-repeat":"no-repeat"});
			if(tamanoEtiqueta=="10X5" && etiqueta_orientacion == "horizontal")
				$("#word_preview").css({"background-image":"url('./images/background10x5horizontal.png')", "background-repeat":"no-repeat"});
			if(tamanoEtiqueta=="10X5" && etiqueta_orientacion == "vertical")
				$("#word_preview").css({"background-image":"url('./images/background10x5vertical.png')", "background-repeat":"no-repeat"});	
			$("#campo_"+cuentaLinea+"").keyup(function(){
				var tamagnoLinea = new Array();
				var TextoEtiqueta=" ";
				var v_lineaEditar=$(".linea_editar");
				totalLineas=v_lineaEditar.length;/*total de text boxes en la pagina que tienen como class linea_editar*/
				for(i=1;i<=totalLineas;i++){
					LineaEtiqueta[i]=$("#campo_"+i+"").val();
					tamagnoLinea[i]=$("#tamanolinea_"+i).val();
					for(j=1;j<=MaxInputs;j++){
						if(LineaEtiqueta[j]==undefined){
							LineaEtiqueta[j]=" ";
							tamagnoLinea[j]=" ";
						}
					}
					//aqui deverian ir los if para determinar el tamaño y la ubicacion de las letras
					TextoEtiqueta=TextoEtiqueta+"<div id='textolinea"+i+"' style='font-size:"+tamagnoLinea[i]+"px;'>&nbsp;"+ LineaEtiqueta[i].toUpperCase() +"</div>";
				}
				
				$("#word_preview").html(TextoEtiqueta.replace(/  /g,"&nbsp;&nbsp;"));
			});
		}
		function imprimir(){
			//declaracion de variables
			v_tamagno=$("#tamagnoEtiqueta").val();//tamaño de la etiqueta que se quiere imprimir
			tamagno_r = new Array();//valor del select del tamaño de letra en la etiqueta
			tamagno_zebra = new Array();//señala el tamaño de la letra con lenguaje ZPLII
			v_orientacion=$("#orientacion").val();//orientacion de la etiqueta vertical, horizontal
			v_cantidad=$("#cantidad").val(); //cantidad a imprimir de etiquetas
			var v_lineaEditar=$(".linea_editar"); //cantidad de text con el id linea_editar
			totalLineas=v_lineaEditar.length;//total de text boxes en la pagina que tienen como class linea_editar
			var etiqueta1="", etiqueta2="", etiqueta3=""; //etiquetas con sus coordenadas de impresion en ZPLII
			var orientacion="N";//default de orientacion en lenguaje ZPLII
			etiquetas_papel=3; //cantidad de etiquetas en el papel fisico ej: 3x2 son 3 etiquetas por linea.
			etiqueta_ejeY = new Array();
			etiqueta_ejeX = new Array();
			//console.log(v_tamagno)
			for(i=1;i<=totalLineas;i++){
				LineaEtiqueta[i]=$("#campo_"+i+"").val();//valor de cada text en la etiqueta
				tamagno_r[i]=$("#tamanolinea_"+i+"").val();//valor de cada tamaño asignado a ese text
				for(j=1;j<=totalLineas;j++){
					if(LineaEtiqueta[j]==undefined){//es caso de que los valores sean undefined les asigno el valor vacio
						LineaEtiqueta[j]=" ";
						tamagno_r[j]=" ";
					}
				}
			}
			//esto es debido a que son de muy distinto tamaño unas con otras
			if(v_tamagno=="4X3"){
				etiquetas_papel=3;
				if(v_orientacion=="vertical"){
					cantidad_lineas=60;
					lineas_por_etiqueta=20;
					tope_etiqueta=10;
					orientacion="N";
					for(i=0;i<=cantidad_lineas;i++){
						if(i<20){
							etiqueta_ejeY[i]=0;
							etiqueta_ejeX[i]=tope_etiqueta;
							tope_etiqueta=tope_etiqueta+15;
							if(tope_etiqueta==310)
								tope_etiqueta=10;
						}
						if(i>19 && i<40){
							etiqueta_ejeY[i]=265;
							etiqueta_ejeX[i]=tope_etiqueta;
							tope_etiqueta=tope_etiqueta+15;
							if(tope_etiqueta==310)
								tope_etiqueta=10;
						}
						if(i>=40){
							etiqueta_ejeY[i]=530;
							etiqueta_ejeX[i]=tope_etiqueta;
							tope_etiqueta=tope_etiqueta+15;
							if(tope_etiqueta==310)
								tope_etiqueta=10;
						}
					}
				}
				if(v_orientacion=="horizontal"){
					cantidad_lineas=45;
					lineas_por_etiqueta=15;
					orientacion="R";
					tope_etiqueta=750;
					for(i=0;i<=cantidad_lineas;i++){
						if(i==15)
							tope_etiqueta=490
						if(i==30)
							tope_etiqueta=225
						etiqueta_ejeY[i]=tope_etiqueta;
						etiqueta_ejeX[i]=10;
						tope_etiqueta=tope_etiqueta-15;
					}
				}
			}
			if(v_tamagno=="3X2"){
				etiquetas_papel=3;
				if(v_orientacion=="vertical"){
					cantidad_lineas=33;
					lineas_por_etiqueta=11;
					tope_etiqueta=10;
					orientacion="N";
					for(i=0;i<=cantidad_lineas;i++){
						if(i<11){
							etiqueta_ejeY[i]=30;
							etiqueta_ejeX[i]=tope_etiqueta;
							tope_etiqueta=tope_etiqueta+15;
							if(tope_etiqueta==175)
								tope_etiqueta=10;
						}
						if(i>10 && i<22){
							etiqueta_ejeY[i]=305;
							etiqueta_ejeX[i]=tope_etiqueta;
							tope_etiqueta=tope_etiqueta+15;
							if(tope_etiqueta==175)
								tope_etiqueta=10;
						}
						if(i>21){
							etiqueta_ejeY[i]=585;
							etiqueta_ejeX[i]=tope_etiqueta;
							tope_etiqueta=tope_etiqueta+15;
							if(tope_etiqueta==175)
								tope_etiqueta=10;
						}
					}
				}
				if(v_orientacion=="horizontal"){
					cantidad_lineas=51;
					lineas_por_etiqueta=17;
					tope_etiqueta=820;
					orientacion="R";
					for(i=0;i<=cantidad_lineas;i++){
						if(i==17)
							tope_etiqueta=540;
						if(i==34)
							tope_etiqueta=260;
						etiqueta_ejeY[i]=tope_etiqueta;
						etiqueta_ejeX[i]=5;
						tope_etiqueta=tope_etiqueta-15;
					}
				}
			}
			if(v_tamagno=="4X10"){
				etiquetas_papel=1;
				if(v_orientacion=="vertical"){
					cantidad_lineas=16;//cuantas lineas caben en la etiqueta
					tope_etiqueta=10;//indicador de partida de ubicacion de cada linea en la etiqueta
					orientacion="N";
					for(i=0;i<=cantidad_lineas;i++){
						etiqueta_ejeY[i]=30;
						etiqueta_ejeX[i]=tope_etiqueta;
						tope_etiqueta=tope_etiqueta+15;
					}
				}
				if(v_orientacion=="horizontal"){
					cantidad_lineas=53;
					tope_etiqueta=800;
					orientacion="R";
					for(i=0;i<=cantidad_lineas;i++){
						etiqueta_ejeY[i]=tope_etiqueta;
						etiqueta_ejeX[i]=5;
						tope_etiqueta=tope_etiqueta-15;
					}
				}
			}
			if(v_tamagno=="10X5"){
				etiquetas_papel=1;
				//console.log("flag 10*5")
				if(v_orientacion=="vertical"){
					//console.log("vertical")
					cantidad_lineas=27;
					tope_etiqueta=50;
					orientacion="N";
					for(i=0;i<=cantidad_lineas;i++){
						etiqueta_ejeY[i]=30;
						etiqueta_ejeX[i]=tope_etiqueta;
						tope_etiqueta=tope_etiqueta+19;
					}
				}
				if(v_orientacion=="horizontal"){
					//console.log("horizontal")
					cantidad_lineas=53;
					tope_etiqueta=780;
					orientacion="R";
					for(i=0;i<=cantidad_lineas;i++){
						etiqueta_ejeY[i]=tope_etiqueta;
						etiqueta_ejeX[i]=30;
						tope_etiqueta=tope_etiqueta-20;
					}
				}
			}
			//este for se encarga de hacer el cambio desde el tamagno_r a la letra que corresponde en el lenguaje ZPLII
			for(k=1;k<=totalLineas;k++){
				if(tamagno_r[k]=="8"){
					tamagno_zebra[k]="B";
				}
				if(tamagno_r[k]=="12"){
					tamagno_zebra[k]="P";
				}
				if(tamagno_r[k]=="15"){
					tamagno_zebra[k]="R";
				}
				if(tamagno_r[k]=="16"){
					tamagno_zebra[k]="Q";
				}
				if(tamagno_r[k]=="18"){
					tamagno_zebra[k]="S";
				}
				if(tamagno_r[k]=="24"){
					tamagno_zebra[k]="V";
				}
			}
			if(etiquetas_papel==3){
				for(i=0;i<=cantidad_lineas;i++){
					if(tamagno_zebra[i+1]==undefined || LineaEtiqueta==undefined){
						break;//en caso de que se impriman menos lineas que el tope este se encarga de romper el ciclo para que no imprima basura
					}
					else{
						//armo la variable que contiene el tamaño de la letra, el contenido de la linea, la ubicacion en la etiqueta y la orientacion
						etiqueta1=etiqueta1+"^FS^FO"+etiqueta_ejeY[i]+","+etiqueta_ejeX[i]+"^A"+tamagno_zebra[i+1]+orientacion+"^FD"+LineaEtiqueta[i+1];
						etiqueta2=etiqueta2+"^FS^FO"+etiqueta_ejeY[i+lineas_por_etiqueta]+","+etiqueta_ejeX[i+lineas_por_etiqueta]+"^A"+tamagno_zebra[i+1]+orientacion+"^FD"+LineaEtiqueta[i+1];
						etiqueta3=etiqueta3+"^FS^FO"+etiqueta_ejeY[i+(lineas_por_etiqueta*2)]+","+etiqueta_ejeX[i+(lineas_por_etiqueta*2)]+"^A"+tamagno_zebra[i+1]+orientacion+"^FD"+LineaEtiqueta[i+1];
					}
				}
			}
			if(etiquetas_papel==1){
				for(i=0;i<=cantidad_lineas;i++){
					if(tamagno_zebra[i+1]==undefined || LineaEtiqueta==undefined){
						break;//en caso de que se impriman menos lineas que el tope este se encarga de romper el ciclo para que no imprima basura
					}
					else{
						//armo la variable que contiene el tamaño de la letra, el contenido de la linea, la ubicacion en la etiqueta y la orientacion
						etiqueta1=etiqueta1+"^FS^FO"+etiqueta_ejeY[i]+","+etiqueta_ejeX[i]+"^A"+tamagno_zebra[i+1]+orientacion+"^FD"+LineaEtiqueta[i+1];
					}
				}
			}
			etiqueta_encabezado="^XA";//esto va siempre para empezar la impresion de la etiqueta 
			etiqueta_finalizado="^XZ";//esto va siempre para finalizar la impresion de la etiqueta
			etiqueta_para_imprimir=etiqueta_encabezado+etiqueta1+etiqueta2+etiqueta3+etiqueta_finalizado;//esta etiqueta esta lista para ser impresa
			//segun la cantidad realizo la impresion con el applet donde busco la impresora con el nombre ZEBRA y le paso la variable etiqueta_para_imprimir
			//console.log(etiqueta1+"\n"+etiqueta2+"\n"+etiqueta3);
			//console.log(v_cantidad)			
			for(i=0;i<v_cantidad;i++){
				document.jzebra.findPrinter("ZebraSYS");
				//findPrinter()
				document.jzebra.append(etiqueta_para_imprimir); 
				document.jzebra.print();
			}
		}
		function guardar_etiqueta(){
			var etiqueta= new Array();
			var tamagnos = new Array();
			var v_lineaEditar=$(".linea_editar");
			totalLineas=parseInt(v_lineaEditar.length);//total de text boxes en la pagina que tienen como class linea_editar
			var etiquetabd;
			var v_tamagnoLinea = new Array();
			v_tamagnoEtiqueta=$("#tamagnoEtiqueta").val();
			v_numero_interno_etiqueta=$("#numero_interno_etiqueta").val();
			v_nombre_etiqueta=$("#nombre_etiqueta").val();
			if(v_nombre_etiqueta!=undefined){
				for(i=1;i<=totalLineas;i++){
					if(i<totalLineas){
						etiqueta[i]=$("#campo_"+i).val();
						tamagnos[i]=$("#tamanolinea_"+i).val();
						etiqueta[i]=etiqueta[i]+";";//; es el separador de linea
						tamagnos[i]=tamagnos[i]+";";//; es el separador de linea
					}
					else{
						etiqueta[i]=$("#campo_"+i+"").val();
						tamagnos[i]=$("#tamanolinea_"+i).val();
						etiqueta[i]=etiqueta[i];
						tamagnos[i]=tamagnos[i];
					}
				}
				etiquetabd=etiqueta[1];
				tamagnosbd=tamagnos[1];
				for(j=1;j<totalLineas;j++){
					etiquetabd=etiquetabd+etiqueta[j+1];
					tamagnosbd=tamagnosbd+tamagnos[j+1];
				}
				if(etiquetabd!=undefined)
					etiquetabd=etiquetabd.replace(/ /g,"%20");
				v_nombre_etiqueta=v_nombre_etiqueta.replace(/ /g,"%20");
				if(etiquetabd!=undefined){
					if(v_nombre_etiqueta==""){
						alert("Por favor ponga un nombre a la etiqueta.")	
					}
					else{
						if(confirm("Guardar Cambios en etiqueta?")){
							$.ajax({
								dataType: "html",
								type: "post",
								url: "etiqueta_grabar.asp",
								data: "accion=UPDATE&numero_interno_etiqueta="+v_numero_interno_etiqueta+"&detalle_etiqueta="+etiquetabd+"&nombre_etiqueta="+escape(v_nombre_etiqueta)+"&tamagno_linea="+tamagnosbd,
								success: function(html){
									alert("Etiqueta Guardada con exito");
								}, 
								error: function(html){
									alert("Ha ocurrido un error al intentar grabar la etiqueta. Por favor inténtelo nuevamente.\nSi el problema persiste contacte al administrador del sistema.")
								}
							});//Fin AJAX
						}

					}
				}
				else
					alert("Por favor inserte al menos una linea a la etiqueta.");
			}	
			else
				alert("Por favor ponga un nombre a la etiqueta.");
		}
		function editarEtiqueta(numero_interno_etiqueta){
			$("#cabecera").remove();
			$("#encabezado_tabla").remove();
			$("#cuerpo").html(" ");
			//$("#cuerpo").css("overflow","hidden");
			$.ajax({
				dataType: "html",
				type: "POST",
				url: "etiqueta_editar.asp",
				data: "numero_interno_etiqueta="+numero_interno_etiqueta,
				success: function(html){
					$("#cuerpo").html(html);
				}
			});
		}
	</script>
	<body>
		<div id="lienzo" name="lienzo">
			<div id="cabecera" name="cabecera">
				<input type="button" name="nueva_etiqueta" id="nueva_etiqueta" value="Nueva Etiqueta">
			</div>
			<div id="encabezado_tabla" name="encabezado_tabla">
				<table id="tabla_encabezado" name="tabla_encabezado">
					<tr>
						<td>Fecha</td><td>Nombre</td><td>Tipo Etiqueta</td>
					</tr>
				</table>
			</div>
			<div id="cuerpo" name="cuerpo">
				<table id="tabla_detalle" name="tabla_detalle">
				<%
					i=1
					Do While Not rs.EOF%>
					<tr onmouseover="javascript:resaltar_linea(<%=i%>);" onclick="javascript:editarEtiqueta(<%=rs("numero_interno_etiqueta")%>);" class="trfontlistar_<%=i%>" name="trfontlistar_<%=i%>" id="trfontlistar_<%=i%>">
						<td style="width:<%=w_fecha%>;"><%=Left(rs("fecha"),10)%></td>
						<td style="width:<%=w_nombre_etiqueta%>;"><%=Rs("nombre_etiqueta")%></td>
						<td style="width:<%=w_tipo_etiqueta%>;"><%=rs("tipo_etiqueta")%></td>
					</tr>
				<%
					rs.MoveNext
					i=i+1
				loop%>
				</table>
			</div>
		</div>
	</body>
</html>
<%End if%>
<applet name="jzebra" id="jzebra" code="jzebra.PrintApplet.class" archive="js/jzebra.jar" width="1" height="1">
	<param name="printer" value="zebra">
</applet>