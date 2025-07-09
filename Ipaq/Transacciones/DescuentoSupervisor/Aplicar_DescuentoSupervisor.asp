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
	
	for a=1 to nLineas
		if Request("Descuento_anterior_" & a) <> Request("Descuento_" & a) then
       Sql = "Exec MOP_Modifica_descuento_linea_DVT '" & _
                           Request("Cajera") & "',0" & _
                           Request("Numero_linea_" & a) & ",0" & _
                           Request("Descuento_" & a)
       Conn.execute( Sql )
				if len(trim(Err.Description)) > 0 then
					Error = "S"
					MsgError = MsgError & Err.Description & "\n"
					exit for 
				end if
		end if
	next
	
	if Error = "N" Then
		Conn.CommitTrans 
		MsgError = "Proceso terminado satisfactoriamente."
	else
		Conn.RollbackTrans 
	end if

	Conn.Close	
%>
	<script language="JavaScript">
		alert ( '<%=MsgError%>' )
		parent.top.location.href = "Main_DescuentoSupervisor.asp"
	</script>
<%else
	Response.Redirect "../../index.htm"
end if%>