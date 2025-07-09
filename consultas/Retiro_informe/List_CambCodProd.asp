<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"


  Monto_retiro = request("monto_retiro")
  Fecha_solicitada_informe = month(request("fecha_inicial")) & "-" & day(request("fecha_inicial")) & "-" & year(request("fecha_inicial"))
  
	if len(trim(Orden)) = 0 then
		Orden = 1
	end if

  session("Fiscal_actual") = request("Fiscal_actual")

Const adUseClient = 3

'response.write (request("monto_retiro"))
'Response.Write (session("fiscal_actual"))
'response.write (request("Fiscal_actual"))

Dim conn1

   Sql = "select *, nombre_cajero = substring(IsNull((select top 1 Apellidos_persona_o_nombre_empresa + ' ' + Nombres_persona from entidades_comerciales where entidad_comercial = Retiros_cajas.rut_cajero), 'S/rut'), 1,28) from Retiros_cajas where day(fecha)=day('" & Fecha_solicitada_informe & "') AND month(fecha)=month('" & Fecha_solicitada_informe & "') and year(fecha)=year('" & Fecha_solicitada_informe & "')"

'Response.Write (session("fiscal_actual"))
'Response.end

		conn1 = Session("DataConn_ConnectionString")
				
		Set rs = Server.CreateObject("ADODB.Recordset")
		
		rs.PageSize = Session("PageSize")
		rs.CacheSize = 3
		rs.CursorLocation = adUseClient

		rs.Open sql , conn1, , , adCmdText 'mejor

		ResultadoRegistros=rs.RecordCount
		
		'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
		'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
		conn3 = Session("DataConn_ConnectionString")
		Set rs_3 = Server.CreateObject("ADODB.Recordset")
		
		Sql_3 = "if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[_informe_retiros]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table [dbo].[_informe_retiros]" & +_
            "CREATE TABLE [_informe_retiros] (" & +_
	          "[id] [int] IDENTITY (1, 1) NOT NULL ," & +_
	          "[fecha] [datetime] NOT NULL ," & +_
	          "[impresora] [smallint] NOT NULL ," & +_
	          "[rut_cajero] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ," & +_
	          "[monto_retiro] [int] NULL ," & +_
	          "[Obs] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ," & +_
	          "[Medio] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ," & +_
	          "CONSTRAINT [PK__informe_retiros] PRIMARY KEY  CLUSTERED " & +_
	          "(" & +_
		        "[id]," & +_
		        "[fecha]," & +_
		        "[impresora]," & +_
		        "[rut_cajero]" & +_
	          ")  ON [PRIMARY] " & +_
            ") ON [PRIMARY]" +_
            " select Q_retiros = IsNull(max(num_retiro),1) from Retiros_cajas where day(fecha)=day('" & Fecha_solicitada_informe & "') and month(fecha)=month('" & Fecha_solicitada_informe & "') and year(fecha)=year('" & Fecha_solicitada_informe & "') "
		rs_3.Open sql_3 , conn3, , , adCmdText 'mejor

		j = rs_3("Q_retiros")
		k = rs_3("Q_retiros")
  	conn2 = Session("DataConn_ConnectionString")
		Set rs_1 = Server.CreateObject("ADODB.Recordset")
		for i=1 to j
		Sql_1 = " Declare @i smallint, @j smallint " & +_
            " select @j = 1 " & +_
            " select @i = IsNull(max(num_retiro),1) from Retiros_cajas where day(fecha)=day('" & Fecha_solicitada_informe & "') and month(fecha)=month('" & Fecha_solicitada_informe & "') and year(fecha)=year('" & Fecha_solicitada_informe & "') " & +_
            " alter table _informe_retiros add [RETIRO " & i & "] int"
		rs_1.Open sql_1 , conn2, , , adCmdText 'mejor
		next
		
		
	 	conn4 = Session("DataConn_ConnectionString")
		Set rs_4 = Server.CreateObject("ADODB.Recordset")
		Sql_4 = "insert	into _informe_retiros " & +_
            "select convert(datetime, convert(varchar, max(fecha), 112))," & +_ 
	          "impresora," & +_ 
	          "rut_cajero," & +_
	          "sum(monto_retiro)," & +_
	          "NULL," & +_
	          "NULL,"
    
    for i=1 to j-1
    Sql_5 =  Sql_5 & "(select IsNull(sum([monto_retiro]),0) from retiros_cajas where rut_cajero = A.rut_cajero and impresora = A.impresora and num_retiro = " & i & " and day(fecha)=day('" & Fecha_solicitada_informe & "') and month(fecha)=month('" & Fecha_solicitada_informe & "') and year(fecha)=year('" & Fecha_solicitada_informe & "')),"          
    next	 
    
    Sql_6 = "(select IsNull(sum([monto_retiro]),0) from retiros_cajas where rut_cajero = A.rut_cajero and impresora = A.impresora and num_retiro = " & j & " and day(fecha)=day('" & Fecha_solicitada_informe & "') and month(fecha)=month('" & Fecha_solicitada_informe & "') and year(fecha)=year('" & Fecha_solicitada_informe & "')) " & +_
            "from retiros_cajas A " & +_
            "where day(A.fecha)=day('" & Fecha_solicitada_informe & "') and month(fecha)=month('" & Fecha_solicitada_informe & "') and year(A.fecha)=year('" & Fecha_solicitada_informe & "') " & +_
            "group by rut_cajero, impresora"
  
    Sql_4 = Sql_4 & Sql_5 & Sql_6        

		rs_4.Open sql_4 , conn4, , , adCmdText 'mejor


  	conn7 = Session("DataConn_ConnectionString")
		Set rs_7 = Server.CreateObject("ADODB.Recordset")
		Sql_7 = "select *, nombre_cajero = substring(IsNull((select top 1 Apellidos_persona_o_nombre_empresa + ' ' + Nombres_persona from entidades_comerciales where entidad_comercial = _informe_retiros.rut_cajero), 'S/rut'), 1,28) from _informe_retiros where day(fecha)=day('" & Fecha_solicitada_informe & "') AND MONTH(fecha)=MONTH('" & Fecha_solicitada_informe & "') and year(fecha)=year('" & Fecha_solicitada_informe & "') order by nombre_cajero"
		rs_7.Open sql_7 , conn7, , , adCmdText 'mejor
    
    salir="false"
    If Not rs_7.EOF Then
      salir = "true"
    end If
    
    conn9 = Session("DataConn_ConnectionString")
		Set rs_9 = Server.CreateObject("ADODB.Recordset")
		Sql_9 = "select Total = sum(monto_retiro),"

		for i=1 to k-1
    Sql_9 =  Sql_9 & "[Retiro " & i & "]=sum([Retiro " & i & "]),"          
    next	 
    
    Sql_10 = " [Retiro " & k & "]=sum([Retiro " & k & "])" & +_
             " from _informe_retiros " & +_
             " where day(fecha)=day('" & Fecha_solicitada_informe & "') and month(fecha)=month('" & Fecha_solicitada_informe & "') and year(fecha)=year('" & Fecha_solicitada_informe & "')"
             
    Sql_11 = Sql_9 & Sql_10
     
		rs_9.Open sql_11 , conn9, , , adCmdText 'mejor
		If Not rs_9.EOF Then
      Total = rs_9("total")
    end If
		
    'response.write rs_9("total")
    'response.end
		'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
		'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
%>

<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Caracteres.js"></script>
</head>

<%	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	else%>
		<script language="JavaScript">
			function Mensajes( valor )
			{
				with (parent.top.frames[3].document.IdMensaje.document)
				{
				  open();
				  write(valor);
				  close();
				}
			}
		</script>
<%	end if%>

<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>">
<form name="frm_mantencion" target="Trabajo" method="post" action="Save_Empresas.asp" target="Listado">
		<input type=hidden name="Orden" value="<%=Orden%>">
		<input type=hidden name="monto_retiro" value="<%=request("monto_retiro")%>">
<%		
		If Not rs.EOF and salir="true" Then
			If Len(Request("pagenum")) = 0  Then
					rs.AbsolutePage = 1
					monto_retiro = rs("monto_retiro")
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
<!--
	Se definen las funciones para el avance de página y para el retroceso de página
-->		
<script language=javascript>
	function PrimeraPag()
	{
		parent.top.frames[2].document.Eliminar.pagenum.value = 1;
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = 1;
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=request("Empresa")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&Orden=<%=Orden%>&pagenum=1&switch=<%=Request("Switch")%>";//'Primera Página
	}

	function repag()
	{
		parent.top.frames[2].document.Eliminar.pagenum.value = <%=abspage-1%>;
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = <%=abspage-1%>;
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=request("Empresa")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&Orden=<%=Orden%>&pagenum=<%=abspage - 1%>&switch=<%=Request("Switch")%>";//'Página anterior
	}

	function avpag()
	{
		parent.top.frames[2].document.Eliminar.pagenum.value = <%=abspage+1%>;
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = <%=abspage+1%>;
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=request("Empresa")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&Orden=<%=Orden%>&pagenum=<%=abspage + 1%>&switch=<%=Request("Switch")%>";//'Página anterior
	}
					
	function UltimaPag()
	{
		parent.top.frames[2].document.Eliminar.pagenum.value = <%=0+pagecnt%>;
		parent.top.frames[2].document.Formulario_Botones.pagenum.value = <%=0+pagecnt%>;
		location.href="<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=request("Empresa")%>&Nombre=" +escape('<%=request("Nombre")%>') + "&Orden=<%=Orden%>&pagenum=<%=0+pagecnt%>&switch=<%=Request("Switch")%>";//'Última Página
	}

	function MantencionUpdate( valor )
	{	
		parent.top.frames[2].location.href = "BotonesMantencion_Empresas.asp?Orden=<%=Orden%>";
		parent.top.frames[2].document.Formulario_Botones.Empresa.value	= valor;
		parent.top.frames[2].document.Formulario_Botones.Nombre.value	= "";
		parent.top.frames[2].document.Formulario_Botones.Nuevo.value		= "N";		
   		parent.top.frames[2].document.Formulario_Botones.pagenum.value		= '<%=abspage%>';
   		parent.top.frames[2].document.Formulario_Botones.Orden.value		= '<%=Orden%>';
		parent.top.frames[2].document.Formulario_Botones.submit();
	}	
</script>

		<%'Paginacion abspage,pagecnt,rs.PageSize
    %>

			<%	Dim fldF, intRec %>
				<table width="90%" border=1 align=left cellpadding=3 cellspacing=0><thead>
				 <caption align=left class="FuenteEncabezados"><font size=2>Fecha: <%=request("fecha_inicial")%></font></caption>
					<tr class="FuenteCabeceraTabla">
						<!--<td width= "20%" align=left   NOWRAP >&nbsp;<a class="FuenteCabeceraLink" OnMouseMove="JavaScript:Limpia_BarraEstado()" Onfocus="JavaScript:Limpia_BarraEstado()" href='<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=Codigo%>&Nombre=<%=Nombre%>&Orden=1&pagenum=<%=Request("pagenum")%>'>Código</a>&nbsp;&nbsp;<% If Orden = 1 Then Response.Write Session("Simbolo")%></td>
						<td width= "30%" align=left   NOWRAP >&nbsp;<a class="FuenteCabeceraLink" OnMouseMove="JavaScript:Limpia_BarraEstado()" Onfocus="JavaScript:Limpia_BarraEstado()" href='<%=Request.ServerVariables("SCRIPT_NAME")%>?Empresa=<%=Codigo%>&Nombre=<%=Nombre%>&Orden=2&pagenum=<%=Request("pagenum")%>'>Nombre</a>&nbsp;&nbsp;<% If Orden = 2 Then Response.Write Session("Simbolo")%></td>-->
						<td width= "5%"	 align=left  >&nbsp;Nº</td>
						<td width= "8%"	 align=left  >&nbsp;Rut</td>
						<td width= "40%"	 align=left  >&nbsp;Nombre Cajero(a)</td>
						<% for i=1 to j-1 %>
						<td align=left  >&nbsp;Retiro <%=i%></td>
						<%next%>
						<% for i=j to j %>
						<td align=left >&nbsp;Retiro <%=j%></td>
						<%next%>
						<td align=left  >&nbsp;Total</td>
					</tr>
			<%		i=0
					For intRec=1 To rs.PageSize
						If Not rs_7.EOF Then%>
							<tr class="FuenteInput">
								<td width=3% align=right >&nbsp;<%=rs_7("impresora")%></td>
								<td width=5% align=right >&nbsp;<%=rs_7("rut_cajero")%></td>
                <td width=20% align=left >&nbsp;<%=rs_7("nombre_cajero")%></td>  
								
                <% 
                for i=1 to j - 1 
                Retiro = "Retiro " & i
                %>
						    <td class="FuenteEncabezados" valign=top align=right OnDblClick="javascript:winpopup('<%=i%>','<%=rs_7("impresora")%>','<%=rs_7("rut_cajero")%>','<%=rs_7("nombre_cajero")%>','<%=Fecha_solicitada_informe%>','<%=rs_7(Retiro)%>')"><font size=1><%=formatNumber(rs_7(Retiro), 0)%></font></td>
						    <%next%>
						    <%for i=j to j 
                Retiro = "Retiro " & i
                %>
						    <td width=15% align=left class="FuenteEncabezados" valign=top align=center OnDblClick="javascript:winpopup('<%=i%>','<%=rs_7("impresora")%>','<%=rs_7("rut_cajero")%>','<%=rs_7("nombre_cajero")%>','<%=Fecha_solicitada_informe%>','<%=rs_7(Retiro)%>')"><font size=1>&nbsp;&nbsp;&nbsp;<%=formatNumber(rs_7(Retiro), 0)%></font></td>
						    <%next%>
						    <td  align=right  class="FuenteEncabezados">&nbsp;<%=formatNumber(rs_7("monto_retiro"),0)%></td>
							</tr>
						<%	rs_7.MoveNext
						End If
						i=i+1
					Next
					%>
					  <tr class="FuenteCabeceraTabla">
               <td colspan=3 align=right>Total</td>
                
          <%
                    for i=1 to j
                Retiro_tot = "Retiro " & i

                %>
                <td width=10% align=right >&nbsp;<%=formatNumber(rs_9(Retiro_tot), 0)%></td>
                <%
                next
          %>
        <td width=10% align=right >&nbsp;<%=formatNumber(Total, 0)%></td>
        </tr>
				</table>
<%		Else
			abspage = 0 %>
			<table Width=95% border=0 cellspacing=2 cellpadding=2 >
			    <tr class="FuenteEncabezados">
					<td class="FuenteEncabezados" width=20% align=left><B>No se han realizado retiros en la fecha indicada.</B></td>
				</tr>
			</table>
		<%End If
						
		rs.Close
		Set rs = Nothing
%>
</form>
</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>

<script language=javascript>
	function winpopup( num_retiro, impresora, rut_cajero, nombre_cajero, Fecha_solicitada_informe, Retiro)
	{
		var winURL		 = "Update_retiro_x.asp?num_retiro=" + num_retiro;
			winURL		 = winURL + "&impresora=" + escape(impresora);
			winURL		 = winURL + "&rut_cajero=" + escape(rut_cajero);
			winURL		 = winURL + "&nombre_cajero=" + escape(nombre_cajero);
			winURL		 = winURL + "&Fecha_solicitada_informe=" + escape(Fecha_solicitada_informe);
			winURL		 = winURL + "&Retiro=" + escape(Retiro);
		var winName		 = "Wnd_Imprimir";
		var winFeatures  = "status=no," ; 
			winFeatures += "resizable=no," ;
			winFeatures += "toolbar=no," ;
			winFeatures += "location=no," ;
			winFeatures += "scrollbars=no," ;
			winFeatures += "menubar=0," ;
			winFeatures += "width=500," ;
			winFeatures += "height=200," ;
			winFeatures += "top=30," ;
			winFeatures += "left=0" ;
			window.open(winURL , winName , winFeatures , 'mainwindow')
	}
</script>
