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

    cSql = "Exec PAR_ListaParametros 'IMPBOLEVTA'"
    Set Rs = Conn.Execute ( cSql )
    If Not Rs.Eof then
        Puerto = Rs("Valor_Texto")
    else
        Puerto = "COM1"
    end if
    Rs.Close
    Puerto = trim( replace( ucase( Puerto ) , "COM" , "" ) )

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
'msgbox ( Right("00" & <%=Comando%>,2) )
	    Dim Err

		Dim MSComm1, Buffer
		Set MSComm1 = CreateObject("MSCOMMLib.MSComm")
        MSComm1.Settings = "19200,N,8,1"
		MSComm1.CommPort = <%=Puerto%>
		MSComm1.PortOpen = True          ' open port
		MSComm1.InBufferCount = 0
		MSComm1.InputLen = 0              ' disable input
		MSComm1.InputMode = comInputModeText
		MSComm1.RTSEnable = True         ' Ensure high for power

		'Delay(3)

		MSComm1.Output = Chr(135) + "<%=Comando%>" + Chr(136)
		pausecomp(500) ' medio segundo
		Err = Lectura(0)
		
		Intentos = 1
        If Len(Trim(Err)) > 0 Then
		    Do While Len(Trim(Err)) > 0 
                if Intentos <= 3 then
		                exit do
                end if					
				if Instr(1,Err,"Se espera comando repetir") > 0 then
					MSComm1.Output = Chr(135) + "18" + Chr(136)
				elseif Instr(1,Err,"Falta Papel o la Tapa de Impresora está abierta") > 0 then
					Msgbox "Para continuar coloque más papel o cierre la tapa de impresora.",vbOKOnly," :. Advertencia .: "
					MSComm1.Output = Chr(135) + "18" + Chr(136)
				elseif Instr(1,Err,"no responde") > 0 then
					Msgbox "La impresora presenta problemas.",vbOKOnly," :. Advertencia .: "
					MSComm1.Output = Chr(135) + "18" + Chr(136)
				else
					Msgbox "Se ha producido un error " & Trim(Err), vbOKOnly, " :. Advertencia .: " 
				end if        
				Delay(1)
				Err = Lectura(0)
				Intentos = Intentos + 1
		    Loop 
		End If
		
			    MSComm1.PortOpen = False
	    
	              
			          

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
