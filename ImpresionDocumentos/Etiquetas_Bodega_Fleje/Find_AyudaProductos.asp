<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
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

<body OnLoad="placeFocus()"  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

<script language="javascript"> 
     var Familias = new Array(
				<%	Sql = "Exec FAM_ListaFamilias '','','',01"
                         set rs=conn.execute(sql)
                         total_Familia=0
	               	do while not rs.eof%>
						new Array("<%=trim(rs("Familia"))%>","<%=trim(rs("Superfamilia"))%>","<%=ucase(trim(rs("Familia")))%>" ),
	            <%		rs.movenext
	               	    total_Familia = total_Familia + 1
	               	loop
	               	rs.close()
	               	set rs=nothing
	               	%>
	               		new Array("Ultimo","")
                         );
     
     var SubFamilias = new Array(
				<%	Sql = "Exec SBF_ListaSubfamilias '','','','',01"
                         set rs=conn.execute(sql)
                         total_SubFamilia=0
	               	do while not rs.eof%>
						new Array("<%=trim(rs("Subfamilia"))%>","<%=trim(rs("Familia"))%>","<%=trim(rs("Superfamilia"))%>","<%=ucase(trim(rs("SubFamilia")))%>" ),
	            <%		rs.movenext
	               	    total_SubFamilia = total_SubFamilia + 1
	               	loop
	               	rs.close()
	               	set rs=nothing
	               	%>
	               		new Array("Ultimo","")
                         );

    function Carga_Familia( valor )
    {
		var i, j;
		var SuperFamilia = document.FormularioAyuda.Slct_SuperFam.options[document.FormularioAyuda.Slct_SuperFam.selectedIndex].value;
/*		if (SuperFamilia.length == 0)
		{
		     return;
		}
*/
		for (j = document.FormularioAyuda.Slct_Familia.options.length; j >= 0; j--) 	
		{
			document.FormularioAyuda.Slct_Familia.options[j] = null; 
		}
		for (j = document.FormularioAyuda.Slct_SubFamilia.options.length; j >= 0; j--) 	
		{
			document.FormularioAyuda.Slct_SubFamilia.options[j] = null; 
		}
		
		j=1
		for (i = 0; i < Familias.length; i++) 
		{
			if (Familias[i][1] == SuperFamilia & Familias[i][1] != '')			
			{
		    	document.FormularioAyuda.Slct_Familia.options[j] = new Option(Familias[i][2]);
				document.FormularioAyuda.Slct_Familia.options[j].value = Familias[i][0];				
				if ('<%=trim(Familia)%>' == Familias[i][0]) 
				{
					document.FormularioAyuda.Slct_Familia.options[j].selected = true;
				}
		    	j++;
			}
		}
	}

	function Carga_SubFamilia( valor )
	{
		var i, j;
		var SuperFamilia = document.FormularioAyuda.Slct_SuperFam.options[document.FormularioAyuda.Slct_SuperFam.selectedIndex].value;
		var Familia = document.FormularioAyuda.Slct_Familia.options[document.FormularioAyuda.Slct_Familia.selectedIndex].value;
		for (j = document.FormularioAyuda.Slct_SubFamilia.options.length; j >= 0; j--) 	
		{
			document.FormularioAyuda.Slct_SubFamilia.options[j] = null; 
		}
			
		j=1
		for (i = 0; i < SubFamilias.length; i++) 
		{
			if (SubFamilias[i][1] == Familia && SubFamilias[i][2] == SuperFamilia && SubFamilias[i][1] != '' )
			{
		    	document.FormularioAyuda.Slct_SubFamilia.options[j] = new Option(SubFamilias[i][3]);
				document.FormularioAyuda.Slct_SubFamilia.options[j].value = SubFamilias[i][0]; 
				if ('<%=trim(SubFamilia)%>' == SubFamilias[i][0]) 
				{
					document.FormularioAyuda.Slct_SubFamilia.options[j].selected  = true;
				}
		    	j++;
			}
		}
	}

    function fAsigna()
    {
		document.FormularioAyuda.SubFamilia.value	= ""
		document.FormularioAyuda.Familia.value		= ""
		document.FormularioAyuda.SuperFamilia.value  = ""

		if ( document.FormularioAyuda.Slct_SubFamilia.options.length != 0 )
		{
			document.FormularioAyuda.SubFamilia.value					= document.FormularioAyuda.Slct_SubFamilia.options[document.FormularioAyuda.Slct_SubFamilia.selectedIndex].value ;
		}
		if ( document.FormularioAyuda.Slct_Familia.options.length != 0 )
		{
			document.FormularioAyuda.Familia.value						= document.FormularioAyuda.Slct_Familia.options[document.FormularioAyuda.Slct_Familia.selectedIndex].value ;
		}
		if ( document.FormularioAyuda.Slct_SuperFam.options.length != 0 )
		{
			document.FormularioAyuda.SuperFamilia.value  				= document.FormularioAyuda.Slct_SuperFam.options[document.FormularioAyuda.Slct_SuperFam.selectedIndex].value ;
		}
    }
    
    function fBuscar()
    {
		var Error = "N"
		var Descripcion = LTrim(RTrim(document.FormularioAyuda.Descripcion.value));

		if( validEmpty(document.FormularioAyuda.Slct_SuperFam.value) &&
			validEmpty(document.FormularioAyuda.Slct_Familia.value) &&
			validEmpty(document.FormularioAyuda.Slct_SubFamilia.value) &&
			validEmpty(document.FormularioAyuda.Descripcion.value) &&
      validEmpty(document.FormularioAyuda.producto.value) && 
      validEmpty(document.FormularioAyuda.guia.value) &&
      validEmpty(document.FormularioAyuda.nprecio.value))
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
					alert('La descripción debe contener al menos 2 caractéres.');
				}
			}
		}

		if ( Error == "N" ) 
		{
			document.FormularioAyuda.submit();
		}
    }
    
</script>

<Form name="FormularioAyuda" method="post" action="List_AyudaProductos.asp" target="wnd_abajo">
	<input type=hidden name="Vendible" value="<%=Vendible%>">
	<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
		<tr>
			<td colspan=4 width=100% class="FuenteTitulosFunciones" align=center nowrap>Imprime Etiquetas Bodega Fleje</td>
		</tr>
		
		<tr>
    		
    <tr>
		  <td width=10% class="FuenteEncabezados" align=left nowrap>Producto</td>
		  <td>  <input class="FuenteInput" type=text name="producto" value="<%=producto%>" size=9 maxlength=9> </td>
		  
		  <td class="FuenteEncabezados" align=left nowrap>Doc. Compra</td>
		  <td>
        <select Class="FuenteInput" style="width:40" name="Bodega">
		          <option value="R">R</option>
							<option value="Z">Z</option>
							<option value="TU">TU</option>	
						</select>

        <select class="fuenteinput" name="periodo">
							<%for i=year(date)-5 to year(date)%>
								<option <%if i = year(date()) then Response.write("selected ") end if %>value="<%=i%>"><%=i%></option>
							<%next%>
						</select>
			
      <a Class="FuenteEncabezados">Nº</a><input class="FuenteEncabezados" type=text name="nprecio" value="<%=nprecio%>" size=9 maxlength=9>
			
          
          
					 <input Class="FuenteInput" type=radio name="Mostrar_TCP_o_RCP" value="TCP" ><a Class="FuenteEncabezados">TCP</a>
					 	<input Class="FuenteInput" type=radio name="Mostrar_TCP_o_RCP" value="RCP" checked><a Class="FuenteEncabezados">RCP</a>
					 	
					 	
					
					
			
      </td>
		</tr>
		
		
		
        <!--cbutendieck------------------------------------------------------------------------------------------>
        
			<td width=10% class="FuenteEncabezados" align=left nowrap>Rubro</td>
			<td width=34% align=left>
				<select class="FuenteInput" name="Slct_SuperFam" style="width:200"  onchange="JavaScript:fAsigna()"> 
					<option value=""></option>
				<%	cSql = "Exec SPF_ListaSuperfamilias Null, Null, 1"
					Set RsSupFam = Conn.Execute ( cSql )
					Do While Not RsSupFam.Eof%>
						<option value='<%=RsSupFam("Superfamilia")%>'><%=RsSupFam("Superfamilia")%></option>
				<%		RsSupFam.MoveNext
					Loop
					RsSupFam.Close%>
					<input type=hidden name="SuperFamilia" value="<%=Superfamilia%>">
				</select>
			</td>

			<td width=10% class="FuenteEncabezados" align=left nowrap>Familia</td>
			<td width=34% align=left>
				<select class="FuenteInput" name="Slct_Familia" style="width:200"  onchange="JavaScript:fAsigna()"> 
					<option value=""></option>
				<%	cSql = "Exec FAM_ListaFamilias Null, Null, Null, 1, 'S'"
					Set RsFam = Conn.Execute ( cSql )
					Do While Not RsFam.Eof%>
						<option value='<%=RsFam("Familia")%>'><%=RsFam("Familia")%></option>
				<%		RsFam.MoveNext
					Loop
					RsFam.Close%>
					<input type=hidden name="Familia" value="<%=Familia%>">
				</select>
			</td>
      </tr>
      
     <tr>
		 <td width=10% class="FuenteEncabezados" align=left nowrap>SubFamilia</td>
			<td width=34% align=left>
				<select class="FuenteInput" name="Slct_SubFamilia" style="width:200"  onchange="JavaScript:fAsigna()"> 
					<option value=""></option>
				<%	cSql = "Exec SBF_ListaSubFamilias Null, Null, Null, Null, 1, 'S'"
					Set RsSbFam = Conn.Execute ( cSql )
					Do While Not RsSbFam.Eof%>
						<option value='<%=RsSbFam("SubFamilia")%>'><%=RsSbFam("SubFamilia")%></option>
				<%		RsSbFam.MoveNext
					Loop
					RsSbFam.Close%>
					<input type=hidden name="SubFamilia" value="<%=SubFamilia%>">
				</select>
			</td>

		  <td width=10% class="FuenteEncabezados" align=left nowrap>Num.Guía</td>
		  <td>  <input class="FuenteInput" type=text name="guia" value="<%=guia%>" size=9 maxlength=9> 
      </td>

<!--
		 <td width=10% class="FuenteEncabezados" align=left nowrap>Proveedor</td>
			<td width=34% align=left>
				<select class="FuenteInput" name="Proveedor" style="width:200"> 
					<option value=""></option>
				<%	cSql = "Exec ECP_ListaProveedores_inv Null, Null, Null, 1, Null"
					Set RsProveedor = Conn.Execute ( cSql )
					Do While Not RsProveedor.Eof%>
						<option value='<%=RsProveedor("entidad_comercial")%>'><%=RsProveedor("Codigo_postal")%></option>
				<%		RsProveedor.MoveNext
					Loop
					RsProveedor.Close%>
					<!-- <input type=hidden name="Proveedor" value="<%=Codigo_Postal%>"> 
				</select>
			</td>
-->
      </tr>
<!--      
<td nowrap class="FuenteEncabezados" width=10% align=left >Bodega&nbsp;</td>
					<td align=left>
						 <select Class="FuenteInput" style="width:150" name="Bodega">
							<option value="0010-BM7">BM7</option>
							<option value="0011-Manzana 7" selected>Manzana 7</option>	
							<option value="0001-Bod">Bod</option>
							<option value="0002-Jug">Jug</option>
							<option value="0003-Ona">Ona</option>
							<option value="0004-L146">L146</option>
							<option value="0005-L27">L27</option>
							<option value="0006-ST">ST</option>
							<option value="0007-Mue">Mue</option>
							<option value="0008-L238">L238</option>
							<option value="0009-L26">L26</option>
						</select>
					</td>
-->
			<td width=10% class="FuenteEncabezados" align=left nowrap>Descripción</td>
			<td width=33% colspan=3 align=left>
				<!-- <input class="FuenteInput" type=text name="Descripcion" value="<%=Descripcion%>" size=80 maxlength=50> -->
				<input class="FuenteInput" type=text name="Descripcion" value="<%=Descripcion%>" size=50 maxlength=50>
			</td>
			
		<!--cbutendieck------------------------------------------------------------------------------------------>
					
			<td class="FuenteTitulosFunciones" align=center>
				<input class="FuenteEncabezados" type=button name="Buscar" value=" Buscar " OnClick="JavaScript:fBuscar()">
			</td>
		</tr>

	</table>
</Form>

<%Conn.close%>

<script language="JavaScript">
	this.window.focus();
</script>
