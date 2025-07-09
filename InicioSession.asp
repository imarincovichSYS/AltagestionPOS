<!-- #include file="Scripts/Inc/Cache.Inc" -->
<%
	Cache

	Abonado = Session("Abonado")

	Session.Abandon
	
	Session("DataConn_ConnectionTimeout")	= 30
	Session("DataConn_CommandTimeout")		= 100
	Session("DataConn_RuntimeUserName") 	= "altanet"
	Session("DataConn_RuntimePassword") 	= ""
	Session("ColorImagenFondo") = "Imagenes/ImagenDfondo.jpg"
	Session("ImagenFondo")		= "Imagenes/ImagenDfondo.jpg"

	Session("ConexionInicial")			 = "Provider=MSOLEDBSQL;Password=Vp?T+!mZpJds;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";Database=Sanchez;User ID=AG_Sanchez;TrustServerCertificate=True;Server=SRVSQL01,1433;"
	Session("DataConn_ConnectionString") = "Provider=MSOLEDBSQL;Password=Vp?T+!mZpJds;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";Database=Sanchez;User ID=AG_Sanchez;TrustServerCertificate=True;Server=SRVSQL01,1433;"
	
	Session("URL_Corporativa") = "www.altagestion.cl"

	Session("IP")		= Request.ServerVariables("REMOTE_ADDR")
	Session("PageSize")	= 12
	
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("ConexionInicial")
	Conn.CommandTimeout = 100
	cSql = "Exec CON_CierraSesion 0" & Session.SessionID 
	Conn.Execute ( cSql )
	Conn.Close
	Response.Redirect "Autentificacion.asp?Abonado=" & Abonado

%>
