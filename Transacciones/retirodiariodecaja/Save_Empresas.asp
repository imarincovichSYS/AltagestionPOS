<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then

	msgerror=""
	error=0

Monto_retiro = request("monto_retiro")
'response.write	(request("monto_concepto"))
'response.write	(request("monto_medio"))
'response.end
	
	
		Set ConnManejo_1= Server.CreateObject("ADODB.Connection")
		ConnManejo_1.Open Session( "DataConn_ConnectionString" )
		ConnManejo_1.CommandTimeout = 3600
		

	cSql_1 = "select top 1 num_retiro from	Retiros_cajas where rut_cajero=" +_
          "'"  & session("login") & "' and fecha between convert(datetime, convert(varchar, month(getdate())) + '-'+ convert(varchar, day(getdate())) + '-' + convert(varchar, year(getdate()))) and getdate() order by fecha desc"
  Set RsManejo_1 = ConnManejo_1.Execute( cSQL_1 )
  
  If Not RsManejo_1.EOF Then
	 num_retiro_actual = RsManejo_1("num_retiro")
  End if		
		
				Set ConnManejo= Server.CreateObject("ADODB.Connection")
		ConnManejo.Open Session( "DataConn_ConnectionString" )
		ConnManejo.CommandTimeout = 3600
		ConnManejo.BeginTrans
		cSQL	=	"Exec RET_Grabar_Retiro_caja '"	& session("fiscal_actual") & "', '" 	& +_
												session("login")				& "', '"		& +_
												request("monto_retiro")        & "', '" & +_
												num_retiro_actual+1				& "', '" & +_
												request("monto_concepto")				& "', '" & +_
												request("monto_medio")				& "'"
												
'response.write (cSQL)
'response.end
								
'Response.Write cSQL + "<br>"
'Response.end
			Set RsManejo = ConnManejo.Execute( cSQL )

			Registros	= RsManejo("Registros")
			Error		= RsManejo("Error")
			
			If Registros > 0 and Error = 0 then
				ConnManejo.CommitTrans				
				msgerror	= "Proceso terminado satisfactoriamente."
			Else
				ConnManejo.RollbackTrans
				msgerror	= "No se puede ingresar/modificar esta empresa."
			End if
			

	cSql = "select	top 1 id, num_retiro from	Retiros_cajas where rut_cajero=" +_
          "'"  & session("login") & "' order by fecha desc"
  Set RsManejo = ConnManejo.Execute( cSQL )
	correlativo = RsManejo("num_retiro")		

			
		RsManejo.close

		ConnManejo.close
		Set ConnManejo = Nothing

		ConnManejo_1.Close
   	Set ConnManejo_1 = Nothing
		
		
%>

<%
'conexión para obtener el puerto en Parámetros'
set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 3600

MensajeError = ""

'on error resume next

Puerto = "COM1"
Puerto = trim( replace( ucase( Puerto ) , "COM" , "" ) )

cSql_1 = "EXEC PUN_Consulta_cliente '" & TRIM(session("login")) & "'"
Set Rs_1 = Conn.Execute ( cSql_1 )

Nombre_cajero = left(Rs_1("Apellidos_persona_o_nombre_empresa") + " " + Rs_1("Nombres_persona"), 30)
Fiscal_actual = request("Fiscal_actual")
Conn.Close
Set Conn = Nothing

'response.write cSql_1 + "<br>"
'response.write Nombre_cajero + "<br>"
'response.end

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
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113FECHA: <%=NOW()%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113IMPRESORA: <%=session("fiscal_actual")%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113RUT: <%=SESSION("LOGIN")%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113CAJERO(A): <%=Nombre_cajero%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "116MONTO: $<%=formatNumber(Monto_retiro,0)%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "111" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "30" + Chr(136)
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
  MSComm1.Output = Chr(135) + "30" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113FECHA: <%=NOW()%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113IMPRESORA: <%=session("fiscal_actual")%>" + Chr(136)
  pausecomp( nSegundos )
  MSComm1.Output = Chr(135) + "113RUT: <%=SESSION("LOGIN")%>" + Chr(136)
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
  MSComm1.Output = Chr(135) + "30" + Chr(136)
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


<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
</body>

<script language="JavaScript">
  	parent.top.frames[2].location.href = "Botones_Empresas.asp";
		parent.top.frames[1].location.href = "Inicial_Empresas.asp";
</script>
<%else
	Response.Redirect "../../index.htm"
end if%>
