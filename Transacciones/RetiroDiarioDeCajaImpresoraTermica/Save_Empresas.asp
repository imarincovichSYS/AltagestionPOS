<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then

	msgerror=""
	error=0

Monto_retiro = request("monto_retiro")
'response.write	(request("monto_concepto"))
'response.write	(request("monto_medio"))
'response.end
	
	
		Set ConnManejo_1= Server.CreateObject("ADODB.Connection")
		ConnManejo_1.Open Session( "DataConn_ConnectionString" )
		ConnManejo_1.CommandTimeout = 3600
		

	cSql_1 = "select top 1 num_retiro from	Retiros_cajas where rut_cajero=" +_
          "'"  & session("login") & "' and fecha between convert(datetime, convert(varchar, month(getdate())) + '-'+ convert(varchar, day(getdate())) + '-' + convert(varchar, year(getdate()))) and getdate() order by fecha desc"
  Set RsManejo_1 = ConnManejo_1.Execute( cSQL_1 )
  
  If Not RsManejo_1.EOF Then
	 num_retiro_actual = RsManejo_1("num_retiro")
  End if		



caja_numero = 0
sql = "exec CAJ_Obtener_por_direccion_IP '"&session("IP")&"'"
Set Rs = ConnManejo_1.Execute ( sql )

If Not Rs.Eof then   
   caja_numero = Rs("caja_numero")
end if

Rs.close
set Rs = nothing

		
				Set ConnManejo= Server.CreateObject("ADODB.Connection")
		ConnManejo.Open Session( "DataConn_ConnectionString" )
		ConnManejo.CommandTimeout = 3600
		ConnManejo.BeginTrans
		cSQL	=	"Exec RET_Grabar_Retiro_caja '"	& caja_numero & "', '" 	& +_
												session("login")				& "', '"		& +_
												request("monto_retiro")        & "', '" & +_
												num_retiro_actual+1				& "', '" & +_
												request("monto_concepto")				& "', '" & +_
												request("monto_medio")				& "'"
												

			Set RsManejo = ConnManejo.Execute( cSQL )

			Registros	= RsManejo("Registros")
			Error		= RsManejo("Error")
			id = RsManejo("id")
			
			If Registros > 0 and Error = 0 then
				ConnManejo.CommitTrans				
				msgerror	= "Proceso terminado satisfactoriamente."
			Else
				ConnManejo.RollbackTrans
				msgerror	= "No se puede ingresar/modificar esta empresa."
			End if
			
%>

<%
'Imprimir Retiro en impresora Termica
If Registros > 0 and Error = 0 then
	Dim objXMLHTTP
	Dim url
	Dim respuesta

	' Define la URL que necesitas llamar
	url = "http://"&session("IP")&":8080/phpcaja/docs/retiro.php?id="&id

	' Crea el objeto para realizar la solicitud HTTP
	Set objXMLHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")
	

	' Configura la solicitud HTTP
	objXMLHTTP.Open "GET", url, False

	' Envía la solicitud al servidor
	objXMLHTTP.Send

	' Captura y muestra la respuesta
	'If objXMLHTTP.Status = 200 Then
    
	'end if

	Set objXMLHTTP = Nothing
   
End If

RsManejo.close
set RsManejo = nothing
ConnManejo.close

RsManejo_1.close
set RsManejo_1 = nothing

ConnManejo_1.close

%>

<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
</body>

<script language="JavaScript">
  	parent.top.frames[2].location.href = "Botones_Empresas.asp";
		parent.top.frames[1].location.href = "Inicial_Empresas.asp";
</script>
<%else
	Response.Redirect "../../index.htm"
end if%>
