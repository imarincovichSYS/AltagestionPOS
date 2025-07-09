<%
    ' http://erp.altagestion.cl/Abonados/Sanchez_PtaArenas/WEB/Default.asp

    Dim Fecha: Fecha = date()
    Dim Hora: Hora = replace( time(), ":", "" )

    Dim nAno: nAno = Year( Fecha )
    Dim nMes: nMes = Month( Fecha )
    Dim nDia: nDia = Day( Fecha )

    Dim NameArchivo, URLArchivo
    NameArchivo = "Listado_" & nAno & nMes & nDia & "_" & Hora & ".xls"
    URLArchivo = Server.MapPath( "." ) & "\"

    Nombre_DSN = "AG_Sanchez"
    APP = ""
    WSID = ""
    
    strConn = "DSN=" & Nombre_DSN & ";UID=AG_Sanchez;PWD=;APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez"
    Dim Conn
    set Conn = Server.CreateObject( "ADODB.Connection" )
    Conn.Open strConn
    Conn.CommandTimeout = 3600

    set rs = Conn.Execute( "select top 10 * from _agrupado (nolock) where VA > 1000" )

    Set oXLS = Server.CreateObject( "Scripting.FileSystemObject" )
    Set fXLS = oXLS.OpenTextFile( URLArchivo & NameArchivo, 2, True, 0 )

    fXLS.Write "<table border='1' cellspacin='0' cellpadding='0' style='table-layout: fixed;'>"
    fXLS.Write "<tr valign='top' style='color: #FFFFFF; background-color: #000000;'>"
    fXLS.Write "<td width='  5px' align='center'>&nbsp;</td>"
    fXLS.Write "<td width=' 50px' align='center'>Nro</td>"
    fXLS.Write "<td width='100px' align='center'>Codigo</td>"
    fXLS.Write "<td width='250px' align='left'>Nombre</td>"
    fXLS.Write "<td width='100px' align='right'>Valor</td>"
    fXLS.Write "<td width='100px' align='right'>Valor</td>"
    fXLS.Write "<td width='100px' align='right'>Valor</td>"
    fXLS.Write "<td width=' 100%' align='center'>&nbsp;</td>"
    fXLS.Write "</tr>"

    if not rs.eof then
        do while not rs.eof
            fXLS.Write "<tr valign='top' style='color: #000000; background-color: #FFFFFF;'>"
            fXLS.Write "<td width='  5px' align='center'>&nbsp;</td>"
            fXLS.Write "<td width=' 50px' align='center'>" & rs( "numero_interno_RCP_Correspondiente_a_DVT" ) & "</td>"
            fXLS.Write "<td width='100px' align='center'>" & rs( "Producto" ) & "</td>"
            fXLS.Write "<td width='250px' align='left'>" & rs( "Producto" ) & "</td>"

            fXLS.Write "<td width=' 50px' align='right'>" & rs( "VA" ) & "</td>"
            fXLS.Write "<td width=' 50px' align='right'>" & FormatNumber( rs( "VA" ), 0 ) & "</td>"
            fXLS.Write "<td width=' 50px' align='right'>" & FormatNumber( rs( "VA" ), 2 ) & "</td>"

            fXLS.Write "<td width=' 100%' align='center'>&nbsp;</td>"
            fXLS.Write "</tr>"

            rs.movenext
        loop
    end if

    fXLS.Write "</table>"

    rs.close
    Conn.close
%>
