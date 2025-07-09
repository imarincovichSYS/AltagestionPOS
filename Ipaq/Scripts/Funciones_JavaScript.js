function validEMail( valorObj ) {

   var nCnt, cChr ;
   var chrOblig_1  = "@" ;
   var chrOblig_2  = "." ;
   var chrNumeros  = "0123456789" ;
   var chrValidar  = chrOblig_1 + chrOblig_2 ;
       chrValidar += chrNumeros ;
       chrValidar += "abcdefghijklmnñopqrstuvwxyz" ;
       chrValidar += "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ" ;
       chrValidar += "_-" ;
   var logicReturn = true ;

   var largoObj = valorObj.length ;

   // Primero: valida los caracteres obligatorios.
   if (                valorObj.indexOf( chrOblig_1 ) == -1 ) { logicReturn = false }
   if ( logicReturn && valorObj.indexOf( chrOblig_2 ) == -1 ) { logicReturn = false }

   // Segundo: valida los demas caracteres.
   if ( logicReturn ) {
      nCnt =  0 ;
      for ( var i =  0; i < largoObj; i++ ) {
          cChr = valorObj.substring( i, i +  1 )
         if ( chrValidar.indexOf( cChr ) != -1 ) { nCnt++ }
      }
      if ( nCnt != largoObj ) {
         logicReturn = false ;
      }
   }

   if ( logicReturn ) {
   // Todos los caracteres son validos.
      nposOblig_1 = valorObj.indexOf( chrOblig_1 ) ;
      chrUsuario  = valorObj.substr(  0, nposOblig_1 ) ;
      chrDominio  = valorObj.substr( nposOblig_1 +  1 ) ;

      // Valida que chrUsuario y chrDominio no sean nulos.
      if ( chrUsuario.length ==  0 || chrDominio.length ==  0 ) { logicReturn = false }
      
      if ( logicReturn ) {
         primerChrUsuario = chrUsuario.substr(  0,  1 ) ;
         primerChrDominio = chrDominio.substr(  0,  1 ) ;
         
         // Valida que el primer caracter no sea un numero.
         if (                chrNumeros.indexOf( primerChrUsuario ) != -1 ) { logicReturn = false }
         if ( logicReturn && chrNumeros.indexOf( primerChrDominio ) != -1 ) { logicReturn = false }
         
         // Validar que el chrOblig_1 no esté en: chrUsuario y chrDominio.
         if ( logicReturn && chrUsuario.indexOf( chrOblig_1 ) != -1 ) { logicReturn = false }
         if ( logicReturn && chrDominio.indexOf( chrOblig_1 ) != -1 ) { logicReturn = false }
         
         // Validar que por lo menos exista un chrOblig_2 en: chrDominio.            
         if ( logicReturn && chrDominio.indexOf( chrOblig_2 ) == -1 ) { logicReturn = false }
         
         // Se valida que: chrEmpresa o chrPais no sean nulos.
         if ( logicReturn ) {
            nposOblig_2 = chrDominio.indexOf( chrOblig_2 ) ;
            chrEmpresa  = chrDominio.substr(  0, nposOblig_2 ) ;
            chrPais     = chrDominio.substr( nposOblig_2 +  1 ) ;
            nposOblig_3 = chrPais.indexOf( chrOblig_2 ) ;
         
            // Valida que no sean nulos.               
            if ( chrEmpresa.length ==  0 || chrPais.length ==  0 ) { logicReturn = false }
            // Valida que los dos chrOblig_2 no estén juntos.
            if ( logicReturn && nposOblig_3 ==  0 ) { logicReturn = false }
         }
         
         // Si existe un chrOblig_2 en chrUsuario, valida que no sean nulos.
         if ( logicReturn ) {
            nposOblig_2 = chrUsuario.indexOf( chrOblig_2 ) ;
            if ( nposOblig_2 != -1 ) {
               chrUsuario1 = chrUsuario.substr(  0, nposOblig_2 ) ;
               chrUsuario2 = chrUsuario.substr( nposOblig_2 +  1 ) ;

               if ( chrUsuario1.length ==  0 || chrUsuario2.length ==  0 ) { logicReturn = false }
            }
         }
         
      }
      
   }

   return logicReturn ;
}



function validEMails( valorObj, chrSeparador ) {

   if ( chrSeparador == null ) {
      chrSeparador = ";" ;
   }
   var logicReturn = true ;
   var flag = true ;

   if ( valorObj.length ==  0 ) { logicReturn = false ; flag = false }
   
   while ( flag ) {
      // Posicion del separador.
      nposSep = valorObj.indexOf( chrSeparador ) ;

      // Si nposSep es distinto de -1 significa que existe un texto a validar.
      if ( nposSep != -1 ) {
         chrValidar = valorObj.substr(  0, nposSep ) ;
      }
      else {
         chrValidar = valorObj ;
         nposSep    = valorObj.length ;
      }

      // Elimina el texto de la cadena general.
      valorObj = valorObj.substr( nposSep +  1 ) ;
                  
      // Ejecuta la funcion.
      if ( ! validEMail( chrValidar ) ) {
         flag = false ;
         logicReturn = false ;
      }
                  
      if ( valorObj.length ==  0 ) {
         flag = false ;
      }
   }

   return logicReturn ;
}



// Rutina : Valida que un valor sea numerico. TRUE si es numero.
function validNum( valor ) {
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0123456789." ;

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



// Rutina : Valida que un valor sea alfabetico. TRUE si es alfabetico.
function validChr( valor ) {
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



// Rutina : Valida que una cadena no este vacia. TRUE esta vacia.
function validEmpty( valor ) {
  var cChr ;
  var nCnt =  0 ;
  var cNum = " " ;

  if ( valor.length !=  0 ) {
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
     return( true ) ;
  }

}



// Rutina : Valida que una cadena no sea un cero. TRUE si es cero
function validZero( valor ) {
  var cChr ;
  var nCnt =  0 ;
  var cNum = "0" ;

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



// Rutina : Valida el ingreso de una fecha. TRUE si es valida
function validFecha( valor ) {
  var nDia ;
  var nMes ;
  var nAno ;
  var nPos ;
  var dFecha ;
  var lFlag = false ;

  if ( valor.indexOf( "/" ) !=  0 ) {
     nPos  = valor.indexOf( "/" ) ;
  	  nDia  = valor.substr( 0, nPos ) ;
     valor = valor.substr( nPos +  1 ) ;
  
  	  nPos  = valor.indexOf( "/" ) ;
  	  nMes  = valor.substr( 0, nPos ) ;
  
     nAno  = valor.substr( nPos +  1 ) ;
            
  	  lFlag = true ;
  }
  else {
     if ( valor.indexOf( "-" ) !=  0 ) {
  	     nPos  = valor.indexOf( "-" ) ;
  		  nDia  = valor.substr( 0, nPos ) ;
        valor = valor.substr( nPos +  1 ) ;
  
  		  nPos  = valor.indexOf( "-" ) ;
  		  nMes  = valor.substr( 0, nPos ) ;
  
        nAno  = valor.substr( nPos +  1 ) ;
  			   
  		  lFlag = true ;
     }
  }

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



// Rutina : convierte la fecha a formato JAVASCRIPT.
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
