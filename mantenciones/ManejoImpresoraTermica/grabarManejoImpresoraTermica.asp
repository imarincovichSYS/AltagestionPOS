<%

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600	

	ip = Request.ServerVariables("REMOTE_ADDR")
	accion = request("accion")
	responsable = session("login")

	cSQL =  "exec CAJ_Obtener_por_direccion_IP '" & ip & "'"

	Set Rs1 = Conn.Execute ( cSQL )

	if not Rs1.EOF then
		cajaNumero = Rs1("caja_numero")	
	else
		response.write "{ status: error }"
		response.end

	end if

	set Rs1 = nothing

	cSql_2 = "Exec DOV_Apertura_y_Cierre_de_Periodo '" & accion & "', '" & responsable & "', '" & cajaNumero & "', '" & Session("xCentro_de_venta") & "'"

    Set Rs_2 = Conn.Execute ( cSql_2 )

    set Rs_2 = nothing

    Dim objXMLHTTP
	Dim url
	Dim respuesta


	url = "http://"&session("IP")&":8080/phpcaja/docs/aperturacierre.php?num_fiscal="&cajaNumero&"&accion="&accion&"&cto_venta=0011" '&Session("xCentro_de_venta")

	response.write url
	Set objXMLHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")

	objXMLHTTP.Open "GET", url, False
	objXMLHTTP.Send

	Set objXMLHTTP = Nothing

    
    Conn.Close

    response.write "{ status: ok }"
%>