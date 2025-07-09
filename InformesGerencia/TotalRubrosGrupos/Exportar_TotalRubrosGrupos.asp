<%
    function Get_Fecha_Formato_YYYY_MM_DD(v_fecha)
      c_dia = day(cdate(v_fecha))
      c_mes = month(cdate(v_fecha))
      c_anio = year(cdate(v_fecha))
      Get_Fecha_Formato_YYYY_MM_DD = c_anio&"/"&Lpad(c_mes,2,0)&"/"&Lpad(c_dia,2,0)
    end function

	Dim RutaProyecto, RutaInf, version_sis
	version_sis   = "v2.0"
	nom_proyecto  = "AltaGestion"
	StrSite       = mid(Request.ServerVariables("SCRIPT_NAME"),1,instr(mid(Request.ServerVariables("SCRIPT_NAME"), 2), "/")+1)
	RutaProyecto  = "http://" &Request.serverVariables("Server_Name")& StrSite
	RutaInf       = "/altagestion/tmp/"
	'Nombre_DSN    = "AG_Sanchez" 'BD oficial del servidor
	APP = Session("Nombre_Aplicacion") & "(" & session("login") & ")"
	WSID = Session("Login") & " (" & Request.ServerVariables("REMOTE_ADDR") & ")"

    servidor = Request( "servidor" )
    if servidor = "P" then strConnect = "DSN=AG_Sanchez; UID=AG_Sanchez; PWD=Vp?T+!mZpJds; APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez; LANGUAGE=Spanish;"
    if servidor = "Replica" then strConnect = "DSN=Replica; UID=AG_Sanchez; PWD=Vp?T+!mZpJds; APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez; LANGUAGE=Spanish;"
    if servidor = "Test" then strConnect = "DSN=Test; UID=AG_Sanchez; PWD=Vp?T+!mZpJds; APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez; LANGUAGE=Spanish;"
    Dim Conn : set Conn = Server.CreateObject("ADODB.Connection")

    '
    v_fecha = mid( now(), 1, 10 )
    c_dia = day(cdate(v_fecha))
    c_mes = month(cdate(v_fecha))
    c_anio = year(cdate(v_fecha))
    if cDbl( c_mes ) - 1 <= 0 then
        c_anio = cDbl(c_anio) -  1
        c_mes = 12
        c_dia = 31
    else
        c_mes = cDbl(c_mes) -  1
    end if
    if cDbl( c_mes ) = 1 then c_dia = 31
    if cDbl( c_mes ) = 2 then c_dia = 28
    if cDbl( c_mes ) = 3 then c_dia = 31
    if cDbl( c_mes ) = 4 then c_dia = 30
    if cDbl( c_mes ) = 5 then c_dia = 31
    if cDbl( c_mes ) = 6 then c_dia = 30
    if cDbl( c_mes ) = 7 then c_dia = 31
    if cDbl( c_mes ) = 8 then c_dia = 31
    if cDbl( c_mes ) = 9 then c_dia = 30
    if cDbl( c_mes ) = 10 then c_dia = 31
    if cDbl( c_mes ) = 11 then c_dia = 30
    if cDbl( c_mes ) = 12 then c_dia = 31

    if cDbl(c_dia) < 10 then
        c_dia = "0" & c_dia
    end if
    if cDbl(c_mes) < 10 then
        c_mes = "0" & c_mes
    end if
    fechaArchivo = c_anio & "-" & c_mes & "-" & c_dia
    Dim sFileName
    sFileName = "Totales x Rubro x Grupo " & fechaArchivo & ".xls"

    '
    Conn.Open strConnect
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-Disposition", "filename=" & sFileName
    Dim sSpreadsheet
    sSpreadsheet = "Totales x Rubro x Grupo"
    Response.Write "<html xmlns:x=""urn:schemas-microsoft-com:office:excel"">" & chr(13) & CHR(10)
    Response.Write "<head>" & chr(13) & CHR(10)
    Response.Write "<!--[if gte mso 9]><xml>" & chr(13) & CHR(10)
    Response.Write "<x:ExcelWorkbook>" & chr(13) & CHR(10)
    ' Primera Hoja
    Response.Write "<x:ExcelWorksheets>" & chr(13) & CHR(10)
    Response.Write "<x:ExcelWorksheet>" & chr(13) & CHR(10)
    Response.Write "<x:Name>" & sSpreadsheet & "</x:Name>" & chr(13) & CHR(10)
    Response.Write "<x:WorksheetOptions>" & chr(13) & CHR(10)
    Response.Write "<x:Print>" & chr(13) & CHR(10)
    Response.Write "<x:ValidPrinterInfo/>" & chr(13) & CHR(10)
    Response.Write "</x:Print>" & chr(13) & CHR(10)
    Response.Write "</x:WorksheetOptions>" & chr(13) & CHR(10)
    Response.Write "</x:ExcelWorksheet>" & chr(13) & CHR(10)

    Response.Write "</x:ExcelWorksheets>" & chr(13) & CHR(10)
    Response.Write "</x:ExcelWorkbook>" & chr(13) & CHR(10)
    Response.Write "</xml>" & chr(13) & CHR(10)
    Response.Write "<![endif]--> " & chr(13) & CHR(10)
    response.write "<style>" & chr(13) & CHR(10)
    response.write ".textclass{mso-number-format:\@;}" & chr(13) & CHR(10)
    response.write "</style>" & chr(13) & CHR(10)
    Response.Write "</head>" & chr(13) & CHR(10)
    Response.Write "<body>" & chr(13) & CHR(10)

    strSQL = "Exec Total_x_Rubro_x_Grupo_inf "
    set rs = Conn.Execute( strSQL )
%>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns="http://www.w3.org/TR/REC-html40">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <meta name="ProgId" content="Excel.Sheet">
    <meta name="Generator" content="Microsoft Excel 10">
    <!--
            [if gte mso 9]>
                <xml>
                    <o:DocumentProperties>
                    <o:LastAuthor>ALTAGESTION</o:LastAuthor>
                    <o:LastPrinted>2011-07-02T07:25:56Z</o:LastPrinted>
                    <o:Created>2011-07-02T07:26:08Z</o:Created>
                    <o:LastSaved>2011-07-02T07:30:14Z</o:LastSaved>
                    <o:Version>11.5606</o:Version>
                    </o:DocumentProperties>
                </xml>
            <![endif]
        -->
    <style>
            <!--table
            {
                mso-displayed-decimal-separator:"\.";
	            mso-displayed-thousand-separator:"\,";
	        }
            @page
	        {
            <%if para = "" then%>
	            margin:.4in 0in 0in 1.1in;
            <%else%>
                margin:0in 0in 0in 0in;
            <%end if%>
	            mso-header-margin:0in;
	            mso-footer-margin:0in;
            <%if para = "" then%>
	            mso-page-orientation:landscape;
	        <%end if%>}
            -->
            
            .FormatNumber_7{
              mso-number-format:'#,##0.0000000';
            }

            .FormatNumber_4{
              mso-number-format:'#,##0.0000';
            }

            .FormatNumber_2{
              mso-number-format:'#,##0.00';
            }
            .FormatNumber_0{
              mso-number-format:'#,##0';
            }
            
        </style>
</head>
<body leftmargin="0px" topmargin="0px" rightmargin="0px" bottommargin="0px">
        <table>
        <tr style='font-family: MS Sans h; font-size: 12px;'>
        <td Align='center' colspan='1'>Grupo</td>
        <td Align='center' colspan='1'>Rubro</td>
        <td Align='center' colspan='1'>Año</td>
        <td Align='center' colspan='1'>Mes</td>
        <td Align='center' colspan='1'>Lin</td>
        <td Align='center' colspan='1'>QMerc</td>

        <td Align='center' colspan='1'>Total $</td>
        <td Align='center' colspan='1'>Neto $</td>
        <td Align='center' colspan='1'>Impto. $</td>
        <td Align='center' colspan='1'>ILA $</td>
        <td Align='center' colspan='1'>Perdida $</td>

        <td Align='center' colspan='1'>Neto US$</td>
        <td Align='center' colspan='1'>Cif Adu US$</td>
        <td Align='center' colspan='1'>CPA US$</td>
        <td Align='center' colspan='1'>Compra US$</td>
        </tr>

<%      do while not rs.eof %>
            <tr style='font-family: MS Sans Serif; font-size: 12px;'>
            <td Align='center'><% = rs( "Grupo" ) %></td>
            <td Align='center'><% = rs( "Rubro" ) %></td>
            <td Align='center'><% = rs( "Año" ) %></td>
            <td Align='center'><% = rs( "Mes" ) %></td>

            <td Align='center'><% = rs( "Lineas" ) %></td>
            <td Align='center'><% = rs( "Q_Merc" ) %></td>

            <td Align='right' class='FormatNumber_0'><% = FormatNumber( rs( "Total_$" ), 0 ) %></td>
            <td Align='right' class='FormatNumber_0'><% = FormatNumber( rs( "Neto_$" ), 7 ) %></td>
            <td Align='right' class='FormatNumber_0'><% = FormatNumber( rs( "Impto._$" ), 0 ) %></td>
            <td Align='right' class='FormatNumber_0'><% = FormatNumber( rs( "ILA_$" ), 0 ) %></td>
            <td Align='right' class='FormatNumber_0'><% = FormatNumber( rs( "Perdida_$" ), 0 ) %></td>

            <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Neto_US$" ), 7 ) %></td>
            <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cif_Adu_US$" ), 7 ) %></td>
            <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "CPA_US$" ), 7 ) %></td>
            <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Compra_US$" ), 7 ) %></td>
            </tr>

<%            k = k +  1
            rs.movenext
        loop %>
        </table>
</body>
</html>
