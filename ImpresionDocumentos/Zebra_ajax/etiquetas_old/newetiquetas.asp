<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
	Server.ScriptTimeOut = 1000
	'*********** Especifica la codificaciуn y evita usar cachй **********
	Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
	Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
	OpenConn_Alta
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
			$(document).ready(function(){
				$("#tamagnoEtiqueta").change(function(){
					optionTamagno=$("#tamagnoEtiqueta").val();
					if(optionTamagno=="3X2"){
						crearEtiqueta=confirm("Desea Crear la etiqueta con el porte "+optionTamagno+"");
						$("#etiqueta3x2").css("visibility","visible");
						$("#ocultar_opcion").css('visibility', 'visible');
						$("#titulo_etiqueta").css('visibility', 'visible');
						$("#etiqueta3x2").css("background-image","url('./images/background3x2.png')");
						if(crearEtiqueta){
							$.ajax({
								dataType: "json",
								type: "post",
								url: "etiquetas_grabar.asp",
								data: "accion=INSERT&tipo_etiqueta = "+escape($("#tamagnoEtiqueta").val()),
								success: function(data){
									$("#numero_interno_etiqueta").val(data.valor);
									if(data.accion=="OK"){
										$("#ocultar_opcion").css('visibility', 'visible');
										$("#tamagnoEtiqueta").css('disabled');
									}
									else{
										alert("Ocurriу un error al intentar crear el registro de la etiqueta. Informaciуn tйcnica del error: \n"+data.valor)
									}/*Fin Else*/
								}/*Fin succes*/
							});/*Fin ajax*/
						}
					} // fin 3x2
					if(optionTamagno=="4X3"){
						crearEtiqueta=confirm("Desea Crear la etiqueta con el porte "+optionTamagno+"");
						$("#etiqueta3x2").css("visibility","visible");
						$("#ocultar_opcion").css('visibility', 'visible');
						$("#titulo_etiqueta").css('visibility', 'visible');
						$("#etiqueta3x2").css("background-image","url('./images/background4x3.png')");
						if(crearEtiqueta){
							$.ajax({
								dataType: "json",
								type: "post",
								url: "etiquetas_grabar.asp",
								data: "accion=INSERT&tipo_etiqueta = "+escape($("#tamagnoEtiqueta").val()),
								success: function(data){
									$("#numero_interno_etiqueta").val(data.valor);
									if(data.accion=="OK"){
										$("#ocultar_opcion").css('visibility', 'visible');
										$("#tamagnoEtiqueta").css('disabled');
									}/*Fin data.accion*/
									else{
										alert("Ocurriу un error al intentar crear el registro de la etiqueta. Informaciуn tйcnica del error: \n"+data.valor)
									}/*Fin Else*/
								}/*fin succes*/
							});/*Fin ajax*/
						}
					}/*fin if 4x3*/
					if(optionTamagno=="10X5"){
						crearEtiqueta=confirm("Desea Crear la etiqueta con el porte "+optionTamagno+"");
						$("#etiqueta3x2").css("visibility","visible");
						$("#ocultar_opcion").css('visibility', 'visible');
						$("#titulo_etiqueta").css('visibility', 'visible');
						$("#etiqueta3x2").css("background-image","url('./images/background10x5.png')");
						if(crearEtiqueta){
							$.ajax({
								dataType: "json",
								type: "post",
								url: "etiquetas_grabar.asp",
								data: "accion=INSERT&tipo_etiqueta = "+escape($("#tamagnoEtiqueta").val()),
								success: function(data){
									$("#numero_interno_etiqueta").val(data.valor);
									if(data.accion=="OK"){
										$("#ocultar_opcion").css('visibility', 'visible');
										$("#tamagnoEtiqueta").css('disabled');
									}
									else{
										alert("Ocurriу un error al intentar crear el registro de la etiqueta. Informaciуn tйcnica del error: \n"+data.valor)
									}/*Fin Else*/
								}/*Fin data.accion*/
							});/*Fin ajax*/
						}
					}/*fin if 10x5*/
				});	//fin change function tamagnoEtiqueta		
			}); //fin ready
			function imprimir(){
				tamagno_r = new Array();
				tamagno_zebra = new Array();
				etiqueta4x3A = new Array("204","187","170","153","136","119","102","85","68","51","34","17");
				etiqueta4x3B = new Array("470","453","436","419","402","385","368","351","334","317","300","283");
				etiqueta4x3C = new Array("735","718","701","684","667","650","633","616","599","582","565","548");
				etiqueta10x5 = new Array("0","20","40","60","80","100","120","140","160","180","200","220","240","260","280","300");
				v_tamagno=$("#tamagnoEtiqueta").val();
				v_cantidad=$("#cantidad").val();
				v_orientacion=$("#orientacion").val();
				var v_lineaEditar=$(".linea_editar");
				totalLineas=v_lineaEditar.length;/*total de text boxes en la pagina que tienen como class linea_editar*/
				for(i=1;i<=totalLineas;i++){
					LineaEtiqueta[i]=$("#campo_"+i+"").val();
					tamagno_r[i]=$("#tamanolinea_"+i+"").val();
					for(j=1;j<=totalLineas;j++){/*cambiar por el maximo global*/
						if(LineaEtiqueta[j]==undefined){
							LineaEtiqueta[j]=" ";
							tamagno_r[j]=" ";
						}
					}
				}
				//console.log(totalLineas);
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
						}
						var etiquetas = "\""+"^XA^FO15,"+etiqueta10x5[0]+"^A"+tamagno_zebra[1]+"^FD"+LineaEtiqueta[1]+"^FS^FO15,"+etiqueta10x5[1]+"^A"+tamagno_zebra[2]+"^FD"+LineaEtiqueta[2]+"^FS^FO15,"+etiqueta10x5[2]+"^A"+tamagno_zebra[3]+"^FD"+LineaEtiqueta[3]+"^FS^FO15,"+etiqueta10x5[3]+"^A"+tamagno_zebra[4]+"^FD"+LineaEtiqueta[4]+"^FS^FO15,"+etiqueta10x5[4]+"^A"+tamagno_zebra[5]+"^FD"+LineaEtiqueta[5]+"^FS^FO15,"+etiqueta10x5[5]+"^A"+tamagno_zebra[6]+"^FD"+LineaEtiqueta[6]+"^FS^FO15,"+etiqueta10x5[6]+"^A"+tamagno_zebra[7]+"^FD"+LineaEtiqueta[7]+"^FS^FO15,"+etiqueta10x5[7]+"^A"+tamagno_zebra[8]+"^FD"+LineaEtiqueta[8]+"^FS^FO15,"+etiqueta10x5[8]+"^A"+tamagno_zebra[9]+"^FD"+LineaEtiqueta[9]+"^FS^FO15,"+etiqueta10x5[9]+"^A"+tamagno_zebra[10]+"^FD"+LineaEtiqueta[10]+"^FS^FO15,"+etiqueta10x5[10]+"^A"+tamagno_zebra[11]+"^FD"+LineaEtiqueta[11]+"^FS^FO15,"+etiqueta10x5[11]+"^A"+tamagno_zebra[12]+"^FD"+LineaEtiqueta[12]+"^FS^FO15,"+etiqueta10x5[12]+"^A"+tamagno_zebra[13]+"^FD"+LineaEtiqueta[13]+"^FS^FO15,"+etiqueta10x5[13]+"^A"+tamagno_zebra[14]+"^FD"+LineaEtiqueta[14]+"^FS^FO15,"+etiqueta10x5[14]+"^A"+tamagno_zebra[15]+"^FD"+LineaEtiqueta[15]+"^FS^FO15,"+etiqueta10x5[15]+"^A"+tamagno_zebra[16]+"^FD"+LineaEtiqueta[16]+"^XZ"+"\"";
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
						var etiquetasA="^XA^FO0,15^A"+tamagno_zebra[1]+"^FD"+LineaEtiqueta[1]+"^FS^FO0,30^A"+tamagno_zebra[2]+"^FD"+LineaEtiqueta[2]+"^FS^FO0,45^A"+tamagno_zebra[3]+"^FD"+LineaEtiqueta[3]+"^FS^FO0,60^A"+tamagno_zebra[4]+"^FD"+LineaEtiqueta[4]+"^FS^FO0,75^A"+tamagno_zebra[5]+"^FD"+LineaEtiqueta[5]+"^FS^FO0,90^A"+tamagno_zebra[6]+"^FD"+LineaEtiqueta[6]+"^FS^FO0,105^A"+tamagno_zebra[7]+"^FD"+LineaEtiqueta[7]+"^FS^FO0,120^A"+tamagno_zebra[8]+"^FD"+LineaEtiqueta[8]+"^FS^FO0,135^A"+tamagno_zebra[9]+"^FD"+LineaEtiqueta[9]+"^FS^FO0,150^A"+tamagno_zebra[10]+"^FD"+LineaEtiqueta[10]+"^FS^FO0,165^A"+tamagno_zebra[11]+"^FD"+LineaEtiqueta[11]+"^FS^FO280,15^A"+tamagno_zebra[1]+"^FD"+LineaEtiqueta[1]+"^FS^FO280,30^A"+tamagno_zebra[2]+"^FD"+LineaEtiqueta[2]+"^FS^FO280,45^A"+tamagno_zebra[3]+"^FD"+LineaEtiqueta[3]+"^FS^FO280,60^A"+tamagno_zebra[4]+"^FD"+LineaEtiqueta[4]+"^FS^FO280,75^A"+tamagno_zebra[5]+"^FD"+LineaEtiqueta[5]+"^FS^FO280,90^A"+tamagno_zebra[6]+"^FD"+LineaEtiqueta[6]+"^FS^FO280,105^A"+tamagno_zebra[7]+"^FD"+LineaEtiqueta[7]+"^FS^FO280,120^A"+tamagno_zebra[8]+"^FD"+LineaEtiqueta[8]+"^FS^FO280,135^A"+tamagno_zebra[9]+"^FD"+LineaEtiqueta[9]+"^FS^FO280,150^A"+tamagno_zebra[10]+"^FD"+LineaEtiqueta[10]+"^FS^FO280,165^A"+tamagno_zebra[11]+"^FD"+LineaEtiqueta[11]+"^FS^FO560,15^A"+tamagno_zebra[1]+"^FD"+LineaEtiqueta[1]+"^FS^FO560,30^A"+tamagno_zebra[2]+"^FD"+LineaEtiqueta[2]+"^FS^FO560,45^A"+tamagno_zebra[3]+"^FD"+LineaEtiqueta[3]+"^FS^FO560,60^A"+tamagno_zebra[4]+"^FD"+LineaEtiqueta[4]+"^FS^FO560,75^A"+tamagno_zebra[5]+"^FD"+LineaEtiqueta[5]+"^FS^FO560,90^A"+tamagno_zebra[6]+"^FD"+LineaEtiqueta[6]+"^FS^FO560,105^A"+tamagno_zebra[7]+"^FD"+LineaEtiqueta[7]+"^FS^FO560,120^A"+tamagno_zebra[8]+"^FD"+LineaEtiqueta[8]+"^FS^FO560,135^A"+tamagno_zebra[9]+"^FD"+LineaEtiqueta[9]+"^FS^FO560,150^A"+tamagno_zebra[10]+"^FD"+LineaEtiqueta[10]+"^FS^FO560,165^A"+tamagno_zebra[11]+"^FD"+LineaEtiqueta[11]+"^XZ";
						etiquetasABC=etiquetasA//+etiquetasB+etiquetasC
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
						var etiquetasA="^XA^FS^FO"+etiqueta4x3A[0]+",15^A"+tamagno_zebra[1]+"R^FD"+LineaEtiqueta[1]+"^FS^FO"+etiqueta4x3A[1]+",15^A"+tamagno_zebra[2]+"R^FD"+LineaEtiqueta[2]+"^FS^FO"+etiqueta4x3A[2]+",15^A"+tamagno_zebra[3]+"R^FD"+LineaEtiqueta[3]+"^FS^FO"+etiqueta4x3A[3]+",15^A"+tamagno_zebra[4]+"R^FD"+LineaEtiqueta[4]+"^FS^FO"+etiqueta4x3A[4]+",15^A"+tamagno_zebra[5]+"R^FD"+LineaEtiqueta[5]+"^FS^FO"+etiqueta4x3A[5]+",15^A"+tamagno_zebra[6]+"R^FD"+LineaEtiqueta[6]+"^FS^FO"+etiqueta4x3A[6]+",15^A"+tamagno_zebra[7]+"R^FD"+LineaEtiqueta[7]+"^FS^FO"+etiqueta4x3A[7]+",15^A"+tamagno_zebra[8]+"R^FD"+LineaEtiqueta[8]+"^FS^FO"+etiqueta4x3A[8]+",15^A"+tamagno_zebra[9]+"R^FD"+LineaEtiqueta[9]+"^FS^FO"+etiqueta4x3A[9]+",15^A"+tamagno_zebra[10]+"R^FD"+LineaEtiqueta[10]+"^FS^FO"+etiqueta4x3A[10]+",15^A"+tamagno_zebra[11]+"R^FD"+LineaEtiqueta[11]+"^FS^FO"+etiqueta4x3A[11]+",15^A"+tamagno_zebra[12]+"R^FD"+LineaEtiqueta[12]+"^FS^FO"+etiqueta4x3A[12]+",15^A"+tamagno_zebra[13]+"R^FD"+LineaEtiqueta[13]+"^FS^FO"+etiqueta4x3B[0]+",15^A"+tamagno_zebra[1]+"R^FD"+LineaEtiqueta[1]+"^FS^FO"+etiqueta4x3B[1]+",15^A"+tamagno_zebra[2]+"R^FD"+LineaEtiqueta[2]+"^FS^FO"+etiqueta4x3B[2]+",15^A"+tamagno_zebra[3]+"R^FD"+LineaEtiqueta[3]+"^FS^FO"+etiqueta4x3B[3]+",15^A"+tamagno_zebra[4]+"R^FD"+LineaEtiqueta[4]+"^FS^FO"+etiqueta4x3B[4]+",15^A"+tamagno_zebra[5]+"R^FD"+LineaEtiqueta[5]+"^FS^FO"+etiqueta4x3B[5]+",15^A"+tamagno_zebra[6]+"R^FD"+LineaEtiqueta[6]+"^FS^FO"+etiqueta4x3B[6]+",15^A"+tamagno_zebra[7]+"R^FD"+LineaEtiqueta[7]+"^FS^FO"+etiqueta4x3B[7]+",15^A"+tamagno_zebra[8]+"R^FD"+LineaEtiqueta[8]+"^FS^FO"+etiqueta4x3B[8]+",15^A"+tamagno_zebra[9]+"R^FD"+LineaEtiqueta[9]+"^FS^FO"+etiqueta4x3B[9]+",15^A"+tamagno_zebra[10]+"R^FD"+LineaEtiqueta[10]+"^FS^FO"+etiqueta4x3B[10]+",15^A"+tamagno_zebra[11]+"R^FD"+LineaEtiqueta[11]+"^FS^FO"+etiqueta4x3B[11]+",15^A"+tamagno_zebra[12]+"R^FD"+LineaEtiqueta[12]+"^FS^FO"+etiqueta4x3B[12]+",15^A"+tamagno_zebra[13]+"R^FD"+LineaEtiqueta[13]+"^FS^FO"+etiqueta4x3C[0]+",15^A"+tamagno_zebra[1]+"R^FD"+LineaEtiqueta[1]+"^FS^FO"+etiqueta4x3C[1]+",15^A"+tamagno_zebra[2]+"R^FD"+LineaEtiqueta[2]+"^FS^FO"+etiqueta4x3C[2]+",15^A"+tamagno_zebra[3]+"R^FD"+LineaEtiqueta[3]+"^FS^FO"+etiqueta4x3C[3]+",15^A"+tamagno_zebra[4]+"R^FD"+LineaEtiqueta[4]+"^FS^FO"+etiqueta4x3C[4]+",15^A"+tamagno_zebra[5]+"R^FD"+LineaEtiqueta[5]+"^FS^FO"+etiqueta4x3C[5]+",15^A"+tamagno_zebra[6]+"R^FD"+LineaEtiqueta[6]+"^FS^FO"+etiqueta4x3C[6]+",15^A"+tamagno_zebra[7]+"R^FD"+LineaEtiqueta[7]+"^FS^FO"+etiqueta4x3C[7]+",15^A"+tamagno_zebra[8]+"R^FD"+LineaEtiqueta[8]+"^FS^FO"+etiqueta4x3C[8]+",15^A"+tamagno_zebra[9]+"R^FD"+LineaEtiqueta[9]+"^FS^FO"+etiqueta4x3C[9]+",15^A"+tamagno_zebra[10]+"R^FD"+LineaEtiqueta[10]+"^FS^FO"+etiqueta4x3C[10]+",15^A"+tamagno_zebra[11]+"R^FD"+LineaEtiqueta[11]+"^FS^FO"+etiqueta4x3C[11]+",15^A"+tamagno_zebra[12]+"R^FD"+LineaEtiqueta[12]+"^FS^FO"+etiqueta4x3C[12]+",15^A"+tamagno_zebra[13]+"R^FD"+LineaEtiqueta[13]+"^XZ";
						etiquetasABC=etiquetasA;
						for(i=0;i<v_cantidad;i++){
							document.jzebra.findPrinter("zebra");
							document.jzebra.append(etiquetasABC); 
							document.jzebra.print();
						}
					}
					if(v_orientacion=="vertical"){
						v_etiqueta4x3A = new Array("37","54","71","88","105","122","139","156","173","190","207","224","244","264","284","304");

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
						"^FS^FO530,"+v_etiqueta4x3A[15]+"^A"+tamagno_zebra[16]+"N^FD"+LineaEtiqueta[16]+"^XZ";
						etiquetasABC=etiquetasA;
						for(i=0;i<v_cantidad;i++){
							document.jzebra.findPrinter("zebra");
							document.jzebra.append(etiquetasABC); 
							document.jzebra.print();
						}
					}
				}
			}
			function eliminar()	{
				return;
				if(confirm("їEstб seguro que desea eliminar esta etiqueta?")){
					$.ajax({
						dataType: "json",
						type: "post",
						url: "etiquetas_grabar.asp",
						data: "accion=DELETE&numero_interno_etiqueta= "+$("#numero_interno_etiqueta").val(),
						success: function(data){
							location.href='newetiquetas_index.asp';
						}
					});
				}
			}
			var nextinput = 0, maxInput=20;
			function AgregarCampos(opcion){
				if(opcion==1){
					if(nextinput<=MaxInputs){/*MaxInputs es la cantidad total de lineas tipo text que hay en la pagina*/
						nextinput++;
						campo = '<input type="text" class="linea_editar" style="width:250px; font-family:courier;" id="campo_'+nextinput+'" name="campo_' +nextinput+'"/><select name="tamanolinea_'+nextinput+'" id="tamanolinea_'+nextinput+'"><option value="8">8</option><option value="12">12</option><option value="16">16</option><option value="15">20</option><option value="18">24</option></select><br id=br_'+nextinput+'>';
						$("#added").append(campo);
					}
					$("#campo_"+nextinput+"").keyup(function(){
						var tamagnoLinea = new Array();
						var TextoEtiqueta=" ";
						var TextoImprimir=" ";
						for(i=1;i<=MaxInputs;i++){
							LineaEtiqueta[i]=$("#campo_"+i+"").val();
							tamagnoLinea[i]=$("#tamanolinea_"+i).val();
							for(j=1;j<=MaxInputs;j++){
								if(LineaEtiqueta[j]==undefined){
									LineaEtiqueta[j]=" ";
									tamagno[j]=" ";
								}
							}
							TextoEtiqueta=TextoEtiqueta+"<div id='textolinea"+tamagno[i]+"' style='font-size:12px'>&nbsp;&nbsp;"+LineaEtiqueta[i]+"</div>";
						}
						$("#word_preview").html(TextoEtiqueta.replace(/  /g,"&nbsp;&nbsp;"));
					});
				}
				if(opcion==2){
					if(nextinput>=1){
						$("#campo_"+nextinput).remove();
						$("#br_"+nextinput).remove();
						$("#tamanolinea_"+nextinput).remove();
						nextinput--;
					}
				}
			}
			function guardar_etiqueta(){
				var etiqueta = new Array(nextinput);
				var tamagnos = new Array(nextinput);
				var etiquetabd, tamagnosbd;
				v_tamagnoEtiqueta=$("#tamagnoEtiqueta").val();
				v_numero_interno_etiqueta=$("#numero_interno_etiqueta").val();
				v_nombre_etiqueta=$("#nombre_etiqueta").val();
				for(i=1;i<=nextinput;i++){
					if(i<nextinput){
						etiqueta[i]=$("#campo_"+i+"").val();
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
				for(j=1;j<nextinput;j++){
					etiquetabd=etiquetabd+etiqueta[j+1];
					tamagnosbd=tamagnosbd+tamagnos[j+1];
				}
				//etiquetabd=etiquetabd.replace(/ /g,"%20");
				//v_nombre_etiqueta=v_nombre_etiqueta.replace(/ /g,"%20");
				//console.log(v_nombre_etiqueta);
				if(confirm("їGuardar Cambios en etiqueta "+v_nombre_etiqueta+"?")){
					$.ajax({
						dataType: "json",
						type: "post",
						url: "etiquetas_grabar.asp",
						data: "accion=UPDATE&numero_interno_etiqueta="+v_numero_interno_etiqueta+"&detalle_etiqueta="+etiquetabd+"&nombre_etiqueta="+escape(v_nombre_etiqueta)+"&tamagno_linea="+tamagnosbd,
						success: function(data){
							alert("Etiqueta Guardada con exito");
						}
					});//Fin AJAX
				}
				/*$.ajax({
					dataType: "json",
					type: "post",
					url: "etiquetas_grabar.asp",
					async: false,
					data: "accion=UPDATE&numero_interno_etiqueta= "+v_numero_interno_etiqueta+"&detalle_etiqueta= "+etiquetabd+"&nombre_etiqueta= "+escape(v_nombre_etiqueta)+"&tamagno_linea= "+tamagnosbd,
					success: function(data){
						location.href='newetiquetas_index.asp';
					}
				});*/
			}
		</script>
	</head>
	<body>
		<div id="lienzoetiqueta">
			<div id="menusuperior">
				<table>
					<tr>
						<td>
							<table>
								<tr>
									<td>
										<img src="images/162.png" height="24px" width="24px" style="cursor:pointer;" onclick="javascript:location.href='newetiquetas_index.asp'">
									</td>
									<td>Seleccione tama&ntilde;o</td>
									<td>
										<select name="tamagnoEtiqueta" id="tamagnoEtiqueta">
											<option value=" " selected> </option>
											<option value="3X2">3X2 cm</option>
											<option value="4X3">4X3 cm</option>
											<option value="10X5">10X5 cm</option>
										</select>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table id="ocultar_opcion" style="visibility: hidden">
								<tr>
									<td><img src="images/015.png" height="24" width="24" style="cursor:pointer;" onclick="AgregarCampos(1);"></td>
									<td><img src="images/012.png" height="24" width="24" style="cursor:pointer;" onclick="AgregarCampos(2);"></td>
									<td>Cantidad a Imprimir</td><td><input type="text" name="cantidad" id="cantidad" size="10" maxlength="3" value="1"></td>
									<td><input type="button" name="imprimir" id="imprimir" value="Imprimir" onclick="imprimir();"></td>
									<td><input type="button" name="guardar" id="guardar" onclick="guardar_etiqueta();" value="Guardar"></td>
									<td><input type="button" name="eliminar" id="eliminar" onclick="eliminar();" value="Eliminar"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="menulateralizq">
				<table  id="titulo_etiqueta" style="visibility: hidden">
					<tr>
						<td>
							Titulo Etiqueta:<input type="text" name="nombre_etiqueta" id="nombre_etiqueta" size="25">
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
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div id="menulateralder">
				<br>
				<div id="etiqueta3x2" style="visibility: hidden;">
					<span id="word_preview">
					</span>
				</div>
			</div>
		</div>
		<input type="text" id="numero_interno_etiqueta" class="numero_interno_etiqueta" style="visibility: hidden">
		<applet name="jzebra" id="jzebra" code="jzebra.PrintApplet.class" archive="js/jzebra.jar" width="1" height="1">
			<param name="printer" value="zebra">
		</applet>
	</body>
</html>