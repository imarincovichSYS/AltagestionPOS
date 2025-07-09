<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
	Vendible = Request("Vendible")
	Proveedor = Request("Proveedor")
%>
<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>

<body OnLoad="placeFocus()"  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">

<script language="javascript"> 
     //acá se carga el arreglo con la tabla de Familias     
     var Familias = new Array(
				<%	Sql = "Exec FAM_ListaFamilias '','','',01"  
                         set rs=conn.execute(sql)
                         total_Familia=0
	               	do while not rs.eof%>
						new Array("<%=trim(rs("Familia"))%>","<%=trim(rs("Superfamilia"))%>","<%=trim(rs("Nombre"))%>" ),
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
						new Array("<%=trim(rs("Subfamilia"))%>","<%=trim(rs("Familia"))%>","<%=trim(rs("Superfamilia"))%>","<%=trim(rs("Nombre"))%>" ),
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
		if (SuperFamilia.length == 0)
		{
		     return;
		}
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
		var Familia = document.FormularioAyuda.Slct_Familia.options[document.FormularioAyuda.Slct_Familia.selectedIndex].value;
		if (Familia.length == 0)
		{
		     return;
		}
		for (j = document.FormularioAyuda.Slct_SubFamilia.options.length; j >= 0; j--) 	
		{
			document.FormularioAyuda.Slct_SubFamilia.options[j] = null; 
		}
			
		j=1
		for (i = 0; i < SubFamilias.length; i++) 
		{
			if (SubFamilias[i][1] == Familia & SubFamilias[i][1] != '')
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
			document.FormularioAyuda.SubFamilia.value					= "";
			document.FormularioAyuda.Familia.value						= "";
			document.FormularioAyuda.SuperFamilia.value  				= "";
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
		document.FormularioAyuda.submit();
    }
    
</script>

<Form name="FormularioAyuda" method="post" action="List_AyudaProductos.asp" target="wnd_abajo">
	<input type=hidden name="Vendible" value="<%=Vendible%>">
	<input type=hidden name="Proveedor" value="<%=Proveedor%>">
	<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
		<tr>
			<td colspan=4 width=100% class="FuenteTitulosFunciones" align=center nowrap>Ayuda de Productos</td>
		</tr>
		<tr>
			<td width=10% class="FuenteEncabezados" align=left nowrap>Código</td>
			<td width=34% align=left>
				<input class=FuenteInput size=20 maxlength=12 type=text name="Codigo" value="">
			</td>

			<td width=10% class="FuenteEncabezados" align=left nowrap>Rubro</td>
			<td width=34% align=left>
				<select class="FuenteInput" name="Slct_SuperFam" style="width:200"  onchange="JavaScript:Carga_Familia(this.value);fAsigna()"> 
					<option value=""></option>
				<%	cSql = "Exec SPF_ListaSuperfamilias Null, Null, 1"
					Set RsSupFam = Conn.Execute ( cSql )
					Do While Not RsSupFam.Eof%>
						<option <%if Superfamilia = RsSupFam("Superfamilia") then Response.Write " selected " %> value='<%=RsSupFam("Superfamilia")%>'><%=RsSupFam("Nombre")%></option>
				<%		RsSupFam.MoveNext
					Loop
					RsSupFam.Close%>
					<input type=hidden name="SuperFamilia" value="<%=Superfamilia%>">
				</select>
			</td>
		</tr>
		
		<tr>
			<td width=10% class="FuenteEncabezados" align=left nowrap >Familia</td>
			<td width=33% align=left>
				<select class="FuenteInput" name="Slct_Familia" style="width:200" onchange="JavaScript:Carga_SubFamilia(this.value);fAsigna()">
					<option value="">&nbsp;</option>
					<%for a=1 to total_Familia%>
						<option value="">&nbsp;</option>
					<%next%>
				</select>
				<input type=hidden name="Familia" value="<%=Familia%>">
			</td>

			<td width=10% class="FuenteEncabezados" align=left nowrap>Sub Familia</td>
			<td width=33% align=left>
				<select class="FuenteInput" name="Slct_SubFamilia" style="width:200" onchange="JavaScript:fAsigna()">
					<option value=""></option>
					<%for b=1 to total_SubFamilia%>
						<option value="">&nbsp;</option>
					<%next%>
				</select>
				<input type=hidden name="SubFamilia" value="<%=SubFamilia%>">
			</td>
		</tr>

		<tr>
			<td width=10% class="FuenteEncabezados" align=left nowrap>Descripción</td>
			<td width=33% colspan=3 align=left>
				<input class="FuenteInput" type=text name="Descripcion" value="<%=Descripcion%>" size=80 maxlength=50>
			</td>
			
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