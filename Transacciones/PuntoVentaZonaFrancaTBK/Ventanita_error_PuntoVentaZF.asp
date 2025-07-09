<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
Cache
%>

<html>
<head>
    <title>Error</title>
    <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
</head>
<body bgcolor="#CCCD94" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">

<center>

<form name="Formulario">

<table align="center" valign="center" height="80%" width="100%">
<tr>
<td align="center">
<div style="color=#ff0000; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px; text-decoration: blink;"><%=Session("MensajeError")%> </div> </BR>
<div>
     <img id="imagen" src="<%=session("ruta_imagen")%>" alt="Imagen producto" width="200" height="100" border="0"/>
</div>
</td>
</tr>
</table>

<input type="button" onclick="window.close()" value="Continuar" name="Continuar" onkeydown="if ( event.keyCode == 27 || event.keyCode == 13 ) { window.close(); } else { document.Formulario.Continuar.focus(); }">

</form>

</center>

<embed src="error2.wav" 
width=0 height=0 autostart=true repeat=true loop=true> </embed>

</body>
</html>
<script language="JavaScript">
document.Formulario.Continuar.focus();
</script>
