<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
<%
'	On Error Resume Next
	
	SET Conn = Server.CreateObject("ADODB.Connection")
		Conn.Open Session("Dataconn_ConnectionString")
		Conn.commandtimeout=3600	
	Mensaje = ""

	Bodega		= Request("Bodega")
	
	NroIntDOV	= Request("NroIntDOV")
	NroDOV		= Request("NroDOV")

	Ticket		= Request("Ticket")
	NroDoc		= Request("NroDoc")
	
'Response.Write NroIntDOV & " *** "
'Response.Write NroDOV & " *** "
'break

	if Request("Err") = "060" then 
		Conn.BeginTrans 
	
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
			aLinea = Split(Request("Items"),"¬")
			for a=0 to ubound(aLinea)-1
				aDet = Split(aLinea(a),"|")
					cSql = "Exec MOP_Actualiza_estado 0" & aDet(0) & ", '" & Estado & "', 0" & aDet(1)
				Conn.Execute (cSql)
			next
		
			'Actualiza la cabecera de la OVT
			cSql = "Exec DNV_Manejo_estados_OVT_OCP 0" & NroIntDNV & ", 'OVT', 'N', 'N'"
			Conn.Execute (cSql)
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
		Conn.Execute ( cSql )
		Conn.Close %>
<%	end if%>

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
				end if
			end if
		</script>
</body>