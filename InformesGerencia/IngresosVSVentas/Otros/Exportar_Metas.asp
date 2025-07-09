<!--#include file="configALT.asp" -->
<%
    OpenConn
    strSQL = "Exec Metas_Mensual_inf "
    strSQL = strSQL & "Null, 'S' "
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    set rs = Conn.Execute( strSQL )
    'Response.write( strSQL & "<br>" )
    Fecha_Informe = rs( "Fecha" )
    Fecha_Informe = replace( Fecha_Informe, "/", "" )
    Fecha_Informe = replace( Fecha_Informe, "-", "" )
    
    Dia_0 = rs( "Dia_0" )
    Dia_1 = rs( "Dia_1" )
    Dia_2 = rs( "Dia_2" )

    Doc_0 = rs( "Docs_0" )
    Doc_1 = rs( "Docs_1" )
    Doc_2 = rs( "Docs_2" )

    rs.close
    set rs = Nothing


    sFileName = "Metas_Mensual_" & Fecha_Informe & ".xls"
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-Disposition", "filename=" & sFileName
    Dim sSpreadsheet
    sSpreadsheet = "Metas Mensual"
    Response.Write "<html xmlns:x=""urn:schemas-microsoft-com:office:excel"">"
    Response.Write "<head>"
    Response.Write "<!--[if gte mso 9]><xml>"
    Response.Write "<x:ExcelWorkbook>"
    ' Primera Hoja
    Response.Write "<x:ExcelWorksheets>"
    Response.Write "<x:ExcelWorksheet>"
    Response.Write "<x:Name>" & sSpreadsheet & "</x:Name>"
    Response.Write "<x:WorksheetOptions>"
    Response.Write "<x:Print>"
    Response.Write "<x:ValidPrinterInfo/>"
    Response.Write "</x:Print>"
    Response.Write "</x:WorksheetOptions>"
    Response.Write "</x:ExcelWorksheet>" 

    ' Segunda Hoja
    IF FALSE THEN
    Dim sSsheet
    sSsheet = "excel3.htm"
    Response.Write "<x:ExcelWorksheet>"
    Response.Write "<x:Name>" & sSpreadsheet & "2</x:Name>" 
    Response.write "<x:WorksheetSource HRef=" & sSsheet & "/>"
    Response.Write "<x:WorksheetOptions>"
    Response.Write "<x:Print>"
    Response.Write "<x:ValidPrinterInfo/>"
    Response.Write "</x:Print>"
    Response.Write "</x:WorksheetOptions>"
    Response.Write "</x:ExcelWorksheet>"
    END IF

    IF FALSE THEN
    ' Tercera hoja
    sSsheet = "excel4.htm"
    Response.Write "<x:ExcelWorksheet>"
    Response.Write "<x:Name>" & sSpreadsheet & "3</x:Name>"
    Response.write "<x:WorksheetSource HRef=" & sSsheet & "/>"
    Response.Write "<x:WorksheetOptions>"
    Response.Write "<x:Print>"
    Response.Write "<x:ValidPrinterInfo/>"
    Response.Write "</x:Print>"
    Response.Write "</x:WorksheetOptions>"
    Response.Write "</x:ExcelWorksheet>"
    END IF

    Response.Write "</x:ExcelWorksheets>"
    Response.Write "</x:ExcelWorkbook>"
    Response.Write "</xml>"
    Response.Write "<![endif]--> "
    response.write "<style>"
    response.write ".textclass{mso-number-format:\@;}"
    response.write "</style>"
    Response.Write "</head>"
    Response.Write "<body>"

    strSQL = "Exec Metas_Mensual_inf "
    strSQL = strSQL & "Null "
    set rs = Conn.Execute( strSQL )
    if not rs.eof then


Response.write("        <table>" )
Response.write("            <tr style='font-family: Arial; font-size: 9px;'>" )
Response.write("                <td Align='center' colspan='3'>&nbsp;</td>" )
Response.write("                <td Align='center' colspan='2'><B>Días " & Dia_0 & " - " & Dia_1 & " (US$)</B></td>" )
Response.write("                <td Align='center' colspan='2'><B>Doc: " & Doc_0 & "</B></td>" )
Response.write("                <td Align='center' colspan='2'><B>Día " & Dia_1 & " (US$)</B></td>" )
Response.write("                <td Align='center' colspan='2'><B>Doc: " & Doc_1 & "</B></td>" )
Response.write("                <td Align='center' colspan='2'><B>Día " & Dia_2 & " (US$)</B></td>" )
Response.write("                <td Align='center' colspan='2'><B>Doc: " & Doc_2 & "</B></td>" )
Response.write("                <td Align='center' colspan='5'><B>(US$)</B></td>" )
Response.write("                <td Align='center' colspan='5'><B>Tránsito (US$)</B></td>" )
Response.write("                <td Align='center' colspan='2'><B>(US$)</B></td>" )
Response.write("                <td Align='center' colspan='3'><B>Q.Merc (US$)</B></td>" )
Response.write("                <td Align='center' colspan='3'><B>Líneas</B></td>" )
Response.write("                <td Align='center' colspan='5'><B>Días " & Dia_0 & " al " & Dia_1 & " ($)</B></td>" )
Response.write("                <td Align='center' colspan='5'><B>Día " & Dia_1 & " ($)</B></td>" )
Response.write("                <td Align='center' colspan='5'><B>Día " & Dia_2 & " ($)</B></td>" )
Response.write("                <td Align='center' colspan='3'><B>% Líneas</B></td>" )
Response.write("            </tr>" )
Response.write("            <tr style='font-family: Arial; font-size: 9px;' >" )
Response.write("                <td Align='center'><B>Grupo</B></td>" )
Response.write("            	<td Align='center'><B>Rubro</B></td>" )
Response.write("            	<td Align='center'><B>Nombre</B></td>" )

Response.write("            	<td Align='center'><B>Neto</B></td>" )
Response.write("		        <td Align='center'><B>CifA</B></td>" )
Response.write("            	<td Align='center'><B>CPA</B></td>" )
Response.write("            	<td Align='center'><B>%</B></td>" )

Response.write("            	<td Align='center'><B>Neto</B></td>" )
Response.write("		        <td Align='center'><B>CifA</B></td>" )
Response.write("            	<td Align='center'><B>CPA</B></td>" )
Response.write("            	<td Align='center'><B>%</B></td>" )

Response.write("            	<td Align='center'><B>Neto</B></td>" )
Response.write("		        <td Align='center'><B>CifA</B></td>" )
Response.write("            	<td Align='center'><B>CPA</B></td>" )
Response.write("            	<td Align='center'><B>%</B></td>" )

Response.write("            	<td Align='center'><B>Meta</B></td>" )
Response.write("            	<td Align='center'><B>% Log</B></td>" )
Response.write("            	<td Align='center'><B>Proyectado</B></td>" )
Response.write("            	<td Align='center'><B>Compras</B></td>" )

Response.write("            	<td Align='center'><B>Exi. Act.</B></td>" )

Response.write("	     		<td Align='center'><B>Mes Ant</B></td>" )		
Response.write("	     		<td Align='center'><B>Mes</B></td>" )		
Response.write("            	<td Align='center'><B>Mes+1</B></td>" )
Response.write("                <td Align='center'><B>Mes+2</B></td>" )
Response.write("            	<td Align='center'><B>Futuro</B></td>" )

Response.write("            	<td Align='center'><B>CifOri</B></td>" )

Response.write("		        <td Align='center'><B>Exi Mes</B></td>" )
Response.write("		        <td Align='center'><B>Mes</B></td>" )
Response.write("		        <td Align='center'><B>" & Dia_1 & "</B></td>" )
Response.write("		        <td Align='center'><B>" & Dia_2 & "</B></td>" )
Response.write("		        <td Align='center'><B>Mes</B></td>" )
Response.write("		        <td Align='center'><B>" & Dia_1 & "</B></td>" )
Response.write("		        <td Align='center'><B>" & Dia_2 & "</B></td>" )

Response.write("            	<td Align='center'><B>Total</B></td>" )
Response.write("            	<td Align='center'><B>Neto</B></td>" )
Response.write("                <td Align='center'><B>Impto</B></td>  " )  
Response.write("                <td Align='center'><B>Ila</B></td>      " )
Response.write("                <td Align='center'><B>DIH</B></td>    " )

Response.write("            	<td Align='center'><B>Total</B></td>" )
Response.write("            	<td Align='center'><B>Neto</B></td>    " )        		
Response.write("                <td Align='center'><B>Impto</B></td>    " )
Response.write("                <td Align='center'><B>Ila</B></td>      " )
Response.write("                <td Align='center'><B>DIH</B></td>    " )

Response.write("            	<td Align='center'><B>Total</B></td>" )
Response.write("            	<td Align='center'><B>Neto</B></td>    " )        		
Response.write("                <td Align='center'><B>Impto</B></td>    " )
Response.write("                <td Align='center'><B>Ila</B></td>      " )
Response.write("                <td Align='center'><B>DIH</B></td>    " )

Response.write("                <td Align='center'><B>Mes</B></td>    " )
Response.write("                <td Align='center'><B>" & Dia_1 & "</B></td>    " )
Response.write("                <td Align='center'><B>" & Dia_2 & "</B></td>    " )
Response.write("            </tr>" )

            bgcolor= "#FFFFFF"
            k = 0
            do while not rs.eof
                saveGrupo = rs( "Grupo" )

            	Neto_0 = 0
		        CifA_0 = 0
            	CPA_0  = 0

            	Neto_1 = 0
		        CifA_1 = 0
            	CPA_1  = 0

            	Neto_2 = 0
		        CifA_2 = 0
            	CPA_2  = 0

            	Metas_Mes = 0
            	Proyectado = 0
            	Compras = 0

            	Exi_Act = 0

	     		Tto_Mes_A = 0
	     		Tto_Mes_0 = 0
            	Tto_Mes_1 = 0
                Tto_Mes_2 = 0
            	Tto_Fut = 0

            	CifOri = 0

		        Exi_Mes_1 = 0
		        Q_Merc_0 = 0
		        Q_Merc_1 = 0
		        Q_Merc_2 = 0
		        Lin_0 = 0
		        Lin_1 = 0
		        Lin_2 = 0

            	Total_0 = 0
            	Peso_0  = 0
                Impto_0 = 0
                ILA_0   = 0
                DIH_0   = 0

            	Total_1 = 0
            	Peso_1  = 0
                Impto_1 = 0
                ILA_1   = 0
                DIH_1   = 0

            	Total_2 = 0
            	Peso_2  = 0
                Impto_2 = 0
                ILA_2   = 0
                DIH_2   = 0
                do while saveGrupo = rs( "Grupo" )

            	    Neto_0 = Neto_0 + cDbl( rs( "Neto_US$" ) )
		            CifA_0 = CifA_0 + cDbl( rs( "CifA_US$" ) )
            	    CPA_0  = CPA_0  + cDbl( rs( "CPA_US$" ) )

            	    Neto_1 = Neto_1 + cDbl( rs( "Neto_1" ) )
		            CifA_1 = CifA_1 + cDbl( rs( "CifA_1" ) )
            	    CPA_1  = CPA_1  + cDbl( rs( "CPA_1" ) )

            	    Neto_2 = Neto_2 + cDbl( rs( "Neto_2" ) )
		            CifA_2 = CifA_2 + cDbl( rs( "CifA_2" ) )
            	    CPA_2  = CPA_2  + cDbl( rs( "CPA_2" ) )

            	    Metas_Mes = Metas_Mes + cDbl( rs( "Metas_Mes" ) )
            	    Proyectado = Proyectado + cDbl( rs( "Proyectado" ) )
            	    Compras = Compras + cDbl( rs( "Compras" ) )

            	    Exi_Act = Exi_Act + cDbl( rs( "Exi_Act" ) )

	     		    Tto_Mes_A = Tto_Mes_A + cDbl( rs( "Tto_Mes_Ant" ) )
	     		    Tto_Mes_0 = Tto_Mes_0 + cDbl( rs( "Tto_Mes" ) )
            	    Tto_Mes_1 = Tto_Mes_1 + cDbl( rs( "Tto_Mes_1" ) )
                    Tto_Mes_2 = Tto_Mes_2 + cDbl( rs( "Tto_Mes_2" ) )
            	    Tto_Fut = Tto_Fut + cDbl( rs( "Tto_Fut" ) )

            	    CifOri = CifOri + cDbl( rs( "CifOri_US$" ) )

		            Exi_Mes_1 = Exi_Mes_1 + cDbl( rs( "Exi_Mes_1" ) )
		            Q_Merc_0 = Q_Merc_0 + cDbl( rs( "Q_Merc" ) )
		            Q_Merc_1 = Q_Merc_1 + cDbl( rs( "Q_Merc_1" ) )
		            Q_Merc_2 = Q_Merc_2 + cDbl( rs( "Q_Merc_2" ) )
		            Lin_0 = Lin_0 + cDbl( rs( "Lin" ) )
		            Lin_1 = Lin_1 + cDbl( rs( "Lin_1" ) )
		            Lin_2 = Lin_2 + cDbl( rs( "Lin_2" ) )

            	    Total_0 = Total_0 + cDbl( rs( "Total_$" ) )
            	    Peso_0  = Peso_0  + cDbl( rs( "Neto_$" ) )
                    Impto_0 = Impto_0 + cDbl( rs( "Impto_$" ) )
                    ILA_0   = ILA_0   + cDbl( rs( "ILA_$" ) )
                    DIH_0   = DIH_0   + cDbl( rs( "DIH_$" ) )

            	    Total_1 = Total_1 + cDbl( rs( "Total_$_1" ) )
            	    Peso_1  = Peso_1  + cDbl( rs( "Neto_$_1" ) )
                    Impto_1 = Impto_1 + cDbl( rs( "Impto_$_1" ) )
                    ILA_1   = ILA_1   + cDbl( rs( "ILA_$_1" ) )
                    DIH_1   = DIH_1   + cDbl( rs( "DIH_$_1" ) )

            	    Total_2 = Total_2 + cDbl( rs( "Total_$_2" ) )
            	    Peso_2  = Peso_2  + cDbl( rs( "Neto_$_2" ) )
                    Impto_2 = Impto_2 + cDbl( rs( "Impto_$_2" ) )
                    ILA_2   = ILA_2   + cDbl( rs( "ILA_$_2" ) )
                    DIH_2   = DIH_2   + cDbl( rs( "DIH_$_2" ) )


                    ' Totales
            	    tNeto_0 = cDbl( tNeto_0 ) + cDbl( rs( "Neto_US$" ) )
		            tCifA_0 = cDbl( tCifA_0 ) + cDbl( rs( "CifA_US$" ) )
            	    tCPA_0  = cDbl( tCPA_0 ) + cDbl( rs( "CPA_US$" ) )

            	    tNeto_1 = cDbl( tNeto_1 ) + cDbl( rs( "Neto_1" ) )
		            tCifA_1 = cDbl( tCifA_1 ) + cDbl( rs( "CifA_1" ) )
            	    tCPA_1  = cDbl( tCPA_1 ) + cDbl( rs( "CPA_1" ) )

            	    tNeto_2 = cDbl( tNeto_2 ) + cDbl( rs( "Neto_2" ) )
		            tCifA_2 = cDbl( tCifA_2 ) + cDbl( rs( "CifA_2" ) )
            	    tCPA_2  = cDbl( tCPA_2 ) + cDbl( rs( "CPA_2" ) )

            	    tMetas_Mes  = cDbl( tMetas_Mes ) + cDbl( rs( "Metas_Mes" ) )
            	    tProyectado = cDbl( tProyectado ) + cDbl( rs( "Proyectado" ) )
            	    tCompras    = cDbl( tCompras ) + cDbl( rs( "Compras" ) )

            	    tExi_Act = cDbl( tExi_Act ) + cDbl( rs( "Exi_Act" ) )

	     		    tTto_Mes_A = cDbl( tTto_Mes_A ) + cDbl( rs( "Tto_Mes_Ant" ) )
	     		    tTto_Mes_0 = cDbl( tTto_Mes_0 ) + cDbl( rs( "Tto_Mes" ) )
            	    tTto_Mes_1 = cDbl( tTto_Mes_1 ) + cDbl( rs( "Tto_Mes_1" ) )
                    tTto_Mes_2 = cDbl( tTto_Mes_2 ) + cDbl( rs( "Tto_Mes_2" ) )
            	    tTto_Fut   = cDbl( tTto_Fut ) + cDbl( rs( "Tto_Fut" ) )

            	    tCifOri = cDbl( tCifOri ) + cDbl( rs( "CifOri_US$" ) )

		            tExi_Mes_1 = cDbl( tExi_Mes_1 ) + cDbl( rs( "Exi_Mes_1" ) )
		            tQ_Merc_0 = cDbl( tQ_Merc_0 ) + cDbl( rs( "Q_Merc" ) )
		            tQ_Merc_1 = cDbl( tQ_Merc_1 ) + cDbl( rs( "Q_Merc_1" ) )
		            tQ_Merc_2 = cDbl( tQ_Merc_2 ) + cDbl( rs( "Q_Merc_2" ) )
		            tLin_0 = cDbl( tLin_0 ) + cDbl( rs( "Lin" ) )
		            tLin_1 = cDbl( tLin_1 ) + cDbl( rs( "Lin_1" ) )
		            tLin_2 = cDbl( tLin_2 ) + cDbl( rs( "Lin_2" ) )

            	    tTotal_0 = cDbl( tTotal_0 ) + cDbl( rs( "Total_$" ) )
            	    tPeso_0  = cDbl( tPeso_0 ) + cDbl( rs( "Neto_$" ) )
                    tImpto_0 = cDbl( tImpto_0 ) + cDbl( rs( "Impto_$" ) )
                    tILA_0   = cDbl( tILA_0 ) + cDbl( rs( "ILA_$" ) )
                    tDIH_0   = cDbl( tDIH_0 ) + cDbl( rs( "DIH_$" ) )

            	    tTotal_1 = cDbl( tTotal_1 ) + cDbl( rs( "Total_$_1" ) )
            	    tPeso_1  = cDbl( tPeso_1 ) + cDbl( rs( "Neto_$_1" ) )
                    tImpto_1 = cDbl( tImpto_1 ) + cDbl( rs( "Impto_$_1" ) )
                    tILA_1   = cDbl( tILA_1 ) + cDbl( rs( "ILA_$_1" ) )
                    tDIH_1   = cDbl( tDIH_1 ) + cDbl( rs( "DIH_$_1" ) )

            	    tTotal_2 = cDbl( tTotal_2 ) + cDbl( rs( "Total_$_2" ) )
            	    tPeso_2  = cDbl( tPeso_2 ) + cDbl( rs( "Neto_$_2" ) )
                    tImpto_2 = cDbl( tImpto_2 ) + cDbl( rs( "Impto_$_2" ) )
                    tILA_2   = cDbl( tILA_2 ) + cDbl( rs( "ILA_$_2" ) )
                    tDIH_2   = cDbl( tDIH_2 ) + cDbl( rs( "DIH_$_2" ) )

Response.write("                <tr style='font-family: Arial; font-size: 9px;'>" )
Response.write("                    <td Align='center'>" & rs( "Grupo" ) & "</td>" )
Response.write("            	    <td Align='center'>" & rs( "Rubro" ) & "</td>" )
Response.write("            	    <td Align='left' nowrap>" & rs( "Nombre" ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Neto_US$" ), 2 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( rs( "CifA_US$" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "CPA_US$" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "%_Mes" ), 2 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Neto_1" ), 2 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( rs( "CifA_1" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "CPA_1" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "%_1" ), 2 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Neto_2" ), 2 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( rs( "CifA_2" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "CPA_2" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "%_2" ), 2 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Metas_Mes" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "%_Log" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Proyectado" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Compras" ), 2 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Exi_Act" ), 2 ) & "</td>" )

Response.write("	     		    <td Align='right'>" & FormatNumber( rs( "Tto_Mes_Ant" ), 2 ) & "</td>" )
Response.write("	     		    <td Align='right'>" & FormatNumber( rs( "Tto_Mes" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Tto_Mes_1" ), 2 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "Tto_Mes_2" ), 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Tto_Fut" ), 2 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( rs( "CifOri_US$" ), 2 ) & "</td>" )

Response.write("		            <td Align='right'>" & FormatNumber( rs( "Exi_Mes_1" ), 2 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( rs( "Q_Merc" ), 0 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( rs( "Q_Merc_1" ), 0 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( rs( "Q_Merc_2" ), 0 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( rs( "Lin" ), 0 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( rs( "Lin_1" ), 0 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( rs( "Lin_2" ), 0 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Total_$" ), 0 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Neto_$" ), 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "Impto_$" ), 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "ILA_$" ), 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "DIH_$" ), 0 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Total_$_1" ), 0 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Neto_$_1" ), 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "Impto_$_1" ), 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "ILA_$_1" ), 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "DIH_$_1" ), 0 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Total_$_2" ), 0 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( rs( "Neto_$_2" ), 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "Impto_$_2" ), 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "ILA_$_2" ), 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "DIH_$_2" ), 0 ) & "</td>" )

Response.write("                    <td Align='right'>" & FormatNumber( rs( "%_Lin" ), 2 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "%_Lin_1" ), 2 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( rs( "%_Lin_2" ), 2 ) & "</td>" )
Response.write("                </tr>" )

                    k = k +  1
                    rs.movenext
                    if rs.eof then
                        exit do
                    end if
                    if saveGrupo <> rs( "Grupo" ) then
                        exit do
                    end if
                loop
                k = k +  1

Response.write("                <tr style='font-family: Arial; font-size: 9px;'>" )
Response.write("                    <td align='right' colspan='3'><b>Sub-total " & saveGrupo & "</br></td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( Neto_0, 2 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( CifA_0, 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( CPA_0, 2 ) & "</td>" )
Response.write("            	    <td Align='right'>&nbsp;</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( Neto_1, 2 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( CifA_1, 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( CPA_1, 2 ) & "</td>" )
Response.write("            	    <td Align='right'>&nbsp;</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( Neto_2, 2 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( CifA_2, 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( CPA_2, 2 ) & "</td>" )
Response.write("            	    <td Align='right'>&nbsp;</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( Metas_Mes, 2 ) & "</td>" )
Response.write("            	    <td Align='right'>&nbsp;</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( Proyectado, 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( Compras, 2 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( Exi_Act, 2 ) & "</td>" )

Response.write("	     		    <td Align='right'>" & FormatNumber( Tto_Mes_A, 2 ) & "</td>" )
Response.write("	     		    <td Align='right'>" & FormatNumber( Tto_Mes_0, 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( Tto_Mes_1, 2 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( Tto_Mes_2, 2 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( Tto_Fut, 2 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( CifOri, 2 ) & "</td>" )

Response.write("		            <td Align='right'>" & FormatNumber( Exi_Mes_1, 2 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( Q_Merc_0, 0 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( Q_Merc_1, 0 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( Q_Merc_2, 0 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( Lin_0, 0 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( Lin_1, 0 ) & "</td>" )
Response.write("		            <td Align='right'>" & FormatNumber( Lin_2, 0 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( Total_0, 0 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( Peso_0, 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( Impto_0, 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( ILA_0, 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( DIH_0, 0 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( Total_1, 0 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( Peso_1, 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( Impto_1, 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( ILA_1, 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( DIH_1, 0 ) & "</td>" )

Response.write("            	    <td Align='right'>" & FormatNumber( Total_2, 0 ) & "</td>" )
Response.write("            	    <td Align='right'>" & FormatNumber( Peso_2, 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( Impto_2, 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( ILA_2, 0 ) & "</td>" )
Response.write("                    <td Align='right'>" & FormatNumber( DIH_2, 0 ) & "</td>" )

Response.write("            	    <td Align='right'>&nbsp;</td>" )
Response.write("            	    <td Align='right'>&nbsp;</td>" )
Response.write("            	    <td Align='right'>&nbsp;</td>" )
Response.write("                </tr>" )

                if rs.eof then
                    exit do
                end if
            loop

Response.write("            <tr style='font-family: Arial; font-size: 9px;'>" )
Response.write("                <td align='right' colspan='3'><b>Total General: </br></td>" )

Response.write("            	<td Align='right'>" & FormatNumber( tNeto_0, 2 ) & "</td>" )
Response.write("		        <td Align='right'>" & FormatNumber( tCifA_0, 2 ) & "</td>" )
Response.write("            	<td Align='right'>" & FormatNumber( tCPA_0, 2 ) & "</td>" )
Response.write("            	<td Align='right'>&nbsp;</td>" )

Response.write("            	<td Align='right'>" & FormatNumber( tNeto_1, 2 ) & "</td>" )
Response.write("		        <td Align='right'>" & FormatNumber( tCifA_1, 2 ) & "</td>" )
Response.write("            	<td Align='right'>" & FormatNumber( tCPA_1, 2 ) & "</td>" )
Response.write("            	<td Align='right'>&nbsp;</td>" )

Response.write("            	<td Align='right'>" & FormatNumber( tNeto_2, 2 ) & "</td>" )
Response.write("		        <td Align='right'>" & FormatNumber( tCifA_2, 2 ) & "</td>" )
Response.write("            	<td Align='right'>" & FormatNumber( tCPA_2, 2 ) & "</td>" )
Response.write("            	<td Align='right'>&nbsp;</td>" )

Response.write("            	<td Align='right'>" & FormatNumber( tMetas_Mes, 2 ) & "</td>" )
Response.write("            	<td Align='right'>&nbsp;</td>" )
Response.write("            	<td Align='right'>" & FormatNumber( tProyectado, 2 ) & "</td>" )
Response.write("            	<td Align='right'>" & FormatNumber( tCompras, 2 ) & "</td>" )

Response.write("            	<td Align='right'>" & FormatNumber( tExi_Act, 2 ) & "</td>" )

Response.write("	     		<td Align='right'>" & FormatNumber( tTto_Mes_A, 2 ) & "</td>" )
Response.write("	     		<td Align='right'>" & FormatNumber( tTto_Mes_0, 2 ) & "</td>" )
Response.write("            	<td Align='right'>" & FormatNumber( tTto_Mes_1, 2 ) & "</td>" )
Response.write("                <td Align='right'>" & FormatNumber( tTto_Mes_2, 2 ) & "</td>" )
Response.write("            	<td Align='right'>" & FormatNumber( tTto_Fut, 2 ) & "</td>" )

Response.write("            	<td Align='right'>" & FormatNumber( tCifOri, 2 ) & "</td>" )

Response.write("		        <td Align='right'>" & FormatNumber( tExi_Mes_1, 2 ) & "</td>" )
Response.write("		        <td Align='right'>" & FormatNumber( tQ_Merc_0, 0 ) & "</td>" )
Response.write("		        <td Align='right'>" & FormatNumber( tQ_Merc_1, 0 ) & "</td>" )
Response.write("		        <td Align='right'>" & FormatNumber( tQ_Merc_2, 0 ) & "</td>" )
Response.write("		        <td Align='right'>" & FormatNumber( tLin_0, 0 ) & "</td>" )
Response.write("		        <td Align='right'>" & FormatNumber( tLin_1, 0 ) & "</td>" )
Response.write("		        <td Align='right'>" & FormatNumber( tLin_2, 0 ) & "</td>" )

Response.write("            	<td Align='right'>" & FormatNumber( tTotal_0, 0 ) & "</td>" )
Response.write("            	<td Align='right'>" & FormatNumber( tPeso_0, 0 ) & "</td>" )
Response.write("                <td Align='right'>" & FormatNumber( tImpto_0, 0 ) & "</td>" )
Response.write("                <td Align='right'>" & FormatNumber( tILA_0, 0 ) & "</td>" )
Response.write("                <td Align='right'>" & FormatNumber( tDIH_0, 0 ) & "</td>" )

Response.write("            	<td Align='right'>" & FormatNumber( tTotal_1, 0 ) & "</td>" )
Response.write("            	<td Align='right'>" & FormatNumber( tPeso_1, 0 ) & "</td>" )
Response.write("                <td Align='right'>" & FormatNumber( tImpto_1, 0 ) & "</td>" )
Response.write("                <td Align='right'>" & FormatNumber( tILA_1, 0 ) & "</td>" )
Response.write("                <td Align='right'>" & FormatNumber( tDIH_1, 0 ) & "</td>" )

Response.write("            	<td Align='right'>" & FormatNumber( tTotal_2, 0 ) & "</td>" )
Response.write("            	<td Align='right'>" & FormatNumber( tPeso_2, 0 ) & "</td>" )
Response.write("                <td Align='right'>" & FormatNumber( tImpto_2, 0 ) & "</td>" )
Response.write("                <td Align='right'>" & FormatNumber( tILA_2, 0 ) & "</td>" )
Response.write("                <td Align='right'>" & FormatNumber( tDIH_2, 0 ) & "</td>" )

Response.write("            	<td Align='right'>&nbsp;</td>" )
Response.write("            	<td Align='right'>&nbsp;</td>" )
Response.write("            	<td Align='right'>&nbsp;</td>" )
Response.write("            </tr>" )
Response.write("        </table>" )




    else
        Response.write( "<table>" )
        Response.write( "   <tr>" )
        Response.write( "       <td>" )
        Response.write( "           No hay informacion" )
        Response.write( "       </td>" )
        Response.write( "   </tr>" )
        Response.write( "</table>" )
    end if

    Response.write "</body>"
    Response.write "</html>"
%>
