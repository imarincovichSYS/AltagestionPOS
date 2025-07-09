<%
titulo = "Consulta Precio"
numero_nota_de_venta = Request.Form("num_n_de_venta") 
cliente              = Request.Form("cliente_nota_de_venta")
Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"
'SET Conn = Server.CreateObject("ADODB.Connection")
'Conn.Open strConnect
'Conn.commandtimeout=600
%>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<html>
<head>
<title>AltaGestión - <%=titulo%></title>
<script language="JavaScript">
var RutaProyecto  = "<%=RutaProyecto%>";
</script>
<link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">
<script language="JavaScript" src="<%=RutaProyecto%>js/tools.js"></script>
<script language="javascript" src="<%=RutaProyecto%>js/mootools-1.11.js"></script>
<link rel="stylesheet" href="<%=RutaProyecto%>ACIDgrid/grid.css" type="text/css">
<%

conn1 = strConnect
''''''''''''''''''''''''''''''''''PREGUNTO SI EXISTE O NO EL CLIENTE  EN LA BASE DE DATOS'''''''''''''''''''''
if cliente = "" then
  cliente = ""
  rut = ""
else
  strSQL="select Apellidos_persona_o_nombre_empresa, entidad_comercial from entidades_comerciales where empresa='SYS' and entidad_comercial = '"& cliente &"'"
  Set rs1 = Server.CreateObject("ADODB.Recordset")
  rs1.Open strSQL , conn1, , ,adCmdText
  if rs1.eof then
    Response.Write("<script>alert('Cliente No Existe');</script>")
    Response.Write("<script language=javascript> history.back(); </script>")
  else
    cliente = rs1("Apellidos_persona_o_nombre_empresa")
    rut = rs1("entidad_comercial")
  end if
end if
if cdbl(numero_nota_de_venta) = -1 then 'es cuando se crea una nueva nota de venta, este valor viene en -1
  'sql = "select * from ordenes_de_ventas where cliente = '" & cliente & "' and fecha = '" & month(date()) &"-"& day(date()) & "-" & year(date()) & "'"
  'Set rs2 = Server.CreateObject("ADODB.Recordset")
  'rs2.Open SQL , conn1, , ,adCmdText
  'if not rs2.eof then
  ''    Response.Write("<script>alert('Ya Existe Nota de Venta para el Cliente Hoy');</script>")
  ''    response.write("<script>var x= confirm('¿Crear nueva Nota de Venta?');if(x==false)history.back();</script>")       
  'end if
    strSQL="select valor_numerico from parametros where parametro = 'ULTNRONOTAVT' "
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.Open strSQL , conn1, , ,adCmdText
    numero_nota_de_venta = cdbl(rs("valor_numerico")) + 1
    
    strSQL="update parametros set valor_numerico ="& numero_nota_de_venta &" where parametro = 'ULTNRONOTAVT' "
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.Open strSQL , conn1, , ,adCmdText
   'end if      
end if
%>

</head>
<body onload="codigo.focus()">
<br>
<table id="table_enc" width="300" cellPadding="0" cellSpacing="0" align="center" border = 0>
<tr align="center">
  <td id="texto_12" colspan = 2>
  <b>NOTA DE VENTA NUMERO <%=numero_nota_de_venta%></b>
  </td>
</tr>
<tr>
  <td id="texto_12" style="width:150px;">&nbsp;Producto
    &nbsp;
    <input OnClick="this.value=''" onkeyUp="SetKey(event);if(key==13)Datos_Producto(this.value,'<%=numero_nota_de_venta%>');"
    type="text" id="codigo" name="codigo" maxlength="20" style="width:85px;">
  </td>
    
  <td id="texto_12" style="width:130px;">
    <%response.write trim(cliente)%>
  </td>
</tr>
<tr>
  <td id="texto_12" style="width:200px;">&nbsp;Cantidad
    &nbsp;
    <input OnClick="this.value=''" onkeyUp="SetKey(event);if(key==13)graba_Producto(this.value, '<%=numero_nota_de_venta%>');" onkeypress="return Valida_Digito(event);"
    type="text" id="cantidad" name="cantidad" maxlength="20" style="width:85px;">
  </td>
  <td style="width:200px;"><img 
    OnClick="Lista_detalle_orden_de_venta()"
    title="Lista detalle Orden de Venta" OnMOuseOver="this.style.cursor='hand'" src="Inv_lista.gif" width="23" height="24" border=0>&nbsp;
  <!--<img 
    OnClick="Cierra_orden_de_venta()"
    title="Cerrar Nota de Venta" OnMOuseOver="this.style.cursor='hand'" src="Cerrar.jpg" width="24" height="24" border=0>&nbsp;-->
  <img 
    OnClick="Volver()"
    title="Ir al Inicio" OnMOuseOver="this.style.cursor='hand'" src="Ico_Atras_24x24_on.gif" width="23" height="24" border=0>&nbsp;
  <img 
    OnClick="Imprimir()"
    title="Imprimir" OnMOuseOver="this.style.cursor='hand'" src="Imprimir.jpg" width="24" height="23" border=0>&nbsp;
    
  <label style="width: 23px; height = 24px;"
  OnClick="Cambiar_Simbolo()" 
  OnMouseOver="this.style.cursor='hand';"
  id="label_simbolo" name="label_simbolo" value="-"></label>
  <img 
    OnClick="Observacion()"
    title="Agregar Observacion" OnMOuseOver="this.style.cursor='hand'" src="Ico_Editar_24X24_on.gif" width="23" height="24" border=0>&nbsp;  
  </td>
  
  
</tr>
<tr height="200" align="center">
  <td valign="top" id="td_datos" name="td_datos" colspan = 2></td>
</tr>
</table>
<script language="javascript">

function Datos_Producto(codigo_tmp, numero_nota_de_venta){
    strCargando ="<center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' "
    strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Consultando...espere un momento</b></font><br><br></center>"
    td_datos.innerHTML    = strCargando
    var ajx = new Ajax("muestra_detalle_productos.asp",{
      method:'post', 
      data: 'codigo='+codigo_tmp+'&numero='+numero_nota_de_venta,
      update:$("td_datos"),
      onComplete: function(respuesta){
        //alert(respuesta)
        //codigo.value=""
        cantidad.focus()
      }
    });
    ajx.request();
}
function graba_Producto(cantidad_prod,numero_nota_de_venta){
    if (codigo.value == ""){
      alert ("Falta Ingresar Producto")
    }
    else{
      if (cantidad.value == ""){
        alert ("Debe Ingresar la Cantidad")
      }
      else{
        if(label_simbolo.getAttribute("value") == "-"){
          if(!confirm("Está seguro que desea restar "+cantidad.value+" a la nota de venta")){
            codigo.value    = ""
            cantidad.value  = "" 
            Cambiar_Simbolo()
            return;
          }
          else{
            strCargando ="<center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' "
            strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Consultando...espere un momento</b></font><br><br></center>"
            td_datos.innerHTML    = strCargando
            var ajx = new Ajax("Inserta_productos_nota_de_venta.asp",{
              method:'post', 
              data: 'cant='+eval(cantidad_prod*-1)+'&numero='+numero_nota_de_venta+'&codigo='+codigo.value+'&cliente='+'<%=rut%>',
              update:$("td_datos"),
              onComplete: function(respuesta){
                //alert(respuesta)
                codigo.value=""
                cantidad.value=""
                codigo.focus()
              }
            });
            ajx.request();
            
            //alert (codigo.value)          
          }
          Cambiar_Simbolo()
        }
        else{
          strCargando ="<center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' "
          strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Consultando...espere un momento</b></font><br><br></center>"
          td_datos.innerHTML    = strCargando
          var ajx = new Ajax("Inserta_productos_nota_de_venta.asp",{
            method:'post', 
            data: 'cant='+cantidad_prod+'&numero='+numero_nota_de_venta+'&codigo='+codigo.value+'&cliente='+'<%=rut%>',
            update:$("td_datos"),
            onComplete: function(respuesta){
              //alert(respuesta)
              codigo.value=""
              cantidad.value=""
              codigo.focus()
            }
          });
          ajx.request();
          //alert (codigo.value)
        }
      }
    }
}
function Lista_detalle_orden_de_venta(){
    strCargando ="<center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' "
    strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Consultando...espere un momento</b></font><br><br></center>"
    td_datos.innerHTML    = strCargando
    var ajx = new Ajax("Lista_detalle_Nota_de_venta.asp",{
      method:'post', 
      data: 'codigo='+'<%=numero_nota_de_venta%>',
      update:$("td_datos"),
      onComplete: function(respuesta){
        //alert(respuesta)
        //codigo.value=""
        //codigo.focus()
      }
    });
    ajx.request();
}
function Cierra_orden_de_venta(){
    var x= confirm("¿Está seguro de cerrar la Nota de Venta?");
    if (x==true){
      strCargando ="<center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' "
      strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Consultando...espere un momento</b></font><br><br></center>"
      td_datos.innerHTML    = strCargando
      var ajx = new Ajax("Cierra_nota_de_venta.asp",{
        method:'post', 
        data: 'numero='+'<%=numero_nota_de_venta%>',
        update:$("td_datos"),
        onComplete: function(respuesta){
          //alert(respuesta)
          //codigo.value=""
          //codigo.focus()
        }
        });
      ajx.request();
    }
}
function Volver(){
//history.back();
document.location.href='Nota_de_venta_Inicial.asp'
}

function Imprimir(){
document.location.href='ImprimeBoucher.asp?numero='+'<%=numero_nota_de_venta%>'+'&cliente='+'<%=rut%>';
}

function Cambiar_Simbolo(){
  if(label_simbolo.getAttribute("value") == "+")
  {
    label_simbolo.style.color = "#FF0000"
    label_simbolo.innerHTML   = "<img src='Inv_resta.gif' width='24' height='24' border='0' align='top'>"
    label_simbolo.title       = "Restar"
    label_simbolo.setAttribute("value","-")
  }
  else
  {
    label_simbolo.style.color = "#0000FF"
    label_simbolo.innerHTML   = "<img src='Inv_suma.gif' width='24' height='24' border='0' align='top'>"
    label_simbolo.title       = "Sumar"
    label_simbolo.setAttribute("value","+")
  }
  codigo.focus()
}
//strCargando ="<center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' "
//strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Consultando...espere un momento</b></font><br><br></center>"
//td_datos.innerHTML    = strCargando
//var ajx = new Ajax("ImprimeBoucher.asp",{
//  method:'post', 
//  data: 'numero='+'<%=numero_nota_de_venta%>'+'&cliente='+'<%=cliente%>',
//  update:$("td_datos"),
//  onComplete: function(respuesta){
//    //alert(respuesta)
//    //codigo.value=""
//    //codigo.focus()
//  }
//  });
//ajx.request();
//}

function Observacion(){
  //var winURL		 = "Detalle_DespachosZF.asp?NroInt=" + NroInt + "&OVT=" + OVT + "&cDOC=" + cDOC + "&nDOC=" + nDOC + "&Fecha=" + dFecha;
  var winURL		 = "AgregaObservacion.asp?Numero_nota_de_venta="+'<%=numero_nota_de_venta%>';
	var winName		 = "WndDetalle_DVT";
	var winFeatures  = "status=no, ";
			winFeatures += "resizable=no, ";
			winFeatures += "toolbar=no, ";
			winFeatures += "location=no," ;
			winFeatures += "scrollbars=yes," ;
			winFeatures += "menubar=0," ;
			winFeatures += "width=350," ;
			winFeatures += "height=180," ;
			winFeatures += "top=250," ;
			winFeatures += "left=600" ;
			window.open (winURL,winName,winFeatures,winName)
}
Cambiar_Simbolo()
</script>
</body>
</html>
