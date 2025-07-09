<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
<%
    Cache
    
	On Error Resume Next
	
	SET Conn = Server.CreateObject("ADODB.Connection")
		Conn.Open Session("Dataconn_ConnectionString")
		Conn.commandtimeout=3600	
	Mensaje = ""

	Bodega		= Request("Bodega")
	
	NroIntDOV	= Request("NroIntDOV")
	NroDOV		= Request("NroDOV")

	Ticket		= Request("Ticket")
	NroDoc		= Request("NroDoc")

    TextoError  = Request("TextoError")	
'Response.Write NroIntDOV & " *** "
'Response.Write NroDOV & " *** "
'break

    Set oBitacora = Server.CreateObject("Scripting.FileSystemObject")
    NombreArchivo = "LogActualizaBOV_" & Year(date()) & Right("00" & Month(date()), 2) & Right("00" & Day(date()), 2) & ".txt"
    UrlDesarrollo = Server.MapPath(".") & "\"
    Set fnBitacora = oBitacora.OpenTextFile(UrlDesarrollo + NombreArchivo, 8, True, 0)

	if Request("Err") = "060" then 
		Conn.BeginTrans 

        fnBitacora.Write ( Now() & Space(10) & " Se produjo un error: " & TextoError & " - " & Request("Err") ) & chr(13) & chr(10)
        fnBitacora.Write ( Now() & Space(10) & " Se hace rollback simulado." ) & chr(13) & chr(10)
	
		cSql = ""
		cSql_ACO = "Exec ACO_DocsCobrados '',0,'BOV', 0" & NroDOV & ", 0,'','CLI_BOLETA', '" & Session("Empresa_usuario") & "'"
		Set RsAco = Conn.Execute (cSql_ACO)
			Do While Not RsAco.Eof 
				NroAco_		= RsAco("Numero_interno_asiento_contable")
				NroIntDov_	= RsAco("Numero_interno_documento_valorizado")
				
				'Elimina documento de venta
				cSql = cSql & Chr(10) & Chr(13) & " Exec ACO_Borra_AsientoContable 0" & NroAco_ & " " 

				'Elimina documento valorizado
				cSql = cSql & Chr(10) & Chr(13) & " Exec DOV_Borra_DocumentoValorizado 0" & NroIntDOV_ & " "

				RsAco.MoveNext
			Loop
		RsAco.close
		Set RsAco = nothing
		if len(trim(cSql)) > 0 then Conn.Execute ( cSql )

'************************************* O *************************************
		cSql = "Exec DNV_Lista_Despachos_de_OVT 0" & Request("Numero_OrdenVenta")
		Set Rs = Conn.Execute ( cSql )
			cSql = ""
			if Not Rs.Eof then
				NroDVT = Rs("Numero_despacho_de_venta")
				cSql = cSql & chr(10) & Chr(13) & " Exec MOP_BorraMovimientoProductoxdocumentoNoValorizado_SinLinea 'DVT', 0" & NroDVT & " " 
				cSql = cSql & chr(10) & Chr(13) & " Exec DNV_BorraDocumentoNoValorizado 'DVT', 0" & NroDVT & " " 
			end if
		Rs.Close
		Set Rs = Nothing
		if len(trim(cSql)) > 0 then Conn.Execute ( cSql )
		
		cSql = "Exec DNV_Lista_ACO_Asiento_automatico 0" & NroDOV
		Set Rs = Conn.Execute ( cSql )
			cSql = ""
			Do While Not Rs.Eof
				Nro = Rs("Numero_documento_no_valorizado")
				cSql = cSql & chr(10) & Chr(13) & "Exec DNV_BorraDocumentoNoValorizado 'ACO', 0" & Nro
				'Conn.Execute ( cSql )
				Rs.MoveNext
			Loop
		Rs.Close
		Set Rs = Nothing
		if len(trim(cSql)) > 0 then Conn.Execute ( cSql )

		cSql = "Exec DOV_Borra_DocumentoValorizado " & NroIntDOV
		Conn.Execute ( cSql )
		
'************************************* O *************************************

'Response.Write cSql
'break
		
		if Request("Funcion") = "DespachoIPAQ" then
			Estado = "PRE"
		else
			Estado = "AUT"
		end if

		if Request("Funcion") = "DespachoIPAQ" then
			cSql = "Exec DNV_Cambia_Estado_OVT_IPAQ 0" & Request("Numero_OrdenVenta") & ", 'OVT', '" & Estado & "'"
			Conn.Execute (cSql)		
		else
			'Obtiene el número del documento no valorizado
			cSql = "Exec DNV_Rescata_numero_interno 0" & Request("Numero_OrdenVenta") & ",'OVT'"
			Set Rs = Conn.Execute (cSql)
				NroIntDNV = Rs("Numero_interno_documento_no_valorizado")
			Rs.close
			set rs = nothing

			'Actualiza los detalles de la OVT
			cSql = "Exec MOP_Actualiza_estado_documento_completo 0" & NroIntDNV & ", '" & Estado & "'"
			Conn.Execute (cSql)
		
			'Actualiza la cabecera de la OVT
			cSql = "Exec DNV_Manejo_estados_OVT_OCP 0" & NroIntDNV & ", 'OVT', 'N', 'N'"
			Conn.Execute (cSql)

            cSql = "Exec DNV_Recalcula_montos 'OVT', 0" & Request("Numero_OrdenVenta") 
            Conn.Execute ( cSql )
        end if
		
		if Conn.Errors.Count = 0 then
			Conn.CommitTrans 			
			'Conn.RollbackTrans 
		else
			Conn.RollbackTrans 
		end if
		Conn.Close
		Set Conn = Nothing
	else
		cSql = "Exec DOV_Actualiza_Nro_DOV 0" & NroIntDOV & ", 0" & Request("NroBoleta")
		Set RsAct = Conn.Execute ( cSql )
		if Not RsAct.Eof then
            TotalCampos = RsAct.FIELDS.COUNT
                fnBitacora.Write ( Now() & Space(10) & "No hay errores (" & TextoError & ") se actualiza Folio de la Boleta: " & cSql ) & chr(13) & chr(10)
            	For	i=0 to TotalCampos-1
            		if i<>0 then
            			fnBitacora.Write ","
            		end if
            		fnBitacora.Write ( RsAct.fields(i).name ) 
            	Next
            	fnBitacora.Write chr(13) & chr(10)
            	
            Do while Not RsAct.Eof 
            	For	i=0 to TotalCampos-1
            		if i<>0 then
            			fnBitacora.Write ","
            		end if
            		if RsAct.fields(i).type = 200 or RsAct.fields(i).type = 129 Or RsAct.fields(i).type = 135 then ' varchar y char
            			if RsAct.fields(i).type = 135 then
            				if RsAct.fields(i).value <> "" then
            					fnBitacora.Write ( day(RsAct.fields(i).value) & "/" & month(RsAct.fields(i).value) & "/" & year(RsAct.fields(i).value) )
            				end if
            			else
            				fnBitacora.Write ( chr(34) & RsAct.fields(i).value & chr(34))
            			end if
            		elseif RsAct.fields(i).type = 2 or RsAct.fields(i).type = 3 or RsAct.fields(i).type = 17 or RsAct.fields(i).type = 131 then  ' smallint & integer & tinyint & numeric
            'Response.Write Rs.fields(i).value & Chr(13) & Chr(10)
            			if IsNull(RsAct.fields(i).value) then
            				fnBitacora.Write ( 0 )
            			else
            				fnBitacora.Write ( RsAct.fields(i).value )
            			end if
            		end if							
            	Next
            	fnBitacora.Write chr(13) & chr(10)
            	RsAct.MoveNext				
            Loop				
		End if
		Conn.Close %>
<%	end if
    
    fnBitacora.Close				

%>

		<script language="vbscript">		
			if "<%=Ticket%>" = "S" Then
				parent.location.href = "../Ticket/Ticket.asp?NroDoc=<%=NroDoc%>&Despacho=S&Funcion=<%=Request("Funcion")%>&Bodega=<%=Bodega%>"
			else
				if "<%=Request("Funcion")%>" = "Despacho" then
					parent.top.frames(1).location.href = "../../Transacciones/DespachoOrdenVenta/Inicial_Despacho.asp"
					parent.top.frames(2).location.href = "../../Transacciones/DespachoOrdenVenta/Botones_Despacho.asp"
					parent.top.frames(3).location.href = "../../Mensajes.asp"
				elseif "<%=Request("Funcion")%>" = "DespachoIPAQ" then
					parent.top.frames(1).location.href = "../../Transacciones/DespachoOrdenVentaIPAQ/Inicial_DespachoIPAQ.asp"
					parent.top.frames(2).location.href = "../../Transacciones/DespachoOrdenVentaIPAQ/Botones_DespachoIPAQ.asp"
					parent.top.frames(3).location.href = "../../Mensajes.asp"
				else
					parent.top.frames(1).location.href = "../../Transacciones/EmisionBoleta/Inicial_Despacho.asp"
					parent.top.frames(2).location.href = "../../Transacciones/EmisionBoleta/Botones_Despacho.asp"
					parent.top.frames(3).location.href = "../../Mensajes.asp"
				end if
			end if
		</script>
</body>
