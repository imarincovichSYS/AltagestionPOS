<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if

	responsable = session("login")
	if	len(trim(request("Fiscal_actual"))) > 0 then
  	session("Fiscal_actual") = request("Fiscal_actual")
	else
	  session("Fiscal_actual") = 99
	end if

	Fiscal_actual = session("Fiscal_actual")

	if request("Login_punto_venta") <> "" then
  	Session("Login_punto_venta") = request("Login_punto_venta")
		session("Nombre_usuario_boleta") = Session("Login_punto_venta")
  end if
 
  Const adUseClient = 3


	Dim conn1

   cSql = "Select	top 15 z.fecha,accion = case when accion = 'A' then 'Apertura' when accion='Z' then 'Cierre' else '' end " &_
   				" ,b.Descripcion_breve bodega,e.Nombres_persona + ' ' + e.Apellidos_persona_o_nombre_empresa Colaborador ,z.numero_impresora_fiscal caja " &_
					"from		Zbitacora_AperturayCierre_de_Periodo z with(nolock) " &_
					"inner join	entidades_comerciales e with(nolock) on e.Entidad_comercial = z.responsable " &_
					"inner join	Bodegas b with(nolock) on b.Bodega = z.centro_de_venta " &_
					" where		z.responsable = '" &responsable& "' " &_
					" order by	fecha desc "
			'Response.Write (sql)

		conn1 = Session("DataConn_ConnectionString")
				
		Set rs = Server.CreateObject("ADODB.Recordset")
		
		rs.PageSize = Session("PageSize")
		rs.CacheSize = 3
		rs.CursorLocation = adUseClient

		rs.Open cSql , conn1, , , adCmdText 'mejor
		
		ResultadoRegistros=rs.RecordCount

%>

<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
		<script src="../../js/jquery-1.7.2.min.js" type="text/javascript"></script>
		<script src="../../js/json2.js" type="text/javascript"></script>
	</head>

<body OnLoad="placeFocus()"  bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center>&nbsp;&nbsp;&nbsp;&nbsp;<%=session("title")%></td>
			</tr>
		</table>

	

		<table align=center width=95% border=0 cellspacing=0 cellpadding=0>
			<tr class="FuenteEncabezados">
				<td width=30% class="FuenteEncabezados" align=center>
					<input class="FuenteEncabezados" type=button name="btnCierrePeriodo" id="btnCierrePeriodo" value="Cierre Período Venta (Z)" OnClick="javascript:fManejo('Z')">
				</td>

				

				<td width=30% class="FuenteEncabezados" align=center>
					<input class="FuenteEncabezados" type=button name="btnApertura" id="btnApertura" value="Apertura de periodo" OnClick="javascript:fManejo('A')">
				</td>

				<td width=30% class="FuenteEncabezados" align=center>
					<img src="../../Imagenes/page-loader.gif" id="cargando-paridad" width="240" height="240"  ></img>
				</td>
				

			</tr>
      
		</table>
	

	<table width="95%" border=1 align=center cellpadding=0 cellspacing=0 >
		<tr>
			<td>Fecha</td>
			<td>Colaborador</td>
			<td>Accion</td>
			<td>Local</td>	
			<td align="right">Caja</td>			
		</tr>
			<%
				'response.write cSql
				'response.end								
        'set rs = Conn.Execute(cSql)
       	do while not rs.EOF
			%>
			<tr>
				<td><%= rs("fecha")%></td>
				<td><%= rs("Colaborador")%></td>
				<td><%= rs("accion")%></td>
				<td><%= rs("bodega")%></td>
				<td align="right"><%= rs("caja")%></td>				
			</tr>
			<%
					rs.MoveNext
        	loop
        rs.close
			%>
		

	</table>

	<iframe id="Paso" name="Paso" src="../../empty.asp" height=0 width=0></iframe>

	<script language="javascript">
		///parent.Mensajes.location.href = "../../Mensajes.asp";
	   
	  var session_login = "<%=session("LOGIN")%>"

	  $(document).ready(function() {
    	$('#cargando-paridad').hide();
		});
		function fManejo( valor )
		{
		  if (valor == 1 && session_login == "")
      {
         alert ("se ha perdido la sesión del sistema. Por favor ingrese nuevamente") 
         location.href = "../../index1.asp";
         return;
      }
      $('#cargando-paridad').show();
      $.ajax({    
        	type:"GET",
        	url:"grabarManejoImpresoraTermica.asp?accion=" + valor,    
        	success:function(data, textStatus, xhr){ 
        		$('#cargando-paridad').hide();
        		//json = JSON.parse(data)
        		parent.Trabajo.location.href = "Mant_IF.asp";
        		
        }, 
        error:function(e){
        	$('#cargando-paridad').hide();
            return;
        }
    	}); 
			//Paso.location.href = "Manejo_IF.asp?Manejo=" + valor + "&Fiscal_actual=" + <%=Fiscal_actual%>;
		}	   
		
	</script>
  </body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
