<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

'OpenConn_Alta_Replica
OpenConn_Alta
session("login") = "13512435"

accion									= Request.Form("accion")
tipo_etiqueta						= Unescape(Request.Form("tipo_etiqueta"))
numero_interno_etiqueta	= Request.Form("numero_interno_etiqueta")

nombre_etiqueta					= Ucase(Trim(Unescape(Request.Form("nombre_etiqueta"))))
detalle_etiqueta					= Trim(Unescape(Request.Form("detalle_etiqueta")))

'ConnAltaRep.BeginTrans
ConnAlta.BeginTrans

If accion = "INSERT" then
	strSQL="insert into etiquetas (fecha, responsable, tipo_etiqueta) values (getdate(), '"&session("login")&"', '"&tipo_etiqueta&"')"
	ConnAlta.Execute(strSQL)
	strSQL="select IDENT_CURRENT('etiquetas')"
	Set rs = ConnAlta.Execute(strSQL)
	nuevo_numero_interno_etiqueta = rs(0)
ElseIf accion = "UPDATE" Then
	'Verificar que el nombre de etiqueta no existe
	strSQL="select nombre_etiqueta from etiquetas where numero_interno_etiqueta<>"&numero_interno_etiqueta&" and nombre_etiqueta='"&nombre_etiqueta&"'"
	set rs= server.CreateObject("ADODB.RECORDSET")
	rs.Open strSQL, ConnAlta, 3, 3
	If Not rs.EOF Then
		strOutput = "{""accion"":""EXISTE"",""valor"":""""}"
		Response.Write strOutput
		Response.End
	End if
	strSQL="update etiquetas set nombre_etiqueta='"&nombre_etiqueta&"', " &_
	              "detalle_etiqueta='"&detalle_etiqueta&"'" &_
				  "where numero_interno_etiqueta="&numero_interno_etiqueta
	ConnAlta.Execute(strSQL)
ElseIf accion = "DELETE" Then
	strSQL="delete from etiquetas where numero_interno_etiqueta=" &numero_interno_etiqueta
	ConnAlta.Execute(strSQL)
End if
if err <> 0 then
	ConnAlta.RollbackTrans
	strOutput = "{""accion"":""ERROR"",""valor"":"""&err.Description&"""}"
else    
	ConnAlta.CommitTrans
	strOutput = "{""accion"":""OK"",""valor"":"""&nuevo_numero_interno_etiqueta&"""}"
end if
Response.Write strOutput
ConnAlta.Close : set ConnAlta = nothing
%>