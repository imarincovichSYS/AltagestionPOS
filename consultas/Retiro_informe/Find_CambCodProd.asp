<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
%>
<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<script src="../../Scripts/Js/Fechas.js"></script>
	<script src="../../Scripts/Js/Caracteres.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
</head>
<script language="javascript"> 


     //acá se carga el arreglo con la tabla de cuentas
     cuentas = new Array(
				<%
	               	Sql = "Exec CCB_ListaCuentasBancarias '',''"  
                         set rs=conn.execute(sql)
                         hay=0
	               	do while not rs.eof%>
	               	     new Array("<%=rs("banco")%>","<%=rs("Cuenta_bancaria")%>","<%=trim(rs("moneda"))%>" ),
	               	     <%rs.movenext
	               	     hay=1
	               	loop
	               	rs.close()
	               	set rs=nothing %>
	               	     new Array("Ultimo","")
                         );
     
     function cargar_cuenta(selectCtrl, valor)
     {
     
		
          //rescatar la  moneda
          var cadena=valor;
          pos=cadena.indexOf("@");
          moneda=cadena.substring(pos+1,valor.length);
          if (moneda.length==0)
          {
			   
               return;
          }

          //borrar combo
          var i, j;
          for (i = selectCtrl.options.length; i >= 0; i--) 	
          {
          	selectCtrl.options[i] = null; 
          }
                 
          j=1
	     for (i = 0; i < cuentas.length; i++) 
	     {
	     	if (cuentas[i][2] == moneda & cuentas[i][2] != '') //si el pais de la tabla estados_o_regiones es igual al pais de la tabla ciudades_o_comunas,
	     	                                   //entonces se agrega en el combo
	     	{
     	     	selectCtrl.options[j] = new Option(cuentas[i][0]);
 
	     		selectCtrl.options[j].text	= cuentas[i][0] + ' (' + cuentas[i][1] + ')'; 
	     		if (moneda == cuentas[i][0]) 
	     		{
	     		     selectCtrl.options[j].selected=true;
	     		}
     	     	j++;
	     	}
	     }
	     

}
</script>

<%if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
%>

<!--	<body onload="javascript:placeFocus();document.Formulario.submit();cargar_cuenta(document.Formulario.CuentaBanco,'$')" leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">-->
	<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>
		<Form name="Formulario" method="post" action="List_CambCodProd.asp" target="Listado">
			<table width=89% align=center border=0 cellspacing=0 cellpadding=0>
				
				<tr CLASS=FuenteEncabezados cellspacing=10%>
         <td  nowrap class="FuenteEncabezados" align=left class="FuenteEncabezados">Fecha&nbsp;&nbsp;&nbsp;
						<input Class="FuenteInput" type=Text align=left name="Fecha_inicial" size=7 maxlength=10 value="<%=date()%>" qonKeyUp="DateFormat(this,this.value,event,false,'3')" onBlur="DateFormat(this,this.value,event,true,'3')" ><a href="javascript:show_calendar('Formulario.Fecha_inicial');" onmouseover="window.status='Calendario';return true;" onmouseout="window.status='';return true;"><img CLASS="TextoColorNegro" src="../../Imagenes/show-calendar.gif" width=24 height=22 border=0 align=top></a>
					</td>
					<td align=left>
					</td>
				</tr>    

					
          <tr>
          	<td nowrap class="FuenteEncabezados" width=10% align=left ><b></b></td>


					 </td>
					</tr>
					
			</table>
		
</form>
</body>

<%conn.close()%>
<%else
	Response.Redirect "../../index.htm"
end if%>

</html>
