
// function OcultarCapa(id)
// function CentrarCapa(id_object)
// function ResetCapa(id)
// function maxCaracteres(id,total)
// function Cerrar_Sesion()
// function LimpiaLista(id_select_tmp)
// function SetColor(id,colorBackground,colorText)
// function SetKey(evt)
// function Ver_Coordenadas()
// function Ver_ScrollCoord()
// function Existe_Objeto(id_objeto)
// function SetHora(evt,id)
// function Filtrar_Archivo(file)
// function Filtrar_PDF(file)
// function Filtrar_Excel(file)
// function IsNum( numstr )
// function Replace(s, r1, r2)
// function IsObject(id_object)
// function GetNomMes(mes_tmp)
// function LPad(ContentToSize,PadLength,PadChar)
// function RPad(ContentToSize,PadLength,PadChar)
// function roundNumber(rnum, rlength)
// function Radio_Es_Arreglo(id_radio)
// function SetChecked_Radio(v_id_object,v_posicion)
// function Valida_AlfaNumerico(e)
// function Valida_Digito(e)
// function Valida_Numerico(e)
// function Valida_Numerico_Negativo(e)
// function Valida_Caracteres_Fecha(e)
// function Valida_Caracteres_Hora(e)
// function Valida_Texto(e)
// function Valida_Hora(id)
// function LTrim(s)
// function RTrim(s)
// function Trim(s)
// function Ucase(s)
// function Lcase(s)
// function convertirAFecha(v_string)
// function Compara_Fechas(fecha1,fecha2)
// function Get_Digito_Verificador_Rut(rut_tmp)
// function Get_Value_Grupo_Form_Seleccionado(id_grupo_tmp)
// function Formatear_Separador_Miles(v_num)
// function Completar_Hora_Corta(v_hora_incompleta)
// function Completar_Fecha_Corta(p_fecha)
// function GetFechaCompleta(v_dia,v_fecha_hoy)
// function SetBackgroundImageInput(v_id_object,v_url_img)
// function Copiar_Datos(id_object)
// function Formateo_Completo_Numero(num,prefix)
// function unformatNumber(num)
// function format_number(pnumber,decimals)
// function Decimales(Numero, Decimales)
// function IsDate(v_cadena)
// function Left(s, n)
// function Right(s, n)
// function Mid(s, n, c)
// function Get_Valor_Atributo_Radio_Checked(v_id_object, v_atributo)

// *************** VARIABLES GLOBALES **************
// *************************************************
n4 = (document.layers)? true:false
//ie = (document.all)? true:false
//n6 = document.getElementById&&!document.all

var ARRIBA = 38; ABAJO = 40 ; DERECHA = 39 ; IZQUIERDA = 37 ; ENTER = 13; ESC = 27; 

function OcultarCapa(id){
 if(n4)   
       document.layers[id].visibility = "hide";   
 else if(ie)   
       document.all[id].style.visibility = "hidden";    
 else if(n6)   
       document.getElementById(id).style.visibility = "hidden";      
}

function CentrarCapa(id_object){
	ws = screen.availWidth;
	an = parseInt(id_object.style.width);
	x = parseInt((parseInt(ws)-an)/2);
	id_object.style.left=x+"px";
}

function ResetCapa(id){
   if(n4)   
     document.layers[id].visibility = "";   
   else if(ie)   
     document.all[id].style.visibility = "";   
   else if(n6)   
     document.getElementById(id).style.visibility = "";   
}

function maxCaracteres(id,total){
	if(id.value.length < total)
		return true
	else
		id.value=id.value.substr(0,total-1)
}

//Redirecciona la página a cerrar_sesion.asp
//en esa página se llama al método session.abandom para cerrar la sesion creada en inicio.asp
function Cerrar_Sesion(){
  document.location.href=RutaProyecto+"new_cerrar_sesion.asp"
}

//Limpiar una lista Desplegable
function LimpiaLista(id_select_tmp){
  largo=id_select_tmp.length + 1
  for(i=0;i<=largo;i++)
    id_select_tmp.remove(0)
}

//Establecer los colores de fondo y texto de los campos de modificacion
function SetColor(id,colorBackground,colorText){ 
  eval("id.style.backgroundColor='"+colorBackground+"'")
  eval("id.style.color='"+colorText+"'")
}

function SetKey(evt){
  key = n4 ? evt.which : evt.keyCode;
}

function Ver_Coordenadas(){
	document.all.coordenadas.value= "X: "+event.clientX+" - Y:"+event.clientY
}

function Ver_ScrollCoord(){
	window.status="Y: "+document.all.capaGrafico.scrollTop+", X: "+document.all.capaGrafico.scrollLeft
}

//Se debe pasar por parametro el String del objeto
function Existe_Objeto(id_objeto){
	return eval("("+id_objeto+")?true:false")
}

function SetHora(evt,id){
	var key = n4 ? evt.which : evt.keyCode;
	if(key!=8)
		if(id.value.length==2)
			id.value=id.value+":"
}

function Filtrar_Archivo(file){
  extArray = new Array(".xls",".doc",".ppt",".pps");
	//extArray = new Array(".xls",".doc",".txt",".pdf",".jpg",".gif",".ppt",".pps");
	//extArray = new Array(".jpg",".gif");
	allowSubmit = false;
	if (!file) return;
	while (file.indexOf("\\") != -1)
	
	file = file.slice(file.indexOf("\\") + 1);
	ext = file.slice(file.indexOf(".")).toLowerCase();
	
	for (var i = 0; i < extArray.length; i++)
	{
		if (extArray[i] == ext) 
		{ 
			allowSubmit = true; break; 
		}
	}
	if (allowSubmit)
		return true;
	else
		return false;
}

function Filtrar_PDF(file){
  extArray = new Array(".pdf");
	allowSubmit = false;
	if (!file) return;
	while (file.indexOf("\\") != -1)
	
	file = file.slice(file.indexOf("\\") + 1);
	ext = file.slice(file.indexOf(".")).toLowerCase();
	
	for (var i = 0; i < extArray.length; i++)
	{
		if (extArray[i] == ext) 
		{ 
			allowSubmit = true; break; 
		}
	}
	if (allowSubmit)
		return true;
	else
		return false;
}

function Filtrar_Excel(file){
  extArray = new Array(".xls");
	allowSubmit = false;
	if (!file) return;
	while (file.indexOf("\\") != -1)
	
	file = file.slice(file.indexOf("\\") + 1);
	ext = file.slice(file.indexOf(".")).toLowerCase();
	
	for (var i = 0; i < extArray.length; i++)
	{
		if (extArray[i] == ext) 
		{ 
			allowSubmit = true; break; 
		}
	}
	if (allowSubmit)
		return true;
	else
		return false;
}

function IsNum( numstr ){
	// Return immediately if an invalid value was passed in
	if (numstr+"" == "undefined" || numstr+"" == "null" || numstr+"" == "")	
		return false;

	var isValid = true;
	var decCount = 0;		// number of decimal points in the string

	// convert to a string for performing string comparisons.
	numstr += "";	

	// Loop through string and test each character. If any
	// character is not a number, return a false result.
 	// Include special cases for negative numbers (first char == '-')
	// and a single decimal point (any one char in string == '.').   
	for (i = 0; i < numstr.length; i++) {
		// track number of decimal points
		
		// Configuración Local "punto" (.) como separador de decimal
		//if (numstr.charAt(i) == ".")
		
		// Configuración Local "coma" (,) como separador de decimal (se cambian todos los IF en donde se pregunte por punto (se cambia a coma)
		if (numstr.charAt(i) == ",")
		  decCount++;

    	if (!((numstr.charAt(i) >= "0") && (numstr.charAt(i) <= "9") || 
				(numstr.charAt(i) == "-") || (numstr.charAt(i) == ","))) {
       	isValid = false;
       	break;
		} else if ((numstr.charAt(i) == "-" && i != 0) ||
				(numstr.charAt(i) == "," && numstr.length == 1) ||
			  (numstr.charAt(i) == "," && decCount > 1)) {
       	isValid = false;
       	break;
      }         	         	       
//if (!((numstr.charAt(i) >= "0") && (numstr.charAt(i) <= "9")) || 
   } // END for   
   
   	return isValid;
}  // end IsNum

function Replace(s, r1, r2){
   var r="";
   for(var i=0; i<=s.length-1; i++)
      if(s.substring(i,i+1) != r1)
         r = r + s.substring(i,i+1);
      else
         r = r + r2;
   return r;
}

function IsObject(id_object){
  if(id_object)
    return true;
  else
    return false;
}

function GetNomMes(mes_tmp){
  switch (parseInt(mes_tmp))
  {
    case 1: return "Enero";
    case 2: return "Febrero";
    case 3: return "Marzo";
    case 4: return "Abril";
    case 5: return "Mayo";
    case 6: return "Junio";
    case 7: return "Julio";
    case 8: return "Agosto";
    case 9: return "Septiembre";
    case 10: return "Octubre";
    case 11: return "Noviembre";
    case 12: return "Diciembre";
  }
}

function LPad(ContentToSize,PadLength,PadChar){
   var PaddedString=ContentToSize.toString();
   for(a1=ContentToSize.length+1;a1<=PadLength;a1++)
   {
       PaddedString=PadChar+PaddedString;
   }
   return PaddedString;
}

function RPad(ContentToSize,PadLength,PadChar){
   var PaddedString=ContentToSize.toString();
   for(a1=ContentToSize.length+1;a1<=PadLength;a1++)
   {
       PaddedString=PaddedString+PadChar;
   }
   return PaddedString;
}

function roundNumber(rnum, rlength) { 
  var newnumber = Math.round(rnum*Math.pow(10,rlength))/Math.pow(10,rlength);
  return newnumber;
}

function Radio_Es_Arreglo(id_radio){
  if(isNaN(id_radio.length))
    return false;
  else
    return true;
}

function SetChecked_Radio(v_id_object,v_posicion){
  if(Radio_Es_Arreglo(v_id_object))
    v_id_object[v_posicion].checked=true;
  else
    v_id_object.checked=true;
}

function Valida_AlfaNumerico(e){
  //para IE: e.keyCode
  //para Firefox: e.which
  if(e.which==0 || e.which==8) //Para Firefox
    return true;
  else
  {
	///^[\w\s°/\.áéíóúñÑ:*$%&()=?¿!¡+-]+$/;
    regexp = /^[\w\s°/\.ñÑ]/;
    if(!regexp.test(String.fromCharCode(e.which)))
      return false;
    else
      return true;
  }
}

function Valida_Digito(e){
  //para IE: e.keyCode
  //para Firefox y Chrome: e.which
  if(e.which==0 || e.which==8) //Para Firefox
    return true;
  else
  {
    regexp = /\d/;
    if(!regexp.test(String.fromCharCode(e.which)))
      return false;
    else
      return true;
  }
}

function Valida_Numerico(e){
  //para IE: e.keyCode
  //para Firefox y Chrome: e.which
  if(e.which==0 || e.which==8) //Para Firefox
    return true;
  else
  {
    regexp = /^[\d\.,]+$/;
    if(!regexp.test(String.fromCharCode(e.which)))
      return false;
    else
      return true;
  }
}

function Valida_Numerico_Negativo(e){
  //para IE: e.keyCode
  //para Firefox y Chrome: e.which
  if(e.which==0 || e.which==8) //Para Firefox
    return true;
  else
  {
    regexp = /^[\d\.,-]+$/;
    if(!regexp.test(String.fromCharCode(e.which)))
      return false;
    else
      return true;
  }
}

function Valida_Caracteres_Fecha(e){
  //(digitos y "/")
  //para IE: e.keyCode
  //para Firefox y Chrome: e.which
  if(e.which==0 || e.which==8) //Para Firefox
    return true;
  else
  {
    regexp = /^[\d\/]+$/;
    if(!regexp.test(String.fromCharCode(e.which)))
      return false;
    else
      return true;
  }
}

function Valida_Caracteres_Hora(e){
  //(digitos y ":")
  //para IE: e.keyCode
  //para Firefox y Chrome: e.which
  if(e.which==0 || e.which==8) //Para Firefox
    return true;
  else
  {
    regexp = /^[\d:]+$/;
    if(!regexp.test(String.fromCharCode(e.which)))
      return false;
    else
      return true;
  }
}

function Valida_Caracteres_Rut(e){
  //(digitos y "-")
  //para IE: e.keyCode
  //para Firefox y Chrome: e.which
  if(e.which==0 || e.which==8) //Para Firefox
    return true;
  else
  {
    regexp = /^[\d-]+$/;
    if(!regexp.test(String.fromCharCode(e.which)))
      return false;
    else
      return true;
  }
}

function Valida_Texto(e){
  //para IE: e.keyCode
  //para Firefox y Chrome: e.which
  if(e.which==0 || e.which==8) //Para Firefox
    return true;
  else
  {
    regexp = /^[\w\s°/\.áéíóúñÑ:*$%&()=?¿!¡+-]+$/;
    if(!regexp.test(String.fromCharCode(e.which)))
      return false;
    else
      return true;
  }
}

function Valida_Hora(id){
	if(id.value.length == 5)
	{
		hora			= id.value.substr(0,2)
		separador	= id.value.substr(2,1)
		minuto		= id.value.substr(3,2)
		if(isNaN(hora) || isNaN(minuto) || separador!=":")
			return false;
		else if((hora > 23 || hora < 0) || (minuto > 59 || minuto < 0))
			return false;
		else
			return true;
	}
	else
		return false;
}

function LTrim(s){
	// Devuelve una cadena sin los espacios del principio
	var a1=0;
	var a2=0;
	
	// Busca el primer caracter <> de un espacio
	for(a1=0; a1<=s.length-1; a1++)
		if(s.substring(a1,a1+1) != ' '){
			a2=a1;
			break;
		}
	return s.substring(a2, s.length);
}
function RTrim(s){
	// Quita los espacios en blanco del final de la cadena
	var a2=0;
	
	// Busca el último caracter <> de un espacio
	for(var a1=s.length-1; a1>-1; a1--)
		if(s.substring(a1,a1+1) != ' '){
			a2=a1;
			break;
		}
	return s.substring(0, a2+1);
}
function Trim(s){
	// Quita los espacios del principio y del final
	return LTrim(RTrim(s));
}

function Ucase(s){
	// Devuelve la cadena convertida a mayúsculas
	return s.toUpperCase();
}
function Lcase(s){
	// Devuelve la cadena convertida en minúsculas
	return s.toLowerCase();
}

function convertirAFecha(v_string){
  var v_date = new Date()
  var mes = v_string.substring(3, 5);
  v_date.setMonth(mes - 1); //en javascript los meses van de 0 a 11
  v_date.setDate(v_string.substring(0, 2));
  v_date.setYear(v_string.substring(6));
  return v_date;
}

function Compara_Fechas(fecha1,fecha2){
  //alert(fecha1.substr(3,2))
  //alert(parseInt(fecha1.substr(3,2)))
  //Debe ser fechas en el formato dd-mm-yyyy
  Anio1 = parseInt(fecha1.substr(6,4))
  Mes1  = parseInt(fecha1.substr(3,2)) - 1
  Dia1  = parseInt(fecha1.substr(0,2).replace("0",""))
  Anio2 = parseInt(fecha2.substr(6,4))
  Mes2  = parseInt(fecha2.substr(3,2)) - 1
  Dia2  = parseInt(fecha2.substr(0,2).replace("0",""))
  
  //alert("Anio1: "+Anio1+", Mes1: "+Mes1+"Dia1: "+Dia1+" - Anio2: "+Anio2+", Mes2: "+Mes2+"Dia1: "+Dia2)
  
  var fecha1_tmp = convertirAFecha(fecha1)
  var fecha2_tmp = convertirAFecha(fecha2)
  
  //var fecha1_tmp = new Date(Anio1,Mes1,Dia1)
  //var fecha2_tmp = new Date(Anio2,Mes2,Dia2)
  
  //alert("fecha1_tmp: "+fecha1_tmp+",fecha2_tmp: "+fecha2_tmp)
  
  if(fecha1_tmp > fecha2_tmp)
    return true
  else
    return false
}

function Get_Digito_Verificador_Rut(rut_tmp){
  var M=0,S=1;
  for(;rut_tmp;rut_tmp=Math.floor(rut_tmp/10)) 
  S=(S+rut_tmp%10*(9-M++%6))%11;return S?S-1:'K';
} 

function Get_Value_Grupo_Form_Seleccionado(id_grupo_tmp){
  for(i=0;i<=id_grupo_tmp.length-1;i++)
    if(id_grupo_tmp[i].checked==true)
      return id_grupo_tmp[i].value
}

function Formatear_Separador_Miles(v_num){
  num_tmp = v_num.replace(/\,/g,"")
  num_tmp = num_tmp.toString().split("").reverse().join("").replace(/(?=\d*\,?)(\d{3})/g,"$1,");
  num_tmp = num_tmp.split("").reverse().join("").replace(/^[\,]/,"");
  return num_tmp;
}

function Completar_Hora_Corta(v_hora_incompleta){
  v_hora_sin_dos_puntos = v_hora_incompleta.replace(":","")
  //alert("v_hora_sin_dos_puntos: "+v_hora_sin_dos_puntos+", largo: "+v_hora_sin_dos_puntos.length)
  switch(v_hora_sin_dos_puntos.length)
  {
    case 1:
      x_h1    = v_hora_sin_dos_puntos.substr(0,1)
      x_hora  = "0" + x_h1 + ":00"
      break;  
    case 2:
      x_h1    = v_hora_sin_dos_puntos.substr(0,1)
      x_h2    = v_hora_sin_dos_puntos.substr(1,1)
      if(parseInt(x_h1) >2)
        return false;
      if(parseInt(x_h1) == 2 && parseInt(x_h2) > 3)
        return false;
      x_hora  = x_h1 + x_h2 + ":00"
      break;
    case 3:
      x_h1    = v_hora_sin_dos_puntos.substr(0,1)
      x_h2    = v_hora_sin_dos_puntos.substr(1,1)
      x_h3    = v_hora_sin_dos_puntos.substr(2,1)
      if(parseInt(x_h2) > 5)
        return false;
      x_hora  = "0" + x_h1 + ":" + x_h2 + x_h3
      break;
    case 4:
      x_h1    = v_hora_sin_dos_puntos.substr(0,1)
      x_h2    = v_hora_sin_dos_puntos.substr(1,1)
      x_h3    = v_hora_sin_dos_puntos.substr(2,1)
      x_h4    = v_hora_sin_dos_puntos.substr(3,1)
      //alert("x_h1: " +x_h1+ ", x_h2: " +x_h2+ ", x_h3: " +x_h3+ ", x_h4: " +x_h4)
      if(parseInt(x_h1) > 2)
        return false;
      if(parseInt(x_h1) == 2 && parseInt(x_h2) > 3)
        return false;
      if(parseInt(x_h3) > 5)
        return false;
      x_hora  = x_h1 + x_h2 + ":" + x_h3 + x_h4
      break;
  }
  return x_hora;
}

function Completar_Fecha_Corta(p_fecha){
  if(p_fecha!="")
  {
    var array_fecha = p_fecha.split("/")
    if(array_fecha.length==3)
    {
      x_dia   = LPad(array_fecha[0],2,0)
      x_mes   = LPad(array_fecha[1],2,0)
      x_anio  = "20" + Right(array_fecha[2],2)
      //alert(x_dia + "/" + x_mes + "/" + x_anio)
      return x_dia + "/" + x_mes + "/" + x_anio
    }
    else
      return p_fecha;
    /*
    if(p_fecha.length==8)
      return p_fecha.substr(0,6) + "20" + Right(p_fecha,2)
    else
      return p_fecha;
    */
  }
  return p_fecha;
}

function GetFechaCompleta(v_dia,v_fecha_hoy){
  if(v_dia!="")
  {
    r_dia   = parseFloat(v_dia.substr(0,2))
    if(IsNum(parseFloat(v_dia.substr(3,2))))
    {
      r_mes   = v_dia.substr(3,2)
      if(r_mes.substr(0,1)=="0")
        r_mes   = r_mes.replace("0","")
      r_mes   = parseInt(r_mes)
      r_anio  = parseInt(v_dia.substr(6,4))
    }
    else
    {
      r_mes   = v_fecha_hoy.substr(3,2)
      if(r_mes.substr(0,1)=="0")
      r_mes   = r_mes.replace("0","")
      r_mes   = parseInt(r_mes)
      r_anio  = parseInt(v_fecha_hoy.substr(6,4))
    }
    switch(r_mes)
    {
      case 4  : v_maxDias=30;break;
      case 6  : v_maxDias=30;break;
      case 9  : v_maxDias=30;break;
      case 11 : v_maxDias=30;break;
      case 2  : v_maxDias=28;if(r_anio%4==0)v_maxDias=29;break;
      default : v_maxDias=31; //1,3,5,7,8,10,12
    }
    if(r_dia==0)
      r_dia = 1;
    else if(r_dia > v_maxDias)
      r_dia = v_maxDias;
    // formato dd/mm/yyyy
    //return LPad(r_dia.toString(),2,0) + "/" + LPad(r_mes.toString(),2,0) + "/" + r_anio
    // formato dd-mm-yyyy
    return LPad(r_dia.toString(),2,0) + "-" + LPad(r_mes.toString(),2,0) + "-" + r_anio
  }
  else
    return v_fecha_hoy;
}

function SetBackgroundImageInput(v_id_object,v_url_img){
  v_id_object.style.backgroundImage='url('+v_url_img+')'
}

function Copiar_Datos(id_object)
{
	var oControlRange = document.body.createTextRange();
  oControlRange.moveToElementText(id_object);
  oControlRange.execCommand("copy");
}


function Formateo_Completo_Numero(num,prefix){
  prefix = prefix || "";
  num += "";
  //var splitStr = num.split(","); //separador de miles (,)
  var splitStr = num.split("."); //separador de miles (.)
  var splitLeft = splitStr[0];
  var splitRight = splitStr.length > 1 ? "," + splitStr[1] : ""; //Separador de decimales (.)
  //var splitRight = splitStr.length > 1 ? "." + splitStr[1] : ""; //Separador de decimales (,)
  var regx = /(\d+)(\d{3})/;
  while (regx.test(splitLeft)) {
  splitLeft = splitLeft.replace(regx, "$1" + "." + "$2"); //Separador de miles (.)
  //splitLeft = splitLeft.replace(regx, "$1" + "." + "$2"); //Separador de miles (,)
  }
  return prefix + splitLeft + splitRight;
}

function unformatNumber(num){
  return num.replace(/([^0-9\.\-])/g,"")*1;
}

function format_number(pnumber,decimals){
	if (isNaN(pnumber)) { return 0};
	if (pnumber=='') { return 0};
	
	var snum = new String(pnumber);
	var sec = snum.split('.');
	var whole = parseFloat(sec[0]);
	var result = '';
	
	if(sec.length > 1){
		var dec = new String(sec[1]);
		dec = String(parseFloat(sec[1])/Math.pow(10,(dec.length - decimals)));
		dec = String(whole + Math.round(parseFloat(dec))/Math.pow(10,decimals));
		var dot = dec.indexOf('.');
		if(dot == -1){
			dec += '.'; 
			dot = dec.indexOf('.');
		}
		while(dec.length <= dot + decimals) { dec += '0'; }
		result = dec;
	} else{
		var dot;
		var dec = new String(whole);
		dec += '.';
		dot = dec.indexOf('.');		
		while(dec.length <= dot + decimals) { dec += '0'; }
		result = dec;
	}	
	return result;
}

function Decimales(Numero, Decimales){
	pot = Math.pow(10,Decimales);
	num = parseInt(Numero * pot) / pot;
	nume = num.toString().split('.');

	entero = nume[0];
	decima = nume[1];

	if (decima != undefined) {
		fin = Decimales-decima.length; }
	else {
		decima = '';
		fin = Decimales; }

	for(m=0;m<fin;m++)
	  decima+=String.fromCharCode(48); 

	num=entero+'.'+decima;
	return num;
}

function IsDate(v_cadena) {
  //formato dd/mm/yyyy
  //strExpReg = /^(((0[1-9]|[12][0-9]|3[01])([/])(0[13578]|10|12)([/])(\d{4}))|(([0][1-9]|[12][0-9]|30)([/])(0[469]|11)([/])(\d{4}))|((0[1-9]|1[0-9]|2[0-8])([/])(02)([/])(\d{4}))|((29)(\.|-|\/)(02)([/])([02468][048]00))|((29)([/])(02)([/])([13579][26]00))|((29)([/])(02)([/])([0-9][0-9][0][48]))|((29)([/])(02)([/])([0-9][0-9][2468][048]))|((29)([/])(02)([/])([0-9][0-9][13579][26])))$/;
  //formato dd-mm-yyyy
  strExpReg = /^(((0[1-9]|[12][0-9]|3[01])([-])(0[13578]|10|12)([-])(\d{4}))|(([0][1-9]|[12][0-9]|30)([-])(0[469]|11)([-])(\d{4}))|((0[1-9]|1[0-9]|2[0-8])([-])(02)([-])(\d{4}))|((29)(\.|-|\/)(02)([-])([02468][048]00))|((29)([-])(02)([-])([13579][26]00))|((29)([-])(02)([-])([0-9][0-9][0][48]))|((29)([-])(02)([-])([0-9][0-9][2468][048]))|((29)([-])(02)([-])([0-9][0-9][13579][26])))$/;
  return strExpReg.test(v_cadena);
}

function Left(s, n){
	// Devuelve los n primeros caracteres de la cadena
	if(n>s.length)
		n=s.length;
		
	return s.substring(0, n);
}

function Right(s, n){
	// Devuelve los n últimos caracteres de la cadena
	var t=s.length;
	if(n>t)
		n=t;
		
	return s.substring(t-n, t);
}

function Mid(s, n, c){
	// Devuelve una cadena desde la posición n, con c caracteres
	// Si c = 0 devolver toda la cadena desde la posición n
	
	var numargs=Mid.arguments.length;
	
	// Si sólo se pasan los dos primeros argumentos
	if(numargs<3)
		c=s.length-n+1;
		
	if(c<1)
		c=s.length-n+1;
	if(n+c >s.length)
		c=s.length-n+1;
	if(n>s.length)
		return "";
		
	return s.substring(n-1,n+c-1);
}

function Get_Valor_Atributo_Radio_Checked(v_id_object, v_atributo){
  if(Radio_Es_Arreglo(v_id_object))
  {
    for(i=0;i<=v_id_object.length-1;i++)
      if(v_id_object[i].checked==true)
      {      
        v_valor = v_id_object[i].getAttribute(v_atributo)
        break;
      }
  }
  else
    v_valor = v_id_object.getAttribute(v_atributo)
  return v_valor;
}