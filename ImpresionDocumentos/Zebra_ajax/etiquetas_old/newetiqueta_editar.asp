<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
	'*********** Especifica la codificación y evita usar caché **********
	Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
	Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
	tipo_usuario = Request.QueryString("tipo_usuario")
	OpenConn_Alta
	x_numero_interno_etiqueta=Request.QueryString("numero_interno_etiqueta")
	fecha_hoy_YYYY_MM_DD = Get_Fecha_Formato_YYYY_MM_DD(Date)
	nom_dia_semana = GetDiaSemana(Weekday(date,0))
	strSQL="select A.numero_interno_etiqueta, A.detalle_etiqueta, A.fecha, A.nombre_etiqueta, A.responsable, A.tipo_etiqueta, A.tamagno_linea, B.n_responsable from " &_
	"(select  detalle_etiqueta, numero_interno_etiqueta, fecha, nombre_etiqueta, responsable, tipo_etiqueta, tamagno_linea from etiquetas) A, " &_
	"(select  entidad_comercial,  Apellidos_persona_o_nombre_empresa + ' ' + Nombres_persona as n_responsable from entidades_comerciales where empresa='SYS') B " &_
	"where A.responsable=B.entidad_comercial and A.numero_interno_etiqueta = '"&x_numero_interno_etiqueta&"' order by nombre_etiqueta"
	Set rs = ConnAlta.Execute(strSQL)
	Dim texto, x_detalle_etiqueta, count, arreglo
	count=0
	arreglo=1
	x_detalle_etiqueta=rs("detalle_etiqueta")
	x_detalle_tamagno=rs("tamagno_linea")
	texto = Split(x_detalle_etiqueta,";")
	tamlinea = Split(x_detalle_tamagno,";")
	for i=0 to uBound(texto) 
		count=count+1 
	Next
%>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
	<link rel="stylesheet" type="text/css" href="css/etiqueta.css">
	<script type="text/javascript" src="js/jquery-1.7.2.js"></script>	
	<script type="text/javascript" src="js/tools.js"></script>
	<!-- 
	Determina con que navegador se ingresa a la pagina.
	<script type="text/javascript" src="js/comprobarnavegador.js"></script>	
	-->
	<script type="text/javascript">
		var LineaEtiqueta=new Array();
		var tamagno=new Array();
		var MaxInputs=20;
		var tipo_usuario = "<%=tipo_usuario%>"
		$(document).ready(function(){
			r_count=<%=count%>/*cantidad de lineas*/
			v_tamagnoEtiqueta=$("#tamagnoEtiqueta").val();
			if(v_tamagnoEtiqueta=="3X2"){
				$("#etiqueta3x2").css("visibility","visible");
				$("#etiqueta3x2").css("background-image","url('./images/background3x2.png')");
			}
			if(v_tamagnoEtiqueta=="4X3"){
				$("#etiqueta3x2").css("visibility","visible");
				$("#etiqueta3x2").css("background-image","url('./images/background4x3.png')");
			}
			if(v_tamagnoEtiqueta=="10X5"){
				$("#etiqueta3x2").css("visibility","visible");
				$("#etiqueta3x2").css("background-image","url('./images/background10x5.png')");
			}
			dibujar();
			/*if(tipo_usuario=="visita"){
				var v_lineaEditar=$(".linea_editar");
				totalLineas=v_lineaEditar.length;/*total de text boxes en la pagina que tienen como class linea_editar
				$("#agregar_linea").css("visibility","hidden");
				$("#quitar_linea").css("visibility","hidden");
				$("#guardar").css("visibility","hidden");
				$("#eliminar").css("visibility","hidden");
				$("#nombre_etiqueta").attr("readonly","True");
				for(i=1;i<=totalLineas;i++){
					$("#campo_"+i+"").attr("readonly","True");
				}
			}*/
		});
		var LineaEtiqueta=new Array();
		var tamagno=new Array();
		var MaxInputs=20;
		function eliminar(){
			return;
			if(confirm("¿Está seguro que desea eliminar esta etiqueta?")){
				$.ajax({
					dataType: "json",
					type: "post",
					url: "etiquetas_grabar.asp",
					data: "accion=DELETE&numero_interno_etiqueta= "+$("#numero_interno_etiqueta").val(),
					success: function(data){
						document.location.href='newetiquetas_index.asp';
					}
				});
			}
		}
		function dibujar(){
			var TextoEtiqueta=" ";
			texto='<%=rs("detalle_etiqueta")%>';
			tamagno='<%=rs("tamagno_linea")%>';
			te=texto.split(";");
			ta=tamagno.split(";");
			le=te.length;
			for(i=0;i<le;i++){
				TextoEtiqueta=TextoEtiqueta+"<div id='textolinea'"+[i+1]+" style='font-size:12px;'>&nbsp;&nbsp;"+te[i]+"</div>";
				$("#word_preview").html(TextoEtiqueta.replace(/  /g,"&nbsp;&nbsp;"));
			}
		}
		function dibujarLetra(posicion){
			$("#campo_"+posicion+"").keyup(function(){
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
					TextoEtiqueta=TextoEtiqueta+"<div id='textolinea"+i+"' style='font-size:12px'>&nbsp;&nbsp;"+LineaEtiqueta[i]+"</div>";
				}
				$("#word_preview").html(TextoEtiqueta.replace(/  /g,"&nbsp;&nbsp;"));
			});
		}
		function AgregarCampos(opcion){
			var v_lineaEditar=$(".linea_editar");
			totalLineas=v_lineaEditar.length;/*total de text boxes en la pagina que tienen como class linea_editar*/
			cuentaLinea=parseInt(totalLineas)+1;
			if(opcion==1){
				campo="<input type='text' style='width:250px; font-family:courier;' class='linea_editar' id='campo_"+cuentaLinea+"' name='campo_"+cuentaLinea+"' onclick='dibujarLetra("+cuentaLinea+");'><select name='tamanolinea_"+cuentaLinea+"' id='tamanolinea_"+cuentaLinea+"'><option value='8'>8</option><option value='12'>12</option><option value='16'>16</option><option value='15'>20</option><option value='18'>24</option><option value='24'>32</option></select><br id=br_"+cuentaLinea+">";
				$("#added").append(campo);
			}
			if(opcion==2){
				var res_cuentaLinea=cuentaLinea;
				if(res_cuentaLinea<=cuentaLinea){
					res_cuentaLinea=parseInt(res_cuentaLinea)-1;
					$("#campo_"+res_cuentaLinea+"").remove();
					$("#br_"+res_cuentaLinea+"").remove();
					$("#tamanolinea_"+res_cuentaLinea+"").remove();
				}
			}
		}
		function guardar_etiqueta(){
			var etiqueta= new Array();
			var tamagnos = new Array();
			var v_lineaEditar=$(".linea_editar");
			totalLineas=v_lineaEditar.length;/*total de text boxes en la pagina que tienen como class linea_editar*/
			var etiquetabd;
			var v_tamagnoLinea = new Array();
			v_tamagnoEtiqueta=$("#tamagnoEtiqueta").val();
			v_numero_interno_etiqueta=$("#numero_interno_etiqueta").val();
			v_nombre_etiqueta=$("#nombre_etiqueta").val();
			for(i=1;i<=totalLineas;i++){
				if(i<totalLineas){
					etiqueta[i]=$("#campo_"+i).val();
					tamagnos[i]=$("#tamanolinea_"+i).val();
					etiqueta[i]=etiqueta[i]+";";
					tamagnos[i]=tamagnos[i]+";";
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
			etiquetabd=etiquetabd.replace(/ /g,"%20");
			v_nombre_etiqueta=v_nombre_etiqueta.replace(/ /g,"%20");
			if(confirm("¿Guardar Cambios en etiqueta "+v_nombre_etiqueta+"?")){
				$.ajax({
					dataType: "html",
					type: "post",
					url: "etiquetas_grabar.asp",
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
		function imprimir(){
			tamagno_r = new Array();
			tamagno_zebra = new Array();
			etiqueta4x3A = new Array("204","187","170","153","136","119","102","85","68","51","34","17","3");
			etiqueta4x3B = new Array("470","453","436","419","402","385","368","351","334","317","300","283","263");
			etiqueta4x3C = new Array("735","718","701","684","667","650","633","616","599","582","565","548","528");
			etiqueta10x5 = new Array("0","20","40","60","80","100","120","140","160","180","200","220","240","260","280","300");
			v_tamagno=$("#tamagnoEtiqueta").val();
			v_cantidad=$("#cantidad").val();
			v_orientacion=$("#orientacion").val();
			var v_lineaEditar=$(".linea_editar");
			totalLineas=v_lineaEditar.length;/*total de text boxes en la pagina que tienen como class linea_editar*/
			for(i=1;i<=totalLineas;i++){
				LineaEtiqueta[i]=$("#campo_"+i+"").val();
				tamagno_r[i]=$("#tamanolinea_"+i+"").val();
				for(j=1;j<=totalLineas;j++){
					if(LineaEtiqueta[j]==undefined){
						LineaEtiqueta[j]=" ";
						tamagno_r[j]=" ";
					}
				}
			}
			if(v_tamagno=="10X5"){
				if(v_orientacion=="horizontal"){
					for(i=1;i<=MaxInputs;i++){
						if(LineaEtiqueta[i]==undefined)
							LineaEtiqueta[i]=" ";
					}
					for(k=1;k<=totalLineas;k++){
						if(tamagno_r[k]=="8"){
							tamagno_zebra[k]="B";
						}
						if(tamagno_r[k]=="12"){
							tamagno_zebra[k]="P";
						}
						if(tamagno_r[k]=="16"){
							tamagno_zebra[k]="Q";
						}
						if(tamagno_r[k]=="15"){
							tamagno_zebra[k]="R";
						}
						if(tamagno_r[k]=="18"){
							tamagno_zebra[k]="S";
						}
						if(tamagno_r[k]=="24"){
							tamagno_zebra[k]="V";
						}
					}
					var etiquetas = "\""+"^XA^FS^FO15,"+etiqueta10x5[0]+"^A"+tamagno_zebra[1]+"^FD"+LineaEtiqueta[1]+"^FS^FO15,"+etiqueta10x5[1]+"^A"+tamagno_zebra[2]+"^FD"+LineaEtiqueta[2]+"^FS^FO15,"+etiqueta10x5[2]+"^A"+tamagno_zebra[3]+"^FD"+LineaEtiqueta[3]+"^FS^FO15,"+etiqueta10x5[3]+"^A"+tamagno_zebra[4]+"^FD"+LineaEtiqueta[4]+"^FS^FO15,"+etiqueta10x5[4]+"^A"+tamagno_zebra[5]+"^FD"+LineaEtiqueta[5]+"^FS^FO15,"+etiqueta10x5[5]+"^A"+tamagno_zebra[6]+"^FD"+LineaEtiqueta[6]+"^FS^FO15,"+etiqueta10x5[6]+"^A"+tamagno_zebra[7]+"^FD"+LineaEtiqueta[7]+"^FS^FO15,"+etiqueta10x5[7]+"^A"+tamagno_zebra[8]+"^FD"+LineaEtiqueta[8]+"^FS^FO15,"+etiqueta10x5[8]+"^A"+tamagno_zebra[9]+"^FD"+LineaEtiqueta[9]+"^FS^FO15,"+etiqueta10x5[9]+"^A"+tamagno_zebra[10]+"^FD"+LineaEtiqueta[10]+"^FS^FO15,"+etiqueta10x5[10]+"^A"+tamagno_zebra[11]+"^FD"+LineaEtiqueta[11]+"^FS^FO15,"+etiqueta10x5[11]+"^A"+tamagno_zebra[12]+"^FD"+LineaEtiqueta[12]+"^FS^FO15,"+etiqueta10x5[12]+"^A"+tamagno_zebra[13]+"^FD"+LineaEtiqueta[13]+"^FS^FO15,"+etiqueta10x5[13]+"^A"+tamagno_zebra[14]+"^FD"+LineaEtiqueta[14]+"^FS^FO15,"+etiqueta10x5[14]+"^A"+tamagno_zebra[15]+"^FD"+LineaEtiqueta[15]+"^FS^FO15,"+etiqueta10x5[15]+"^A"+tamagno_zebra[16]+"^FD"+LineaEtiqueta[16]+"^XZ"+"\"";
					for(i=0;i<v_cantidad;i++){
						document.jzebra.findPrinter("zebra");
						document.jzebra.append(etiquetas); 
						document.jzebra.print();
					}
				}
				if(v_orientacion=="vertical"){
					for(i=1;i<=MaxInputs;i++){
						if(LineaEtiqueta[i]==undefined)
							LineaEtiqueta[i]=" ";
					}
					for(k=1;k<=totalLineas;k++){
						if(tamagno_r[k]=="8"){
							tamagno_zebra[k]="B";
						}
						if(tamagno_r[k]=="12"){
							tamagno_zebra[k]="P";
						}
						if(tamagno_r[k]=="16"){
							tamagno_zebra[k]="Q";
						}
						if(tamagno_r[k]=="15"){
							tamagno_zebra[k]="R";
						}
						if(tamagno_r[k]=="18"){
							tamagno_zebra[k]="S";
						}
					}
					var etiquetas = "\""+"^XA^FS^FO15,"+etiqueta10x5[0]+"^A"+tamagno_zebra[1]+"^FD"+LineaEtiqueta[1]+"^FS^FO15,"+etiqueta10x5[1]+"^A"+tamagno_zebra[2]+"^FD"+LineaEtiqueta[2]+"^FS^FO15,"+etiqueta10x5[2]+"^A"+tamagno_zebra[3]+"^FD"+LineaEtiqueta[3]+"^FS^FO15,"+etiqueta10x5[3]+"^A"+tamagno_zebra[4]+"^FD"+LineaEtiqueta[4]+"^FS^FO15,"+etiqueta10x5[4]+"^A"+tamagno_zebra[5]+"^FD"+LineaEtiqueta[5]+"^FS^FO15,"+etiqueta10x5[5]+"^A"+tamagno_zebra[6]+"^FD"+LineaEtiqueta[6]+"^FS^FO15,"+etiqueta10x5[6]+"^A"+tamagno_zebra[7]+"^FD"+LineaEtiqueta[7]+"^FS^FO15,"+etiqueta10x5[7]+"^A"+tamagno_zebra[8]+"^FD"+LineaEtiqueta[8]+"^FS^FO15,"+etiqueta10x5[8]+"^A"+tamagno_zebra[9]+"^FD"+LineaEtiqueta[9]+"^FS^FO15,"+etiqueta10x5[9]+"^A"+tamagno_zebra[10]+"^FD"+LineaEtiqueta[10]+"^FS^FO15,"+etiqueta10x5[10]+"^A"+tamagno_zebra[11]+"^FD"+LineaEtiqueta[11]+"^FS^FO15,"+etiqueta10x5[11]+"^A"+tamagno_zebra[12]+"^FD"+LineaEtiqueta[12]+"^FS^FO15,"+etiqueta10x5[12]+"^A"+tamagno_zebra[13]+"^FD"+LineaEtiqueta[13]+"^FS^FO15,"+etiqueta10x5[13]+"^A"+tamagno_zebra[14]+"^FD"+LineaEtiqueta[14]+"^FS^FO15,"+etiqueta10x5[14]+"^A"+tamagno_zebra[15]+"^FD"+LineaEtiqueta[15]+"^FS^FO15,"+etiqueta10x5[15]+"^A"+tamagno_zebra[16]+"^FD"+LineaEtiqueta[16]+"^XZ"+"\"";
					for(i=0;i<v_cantidad;i++){
						document.jzebra.findPrinter("zebra");
						document.jzebra.append(etiquetas); 
						document.jzebra.print();
					}
				}
			}
			if(v_tamagno=="3X2"){
				if(v_orientacion=="horizontal"){
					interline_zebra = new Array();
					tamagno_zebra = new Array();
					for(i=1;i<=MaxInputs;i++){
						if(LineaEtiqueta[i]==undefined)
							LineaEtiqueta[i]=" ";
					}
					for(k=1;k<=totalLineas;k++){
						if(tamagno_r[k]=="8"){
							tamagno_zebra[k]="B";
						}
						if(tamagno_r[k]=="12"){
							tamagno_zebra[k]="P";
						}
						if(tamagno_r[k]=="16"){
							tamagno_zebra[k]="Q";
						}
						if(tamagno_r[k]=="15"){
							tamagno_zebra[k]="R";
						}
						if(tamagno_r[k]=="18"){
							tamagno_zebra[k]="S";
						}
					}
					var etiquetasA=
					"^XA^FS^FO40,15^A"+tamagno_zebra[1]+"N^FD"+LineaEtiqueta[1]+
					"^FS^FO40,30^A"+tamagno_zebra[2]+"N^FD"+LineaEtiqueta[2]+
					"^FS^FO40,45^A"+tamagno_zebra[3]+"N^FD"+LineaEtiqueta[3]+
					"^FS^FO40,60^A"+tamagno_zebra[4]+"N^FD"+LineaEtiqueta[4]+
					"^FS^FO40,75^A"+tamagno_zebra[5]+"N^FD"+LineaEtiqueta[5]+
					"^FS^FO40,90^A"+tamagno_zebra[6]+"N^FD"+LineaEtiqueta[6]+
					"^FS^FO40,105^A"+tamagno_zebra[7]+"N^FD"+LineaEtiqueta[7]+
					"^FS^FO40,120^A"+tamagno_zebra[8]+"N^FD"+LineaEtiqueta[8]+
					"^FS^FO40,135^A"+tamagno_zebra[9]+"N^FD"+LineaEtiqueta[9]+
					"^FS^FO40,150^A"+tamagno_zebra[10]+"N^FD"+LineaEtiqueta[10]+
					"^FS^FO40,165^A"+tamagno_zebra[11]+"N^FD"+LineaEtiqueta[11]+
					"^FS^FO300,15^A"+tamagno_zebra[1]+"N^FD"+LineaEtiqueta[1]+
					"^FS^FO300,30^A"+tamagno_zebra[2]+"N^FD"+LineaEtiqueta[2]+
					"^FS^FO300,45^A"+tamagno_zebra[3]+"N^FD"+LineaEtiqueta[3]+
					"^FS^FO300,60^A"+tamagno_zebra[4]+"N^FD"+LineaEtiqueta[4]+
					"^FS^FO300,75^A"+tamagno_zebra[5]+"N^FD"+LineaEtiqueta[5]+
					"^FS^FO300,90^A"+tamagno_zebra[6]+"N^FD"+LineaEtiqueta[6]+
					"^FS^FO300,105^A"+tamagno_zebra[7]+"N^FD"+LineaEtiqueta[7]+
					"^FS^FO300,120^A"+tamagno_zebra[8]+"N^FD"+LineaEtiqueta[8]+
					"^FS^FO300,135^A"+tamagno_zebra[9]+"N^FD"+LineaEtiqueta[9]+
					"^FS^FO300,150^A"+tamagno_zebra[10]+"N^FD"+LineaEtiqueta[10]+
					"^FS^FO300,165^A"+tamagno_zebra[11]+"N^FD"+LineaEtiqueta[11]+
					"^FS^FO580,15^A"+tamagno_zebra[1]+"N^FD"+LineaEtiqueta[1]+
					"^FS^FO580,30^A"+tamagno_zebra[2]+"N^FD"+LineaEtiqueta[2]+
					"^FS^FO580,45^A"+tamagno_zebra[3]+"N^FD"+LineaEtiqueta[3]+
					"^FS^FO580,60^A"+tamagno_zebra[4]+"N^FD"+LineaEtiqueta[4]+
					"^FS^FO580,75^A"+tamagno_zebra[5]+"N^FD"+LineaEtiqueta[5]+
					"^FS^FO580,90^A"+tamagno_zebra[6]+"N^FD"+LineaEtiqueta[6]+
					"^FS^FO580,105^A"+tamagno_zebra[7]+"N^FD"+LineaEtiqueta[7]+
					"^FS^FO580,120^A"+tamagno_zebra[8]+"N^FD"+LineaEtiqueta[8]+
					"^FS^FO580,135^A"+tamagno_zebra[9]+"N^FD"+LineaEtiqueta[9]+
					"^FS^FO580,150^A"+tamagno_zebra[10]+"N^FD"+LineaEtiqueta[10]+
					"^FS^FO580,165^A"+tamagno_zebra[11]+"N^FD"+LineaEtiqueta[11]+"^XZ";
					etiquetasABC=etiquetasA;
					for(i=0;i<v_cantidad;i++){
						document.jzebra.findPrinter("zebra");
						document.jzebra.append(etiquetasABC); 
						document.jzebra.print();
					}
				}
				if(v_orientacion=="vertical"){
					interline_zebra = new Array();
					tamagno_zebra = new Array();
					for(i=1;i<=MaxInputs;i++){
						if(LineaEtiqueta[i]==undefined)
							LineaEtiqueta[i]=" ";
					}
					for(k=1;k<=MaxInputs;k++){
						if(tamagno_r[k]=="8"){
							tamagno_zebra[k]="B";
							interline_zebra[k]=parseInt(interline_zebra[k])+7;
						}
						if(tamagno_r[k]=="12"){
							tamagno_zebra[k]="P";
						}
						if(tamagno_r[k]=="16"){
							tamagno_zebra[k]="Q";
						}
						if(tamagno_r[k]=="15"){
							tamagno_zebra[k]="R";
						}
						if(tamagno_r[k]=="18"){
							tamagno_zebra[k]="S";
						}
					}
					var etiquetasA=
					"^XA^FS^FO0,0^A"+tamagno_zebra[1]+"B^FD"+LineaEtiqueta[1]+
					"^FS^FO15,0^A"+tamagno_zebra[2]+"B^FD"+LineaEtiqueta[2]+
					"^FS^FO30,0^A"+tamagno_zebra[3]+"B^FD"+LineaEtiqueta[3]+
					"^FS^FO45,0^A"+tamagno_zebra[4]+"B^FD"+LineaEtiqueta[4]+
					"^FS^FO60,0^A"+tamagno_zebra[5]+"B^FD"+LineaEtiqueta[5]+
					"^FS^FO75,0^A"+tamagno_zebra[6]+"B^FD"+LineaEtiqueta[6]+
					"^FS^FO90,0^A"+tamagno_zebra[7]+"B^FD"+LineaEtiqueta[7]+
					"^FS^FO105,0^A"+tamagno_zebra[8]+"B^FD"+LineaEtiqueta[8]+
					"^FS^FO120,0^A"+tamagno_zebra[9]+"B^FD"+LineaEtiqueta[9]+
					"^FS^FO135,0^A"+tamagno_zebra[10]+"B^FD"+LineaEtiqueta[10]+
					"^FS^FO150,0^A"+tamagno_zebra[11]+"B^FD"+LineaEtiqueta[11]+
					"^FS^FO165,0^A"+tamagno_zebra[12]+"B^FD"+LineaEtiqueta[12]+
					"^FS^FO180,0^A"+tamagno_zebra[13]+"B^FD"+LineaEtiqueta[13]+
					"^FS^FO195,0^A"+tamagno_zebra[14]+"B^FD"+LineaEtiqueta[14]+
					"^FS^FO210,0^A"+tamagno_zebra[15]+"B^FD"+LineaEtiqueta[15]+
					"^FS^FO225,0^A"+tamagno_zebra[16]+"B^FD"+LineaEtiqueta[16]+
					"^FS^FO280,0^A"+tamagno_zebra[1]+"B^FD"+LineaEtiqueta[1]+
					"^FS^FO295,0^A"+tamagno_zebra[2]+"B^FD"+LineaEtiqueta[2]+
					"^FS^FO310,0^A"+tamagno_zebra[3]+"B^FD"+LineaEtiqueta[3]+
					"^FS^FO325,0^A"+tamagno_zebra[4]+"B^FD"+LineaEtiqueta[4]+
					"^FS^FO340,0^A"+tamagno_zebra[5]+"B^FD"+LineaEtiqueta[5]+
					"^FS^FO355,0^A"+tamagno_zebra[6]+"B^FD"+LineaEtiqueta[6]+
					"^FS^FO370,0^A"+tamagno_zebra[7]+"B^FD"+LineaEtiqueta[7]+
					"^FS^FO385,0^A"+tamagno_zebra[8]+"B^FD"+LineaEtiqueta[8]+
					"^FS^FO400,0^A"+tamagno_zebra[9]+"B^FD"+LineaEtiqueta[9]+
					"^FS^FO415,0^A"+tamagno_zebra[10]+"B^FD"+LineaEtiqueta[10]+
					"^FS^FO430,0^A"+tamagno_zebra[11]+"B^FD"+LineaEtiqueta[11]+
					"^FS^FO445,0^A"+tamagno_zebra[12]+"B^FD"+LineaEtiqueta[12]+
					"^FS^FO460,0^A"+tamagno_zebra[13]+"B^FD"+LineaEtiqueta[13]+
					"^FS^FO475,0^A"+tamagno_zebra[14]+"B^FD"+LineaEtiqueta[14]+
					"^FS^FO490,0^A"+tamagno_zebra[15]+"B^FD"+LineaEtiqueta[15]+
					"^FS^FO505,0^A"+tamagno_zebra[16]+"B^FD"+LineaEtiqueta[16]+
					"^FS^FO560,0^A"+tamagno_zebra[1]+"B^FD"+LineaEtiqueta[1]+
					"^FS^FO575,0^A"+tamagno_zebra[2]+"B^FD"+LineaEtiqueta[2]+
					"^FS^FO590,0^A"+tamagno_zebra[3]+"B^FD"+LineaEtiqueta[3]+
					"^FS^FO605,0^A"+tamagno_zebra[4]+"B^FD"+LineaEtiqueta[4]+
					"^FS^FO620,0^A"+tamagno_zebra[5]+"B^FD"+LineaEtiqueta[5]+
					"^FS^FO635,0^A"+tamagno_zebra[6]+"B^FD"+LineaEtiqueta[6]+
					"^FS^FO650,0^A"+tamagno_zebra[7]+"B^FD"+LineaEtiqueta[7]+
					"^FS^FO665,0^A"+tamagno_zebra[8]+"B^FD"+LineaEtiqueta[8]+
					"^FS^FO680,0^A"+tamagno_zebra[9]+"B^FD"+LineaEtiqueta[9]+
					"^FS^FO695,0^A"+tamagno_zebra[10]+"B^FD"+LineaEtiqueta[10]+
					"^FS^FO710,0^A"+tamagno_zebra[11]+"B^FD"+LineaEtiqueta[11]+
					"^FS^FO725,0^A"+tamagno_zebra[12]+"B^FD"+LineaEtiqueta[12]+
					"^FS^FO740,0^A"+tamagno_zebra[13]+"B^FD"+LineaEtiqueta[13]+
					"^FS^FO755,0^A"+tamagno_zebra[14]+"B^FD"+LineaEtiqueta[14]+
					"^FS^FO760,0^A"+tamagno_zebra[15]+"B^FD"+LineaEtiqueta[15]+
					"^FS^FO775,0^A"+tamagno_zebra[16]+"B^FD"+LineaEtiqueta[16]+"^XZ";
					etiquetasABC=etiquetasA;
					for(i=0;i<v_cantidad;i++){
						document.jzebra.findPrinter("zebra");
						document.jzebra.append(etiquetasABC); 
						document.jzebra.print();
					}

				}
			}
			if(v_tamagno=="4X3"){
				if(v_orientacion=="horizontal"){
					for(i=1;i<=MaxInputs;i++){
						if(LineaEtiqueta[i]==undefined)
							LineaEtiqueta[i]=" ";
					}
					for(k=1;k<=totalLineas;k++){
						if(tamagno_r[k]=="8"){
							tamagno_zebra[k]="B";
							etiqueta4x3A[k-1]=parseInt(etiqueta4x3A[k-1])+7;
							etiqueta4x3B[k-1]=parseInt(etiqueta4x3B[k-1])+7;
							etiqueta4x3C[k-1]=parseInt(etiqueta4x3C[k-1])+7;
						}
						if(tamagno_r[k]=="12"){
							tamagno_zebra[k]="D";
						}
						if(tamagno_r[k]=="16"){
							tamagno_zebra[k]="P";
							etiqueta4x3A[k-1]=parseInt(etiqueta4x3A[k-1])-5;
							etiqueta4x3B[k-1]=parseInt(etiqueta4x3B[k-1])-5;
							etiqueta4x3C[k-1]=parseInt(etiqueta4x3C[k-1])-5;
						}
						if(tamagno_r[k]=="15"){
							tamagno_zebra[k]="Q";
							etiqueta4x3A[k-1]=parseInt(etiqueta4x3A[k-1])-5;
							etiqueta4x3B[k-1]=parseInt(etiqueta4x3B[k-1])-5;
							etiqueta4x3C[k-1]=parseInt(etiqueta4x3C[k-1])-5;
						}
						if(tamagno_r[k]=="18"){
							tamagno_zebra[k]="R";
							etiqueta4x3A[k-1]=parseInt(etiqueta4x3A[k-1])-20;
							etiqueta4x3B[k-1]=parseInt(etiqueta4x3B[k-1])-20;
							etiqueta4x3C[k-1]=parseInt(etiqueta4x3C[k-1])-20;
						}
					}
					var etiquetasA="^XA"+
					"^FS^FO"+etiqueta4x3A[0]+",15^A"+tamagno_zebra[1]+"R^FD"+LineaEtiqueta[1]+
						"^FS^FO"+etiqueta4x3A[1]+",15^A"+tamagno_zebra[2]+"R^FD"+LineaEtiqueta[2]+
						"^FS^FO"+etiqueta4x3A[2]+",15^A"+tamagno_zebra[3]+"R^FD"+LineaEtiqueta[3]+
						"^FS^FO"+etiqueta4x3A[3]+",15^A"+tamagno_zebra[4]+"R^FD"+LineaEtiqueta[4]+
						"^FS^FO"+etiqueta4x3A[4]+",15^A"+tamagno_zebra[5]+"R^FD"+LineaEtiqueta[5]+
						"^FS^FO"+etiqueta4x3A[5]+",15^A"+tamagno_zebra[6]+"R^FD"+LineaEtiqueta[6]+
						"^FS^FO"+etiqueta4x3A[6]+",15^A"+tamagno_zebra[7]+"R^FD"+LineaEtiqueta[7]+
						"^FS^FO"+etiqueta4x3A[7]+",15^A"+tamagno_zebra[8]+"R^FD"+LineaEtiqueta[8]+
						"^FS^FO"+etiqueta4x3A[8]+",15^A"+tamagno_zebra[9]+"R^FD"+LineaEtiqueta[9]+
						"^FS^FO"+etiqueta4x3A[9]+",15^A"+tamagno_zebra[10]+"R^FD"+LineaEtiqueta[10]+
						"^FS^FO"+etiqueta4x3A[10]+",15^A"+tamagno_zebra[11]+"R^FD"+LineaEtiqueta[11]+
						"^FS^FO"+etiqueta4x3A[11]+",15^A"+tamagno_zebra[12]+"R^FD"+LineaEtiqueta[12]+
						"^FS^FO"+etiqueta4x3A[12]+",15^A"+tamagno_zebra[13]+"R^FD"+LineaEtiqueta[13]+
						"^FS^FO"+etiqueta4x3A[13]+",15^A"+tamagno_zebra[14]+"R^FD"+LineaEtiqueta[14]+
						"^FS^FO"+etiqueta4x3B[0]+",15^A"+tamagno_zebra[1]+"R^FD"+LineaEtiqueta[1]+
						"^FS^FO"+etiqueta4x3B[1]+",15^A"+tamagno_zebra[2]+"R^FD"+LineaEtiqueta[2]+
						"^FS^FO"+etiqueta4x3B[2]+",15^A"+tamagno_zebra[3]+"R^FD"+LineaEtiqueta[3]+
						"^FS^FO"+etiqueta4x3B[3]+",15^A"+tamagno_zebra[4]+"R^FD"+LineaEtiqueta[4]+
						"^FS^FO"+etiqueta4x3B[4]+",15^A"+tamagno_zebra[5]+"R^FD"+LineaEtiqueta[5]+
						"^FS^FO"+etiqueta4x3B[5]+",15^A"+tamagno_zebra[6]+"R^FD"+LineaEtiqueta[6]+
						"^FS^FO"+etiqueta4x3B[6]+",15^A"+tamagno_zebra[7]+"R^FD"+LineaEtiqueta[7]+
						"^FS^FO"+etiqueta4x3B[7]+",15^A"+tamagno_zebra[8]+"R^FD"+LineaEtiqueta[8]+
						"^FS^FO"+etiqueta4x3B[8]+",15^A"+tamagno_zebra[9]+"R^FD"+LineaEtiqueta[9]+
						"^FS^FO"+etiqueta4x3B[9]+",15^A"+tamagno_zebra[10]+"R^FD"+LineaEtiqueta[10]+
						"^FS^FO"+etiqueta4x3B[10]+",15^A"+tamagno_zebra[11]+"R^FD"+LineaEtiqueta[11]+
						"^FS^FO"+etiqueta4x3B[11]+",15^A"+tamagno_zebra[12]+"R^FD"+LineaEtiqueta[12]+
						"^FS^FO"+etiqueta4x3B[12]+",15^A"+tamagno_zebra[13]+"R^FD"+LineaEtiqueta[13]+
						"^FS^FO"+etiqueta4x3A[13]+",15^A"+tamagno_zebra[14]+"R^FD"+LineaEtiqueta[14]+
						"^FS^FO"+etiqueta4x3C[0]+",15^A"+tamagno_zebra[1]+"R^FD"+LineaEtiqueta[1]+
						"^FS^FO"+etiqueta4x3C[1]+",15^A"+tamagno_zebra[2]+"R^FD"+LineaEtiqueta[2]+
						"^FS^FO"+etiqueta4x3C[2]+",15^A"+tamagno_zebra[3]+"R^FD"+LineaEtiqueta[3]+
						"^FS^FO"+etiqueta4x3C[3]+",15^A"+tamagno_zebra[4]+"R^FD"+LineaEtiqueta[4]+
						"^FS^FO"+etiqueta4x3C[4]+",15^A"+tamagno_zebra[5]+"R^FD"+LineaEtiqueta[5]+
						"^FS^FO"+etiqueta4x3C[5]+",15^A"+tamagno_zebra[6]+"R^FD"+LineaEtiqueta[6]+
						"^FS^FO"+etiqueta4x3C[6]+",15^A"+tamagno_zebra[7]+"R^FD"+LineaEtiqueta[7]+
						"^FS^FO"+etiqueta4x3C[7]+",15^A"+tamagno_zebra[8]+"R^FD"+LineaEtiqueta[8]+
						"^FS^FO"+etiqueta4x3C[8]+",15^A"+tamagno_zebra[9]+"R^FD"+LineaEtiqueta[9]+
						"^FS^FO"+etiqueta4x3C[9]+",15^A"+tamagno_zebra[10]+"R^FD"+LineaEtiqueta[10]+
						"^FS^FO"+etiqueta4x3C[10]+",15^A"+tamagno_zebra[11]+"R^FD"+LineaEtiqueta[11]+
						"^FS^FO"+etiqueta4x3C[11]+",15^A"+tamagno_zebra[12]+"R^FD"+LineaEtiqueta[12]+
						"^FS^FO"+etiqueta4x3C[12]+",15^A"+tamagno_zebra[13]+"R^FD"+LineaEtiqueta[13]+
						"^FS^FO"+etiqueta4x3A[13]+",15^A"+tamagno_zebra[14]+"R^FD"+LineaEtiqueta[14]+
					    "^XZ";
					etiquetasABC=etiquetasA;
					for(i=0;i<v_cantidad;i++){
						document.jzebra.findPrinter("zebra");
						document.jzebra.append(etiquetasABC); 
						document.jzebra.print();
					}
				}
				if(v_orientacion=="vertical"){

					v_etiqueta4x3A = new Array("37","54","71","88","105","122","139","156","173","190","207","224","241","258","275","292","309","326");

					for(i=1;i<=MaxInputs;i++){
						if(LineaEtiqueta[i]==undefined)
							LineaEtiqueta[i]=" ";
					}
					for(k=1;k<=totalLineas;k++){
						if(tamagno_r[k]=="8"){
							tamagno_zebra[k]="B";
							etiqueta4x3A[k-1]=parseInt(etiqueta4x3A[k-1])+7;
							etiqueta4x3B[k-1]=parseInt(etiqueta4x3B[k-1])+7;
							etiqueta4x3C[k-1]=parseInt(etiqueta4x3C[k-1])+7;
						}
						if(tamagno_r[k]=="12"){
							tamagno_zebra[k]="D";
						}
						if(tamagno_r[k]=="16"){
							tamagno_zebra[k]="P";
							etiqueta4x3A[k-1]=parseInt(etiqueta4x3A[k-1])-5;
							etiqueta4x3B[k-1]=parseInt(etiqueta4x3B[k-1])-5;
							etiqueta4x3C[k-1]=parseInt(etiqueta4x3C[k-1])-5;
						}
						if(tamagno_r[k]=="15"){
							tamagno_zebra[k]="Q";
							etiqueta4x3A[k-1]=parseInt(etiqueta4x3A[k-1])-5;
							etiqueta4x3B[k-1]=parseInt(etiqueta4x3B[k-1])-5;
							etiqueta4x3C[k-1]=parseInt(etiqueta4x3C[k-1])-5;
						}
						if(tamagno_r[k]=="18"){
							tamagno_zebra[k]="R";
							etiqueta4x3A[k-1]=parseInt(etiqueta4x3A[k-1])-20;
							etiqueta4x3B[k-1]=parseInt(etiqueta4x3B[k-1])-20;
							etiqueta4x3C[k-1]=parseInt(etiqueta4x3C[k-1])-20;
						}
					}
					var etiquetasA=
					"^XA^FS^FO0,"+v_etiqueta4x3A[0]+"^A"+tamagno_zebra[1]+"N^FD"+LineaEtiqueta[1]+
					"^FS^FO0,"+v_etiqueta4x3A[1]+"^A"+tamagno_zebra[2]+"N^FD"+LineaEtiqueta[2]+
					"^FS^FO0,"+v_etiqueta4x3A[2]+"^A"+tamagno_zebra[3]+"N^FD"+LineaEtiqueta[3]+
					"^FS^FO0,"+v_etiqueta4x3A[3]+"^A"+tamagno_zebra[4]+"N^FD"+LineaEtiqueta[4]+
					"^FS^FO0,"+v_etiqueta4x3A[4]+"^A"+tamagno_zebra[5]+"N^FD"+LineaEtiqueta[5]+
					"^FS^FO0,"+v_etiqueta4x3A[5]+"^A"+tamagno_zebra[6]+"N^FD"+LineaEtiqueta[6]+
					"^FS^FO0,"+v_etiqueta4x3A[6]+"^A"+tamagno_zebra[7]+"N^FD"+LineaEtiqueta[7]+
					"^FS^FO0,"+v_etiqueta4x3A[7]+"^A"+tamagno_zebra[8]+"N^FD"+LineaEtiqueta[8]+
					"^FS^FO0,"+v_etiqueta4x3A[8]+"^A"+tamagno_zebra[9]+"N^FD"+LineaEtiqueta[9]+
					"^FS^FO0,"+v_etiqueta4x3A[9]+"^A"+tamagno_zebra[10]+"N^FD"+LineaEtiqueta[10]+
					"^FS^FO0,"+v_etiqueta4x3A[10]+"^A"+tamagno_zebra[11]+"N^FD"+LineaEtiqueta[11]+
					"^FS^FO0,"+v_etiqueta4x3A[11]+"^A"+tamagno_zebra[12]+"N^FD"+LineaEtiqueta[12]+
					"^FS^FO0,"+v_etiqueta4x3A[12]+"^A"+tamagno_zebra[13]+"N^FD"+LineaEtiqueta[13]+
					"^FS^FO0,"+v_etiqueta4x3A[13]+"^A"+tamagno_zebra[14]+"N^FD"+LineaEtiqueta[14]+
					"^FS^FO0,"+v_etiqueta4x3A[14]+"^A"+tamagno_zebra[15]+"N^FD"+LineaEtiqueta[15]+
					"^FS^FO0,"+v_etiqueta4x3A[15]+"^A"+tamagno_zebra[16]+"N^FD"+LineaEtiqueta[16]+
					"^FS^FO0,"+v_etiqueta4x3A[16]+"^A"+tamagno_zebra[17]+"N^FD"+LineaEtiqueta[17]+
					"^FS^FO260,"+v_etiqueta4x3A[0]+"^A"+tamagno_zebra[1]+"N^FD"+LineaEtiqueta[1]+
					"^FS^FO260,"+v_etiqueta4x3A[1]+"^A"+tamagno_zebra[2]+"N^FD"+LineaEtiqueta[2]+
					"^FS^FO260,"+v_etiqueta4x3A[2]+"^A"+tamagno_zebra[3]+"N^FD"+LineaEtiqueta[3]+
					"^FS^FO260,"+v_etiqueta4x3A[3]+"^A"+tamagno_zebra[4]+"N^FD"+LineaEtiqueta[4]+
					"^FS^FO260,"+v_etiqueta4x3A[4]+"^A"+tamagno_zebra[5]+"N^FD"+LineaEtiqueta[5]+
					"^FS^FO260,"+v_etiqueta4x3A[5]+"^A"+tamagno_zebra[6]+"N^FD"+LineaEtiqueta[6]+
					"^FS^FO260,"+v_etiqueta4x3A[6]+"^A"+tamagno_zebra[7]+"N^FD"+LineaEtiqueta[7]+
					"^FS^FO260,"+v_etiqueta4x3A[7]+"^A"+tamagno_zebra[8]+"N^FD"+LineaEtiqueta[8]+
					"^FS^FO260,"+v_etiqueta4x3A[8]+"^A"+tamagno_zebra[9]+"N^FD"+LineaEtiqueta[9]+
					"^FS^FO260,"+v_etiqueta4x3A[9]+"^A"+tamagno_zebra[10]+"N^FD"+LineaEtiqueta[10]+
					"^FS^FO260,"+v_etiqueta4x3A[10]+"^A"+tamagno_zebra[11]+"N^FD"+LineaEtiqueta[11]+
					"^FS^FO260,"+v_etiqueta4x3A[11]+"^A"+tamagno_zebra[12]+"N^FD"+LineaEtiqueta[12]+
					"^FS^FO260,"+v_etiqueta4x3A[12]+"^A"+tamagno_zebra[13]+"N^FD"+LineaEtiqueta[13]+
					"^FS^FO260,"+v_etiqueta4x3A[13]+"^A"+tamagno_zebra[14]+"N^FD"+LineaEtiqueta[14]+
					"^FS^FO260,"+v_etiqueta4x3A[14]+"^A"+tamagno_zebra[15]+"N^FD"+LineaEtiqueta[15]+
					"^FS^FO260,"+v_etiqueta4x3A[15]+"^A"+tamagno_zebra[16]+"N^FD"+LineaEtiqueta[16]+
					"^FS^FO260,"+v_etiqueta4x3A[16]+"^A"+tamagno_zebra[17]+"N^FD"+LineaEtiqueta[17]+
					"^FS^FO530,"+v_etiqueta4x3A[0]+"^A"+tamagno_zebra[1]+"N^FD"+LineaEtiqueta[1]+
					"^FS^FO530,"+v_etiqueta4x3A[1]+"^A"+tamagno_zebra[2]+"N^FD"+LineaEtiqueta[2]+
					"^FS^FO530,"+v_etiqueta4x3A[2]+"^A"+tamagno_zebra[3]+"N^FD"+LineaEtiqueta[3]+
					"^FS^FO530,"+v_etiqueta4x3A[3]+"^A"+tamagno_zebra[4]+"N^FD"+LineaEtiqueta[4]+
					"^FS^FO530,"+v_etiqueta4x3A[4]+"^A"+tamagno_zebra[5]+"N^FD"+LineaEtiqueta[5]+
					"^FS^FO530,"+v_etiqueta4x3A[5]+"^A"+tamagno_zebra[6]+"N^FD"+LineaEtiqueta[6]+
					"^FS^FO530,"+v_etiqueta4x3A[6]+"^A"+tamagno_zebra[7]+"N^FD"+LineaEtiqueta[7]+
					"^FS^FO530,"+v_etiqueta4x3A[7]+"^A"+tamagno_zebra[8]+"N^FD"+LineaEtiqueta[8]+
					"^FS^FO530,"+v_etiqueta4x3A[8]+"^A"+tamagno_zebra[9]+"N^FD"+LineaEtiqueta[9]+
					"^FS^FO530,"+v_etiqueta4x3A[9]+"^A"+tamagno_zebra[10]+"N^FD"+LineaEtiqueta[10]+
					"^FS^FO530,"+v_etiqueta4x3A[10]+"^A"+tamagno_zebra[11]+"N^FD"+LineaEtiqueta[11]+
					"^FS^FO530,"+v_etiqueta4x3A[11]+"^A"+tamagno_zebra[12]+"N^FD"+LineaEtiqueta[12]+
					"^FS^FO530,"+v_etiqueta4x3A[12]+"^A"+tamagno_zebra[13]+"N^FD"+LineaEtiqueta[13]+
					"^FS^FO530,"+v_etiqueta4x3A[13]+"^A"+tamagno_zebra[14]+"N^FD"+LineaEtiqueta[14]+
					"^FS^FO530,"+v_etiqueta4x3A[14]+"^A"+tamagno_zebra[15]+"N^FD"+LineaEtiqueta[15]+
					"^FS^FO530,"+v_etiqueta4x3A[15]+"^A"+tamagno_zebra[16]+"N^FD"+LineaEtiqueta[16]+
					"^FS^FO530,"+v_etiqueta4x3A[16]+"^A"+tamagno_zebra[17]+"N^FD"+LineaEtiqueta[17]+
					"^XZ";
					etiquetasABC=etiquetasA;
					for(i=0;i<v_cantidad;i++){
						document.jzebra.findPrinter("zebra");
						document.jzebra.append(etiquetasABC); 
						document.jzebra.print();
					}
				}
			}
		}
	</script>
	</head>
	<body>
		<div id="lienzoetiqueta">
			<div id="menusuperior">
				<table>
					<tr>
						<td>
							<img src="images/162.png" height="24px" width="24px" style="cursor:pointer;" onclick="javascript:location.href='newetiquetas_index.asp?t_u=<%=tipo_usuario%>';">
						</td>
						<td id="letra_estaticas">Seleccione tama&ntilde;o</td>
						<td>
							<select name="tamagnoEtiqueta" id="tamagnoEtiqueta" disabled>
								<option value="<%=rs("tipo_etiqueta")%>" selected><%=rs("tipo_etiqueta")%> cm</option>
							</select>
						</td>
						<td><img src="images/07.png" height="24" width="24" style="cursor:pointer;" onclick="AgregarCampos(1);" id="agregar_linea" name="agregar_linea"></td>
						<td><img src="images/012.png" height="24" width="24" style="cursor:pointer;" onclick="AgregarCampos(2);" id="quitar_linea" name="agregar_linea"></td>
						<td id="letra_estaticas">Cantidad a Imprimir</td><td><input type="text" name="cantidad" id="cantidad" size="10" maxlength="3" value="1"></td>
						<td><input type="button" name="imprimir" id="imprimir" value="Imprimir" onclick="imprimir();"></td>
						<td><input type="button" name="guardar" id="guardar" onclick="guardar_etiqueta();" value="Guardar"></td>
						<td><input type="button" name="eliminar" id="eliminar" onclick="eliminar();" value="Eliminar"></td>
					</tr>
				</table>
			</div>
			<div id="menulateralizq">
				<table  id="titulo_etiqueta">
					<tr>
						<td id="letra_estaticas">
							Titulo Etiqueta:<input type="text" name="nombre_etiqueta" id="nombre_etiqueta" size="25" value="<%=rs("nombre_etiqueta")%>">
							<br>Orientacion: <select name='orientacion' id='orientacion'>
											<option value="horizontal">Horizontal</option>
											<option value="vertical">Vertical</option>
										</select>	
						</td>
					</tr>
				</table>
				<table>
					<tr>
						<td>	
							<div id="added">
								<%For i=0 To count-1%>
									<input type="text" class="linea_editar" style="width:250px; font-family:courier;" value="<%=texto(i)%>" id="campo_<%=i+1%>" name="campo_<%=i+1%>" onclick="dibujarLetra(<%=i+1%>);"><select name="tamanolinea_<%=i+1%>" id="tamanolinea_<%=i+1%>"><option value="<%=tamlinea(i)%>"><%=tamlinea(i)%></option><option value="8">8</option><option value="12">12</option><option value="16">16</option>	<option value="15">20</option>	<option value="18">24</option><option value="24">32</option></select>
								<%Next%>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div id="menulateralder">
				<br>
				<div id="etiqueta3x2" style="visibility: hidden;">
					<span id="word_preview" style="font-family:courier;"></span>
				</div>
			</div>
		</div>
		<input type="text" id="numero_interno_etiqueta" style="visibility: hidden;" value="<%=x_numero_interno_etiqueta%>">
		<applet name="jzebra" id="jzebra" code="jzebra.PrintApplet.class" archive="js/jzebra.jar" width="1" height="1">
			<param name="printer" value="zebra">
		</applet>
	</body>
</html>