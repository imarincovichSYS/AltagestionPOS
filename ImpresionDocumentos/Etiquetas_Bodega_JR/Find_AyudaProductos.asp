<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	Session.LCID = 11274
%>
<%
	Cache
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
	'Vendible = Request("Vendible")
%>
<html>
	<head>
		<!--<title>sfsdfsdsdf</title>-->
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
<table align=center width=100% border=0 cellspacing=0 cellpadding=0>
    <td width=100% class="FuenteTitulosFunciones" align=center nowrap>Impresión de Etiquetas</td>
  </table>
  
<table NOWRAP align=center width=90% border=0 cellspacing=0 cellpadding=0>

<tr>
<td>
<Form name="Form1" method="post" action="List_AyudaProductos2.asp" target="wnd_abajo">
  
	<table align=center width=100% border=0 cellspacing=0 cellpadding=0>
	  <tr>
		  <td>
		  <tr class="FuenteCabeceraTabla">Etiqueta de ejemplo 1
      </td>
		</tr>
  	<tr>
	  	<td>
  			<tr><input type=text name="text1" size=26 maxlength=13 value="MUESTRA" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='MUESTRA') this.value='';" onBlur="if(this.value=='') this.value='MUESTRA';"></tr>
  			<tr readonly><font color=white><%=response.write ("- ")%></font></tr>
  			<tr readonly><font color=white><%=response.write ("- ")%></font></tr>
				<tr><a Class="FuenteEncabezados">Nº etiquetas</a>
        <input class="FuenteEncabezados" type=text value="1" name="cantidad" size=1 maxlength=4>
		    <input class="FuenteEncabezados" type=submit name="Imprimir1" value=IMPRIMIR size=1 maxlength=4>
		    <tr class="FuenteEncabezados">
		    Alinear:
		    <input type=radio name="ajuste" Value="I" checked>Izq.
		    <input type=radio name="ajuste" Value="C">Centrar
		    <input type=hidden value="Etiqueta_1" name="Etiqueta">
		</tr>

	</table>
</Form>
</td>

<td>
<Form name="Form2" method="post" action="List_AyudaProductos2.asp" target="wnd_abajo">
  
	<table align=center width=100% border=0 cellspacing=0 cellpadding=0>
	  <tr>
		  <td>
		  <tr class="FuenteCabeceraTabla">Etiqueta de ejemplo 2
      </td>
		</tr>
  	<tr>
	  	<td>
  			<tr><input type=textbox name="text1" size=26 maxlength=13 value="AUTORIZADO" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='AUTORIZADO') this.value='';" onBlur="if(this.value=='') this.value='AUTORIZADO';"></tr>
				<tr><input type=textbox name="text2" size=26 maxlength=13 value="JEFE DE LINEA" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='JEFE DE LINEA') this.value='';" onBlur="if(this.value=='') this.value='JEFE DE LINEA';"></tr>
      <tr><font color=white><%=response.write (". ")%></font></tr>				
						<tr><a Class="FuenteEncabezados">Nº etiquetas</a>
        <input class="FuenteEncabezados" type=text value="1" name="cantidad" size=1 maxlength=4>
		  <input class="FuenteEncabezados" type=submit name="Imprimir2" value=IMPRIMIR size=1 maxlength=4></tr>
		  <tr class="FuenteEncabezados">
		    Alinear:
		    <input type=radio name="ajuste" Value="I" checked>Izq.
		    <input type=radio name="ajuste" Value="C">Centrar
		  <input type=hidden value="Etiqueta_2" name="Etiqueta">
      </tr>		  
   		</td>
		</tr>
	</table>
</Form>
</td>

<td>
<Form name="Form3" method="post" action="List_AyudaProductos2.asp" target="wnd_abajo">
  
	<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
	  <tr>
		  <td>
		  <tr class="FuenteCabeceraTabla">Etiqueta de ejemplo 3
      </td>
		</tr>
  	<tr>
	  	<td>
  			<tr><input type=textbox name="text1" size=26 maxlength=18 value="SALDO" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='SALDO') this.value='';" onBlur="if(this.value=='') this.value='SALDO';"></tr>
				<tr><input type=textbox name="text2" size=26 maxlength=18 value="$9.999.999" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='$9.999.999') this.value='';" onBlur="if(this.value=='') this.value='$9.999.999';"></tr>
				<tr><input type=textbox name="text3" size=26 maxlength=18 value="CODIGO" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='CODIGO') this.value='';" onBlur="if(this.value=='') this.value='CODIGO';"></tr>
						<tr><a Class="FuenteEncabezados">Nº etiquetas</a>
        <input class="FuenteEncabezados" type=text value="1" name="cantidad" size=1 maxlength=4>
		  <input class="FuenteEncabezados" type=submit name="Imprimir3" value=IMPRIMIR size=1 maxlength=4>
		    <tr class="FuenteEncabezados">
		    Alinear:
		    <input type=radio name="ajuste" Value="I" checked>Izq.
		    <input type=radio name="ajuste" Value="C">Centrar
		  <input type=hidden value="Etiqueta_3" name="Etiqueta">
		</tr>
   		</td>
		</tr>
	</table>
</Form>
</td>


</tr>

</table>

<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
    <td width=100% class="FuenteTitulosFunciones" align=center nowrap></td>
  </table>
  
<table align=center width=92% border=0 cellspacing=0 cellpadding=0>

<tr>
<td>
<Form name="Form4" method="post" action="List_AyudaProductos2.asp" target="wnd_abajo">
  
	<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
	  <tr>
		  <td>
		  <tr class="FuenteCabeceraTabla">Etiqueta de ejemplo 4
      </td>
		</tr>
  	<tr>
	  	<td>
  			<tr><input type=textbox size=26 name="text1" maxlength=17 value="LIQUIDACION" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='LIQUIDACION') this.value='';" onBlur="if(this.value=='') this.value='LIQUIDACION';"></tr>
				<tr><input type=textbox size=26 name="text2" maxlength=17 value="50%" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='50%') this.value='';" onBlur="if(this.value=='') this.value='50%';"></tr>
				<tr><input type=textbox size=26 name="text3" maxlength=25 value="CODIGO" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='CODIGO') this.value='';" onBlur="if(this.value=='') this.value='CODIGO';"></tr>
				<tr><input type=textbox size=26 name="text4" maxlength=25 value="OPCIONAL" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='OPCIONAL') this.value='';" onBlur="if(this.value=='') this.value='OPCIONAL';"></tr>
        <tr readonly><font color=white><%=response.write ("- ")%></font></tr>
        <tr readonly><font color=white><%=response.write ("- ")%></font></tr>        
						<tr><a Class="FuenteEncabezados">Nº etiquetas</a>
        <input class="FuenteEncabezados" type=text value="1" name="cantidad" size=1 maxlength=4>
		  <input class="FuenteEncabezados" type=submit name="Imprimir4" value=IMPRIMIR size=1 maxlength=4>
		    <tr class="FuenteEncabezados">
		    Alinear:
		    <input type=radio name="ajuste" Value="I" checked>Izq.
		    <input type=radio name="ajuste" Value="C">Centrar
		  <input type=hidden value="Etiqueta_4" name="Etiqueta">		  
		</tr>
   		</td>
		</tr>
	</table>
</Form>
</td>

<td>
<Form name="Form5" method="post" action="List_AyudaProductos2.asp" target="wnd_abajo">
  
	<table align=center width=80% border=0 cellspacing=0 cellpadding=0>
	  <tr>
		  <td>
		  <tr class="FuenteCabeceraTabla">Etiqueta de ejemplo 5
      </td>
		</tr>
  	<tr>
	  	<td>
  			<tr><input type=textbox size=26 name="text1" maxlength=17 value="OFERTA" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='OFERTA') this.value='';" onBlur="if(this.value=='') this.value='OFERTA';"></tr>
				<tr><input type=textbox size=26 name="text2" maxlength=17 value="$9.999.999" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='$9.999.999') this.value='';" onBlur="if(this.value=='') this.value='$9.999.999';"></tr>
				<tr><input type=textbox size=26 name="text3" maxlength=17 value="CODIGO" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='CODIGO') this.value='';" onBlur="if(this.value=='') this.value='CODIGO';"></tr>
				<tr><input type=textbox size=26 name="text4" maxlength=17 value="OPCIONAL 1" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='OPCIONAL 1') this.value='';" onBlur="if(this.value=='') this.value='OPCIONAL 1';"></tr>
				<tr><input type=textbox size=26 name="text5" maxlength=17 value="OPCIONAL 2" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='OPCIONAL 2') this.value='';" onBlur="if(this.value=='') this.value='OPCIONAL 2';"></tr>
  			<tr readonly><font color=white><%=response.write ("- ")%></font></tr>
						<tr><a Class="FuenteEncabezados">Nº etiquetas</a>
        <input class="FuenteEncabezados" type=text value="1" name="cantidad" size=1 maxlength=4>
		  <input class="FuenteEncabezados" type=submit name="Imprimir5" value=IMPRIMIR size=1 maxlength=4>
		    <!--<p Class="FuenteEncabezados">Alinear</p>
		    <input type=radio name="ajuste" Value="I" checked>Izq.
		    <input type=radio name="ajuste" Value="C">Centrar-->
		  <input type=hidden value="Etiqueta_5" name="Etiqueta">
		</tr>
   		</td>
		</tr>
	</table>
</Form>
</td>

<td>
<Form name="Form6" method="post" action="List_AyudaProductos2.asp" target="wnd_abajo">
  
	<table align=center width=50% border=0 cellspacing=0 cellpadding=0>
	  <tr>
		  <td>
		  <tr class="FuenteCabeceraTabla">Etiqueta de ejemplo 6
      </td>
		</tr>
  	<tr>
	  	<td>
				<tr><input type=textbox size=34 name="text1" maxlength=30 value="IMPORTADO POR:" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='IMPORTADO POR:') this.value='';" onBlur="if(this.value=='') this.value='IMPORTADO POR:';"></tr>
				<tr><input type=textbox size=34 name="text2" maxlength=30 value="SANCHEZ Y SANCHEZ LTDA." onKeyUp="conMayusculas(this)" onFocus="if(this.value=='SANCHEZ Y SANCHEZ LTDA.') this.value='';" onBlur="if(this.value=='') this.value='SANCHEZ Y SANCHEZ LTDA.';"></tr>
				<tr><input type=textbox size=34 name="text3" maxlength=30 value="RUT: 96.620.660-8" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='RUT: 96.620.660-8') this.value='';" onBlur="if(this.value=='') this.value='RUT: 96.620.660-8';"></tr>
				<tr><input type=textbox size=34 name="text4" maxlength=30 value="CAPELLADA: MATERIAL SINTETICO" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='CAPELLADA: MATERIAL SINTETICO') this.value='';" onBlur="if(this.value=='') this.value='CAPELLADA: MATERIAL SINTETICO';"></tr>
				<tr><input type=textbox size=34 name="text5" maxlength=30 value="FORRO: MATERIAL SINTETICO" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='FORRO: MATERIAL SINTETICO') this.value='';" onBlur="if(this.value=='') this.value='FORRO: MATERIAL SINTETICO';"></tr>
				<tr><input type=textbox size=34 name="text6" maxlength=30 value="PLANTA: PVC" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='PLANTA: PVC') this.value='';" onBlur="if(this.value=='') this.value='PLANTA: PVC';"></tr>
				<tr><input type=textbox size=34 name="text7" maxlength=30 value="HECHO EN CHINA" onKeyUp="conMayusculas(this)" onFocus="if(this.value=='HECHO EN CHINA') this.value='';" onBlur="if(this.value=='') this.value='HECHO EN CHINA';"></tr>
						<tr><a Class="FuenteEncabezados">Nº etiquetas</a>
        <input class="FuenteEncabezados" type=text value="1" name="cantidad" size=1 maxlength=4>
		  <input class="FuenteEncabezados" type=submit name="Imprimir6" value=IMPRIMIR size=1 maxlength=4>
		    <!--<p Class="FuenteEncabezados">Alinear</p>
		    <input type=radio name="ajuste" Value="I" checked>Izq.
		    <input type=radio name="ajuste" Value="C">Centrar-->
		  <input type=hidden value="Etiqueta_6" name="Etiqueta">  
		</tr>
   		</td>
		</tr>
	</table>
</Form>
</td>


</tr>

</table>

<%Conn.close%>

<script language="JavaScript">
	this.window.focus();
  function conMayusculas(field) 
  {
    field.value = field.value.toUpperCase()
  }

</script>
