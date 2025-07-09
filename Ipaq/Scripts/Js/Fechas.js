var isNav4 = false, isNav5 = false, isIE4 = false  ;
var strSeperator = "/"; 
// If you are using any Java validation on the back side you will want to use the / because 
// Java date validations do not recognize the dash as a valid date separator.
var vDateType = 1; 		// Global value for type of date format
//                1 = mm/dd/yyyy
//                2 = yyyy/dd/mm  (Unable to do date check at this time)
//                3 = dd/mm/yyyy
var vYearType = 4; 		//Set to 2 or 4 for number of digits in the year for Netscape
var err = 0; 			// Set the error code to a default of zero
if(navigator.appName == "Netscape") {
if (navigator.appVersion < "5") {
isNav4 = true;
isNav5 = false;
}
else
if (navigator.appVersion > "4") {
isNav4 = false;
isNav5 = true;
   }
}
else isIE4 = true;

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

function DateFormat(vDateName, vDateValue, e, dateCheck, dateType)
{
    Mensajes_Error ("")
    var separador = ""
    if ( ! validEmpty( vDateValue ) )
    {
		if ( vDateValue.indexOf( "/" ) > 0 )
		{
		   var separador = "/";
		}
		else if ( vDateValue.indexOf( "-" ) > 0 )
		{
		    var separador = "-";
		}

 		if ( separador == "-" || separador == "/" )
 		{ 			
			var Fecha = Convierte_Fecha( vDateValue, separador )
 		}
 		else 			
 		{
 			var Fecha = validFecha4_6( vDateValue, 's' )
 		}
		if ( validaFecha( Fecha ) )
		{
			vDateName.value = Fecha ;
			return true;
		}
		else
		{
			Mensajes_Error ( "Formato de fecha incorrecto, el formato debe ser (dd/mm/aaaa) " );			
			vDateName.focus();
			return false;
		}
   }
   else
   {
		return true;
   }
}

function DateFormat_2(vDateName, vDateValue, e, dateCheck, dateType) {
vDateType = dateType;

//////////////////////////////////////////////////////////////////////////////////////
// vDateName = object name
// vDateValue = value in the field being checked
// e = event
// dateCheck 
//       True  = Verify that the vDateValue is a valid date
//       False = Format values being entered into vDateValue only
// vDateType
//       1 = mm/dd/yyyy
//       2 = yyyy/mm/dd
//       3 = dd/mm/yyyy
//Enter a tilde sign for the first number and you can check the variable information.
//////////////////////////////////////////////////////////////////////////////////////
if (vDateValue == "~" ) {
//alert("AppVersion = "+navigator.appVersion+" \nNav. 4 Version = "+isNav4+" \nNav. 5 Version = "+isNav5+" \nIE Version = "+isIE4+" \nYear Type = "+vYearType+" \nDate Type = "+vDateType+" \nSeparator = "+strSeperator);
Mensajes_Error ( "AppVersion = "+navigator.appVersion+" \nNav. 4 Version = "+isNav4+" \nNav. 5 Version = "+isNav5+" \nIE Version = "+isIE4+" \nYear Type = "+vYearType+" \nDate Type = "+vDateType+" \nSeparator = "+strSeperator);
vDateName.value = "";
vDateName.focus();
return true;
}

var whichCode = (window.Event) ? e.which : e.keyCode;
//alert(whichCode);
if (whichCode == 35 || whichCode == 36 || whichCode == 45 || whichCode == 9 || whichCode == 20 || whichCode == 37 ||whichCode == 38 ||whichCode == 39 ||whichCode == 40 || whichCode == 16 || whichCode == 17 || whichCode == 46)
{
	return true;
}
// Check to see if a seperator is already present.
// bypass the date if a seperator is present and the length greater than 8
if (vDateValue.length > 8 && isNav4) {
if ((vDateValue.indexOf("-") >= 1) || (vDateValue.indexOf("/") >= 1)) return true;
}
//Eliminate all the ASCII codes that are not valid
var alphaCheck = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/-";
if (alphaCheck.indexOf(vDateValue) >= 1) {
if (isNav4) {
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
}
else {
vDateName.value = vDateName.value.substr(0, (vDateValue.length-1));
return false;
   }
}
if (whichCode == 8) //Ignore the Netscape value for backspace. IE has no value
return false;
else {
//Create numeric string values for 0123456789/
//The codes provided include both keyboard and keypad values
var strCheck = '47,48,49,50,51,52,53,54,55,56,57,58,59,95,96,97,98,99,100,101,102,103,104,105';
if (strCheck.indexOf(whichCode) != -1) {
if (isNav4) {
if (((vDateValue.length < 6 && dateCheck) || (vDateValue.length == 7 && dateCheck)) && (vDateValue.length >=1)) {
//alert("Formato de fecha incorrecto");
Mensajes_Error ( "Formato de fecha incorrecto" )
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
}
if (vDateValue.length == 6 && dateCheck) {
var mDay = vDateName.value.substr(2,2);
var mMonth = vDateName.value.substr(0,2);
var mYear = vDateName.value.substr(4,4);
//Turn a two digit year into a 4 digit year
if (mYear.length == 2 && vYearType == 4) {
var mToday = new Date();
//If the year is greater than 30 years from now use 19, otherwise use 20
var checkYear = mToday.getFullYear() + 30; 
var mCheckYear = '20' + mYear;
if (mCheckYear >= checkYear) mYear = '19' + mYear;
else mYear = '20' + mYear;
}
var vDateValueCheck = mMonth+strSeperator+mDay+strSeperator+mYear;
if (!dateValid(vDateValueCheck)) {
//alert("Formato de fecha incorrecto");
Mensajes_Error ( "Formato de fecha incorrecto" )

vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
}
Mensajes_Error ( '' )
return true;
}
else {
// Reformat the date for validation and set date type to a 1
if (vDateValue.length >= 8  && dateCheck) {
// mmddyyyy
if (vDateType == 1) {
var mDay = vDateName.value.substr(2,2);
var mMonth = vDateName.value.substr(0,2);
var mYear = vDateName.value.substr(4,4)
vDateName.value = mMonth+strSeperator+mDay+strSeperator+mYear;
}
// yyyymmdd
if (vDateType == 2) {
var mYear = vDateName.value.substr(0,4)
var mMonth = vDateName.value.substr(4,2);
var mDay = vDateName.value.substr(6,2);
vDateName.value = mYear+strSeperator+mMonth+strSeperator+mDay;
}
// ddmmyyyy
if (vDateType == 3) {
var mMonth = vDateName.value.substr(2,2);
var mDay = vDateName.value.substr(0,2);
var mYear = vDateName.value.substr(4,4)
vDateName.value = mDay+strSeperator+mMonth+strSeperator+mYear;
}
//Create a temporary variable for storing the DateType and change
//the DateType to a 1 for validation.
var vDateTypeTemp = vDateType;
vDateType = 1;
var vDateValueCheck = mMonth+strSeperator+mDay+strSeperator+mYear;
if (!dateValid(vDateValueCheck)) {
//alert("Formato de fecha incorrecto");
Mensajes_Error ( "Formato de fecha incorrecto" )
vDateType = vDateTypeTemp;
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
}
Mensajes_Error ( '' )
vDateType = vDateTypeTemp;
return true;
}
else {
if (((vDateValue.length < 8 && dateCheck) || (vDateValue.length == 9 && dateCheck)) && (vDateValue.length >=1)) {
//alert("Formato de fecha incorrecto");
Mensajes_Error ( "Formato de fecha incorrecto" )
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
         }
      }
   }
}
else {
// Non isNav Check
if (((vDateValue.length < 8 && dateCheck) || (vDateValue.length == 9 && dateCheck)) && (vDateValue.length >=1)) {
//alert("Formato de fecha incorrecto");
Mensajes_Error ( "Formato de fecha incorrecto" )

vDateName.value = "";
vDateName.focus();
return true;
}
// Reformat date to format that can be validated. mm/dd/yyyy
if (vDateValue.length >= 8 && dateCheck) {
// Additional date formats can be entered here and parsed out to
// a valid date format that the validation routine will recognize.
// mm/dd/yyyy
if (vDateType == 1) {
var mMonth = vDateName.value.substr(0,2);
var mDay = vDateName.value.substr(3,2);
var mYear = vDateName.value.substr(6,4)
}
// yyyy/mm/dd
if (vDateType == 2) {
var mYear = vDateName.value.substr(0,4)
var mMonth = vDateName.value.substr(5,2);
var mDay = vDateName.value.substr(8,2);
}
// dd/mm/yyyy
if (vDateType == 3) {
var mDay = vDateName.value.substr(0,2);
var mMonth = vDateName.value.substr(3,2);
var mYear = vDateName.value.substr(6,4)
}
// Create temp. variable for storing the current vDateType
var vDateTypeTemp = vDateType;
// Change vDateType to a 1 for standard date format for validation
// Type will be changed back when validation is completed.
vDateType = 1;
// Store reformatted date to new variable for validation.
var vDateValueCheck = mMonth+strSeperator+mDay+strSeperator+mYear;
if (vDateValueCheck.length >= 8 && dateCheck) {
//Turn a two digit year into a 4 digit year
if (mYear.length == 2 && vYearType == 4) {
var mToday = new Date();
//If the year is greater than 30 years from now use 19, otherwise use 20
var checkYear = mToday.getFullYear() + 30; 
var mCheckYear = '20' + mYear;
if (mCheckYear >= checkYear) mYear = '19' + mYear;
else mYear = '20' + mYear;
}
vDateValueCheck = mMonth+strSeperator+mDay+strSeperator+mYear;
} 
if (!dateValid(vDateValueCheck)) {
//alert("Formato de fecha incorrecto");
Mensajes_Error ( "Formato de fecha incorrecto" )
vDateType = vDateTypeTemp;
vDateName.value = "";
vDateName.focus();
return true;
}
Mensajes_Error ( '' )
vDateType = vDateTypeTemp;
return true;
}
else {
if (vDateType == 1) {
if (vDateValue.length == 2) {
//vDateName.value = vDateValue+strSeperator;
}
if (vDateValue.length == 5) {
//vDateName.value = vDateValue+strSeperator;
   }
}
if (vDateType == 2)
{
if (vDateValue.length == 4)  
{
//vDateName.value = vDateValue+strSeperator;
}
if (vDateValue.length == 7) {
//vDateName.value = vDateValue+strSeperator;
   }
}
if (vDateType == 3) {
if (vDateValue.length == 2) {
//vDateName.value = vDateValue+strSeperator;
}
if (vDateValue.length == 5) {
//vDateName.value = vDateValue+strSeperator;
   }
}
return true;
   }
}
if (vDateValue.length == 10&& dateCheck) {
if (!dateValid(vDateName)) {
// Un-comment the next line of code for debugging the dateValid() function error messages
//alert(err);  
//alert("Formato de fecha incorrecto");
Mensajes_Error ( "Formato de fecha incorrecto" )

vDateName.focus();
vDateName.select();
   }
}
return false;
}
else {
// If the value is not in the string return the string minus the last
// key entered.
if (isNav4) {
vDateName.value = "";
vDateName.focus();
vDateName.select();
return false;
}
else {
//vDateName.value = vDateName.value.substr(0, (vDateValue.length-1));
return false;
         }
      }
   }
}

function dateValid(objName) {
var strDate;
var strDateArray;
var strDay;
var strMonth;
var strYear;
var intday;
var intMonth;
var intYear;
var booFound = false;
var datefield = objName;
var strSeparatorArray = new Array("-"," ","/",".");
var intElementNr;
// var err = 0;
var strMonthArray = new Array(12);
strMonthArray[0] = "Jan";
strMonthArray[1] = "Feb";
strMonthArray[2] = "Mar";
strMonthArray[3] = "Apr";
strMonthArray[4] = "May";
strMonthArray[5] = "Jun";
strMonthArray[6] = "Jul";
strMonthArray[7] = "Aug";
strMonthArray[8] = "Sep";
strMonthArray[9] = "Oct";
strMonthArray[10] = "Nov";
strMonthArray[11] = "Dec";
//strDate = datefield.value;
strDate = objName;
if (strDate.length < 1) {
return true;
}
for (intElementNr = 0; intElementNr < strSeparatorArray.length; intElementNr++) {
if (strDate.indexOf(strSeparatorArray[intElementNr]) != -1) {
strDateArray = strDate.split(strSeparatorArray[intElementNr]);
if (strDateArray.length != 3) {
err = 1;
return false;
}
else {
strDay = strDateArray[0];
strMonth = strDateArray[1];
strYear = strDateArray[2];
}
booFound = true;
   }
}
if (booFound == false) {
if (strDate.length>5) {
strDay = strDate.substr(0, 2);
strMonth = strDate.substr(2, 2);
strYear = strDate.substr(4);
   }
}
//Adjustment for short years entered
if (strYear.length == 2) {
strYear = '20' + strYear;
}
strTemp = strDay;
strDay = strMonth;
strMonth = strTemp;
intday = parseInt(strDay, 10);
if (isNaN(intday)) {
err = 2;
return false;
}
intMonth = parseInt(strMonth, 10);
if (isNaN(intMonth)) {
for (i = 0;i<12;i++) {
if (strMonth.toUpperCase() == strMonthArray[i].toUpperCase()) {
intMonth = i+1;
strMonth = strMonthArray[i];
i = 12;
   }
}
if (isNaN(intMonth)) {
err = 3;
return false;
   }
}
intYear = parseInt(strYear, 10);
if (isNaN(intYear)) {
err = 4;
return false;
}
if (intMonth>12 || intMonth<1) {
err = 5;
return false;
}
if ((intMonth == 1 || intMonth == 3 || intMonth == 5 || intMonth == 7 || intMonth == 8 || intMonth == 10 || intMonth == 12) && (intday > 31 || intday < 1)) {
err = 6;
return false;
}
if ((intMonth == 4 || intMonth == 6 || intMonth == 9 || intMonth == 11) && (intday > 30 || intday < 1)) {
err = 7;
return false;
}
if (intMonth == 2) {
if (intday < 1) {
err = 8;
return false;
}
if (LeapYear(intYear) == true) {
if (intday > 29) {
err = 9;
return false;
   }
}
else {
if (intday > 28) {
err = 10;
return false;
      }
   }
}
return true;
}
function LeapYear(intYear) {
if (intYear % 100 == 0) {
if (intYear % 400 == 0) {
return true;
   }
}
else {
if ((intYear % 4) == 0) {
return true;
   }
}
return false;
}


function ValidaHora( obj, dDonde )
{
	var valor = obj.value ;
	var cMensaje = '' ;
	var nPosHora	= valor.indexOf( ":" )	
   if (! validEmpty (valor) )
   {
	if ( nPosHora == -1 || valor.length != 5 )
	{
		cMensaje = 'Formato hora de ' + dDonde + ' no es válido ( hh:mm )';
	}
	else
	{
		var nHora		= valor.substr( 0, nPosHora )
		if ( validaNumeros( nHora ))
		{
			if ( nHora >= 00 && nHora <= 23 )
			{
				var nMinutos	= valor.substr( nPosHora+1, valor.length )
								
				if ( validaNumeros( nMinutos ))
				{
					if ( nMinutos >= 00 && nMinutos <= 59 )
					{
					}
					else
					{
						cMensaje = 'Los minutos en la hora de ' + dDonde + ' no son válidos.';
					}
				}
				else
				{
					cMensaje = 'Los minutos de ' + dDonde + ' deben ser númericos.';
				}
			}
			else
			{
					cMensaje = 'La hora de ' + dDonde + ' no es válida.';
			}		
		}
		else
		{
			cMensaje = 'La hora de ' + dDonde + ' debe ser númerica.';			
		}
	}
	
	if ( cMensaje != '' )
	{
		alert ( cMensaje );
		obj.focus();
		return( false ) ;
	}
	else
	{
		return( true ) ;
	}	
    }
}

function HoraValida( valor, dDonde )
{
	//var valor = obj.value ;
	var cMensaje = '' ;
	var nPosHora	= valor.indexOf( ":" )	
   if (! validEmpty (valor) )
   {
	if ( nPosHora == -1 || valor.length != 5 )
	{
		cMensaje = 'Formato hora de ' + dDonde + ' no es válido ( hh:mm )';
	}
	else
	{
		var nHora		= valor.substr( 0, nPosHora )
		if ( validaNumeros( nHora ))
		{
			if ( nHora >= 00 && nHora <= 23 )
			{
				var nMinutos	= valor.substr( nPosHora+1, valor.length )
								
				if ( validaNumeros( nMinutos ))
				{
					if ( nMinutos >= 00 && nMinutos <= 59 )
					{
					}
					else
					{
						cMensaje = 'Los minutos en la hora de ' + dDonde + ' no son válidos.';
					}
				}
				else
				{
					cMensaje = 'Los minutos de ' + dDonde + ' deben ser númericos.';
				}
			}
			else
			{
					cMensaje = 'La hora de ' + dDonde + ' no es válida.';
			}		
		}
		else
		{
			cMensaje = 'La hora de ' + dDonde + ' debe ser númerica.';			
		}
	}
	
	if ( cMensaje != '' )
	{
		return( false ) ;
	}
	else
	{
		return( true ) ;
	}	
    }
}


// Valida que se ingrese un valido, despliega alerta en caso de error.
// Entrada: item, dato a validar
// Salida: true si es mes valido, false en otro caso
function MesValido(item) {
	var returnVal = false

	if (item.value=='')
			returnVal = true
	else
		if ((item.value >=1) & (item.value<=12))
			returnVal = true
		else
			alert("Por favor, ingrese un mes valido")

	return returnVal
}

// Rutina : Valida el ingreso de una fecha.
// Entrada: valor
// Salida : true si es valida.
function validaFecha( valor ) {
  var nDia ;
  var nMes ;
  var nAno ;
  var nPos ;
  var dFecha ;
  var lFlag = false ;

  if ( valor.indexOf( "/" ) != -1 )
  {
     nPos  = valor.indexOf( "/" ) ;
  	 nDia  = valor.substr( 0, nPos ) ;
     valor = valor.substr( nPos +  1 ) ;
  
  	 nPos  = valor.indexOf( "/" ) ;
  	 nMes  = valor.substr( 0, nPos ) ;
  
     nAno  = valor.substr( nPos +  1 ) ;
            
  	 lFlag = true ;
  }
  else if ( valor.indexOf( "-" ) !=  -1 )
  {
  	    nPos  = valor.indexOf( "-" ) ;
  		nDia  = valor.substr( 0, nPos ) ;
        valor = valor.substr( nPos +  1 ) ;
  
  		nPos  = valor.indexOf( "-" ) ;
  		nMes  = valor.substr( 0, nPos ) ;
  
        nAno  = valor.substr( nPos +  1 ) ;
  			   
  		lFlag = true ;
  }
/*
  else if ( valor.indexOf( "." ) != -1 )
  {
  	    nPos  = valor.indexOf( "." ) ;
  		nDia  = valor.substr( 0, nPos ) ;
        valor = valor.substr( nPos +  1 ) ;
  
  		nPos  = valor.indexOf( "." ) ;
  		nMes  = valor.substr( 0, nPos ) ;
  
        nAno  = valor.substr( nPos +  1 ) ;
  			   
  		lFlag = true ;
  }
*/  

  if ( lFlag ) {
     lFlag = false ;
  	 if ( nMes ==  1 || nMes ==  3 || nMes ==  5 || nMes ==  7 || nMes ==  8 || nMes == 10 || nMes == 12 ) {
  	    if ( nDia >=  1 && nDia <= 31 ) {
  		   lFlag = true ;
  		}
  	 }
  	 if ( nMes ==  4 || nMes ==  6 || nMes ==  9 || nMes == 11 ) {
  	    if ( nDia >=  1 && nDia <= 30 ) {
  		   lFlag = true ;
  		}
  	 }
  	 if ( nMes ==  2 ) {
	    if ( ( nAno % 4 ) ==  0 ) {
    	   if ( nDia >=  1 && nDia <= 29 ) {
  		      lFlag = true ;
  		   }
        }
		else {
    	   if ( nDia >=  1 && nDia <= 28 ) {
  		      lFlag = true ;
  		   }
		}
  	 }

     if (lFlag)
     {
	if ( ! validEmpty(nMes) && ! validEmpty(nDia) && ! validEmpty(nAno) )
	{
		if ( validaNumeros(nMes) && validaNumeros(nDia) && validaNumeros(nAno) )
        	{
			lFlag = true ;
        	}
		else
		{
			lFlag = false;
		}
     	}
	else
	{
		lFlag = false;
	}
     }

     if ( lFlag ) {
        dFecha  = ( ( parseFloat( nMes ) < 10 ) ? "0" : "" ) + parseFloat( nMes ) + "/" ;
        dFecha += ( ( parseFloat( nDia ) < 10 ) ? "0" : "" ) + parseFloat( nDia ) + "/" ;
        dFecha +=     nAno ;

	lFlag = false ;
        dFecha = new Date( dFecha ) ;
        if ( dFecha != NaN ) {
           lFlag = true ;
        }
  	 }
  }

  return( lFlag ) ;

}


function FechaValida(item) {
	var returnVal = false

	mesdia = new Array(13)
	mesdia[0] = -1
	mesdia[1] = 31
	mesdia[2] = 29
	mesdia[3] = 31
	mesdia[4] = 30
	mesdia[5] = 31 
	mesdia[6] = 30 
	mesdia[7] = 31 
	mesdia[8] = 31 
	mesdia[9] = 30 
	mesdia[10] = 31 
	mesdia[11] = 30 
	mesdia[12] = 31

	string = item.value

//	string.substring(0, 2)	Corresponde a Mes 
//	string.substring(3, 5)	Corresponde a Día
//	string.substring(6,10)	Corresponde a Año

	if (string.length != 10 )
		alert("Formato de fecha inválido (dd/mm/aaaa) ")
	else if (!esNumPos(string.substring(0,2)) || 
		 !esNumPos(string.substring(3,5)) || 
		 !esNumPos(string.substring(6,10)))
		alert("Día, mes y año deben ser números mayores a cero")
	else if (parseInt(string.substring(3, 5)) > 12 )
		alert("Mes inválido")
	else if (parseInt(string.substring(0, 2)) > mesdia[parseInt(string.substring(3, 5))])
		alert("Número de días inválido para el mes indicado")
	else
		returnVal = true

	return returnVal
}


function Fecha_Universal( valor ) 
{
	  var nDia ;
	  var nMes ;
	  var nAno ;
	  var nPos ;
	  var dFecha ;
	  var valorOriginal = valor;
	if(valor==0)
	{
	  return('1900/01/01') ;
	}
	else
	{
	  if ( valor.indexOf( "/" ) !=  0 ) {
		 nPos  = valor.indexOf( "/" ) ;
		 nDia  = valor.substr( 0, nPos ) ;
			valor = valor.substr( nPos +  1 ) ;
		 nPos  = valor.indexOf( "/" ) ;
		 nMes  = valor.substr( 0, nPos ) ;

		 nPos1  = valor.indexOf( " " ) ;
                 if ( valor.indexOf( " " ) == -1 )
		 {
                   nPos1 = valor.length;
                 }
		 nAno  =  valor.substr( nPos+1, nPos1-(nPos+1) ) ;
	         nHora  = valor.substr( nPos1+1) ;

	  dFecha = nAno + "/" 
		if ( nMes < 10 )
		{
			dFecha += "0" + parseFloat( nMes ) + "/" 
		}
		else
		{
			   dFecha += parseFloat( nMes ) + "/" 
		}
		if ( nDia < 10 )
		{
			dFecha += "0" + parseFloat( nDia.substr(nDia.length-1, nDia.length) ) + " " 
		}
		else
		{
			   dFecha += parseFloat( nDia ) + " " 
		}
	      dFecha += nHora;
	  }
	  else {
		 if ( valor.indexOf( "-" ) !=  0 ) {
			nPos  = valor.indexOf( "-" ) ;
		 nDia  = valor.substr( 0, nPos ) ;
			 valor = valor.substr( nPos +  1 ) ;
		 nPos  = valor.indexOf( "-" ) ;
            	 nMes  = valor.substr( 0, nPos ) ;
		 
		 nPos1  = valor.indexOf( " " ) ;
                 if ( valor.indexOf( " " ) == -1 )
		 {
                   nPos1 = valor.length;
                 }
		 nAno  = valor.substr( nPos+1, nPos1-(nPos+1) ) ;
		 nHora  = valor.substr( nPos1+1) ;
	  dFecha = nAno + "-" 
		if ( nMes < 10 )
		{
			dFecha += "0" + parseFloat( nMes ) + "-" 
		}
		else
		{
			   dFecha += parseFloat( nMes ) + "-" 
		}
		if ( nDia < 10 )
		{
			dFecha += "0" + parseFloat( nDia.substr(nDia.length-1, nDia.length) ) + " " 
		}
		else
		{
			   dFecha += parseFloat( nDia ) + " " 
		}
	      dFecha += nHora;
	    }
	  }
	  return( dFecha ) ;
	}
}

function Fecha_Universal_2( valor ) 
{
  var nDia ;
  var nMes ;
  var nAno ;
  var nPos ;
  var dFecha ;

  if ( valor.indexOf( "/" ) !=  0 ) {
     nPos  = valor.indexOf( "/" ) ;
  	 nDia  = valor.substr( 0, nPos ) ;
     valor = valor.substr( nPos +  1 ) ;
  
  	 nPos  = valor.indexOf( "/" ) ;
  	 nMes  = valor.substr( 0, nPos ) ;
  
     nAno  = valor.substr( nPos +  1 ) ;
  }
  else {
     if ( valor.indexOf( "-" ) !=  0 ) {
  	    nPos  = valor.indexOf( "-" ) ;
  		nDia  = valor.substr( 0, nPos ) ;
        valor = valor.substr( nPos +  1 ) ;
  
  		nPos  = valor.indexOf( "-" ) ;
  		nMes  = valor.substr( 0, nPos ) ;
  
        nAno  = valor.substr( nPos +  1 ) ;
     }
  }

  dFecha = nAno ;
  dFecha += "/" + ( ( parseFloat( nMes ) < 10 ) ? "0" : "" ) + parseFloat( nMes ) + "/" ;
  dFecha += ( ( parseFloat( nDia ) < 10 ) ? "0" : "" ) + parseFloat( nDia ) ;
  return( dFecha ) ;

}


// Rutina : convierte la fecha a formato JAVASCRIPT.
// Entrada: valor
// Salida : fecha en formato JAVASCRIPT.
function Fecha_A_Java( valor ) {
  var nDia ;
  var nMes ;
  var nAno ;
  var nPos ;
  var dFecha ;

  if ( valor.indexOf( "/" ) !=  0 ) {
     nPos  = valor.indexOf( "/" ) ;
  	 nDia  = valor.substr( 0, nPos ) ;
     valor = valor.substr( nPos +  1 ) ;
  
  	 nPos  = valor.indexOf( "/" ) ;
  	 nMes  = valor.substr( 0, nPos ) ;
  
     nAno  = valor.substr( nPos +  1 ) ;
  }
  else {
     if ( valor.indexOf( "-" ) !=  0 ) {
  	    nPos  = valor.indexOf( "-" ) ;
  		nDia  = valor.substr( 0, nPos ) ;
        valor = valor.substr( nPos +  1 ) ;
  
  		nPos  = valor.indexOf( "-" ) ;
  		nMes  = valor.substr( 0, nPos ) ;
  
        nAno  = valor.substr( nPos +  1 ) ;
     }
  }
  
  dFecha  = ( ( parseFloat( nMes ) < 10 ) ? "0" : "" ) + parseFloat( nMes ) + "/" ;
  dFecha += ( ( parseFloat( nDia ) < 10 ) ? "0" : "" ) + parseFloat( nDia ) + "/" ;
  dFecha +=     nAno ;
  dFecha = new Date( dFecha ) ;

  return( dFecha ) ;

}

// Inicio Calendario Flotante.

var weekend = [0,6];
var weekendColor = "#e0e0e0";
var fontface = "Arial";
var fontsize = 2;

var gNow = new Date();
var ggWinCal;
isNav = (navigator.appName.indexOf("Netscape") != -1) ? true : false;
isIE = (navigator.appName.indexOf("Microsoft") != -1) ? true : false;

Calendar.Months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
"Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];

// Non-Leap year Month days..
Calendar.DOMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
// Leap year Month days..
Calendar.lDOMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

function Calendar(p_item, p_WinCal, p_month, p_year, p_format) {
	if ((p_month == null) && (p_year == null))	return;

	if (p_WinCal == null)
		this.gWinCal = ggWinCal;
	else
		this.gWinCal = p_WinCal;
	
	if (p_month == null) {
		this.gMonthName = null;
		this.gMonth = null;
		this.gYearly = true;
	} else {
		this.gMonthName = Calendar.get_month(p_month);
		this.gMonth = new Number(p_month);
		this.gYearly = false;
	}

	this.gYear = p_year;
	this.gFormat = p_format;
	this.gBGColor = "#acbdce";
	this.gFGColor = "black";
	this.gTextColor = "black";
	this.gHeaderColor = "black";
	this.gReturnItem = p_item;
}

Calendar.get_month = Calendar_get_month;
Calendar.get_daysofmonth = Calendar_get_daysofmonth;
Calendar.calc_month_year = Calendar_calc_month_year;
Calendar.print = Calendar_print;

function Calendar_get_month(monthNo) {
	return Calendar.Months[monthNo];
}

function Calendar_get_daysofmonth(monthNo, p_year) {
	/* 
	Check for leap year ..
	1.Years evenly divisible by four are normally leap years, except for... 
	2.Years also evenly divisible by 100 are not leap years, except for... 
	3.Years also evenly divisible by 400 are leap years. 
	*/
	if ((p_year % 4) == 0) {
		if ((p_year % 100) == 0 && (p_year % 400) != 0)
			return Calendar.DOMonth[monthNo];
	
		return Calendar.lDOMonth[monthNo];
	} else
		return Calendar.DOMonth[monthNo];
}

function Calendar_calc_month_year(p_Month, p_Year, incr) {
	/* 
	Will return an 1-D array with 1st element being the calculated month 
	and second being the calculated year 
	after applying the month increment/decrement as specified by 'incr' parameter.
	'incr' will normally have 1/-1 to navigate thru the months.
	*/
	var ret_arr = new Array();
	
	if (incr == -1) {
		// B A C K W A R D
		if (p_Month == 0) {
			ret_arr[0] = 11;
			ret_arr[1] = parseInt(p_Year) - 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) - 1;
			ret_arr[1] = parseInt(p_Year);
		}
	} else if (incr == 1) {
		// F O R W A R D
		if (p_Month == 11) {
			ret_arr[0] = 0;
			ret_arr[1] = parseInt(p_Year) + 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) + 1;
			ret_arr[1] = parseInt(p_Year);
		}
	}
	
	return ret_arr;
}

function Calendar_print() {
	ggWinCal.print();
}

function Calendar_calc_month_year(p_Month, p_Year, incr) {
	/* 
	Will return an 1-D array with 1st element being the calculated month 
	and second being the calculated year 
	after applying the month increment/decrement as specified by 'incr' parameter.
	'incr' will normally have 1/-1 to navigate thru the months.
	*/
	var ret_arr = new Array();
	
	if (incr == -1) {
		// B A C K W A R D
		if (p_Month == 0) {
			ret_arr[0] = 11;
			ret_arr[1] = parseInt(p_Year) - 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) - 1;
			ret_arr[1] = parseInt(p_Year);
		}
	} else if (incr == 1) {
		// F O R W A R D
		if (p_Month == 11) {
			ret_arr[0] = 0;
			ret_arr[1] = parseInt(p_Year) + 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) + 1;
			ret_arr[1] = parseInt(p_Year);
		}
	}
	
	return ret_arr;
}

// This is for compatibility with Navigator 3, we have to create and discard one object before the prototype object exists.
new Calendar();

Calendar.prototype.getMonthlyCalendarCode = function() {
	var vCode = "";
	var vHeader_Code = "";
	var vData_Code = "";
	
	// Begin Table Drawing code here..
	vCode = vCode + "<TABLE BORDER=1 aBGCOLOR=\"" + this.gBGColor + "\">";
	
	vHeader_Code = this.cal_header();
	vData_Code = this.cal_data();
	vCode = vCode + vHeader_Code + vData_Code;
	
	vCode = vCode + "</TABLE>";
	
	return vCode;
}

Calendar.prototype.show = function() {
	var vCode = "";
	
	this.gWinCal.document.open();

	// Setup the page...
	this.wwrite("<html>");
	this.wwrite("<head><title>Calendario</title>");
	this.wwrite("</head>");

	this.wwrite("<body bgcolor='#BAC6D5'" + 
		"link=\"" + this.gLinkColor + "\" " + 
		"vlink=\"" + this.gLinkColor + "\" " +
		"alink=\"" + this.gLinkColor + "\" " +
		"text=\"" + this.gTextColor + "\">");
	this.wwriteA("<center><FONT FACE='" + fontface + "' SIZE=2><B>");
	this.wwriteA(this.gMonthName + " " + this.gYear);
	this.wwriteA("</B></font></center><BR>");

	// Show navigation buttons
	var prevMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, -1);
	var prevMM = prevMMYYYY[0];
	var prevYYYY = prevMMYYYY[1];

	var nextMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, 1);
	var nextMM = nextMMYYYY[0];
	var nextYYYY = nextMMYYYY[1];
	
	this.wwrite("<TABLE WIDTH='100%' BORDER=1 CELLSPACING=0 CELLPADDING=0 BGCOLOR='#acbdce'><TR><TD ALIGN=center>");
	this.wwrite("[<A Title='Año anterior' HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)-1) + "', '" + this.gFormat + "'" +
		");" +
		"\"><<<\/A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A Title='Mes anterior' HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', '" + prevMM + "', '" + prevYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\"><<\/A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"javascript:window.print();\">Imprimir</A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A Title='Mes siguiente' HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', '" + nextMM + "', '" + nextYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\">><\/A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A Title='Año siguiente' HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)+1) + "', '" + this.gFormat + "'" +
		");" +
		"\">>><\/A>]</TD></TR></TABLE><BR>");

	// Get the complete calendar code for the month..
	vCode = this.getMonthlyCalendarCode();
	this.wwrite(vCode);

	this.wwrite("</font></body></html>");
	this.gWinCal.document.close();
}

Calendar.prototype.showY = function() {
	var vCode = "";
	var i;
	var vr, vc, vx, vy;		// Row, Column, X-coord, Y-coord
	var vxf = 285;			// X-Factor
	var vyf = 200;			// Y-Factor
	var vxm = 10;			// X-margin
	var vym;				// Y-margin
	if (isIE)	vym = 75;
	else if (isNav)	vym = 25;
	
	this.gWinCal.document.open();

	this.wwrite("<html>");
	this.wwrite("<head><title>Calendar</title>");
	this.wwrite("<style type='text/css'>\n<!--");
	for (i=0; i<12; i++) {
		vc = i % 3;
		if (i>=0 && i<= 2)	vr = 0;
		if (i>=3 && i<= 5)	vr = 1;
		if (i>=6 && i<= 8)	vr = 2;
		if (i>=9 && i<= 11)	vr = 3;
		
		vx = parseInt(vxf * vc) + vxm;
		vy = parseInt(vyf * vr) + vym;

		this.wwrite(".lclass" + i + " {position:absolute;top:" + vy + ";left:" + vx + ";}");
	}
	this.wwrite("-->\n</style>");
	this.wwrite("</head>");

	this.wwrite("<body " + 
		"link=\"" + this.gLinkColor + "\" " + 
		"vlink=\"" + this.gLinkColor + "\" " +
		"alink=\"" + this.gLinkColor + "\" " +
		"text=\"" + this.gTextColor + "\">");
	this.wwrite("<FONT FACE='" + fontface + "' SIZE=2><B>");
	this.wwrite("Year : " + this.gYear);
	this.wwrite("</B><BR>");

	// Show navigation buttons
	var prevYYYY = parseInt(this.gYear) - 1;
	var nextYYYY = parseInt(this.gYear) + 1;
	
	this.wwrite("<TABLE WIDTH='100%' BORDER=1 CELLSPACING=0 CELLPADDING=0 BGCOLOR='#acbdce'><TR><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', null, '" + prevYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\" alt='Prev Year'><<<\/A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"javascript:window.print();\">Print</A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', null, '" + nextYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\">>><\/A>]</TD></TR></TABLE><BR>");

	// Get the complete calendar code for each month..
	var j;
	for (i=11; i>=0; i--) {
		if (isIE)
			this.wwrite("<DIV ID=\"layer" + i + "\" CLASS=\"lclass" + i + "\">");
		else if (isNav)
			this.wwrite("<LAYER ID=\"layer" + i + "\" CLASS=\"lclass" + i + "\">");

		this.gMonth = i;
		this.gMonthName = Calendar.get_month(this.gMonth);
		vCode = this.getMonthlyCalendarCode();
		this.wwrite(this.gMonthName + "/" + this.gYear + "<BR>");
		this.wwrite(vCode);

		if (isIE)
			this.wwrite("</DIV>");
		else if (isNav)
			this.wwrite("</LAYER>");
	}

	this.wwrite("</font><BR></body></html>");
	this.gWinCal.document.close();
}

Calendar.prototype.wwrite = function(wtext) {
	this.gWinCal.document.writeln(wtext);
}

Calendar.prototype.wwriteA = function(wtext) {
	this.gWinCal.document.write(wtext);
}

Calendar.prototype.cal_header = function() {
	var vCode = "";
	
	vCode = vCode + "<TR>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Dom</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Lun</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Mar</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Mie</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Jue</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Vie</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='16%'><FONT SIZE='2' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Sab</B></FONT></TD>";
	vCode = vCode + "</TR>";
	
	return vCode;
}

Calendar.prototype.cal_data = function() {
	var vDate = new Date();
	vDate.setDate(1);
	vDate.setMonth(this.gMonth);
	vDate.setFullYear(this.gYear);

	var vFirstDay=vDate.getDay();
	var vDay=1;
	var vLastDay=Calendar.get_daysofmonth(this.gMonth, this.gYear);
	var vOnLastDay=0;
	var vCode = "";

	/*
	Get day for the 1st of the requested month/year..
	Place as many blank cells before the 1st day of the month as necessary. 
	*/

	vCode = vCode + "<TR>";
	for (i=0; i<vFirstDay; i++) {
		vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(i) + "><FONT SIZE='2' FACE='" + fontface + "'> </FONT></TD>";
	}

	// Write rest of the 1st week
	for (j=vFirstDay; j<7; j++) {
		vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j) + "><FONT SIZE='2' FACE='" + fontface + "'>" + 
			"<A HREF='#' " + 
				"onClick=\"self.opener.document." + this.gReturnItem + ".value='" + 
				this.format_data(vDay) + 
				"';window.close();\">" + 
				this.format_day(vDay) + 
			"</A>" + 
			"</FONT></TD>";
		vDay=vDay + 1;
	}
	vCode = vCode + "</TR>";

	// Write the rest of the weeks
	for (k=2; k<7; k++) {
		vCode = vCode + "<TR>";

		for (j=0; j<7; j++) {
			vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j) + "><FONT SIZE='2' FACE='" + fontface + "'>" + 
				"<A HREF='#' " + 
					"onClick=\"self.opener.document." + this.gReturnItem + ".value='" + 
					this.format_data(vDay) + 
					"';window.close();\">" + 
				this.format_day(vDay) + 
				"</A>" + 
				"</FONT></TD>";
			vDay=vDay + 1;

			if (vDay > vLastDay) {
				vOnLastDay = 1;
				break;
			}
		}

		if (j == 6)
			vCode = vCode + "</TR>";
		if (vOnLastDay == 1)
			break;
	}
	
	// Fill up the rest of last week with proper blanks, so that we get proper square blocks
	for (m=1; m<(7-j); m++) {
		if (this.gYearly)
			vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j+m) + 
			"><FONT SIZE='2' FACE='" + fontface + "' COLOR='gray'> </FONT></TD>";
		else
			vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j+m) + 
			"><FONT SIZE='2' FACE='" + fontface + "' COLOR='gray'>" + m + "</FONT></TD>";
	}
	
	return vCode;
}

Calendar.prototype.format_day = function(vday) {
	var vNowDay = gNow.getDate();
	var vNowMonth = gNow.getMonth();
	var vNowYear = gNow.getFullYear();

	if (vday == vNowDay && this.gMonth == vNowMonth && this.gYear == vNowYear)
		return ("<FONT COLOR=\"RED\"><B>" + vday + "</B></FONT>");
	else
		return (vday);
}

Calendar.prototype.write_weekend_string = function(vday) {
	var i;

	// Return special formatting for the weekend day.
	for (i=0; i<weekend.length; i++) {
		if (vday == weekend[i])
			return (" BGCOLOR=\"" + weekendColor + "\"");
	}
	
	return "";
}

Calendar.prototype.format_data = function(p_day) {
	var vData;
	var vMonth = 1 + this.gMonth;
	vMonth = (vMonth.toString().length < 2) ? "0" + vMonth : vMonth;
	var vMon = Calendar.get_month(this.gMonth).substr(0,3).toUpperCase();
	var vFMon = Calendar.get_month(this.gMonth).toUpperCase();
	var vY4 = new String(this.gYear);
	var vY2 = new String(this.gYear.substr(2,2));
	var vDD = (p_day.toString().length < 2) ? "0" + p_day : p_day;

	switch (this.gFormat) {
		case "MM\/DD\/YYYY" :
			vData = vMonth + "\/" + vDD + "\/" + vY4;
			break;
		case "MM\/DD\/YY" :
			vData = vMonth + "\/" + vDD + "\/" + vY2;
			break;
		case "MM-DD-YYYY" :
			vData = vMonth + "-" + vDD + "-" + vY4;
			break;
		case "MM-DD-YY" :
			vData = vMonth + "-" + vDD + "-" + vY2;
			break;

		case "DD\/MON\/YYYY" :
			vData = vDD + "\/" + vMon + "\/" + vY4;
			break;
		case "DD\/MON\/YY" :
			vData = vDD + "\/" + vMon + "\/" + vY2;
			break;
		case "DD-MON-YYYY" :
			vData = vDD + "-" + vMon + "-" + vY4;
			break;
		case "DD-MON-YY" :
			vData = vDD + "-" + vMon + "-" + vY2;
			break;

		case "DD\/MONTH\/YYYY" :
			vData = vDD + "\/" + vFMon + "\/" + vY4;
			break;
		case "DD\/MONTH\/YY" :
			vData = vDD + "\/" + vFMon + "\/" + vY2;
			break;
		case "DD-MONTH-YYYY" :
			vData = vDD + "-" + vFMon + "-" + vY4;
			break;
		case "DD-MONTH-YY" :
			vData = vDD + "-" + vFMon + "-" + vY2;
			break;

		case "DD\/MM\/YYYY" :
			vData = vDD + "\/" + vMonth + "\/" + vY4;
			break;
		case "DD\/MM\/YY" :
			vData = vDD + "\/" + vMonth + "\/" + vY2;
			break;
		case "DD-MM-YYYY" :
			vData = vDD + "-" + vMonth + "-" + vY4;
			break;
		case "DD-MM-YY" :
			vData = vDD + "-" + vMonth + "-" + vY2;
			break;

		default :
			vData = vMonth + "\/" + vDD + "\/" + vY4;
	}
	return vData;
}

function Build(p_item, p_month, p_year, p_format) {
	var p_WinCal = ggWinCal;
	gCal = new Calendar(p_item, p_WinCal, p_month, p_year, p_format);

	// Customize your Calendar here..
	gCal.gBGColor="#acbdce";
	gCal.gLinkColor="black";
	gCal.gTextColor="#4f5890";
	gCal.gHeaderColor="#00007c";

	// Choose appropriate show function
	if (gCal.gYearly)	gCal.showY();
	else	gCal.show();
}

function show_calendar() {
	/* 
		p_month : 0-11 for Jan-Dec; 12 for All Months.
		p_year	: 4-digit year
		p_format: Date format (mm/dd/yyyy, dd/mm/yy, ...)
		p_item	: Return Item.
	*/

	p_item = arguments[0];
	if (arguments[1] == null)
		p_month = new String(gNow.getMonth());
	else
		p_month = arguments[1];
	if (arguments[2] == "" || arguments[2] == null)
		p_year = new String(gNow.getFullYear().toString());
	else
		p_year = arguments[2];
	if (arguments[3] == null)
		//p_format = "MM/DD/YYYY";
		p_format = "DD/MM/YYYY";
	else
		p_format = arguments[3];

	vWinCal = window.open("", "Calendar", 
		"width=250,height=250,status=no,resizable=no,top=200,left=200");
	vWinCal.opener = self;
	ggWinCal = vWinCal;

	Build(p_item, p_month, p_year, p_format);
}
/*
Yearly Calendar Code Starts here
*/
function show_yearly_calendar(p_item, p_year, p_format) {
	// Load the defaults..
	if (p_year == null || p_year == "")
		p_year = new String(gNow.getFullYear().toString());
	if (p_format == null || p_format == "")
		p_format = "DD/MM/YYYY";
//		p_format = "MM/DD/YYYY";

	var vWinCal = window.open("", "Calendar", "scrollbars=yes");
	vWinCal.opener = self;
	ggWinCal = vWinCal;

	Build(p_item, null, p_year, p_format);
}

// Termino Calendario Flotante.

function validFecha( valor, oblig ) 
{
// Rutina : Valida el ingreso de una fecha.
// Entrada: valor, oblig = 's' o 'n'
// Salida : true si es valida.
  var dFecha = valor; //new Date( valor ) ;
  var nDia ;
  var nMes ;
  var nAno ;
  var nPos ;
  var lFlag = false ;
  if ( dFecha != 'NaN' ) 
  {
     if ( valor.indexOf( "/" ) >  0 ) 
     {
         nPos = valor.indexOf( "/" ) ;
         nDia = valor.substr( 0, nPos ) ;
         valor = valor.substr( nPos +  1 ) ;

         nPos = valor.indexOf( "/" ) ;
         nMes = valor.substr( 0, nPos ) ;

         nAno = valor.substr( nPos +  1 ) ;
            
         lFlag = true ;
      }
      else 
      {
         
         if ( valor.indexOf( "-" ) >  0 ) 
         {
               nPos = valor.indexOf( "-" ) ;
		         nDia = valor.substr( 0, nPos ) ;
               valor = valor.substr( nPos +  1 ) ;

		         nPos = valor.indexOf( "-" ) ;
		         nMes = valor.substr( 0, nPos ) ;

               nAno = valor.substr( nPos +  1 ) ;
			   
		         lFlag = true ;
		   }
		   else
		   {
            if ( valor.indexOf( "." ) >  0 ) 
            {
                  nPos = valor.indexOf( "." ) ;
		            nDia = valor.substr( 0, nPos ) ;
                  valor = valor.substr( nPos +  1 ) ;

		            nPos = valor.indexOf( "." ) ;
		            nMes = valor.substr( 0, nPos ) ;

                  nAno = valor.substr( nPos +  1 ) ;
			      
		            lFlag = true ;
		      }
		   }
	   }

     if ( lFlag ) 
     {
         lFlag = false ;
		   if ( nMes ==  1 || nMes ==  3 || nMes ==  5 || nMes ==  7 || nMes ==  8 || nMes == 10 || nMes == 12 ) 
		   {
		      if ( nDia >=  1 && nDia <= 31 ) 
		      {
		         lFlag = true ;
		      }
		   }
		   if ( nMes ==  4 || nMes ==  6 || nMes ==  9 || nMes == 11 ) 
		   {
		      if ( nDia >=  1 && nDia <= 30 ) 
		      {
		         lFlag = true ;
		      }
		   }
		   if ( nMes ==  2 ) 
		   {
		      if ( nDia >=  1 && nDia <= 28 ) 
		      {
		         lFlag = true ;
		      }
		   }
	 
		 if ( nAno.length == 2 ) 
		 {
			if ( nAno > '80' )
			{
				nAno = '19' + nAno ;
			}
			else
			{
				nAno = '20' + nAno ;
			}				
		 }

			{
			   dFecha  = ( ( parseFloat( nMes ) < 10 ) ? "0" : "" ) + parseFloat( nMes ) + "/" ;
			   dFecha += ( ( parseFloat( nDia ) < 10 ) ? "0" : "" ) + parseFloat( nDia ) + "/" ;
			   dFecha +=     nAno ;
			}
	 }
  }
  else 
  {
     if ( oblig == "n" || oblig == "N" ) 
     {
	    lFlag = true ;
	 }
  }
  return( lFlag ) ;
}

function ConvierteFecha( valor, oblig ) 
{
  var dFecha = valor; //new Date( valor ) ;
  var nDia ;
  var nMes ;
  var nAno ;
  var nPos ;
  var lFlag = false ;
  if ( dFecha != 'NaN' ) 
  {
     if ( valor.indexOf( "/" ) >  0 ) 
     {
         nPos = valor.indexOf( "/" ) ;
         nDia = valor.substr( 0, nPos ) ;
         valor = valor.substr( nPos +  1 ) ;

         nPos = valor.indexOf( "/" ) ;
         nMes = valor.substr( 0, nPos ) ;

         nAno = valor.substr( nPos +  1 ) ;
            
         lFlag = true ;
      }
      else 
      {
         
         if ( valor.indexOf( "-" ) >  0 ) 
         {
               nPos = valor.indexOf( "-" ) ;
		         nDia = valor.substr( 0, nPos ) ;
               valor = valor.substr( nPos +  1 ) ;

		         nPos = valor.indexOf( "-" ) ;
		         nMes = valor.substr( 0, nPos ) ;

               nAno = valor.substr( nPos +  1 ) ;
			   
		         lFlag = true ;
		   }
		   else
		   {
            if ( valor.indexOf( "." ) >  0 ) 
            {
                  nPos = valor.indexOf( "." ) ;
		            nDia = valor.substr( 0, nPos ) ;
                  valor = valor.substr( nPos +  1 ) ;

		            nPos = valor.indexOf( "." ) ;
		            nMes = valor.substr( 0, nPos ) ;

                  nAno = valor.substr( nPos +  1 ) ;
			      
		            lFlag = true ;
		      }
		   }
	   }

     if ( lFlag ) 
     {
         lFlag = false ;
		   if ( nMes ==  1 || nMes ==  3 || nMes ==  5 || nMes ==  7 || nMes ==  8 || nMes == 10 || nMes == 12 ) 
		   {
		      if ( nDia >=  1 && nDia <= 31 ) 
		      {
		         lFlag = true ;
		      }
		   }
		   if ( nMes ==  4 || nMes ==  6 || nMes ==  9 || nMes == 11 ) 
		   {
		      if ( nDia >=  1 && nDia <= 30 ) 
		      {
		         lFlag = true ;
		      }
		   }
		   if ( nMes ==  2 ) 
		   {
		      if ( nDia >=  1 && nDia <= 28 ) 
		      {
		         lFlag = true ;
		      }
		   }
	 
		 if ( nAno.length == 2 ) 
		 {
			if ( nAno > '80' )
			{
				nAno = '19' + nAno ;
			}
			else
			{
				nAno = '20' + nAno ;
			}				
		 }

			{
			   dFecha  = ( ( parseFloat( nDia ) < 10 ) ? "0" : "" ) + parseFloat( nDia ) + "/" ;
			   dFecha += ( ( parseFloat( nMes ) < 10 ) ? "0" : "" ) + parseFloat( nMes ) + "/" ;
			   dFecha +=     nAno ;			   
			}
	 }
  }
  else 
  {
     if ( oblig == "n" || oblig == "N" ) 
     {
	    lFlag = true ;
	 }
  }
  return( dFecha ) ;
}


function ConvierteFechaUniversal( valor, oblig ) 
{
  var dFecha = valor; //new Date( valor ) ;
  var nDia ;
  var nMes ;
  var nAno ;
  var nPos ;
  var lFlag = false ;
  if ( dFecha != 'NaN' ) 
  {
     if ( valor.indexOf( "/" ) >  0 ) 
     {
         nPos = valor.indexOf( "/" ) ;
         nDia = valor.substr( 0, nPos ) ;
         valor = valor.substr( nPos +  1 ) ;

         nPos = valor.indexOf( "/" ) ;
         nMes = valor.substr( 0, nPos ) ;

         nAno = valor.substr( nPos +  1 ) ;
         lFlag = true ;
      }
      else 
      {
         
         if ( valor.indexOf( "-" ) >  0 ) 
         {
               nPos = valor.indexOf( "-" ) ;
		         nDia = valor.substr( 0, nPos ) ;
               valor = valor.substr( nPos +  1 ) ;

		         nPos = valor.indexOf( "-" ) ;
		         nMes = valor.substr( 0, nPos ) ;

               nAno = valor.substr( nPos +  1 ) ;
			   
		         lFlag = true ;
		   }
		   else
		   {
            if ( valor.indexOf( "." ) >  0 ) 
            {
                  nPos = valor.indexOf( "." ) ;
		            nDia = valor.substr( 0, nPos ) ;
                  valor = valor.substr( nPos +  1 ) ;

		            nPos = valor.indexOf( "." ) ;
		            nMes = valor.substr( 0, nPos ) ;

                  nAno = valor.substr( nPos +  1 ) ;
			      
		            lFlag = true ;
		      }
		   }
	   }

     if ( lFlag ) 
     {
         lFlag = false ;
		   if ( nMes ==  1 || nMes ==  3 || nMes ==  5 || nMes ==  7 || nMes ==  8 || nMes == 10 || nMes == 12 ) 
		   {
		      if ( nDia >=  1 && nDia <= 31 ) 
		      {
		         lFlag = true ;
		      }
		   }
		   if ( nMes ==  4 || nMes ==  6 || nMes ==  9 || nMes == 11 ) 
		   {
		      if ( nDia >=  1 && nDia <= 30 ) 
		      {
		         lFlag = true ;
		      }
		   }
		   if ( nMes ==  2 ) 
		   {
		      if ( nDia >=  1 && nDia <= 28 ) 
		      {
		         lFlag = true ;
		      }
		   }
	 
		 if ( nAno.length == 2 ) 
		 {
			if ( nAno > '80' )
			{
				nAno = '19' + nAno ;
			}
			else
			{
				nAno = '20' + nAno ;
			}				
		 }

			{
			   dFecha  =     nAno  + "/" ;
			   dFecha += ( ( parseFloat( nMes ) < 10 ) ? "0" : "" ) + parseFloat( nMes ) + "/" ;
			   dFecha += ( ( parseFloat( nDia ) < 10 ) ? "0" : "" ) + parseFloat( nDia ) ;
			}
	 }
  }
  else 
  {
     if ( oblig == "n" || oblig == "N" ) 
     {
	    lFlag = true ;
	 }
  }
  return( dFecha ) ;
}


function validFecha4_6( valor, oblig ) 
{
  var FechaActual = new Date() ;
  var dFecha = valor; //new Date( valor ) ;
  var nDia ;
  var nMes ;
  var nAno ;
  var nPos ;
  var lFlag = false ;
  var FechStr = new String( valor )
  if ( dFecha != 'NaN' ) 
  {
	if (FechStr.length == 2 )
	{         
         nDia = FechStr.substr( 0, 2 ) ;
		 nMes = FechaActual.getMonth()+1;
		 nAno = FechaActual.getYear();
	}
	if (FechStr.length == 4 )
	{         
         nDia = FechStr.substr( 0, 2 ) ;
		 nMes = FechStr.substr( 2, 2 ) ;
		 nAno = FechaActual.getYear();
	}
	if (valor.length == 6 )
	{         
         nDia = FechStr.substr( 0, 2 ) ;
		 nMes = FechStr.substr( 2, 2 ) ;
		 nAno = FechStr.substr( 4, 2 ) ;
			 if ( nAno.length == 2 ) 
			 {
				if ( nAno > '80' )
				{
					nAno = '19' + ( ( parseFloat( nAno ) < 10 ) ? "0" : "" ) + parseFloat( nAno ) ;
				}
				else
				{
					nAno = '20' + ( ( parseFloat( nAno ) < 10 ) ? "0" : "" ) + parseFloat( nAno ) ;
				}				
			 }
	}
	   dFecha  = ( ( parseFloat( nDia ) < 10 ) ? "0" : "" ) + parseFloat( nDia ) + "/" ;
	   dFecha += ( ( parseFloat( nMes ) < 10 ) ? "0" : "" ) + parseFloat( nMes ) + "/" ;
	   dFecha +=     nAno ;
  return( dFecha ) ;
  }
}

function validaNumeros( valor )
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
     return( false ) ;
  }
}


function Convierte_Fecha( valor, cSep ) 
{
  var FechaActual = new Date() ;
  var nDia = "";
  var nMes = "";
  var nAno = "";
  var nPos ;
  var Tot = 0;
  var lFlag = false ;
  var FechStr = new String( valor )
  if ( validEmpty( cSep ) )
  {
	cSep = "/"
  }

  //if ( valor.length == 2 ) { valor = valor + cSep}
  //if ( valor.length == 5 ) { valor = valor + cSep}
  valor = valor + cSep;
  if ( valor != 'NaN' ) 
  {
     if ( valor.indexOf( cSep ) >  0 ) 
     {
         nPos = valor.indexOf( cSep ) ;
         nDia = valor.substr( 0, nPos ) ;
         valor = valor.substr( nPos +  1 ) ;
     }
     
     if ( valor.indexOf( cSep ) >  0 )
     {
         nPos = valor.indexOf( cSep ) ;
         nMes = valor.substr( 0, nPos );
         valor = valor.substr( nPos +  1 ) ;
	 }
        nAno = valor.replace("/","").replace("-","") ;	 
	 if ( validEmpty(nMes) )
	 {
		nMes = FechaActual.getMonth();
	 }
	 if ( validEmpty(nAno) || nAno.length == 0 ) 
	 {
 		var nAno = FechaActual.getYear();
	 }
	 else
	 {
		if ( nAno.length <= 2 )
		{
			if ( nAno > '80' )
			{
				nAno = '19' + ((parseFloat( nAno ) < 10 ) ? "0" : "" ) + parseFloat( nAno ) ;
			}
			else
			{
				nAno = '20' + ((parseFloat( nAno ) < 10 ) ? "0" : "" ) + parseFloat( nAno ) ;
			}				
		}
	 }

	   dFecha  = ( ( parseFloat( nDia ) < 10 ) ? "0" : "" ) + parseFloat( nDia ) + "/" ;
	   dFecha += ( ( parseFloat( nMes ) < 10 ) ? "0" : "" ) + parseFloat( nMes ) + "/" ;
	   dFecha +=     nAno ;
  	return( dFecha ) ;
  }
}

/*	OJO
	se le pasa mm como ObjetoFecha.getMonth(), es decir Enero=0
*/
function diasdelMes( mm, yy)
{
	var bisiesto = ((( yy % 4 == 0 ) && (yy % 100 != 0 )) || ( yy % 400 == 0));
	var ultimodiadelmes = new UltimoDia(bisiesto);
	//alert(ultimodiadelmes)
	return (ultimodiadelmes[mm]);
}

function UltimoDia(bisiesto)
{
	this[0] = 31;
	this[1] = 28;
	if (bisiesto)
	{
		this[1] = 29;
	}
	this[2] = 31;
	this[3] = 30;
	this[4] = 31;
	this[5] = 30;
	this[6] = 31;
	this[7] = 31;
	this[8] = 30;
	this[9] = 31;
	this[10] = 30;
	this[11] = 31;
}