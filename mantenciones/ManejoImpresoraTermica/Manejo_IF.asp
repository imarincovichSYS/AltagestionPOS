<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<%
    Cache 

responsable = session("login")

if	len(trim(request("Fiscal_actual"))) > 0 then
  session("Fiscal_actual") = request("Fiscal_actual")
else
  session("Fiscal_actual") = 99
end if

Fiscal_actual = session("Fiscal_actual")    
	SET Conn = Server.CreateObject("ADODB.Connection")
		Conn.Open Session("Dataconn_ConnectionString")
		Conn.commandtimeout=3600	

   

	Imprimir = "S"
	Comando = ""
	
  	
	if Request("Manejo") = 1 then 'CIERRE DE PERIODO (Z)
			Comando = "021"
			Accion= "Z"
	elseif Request("Manejo") = 2 then 'INFORME X
			Comando = "01"
			Accion= "X"
	elseif Request("Manejo") = 3 then 'APERTURA DE PERIODO
			Comando = "32"
			Accion= "A"
	end if


	if len(trim(Comando)) = 0 then Imprimir = "N"
	
	if Imprimir = "S" Then %>
	<script language="VbScript">			         
<% 
                '-----------------------------------------------------------------------------------------------------------------------------------------------------  
                    cSql_2 = "Exec DOV_Apertura_y_Cierre_de_Periodo '" & Accion & "', '" & responsable & "', '" & session("Fiscal_actual") & "', '" & Session("xCentro_de_venta") & "'"
                    Set Rs_2 = Conn.Execute ( cSql_2 )
                '-----------------------------------------------------------------------------------------------------------------------------------------------------

                '--------------------------------------------------------------------------------------------------------------
	    	          	'Rs_2.Close 'cierra conexión Conn_2 con el insert a la tabla Zbitacora_AperturayCierre_de_Periodo 
                '-------------------------------------------------------------------------------------------------------------- 		
%>

 		
lIniciar = false
location.href = "Mant_IF.asp?lIniciar=" & lIniciar

	</script>
<% end if %>
