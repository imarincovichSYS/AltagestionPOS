<html>   
<head>   
<title>Muestra y oculta div</title>   

<script language="JavaScript">   

function oculta(id){   
var elDiv = document.getElementById(id); //se define la variable "elDiv" igual a nuestro div   
elDiv.style.display='none'; //damos un atributo display:none que oculta el div       
}  

function muestra(id){  
var elDiv = document.getElementById(id); //se define la variable "elDiv" igual a nuestro div  
elDiv.style.display='block';//damos un atributo display:block que  el div       
}  


window.onload = function(){/*hace que se cargue la funci�n */  
/* "Mandamos como parametro el nombre de la Div para ocultar" */  
oculta('Pmoral'); /*Ocultamos Pmoral*/  
}  
</script>  

</head>  
<body>  
<!--Al hacer llamado de la funci�n solo tienes que idicar el nombre del DIV entre parentesis-->  
<p>  
<label>  
<input type="radio" name="pers_cte" value="Fisica"  id="per_0" onClick="muestra('Pfisica'); oculta('Pmoral')" checked > <!-- Al cambiar "onClick" el valor del radio llamamos la funcion ocultando los campos de Pfisica y mostrando Pmoral-->  
Fisica</label>  
<br>  
<label>  
<input type="radio" name="pers_cte" value="Moral" id="per_1" onClick="muestra('Pmoral'); oculta('Pfisica')">  
Moral</label>  
<br>  
</p>  
<div id="Pfisica">  
<p>Este contenido es para persona Fisica</p>  <!--Div para ocultar o mostrar de Persona Fisica -->  
</div>  
<div id="Pmoral">  
<p>Este contenido es para persona Moral</p>   <!--Div para ocultar o mostrar de Persona moral -->  
</div>  
</body>  
</html>
