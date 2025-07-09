<!-- #include file="Scripts/Inc/Cache.Inc" -->
<%
	Cache

	Abonado = Session("Abonado")

	Session.Abandon
	session("DataConn_ConnectionTimeout")	= 30
	Session("DataConn_CommandTimeout")		= 3600
	Session("DataConn_RuntimeUserName") 	= "altanet"
	Session("DataConn_RuntimePassword") 	= ""
	Session("ColorImagenFondo") = "Imagenes/ImagenDfondo.jpg"
	Session("ImagenFondo")		= "Imagenes/ImagenDfondo.jpg"

	Session("Abonado")					 = "Sanchez"
	Session("ConexionInicial")			 = "DSN=AG_Sanchez;UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez"
	Session("DataConn_ConnectionString") = "DSN=AG_Sanchez;UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez"
	Session("URL_Corporativa") = "ads2.altagestion.cl"
	Abonado = "Sanchez"

	Session("IP")		= Request.ServerVariables("REMOTE_ADDR")
	Session("PageSize")	= 10

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("ConexionInicial")		'ConexionInicial
	Conn.CommandTimeout = 3600
	cSql = "Exec CON_CierraSesion 0" & Session.SessionID 
	Conn.Execute ( cSql )
	Conn.Close

	aServidor = Split(Request.ServerVariables("SERVER_NAME"),".")
	Servidor  = aServidor(0)
	'Servidor = "http://" & Servidor & ".altagestion.cl/"
	Servidor = "http://pd266/altagestion/sanchez.html"
%>
	<script language="javascript">
		location.href = "<%=Servidor%>"
	</script>
	
