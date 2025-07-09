
<html>

<head>
<SCRIPT language="JavaScript" type="text/JavaScript">
function CambiaTamanio (Objetol)
{
    Objeto.size = Objeto.textLength;
}
function cambiar_num_caract(caracteres)
{
document.getElementById('caract1').innerHTML = caracteres;
caract_tserv=caracteres;
}

function count_caract(obj)
{
cant = obj.value.length;
rest = caract_tserv - cant;
document.getElementById('caract1').innerHTML = rest;
if(rest < 0)
{ 
obj.value = obj.value.substr(0, caract_tserv); 
document.getElementById('caract1').innerHTML = 0;
}
}

</SCRIPT>

</head>
<body onload=private void Page_Load(object sender, System.EventArgs e)
{
if(!this.IsPostBack)
{
txtDescripcion.Attributes.Add("onkeydown","count_c aract(this)");
}
}

>
<form>
<form id="form1" name="form1" method="post" action="">
  <label>
  <input type="text" name="textfield"  onkeyup="CambiaTamanio(this);"/>
  </label>
</form> 
<P> Caracteres: <strong><span id="caract1">&nbsp;</span></strong> <input type="hidden" size="3" name="ok"></P>
<asp:textbox id="txtDescripcion" runat="server" Width="341px" Height="77px" TextMode="MultiLine"></asp:textbox>

<script type="text/javascript">
function ElementContent(id,content)
{
    document.getElementById(id).value = content;
}




</script>
 <%
 mostrar = "HOLA"
 %>  
<textarea id="ta1">&nbsp;</textarea>
<button value="Click Me!" onclick="ElementContent('ta1'," & "'" & <%=mostrar%> & "'" & ")"
/>


</form>

<SCRIPT language="JavaScript" type="text/JavaScript">
// Actualizar desde un inicio el numero de caract max
cambiar_num_caract(200)
</SCRIPT>

</body>
</html>
