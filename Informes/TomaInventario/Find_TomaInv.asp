<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
%>

<html>
<script language="javascript"> 
     //acá se carga el arreglo con la tabla de Familias     
     var Familias = new Array(
				<%	Sql = "Exec FAM_ListaFamilias '','','',01"  
                         set rs=conn.execute(sql)
                         total_Familia=0
	               	do while not rs.eof%>
						new Array("<%=trim(rs("Familia"))%>","<%=trim(rs("Superfamilia"))%>","<%=trim(rs("Nombre"))%> (<%=trim(rs("Familia"))%>)" ),
	            <%		rs.movenext
	               	    total_Familia = total_Familia + 1
	               	loop
	               	rs.close()
	               	set rs=nothing
	               	%>
	               		new Array("Ultimo","")
                         );
     
     var SubFamilias = new Array(
				<%	
						Sql = "Exec SBF_ListaSubfamilias '','','','',01"
                         set rs=conn.execute(sql)
                         total_SubFamilia=0
	               	do while not rs.eof%>
						new Array("<%=trim(rs("Subfamilia"))%>","<%=trim(rs("Familia"))%>","<%=trim(rs("Superfamilia"))%>","<%=trim(rs("Nombre"))%> (<%=trim(rs("Subfamilia"))%>)" ),
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
		var SuperFamilia = document.Listado.Slct_SuperFam.options[document.Listado.Slct_SuperFam.selectedIndex].value;
		for (j = document.Listado.Slct_Familia.options.length; j >= 0; j--) 	
		{
			document.Listado.Slct_Familia.options[j] = null; 
		}
		for (j = document.Listado.Slct_SubFamilia.options.length; j >= 0; j--) 	
		{
			document.Listado.Slct_SubFamilia.options[j] = null; 
		}
		if (SuperFamilia.length == 0)
		{
		     return;
		}
		
		j=1
		for (i = 0; i < Familias.length; i++) 
		{
			if (Familias[i][1] == SuperFamilia & Familias[i][1] != '')			
			{
		    	document.Listado.Slct_Familia.options[j] = new Option(Familias[i][2]);
				document.Listado.Slct_Familia.options[j].value = Familias[i][0];				
				if ('<%=trim(Familia)%>' == Familias[i][0]) 
				{
					document.Listado.Slct_Familia.options[j].selected = true;
				}
		    	j++;
			}
		}
	}

	function Carga_SubFamilia( valor )
	{
		var i, j;
		var Familia = document.Listado.Slct_Familia.options[document.Listado.Slct_Familia.selectedIndex].value;
		if (Familia.length == 0)
		{
		     return;
		}
		for (j = document.Listado.Slct_SubFamilia.options.length; j >= 0; j--) 	
		{
			document.Listado.Slct_SubFamilia.options[j] = null; 
		}
			
		j=1
		for (i = 0; i < SubFamilias.length; i++) 
		{
			if (SubFamilias[i][1] == Familia & SubFamilias[i][1] != '')
			{
		    	document.Listado.Slct_SubFamilia.options[j] = new Option(SubFamilias[i][3]);
				document.Listado.Slct_SubFamilia.options[j].value = SubFamilias[i][0]; 
				if ('<%=trim(SubFamilia)%>' == SubFamilias[i][0]) 
				{
					document.Listado.Slct_SubFamilia.options[j].selected  = true;
				}
		    	j++;
			}
		}
	}

    function fAsigna()
    {
		if ( document.Listado.Slct_SubFamilia.options.length != 0 )
		{
			document.Listado.SubFamilia.value					= document.Listado.Slct_SubFamilia.options[document.Listado.Slct_SubFamilia.selectedIndex].value ;
		}
		if ( document.Listado.Slct_Familia.options.length != 0 )
		{
			document.Listado.Familia.value						= document.Listado.Slct_Familia.options[document.Listado.Slct_Familia.selectedIndex].value ;
		}
		if ( document.Listado.Slct_SuperFam.options.length != 0 )
		{
			document.Listado.SuperFamilia.value  				= document.Listado.Slct_SuperFam.options[document.Listado.Slct_SuperFam.selectedIndex].value ;
		}
    }
    
    function fExcluye()
    {
		if ( validEmpty(document.Listado.Slct_SuperFam.value) )
		{
			document.Listado.Excluye.checked = false;
		}
    }
    
</script>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Caracteres.js"></script>
</head>
	<body onload="javascript:placeFocus()" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>

		<Form name="Listado" method="post" action="List_TomaInv.asp" target="Listado">
			<table width=95% align=center border=0 cellspacing=0 cellpadding=0>
				<tr class="FuenteInput">
					<td nowrap class="FuenteEncabezados" width=10% align=left >Bodega</td>
					<td align=left width=20%>
					     <select style="width:150" class="fuenteinput" name="Bodega">
					     <option value="">< Todas ></option>
	                    	     <%Sql = "Exec HAB_ListaBodega '" & session("empresa_usuario") & "'"  
	                    	     SET Rs	=	Conn.Execute( SQL ) %>
	                    	     <%do while not rs.eof%>
	                    	          <option value='<%=trim(rs("Bodega"))%>'><%=rs("Descripcion_breve")%>&nbsp;(<%=trim(rs("Bodega"))%>)</option>
	                    	          <%rs.movenext
	                    	     loop
	                    	     rs.close
	                    	     set rs=nothing%>
					     </select>
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left >
						<a class="FuenteEncabezados" href="JavaScript:ClipBoard( 'Listado', '', 'Producto', 'p');">Producto</a>
					</td>
					<td width=10% align=left>
						<input class=fuenteinput type=text value=''   name ="Producto"  size=20 maxlength=20 >
					</td>

					<td nowrap class="FuenteEncabezados" width=10% align=left ><b>Salida</b></td>
					<td align=left>
						<Select class="FuenteInput" name="Salida">
							<option Selected value="I">Impresora</option>
							<option	value="A">Archivo</option>
						</Select>
					</td>
				</tr>
				
				<tr>
					<td width=10% class="FuenteEncabezados" align=left nowrap>Rubro</td>
					<td width=25% align=left>
						<select class="FuenteInput" name="Slct_SuperFam" style="width:150" onchange="Javascript:Carga_Familia( this.value )" > 
							<option value=""></option>
						<%	cSql = "Exec SPF_ListaSuperfamilias Null, Null, 1"
							Set RsSupFam = Conn.Execute ( cSql )
							Do While Not RsSupFam.Eof%>
								<option <%if Superfamilia = RsSupFam("Superfamilia") then Response.Write " selected " %> value='<%=RsSupFam("Superfamilia")%>'><%=RsSupFam("Nombre")%>&nbsp;(<%=RsSupFam("Superfamilia")%>)</option>
						<%		RsSupFam.MoveNext
							Loop
							RsSupFam.Close%>
							<input type=hidden name="SuperFamilia" value="<%=Superfamilia%>">
						</select>
					</td>

					<td width=10% class="FuenteEncabezados" align=left nowrap>Familia</td>
					<td width=25% align=left>
						<select class="FuenteInput" name="Slct_Familia" style="width:150" onchange="Javascript:Carga_SubFamilia( this.value )" > 
							<option value=""></option>
						</select>
					</td>

					<td width=10% class="FuenteEncabezados" align=left nowrap>SubFamilia</td>
					<td width=25% align=left>
						<select class="FuenteInput" name="Slct_SubFamilia" style="width:150" > 
							<option value=""></option>
						</select>
					</td>

					<td width=10% class="FuenteEncabezados" align=left nowrap>Pre-carga</td>
					<td width=25% align=left>
                        <input class=FuenteInput type=checkbox name="Precarga">
                        <input type=hidden name="hPrecarga" value="N">
					</td>
				</tr>
				
				<input type=hidden name="Accion" value="">
			</table>
		</form>

		<iframe id="Paso" name="Paso" src="../../empty.asp" height=0 width=0></iframe>
	</body>
</html>

<%conn.close()%>
<%else
	Response.Redirect "../../index.htm"
end if%>
