<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	On Error Resume Next

if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	Set Conn= Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600
	Conn.BeginTrans 
	
	MsgError = ""
	Error    = "N"

	nLineas = Request("Lineas")
	
	for a=0 to nLineas
		if Request("Sel_" & a) = "on" then
			cSql = "Exec DOV_Borra_DocumentoValorizado 0" & Request("NroIntDOV_" & a)
			Conn.Execute ( cSql )
			if len(trim(Err.Description)) > 0 then
				Error = "S"
				MsgError = Err.Description 
				exit for 
			'else
				'cSql = "Exec DOV_Agrega_DocumentoNulo_Ipaq '" & Session("Empresa_usuario") & "', '" & Request("Doc_" & a ) & "', 0" & Request("NroDoc_" & a )
				'Conn.Execute ( cSql )
				'if len(trim(Err.Description)) > 0 then
				'	Error = "S"
				'	MsgError = MsgError & Request("Doc_" & a ) & "-" & Request("NroDoc_" & a ) & " " & Err.Description & "\n"
				'	exit for 
				'end if
			end if
		end if
	next
	
	if Error = "N" Then
		Conn.CommitTrans 
		MsgError = "Proceso terminado satisfactoriamente."
	else
		Conn.RollbackTrans 
	end if

    MsgError = LimpiaError(MsgError)

	Conn.Close	
%>
	<script language="JavaScript">
		alert ( '<%=MsgError%>' )
		parent.top.location.href = "Main_VtaInf.asp"
	</script>
<%else
	Response.Redirect "../../index.htm"
end if%>
