<%@ Language=VBScript %>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
    NroInterno = Request( "NroInterno" )

    OpenConn

    strSQL = "SELECT * FROM Asientos_contables ac (nolock) WHERE ac.Empresa = 'SYS' and ac.Registro_de_cancelacion = 'S' and ac.Numero_interno_documento_cobrado_o_pagado = " & NroInterno

    set rs = Conn.Execute(strSQL)
    if not rs.EOF then
        Response.write( "<table border='0' cellspacing='0' cellpadding = '0' style='table-layout: fixed;'>" )
        Response.write( "   <tr style='color: #FFFFFF; background-color: #000000;'>" )
        Response.write( "       <td colspan='1' align='center' width=' 200'>Tipo Docto Pago</td>" )
        Response.write( "       <td colspan='1' align='center' width=' 200'>Nro. Docto Pago</td>" )
        Response.write( "       <td colspan='1' align='center' width=' 200'>Fecha Docto Pago</td>" )
        Response.write( "       <td colspan='1' align='center' width='100%'>&nbsp;</td>" )
        Response.write( "   </tr>" )
        do while not rs.eof

        Response.write( "   <tr>" )
        Response.write( "       <td colspan='1' align='center' style='border-top: 0px #FFFFFF none; border-left: 1px #DDDDDD solid; border-bottom: 1px #DDDDDD solid; border-right: 1px #DDDDDD solid; '>" & rs( "Documento_imputado" ) & "</td>" )
        Response.write( "       <td colspan='1' align='center' style='border-top: 0px #FFFFFF none; border-left: 1px #DDDDDD solid; border-bottom: 1px #DDDDDD solid; border-right: 1px #DDDDDD solid; '>" & rs( "Numero_documento_imputado" ) & "</td>" )
        Response.write( "       <td colspan='1' align='center' style='border-top: 0px #FFFFFF none; border-left: 1px #DDDDDD solid; border-bottom: 1px #DDDDDD solid; border-right: 1px #DDDDDD solid; '>" & rs( "Fecha_asiento" ) & "</td>" )
        Response.write( "       <td colspan='1' align='center' style='border-top: 0px #FFFFFF none; border-left: 1px #DDDDDD solid; border-bottom: 1px #DDDDDD solid; border-right: 1px #DDDDDD solid; '>&nbsp;</td>" )
        Response.write( "   </tr>" )

            rs.movenext
        loop
        Response.write( "</table>" )
    end if

    Response.end
%>
