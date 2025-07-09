if(navigator.appName == "Netscape") {
	function Mensajes_Error( valor )
	{
		parent.top.frames[3].document.getElementById("IdMensaje").innerHTML = valor

	}
}
else
{
	function Mensajes_Error( valor )
	{
		parent.top.frames[3].document.all("IdMensaje").innerHTML = valor;
	}
}


function validaMontos( valor, obj )
{
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789." ;
/*
  if ( valor.length == 0 )
  {
     obj.value = 0;
     obj.focus();
     return( false ) ;
  }
  else
  {
*/
    for (var i =  0; i < valor.length; i++ )
    {
        cChr = valor.substring( i, i +  1 );
	  if ( cNum.indexOf( cChr ) != -1 )
          {
	     nCnt++ ;
	  }
    }
//  }
  
 if ( nCnt == valor.length ) 
  {
     return( true ) ;
  }
  else
  {
//     Mensajes_Error ("Ingrese solo numeros (positivos)");
     obj.focus();     
     obj.value = 0;     
     return( false ) ;
  }
}

function validaMontosPie( valor, obj )
{
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789." ;

   if ( valor > 0 )
    {
	if ( valor.length == 0 )
	{
          obj.value = 0;
        }
        for (var i=0;i<valor.length;i++)
        {
         cChr = valor.substring( i, i +  1 )
	  if ( cNum.indexOf( cChr ) != -1 )
          {
	     nCnt++ ;
	  }
        }
     if ( nCnt == valor.length )
     {
        return( true ) ;
     }
    else
     {
        alert ("Ingrese solo numeros (positivos)");
        obj.value = 0;
        obj.focus();
        return( false ) ;
     }
   }
 else
  {
     alert ("Se tiene que ingresar un pie para ver resultados.");
     obj.value = 0;
     obj.focus();
     return( false ) ;

  }
}

function validaPorcentaje( valor, obj ) 
{
// Rutina : Valida que un valor sea numerico.
// Entrada: valor
// Salida : true si es numero.
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789." ;

  if ( valor > 100 )
  {
    alert ("Debe ser menor que 100 %");
    obj.value = "";
    obj.focus();
    return( false ) ;
  }

  for (var i =  0; i < valor.length; i++ ) 
  {
      cChr = valor.substring( i, i +  1 )
	  if ( cNum.indexOf( cChr ) != -1 ) 
          {
	     nCnt++ ;
	  }
  }
  if ( valor.length == 0 )
  {
    obj.value = 0;
    return( true ) ;   
  }

  if ( nCnt == valor.length ) 
  {
     return( true ) ;
  }
  else 
  {
     alert ("Ingrese solo numeros (positivos) separados por . el %");
     obj.value = "";
     obj.focus();
     return( false ) ;
  }
}

function validaDecimales( valor, obj ) 
{
// Rutina : Valida que un valor sea numerico y decimal.
// Entrada: valor
// Salida : true si es numero.
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789." ;

  for (var i =  0; i < valor.length; i++ ) 
  {
      cChr = valor.substring( i, i +  1 )
	  if ( cNum.indexOf( cChr ) != -1 ) 
          {
	     nCnt++ ;
	  }
  }
  if ( valor.length == 0 )
  {
    obj.value = 0;
    return( true ) ;   
  }

  if ( nCnt == valor.length ) 
  {
     return( true ) ;
  }
  else 
  {
   //  Mensajes_Error ("Ingrese s�lo n�meros (positivos) separados por .");
     obj.value = "";
     obj.focus();
     return( false ) ;
  }
}

function validaDecimales_2( valor, obj ) 
{
// Rutina : Valida que un valor sea numerico y decimal.
// Entrada: valor
// Salida : true si es numero.
// Este no deja puesto un cero en el campo
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789." ;

  for (var i =  0; i < valor.length; i++ ) 
  {
      cChr = valor.substring( i, i +  1 )
	  if ( cNum.indexOf( cChr ) != -1 ) 
          {
	     nCnt++ ;
	  }
  }
  if ( valor.length == 0 )
  {
    obj.value = 0;
    return( true ) ;   
  }

  if ( nCnt == valor.length ) 
  {
     return( true ) ;
  }
  else 
  {
   //  Mensajes_Error ("Ingrese s�lo n�meros (positivos) separados por .");
     obj.value = "";
     obj.focus();
     return( false ) ;
  }
}

function validaNumDec( valor ) 
{
// Utilizada por AC
// Rutina : Valida que un valor sea numerico y decimal.
// Entrada: valor
// Salida : true si es numero.
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789." ;

  for (var i =  0; i < valor.length; i++ ) 
  {
      cChr = valor.substring( i, i +  1 )
	  if ( cNum.indexOf( cChr ) != -1 ) 
          {
	     nCnt++ ;
	  }
  }
  if ( valor.length == 0 )
  {
    return( true ) ;   
  }
  if ( nCnt == valor.length ) 
  {
     return( true ) ;
  }
  else 
  {	 
     return( false ) ;
  }
}

// Rutina : Valida que un valor sea numerico.
// Entrada: valor
// Salida : true si es numero.
function validNum( valor ) {
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789." ;

  if( valor.indexOf( "-" ) == -1 ) {
     for (var i =  0; i < valor.length; i++ ) {
         cChr = valor.substring( i, i +  1 )
	     if ( cNum.indexOf( cChr ) != -1 ) {
	        nCnt++ ;
	     }
     }

      if ( nCnt == valor.length ) {
         return( true ) ;
      }
      else {
         return( false ) ;
      }
  }
  else {
     return( false ) ;
  }
}

function validaEnteros( valor ) {
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789" ;

  if( valor.indexOf( "-" ) == -1 ) {
     for (var i =  0; i < valor.length; i++ ) {
         cChr = valor.substring( i, i +  1 )
	     if ( cNum.indexOf( cChr ) != -1 ) {
	        nCnt++ ;
	     }
     }

      if ( nCnt == valor.length ) {
         return( true ) ;
      }
      else {
         return( false ) ;
      }
  }
  else {
     return( false ) ;
  }
}

// Valida que se ingrese un numero positivo
// Entrada: s, un string a evaluar
// Salida: true si cada caracter es mayor o igual a cero, false en otro caso
function esNumPos(s) {
	var returnVal = true
	
	for(i = 0; i < s.length & returnVal; i++){
		returnVal = parseInt(s.substring(i, i+1)) >= 0
	}

	return returnVal

}
function validaNumericos(event ,valor,obj) {

  if (event.keyCode == 48)
  {
    if (valor == "") {
      return false;
    }
    
  }
  if(event.keyCode >= 48 && event.keyCode <= 57){
   
    return true;
   }
   else{
     
    return false;

   }

}

// Valida que se ingrese un numero positivo, despliega alerta en caso de error.
// Entrada: item, dato a validar
// Salida: true si es numero positivo, false en otro caso
function CheckPos(item) {
	var returnVal = false

	if (! esNumPos(item.value))
		alert("Por favor, ingrese un n�mero positivo")
	else
		returnVal = true

	return returnVal
}

function validaNumMon( valor, obj )
{
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789." ;
    for (var i =  0; i < valor.length; i++ )
    {
        cChr = valor.substring( i, i +  1 );
	  if ( cNum.indexOf( cChr ) != -1 )
          {
	     nCnt++ ;
	  }
    }
  
  if (valor == '' )
  {    
    return ( true );
  }

  if ( nCnt == valor.length ) 
  {
     return( true ) ;
  }
  else
  {
     obj.focus();
     return( false ) ;
  }
}

function validaCantidades( valor, obj )
{
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789" ;
    for (var i =  0; i < valor.length; i++ )
    {
        cChr = valor.substring( i, i +  1 );
	  if ( cNum.indexOf( cChr ) != -1 )
          {
	     nCnt++ ;
	  }
    }
  
  if ( nCnt == valor.length ) 
  {
     return( true ) ;
  }
  else
  {
     alert('Ingrese solamente cantidades enteras positivas.')  
     obj.value='';
     obj.focus();
     return( false ) ;
  }
}

function formatnumber(srcNumber)
{
	var txtNumber = '' + srcNumber;
	if (isNaN(txtNumber) || txtNumber == "") {
	alert("Ingrese datos num�ricos.");
	fieldName.select();
	fieldName.focus();
	}
	else {
	var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][.,])');
	var arrNumber = txtNumber.split('.');
	arrNumber[0] += '.';
	do {
	arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2');
	} while (rxSplit.test(arrNumber[0]));
	if (arrNumber.length > 1) {
	return arrNumber.join('');
	}
	else {
	return arrNumber[0].split('.')[0];
		  }
	   }
}

function Redondear( valor, decimales )
{
  if ( valor == 0)
     return (0);
  var ValorEntrada = ('' + valor);
    if ( ValorEntrada.indexOf(".") == -1 )
       ValorEntrada += ".0";
  var ParteDecimal = ValorEntrada.substring(0, ValorEntrada.indexOf("."));
  var ParteFraccion = parseInt( ValorEntrada.substring(ValorEntrada.indexOf(".")+1, ValorEntrada.indexOf(".")+decimales) );
     ParteFraccion = "" + Math.round( valor * 100 );
     var NuevaParteFraccion = ParteFraccion.substring(ParteFraccion.length-2, ParteFraccion.length);
     return ( "" + ParteDecimal + "." + NuevaParteFraccion );
}

function RandomNumber()
{
	today = new Date();
	num= Math.abs(Math.sin(today.getTime())) * 100000;		
	return parseInt(num);  
}

function validaNumeros( valor )
{
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789." ;
    for (var i =  0; i < valor.length; i++ )
    {
        cChr = valor.substring( i, i +  1 );
	  if ( cNum.indexOf( cChr ) != -1 )
          {
	     nCnt++ ;
	  }
    }
  
  if (valor == '' )
  {
    return ( true );
  }

  if ( nCnt == valor.length ) 
  {
     return( true ) ;
  }
  else
  {
     return( false ) ;
  }
}


function roundOff(value, precision)
{
        value = "" + value //convert value to string
        precision = parseInt(precision);

        var whole = "" + Math.round(value * Math.pow(10, precision));

        var decPoint = whole.length - precision;

        if(decPoint != 0)
        {
                result = whole.substring(0, decPoint);
                if(precision != 0)
                {
					result += ".";
				}
                result += whole.substring(decPoint, whole.length);
        }
        else
        {
                result = "0";
                result += ".";
                result += whole.substring(decPoint, whole.length);
//                result = whole;
        }
        return result;
}


function FormatNumberJS(num,decimalNum,bolLeadingZero,bolParens,bolCommas)
/**********************************************************************
	IN:
		NUM - the number to format
		decimalNum - the number of decimal places to format the number to
		bolLeadingZero - true / false - display a leading zero for
										numbers between -1 and 1
		bolParens - true / false - use parenthesis around negative numbers
		bolCommas - put commas as number separators.
 
	RETVAL:
		The formatted number!
 **********************************************************************/
{ 
        if (isNaN(parseFloat(num))) return "NaN";

	var tmpNum = num;
	var iSign = num < 0 ? -1 : 1;		// Get sign of number
	
	// Adjust number so only the specified number of numbers after
	// the decimal point are shown.
	tmpNum *= Math.pow(10,decimalNum);
	tmpNum = Math.round(Math.abs(tmpNum))
	tmpNum /= Math.pow(10,decimalNum);
	tmpNum *= iSign;					// Readjust for sign
	
	
	// Create a string object to do our formatting on
	var tmpNumStr = new String(tmpNum);

		if (num > 0)
		{
			var hasta=1;
		}
		else
		{
			var hasta=2;
		}

	// See if we need to strip out the leading zero or not.
	if (!bolLeadingZero && num < 1 && num > -1 && num != 0)
		if (num > 0)
		{
			tmpNumStr = tmpNumStr.substring(1,tmpNumStr.length);
		}
		else
		{
			tmpNumStr = "-" + tmpNumStr.substring(2,tmpNumStr.length);
		}
		
		
	// See if we need to put in the commas
	if (bolCommas && (num >= 1000 || num <= -1000)) {
		var iStart = tmpNumStr.indexOf(".");
		if (iStart < 0)
			iStart = tmpNumStr.length;

//		alert(hasta);

		iStart -= 3;
		while (iStart >= hasta) {		
		//alert(num + ' ' + iStart);
			tmpNumStr = tmpNumStr.substring(0,iStart) + "," + tmpNumStr.substring(iStart,tmpNumStr.length)
			iStart -= 3;
		}		
	}

	// See if we need to use parenthesis
	if (bolParens && num < 0)
		tmpNumStr = "(" + tmpNumStr.substring(1,tmpNumStr.length) + ")";

	return tmpNumStr;		// Return our formatted string!
}

// Esta funci�n a diferencia de FormatNumberJS y FormatNumber, permite formatear y detectar si
// trae decimales en caso contrario los rellena con ceros.
// pnumber = es el n�mero a formatear
// decimals = es la cantidad de decimales que se quieren mostrar.
function format_number2(pnumber,decimals) 
{
  var strNumber = new String(pnumber);
  var arrParts = strNumber.split('.');
  var intWholePart = parseInt(arrParts[0],10);
  var strResult = '';
  if (isNaN(intWholePart))
    intWholePart = '0';
  if(arrParts.length > 1)
  {
    var decDecimalPart = new String(arrParts[1]);
    var i = 0;
    var intZeroCount = 0;
     while ( i < String(arrParts[1]).length )
     {
       if( parseInt(String(arrParts[1]).charAt(i),10) == 0 )
       {
         intZeroCount += 1;
         i += 1;
       }
       else
         break;
    }
    decDecimalPart = parseInt(decDecimalPart,10)/Math.pow(10,parseInt(decDecimalPart.length-decimals-1)); 
    Math.round(decDecimalPart); 
    decDecimalPart = parseInt(decDecimalPart)/10; 
    decDecimalPart = Math.round(decDecimalPart); 

    //If the number was rounded up from 9 to 10, and it was for 1 'decimal' 
    //then we need to add 1 to the 'intWholePart' and set the decDecimalPart to 0. 

    if(decDecimalPart==Math.pow(10, parseInt(decimals)))
    { 
      intWholePart+=1; 
      decDecimalPart="0"; 
    } 
    var stringOfZeros = new String('');
    i=0;
    if( decDecimalPart > 0 )
    {
      while( i < intZeroCount)
      {
        stringOfZeros += '0';
        i += 1;
      }
    }
    decDecimalPart = String(intWholePart) + "." + stringOfZeros + String(decDecimalPart); 
    var dot = decDecimalPart.indexOf('.');
    if(dot == -1)
    {
      decDecimalPart += '.'; 
      dot = decDecimalPart.indexOf('.'); 
    } 
    var l=parseInt(dot)+parseInt(decimals); 
    while(decDecimalPart.length <= l) 
    {
      decDecimalPart += '0'; 
    }
    strResult = decDecimalPart;
  }
  else
  {
    var dot; 
    var decDecimalPart = new String(intWholePart); 

    decDecimalPart += '.'; 
    dot = decDecimalPart.indexOf('.'); 
    var l=parseInt(dot)+parseInt(decimals); 
    while(decDecimalPart.length <= l) 
    {
      decDecimalPart += '0'; 
    }
    strResult = decDecimalPart;
  }
  return strResult;
}

  var separator = ",";  // use comma as 000's separator
  var decpoint = ".";  // use period as decimal point
  var percent = "%";
  var currency = "$";  // use dollar sign for currency

/*
Ejemplos:

formatNumber(3, "$0.00") = $3.00
formatNumber(3.14159265, "##0.####") = 3.1416
formatNumber(3.14, "0.0###%") = 314.0%
formatNumber(314159, ",##0.####") = 314,159
formatNumber(31415962, "$,##0.00") = $31,415,962.00
formatNumber(cat43, "0.####%") = null
formatNumber(0.5, "#.00##") = 0.50
formatNumber(0.5, "0.00##") = 0.50
formatNumber(0.5, "00.00##") = 00.50
formatNumber(4.44444, "0.00") = 4.44
formatNumber(5.55555, "0.00") = 5.56
formatNumber(9.99999, "0.00") = 10.00
*/

  function Formateo_Numerico(number, format, print) {  // use: Formateo_Numerico(number, "format")
    if (print) document.write("Formateo_Numerico(" + number + ", \"" + format + "\")<br>");

    if (number - 0 != number) return null;  // if number is NaN return null
    var useSeparator = format.indexOf(separator) != -1;  // use separators in number
    var usePercent = format.indexOf(percent) != -1;  // convert output to percentage
    var useCurrency = format.indexOf(currency) != -1;  // use currency format
    var isNegative = (number < 0);
    number = Math.abs (number);
    if (usePercent) number *= 100;
    format = strip(format, separator + percent + currency);  // remove key characters
    number = "" + number;  // convert number input to string

     // split input value into LHS and RHS using decpoint as divider
    var dec = number.indexOf(decpoint) != -1;
    var nleftEnd = (dec) ? number.substring(0, number.indexOf(".")) : number;
    var nrightEnd = (dec) ? number.substring(number.indexOf(".") + 1) : "";

     // split format string into LHS and RHS using decpoint as divider
    dec = format.indexOf(decpoint) != -1;
    var sleftEnd = (dec) ? format.substring(0, format.indexOf(".")) : format;
    var srightEnd = (dec) ? format.substring(format.indexOf(".") + 1) : "";

     // adjust decimal places by cropping or adding zeros to LHS of number
    if (srightEnd.length < nrightEnd.length) {
      var nextChar = nrightEnd.charAt(srightEnd.length) - 0;
      nrightEnd = nrightEnd.substring(0, srightEnd.length);
      if (nextChar >= 5) nrightEnd = "" + ((nrightEnd - 0) + 1);  // round up

 // patch provided by Patti Marcoux 1999/08/06
      while (srightEnd.length > nrightEnd.length) {
        nrightEnd = "0" + nrightEnd;
      }

      if (srightEnd.length < nrightEnd.length) {
        nrightEnd = nrightEnd.substring(1);
        nleftEnd = (nleftEnd - 0) + 1;
      }
    } else {
      for (var i=nrightEnd.length; srightEnd.length > nrightEnd.length; i++) {
        if (srightEnd.charAt(i) == "0") nrightEnd += "0";  // append zero to RHS of number
        else break;
      }
    }

     // adjust leading zeros
    sleftEnd = strip(sleftEnd, "#");  // remove hashes from LHS of format
    while (sleftEnd.length > nleftEnd.length) {
      nleftEnd = "0" + nleftEnd;  // prepend zero to LHS of number
    }

    if (useSeparator) nleftEnd = separate(nleftEnd, separator);  // add separator
    var output = nleftEnd + ((nrightEnd != "") ? "." + nrightEnd : "");  // combine parts
    output = ((useCurrency) ? currency : "") + output + ((usePercent) ? percent : "");
    if (isNegative) {
      // patch suggested by Tom Denn 25/4/2001
      output = (useCurrency) ? "(" + output + ")" : "-" + output;
    }
    return output;
  }

  function strip(input, chars) {  // strip all characters in 'chars' from input
    var output = "";  // initialise output string
    for (var i=0; i < input.length; i++)
      if (chars.indexOf(input.charAt(i)) == -1)
        output += input.charAt(i);
    return output;
  }

  function separate(input, separator) {  // format input using 'separator' to mark 000's
    input = "" + input;
    var output = "";  // initialise output string
    for (var i=0; i < input.length; i++) {
      if (i != 0 && (input.length - i) % 3 == 0) output += separator;
      output += input.charAt(i);
    }
    return output;
  }
