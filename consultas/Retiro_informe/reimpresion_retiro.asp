<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then

     correlativo = request("num_retiro")
     impresora = request("impresora")
     rut_cajero = request("rut_cajero")
     Fecha_solicitada_informe = request("Fecha_solicitada_informe")
      'Fecha_solicitada_informe = day(Fecha_solicitada_informe) + "/" + month(Fecha_solicitada_informe) + "/" + year(Fecha_solicitada_informe)
     Monto_retiro = request("Retiro")

'conexión para obtener el puerto en Parámetros'
set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 3600

MensajeError = ""

'on error resume next

Puerto = "COM1"
Puerto = trim( replace( ucase( Puerto ) , "COM" , "" ) )

cSql_1 = "EXEC PUN_Consulta_cliente '" & rut_cajero & "'"
Set Rs_1 = Conn.Execute ( cSql_1 )

Nombre_cajero = left(Rs_1("Apellidos_persona_o_nombre_empresa") + " " + Rs_1("Nombres_persona"), 30)
 
Conn.Close
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
        	
nSegundos =150
'Msgbox "La impresora no responde: " & Boleta_fiscal_actual ,vbOkOnly + 16, "Error"

MSComm1.Output = Chr(135) + "60"+ Chr(136) 'INICIO
pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "116      S A N C H E Z  &  S A N C H E Z " + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113       Copia Supervisor(a) RETIRO: <%=correlativo%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113**REIMPRESIÓN   <%=NOW()%> *******" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113FECHA: <%=Fecha_solicitada_informe%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113IMPRESORA: <%=impresora%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113RUT: <%=rut_cajero%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113CAJERO(A): <%=Nombre_cajero%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "116MONTO: $<%=formatNumber(Monto_retiro,0)%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113***************REIMPRESIÓN***************" + Chr(136)
  'pausecomp( nSegundos )
  'MSComm1.Output = Chr(135) + "30" + Chr(136)
pausecomp( nSegundos )
MSComm1.Output = Chr(135) + "61" + Chr(136) 'FIN
pausecomp( nSegundos )
delay(2)
pausecomp( nSegundos )
MSComm1.Output = Chr(135) + "60"+ Chr(136) 'INICIO
pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "116      S A N C H E Z  &  S A N C H E Z " + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113       Copia Cajero(a) RETIRO: <%=correlativo%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113**REIMPRESIÓN   <%=NOW()%> *******" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113FECHA: <%=Fecha_solicitada_informe%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113IMPRESORA: <%=impresora%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113RUT: <%=rut_cajero%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113CAJERO(A): <%=Nombre_cajero%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "111" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "116MONTO: $<%=formatNumber(Monto_retiro,0)%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113***************REIMPRESIÓN***************" + Chr(136)
  'pausecomp( nSegundos )
  'MSComm1.Output = Chr(135) + "30" + Chr(136)
pausecomp( nSegundos )
MSComm1.Output = Chr(135) + "61" + Chr(136) 'FIN
pausecomp( nSegundos )
delay(2)
MSComm1.PortOpen = False
pausecomp( nSegundos )
delay(2)
pausecomp( nSegundos )

</script>
<%
'response.write puerto
%>


<body onload="close()"; bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
</body>

<script language="JavaScript">
  	parent.top.frames[2].location.href = "Botones_Empresas.asp";
		parent.top.frames[1].location.href = "Inicial_Empresas.asp";
</script>
<%else
	Response.Redirect "../../index.htm"
end if%>
