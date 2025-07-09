<!-- #include file="Scripts/Inc/Cache.Inc" -->
<%
	Cache

	Abonado = Session("Abonado")

	Session.Abandon
	
	Session("DataConn_ConnectionTimeout")	= 30
	Session("DataConn_CommandTimeout")		= 3600
	Session("DataConn_RuntimeUserName") 	= "altanet"
	Session("DataConn_RuntimePassword") 	= ""
	Session("ColorImagenFondo") = "Imagenes/ImagenDfondo.jpg"
	Session("ImagenFondo")		= "Imagenes/ImagenDfondo.jpg"

	Session("ConexionInicial")			 = "DSN=AG_Sanchez;UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez"
	Session("DataConn_ConnectionString") = "DSN=AG_Sanchez;UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez"
	
	Session("URL_Corporativa") = "www.altagestion.cl"

	Session("IP")		= Request.ServerVariables("REMOTE_ADDR")
	Session("PageSize")	= 12
	
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("ConexionInicial")
	Conn.CommandTimeout = 3600
	cSql = "Exec CON_CierraSesion 0" & Session.SessionID 
	Conn.Execute ( cSql )
	Conn.Close
	Response.Redirect "Autentificacion.asp?Abonado=" & Abonado

%>
