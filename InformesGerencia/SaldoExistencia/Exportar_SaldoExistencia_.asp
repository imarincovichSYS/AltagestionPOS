<%
    ' http://s02sys.sys.local/altagestion/InformesGerencia/SaldoExistencia/Exportar_SaldoExistencia.asp?servidor=P
    ' http://192.168.30.10/Abonados/Sanchez_PtaArenas/InformesGerencia/SaldoExistencia/Exportar_SaldoExistencia.asp?servidor=P

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
    if servidor = "P" then strConnect = "DSN=AG_Sanchez; UID=AG_Sanchez; PWD=; APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez; LANGUAGE=Spanish;"
    if servidor = "R169" then strConnect = "DSN=AG_Sanchez_R169; UID=AG_Sanchez; PWD=; APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez; LANGUAGE=Spanish;"
    if servidor = "R15" then strConnect = "DSN=AG_Sanchez_R15; UID=AG_Sanchez; PWD=; APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez; LANGUAGE=Spanish;"

    TipoInforme = Request( "TipoInforme" )
    if len( TipoInforme ) = 0 then TipoInforme = "R"
    Agrupado = Request( "Agrupado" )
    if len( Agrupado ) = 0 then Agrupado = "S"
	
    Dim Conn : set Conn = Server.CreateObject("ADODB.Connection")
    Conn.Open strConnect

    ' 
    Dim sFileName
    sFileName = "Saldo Existencia.xls"
    strSQL = "Exec pa_Saldo_Existencia_Fecha "
    set rs = Conn.Execute( strSQL )
    if not rs.eof then
        sFileName = rs( "Nombre_archivo" )
    end if
    rs.close

    '
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-Disposition", "filename=" & sFileName
    Dim sSpreadsheet
    sSpreadsheet = "Rubro"
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

    Response.Write "<x:ExcelWorksheet>" & chr(13) & CHR(10)
    Response.Write "<x:Name>Familia</x:Name>" & chr(13) & CHR(10)
    Response.Write "</x:ExcelWorksheet>" & chr(13) & CHR(10)

    Response.Write "<x:ExcelWorksheet>" & chr(13) & CHR(10)
    Response.Write "<x:Name>SubFamilia</x:Name>" & chr(13) & CHR(10)
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

    strSQL = "Exec pa_Saldo_Existencia_inf "
    strSQL = strSQL & "'" & TipoInforme & "', "
    strSQL = strSQL & "'" & Agrupado & "'"
    set rs = Conn.Execute( strSQL )
%>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
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
<%      if TipoInforme = "R" then %>
<%      if Agrupado = "S" then %>
        <table>
            <tr style='font-family: Arial; font-size: 9px;'>
                <td Align='center' colspan='1'>Grupo</td>
                <td Align='center' colspan='1'>Rubro</td>
                <td Align='center' colspan='1'>Familia</td>
                <td Align='center' colspan='1'>Subfamilia</td>

                <td Align='center' colspan='1'>Entrada</td>
                <td Align='center' colspan='1'>Salida</td>
                <td Align='center' colspan='1'>Saldo UNI</td>
                <td Align='center' colspan='1'>Total US$</td>
            </tr>

<%      do while not rs.eof %>
            <tr style='font-family: Arial; font-size: 9px;'>
                <td Align='center'><% = rs( "Grupo" ) %></td>
                <td Align='center'><% = rs( "Superfamilia" ) %></td>
                <td Align='center'><% = rs( "Familia" ) %></td>
                <td Align='center'><% = rs( "SubFamilia" ) %></td>

                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cantidad_entrada" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cantidad_salida" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Saldo_UNI" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Total_CIF_ADU_US$" ), 7 ) %></td>
            </tr>

<%            k = k +  1
            rs.movenext
        loop %>
        </table>
<%      end if %>

<%      if Agrupado = "F" then %>
        <table>
            <tr style='font-family: Arial; font-size: 9px;'>
                <td Align='center' colspan='1'>Grupo</td>
                <td Align='center' colspan='1'>Rubro</td>
                <td Align='center' colspan='1'>Familia</td>

                <td Align='center' colspan='1'>Entrada</td>
                <td Align='center' colspan='1'>Salida</td>
                <td Align='center' colspan='1'>Saldo UNI</td>
                <td Align='center' colspan='1'>Total US$</td>
            </tr>

<%      do while not rs.eof %>
            <tr style='font-family: Arial; font-size: 9px;'>
                <td Align='center'><% = rs( "Grupo" ) %></td>
                <td Align='center'><% = rs( "Superfamilia" ) %></td>
                <td Align='center'><% = rs( "Familia" ) %></td>

                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cantidad_entrada" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cantidad_salida" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Saldo_UNI" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Total_CIF_ADU_US$" ), 7 ) %></td>
            </tr>

<%            k = k +  1
            rs.movenext
        loop %>
        </table>
<%      end if %>

<%      if Agrupado = "R" then %>
        <table>
            <tr style='font-family: Arial; font-size: 9px;'>
                <td Align='center' colspan='1'>Grupo</td>
                <td Align='center' colspan='1'>Rubro</td>

                <td Align='center' colspan='1'>Entrada</td>
                <td Align='center' colspan='1'>Salida</td>
                <td Align='center' colspan='1'>Saldo UNI</td>
                <td Align='center' colspan='1'>Total US$</td>
            </tr>

<%      do while not rs.eof %>
            <tr style='font-family: Arial; font-size: 9px;'>
                <td Align='center'><% = rs( "Grupo" ) %></td>
                <td Align='center'><% = rs( "Superfamilia" ) %></td>

                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cantidad_entrada" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cantidad_salida" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Saldo_UNI" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Total_CIF_ADU_US$" ), 7 ) %></td>
            </tr>

<%            k = k +  1
            rs.movenext
        loop %>
        </table>
<%      end if %>

<%      if Agrupado = "G" then %>
        <table>
            <tr style='font-family: Arial; font-size: 9px;'>
                <td Align='center' colspan='1'>Grupo</td>

                <td Align='center' colspan='1'>Entrada</td>
                <td Align='center' colspan='1'>Salida</td>
                <td Align='center' colspan='1'>Saldo UNI</td>
                <td Align='center' colspan='1'>Total US$</td>
            </tr>

<%      do while not rs.eof %>
            <tr style='font-family: Arial; font-size: 9px;'>
                <td Align='center'><% = rs( "Grupo" ) %></td>

                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cantidad_entrada" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cantidad_salida" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Saldo_UNI" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Total_CIF_ADU_US$" ), 7 ) %></td>
            </tr>

<%            k = k +  1
            rs.movenext
        loop %>
        </table>
<%      end if %>
<%      end if %>



<%      if TipoInforme = "D" then %>
        <table>
            <tr style='font-family: Arial; font-size: 9px;'>
                <td Align='center' colspan='1'>Grupo</td>
                <td Align='center' colspan='1'>Rubro</td>
                <td Align='center' colspan='1'>Familia</td>
                <td Align='center' colspan='1'>Subfamilia</td>
                <td Align='center' colspan='1'>Producto</td>

                <td Align='center' colspan='1'>Entrada</td>
                <td Align='center' colspan='1'>Salida</td>
                <td Align='center' colspan='1'>Saldo UNI</td>
                <td Align='center' colspan='1'>Costo US$</td>
                <td Align='center' colspan='1'>Total US$</td>
            </tr>

<%      do while not rs.eof %>
            <tr style='font-family: Arial; font-size: 9px;'>
                <td Align='center'><% = rs( "Grupo" ) %></td>
                <td Align='center'><% = rs( "Superfamilia" ) %></td>
                <td Align='center'><% = rs( "Familia" ) %></td>
                <td Align='center'><% = rs( "SubFamilia" ) %></td>
                <td Align='center'><% = rs( "Producto" ) %></td>

                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cantidad_entrada" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Cantidad_salida" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Saldo_UNI" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Costo_CIF_ADU_US$" ), 7 ) %></td>
                <td Align='right' class='FormatNumber_7'><% = FormatNumber( rs( "Total_CIF_ADU_US$" ), 7 ) %></td>
            </tr>

<%            k = k +  1
            rs.movenext
        loop %>
        </table>
<%      end if %>

</body>
</html>
