<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	JavaScript = "JavaScript:"

	Agrupacion	= Request("Agrupacion")
	Periodo		= Request("Periodo")
	Documento	= Request("Documento")
	CtoVenta	= Request("Centro_de_Venta")
	Paridad	    = Request("Paridad")
	if len(trim(Paridad)) = 0 then Paridad = 0 end if
	
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	cSql = "Exec DOV_Detalle_flujo_de_caja   '"	& Agrupacion	& "', " 		& +_
											"'"	& Periodo		& "', " 		& +_
											"'" & Documento		& "', " 		& +_
											"'" & CtoVenta		& "', " 		& +_
											"'" & Session("Empresa_usuario")	& "', " & +_
											"" & Paridad	& ""
'Response.write("cSql ") & cSql & "<br>"											
	SET Rs	=	Conn.Execute( cSql )

%>
<html>
    <head>
    	<title><%=session("title")%></title>
    	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
    	<script src="../../Scripts/Js/Caracteres.js"></script>
    </head>

    <body>
        <form name="Listado">
    <%      If Not Rs.Eof then %>
        		<table width="95%" border=0 align=center cellpadding=0 cellspacing=0>
        			<tr class="FuenteTitulosFunciones">
        				<td colspan=8 align=center NOWRAP >&nbsp;<a href="JavaScript:window.close()">Detalle <%=session("title")%></a>&nbsp;</td>
        			</tr>
        		</table>
        		
        		<table width="95%" border=1 align=center cellpadding=0 cellspacing=0>
        			<tr  class="FuenteCabeceraTabla">
        				<td  align=center width=05% NOWRAP >Documento</td>
        				<td  align=left   width=30% nowrap >Entidad</td>
        				<td  align=left   width=30% nowrap >Ctro vta-cto</td>
        				<td  align=center width=05% NOWRAP >Fecha emis.</td>
        				<td  align=center width=05% NOWRAP >Fecha venc.</td>
        				<td  align=right  width=10% NOWRAP >Monto $</td>
        				<td  align=right  width=10% NOWRAP >Monto US$</td>
        				<td  align=left   width=10% NOWRAP >Observaciones</td>
        			</tr>
        	<%		i=0
              TotalPorCobrar_Pesos = 0
              TotalPorCobrar_Dolar = 0
        			Do While Not Rs.EOF
                Monto_por_cobrar_o_pagar = Rs("Monto_por_cobrar_o_pagar")
                  if IsNull(Monto_por_cobrar_o_pagar) Then Monto_por_cobrar_o_pagar = 0 Else Monto_por_cobrar_o_pagar = Cdbl(Monto_por_cobrar_o_pagar)
                Monto_por_cobrar_o_pagar_US = Rs("Monto_por_cobrar_o_pagar_US$") 
                  if IsNull(Monto_por_cobrar_o_pagar_US) Then Monto_por_cobrar_o_pagar_US = 0 Else Monto_por_cobrar_o_pagar_US = Cdbl(Monto_por_cobrar_o_pagar_US)
              %>
        				<tr class="FuenteInput">
        					<td align=center width=05% NOWRAP ><%=Rs("Documento_valorizado")%> - <%=Rs("Numero_documento_valorizado")%>&nbsp;</td>
        					<td align=left   width=30% nowrap ><%=Rs("Entidad")%>&nbsp;</td>
        					<td align=left   width=30% nowrap ><%=Rs("Centro_venta_costo")%>&nbsp;</td>
        					<td align=center width=05% NOWRAP ><%=Rs("Fecha_emision")%>&nbsp;</td>
        					<td align=center width=05% NOWRAP ><%=Rs("Fecha_vencimiento")%>&nbsp;</td>
        					<td align=right  width=10% NOWRAP ><%=FormatNumber(Rs("Monto_por_cobrar_o_pagar"),0)%>&nbsp;</td>
        					<td align=right  width=10% NOWRAP ><%=FormatNumber(Rs("Monto_por_cobrar_o_pagar_US$"),2)%>&nbsp;</td>
        					<td align=left   width=05% NOWRAP ><%=Rs("Observaciones")%>&nbsp;</td>
        				</tr>
        			<%	Rs.MoveNext
                  i=i+1
        				  TotalPorCobrar_Pesos = TotalPorCobrar_Pesos + Monto_por_cobrar_o_pagar
                  TotalPorCobrar_Dolar = TotalPorCobrar_Dolar + Monto_por_cobrar_o_pagar_US
        			Loop
        			%>
        				<tr class="FuenteCabeceraTabla">
        					<td colspan=4 align=center width=05% NOWRAP >&nbsp;</td>
        					<td colspan=1 align=center width=05% NOWRAP >Totales</td>
        					<td align=right  width=10% NOWRAP ><%=FormatNumber(TotalPorCobrar_Pesos,0)%>&nbsp;</td>
        					<td align=right  width=10% NOWRAP ><%=FormatNumber(TotalPorCobrar_Dolar,2)%>&nbsp;</td>
        					<td align=left   width=05% NOWRAP >&nbsp;</td>
        				</tr>
        		</table>
    <%		Else
    			abspage = 0 %>
    			<table Width=95% border=0 cellspacing=2 cellpadding=2 >
    			    <tr class="FuenteEncabezados">
    					<td class="FuenteEncabezados" width=20% align=left><B>No hay información disponible.</B></td>
    				</tr>
    			</table>
    <%      End If
    						
    		rs.Close
    		Set rs = Nothing
    %>
        </form>
    </body>
</html>

<%
Else
	Response.Redirect "../../index.htm"
End if
%>