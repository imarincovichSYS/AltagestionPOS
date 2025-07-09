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


function  VerificaComilla( formulario, obj )
{
var comilla      =/'/;
var dobleComilla =/"/;

var datoRemplazo =eval( "document." + formulario + "." + obj.name + ".value");
var hasta= datoRemplazo.length;

for (var i=0; i < hasta;i++) 
{
   if (datoRemplazo.substring(i,i+1) == "'" )  
    {
        datoRemplazo= datoRemplazo.replace( comilla," ");
		var hasta = hasta +1 ;
    }
    else 
	if (datoRemplazo.substring(i,i+1) == '"')
        {
           datoRemplazo= datoRemplazo.replace( dobleComilla," ");
	   var hasta = hasta +1 ;
        }
}
    eval( "document." + formulario + "." + obj.name + ".value = datoRemplazo");
}

function Valida_Rut ( objRut, objDigito )
{

   var rut = objRut.value;
   var suma=0 ;
   var res ;
   var dvr = '0';
   var dvi,dv ;
   var largo=rut.length;

   if (largo > 8 || largo < 7 )
   {
	alert ("Lo ingresado no corresponde.");
	objRut.focus();
   }
   else
     {
      mu1 = 2
      for (var  i=rut.length - 1 ; i >= 0; i--)
      {
	      suma = suma + rut.charAt(i)* mu1
	      if (mu1 == 7)
	          mu1 = 2
          else
	         mu1++
      }
      res = suma % 11
      if (res == 1)
          dvr = 'K'
      else if (res==0)
             dvr = '0'
      else
       {
         dvi = 11 - res
	     dvr = dvi + ""
       }	
       if (dvr != objDigito.value.toUpperCase() )
       {
        	alert ("El digito ingresado no corresponde.");
		objDigito.value = "";
		objRut.value = "";
		objRut.focus();
       }
       else
       {
//        	alert ("El digito esta bien ingresado")
       }
      }
  }

function validRut( Rut, Digito )
{

   var suma=0 ;
   var res ;
   var dvr = '0';
   var dvi,dv ;
   var largo = Rut.length;
   var Error = 'N';

   if (largo > 8 || largo < 7 )
   {
	Error = "S";
   }
   else
     {
      mu1 = 2
      for (var  i=Rut.length - 1 ; i >= 0; i--)
      {
	      suma = suma + Rut.charAt(i)* mu1
	      if (mu1 == 7)
	          mu1 = 2
          else
	         mu1++
      }
      res = suma % 11
      if (res == 1)
          dvr = 'K'
      else if (res==0)
             dvr = '0'
      else
       {
         dvi = 11 - res
	     dvr = dvi + ""
       }	

       if (dvr != Digito.toUpperCase() )
       {
		Error = "S";
       }
      }
	if ( Error == "N" )
	{
	   return (true);
	}
	else
	{
	   return (false);
	}
  }

function validaCaractesrut ( valor, obj )
{
  var cChr ;
  var nCnt =  0 ;
  var k =  false ;
  var signo =  false ;
  var K =  false ;
  var cNum = "0123456789-Kk" ;
    for (var i =  0; i < valor.length; i++ )
    {
                cChr = valor.substring( i, i +  1 );
               if (cChr == '-' )
               {
                     if (signo)
                     {
                     	alert ("Lo ingresado no corresponde.");
                        obj.focus();     
                        obj.value = 0;     
                        return( false ) ;
                     }
                     else
                     {
                        signo=true;
                     }
               }   
               if (cChr == 'K' )
               {
                     if (K)
                     {
                     	alert ("Lo ingresado no corresponde.");
                        obj.focus();     
                        obj.value = 0;     
                        return( false ) ;
                     }
                     else
                     {
                        K=true;
                     }
               }
               if (cChr == 'k' )
               {
                     if (k)
                     {
                     	alert ("Lo ingresado no corresponde.");
                        obj.focus();     
                        obj.value = 0;     
                        return( false ) ;
                     }
                     else
                     {
                        k=true;
                     }
               }
               if ( cNum.indexOf( cChr ) != -1 )
               {
                  nCnt++ ;
               }
    }
  
      if (valor == '' )
      {
        obj.value = 0;
        return ( true );
      }
      if ( nCnt == valor.length && signo) 
      {
         return( true ) ;
      }
      else
      {
      	alert ("Lo ingresado no corresponde.");
         obj.focus();     
         obj.value = 0;     
         return( false ) ;
      }
}

	function validaCaractesPassWord ( valor, obj )
	{
		var cChr ;
		var nCnt =  0 ;
		var cNum = "'/\|,ç+" + '"' ;

		for (var i =  0; i < valor.length; i++ )
		{
			cChr = valor.substring( i, i +  1 )
			if ( cNum.indexOf( cChr, 0) != -1 )
			{
                    Mensajes_Error ( "No se permiten los siguientes caracteres ("+ cNum + ")" )
				obj.focus();
				return( false );
			}
		}
          Mensajes_Error ( "" )  ;
          return(true);
	}	

// Rutina : Valida que una cadena no este vacia.
// Entrada: valor
// Salida : true esta vacia.
function validEmpty( valor )
{
  for (var i =  0; i < valor.length; i++ )
  {
	  if ( valor.substr( i,  1 ) != " " )
          {
	     return( false ) ;
	  }
  }
 return( true ) ;
}

function validZero( valor ) 
{
// Rutina : Valida que una cadena no sea un cero.
// Entrada: valor
// Salida : true no es cero.

  if ( valor.substr( 0,  1 ) == "0" ) {
     return( false ) ;
  }
  else {
     return( true ) ;
  }

}

// Rutina : Valida que un valor sea alfabetico.
// Entrada: valor
// Salida : true si es alfabetico.
function validChr( valor ) 
{
  var cChr ;
  var cNum = "0123456789" ;

  for (var i =  0; i < valor.length; i++ ) {
      cChr = valor.substring( i, i +  1 )
	  if ( cNum.indexOf( cChr,  0 ) != -1 ) {
	     return( false ) ;
	  }
  }
  return( true ) ;

}

// Valida el formato de un campo para Patente de vehículo
// Salida: true si formato correcto, false en caso contrario
function CheckPatente(item) {
	var returnVal = false
	string = item.value

	if (string.length != 6)
		alert("Número de caracteres inválido en Patente ")
	else if ( !isNaN(parseInt(string.substring(0,1))) | !isNaN(parseInt(string.substring(1,2))) |
			!esNumPos(string.substring(2,7)) )
		alert("Formato de Patente incorrecto (2 letras, 4 números)")
	else 	
		returnVal = true

	return returnVal
}

function placeFocus() 
{
if (document.forms.length > 0) 
{
      var field = document.forms[0];
      for (i = 0; i < field.length; i++) 
      {
         if ((field.elements[i].type == "text") || (field.elements[i].type == "textarea") || (field.elements[i].type.toString().charAt(0) == "s")) 
            {
               document.forms[0].elements[i].focus();
               break;
            }
         }
      }
}


function  EspaciosA_( valor )
{
    var datoRemplazo	=	valor;
	var hasta			=	datoRemplazo.length;
	for (var i=0; i < hasta;i++) 
	  {
	   if (datoRemplazo.substring(i,i+1) == " " )  
	    {
	        datoRemplazo = datoRemplazo.replace( " ","_");
			var hasta = hasta + 1 ;
	    }
	  }	  
	  return ( datoRemplazo ) ;
}

/*******************************/
      function Commas( obj ) 
/*******************************/
{
         var newobj = "" ;
         var chrnum = "0123456789" ;
         var chrpun = "." ;
         var objeto = "" + obj;
         if (objeto != "undefined")
         {          
				for (var i =  0; i < obj.value.length; i++)
				{
						if ( obj.value.substr( i,  1 ) != "." ) 
						{
							if ( chrnum.indexOf( obj.value.substr( i,  1 ) ) != -1 )
							 {
								newobj += obj.value.substr( i,  1 ) ;
							}
							else
							{
								newobj += "" ;
							}
						}
				}
		        if ( newobj.length <=  3 ) 
		        {
				    obj.value = newobj ;
		        }
		         if ( newobj.length >  3 && newobj.length <=  6 ) 
		         {
				    obj1 = newobj.substr( 0, newobj.length -  3 ) ;
					obj2 = newobj.substr( newobj.length -  3,  3 ) ;
				    obj.value = obj1 + "." + obj2 ;
            
		         }
				if ( newobj.length >  6 && newobj.length <=  9 ) 
				{
		            obj1 = newobj.substr( 0, newobj.length -  6 ) ;
				    obj2 = newobj.substr( newobj.length -  6,  3 ) ;
		            obj3 = newobj.substr( newobj.length -  3,  3 ) ;
				    obj.value = obj1 + "." + obj2 + "." + obj3 ; 
		         }
		         if ( newobj.length >  9 && newobj.length <= 12 ) 
		         {
				    obj1 = newobj.substr( 0, newobj.length -  9 ) ;
		            obj2 = newobj.substr( newobj.length -  9,  3 ) ;
				    obj3 = newobj.substr( newobj.length -  6,  3 ) ;
		            obj4 = newobj.substr( newobj.length -  3,  3 ) ;
		            obj.value = obj1 + "." + obj2  + "." + obj3 + "." + obj4 ;
				 }
		         if ( newobj.length > 12 && newobj.length <= 15 ) 
		         {
				    obj1 = newobj.substr( 0, newobj.length - 12 ) ;
		            obj2 = newobj.substr( newobj.length - 12,  3 ) ;
				    obj3 = newobj.substr( newobj.length -  9,  3 ) ;
		            obj4 = newobj.substr( newobj.length -  6,  3 ) ;
				    obj5 = newobj.substr( newobj.length -  3,  3 ) ;
		            obj.value = obj1 + "." + obj2  + "." + obj3 + "." + obj4 + "." + obj5 ;
				 }
		}
}

/*******************************/
	function Sincommas( obj)
/*******************************/
{
         var newobj = "" ;
         var chrnum = "0123456789" ;
         var chrpun = "." ;
         var objeto="" + obj;
         if (objeto != "undefined")
         {          

	         if ( obj.value.indexOf( chrpun ) == -1 ) 
		     {
			          newobj += obj.value;
			 }
			else
			{			
				for (var i =  0; i < obj.value.length; i++)
				 {
						if ( obj.value.substr( i,  1 ) != "." )
						 {
							if ( chrnum.indexOf( obj.value.substr( i,  1 ) ) != -1 ) 
							{
								newobj += obj.value.substr( i,  1 ) ;
							}
						 }
					}
			}
				obj.value = newobj ;
		}
}	

function Limpia_BarraEstado()
{
	window.status = " ";
}

function noticeIE()
{ 
	menutext.style.left=document.body.scrollLeft+event.clientX;
	menutext.style.top=document.body.scrollTop+event.clientY;
	menutext.style.visibility="visible";
	return false
}

function hidenoticeIE()
{
	menutext.style.visibility="hidden";
}

function noticeNS()
{ 
	menutext.style.left	= document.body.scrollLeft+event.clientX;
	menutext.style.top	= document.body.scrollTop+event.clientY;
	document.layers["menutext"].visibility = 'show';
//	menutext.style.visibility="show";
	return false
}

function hidenoticeNS()
{
	document.layers["menutext"].visibility = 'hiden';
}

function validaCharNoPermitidos( valor )
{
	var cChr ;
	var nCnt =  0 ;
	var cNum = "'|,ç+" + '"' ;
	avalor = valor.split('|');
	valor = avalor[0];
	for (var i =  0; i < valor.length; i++ )
	{
		cChr = valor.substring( i, i +  1 )
		if ( cNum.indexOf( cChr, 0) != -1 )
		{
			nCnt = nCnt + 1;
		}			
	}
	//alert ( nCnt )
	if ( nCnt == 0)
	{
		return( false );
	}
	else
	{
		return( true );
	}
}	

function validaCharNoPermitidos_Txt( valor )
{
	var cChr ;
	var nCnt =  0 ;
	var cNum = "'," + '"' ;
	avalor = valor.split('|');
	valor = avalor[0];
	for (var i =  0; i < valor.length; i++ )
	{
		cChr = valor.substring( i, i +  1 )
		if ( cNum.indexOf( cChr, 0) != -1 )
		{
			nCnt = nCnt + 1;
		}			
	}
	//alert ( nCnt )
	if ( nCnt == 0)
	{
		return( false );
	}
	else
	{
		return( true );
	}
}	

function validaRutaFuncion( valor )
{
	var cChr ;
	var nCnt =  0 ;
	var cNum = "'|,ç+-" + '"' ;
	avalor = valor.split('|');
	valor = avalor[0];
	for (var i =  0; i < valor.length; i++ )
	{
		cChr = valor.substring( i, i +  1 )
		if ( cNum.indexOf( cChr, 0) != -1 )
		{
			nCnt = nCnt + 1;
		}			
	}
	//alert ( nCnt )
	if ( nCnt == 0)
	{
		return( false );
	}
	else
	{
		return( true );
	}
}	

	function LTrim(str)
	{
	  var i;
	  var inicio; /* Posición desde donde no hay espacios */
	  if (str == null)
	     return "";
	  largo = str.length;
	  inicio = 0;
	  for(i=0;i<largo;i++) {
	     c = str.charAt(i);
	     if ( c == ' ')
	       inicio = i + 1;
	     else
	       break;
	  }
	  return str.substring(inicio,largo);
	}

	function RTrim(str)
	{
	  var i;
	  var fin;  /* Posición hasta donde no hay espacios */
	  if (str == null)
	     return "";
	  fin = str.length;
	  for(i=fin - 1;i>=0;i--) {
	     c = str.charAt(i);
	     if ( c == ' ')
	       fin = i;
	     else
	       break;
	  }
	  return str.substring(0,fin);
	}	


	/*
		formulario; es el nombre del formulario donde se encuentra fuente y destino
		fuente : que es lo que se desa copiar
		destino: donde quedará copiado
		accion : c=copiar , p=paste
		Ej. Copiar ClipBoard( 'Formulario', 'copytext', '', 'c')
		Ej. Copiar ClipBoard( 'Formulario', '', 'readtext', 'p')
	*/
	function ClipBoard( formulario, fuente, destino, accion)
	{
		var objeto1 = eval("document." + formulario + ".holdtext" );
		if ( accion.toLowerCase() == 'c' )
		{
			objeto1.innerText = eval(fuente + ".innerText" );
			Copied = objeto1.createTextRange();
			Copied.execCommand("RemoveFormat");
			Copied.execCommand("Copy");
		}
		else if ( accion.toLowerCase() == 'p' )
		{
			if ( eval("document." + formulario + "." + destino + ".disabled == false ") )
			{
				eval("document." + formulario + "." + destino + ".value = ''");
				eval("document." + formulario + "." + destino + ".focus()");
				document.execCommand("Paste");
			}
		}
	}


function replaceSubstring(inputString, fromString, toString) {
   // Goes through the inputString and replaces every occurrence of fromString with toString
   var temp = inputString;
   if (fromString == "") {
      return inputString;
   }
   if (toString.indexOf(fromString) == -1) { // If the string being replaced is not a part of the replacement string (normal situation)
      while (temp.indexOf(fromString) != -1) {
         var toTheLeft = temp.substring(0, temp.indexOf(fromString));
         var toTheRight = temp.substring(temp.indexOf(fromString)+fromString.length, temp.length);
         temp = toTheLeft + toString + toTheRight;
      }
   } else { // String being replaced is part of replacement string (like "+" being replaced with "++") - prevent an infinite loop
      var midStrings = new Array("~", "`", "_", "^", "#");
      var midStringLen = 1;
      var midString = "";
      // Find a string that doesn't exist in the inputString to be used
      // as an "inbetween" string
      while (midString == "") {
         for (var i=0; i < midStrings.length; i++) {
            var tempMidString = "";
            for (var j=0; j < midStringLen; j++) { tempMidString += midStrings[i]; }
            if (fromString.indexOf(tempMidString) == -1) {
               midString = tempMidString;
               i = midStrings.length + 1;
            }
         }
      } // Keep on going until we build an "inbetween" string that doesn't exist
      // Now go through and do two replaces - first, replace the "fromString" with the "inbetween" string
      while (temp.indexOf(fromString) != -1) {
         var toTheLeft = temp.substring(0, temp.indexOf(fromString));
         var toTheRight = temp.substring(temp.indexOf(fromString)+fromString.length, temp.length);
         temp = toTheLeft + midString + toTheRight;
      }
      // Next, replace the "inbetween" string with the "toString"
      while (temp.indexOf(midString) != -1) {
         var toTheLeft = temp.substring(0, temp.indexOf(midString));
         var toTheRight = temp.substring(temp.indexOf(midString)+midString.length, temp.length);
         temp = toTheLeft + toString + toTheRight;
      }
   } // Ends the check to see if the string being replaced is part of the replacement string or not
   return temp; // Send the updated string back to the user
} // Ends the "replaceSubstring" function

