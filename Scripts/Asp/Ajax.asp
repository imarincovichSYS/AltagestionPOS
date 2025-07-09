<script language="Javascript">
	function handleHttpResponse() 
	{
	   if (http.readyState == 4) {
	      if (http.status == 200) {
	         if (http.responseText.indexOf('invalid') == -1) {
	            // Armamos un array, usando la coma para separar elementos
	            results = http.responseText;
	            //document.getElementById(Objeto).innerHTML = results;
	            enProceso = false;
	         }
	      }
	   }
	}

	function getHTTPObject() 
	{
	    var xmlhttp;
	    /*@cc_on
	    @if (@_jscript_version >= 5)
	       try {
	          xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
	       } catch (e) {
	          try {
	             xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	          } catch (E) { xmlhttp = false; }
	       }
	    @else
	    xmlhttp = false;
	    @end @*/
	    if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
	       try {
	          xmlhttp = new XMLHttpRequest();
	       } catch (e) { xmlhttp = false; }
	    }
	    return xmlhttp;
	}
	
	var results = "";
	var enProceso = false; 
	var http = getHTTPObject(); 
  
</script>