<%
	Session("Login") = Replace(Request("Usuario"),"'","")
	ClaveActual		 = Replace(Request("Clave"),"'","")
	Session("Clave") = Replace(Request("Nva_Clave"),"'","")

	Error = "N"
	Estado = "S"

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
	cSql = "Exec USR_IdentificaUsuario '" & Session("Login") & "', '" & ClaveActual & "'"
'Response.Write cSql & "<br>"
	SET Rs = Conn.Execute( cSQL )
	Mensaje = ""
	if Rs.eof then
		Error = "S"
		Direccion = "Usuario.asp"
		Mensaje   = "Clave incorrecta, por favor reingrese."
	Else
		If Not Rs.eof then
			Control = Rs( "Control" )
			if Rs("Estado") = "Vigente" then
				if Rs("Clave") = "OK" then
					Error = "N"
				else
					Error = "S"
				end if
			else
				Estado = "N"
				Error = "S"
			end if
		else
			Error = "S"
		End if

		If Error = "N" then
			Direccion = "Index.htm"		
			cSql = "Exec USR_CambioClaveUsuario '" & Session("Login") & "', '" & ClaveActual & "', '" & Session("Clave") & "', 0"
'			cSql = "Exec USR_CambioClaveUsuario '" & Session("Login") & "', '" & ClaveActual & "', '" & Session("Clave") & "', 0" & Control
			SET RsActualizacion = Conn.Execute( cSQL )
			If RsActualizacion("Error") = 0 And RsActualizacion("Registros") = 1 then
				Mensaje   = "Se cambió satisfactoriamente su clave."
			else
				Mensaje   = "Ocurrieron problemas durante la actualizaciòn de la clave, contacte al administrador."
			end if
			RsActualizacion.Close		
		else
			Direccion = "Usuario.asp"
'			if Estado = "S" then
				Mensaje   = "Ha caducado su vigencia en el sistema, consulte con el administrador."
'			else
'				Mensaje   = "La clave actual ingresada no es correcta, por favor reingrese."
'			end if
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
		document.Formulario.submit();
	<%else%>
		parent.Clave.document.Formulario.Clave.focus();
	<%end if%>
</script>
