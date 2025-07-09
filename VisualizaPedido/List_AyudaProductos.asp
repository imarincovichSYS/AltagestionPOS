<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../_private/config.asp" -->
<%
	Cache
%>
<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">


<form name="Productos" method="post" action="List_AyudaProductos2.asp" target="wnd_abajo">
	<Textarea ID="holdtext" STYLE="display:none;"></Textarea>

	<script language="JavaScript">	
		function fProductos(cCod, id)
		{	
		//	window.opener.document.bgColor = "beige";
			var Unidad = "Unidad" + id;
			var Nombre = "Nombre" + id;
			var Codigo = "Codigo" + id;
			var CodProdProv = "CodProdProv" + id;
			document.FormularioPaso.CodigoProducto.value	= eval("document.Productos." + Codigo + ".value");
			document.FormularioPaso.NombreProducto.value	= eval("document.Productos." + Nombre + ".value");
			document.FormularioPaso.UnidadProducto.value	= eval("document.Productos." + Unidad + ".value");
			document.FormularioPaso.CodProdProv.value		= eval("document.Productos." + CodProdProv + ".value");
		
				
			document.FormularioPaso.submit();
		}

	</script>
<%
	Const adUseClient = 3
	Dim conn1
	conn1 = Session("DataConn_ConnectionString")

	if Len(trim(Request("Vendible"))) > 0 then
		Vendible = "'" & Request("Vendible") & "'"
	else
		Vendible = "Null"
	end if

OpenConn

function Get_Fecha_Ultima_Compra_X_Producto(x_producto)
  strSQL="select Fecha_ultimos_costos from productos where empresa = 'SYS' and producto = '"&x_producto&"'"
  set v_rs = Conn.Execute(strSQL) : v_fecha_ultima_compra = ""
  if not v_rs.EOF then v_fecha_ultima_compra = v_rs("Fecha_ultimos_costos")
  Get_Fecha_Ultima_Compra_X_Producto = v_fecha_ultima_compra
end function

	SuperFamilia	= Request("SuperFamilia")
	Familia			= Request("Familia")
	SubFamilia		= Request("SubFamilia")
	Descripcion		= Request("Descripcion")
	Bodega         = Request("Bodega")
	Proveedor      = Request("Proveedor")
	Productos_Certificados = Request("Productos_Certificados")
	Productos_Certificados = "N"
   
	cSql = "Exec Mop_Pedido '" & SuperFamilia & "', '" & Familia & "', '" & SubFamilia & "', '" & Descripcion & "', '" & NULL & "', '" & NULL & "', '" & "', '" & NULL & "', '" & NULL & "', '" & Bodega & "', '" & Proveedor & "', '" & Productos_Certificados & "'"
	

'Response.Write cSql
'	Set Rs = Conn.Execute ( cSql )

	Set rs = Server.CreateObject("ADODB.Recordset")
	
	rs.PageSize = 10000 'Session("PageSize")
	rs.CacheSize = 3
	rs.CursorLocation = adUseClient
	rs.Open cSql , conn1, , , adCmdText 'mejor


	If Not Rs.eof then
		If Len(Request("pagenum")) = 0  Then
			rs.AbsolutePage = 1
		Else
			If CInt(Request("pagenum")) <= rs.PageCount Then
					rs.AbsolutePage = Request("pagenum")
				Else
					rs.AbsolutePage = 1
			End If
		End If
		
		Dim abspage, pagecnt
			abspage = rs.AbsolutePage
			pagecnt = rs.PageCount
			total_filas = rs.RecordCount
      %>
<script language=javascript>
	function PrimeraPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?SuperFamilia=<%=request("SuperFamilia")%>&Familia=<%=request("Familia")%>&SubFamilia=<%=request("SubFamilia")%>&Descripcion=" +escape('<%=request("Descripcion")%>') + "&pagenum=1";//'Primera Página
	}

	function repag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?SuperFamilia=<%=request("SuperFamilia")%>&Familia=<%=request("Familia")%>&SubFamilia=<%=request("SubFamilia")%>&Descripcion=" +escape('<%=request("Descripcion")%>') + "&pagenum=<%=abspage - 1%>";//'Página anterior
	}

	function avpag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?SuperFamilia=<%=request("SuperFamilia")%>&Familia=<%=request("Familia")%>&SubFamilia=<%=request("SubFamilia")%>&Descripcion=" +escape('<%=request("Descripcion")%>') + "&pagenum=<%=abspage + 1%>";//'Página anterior
	}
					
	function UltimaPag()
	{
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?SuperFamilia=<%=request("SuperFamilia")%>&Familia=<%=request("Familia")%>&SubFamilia=<%=request("SubFamilia")%>&Descripcion=" +escape('<%=request("Descripcion")%>') + "&pagenum=<%=0+pagecnt%>";//'Última Página
	}

</script>
	<!--<%Paginacion_Ayuda abspage,pagecnt,rs.PageSize%> no muestra 1/2 por ej.-->
	<%	Dim fldF, intRec %>
	<% Bodega = Mid(Bodega, 6, len(Bodega)) %>
	
	<% If (session("LOGIN") = "13971354" Or session("LOGIN") = "15311785" Or session("LOGIN") = "9817604" Or session("LOGIN") = "16363292" Or session("LOGIN") = "15309580" Or session("LOGIN") = "15208878" Or session("LOGIN") = "16964222" Or session("LOGIN") = "15287501" Or session("LOGIN") = "17956696" Or session("LOGIN") = "8184925" Or session("LOGIN") = "10218204" Or session("LOGIN") = "8563474" Or session("LOGIN") = "15580664" Or session("LOGIN") = "16353547" Or session("LOGIN") = "7001569" Or session("LOGIN") = "15905169" Or session("LOGIN") = "8563607" Or session("LOGIN") = "16964103" ) Then %>
	
	<table width="96%" border=1 rules=rows align=center cellpadding=0 cellspacing=0><thead>
		<tr class="FuenteCabeceraTabla">
		<td align=Center style="width:100px;"><b>Prov</b></td>
		<td class="" align=center style="width:100px;"><b>Producto</b></td>
		<td class="" align=center style="width:200px;"><b>Ru Fa Sub</b></td>
		<td class="" align=center style="width:200px;"><b>Fecha Ult C.</b></td>
		<td class="" align=Center style="width:1000px;"><b>Descripcion</b></td>
		<td class="" align=center style="width:140px;"><b>Temp</b></td>
		<td class="" align=center style="width:80px;"><b>CC</b></td>
		<td class="" align=center style="width:80px;"><b>Bm7</b></td>
		<td class="" align=center style="width:80px;"><b>Sm7</b></td>
		<td class="" align=center style="width:80px;"><b>Stk.O.B</b></td>
		<td class="" align=center style="width:100px;"><b>Tot</b></td>
		<td class="" align=center style="width:70px;"><b>PVta </b></td>  
		<td class="" align=center style="width:70px;"><b>Mg</b></td>
		<td class="" align=center style="width:90px;"><b>Stk.Min</b></td>
		<td class="" align=center style="width:90px;"><b>Stk.JL</b></td>
		<td class="" align=center style="width:60px;"><b>GPre</b></td>
  		<td class="" align=center style="width:70px;"><b>VU10</b></td>
		<td class="" align=center style="width:70px;"><b>VU2</b></td>
		<td class="" align=center style="width:90px;"><b>Pedido</b></td>
		<td class="" align=center style="width:70px;"><b>Días</b></td>
		<td class="" align=center style="width:70px;"><b>Pedir</b></td>	  
		</tr>
<%		i = 1
		For intRec=1 To rs.PageSize
			if Not Rs.eof then
			  fecha_ultima_compra = Get_Fecha_Ultima_Compra_X_Producto(trim(Rs("Producto")))
			  %>
			
				<%if  Rs("GPre") >0 then%>	
	         <tr align=Center bgcolor="#DDDDDD" nowrap>
        <%else%>
			   <tr align=Center>
			  <%end if%>
		
		<td class="FuenteInput" align=center style="width:100px;">
				<a><DIV ID="Prov<%=i%>" value="Prov<%=i%>"><%=Rs("Prov")%></DIV></a> <!-- Proveedor-->
		</td>
				
	      
		<td class="FuenteInput" align=center style="width:100px;">
				<input type=Text readonly name="Producto<%=i%>" value="<%=Rs("Producto")%>"> <!--Producto-->
		</td>
        
		<td class="FuenteInput" align=center style="width:200px;">
				<%=rs("Superfamilia")&" "%> <%=rs("Familia")&" "%> <%=rs("Subfamilia")&" "%> <!-- Ru Fa Sub-->
		</td>
		
		<td class="FuenteInput"align=Center style="width:200px;">  <!-- Fecha Ult. C-->
				<a><DIV ID="Fecha_Ultima_Compra<%=i%>" value="Fecha_Ultima_Compra<%=i%>"><%=fecha_ultima_compra%></DIV></a>
		</td>
        
        <td class="FuenteInput"align=Left style="width:800px;">
				<a><DIV ID="Descripcion<%=i%>" value="Descripcion<%=i%>"><%=Rs("Descripcion")%></DIV></a> <!--Descripción-->
		</td>
				
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="temporada<%=i%>" value="temporada<%=i%>"><%=Rs("temporada")%></DIV></a> <!--Temp-->
		</td>
				
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="CC<%=i%>" value="CC<%=i%>"><%=formatNumber(Rs("CC"), 0)%></DIV></a> <!--CC-->
		</td>
		
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="BM7<%=i%>" value="BM7<%=i%>"><%=formatNumber(Rs("Bm7"), 0)%></DIV></a> <!--BM7-->
		</td>
				
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="SM7<%=i%>" value="SM7<%=i%>"><%=formatNumber(Rs("Sm7"), 0)%></DIV></a> <!--SM7-->
		</td>
				
		<td class="FuenteInput"align=center style="width:50px;"><%=rs("StkOB")%></td> <!-- Stk. Otras Bod.-->
		
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="Tot<%=i%>" value="Tot<%=i%>"><%=formatNumber(Rs("Tot"), 0)%></DIV></a>  <!--Tot-->
		</td>
								
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="Precio<%=i%>" value="Precio<%=i%>"><%=formatNumber(Rs("Pvta"), 0)%></DIV></a> <!-- PVta -->
		</td> 
		
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="Mg<%=i%>" value="Mg<%=i%>"><%=formatNumber(Rs("Mg"), 2)%></DIV></a>  <!--<Mg> -->
		</td>
		
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="StockMin<%=i%>" value="StockMin<%=i%>"><%=formatNumber(Rs("Stkmin"), 0)%></DIV></a>  <!--<Stk.Min> -->
		</td>
		
		<td class="FuenteInput"align=center style="width:50px;"> <%=rs("StkJL")%></td> <!-- Stk. JL-->
		

		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="GPre<%=i%>" value="GPre<%=i%>"><%=Rs("GPre")%></DIV></a> <!--GPre-->
		</td>
		
		<td class="FuenteInput"align=center style="width:50px;"><%=rs("VU10")%></td> <!--<VU10> -->

		<td class="FuenteInput"align=center style="width:50px;"><%=rs("VU10")%></td> <!--<VU2> -->

		<td class="FuenteInput" align=center style="width:50px;">   <!--<Pedido> -->
		      <input 
            <%if i<rs.RecordCount then%>
              OnKeyPress="if(event.keyCode==13)document.Productos.pedido_<%=(cdbl(i)+1)%>.focus();"
            <%else%>
              OnKeyPress="if(event.keyCode==13)document.Productos.Imprime.focus();"
            <%end if%> 
            type=Text id="pedido_<%=i%>" name="pedido_<%=i%>" value="<%=Rs("Pedido")%>" size=2 OnFocus="select()" OnBlur="JavaScript:ValidaCantidadPedida(this,'<%=Rs("Bm7")%>','<%=i%>','<%=Rs("GPre")%>')">
        </td>					

		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="counter<%=i%>" value="counter<%=i%>"><%=formatNumber(Rs("counter"), 0)%></DIV></a>  <!--<Días> -->
		</td>
		
		<td style="width:50px;">			
			   <input class=FuenteInput type=checkbox id="check_<%=i%>" name="check_<%=i%>" width=5% OnClick="JavaScript:ValidaCantidadPedidaclick(this,'<%=Rs("Bm7")%>','<%=i%>','<%=Rs("GPre")%>')">  <!--<Pedir> -->
	  </td>        	
			</tr>
<%			Rs.MoveNext
        i = i + 1
			End if
			
		Next%>
			
			<%else%>

<table width="96%" border=1 rules=rows align=center cellpadding=0 cellspacing=0><thead>
		<tr class="FuenteCabeceraTabla">
		<td align=Center style="width:100px;"><b>Prov</b></td>
		<td class="" align=center style="width:100px;"><b>Producto</b></td>
		<td class="" align=center style="width:200px;"><b>Ru Fa Sub</b></td>
		<td class="" align=center style="width:200px;"><b>Fecha Ult C.</b></td>
		<td class="" align=Center style="width:1000px;"><b>Descripcion</b></td>
		<td class="" align=center style="width:140px;"><b>Temp</b></td>
		<td class="" align=center style="width:80px;"><b>CC</b></td>
		<td class="" align=center style="width:80px;"><b>Bm7</b></td>
		<td class="" align=center style="width:80px;"><b>Sm7</b></td>
		<td class="" align=center style="width:80px;"><b>Stk.O.B</b></td>
		<td class="" align=center style="width:100px;"><b>Tot</b></td>
		<td class="" align=center style="width:70px;"><b>PVta </b></td>  
		<td class="" align=center style="width:90px;"><b>Stk.Min</b></td>
		<td class="" align=center style="width:90px;"><b>Stk.JL</b></td>
		<td class="" align=center style="width:60px;"><b>GPre</b></td>
  		<td class="" align=center style="width:70px;"><b>VU10</b></td>
		<td class="" align=center style="width:70px;"><b>VU2</b></td>
		<td class="" align=center style="width:90px;"><b>Pedido</b></td>
		<td class="" align=center style="width:70px;"><b>Días</b></td>
		<td class="" align=center style="width:70px;"><b>Pedir</b></td>	  
		</tr>
<%		i = 1
		For intRec=1 To rs.PageSize
			if Not Rs.eof then
			  fecha_ultima_compra = Get_Fecha_Ultima_Compra_X_Producto(trim(Rs("Producto")))
			  %>
			
				<%if  Rs("GPre") >0 then%>	
	         <tr align=Center bgcolor="#DDDDDD" nowrap>
        <%else%>
			   <tr align=Center>
			  <%end if%>
		
		<td class="FuenteInput" align=center style="width:100px;">
				<a><DIV ID="Prov<%=i%>" value="Prov<%=i%>"><%=Rs("Prov")%></DIV></a> <!-- Proveedor-->
		</td>
				
	      
		<td class="FuenteInput" align=center style="width:100px;">
				<input type=Text readonly name="Producto<%=i%>" value="<%=Rs("Producto")%>"> <!--Producto-->
		</td>
        
		<td class="FuenteInput" align=center style="width:200px;">
				<%=rs("Superfamilia")&" "%> <%=rs("Familia")&" "%> <%=rs("Subfamilia")&" "%> <!-- Ru Fa Sub-->
		</td>
		
		<td class="FuenteInput"align=Center style="width:200px;">  <!-- Fecha Ult. C-->
				<a><DIV ID="Fecha_Ultima_Compra<%=i%>" value="Fecha_Ultima_Compra<%=i%>"><%=fecha_ultima_compra%></DIV></a>
		</td>
        
        <td class="FuenteInput"align=Left style="width:800px;">
				<a><DIV ID="Descripcion<%=i%>" value="Descripcion<%=i%>"><%=Rs("Descripcion")%></DIV></a> <!--Descripción-->
		</td>
				
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="temporada<%=i%>" value="temporada<%=i%>"><%=Rs("temporada")%></DIV></a> <!--Temp-->
		</td>
				
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="CC<%=i%>" value="CC<%=i%>"><%=formatNumber(Rs("CC"), 0)%></DIV></a> <!--CC-->
		</td>
		
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="BM7<%=i%>" value="BM7<%=i%>"><%=formatNumber(Rs("Bm7"), 0)%></DIV></a> <!--BM7-->
		</td>
				
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="SM7<%=i%>" value="SM7<%=i%>"><%=formatNumber(Rs("Sm7"), 0)%></DIV></a> <!--SM7-->
		</td>
				
		<td class="FuenteInput"align=center style="width:50px;"><%=rs("StkOB")%></td> <!-- Stk. Otras Bod.-->
		
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="Tot<%=i%>" value="Tot<%=i%>"><%=formatNumber(Rs("Tot"), 0)%></DIV></a>  <!--Tot-->
		</td>
								
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="Precio<%=i%>" value="Precio<%=i%>"><%=formatNumber(Rs("Pvta"), 0)%></DIV></a> <!-- PVta -->
		</td> 
		
		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="StockMin<%=i%>" value="StockMin<%=i%>"><%=formatNumber(Rs("Stkmin"), 0)%></DIV></a>  <!--<Stk.Min> -->
		</td>
		
		<td class="FuenteInput"align=center style="width:50px;"> <%=rs("StkJL")%></td> <!-- Stk. JL-->
		

		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="GPre<%=i%>" value="GPre<%=i%>"><%=Rs("GPre")%></DIV></a> <!--GPre-->
		</td>
		
		<td class="FuenteInput"align=center style="width:50px;"><%=rs("VU10")%></td> <!--<VU10> -->

		<td class="FuenteInput"align=center style="width:50px;"><%=rs("VU10")%></td> <!--<VU2> -->

		<td class="FuenteInput" align=center style="width:50px;">   <!--<Pedido> -->
		      <input 
            <%if i<rs.RecordCount then%>
              OnKeyPress="if(event.keyCode==13)document.Productos.pedido_<%=(cdbl(i)+1)%>.focus();"
            <%else%>
              OnKeyPress="if(event.keyCode==13)document.Productos.Imprime.focus();"
            <%end if%> 
            type=Text id="pedido_<%=i%>" name="pedido_<%=i%>" value="<%=Rs("Pedido")%>" size=2 OnFocus="select()" OnBlur="JavaScript:ValidaCantidadPedida(this,'<%=Rs("Bm7")%>','<%=i%>','<%=Rs("GPre")%>')">
        </td>					

		<td class="FuenteInput"align=center style="width:50px;">
				<a><DIV ID="counter<%=i%>" value="counter<%=i%>"><%=formatNumber(Rs("counter"), 0)%></DIV></a>  <!--<Días> -->
		</td>
		
		<td style="width:50px;">			
			   <input class=FuenteInput type=checkbox id="check_<%=i%>" name="check_<%=i%>" width=5% OnClick="JavaScript:ValidaCantidadPedidaclick(this,'<%=Rs("Bm7")%>','<%=i%>','<%=Rs("GPre")%>')">  <!--<Pedir> -->
	  </td>        	
			</tr>
<%			Rs.MoveNext
        i = i + 1
			End if
			
		Next%>
	<%End IF%>
			<table width="96%" border=0 align=center cellpadding=0 cellspacing=0><thead>
		<tr>
		  <td  colspan=2 align="Left">Productos Mal Abast. = <%=i-1%></td>
		 <!-- <td>&nbsp;</td> -->
			
			
			<td colspan=4 align=Center>
			<label for="ped">Solicitado por: </label> 
		    <input type=Text name="pedido_por" value="" >
		  </td> 
		  
		    <td colspan=3 align=Left> 
			<label for="ped">Numero </label> 
		    <input type=Text name="numero_ped" value="0" size=2>
		  </td>
      <td colspan=11 class="FuenteTitulosFunciones" align=Left>
  			<input colspa	 class="FuenteEncabezados" type=button id="Imprime" name="Imprime" value=" Generar Pedido " OnClick="JavaScript:fBuscar()">
  		</td>
    </tr><%
		rs.Close
		Set rs = Nothing
		%>
		    <td>
			  <input class=FuenteInput type = hidden name="lineas" width=5% value="<%=i%>">
			  </td>	
		</table>
	</table>
<%	else%>
		<table width=100% border=0>
			<tr>
				<td class="FuenteEncabezados">
					No hay productos según el criterio especificado.
				</td>
			</tr>
		</table>
<%	end if%>
</form>
<form name="FormularioPaso" action="PintaProducto.asp" target="Paso">
	<input type=hidden name="CodigoProducto"	value="">
	<input type=hidden name="NombreProducto"	value="">
	<input type=hidden name="UnidadProducto"	value="">
	<input type=hidden name="CodProdProv"		value="">
	<input type=hidden name="ID"				value="">
</form>
</body>
</html>

<script language=javascript>
var total_filas = "<%=total_filas%>"
function fBuscar()
{
  v_band = false
  for (i=1; i<=total_filas; i++)
  {
    if(eval("document.Productos.check_"+i).checked)
    {
      v_band = true;
      break;
    }
    /*else
    {
      alert("No existe producto seleccionado")
      break;
    }*/
  }
  if (!v_band)
  {
    alert("No existe producto seleccionado")
  } 
  if (document.Productos.pedido_por.value=='')
  {
     v_band = false;
     alert("Debe ingresar el responsable del pedido")
  }
  if (document.Productos.numero_ped.value=='')
  {
     v_band = false;
     alert("Debe ingresar numero del pedido")
  }   
  if(v_band)
    document.Productos.submit();
}
function ValidaCantidadPedida(v_id_object, v_cantidad_bodega, v_linea, v_cantidad_en_pre)
{
  x_cantidad_bodega    = parseInt(v_cantidad_bodega)
  x_valor_pedido       = parseInt(v_id_object.value)
  x_cantidad_en_pre    = parseInt(v_cantidad_en_pre)
    
  if(x_valor_pedido>x_cantidad_bodega)
  {
    alert("Cantidad pedida es mayor a la existencia de Bodega")
    v_id_object.focus()
  }
  else if (x_valor_pedido + x_cantidad_en_pre > x_cantidad_bodega)
  {
    alert("Cantidad en Bodega Insuficiente")
    v_id_object.focus()
  }
}  

function ValidaCantidadPedidaclick(v_id_object,v_cantidad_bodega, v_linea, v_cantidad_en_pre)
{
  pedido = "document.Productos.pedido_"+v_linea+".value"
  x_cantidad_bodega    = parseInt(v_cantidad_bodega);
  x_cantidad_en_pre    = parseInt(v_cantidad_en_pre); 
  if (parseInt(eval(pedido)) + x_cantidad_en_pre > x_cantidad_bodega)
  {
    alert("Cantidad en Bodega Insuficiente")
    v_id_object.checked = false    
  } 
}  
   
</script>
