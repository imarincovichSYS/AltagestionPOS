function comprobarnavegador() {
	var is_ie = navigator.userAgent.toLowerCase().indexOf('msie ') > -1;
   //Detectando Cualquier version de IE
        if (is_ie ) {
            var posicion = navigator.userAgent.toLowerCase().lastIndexOf('msie ');
            var ver_ie = navigator.userAgent.toLowerCase().substring(posicion+5, posicion+8);
            //Comprobar version
            ver_chrome = parseFloat(ver_ie);
            alert('Para imprimir Precios es necesario utilizar FIREFOX (Imprime PRECIOS) ubicado en el escritorio');
        }
    }
 
//Llamamos al funcion que comprueba el nagedaor al cargarse la página
//window.onload = comprobarnavegador();