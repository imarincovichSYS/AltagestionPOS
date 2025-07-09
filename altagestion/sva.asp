<html>
<head>
	

    <%     
    set fso = createobject("scripting.filesystemobject")
    
    set objBase=server.CreateObject("ADODB.Connection")
    set objtabla=server.CreateObject("ADODB.recordset")
    
    objbase.Open "Driver={SQL Server};Server=s02sys;Database=sanchez;Uid=AG_Sanchez;Pwd=;"
    
    server.ScriptTimeout=5000
    set objtabla=objbase.Execute("Z_SVA_Z")
             
    Set act = fso.CreateTextFile(server.mappath("txt\Archivo.dat"), true)
    i=0
    do while not objtabla.EOF
       	txt = objtabla.Fields("codigo") '& vbcrlf
        act.WriteLine(txt)
    	i=i+1
    	objtabla.MoveNext
    loop
    act.Close
    server.ScriptTimeout=900
    Response.Write("Se han copiado " & i & " registros.")


%> 

</head>
<body>

	<%'do while Not rs.EOF%>

	<%'=rs("codigo")%>
	
		<%	'rs.MoveNext
		
	'loop%>

<%'rs.movefirst%>

		<%'rs.Close
		'Set rs = Nothing%>
		
		



</body>
</noframes>
</html>
