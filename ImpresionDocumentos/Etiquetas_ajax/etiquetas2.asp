<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/etiqueta.css">
		<script type="text/javascript" src="js/jquery-1.7.2.js"></script>		
		<script type="text/javascript">
			$(document).ready( function(){
				
			});/*FIN .ready*/
			function imprimir(){
				/*console.log("imprimir con exito");*/
				size_letter=$("#size_letter").val();
				cantidad=$("#cantidad").val();
				texto=$("#texto").val();
				texto2=$("#texto2").val();
				texto3=$("#texto3").val();
				texto4=$("#texto4").val();
				texto5=$("#texto5").val();
				texto6=$("#texto6").val();
				texto7=$("#texto7").val();
				texto8=$("#texto8").val();
				texto9=$("#texto9").val();
				texto10=$("#texto10").val();
				texto11=$("#texto11").val();
				console.log(cantidad+"-"+size_letter+"-"+texto);
				if(size_letter==19){
					var etiquetas = "\""+"^XA^FO210,15^A0R,19,19^FD"+texto+"^FS^FO190,15^A0R,19,19^FD"+texto2+"^FS^FO170,15^A0R,19,19^FD"+texto3+"^FS^FO150,15^A0R,19,19^FD"+texto4+"^FS^FO130,15^A0R,19,19^FD"+texto5+"^FS^FO110,15^A0R,19,19^FD"+texto6+"^FS^FO90,15^A0R,19,19^FD"+texto7+"^FS^FO70,15^A0R,19,19^FD"+texto8+"^FS^FO50,15^A0R,19,19^FD"+texto9+"^FS^FO30,15^A0R,19,19^FD"+texto10+"^FS^FO10,15^A0R,19,19^FD"+texto11+"^FS^FO475,15^A0R,19,19^FD"+texto+"^FS^FO455,15^A0R,19,19^FD"+texto2+"^FS^FO435,15^A0R,19,19^FD"+texto3+"^FS^FO415,15^A0R,19,19^FD"+texto4+"^FS^FO395,15^A0R,19,19^FD"+texto5+"^FS^FO375,15^A0R,19,19^FD"+texto6+"^FS^FO355,15^A0R,19,19^FD"+texto7+"^FS^FO335,15^A0R,19,19^FD"+texto8+"^FS^FO315,15^A0R,19,19^FD"+texto9+"^FS^FO295,15^A0R,19,19^FD"+texto10+"^FS^FO275<,15^A0R,19,19^FD"+texto11+"^FS^FO740,15^A0R,19,19^FD"+texto+"^FS^FO720,15^A0R,19,19^FD"+texto2+"^FS^FO700,15^A0R,19,19^FD"+texto3+"^FS^FO680,15^A0R,19,19^FD"+texto4+"^FS^FO660,15^A0R,19,19^FD"+texto5+"^FS^FO640,15^A0R,19,19^FD"+texto6+"^FS^FO620,15^A0R,19,19^FD"+texto7+"^FS^FO600,15^A0R,19,19^FD"+texto8+"^FS^FO580,15^A0R,19,19^FD"+texto9+"^FS^FO560,15^A0R,19,19^FD"+texto10+"^FS^FO540,15^A0R,19,19^FD"+texto11+"^FS^XZ"+"\"";
				}
				else if(size_letter==22){
					var etiquetas = "\""+"^XA^FO210,15^A0R,22,22^FD"+texto+"^FS^FO190,15^A0R,22,22^FD"+texto2+"^FS^FO170,15^A0R,22,22^FD"+texto3+"^FS^FO150,15^A0R,22,22^FD"+texto4+"^FS^FO130,15^A0R,22,22^FD"+texto5+"^FS^FO110,15^A0R,22,22^FD"+texto6+"^FS^FO90,15^A0R,22,22^FD"+texto7+"^FS^FO70,15^A0R,22,22^FD"+texto8+"^FS^FO50,15^A0R,22,22^FD"+texto9+"^FS^FO30,15^A0R,22,22^FD"+texto10+"^FS^FO10,15^A0R,22,22^FD"+texto11+"^FS^FO475,15^A0R,22,22^FD"+texto+"^FS^FO455,15^A0R,22,22^FD"+texto2+"^FS^FO435,15^A0R,22,22^FD"+texto3+"^FS^FO415,15^A0R,22,22^FD"+texto4+"^FS^FO395,15^A0R,22,22^FD"+texto5+"^FS^FO375,15^A0R,22,22^FD"+texto6+"^FS^FO355,15^A0R,22,22^FD"+texto7+"^FS^FO335,15^A0R,22,22^FD"+texto8+"^FS^FO315,15^A0R,22,22^FD"+texto9+"^FS^FO295,15^A0R,22,22^FD"+texto10+"^FS^FO275<,15^A0R,22,22^FD"+texto11+"^FS^FO740,15^A0R,22,22^FD"+texto+"^FS^FO720,15^A0R,22,22^FD"+texto2+"^FS^FO700,15^A0R,22,22^FD"+texto3+"^FS^FO680,15^A0R,22,22^FD"+texto4+"^FS^FO660,15^A0R,22,22^FD"+texto5+"^FS^FO640,15^A0R,22,22^FD"+texto6+"^FS^FO620,15^A0R,22,22^FD"+texto7+"^FS^FO600,15^A0R,22,22^FD"+texto8+"^FS^FO580,15^A0R,22,22^FD"+texto9+"^FS^FO560,15^A0R,22,22^FD"+texto10+"^FS^FO540,15^A0R,22,22^FD"+texto11+"^FS^XZ"+"\"";
				}
				else if(size_letter==26){
					var etiquetas = "\""+"^XA^FO200,15^A0R,26,26^FD"+texto+"^FS^FO180,15^A0R,26,26^FD"+texto2+"^FS^FO160,15^A0R,26,26^FD"+texto3+"^FS^FO140,15^A0R,26,26^FD"+texto4+"^FS^FO120,15^A0R,26,26^FD"+texto5+"^FS^FO90,15^A0R,26,26^FD"+texto6+"^FS^FO70,15^A0R,26,26^FD"+texto7+"^FS^FO50,15^A0R,26,26^FD"+texto8+"^FS^FO3015^A0R,26,26^FD"+texto9+"^FS^FO10,15^A0R,26,26^FD"+texto10+"^FS^FO0,15^A0R,26,26^FD"+texto11+"^FS^FO460,15^A0R,26,26^FD"+texto+"^FS^FO440,15^A0R,26,26^FD"+texto2+"^FS^FO410,15^A0R,26,26^FD"+texto3+"^FS^FO390,15^A0R,26,26^FD"+texto4+"^FS^FO370,15^A0R,26,26^FD"+texto5+"^FS^FO350,15^A0R,26,26^FD"+texto6+"^FS^FO330,15^A0R,26,26^FD"+texto7+"^FS^FO310,15^A0R,26,26^FD"+texto8+"^FS^FO290,15^A0R,26,26^FD"+texto9+"^FS^FO270,15^A0R,26,26^FD"+texto10+"^FS^FO250<,15^A0R,26,26^FD"+texto11+"^FS^FO720,15^A0R,26,26^FD"+texto+"^FS^FO700,15^A0R,26,26^FD"+texto2+"^FS^FO680,15^A0R,26,26^FD"+texto3+"^FS^FO660,15^A0R,26,26^FD"+texto4+"^FS^FO640,15^A0R,26,26^FD"+texto5+"^FS^FO620,15^A0R,26,26^FD"+texto6+"^FS^FO600,15^A0R,26,26^FD"+texto7+"^FS^FO580,15^A0R,26,26^FD"+texto8+"^FS^FO560,15^A0R,26,26^FD"+texto9+"^FS^FO540,15^A0R,26,26^FD"+texto10+"^FS^FO520,15^A0R,26,26^FD"+texto11+"^FS^XZ"+"\"";
				}
				/*^FO700,15^A0R,19,19^FD"+texto+"^FS^FO680,15^A0R,19,19^FD"+texto2+"^FS^FO660,15^A0R,19,19^FD"+texto3+"^FS^FO640,15^A0R,19,19^FD"+texto4+"^FS^FO620,15^A0R,19,19^FD"+texto5+"^FS^FO600,15^A0R,19,19^FD"+texto6+"^FS^FO580,15^A0R,19,19^FD"+texto7+"^FS^FO560,15^A0R,19,19^FD"+texto8+"^FS^FO540,15^A0R,19,19^FD"+texto9+"^FS^FO520,15^A0R,19,19^FD"+texto10+"^FS^FO500,15^A0R,19,19^FD"+texto11+"^FS*/

				for(i=0;i<cantidad;i++){
					document.jzebra.findPrinter("ZebraFleje"); /*busco la impresora por nombre*/
					document.jzebra.append(etiquetas);  /*coloco variable a imprimir*/
					document.jzebra.print();		      /*se imprime*/
				}
			}
			function guardar(){
				console.log("Guardando informacion en la BD");
			}
		</script>
	</head>
	<body>
	<div id="lienzo_para_dibujar">
		<table>
			<tr>
				<td>Cantidad: 
					<input type="text" name="cantidad" id="cantidad" maxlength="1" style="width: 20px;">
					Tama&ntilde;o letra:
					<select id="size_letter" class="regularSelect">
						<option value="19">8</option>
						<option value="22">12</option>
						<option value="26">16</option>
					</select>
				</td>
				<td>
					<img src="images/home_24x24.png" width="24" height="24" alt="Inicio">
					<img src="images/plus.png" width="22" height="22" alt="Crear Nuevo">
				</td>
			</tr>
			<tr>
				<td>	<input type="text" size="40" name="texto" id="texto" maxlength="37"></td>
			</tr>
			<tr>
				<td><input type="text" size="37" name="texto2" id="texto2" maxlength="37"></td>
			</tr>
			<tr>
				<td><input type="text" size="37" name="texto3" id="texto3" maxlength="37"></td>
			</tr>
			<tr>
				<td><input type="text" size="37" name="texto4" id="texto4" maxlength="37"></td>
			</tr>
			<tr>
				<td><input type="text" size="37" name="texto5" id="texto5" maxlength="37"></td>
			</tr>
			<tr>
				<td><input type="text" size="37" name="texto6" id="texto6" maxlength="37"></td>
			</tr>
			<tr>
				<td><input type="text" size="37" name="texto7" id="texto7" maxlength="37"></td>
			</tr>
			<tr>
				<td><input type="text" size="37" name="texto8" id="texto8" maxlength="37"></td>
			</tr>
			<tr>
				<td><input type="text" size="37" name="texto9" id="texto9" maxlength="37"></td>
			</tr>
			<tr>
				<td><input type="text" size="37" name="texto10" id="texto10" maxlength="37"></td>
			</tr>
			<tr>
				<td><input type="text" size="37" name="texto11" id="texto11" maxlength="37"></td>
			</tr>
			<tr>
				<td>
					<input type="button" name="imprimir" value="Imprimir" id="imprimir" onclick="imprimir();">
					<input type="button" name="guardar" value="Guardar" id="guardar" onclick="guardar();">
					<input type="button" name="eliminar" value="Eliminar" id="eliminar" onclick="elimar();">
				</td>
			</tr>
		</table>
	</div>
	<applet name="jzebra" id="jzebra" code="jzebra.PrintApplet.class" archive="js/jzebra.jar" width="1" height="1">
			<param name="printer" value="zebra">
	</applet>
</body>
</html>