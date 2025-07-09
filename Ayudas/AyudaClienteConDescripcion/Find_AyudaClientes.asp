<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
	Vendible = Request("Vendible")
%>
<html>
	<head>
		<title>Ayuda de Clientes</title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<body OnLoad="placeFocus()"  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

<script language="javascript"> 
    
     function fNuevo()
     {
		var hora = new Date() ;
		vHours  = hora.getHours() ;
		vMinute = hora.getMinutes() ;
		vSecond = hora.getSeconds() ;
		hora    = "H" + vHours + "" + vMinute + "" + vSecond ;
		
		var winURL  = "../../Mantenciones/EntidadesComerciales/Win_NuevoCliente.asp?hora="+hora;
		var winName = "NuevoCliente" ;

		var winFeatures  = "status=no," ; 
		    winFeatures += "resizable=no," ;
			winFeatures += "toolbar=no," ;
			winFeatures += "location=no," ;
			winFeatures += "scrollbars=yes," ;
			winFeatures += "menubar=0," ;
			winFeatures += "target=top," ;
			winFeatures += "width=790," ;
			winFeatures += "height=270," ;
			winFeatures += "top=200," ;
			winFeatures += "left=0" ;

		var wclcl = window.open( winURL, winName, winFeatures ) ;
	          wclcl.opener = self;
		
     }

    function fBuscar()
    {
		var Error = "N"
		var Descripcion = LTrim(RTrim(document.FormularioAyuda.Nombre.value));
		
		if ( validEmpty(document.FormularioAyuda.Codigo.value) && validEmpty(Descripcion) )
		{
			Error = "S"
			alert('Debe ingresar al menos un criterio de busqueda');
		}
		else
		{
			if ( ! validEmpty(Descripcion) )
			{
				if ( Descripcion.length < 2 )
				{
					Error = "S"
					alert('El Apellido persona o nombre empresa debe contener al menos 2 caractéres.');
				}
			}
		}	

		if ( Error == "N" ) 
		{
			document.FormularioAyuda.submit();
		}
    }
    
</script>

<Form name="FormularioAyuda" method="post" action="List_AyudaClientes.asp?tipo=<%=request("tipo")%>" target="wnd_abajo">
	<input type=hidden name="Vendible" value="<%=Vendible%>">
	<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
		<tr>
			<td colspan=4 width=100% class="FuenteTitulosFunciones" align=center nowrap>Ayuda de Clientes</td>
		</tr>
		<tr>
			<td class="FuenteEncabezados" width=10% align=left ><b>Código</b></td>
			<td align=left>
				<input Class="FuenteInput" type=Text name="Codigo" size=13 maxlength=12 value='' aonblur="javascript:validaCaractesPassWord(this.value , this)">
			</td>
			<td class="FuenteInput" align=center>
				<input class="FuenteEncabezados" size= 10 type=button name="Nuevo" value="  Nuevo " OnClick="JavaScript:fNuevo()">
			</td>
		</tr>
		<tr>
			<td nowrap class="FuenteEncabezados" width=10% align=left >Apellido persona o nombre empresa</td>
			<td  align=left >
				<input Class="FuenteInput" type=Text name="Nombre" size="50" maxlength=50 value="" aonblur="javascript:validaCaractesPassWord(this.value , this)">
			</td>
		
			<td class="FuenteInput" align=center>
				<input class="FuenteEncabezados" size= 10 type=button name="Buscar" value=" Buscar " OnClick="JavaScript:fBuscar()">
			</td>
		</tr>
	</table>
</Form>

<%Conn.close%>

<script language="JavaScript">
	this.window.focus();
</script>