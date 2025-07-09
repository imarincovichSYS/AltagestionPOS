<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Pump It</title>
<div id="a">Vista previa</div>
<textarea id="c"></textarea>
<button onclick="vis()">Vista previa</button>
<script>
function vis() {
var cont = document.getElementById("c").value;
document.getElementById("a").innerHTML = cont;//lo que hace es poner en el contenido e vivo de la pagina el codigo y como es en html lo corre perfectamente
}
</script>

<form name="form_11550427219" id="11550427219">
<textarea onkeyup = "validarrr(this.form)" name="q3_contenido" id="input_3" class="post required text cuenta-save-1 ui-corner-all form-input-text box-shadow-soft markItUpEditor form-textarea validate[required]" style="height: 470px; width: 400px; resize: none;" tabindex="2"></textarea>
<input value="Vista Previa" class="form-submit-button" onclick="preview()" type="button" name="probar" disabled="disabled">
</form>


</body>
</html>

