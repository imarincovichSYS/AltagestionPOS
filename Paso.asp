<!-- #include file="Scripts/Inc/Cache.Inc" -->
<%
	Cache
	Session.LCID = 2057
	NomFuncion = Request("NomFun")
	Session("Dataconn_ConnectionString") = Session("ConexionInicial")

    if len(trim(Session("Dataconn_ConnectionString"))) > 0 then
    	SET Conn = Server.CreateObject("ADODB.Connection")
    	Conn.Open Session("Dataconn_ConnectionString")
    	Conn.commandtimeout=100
    	
    	CierreEnCurso = "N"
    	cSQL = "Exec PAR_ListaParametros 'CIERRENCURSO'"
    	SET Rs	=	Conn.Execute( cSQL )
    	if Not Rs.Eof then
    		CierrEnCurso = Rs("Valor_texto")
    	end if
    	Rs.Close
    
    	if Ucase(Trim(CierrEnCurso)) = "SI" Then%>
    		<html>
    			<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
    				<script language="JavaScript">
    					alert ( "En este instante se está ejecutando un cierre. No se puede utilizar el sistema hasta que éste termine." )
    					parent.top.frames(1).location.href = "Empty.asp"
    					parent.top.frames(2).location.href = "Empty.asp"
    					parent.top.frames(3).location.href = "Mensajes.asp"
    				</script>
    			</body>
    		</html>
    <%	else		' cierre en curso
    		cSql = "Exec FUN_ListaFunciones '" & NomFuncion & "', Null, Null"
    		Set RsFunciones = Conn.Execute ( cSql )
    		If Not RsFunciones.eof then
    			Session("Title")	= RsFunciones("Nombre")
    			NombreFuncion		= RsFunciones("Nombre")
    			Programa_inicial	= RsFunciones("Programa_inicial") & "?NomFun=" & NomFuncion
    			ExigeEmpresa		= RsFunciones("Exige_empresa")
    		End if
    		Error = "N"
    		if Ucase(Trim(ExigeEmpresa)) = "S" Then
    			if Len(Trim(Session("Empresa_usuario"))) = 0 Or IsNull(Session("Empresa_usuario")) Then
    				cSQL = "Exec FUN_ListaFunciones 'AsignarEmpre', Null, Null"
    				SET Rs	=	Conn.Execute( cSQL ) 
    				if Not Rs.Eof then
    					AsignarEmpresa	= Rs("Nombre")
    					Modulo			= Rs("Modulo")
    				end if
    				Rs.Close 
    				Error = "S"%>
    		<html>
    			<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
    				<script language="JavaScript">
    					alert ( "Esta opción exige una empresa, para asociar una empresa debe hacerlo en la opción <%=AsignarEmpresa%>, que se encuentra en el módulo de <%=Modulo%>." )
    					parent.top.frames(1).location.href = "Empty.asp"
    					parent.top.frames(2).location.href = "Empty.asp"
    					parent.top.frames(3).location.href = "Mensajes.asp"
    				</script>
    			</body>
    		</html>
    	<%		end if
    		end if
    
    		if Error = "N" Then
    			cSql = "Exec _AuditaFunciones '" & NomFuncion & "', 0" & Session.SessionId & ", '" & Session("Login") & "', '" & Session("IP") & "'"
    			Conn.Execute ( cSql )
    			
    			'response.write Session("ConexionInicial") & " --<br />"
    			'Aplicacion	= NombreFuncion
    			'Ip			= Session("Login") & " (" & Session.SessionID & ")"
    			'response.write Ip & " Ip-- <br />"
    			'Pos1 = Instr(1,Session("ConexionInicial"),"APP=")-1
    			'response.write Pos1 & " Pos1 -- <br />"
    			'PrimeraParte = Mid(Session("ConexionInicial"),1,Pos1+4)

    			'response.write PrimeraParte & " PrimeraParte-- <br />"
    			'Pos2 = Instr(1,Session("ConexionInicial"),"WSID=")
    			'response.write Pos2 & " Pos2-- <br />"
    			'Pos3 = Instr(1,Session("ConexionInicial"),";Database")
    			'response.write Pos3 & " Pos33333-- <br />"
    			'SumaPos = Pos3 - Pos2
    			'response.write SumaPos & " SumaPos-- <br />"
    			'SegundaParte = Mid(Session("ConexionInicial"),Pos2+SumaPos,len(Session("ConexionInicial")))
    			'response.write SegundaParte & " SegundaParte-- <br />"
    
    			'PrimeraParte = PrimeraParte & Aplicacion & "(" & session("login") & ")" & ";"
    			'response.write PrimeraParte & " PrimeraParte-- <br />"
    			'SegundaParte = "WSID=" & IP & SegundaParte 
    			'response.write SegundaParte & " SegundaParte-- <br />"

    
    			'Session("Dataconn_ConnectionString") = PrimeraParte & SegundaParte  & "LANGUAGE=us_english;"
    			'response.write Session("Dataconn_ConnectionString") & " Session(Dataconn_ConnectionString)-- <br />"

    			'response.write Programa_inicial & " <--Programa_inicial--> <br />"
    
    			cSQL = "Exec FUN_ListaFunciones '" & NomFuncion & "', Null, Null"
    			SET Rs	=	Conn.Execute( cSQL )
    				Session("Title") = Rs("Nombre")
    			Rs.Close
    			Conn.Close 

    					
    		%>
    			<script src="Scripts/Js/Ventanas.js"></script>			
    			<script language="Javascript">
    				/*
    				var wndFeatures  = "status=no," ; 
    					wndFeatures += "resizable=no," ;
    					wndFeatures += "toolbar=no," ;
    					wndFeatures += "location=no," ;
    					wndFeatures += "scrollbars=no," ;
    					wndFeatures += "menubar=0," ;
    					wndFeatures += "width=1,height=1,top=5000,left=5000"
    				Closepopupnr("Empty.htm","Wnd_Ccosto","", wndFeatures)
    				Closepopupnr("Empty.htm","Wnd_Clientes","", wndFeatures)
    				Closepopupnr("Empty.htm","Wnd_GastoInsumo","", wndFeatures)
    				Closepopupnr("Empty.htm","Wnd_Productos","", wndFeatures)
    				Closepopupnr("Empty.htm","Wnd_Productos_precio","", wndFeatures)				
    				Closepopupnr("Empty.htm","Wnd_Proveedores","", wndFeatures)				
    				Closepopupnr("Empty.htm","Wnd_ProveedoresEspecial","", wndFeatures)				
    				Closepopupnr("Empty.htm","Wnd_Garantia","", wndFeatures)								
    				Closepopupnr("Empty.htm","Wnd_Documento","", wndFeatures)		
    				Closepopupnr("Empty.htm","Wnd_EntidadesComerciales","", wndFeatures)
    				Closepopupnr("Empty.htm","Wnd_ItemGasto","", wndFeatures)				
    				Closepopupnr("Empty.htm","Wnd_AyudaRecepciones","", wndFeatures)
    				Closepopupnr("Empty.htm","Wnd_Usuarios","", wndFeatures)				
    				Closepopupnr("Empty.htm","Wnd_CtasCtbles","", wndFeatures)				
    				Closepopupnr("Empty.htm","", wndFeatures)
    				Closepopupnr("Empty.htm","Wnd_Rosas","", wndFeatures)
    				
    				Closepopupnr("Empty.htm","","", wndFeatures)
    				Closepopupnr("Empty.htm","Wnd_Productos","", wndFeatures)
    				parent.top.frames[1].location.href = "<%=Programa_inicial%>";
    			*/	
    			</script>
    		<%	Response.Redirect(Programa_inicial)

    		end if
    	end if
    else 'if len(trim(Session("Dataconn_ConnectionString"))) > 0 then %>
    	<script language="JavaScript">
    		alert ( "Ha expirado la sesión\nPor favor ingrese nuevamente." )
    		parent.top.location.href = "autentificacion.asp"
    	</script>
<%   end if %>
