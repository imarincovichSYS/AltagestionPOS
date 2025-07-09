<!--#include file="../../Scripts/Inc/Cache.inc" -->
<!--#include file="../../Scripts/ASP/aspJSON1.17.asp" -->
<%
Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeout = 3600

Dim TBKJson: Set TBKJson = New aspJSON

Error = "N"
MensajeError = ""

Numero_documento_valorizado_BOV = Request("Numero_documento_valorizado")
Documento_valorizado_BOV_o_FAV = Request("Documento_valorizado_BOV_o_FAV")

'sql = "exec DOV_Lista_DocumentosVenta '" & session("Empresa_usuario") & "','" & Documento_valorizado_BOV_o_FAV & "'," & Numero_documento_valorizado_BOV
sql = "exec DOV_Lista_DocumentosVenta 'SYS','" & Documento_valorizado_BOV_o_FAV & "'," & Numero_documento_valorizado_BOV
set rs = conn.execute(sql)
Numero_interno_documento_valorizado_DOCVTA = rs("Numero_interno_documento_valorizado")
Numero_documento_valorizado_DOCVTA = Numero_documento_valorizado_BOV
Numero_despacho_de_venta = rs("Numero_despacho_de_venta")
rs.close
set rs = nothing

RespuestaTBK = request("RespTBK")

' Archivo
if TRUE then
	srvrMapPath = Server.MapPath("/")       ' D:\inetpub\wwwroot
	urlArchivo = srvrMapPath & "\LogTBK\"

	set oFile = Server.CreateObject( "Scripting.FileSystemObject" )
	NombreArchivo = "Error_" & Numero_despacho_de_venta & "_" & Year(date()) & Right("00" & Month(date()), 2) & Right("00" & Day(date()), 2) & "_" & Replace(time(), ":","") & ".txt"

	Set oFileCSV = oFile.OpenTextFile(urlArchivo + NombreArchivo, 2, True, 0)
	oFileCSV.Write RespuestaTBK
	oFileCSV.Write chr(13) & chr(10)
	oFileCSV.Close				
end if

RespuestaTBK = replace(RespuestaTBK,"\","")
RespuestaTBK = replace(RespuestaTBK,"""{","{")
RespuestaTBK = replace(RespuestaTBK,"}""","}")
RespuestaTBK = "{""TBK"":"& RespuestaTBK &"}"

TBKJson.loadJSON(RespuestaTBK)

Conn.BeginTrans

For Each Venta In TBKJson.data("TBK")
	if Venta = "Result" then
		Set this = TBKJson.data("TBK").item(Venta)

		cSql = "Exec DOV_Pago_POS_TBK_temporal "
		cSql = cSql & "0" & Numero_despacho_de_venta & ", "
		cSql = cSql & "0" & this.item("Ticket") & ", "
		cSql = cSql & "'" & this.item("AuthorizationCode") & "', "
		cSql = cSql & "0" & this.item("Amount") & ", "
		cSql = cSql & "0" & this.item("SharesNumber") & ", "
		cSql = cSql & "0" & this.item("SharesAmount") & ", "
		cSql = cSql & "0" & this.item("Last4Digits") & ", "
		cSql = cSql & "0" & this.item("OperationNumber") & ", "
		cSql = cSql & "'" & this.item("CardType") & "', "
		cSql = cSql & "'" & this.item("AccountingDate") & "', "
		cSql = cSql & "'" & this.item("AccountNumber") & "', "
		cSql = cSql & "'" & this.item("CardBrand") & "', "
		cSql = cSql & "'" & this.item("RealDate") & "', "
		cSql = cSql & "0" & this.item("EmployeeId") & ", "
		cSql = cSql & "0" & this.item("Tip") & ", "
		cSql = cSql & "'" & this.item("CommerceCode") & "', "
		cSql = cSql & "'" & this.item("TerminalId") & "', "
		cSql = cSql & "'" & this.item("Response") & "', "
		cSql = cSql & "'" & this.item("FunctionCode") &  "', "
		cSql = cSql & "'" & this.item("ResponseMessage") & "', "
		cSql = cSql & "0" & this.item("ResponseCode") & ", "
		cSql = cSql & "'" & this.item("Success") & "' "
		
		Conn.Execute( cSql )
	else
		exit for
	end if
Next

if Conn.Errors.Count <> 0 then
	Error = "S"
	MensajeError = Err.Description
	Log_error sql , Err.Description 	
end if

if Error = "N" then
	Conn.CommitTrans
	Response.write("OK")	
else
	Conn.RollbackTrans	
	Response.Write(Error & "|" & MensajeError)
end if
'Conn.close()
response.End()
%>