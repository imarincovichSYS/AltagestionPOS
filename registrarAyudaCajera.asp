
<%
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")

	value = request("value")


	if value = "True" then
		valueINT =  0
	else
		valueINT =  1
	end if 


	

	cSql = "exec CAJ_PedirAyuda '" & Request.ServerVariables("REMOTE_HOST") & "' , " & valueINT



	SET Rs	=	Conn.Execute( cSQL )
	
	
   	if Not Rs.Eof then
    	response.write Rs("needAyuda")
   	end if

   
	
	Rs.Close
	Conn.Close


%>