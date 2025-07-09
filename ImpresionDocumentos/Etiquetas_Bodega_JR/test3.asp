
<html>
<head>
<script language=JavaScript>
function CambiaTamanio (Objetol)
{
    Objeto.size = Objeto.textLength;
}
</script>
</head>
<body>
<form id="form1" name="form1" method="post" action="">
  <label>
  <input type="text" name="textfield"  onkeyup="CambiaTamanio(this);"/>
  </label>
</form>
</body>
</html>
