<html>
<body>
<script language="javascript">
Navegador_No_IE = document.getElementById&&!document.all
var DERECHA = 39 ; var IZQUIERDA = 37;

function SetKey(evt)
{
  key = Navegador_No_IE ? evt.which : evt.keyCode;
}

function Bloquear_Key_Izquierda_Derecha_Select(evt){
  v_key = Navegador_No_IE ? evt.which : evt.keyCode;
  if(v_key == IZQUIERDA || v_key == DERECHA)
    return false
  else
    return true
}
</script>
<center>
<select style="width:100px;" onkeydown="return Bloquear_Key_Izquierda_Derecha_Select(event)">
  <option value="A">A</option>
  <option value="B">B</option>
  <option value="C">C</option>
  <option value="D">D</option>
</select>

<input readOnly 
OnFocus="this.select();"
type="text" id="input1" name="input1" value="hola1">
<input 
OnFocus="this.select();"
type="text" id="input2" name="input2" value="hola2">
</center>
</body>
</html>
<script language="javascript">
</script>