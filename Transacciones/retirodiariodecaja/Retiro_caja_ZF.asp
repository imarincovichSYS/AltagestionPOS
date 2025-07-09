<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
'conexión para obtener el puerto en Parámetros'
set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 3600

MensajeError = ""

'on error resume next

Puerto = "COM1"
Puerto = trim( replace( ucase( Puerto ) , "COM" , "" ) )

cSql_1 = "EXEC PUN_Consulta_cliente '" & session("login") & "'"
Set Rs_1 = Conn.Execute ( cSql_1 )

Nombre_cajero = left(Rs_1("Apellidos_persona_o_nombre_empresa") + " " + Rs_1("Nombres_persona"), 40)

Conn.Close
Set Conn = Nothing

Fiscal_actual = request("Fiscal_actual")

%>

<script language="VbScript">
Dim nSegundos
Dim xError
Dim TextoError
Dim MSComm1, Buffer
Set MSComm1 = CreateObject("MSCOMMLib.MSComm")
MSComm1.Settings = "19200,N,8,1"
if len(Trim(Err.Description)) > 0 then
  xError = "060"
  TextoError = Err.Description
end if
                if xError <> "060" then  
				    MSComm1.CommPort = <%=Puerto%>
				    if len(Trim(Err.Description)) > 0 then
				        xError = "060"
                        TextoError = Err.Description
                    end if
				end if
                if xError <> "060" then  
    				MSComm1.PortOpen = True          ' open port
				    if len(Trim(Err.Description)) > 0 then
				        xError = "060"
                        TextoError = Err.Description
                    end if
				end if

        if xError <> "060" then  
    				MSComm1.InBufferCount = 0
    				MSComm1.InputLen = 0              ' disable input
    				MSComm1.InputMode = comInputModeText
    				MSComm1.RTSEnable = True         ' Ensure high for power
				end if
			
   			if len(trim(TextoError)) > 0 then 
           Msgbox "Se produjo un error con la impresora: " & chr(13) & TextoError, vbOkOnly + 16, "Error"
        end if			


	'Obteniendo boleta actual
				MSComm1.Output = Chr(135) + "482" + Chr(136)
        xError = Lecturam(3)
        If InStr(1, xError, ":") > 0 Then
    			 aInformacion_impresora = Split(xError, ":")
					 Boleta_fiscal_actual = cdbl("0"&aInformacion_impresora(0)) + 1
				else
					 xError = "060"
					 Msgbox "La impresora no responde: " , vbOkOnly + 16, "Error"
				End If
				'Msgbox "La impresora no responde: "+xError , vbOkOnly + 16, "Error"
				 if xError <> "060" then
        			nSegundos = 500
        	end if

'lectura de boleta'
	'Obteniendo boleta actual
				MSComm1.Output = Chr(135) + "482" + Chr(136)
        xError = Lecturam(3)
        If InStr(1, xError, ":") > 0 Then
    			 aInformacion_impresora = Split(xError, ":")
					 Boleta_fiscal_actual = cdbl("0"&aInformacion_impresora(0)) + 1
				else
					 xError = "060"
					 Msgbox "La impresora no responde: ", vbOkOnly + 16, "Error"
				End If
        	

'Msgbox "La impresora no responde: " & Boleta_fiscal_actual ,vbOkOnly + 16, "Error"

MSComm1.Output = Chr(135) + "60"+ Chr(136) 'INICIO

  MSComm1.Output = Chr(135) + "116      S A N C H E Z  &  S A N C H E Z " + Chr(136)
  MSComm1.Output = Chr(135) + "113       COMPROBANTE DE RETIRO Num: 1" + Chr(136)
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  MSComm1.Output = Chr(135) + "113FECHA: <%=NOW()%>" + Chr(136)
  MSComm1.Output = Chr(135) + "113IMPRESORA: <%=Fiscal_actual%>" + Chr(136)
  MSComm1.Output = Chr(135) + "113RUT: <%=SESSION("LOGIN")%>" + Chr(136)
  MSComm1.Output = Chr(135) + "113CAJERO(A): <%=Nombre_cajero%>" + Chr(136)
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  MSComm1.Output = Chr(135) + "116MONTO: $11.500.000" + Chr(136)
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  MSComm1.Output = Chr(135) + "30" + Chr(136)

MSComm1.Output = Chr(135) + "61" + Chr(136) 'FIN

MSComm1.PortOpen = False


</script>

<%
response.write puerto
%>
