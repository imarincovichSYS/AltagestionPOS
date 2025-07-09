<!--#include file="../_private/config.asp" -->
<!--#include file="../_private/funciones_generales.asp" -->
<!--#include file="../_private/funciones_sys.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

carpeta = Request.Form("carpeta")
numAduana = Request.Form("numAduana")
documento_respaldo  = Request.Form("documento_respaldo")
Manifiesto  = Request.Form("Manifiesto")

OpenConn

' 
strSQL = "select cfd.Numero_aduana, cf.Manifiesto, Valor = CONVERT( varchar, isNull( cfd.Numero_aduana, 0 ) ) + '_' + isNull( cfd.entidad_comercial, '' ) + '_' + CONVERT( varchar(10), isNull( cfd.fecha_factura, '01/01/1900' ), 103 ) + '_' + CONVERT( varchar, isNull( cfd.monto_final_us$, 0 ) ) + '_' + CONVERT( varchar, isNull( cfd.Numero_factura, 0 ) ) + '_' + CONVERT( varchar(10), isNull( cfd.fecha_aduana, '01/01/1900' ), 103 ) + '_' + CONVERT( varchar, isNull( cfd.Bultos, 0 ) ) + '_' "
strSQL = strSQL & "from carpetas_final cf (nolock), carpetas_final_detalle cfd (nolock) "
strSQL = strSQL & "where carpeta = '" & carpeta & "' "
strSQL = strSQL & "and cf.documento_respaldo = cfd.documento_respaldo "
if documento_respaldo = "R" or documento_respaldo = "DS" then
strSQL = strSQL & "and cfd.Tipo_documento_aduana = '" & documento_respaldo & "' "
end if
strSQL = strSQL & "and cf.anio_mes = cfd.anio_mes "
strSQL = strSQL & "and cf.num_carpeta = cfd.num_carpeta "
if documento_respaldo = "Z" then
strSQL = strSQL & "and id_tipo_factura = 1 "
end if
strSQL = strSQL & "and cfd.Numero_aduana <> 0 "
strSQL = strSQL & "and not exists( "
strSQL = strSQL & " select dnv.Numero_documento_respaldo "
strSQL = strSQL & " from Documentos_no_valorizados dnv (nolock) "
strSQL = strSQL & " WHERE dnv.Empresa = 'SYS' "
strSQL = strSQL & " and dnv.Documento_no_valorizado = 'TCP' "
if documento_respaldo = "R" or documento_respaldo = "DS" then
strSQL = strSQL & " and dnv.Documento_respaldo = cfd.Tipo_documento_aduana "
else
strSQL = strSQL & " and dnv.Documento_respaldo = cf.documento_respaldo "
end if
strSQL = strSQL & " and dnv.Numero_documento_respaldo = cfd.Numero_aduana "
strSQL = strSQL & ") "

'response.write strsql
'response.end
set rs = Conn.Execute(strsql)
if documento_respaldo <> "Z" then
%>
<select OnChange="if(this.value!='')changeNroAduana(this.value);" id="TDSELAduana" name="TDSELAduana" style="width: 70px;">
    <option value=""></option>
    <% do while not rs.eof %>
    <option value="<% = rs( "Valor" ) %>"><% = rs( "Numero_aduana" ) %></option>
    <% rs.movenext
        loop %>
</select>
<% else
    if not rs.eof then
        vNumero_aduana = rs( "Numero_aduana" )
        vValor = rs( "Valor" )
        if isNull( vNumero_aduana ) then vNumero_aduana = ""
        if isNull( vValor ) then vValor = ""

        if cDbl( numAduana ) = 0 then
           Response.write( "S," )
        else
            Response.write( "S," )
            'if cDbl( vNumero_aduana ) <> cDbl( numAduana ) then
            '    Response.write( "S," )
            'else
            '    if vValor = "" then
            '        Response.write( "S," )
            '    else
            '        Response.write( "N,Esta compra ya tiene un numero de aduana asignado" )
            '    end if
            'end if
        end if
    else
        Response.write( "N,No hay Factura de Mercaderia." )
    end if
end if %>
