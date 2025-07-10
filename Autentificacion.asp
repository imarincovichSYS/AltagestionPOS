<html>
<% 

Session.LCID = 2057
%>
<!--#include file="config/load_env.asp" -->
<!--#include file="config/config.asp" -->
<%
Response.Expires = 0 
'Session.Abandon

if Instr(1,Request.ServerVariables( "HTTP_USER_AGENT" ),"PPC;") > 0 Then
	Response.Redirect "Ipaq/Usuario.asp"
else
	Abonado = Request("Abonado")
	Session.Timeout = 480

	session("impresora_FAV") = "\\Esmeralda\IBM" 'IMPRESORA PARA LAS FACTURAS
	session("impresora_CEG") = "\\Esmeralda\IBM" 'IMPRESORA PARA LOS COMPROBANTES DE EGRESO

	session("DataConn_ConnectionTimeout")	= 30
	Session("DataConn_CommandTimeout")		= 100
	Session("DataConn_RuntimeUserName") 	= "altanet"
	Session("DataConn_RuntimePassword") 	= ""
	Session("ColorImagenFondo") = "Imagenes/ImagenDfondo.jpg"
	Session("ImagenFondo")		= "Imagenes/ImagenDfondo.jpg"


'Session("ConexionInicial") = "Provider=MSOLEDBSQL;Password=Vp?T+!mZpJds;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";Database=Sanchez;User ID=AG_Sanchez;TrustServerCertificate=True;Server=SRVSQL01,1433;"
	'Session("DataConn_ConnectionString") = "DSN=AG_Sanchez;UID=AG_Sanchez;PWD=Vp?T+!mZpJds;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez"
''	Session("DataConn_ConnectionString") = "Provider=MSOLEDBSQL;Password=Vp?T+!mZpJds;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";Database=Sanchez;User ID=AG_Sanchez;TrustServerCertificate=True;Server=SRVSQL01,1433;"
	
	
	Session("URL_Corporativa") = "www.altagestion.cl"

	Session("IP")		= Request.ServerVariables("REMOTE_ADDR")
	Session("PageSize")	= 12
	if InStr( 1, Request.ServerVariables( "HTTP_USER_AGENT" ), "MSIE" ) = 0 then
		Session( "Browser" ) = 0	'NetScape
	else
		Session( "Browser" ) = 1	'Explorer
	end if
	Session("descuento_maximo_pago_cuenta") = 20


	SET Conn = Server.CreateObject("ADODB.Connection")
'Response.Write(Session("DataConn_ConnectionString"))
	Conn.Open Session("DataConn_ConnectionString")
'Response.End
	Conn.commandtimeout=3600
	cSQL = "Exec PAR_ListaParametros 'ColBotNormal'"

	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("ColBotNormal") = Ltrim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'FECHULTCIE'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("Fecha_ultimo_cierre") = Ltrim(Rs("VALOR_FECHA"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaCuentasContables 'CCFACXPAG'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("CCFACXPAG") = Ltrim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing
	cSQL = "Exec PAR_ListaCuentasContables 'CCIVAPRV'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("CCIVAPRV") = Ltrim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing
	cSQL = "Exec PAR_ListaCuentasContables 'CCIECPRV'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("CCIECPRV") = Ltrim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'CCNDCXPAG'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("CCNDCXPAG") = Ltrim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'PCTRETHONORA'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("PCTRETHONORA") = Ltrim(Rs("Valor_numerico"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'ColTxtBotNor'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("ColTxtBotNor") = Ltrim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaCuentasContables 'CCVTACLI'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("Cuenta_contable_para_neto") = trim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'LP_BASE'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		session("Convenio_base") = trim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'PCTGEIVA'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("PCTGEIVA") = Rs("VALOR_NUMERICO")
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'ColBotOver'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("ColBotOver") = Ltrim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'ColTxtBotOvr'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("ColTxtBotOvr") = Ltrim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'ImagenFondo'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("ImagenFondo") = Ltrim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'SimbOrden'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("Simbolo") = "<img border=0 width=15 height=15 src='../../" & Ltrim(Rs("VALOR_TEXTO")) & "'>"
	end if
	Rs.Close
	Set Rs = Nothing
			
	cSQL = "Exec PAR_ListaParametros 'NumLinMant'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("PageSize") = cLng(Rs("VALOR_NUMERICO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'NROLINEAS'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("NroLineasDetalles") = cLng(Rs("VALOR_NUMERICO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'BLQRESAGE'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("BLQRESAGE") = cLng(Rs("VALOR_NUMERICO"))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'SOLORESTAURA'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("SOLORESTAURA") = Ucase(Trim(Rs("VALOR_TEXTO")))
	end if
	Rs.Close
	Set Rs = Nothing

	cSQL = "Exec PAR_ListaParametros 'SUBFAMHAB'"
	SET Rs	=	Conn.Execute( cSQL )
	if Not Rs.Eof then
		Session("SUBFAMHAB") = Trim(Rs("VALOR_TEXTO"))
	end if
	Rs.Close
	Set Rs = Nothing

	Conn.close

	'*****************************************
		website = Request.ServerVariables("SERVER_NAME")
		   websystem = "AltaGestion"
		   webtitle = "AltaGestion, el primer sistema de control y gestión por internet."
		Session("websystem") = websystem
	'*****************************************
	'Response.Redirect "index1.htm" se cae en el DELL
	%>
	<script language="javascript">
		location.href="index1.asp"
	</script>
<%end if%>
</html>
