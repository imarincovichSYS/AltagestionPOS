<!-- #include file="Scripts/Inc/Cache.Inc" -->
<%
	Cache
'    Response.Expires=0
    Response.Buffer=true
	Session("Login") = Replace(Request("Usuario"),"'","")
	Session("Clave") = Replace(Request("Clave"),"'","")

	Session("MensajeProcesar") = "Validaciones OK, presione Confirmar para grabar."

	Error = "N"
	Estado = "S"

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	cSql = "Exec USR_IdentificaUsuario '" & Session("Login") & "', '" & Session("Clave") & "'"
'Response.Write cSql & "<br>"
	SET Rs = Conn.Execute( cSQL )
	Mensaje = ""
	if Rs.eof then
		Error = "S"
		Direccion = "Usuario.asp"
		Mensaje   = "Clave incorrecta, por favor reingrese."
	Else
		If Not Rs.eof then
			if IsNull(Rs("Empresa")) Then 
				Session("Empresa_usuario") = "" 
			Else 
				Session("Empresa_usuario") = Rs("Empresa")
			end if
			Session("Empresa_usuario_original")	= Session("Empresa_usuario")
			
			if IsNull(Rs("Centro_de_venta")) Then Centro_de_venta = "" Else Centro_de_venta = Rs("Centro_de_venta")
			if IsNull(Rs("Bodega")) Then Bodega = "" Else Bodega = Rs("Bodega")
			if IsNull(Rs("Descuento_vendedor")) then Descuento = 0 Else Descuento = cDbl(Rs("Descuento_vendedor"))
			Session("xCentro_de_venta")			= Centro_de_venta
      Session("xNombre_centro_de_venta")			= Rs("Nombre_centro_de_venta") & ""
			Session("xBodega")					= Bodega
			Session("xDsctoVendedor")			= Descuento
			
			Session("Nombre_usuario")			= Rs("Nombres_usuario") & " " & Rs("Apellidos_usuario")
			Session("Nombre_Empresa")			= Rs("Nombre_Empresa")
		    Session("Impresora_usuario")		= Rs("Direccion_Impresora")
		    session("Mail_usuario")				= Rs("Mail")
			if Rs("Estado") = "Vigente" then
				if Rs("Clave") = "OK" then
					Error = "N"
					Estado = "N"
				else
					Error = "S"
				end if
			else
				Error = "S"
				Estado = "S"
			end if
		End if

		If Error = "N" then
			'********** Inicio grabación el inicio de la conección *******************
			Browser = Request.ServerVariables( "HTTP_USER_AGENT" )
			cSql = "Exec CON_InicioSesion '" & Browser & "', 0" & Session.SessionID & ", '" & Session("Login") & "', '" & Session("IP") & "'"
			Conn.Execute ( cSql )
			'********** Fin grabación el inicio de la conexión *******************
			session("MsgClientenoAsosiado")	= "****** Sin cliente asociado ******"
			if IsNull(Rs("Empresa")) Then 
				Session("Empresa_usuario") = "" 
			Else 
				Session("Empresa_usuario") = Rs("Empresa")
			end if
		    
			'Direccion = "Index.htm"
			'Direccion = session("websystem") & ".html"
			Direccion = "Index.htm"
			session("inicio_url") = session("websystem") & ".asp"
			'Direccion = "Index.asp"				
		else
			Direccion = "Usuario.asp"
			Mensaje   = "Ha caducado su vigencia en el sistema, consulte con el administrador."
		End if
	End if
%>

<body background="<%=Session("ImagenFondo")%>" leftmargin="0" topmargin="0">
	<Form name="Formulario" action="<%=Direccion%>" target="_top">
	</Form>
</body>

<script language="JavaScript">
	<%	if len(trim(Mensaje)) > 0 then %>
			alert ( '<%=Mensaje%>' );
	<%	end if%>
	<%if Error = "N" then%>
		parent.top.location.href = '<%=Direccion%>'; //document.Formulario.submit();
		parent.top.title = '<%=session("websystem")%>'; 
	<%else%>
		parent.Clave.document.Formulario.Clave.focus();
	<%end if%>
</script>
