if(navigator.appName == "Netscape") {
	function Mensajes_Error( valor )
	{
		with (parent.top.frames[3].document.IdMensaje.document)
		{
		  open();
		  write(valor);
		  close();
		}
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
  var cNum = "0123456789" ;
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
     Mensajes_Error ("Ingrese solo numeros (positivos)");
     obj.focus();     
     obj.value = 0;     
     return( false ) ;
  }
}

function validaMontosPie( valor, obj )
{
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789" ;

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
     Mensajes_Error ("Ingrese sólo números (positivos) separados por .");
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

// Valida que se ingrese un numero positivo, despliega alerta en caso de error.
// Entrada: item, dato a validar
// Salida: true si es numero positivo, false en otro caso
function CheckPos(item) {
	var returnVal = false

	if (! esNumPos(item.value))
		alert("Por favor, ingrese un número positivo")
	else
		returnVal = true

	return returnVal
}

function validaNumMon( valor, obj )
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
	alert("Ingrese datos numéricos.");
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
                result += ".";
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
