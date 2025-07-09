<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then 

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

    cSql = "Exec PUN_Permite_eliminar_cajera '" & Session("Login") & "'"
    Set Rs = Conn.Execute ( cSql )
    If Not Rs.Eof then
        Session("Elimina_producto") = Rs("Elimina_producto")
    Else
        Session("Elimina_producto") = "N"
    End if
    Rs.Close
    Set Rs = Nothing

    cSql = "Exec PAR_ListaParametros 'RELACIONCOM'"
    Set Rs = Conn.Execute ( cSql )
    If Not Rs.Eof then
        Session("RELACIONCOM") = Rs("Valor_texto")
    Else
        Session("RELACIONCOM") = "Favor pasar a relaciones comerciales."
    End if
    Rs.Close
    Set Rs = Nothing
    
    Conn.Close
%>
<html>
	<head>
		<title>AltaGestion</title>
	</head>

	<script language=javascript>
        parent.top.frames[1].location.href  = "Boleta_PuntoVentaZF.asp"
        parent.Botones.location.href        = "Botones_Boleta_PuntoVentaZF.asp"
	</script>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>
