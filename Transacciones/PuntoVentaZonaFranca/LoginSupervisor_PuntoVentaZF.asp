<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<html>
<head>
    <title>Supervisor(a)</title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
	<script src="../../Scripts/Js/Ajax.js"></script>
	<script src="../../js/tools.js"></script>
</head>
<script language="javascript">
var dato = "";
function validaSupervisor() 
{ 
  if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete")
  {
    var aDato = xmlHttp.responseText.split("|")
    dato = aDato[0]
    if ( aDato[0] == 'N' )
    {
        alert ( aDato[1] )
        document.Formulario.Password.value = ""
        document.Formulario.Usuario.value = ""
        document.Formulario.Usuario.style.visibility=""
        document.Formulario.Usuario.focus()
        return;
    }
    fDevolverResultado( dato )
  }
}  

function Close(valor)
{
  dato = valor;
  if ( valor == 1 )
  {
      var Usuario = document.Formulario.Usuario.value
      var Clave = document.Formulario.Password.value
      xmlHttp=GetXmlHttpObject()
      if (xmlHttp==null)
      {
          alert ("Browser does not support HTTP Request")
          return
      } 
      var url = "ValidaSupervisor_PuntoVentaZF.asp?Usuario=" + escape(Usuario) + "&Clave=" + escape(Clave);
      url=url + "&sid=" + Math.random()
      xmlHttp.onreadystatechange = validaSupervisor
      xmlHttp.open("GET",url,true)
      xmlHttp.send(null)
  }
  else
  {
      fDevolverResultado( valor )
  }
}
    
function fDevolverResultado( valor )
{
  if ( dato == "N" )
  {
      alert ( 'El usuario/password ingresado no es válido.\n\nReitente por favor.' )
      return;
  }
          
  window.returnValue = dato;
  window.close();
}

var blnDOM = false, blnIE4 = false, blnNN4 = false; 

if (document.layers) 
  blnNN4 = true;
else if (document.all) 
  blnIE4 = true;
else if (document.getElementById) 
  blnDOM = true;

function getKeycode(e)
{
	var TeclaPresionada = ""
	if (blnNN4)
	{
		var NN4key = e.which
		TeclaPresionada = NN4key;
	}
	if (blnDOM)
	{ 
		var blnkey = e.which
		TeclaPresionada = blnkey;
	}
	if (blnIE4)
	{
		var IE4key = event.keyCode
		TeclaPresionada = IE4key
	}

	if (TeclaPresionada == 27) //Escape - Salida
	  Close(2);
}

document.onkeydown = getKeycode;
if (blnNN4) document.captureEvents(Event.KEYDOWN);
</script>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>">
    <form name="Formulario" method="Post" action="">
        <table width=100% align=center border=0 cellspacing=0 cellpadding=0>
            <tr height=50>
                <td align=center class=FuenteEncabezados>
                    Se debe ingresar a un(a) supervisor(a) para realizar este procedimiento: 
                </td>
            </tr>
        </table>
        <table width=100% align=center border=0 cellspacing=0 cellpadding=0>
            <tr height=50>
                <td align=center class=FuenteInput>Usuario</td>
                <td align=center class=FuenteInput>
                  <input id="oculto" type="text" name="oculto" maxlength="1" value="" style="border:1px ; width: 1px; color:FFFFFF;">
                  <INPUT style="color:FFFFFF;"
                    OnBlur="if(this.value!='')document.Formulario.Usuario.style.visibility='hidden'"
                    class=FuenteInput size=20 maxlength=13 type="text" name="Usuario" value="" >
                </td>
            </tr>
            <tr height=50>
                <td align=center class=FuenteInput>Contraseña</td>
                <td align=center class=FuenteInput>
                    <INPUT 
                    OnKeypress="SetKey(event);if(key==13)Close(1);"
                    class=FuenteInput size=20 maxlength=10 type="password" name="Password" value="" >
                </td>
            </tr>

            <tr height=50>
                <td align=center class=FuenteInput>
                    <INPUT class=FuenteInput onclick="Close(1);" type="button" value="Aceptar" name="btnAceptar" >
                </td>
                <td align=center class=FuenteInput>
                    <INPUT class=FuenteInput onclick="Close(2);" type="button" value="Cancelar" name="btnCancelar" >
                </td>
            </tr>

        </table>
    </form>
</body>
</html>

