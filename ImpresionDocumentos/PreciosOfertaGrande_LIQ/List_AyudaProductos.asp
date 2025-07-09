  <!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	Session.LCID = 11274
%>
<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">


<form name="Productos" method="post" action="List_AyudaProductos2.asp" target="wnd_abajo">
<%
	Const adUseClient = 3
	Dim conn1
	conn1 = Session("DataConn_ConnectionString")

	if Len(trim(Request("Vendible"))) > 0 then
		Vendible = "'" & Request("Vendible") & "'"
	else
		Vendible = "Null"
	end if
		
	SuperFamilia	= Request("SuperFamilia")
	Familia			= Request("Familia")
	SubFamilia		= Request("SubFamilia")
	Descripcion		= Request("Descripcion")
	Bodega         = Request("Bodega")
	Proveedor      = Request("Proveedor")
	Productos_Certificados = Request("Productos_Certificados")
	Productos_Certificados = "N"
	Producto = Request("producto")
	Guia = Request("guia")
	nprecio = Request("nprecio")
   
	  cSql = "Exec PRO_Lista_Imprime_Precios_LIQ '" & SuperFamilia & "', '" & Familia & "', '" & SubFamilia & "', '" & Descripcion & "', '" & NULL & "', '" & NULL & "', '" & "', '" & NULL & "', '" & NULL & "', '" & Bodega & "', '" & Proveedor & "', '" & Productos_Certificados & "','" & Producto & "',0" & Guia & ",0" & nprecio 

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
			pagecnt = rs.PageCount%>

	<!--<%Paginacion_Ayuda abspage,pagecnt,rs.PageSize%> no muestra 1/2 por ej.-->
	<%	Dim fldF, intRec %>
	<% Bodega = Mid(Bodega, 6, len(Bodega)) %>
	<table width=60% border=1 align=center  cellspacing=0><thead>
		<tr class="FuenteCabeceraTabla">
		<td align=left width=5%><b>Imp.</b></td>
		<td align=left width=5%><b>Cant.</b></td>
		<!--<td align=left><b>Fecha</b></td>-->
		<td align=left><b>Producto</b></td>
		<td align=left><b>Verde</b></td>
		<td align=left><b>Rojo</b></td>    		
		<td align=center width=50%><b> <%=date()%> </b></td>
	  <!--<td align=center><b> <%=Bodega%></b></td>-->
	   <!--<td align=center><b> Stock </b></td>-->
	  <td align=center width=10%><b> P.Vta </b></td>
	  <td align=left width=20%><b>Prov</b></td>
	  <td align=left width=20%><b>P. Prom</b></td>
		</tr>
<%		i = 1
		'For intRec=1 To rs.PageSize
		do while Not Rs.eof
		  Response.flush
			if Not Rs.eof then
      imprime = ""
		  cantidad_a_imprimir = 1
		  fleje = "Checked"
		  gancho = ""
		  oferta = ""
			if nprecio <> "" then
        imprime = "checked"
        if Isnull(rs("CP_Cantidad")) then
          cantidad_a_imprimir = 1
        else
          cantidad_a_imprimir = rs("CP_Cantidad")
        end if
        if rs("CP_fleje_o_gancho") = "Gancho" then
          Fleje = ""
          Gancho = "checked"
        end if
        if rs("CP_Oferta") = "on" then
          oferta = "Checked"
        end if
      end if
      if guia<>"" then
        imprime = "checked"
      end if%>
			<tr>
			  <td>
			  <input class=FuenteInput type=checkbox name="Ajuste_<%=i%>" width=5% <%=imprime%>>
			  </td>
				<td class=FuenteEncabezados align=left width=5%>
					<a><input class=DatoInPut type=text value=<%=cantidad_a_imprimir%> name="cant_<%=i%>" size=2 maxlength=2 onchange="validarSiNumero(this.value);"></a>
				</td>			  
        <td align=left>
					<strong><input  class=FuenteEncabezados type=text readonly value="<%=trim(Rs("Codigo_producto"))%>" name="Producto_<%=i%>" size="10"></strong>
				</td>
        <td>
			  <input class=FuenteInput type=Radio name="fleje_<%=i%>" width=5% value=Verde <%=Fleje%>>
			  </td>
			  <td>
			  <input class=FuenteInput type=Radio name="fleje_<%=i%>" width=5% Value=Rojo <%=Gancho%> checked>
			  </td>							
				<td class="FuenteInput" width=45%>					
					<input type=text class=FuenteEncabezados readonly value="<%=Rs("Descripcion")%>" name="Desc_<%=i%>" size="50" align="left">
				</td>				
        <td class="FuenteInput" align=right width=5%>
					<input type=text class=FuenteEncabezados readonly value="<%=formatNumber(Rs("Pvta"),0)%>" name="precio_<%=i%>" >
				</td>
				<td class="FuenteInput" align=left width=5%>
					<a><input type=text class=FuenteEncabezados value="<%=Rs("Prov")%>" name="Prov_<%=i%>" readonly></a>
				</td>

					<input type=hidden value="<%=formatNumber(Rs("Unidad_de_medida_venta_peso_en_grs"),0)%>" name="grs_<%=i%>" >

  			
					<input type=hidden value="<%=formatNumber(Rs("Unidad_de_medida_venta_volumen_en_cc"),0)%>" name="cc_<%=i%>" >
  				<input type=hidden value="<%=Rs("Codigo_Ean13")%>" name="Codigo_Ean13_<%=i%>" >
  				

    		<td class="FuenteInput" align=left width=5%>
			  <input class=FuenteEncabezados  width=5% value="<%=Rs("pprom")%>" name="Prom_<%=i%>" readonly>
			  </td>          
		</tr>			
<%			Rs.MoveNext
			End if
			i = i + 1
		Loop
		rs.Close
		Set rs = Nothing
		i=i-1
		%>
			<td colspan=7 class="FuenteTitulosFunciones" align=center>
				<input class="FuenteEncabezados" type=button name="Imprime" value=" IMPRIMIR " OnClick="JavaScript:fBuscar()">
			</td>
    		<td>
			  <input class=FuenteInput type = hidden name="lineas" width=5% value="<%=i%>">
			  </td>



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
</body>
</html>

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

    function fBuscar()
    {
/*		var Error = "N"
		var Descripcion = LTrim(RTrim(document.Productos.Descripcion.value));

		if( validEmpty(document.Productos.Slct_SuperFam.value) &&
			validEmpty(document.Productos.Slct_Familia.value) &&
			validEmpty(document.Productos.Slct_SubFamilia.value) &&
			validEmpty(document.Productos.Descripcion.value))
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
		{*/
			document.Productos.submit();
		//}
    }
  function validarSiNumero(numero)
  {
    if (!/^([0-9])*$/.test(numero))
      alert("El valor " + numero + " no es un número");
  }
  
  

</script>


