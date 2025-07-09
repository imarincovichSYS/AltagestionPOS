<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"
	Session("CodigoProducto") = Request ("Codigo_pais")
	Session("NombreProducto") = Request ("Nombre_pais")
	Session("Orden")		  = Request ("Orden")

	Codigo				= Request ("Codigo_pais") 'Codigo Producto
	Nombre				= Request ("Nombre_pais") 'Nombre Producto
	Orden				= Request ("Orden") 

	if len(trim(Orden)) = 0 then
		Orden = 1
	end if

  Const adUseClient = 3
  Dim conn1

  Sql = "Exec MOP_Consulta_producto " +_
   		  "'0011'," +_
   		  "'0011'," +_
          "'10027765'," +_
          "'SYS'," +_		  
          "'"  & codigo & "'," +_
		  "'10027765', "  & 1
  on error resume next
	conn1 = Session("DataConn_ConnectionString")
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.PageSize = Session("PageSize")
	rs.CacheSize = 3
	rs.CursorLocation = adUseClient

	rs.Open sql , conn1, , , adCmdText 'mejor
		
	if err <> 0 then
    Response.Write "<b><center><font color='#990000'>" & Ucase(Right(trim(err.Description),18)) & "</font></center></b>"
	  Response.End
	end if
	ResultadoRegistros = rs.RecordCount
	if cdbl(rs("Precio_venta_de_lista_1")) < 1000 then
		tam_fuente 	= "400"
		fuente 			= "Impact"
		left_precio = 90
		top_precio 	= 300
		left_desc   = 80
		top_desc 	  = 740
    lef_codigo  = 300
    top_codigo  = 860
	elseif cdbl(rs("Precio_venta_de_lista_1")) >= 1000 and cdbl(rs("Precio_venta_de_lista_1")) < 9999 then
		tam_fuente 	= "290"
		fuente 			= "Impact"
		left_precio = 90
		top_precio 	= 350
		left_desc   = 80
		top_desc 	  = 740
    lef_codigo  = 300
    top_codigo  = 860 
  elseif cdbl(rs("Precio_venta_de_lista_1")) >= 10000 and cdbl(rs("Precio_venta_de_lista_1")) < 99999 then
  	tam_fuente 	= "245"
		fuente 			= "Impact"
		left_precio = 75
		top_precio 	= 400
		left_desc   = 80
		top_desc 	  = 740
    lef_codigo  = 300
    top_codigo  = 860
  elseif cdbl(rs("Precio_venta_de_lista_1")) >= 100000 then
  	tam_fuente 	= "200"
		fuente 			= "Impact"
		left_precio = 75
		top_precio 	= 410
		left_desc   = 80
		top_desc 	  = 740
    lef_codigo  = 300
    top_codigo  = 860      
	end if	
%>
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
    <style type="text/css">
<!--
#Layer10 { 
	position:absolute;
	width:662px;
	height:27px;
	z-index:10;
	left: <%=left_desc%>px;
	top: <%=top_desc%>px;
}
#Layer16 {
	position:absolute;
	width:97px;
	height:13px;
	z-index:16;
	left: <%=lef_codigo%>px;
	top: <%=top_codigo%>px;
}
#Layer31 {
	position:absolute;
	width:29px;
	height:22px;
	z-index:17;
	left: <%=left_precio%>px;
	top: <%=top_precio%>px;
}
.Estilo1 {font-size: <%=tam_fuente%>px;
		  font-family: <%=fuente%>;
		  }
.Estilo6 {font-size: 45px; 
		  font-weight: bold;
		  font-family: Arial;}

.Estilo4 {font-size: 35px;
		  font-weight: bold; 
		  font-family: verdana;}

-->
    </style>
</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>">
<form name="Listado">
  <p>&nbsp;</p>
	<p>&nbsp;</p>    
  <p>&nbsp;</p>
	<p>&nbsp;</p>
  <div class="Estilo6" id="Layer10"><%=rs("Nombre")%></div>
	<p>&nbsp;</p>
  <div class="Estilo4" id="Layer16"><%=UCase(rs("producto"))%></div>
  <div class="Estilo1" id="Layer31"><%=replace(formatNumber(UCase(rs("Precio_venta_de_lista_1")),0),",",".")%></div>
  <p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
	<p>&nbsp;</p>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p>&nbsp;</p>
  <p>
<%End If
rs.Close
Set rs = Nothing
%>
</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</form>
</body>
</html>
