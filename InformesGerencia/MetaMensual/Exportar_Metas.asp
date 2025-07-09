<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<!-- #include file="../../Scripts/Inc/Paginacion.Inc" -->
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
    ' http://192.168.30.10/Abonados/Sanchez_PtaArenas/InformesGerencia/MetaMensual/Exportar_Metas_nuevo.asp?servidor=P

    function Get_Fecha_Formato_YYYY_MM_DD(v_fecha)
      c_dia = day(cdate(v_fecha))
      c_mes = month(cdate(v_fecha))
      c_anio = year(cdate(v_fecha))
      Get_Fecha_Formato_YYYY_MM_DD = c_anio&"/"&Lpad(c_mes,2,0)&"/"&Lpad(c_dia,2,0)
    end function

    

    'Dim RutaProyecto, RutaInf, version_sis
    'version_sis   = "v2.0"
    'nom_proyecto  = "AltaGestion"
    'StrSite       = mid(Request.ServerVariables("SCRIPT_NAME"),1,instr(mid(Request.ServerVariables("SCRIPT_NAME"), 2), "/")+1)
    'RutaProyecto  = "http://" &Request.serverVariables("Server_Name")& StrSite
    'RutaInf       = "/altagestion/tmp/"
    'Nombre_DSN    = "AG_Sanchez" 'BD oficial del servidor
    APP = Session("Nombre_Aplicacion") & "(" & session("login") & ")"
    WSID = Session("Login") & " (" & Request.ServerVariables("REMOTE_ADDR") & ")"

    servidor = Request( "servidor" )
    if servidor = "P" then strConnect = "DSN=AG_Sanchez; UID=AG_Sanchez; PWD=Vp?T+!mZpJds; APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez; LANGUAGE=Spanish;"
    if servidor = "Replica" then strConnect = "DSN=Replica; UID=AG_Sanchez; PWD=Vp?T+!mZpJds; APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez; LANGUAGE=Spanish;"
    if servidor = "Test" then strConnect = "DSN=Test; UID=AG_Sanchez; PWD=Vp?T+!mZpJds; APP=" & APP & ";WSID=" & WSID & ";DATABASE=Sanchez; LANGUAGE=Spanish;"
    
    'Dim Conn : set Conn = Server.CreateObject("ADODB.Connection")

    Conn.Open strConnect
    conn1 = Session("DataConn_ConnectionString")
                
    Set rs2 = Server.CreateObject("ADODB.Recordset")    
    rs2.CacheSize = 3
    rs2.CursorLocation = 3
    strSQL = "exec ECO_listar_rubros  '" & Session("Login") & "'"     
    'strSQL = "exec ECO_listar_rubros  '7001569'"     
    
    rs2.Open strSQL , conn, , , 1 'mejor
        
    ResultadoRegistros=rs2.RecordCount

    
    Dim misRubros()
    
    i = 0
    ReDim misRubros(ResultadoRegistros,2)
    if not rs2.EOF then
        do while not rs2.EOF
            misRubros(i,0) =  rs2("superfamilia") 
            misRubros(i,1) =  rs2("grupo") 
            i=i+1
            rs2.movenext
        loop

    end if
    'response.write i

    'for i = 0 to ubound(misRubros)
    '   Response.write( i & ": " & misRubros(i,0) & " - " & misRubros(i,0) & "<br>" )
    'next
    'Response.end

    rs2.Close
    'Conn.Close
    Set rs2 = nothing

    'response.write misRubros

    strSQL = "Exec Metas_Mensual_inf "
    strSQL = strSQL & "Null, 'S' "
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    set rs = Conn.Execute( strSQL )
    Nombre_archivo = rs( "Nombre_archivo" )

    Dia_0 = rs( "Dia_0" )
    Dia_1 = rs( "Dia_1" )
    Dia_2 = rs( "Dia_2" )

    if cDbl( Dia_0 ) < 10 then Dia_0 = "0" & Dia_0
    if cDbl( Dia_1 ) < 10 then Dia_1 = "0" & Dia_1
    if cDbl( Dia_2 ) < 10 then Dia_2 = "0" & Dia_2

    Doc_0 = rs( "Docs_0" )
    Doc_1 = rs( "Docs_1" )
    Doc_2 = rs( "Docs_2" )

    Fecha = rs( "Fecha" )
    FechaSistema = rs( "FechaSistema" )

    rs.close
    set rs = Nothing

    sFileName = Nombre_archivo
    flagDebug = false
    IF not flagDebug THEN
    Response.ContentType = "application/vnd.ms-excel"
    Response.Charset = "utf-8"
    Response.AddHeader "Content-Disposition", "attachment; filename=" & sFileName
    Dim sSpreadsheet
    sSpreadsheet = "Metas Mensual"
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
    END IF

    strSQL = "Exec Metas_Mensual_inf "
    strSQL = strSQL & "Null "
    set rs = Conn.Execute( strSQL )
    if not rs.eof then

        strHTML = ""
        strHTML = strHTML  & "<table border='0'>"
        strHTML = strHTML  & "<tr style='font-family: MS Sans Serif; font-size: 12px;'>"
        '-- A, B
        strHTML = strHTML  & "<td Align='center' colspan='1'>&nbsp;</td>"
        strHTML = strHTML  & "<td Align='center' colspan='1'>&nbsp;</td>"
        '-- C, D
        strHTML = strHTML  & "<td Align='right'  colspan='1'><B>" & Dia_0 & "&nbsp;al</B></td>"
        strHTML = strHTML  & "<td Align='left'   colspan='1'><B>" & Fecha & "</B></td>"
        '-- E, F
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>Docs mes</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>" & FormatNumber( Doc_0, 0 ) & "</B></td>"
        '-- G, H
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>&nbsp;</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>&nbsp;</B></td>"
        '-- I, J
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>Docs " & Dia_1 & "</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>" & FormatNumber( Doc_1, 0 ) & "</B></td>"
        
        '-- K, L
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>&nbsp;</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>&nbsp;</B></td>"
        '-- M, N
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>Docs " & Dia_2 & "</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>" & FormatNumber( Doc_2, 0 ) & "</B></td>"
        '-- O, P, Q, R, S, T
        strHTML = strHTML  & "<td Align='center' colspan='1'><B>&nbsp;</B></td>"
        
        strHTML = strHTML  & "<td Align='center' colspan='6'><B>(US$)</B></td>"
        
        strHTML = strHTML  & "<td Align='center' colspan='6'><B>Trasito (US$)</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='2'><B>(US$)</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='3'><B>Q. Merc</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='3'><B>Lineas</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='5'><B>($)</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='5'><B>($)</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='5'><B>($)</B></td>"
        strHTML = strHTML  & "<td Align='center' colspan='3'><B>% Lineas</B></td>"
        strHTML = strHTML  & "</tr>"
        
        strHTML = strHTML  & "<tr style='font-family: MS Sans Serif; font-size: 12px;' >"
        strHTML = strHTML  & "<td Align='center'><B>Grupo</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Rubro</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Nombre</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Neto (mes)</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>CifA (mes)</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>CPA (mes)</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>%</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Neto " & Dia_1 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>CifA " & Dia_1 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>CPA " & Dia_1 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>%</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Neto " & Dia_2 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>CifA " & Dia_2 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>CPA " & Dia_2 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>%</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Meta</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>% Log</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Proyectado</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>% Pry</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Compras</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Exi. Act.</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Mes Ant</B></td>"       
        strHTML = strHTML  & "<td Align='center'><B>Mes</B></td>"       
        strHTML = strHTML  & "<td Align='center'><B>Mes+1</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Mes+2</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Futuro</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>OCPA</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>CifOri</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Exi Ini Mes</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Mes</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>" & Dia_1 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>" & Dia_2 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Mes</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>" & Dia_1 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>" & Dia_2 & "</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Neto (mes)</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Impto (mes)</B></td>"  
        strHTML = strHTML  & "<td Align='center'><B>Ila (mes)</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>DIH (mes)</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Total (mes)</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Neto " & Dia_1 & "</B></td>"                
        strHTML = strHTML  & "<td Align='center'><B>Impto " & Dia_1 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Ila " & Dia_1 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>DIH " & Dia_1 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Total " & Dia_1 & "</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Neto " & Dia_2 & "</B></td>"                
        strHTML = strHTML  & "<td Align='center'><B>Impto " & Dia_2 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Ila " & Dia_2 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>DIH " & Dia_2 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>Total " & Dia_2 & "</B></td>"

        strHTML = strHTML  & "<td Align='center'><B>Mes</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>" & Dia_1 & "</B></td>"
        strHTML = strHTML  & "<td Align='center'><B>" & Dia_2 & "</B></td>"
        strHTML = strHTML  & "</tr>"

        bgcolor= "#FFFFFF"
        k = 0
        NetoZZSys = 0
        MetaZZSys = 0
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
            Tto_OCPA = 0

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

            Meta_Total = 0
            Proyectado_Total = 0
            do while saveGrupo = rs( "Grupo" )
                found = false
                for i = 0 to ubound(misRubros)
                    if misRubros(i,0) = rs( "Rubro" ) and misRubros(i,1) = rs( "Grupo" )   then
                        found = true
                    end if
                next
                                
                saveRubro = rs( "Rubro" )

                if saveGrupo = "SYS" and saveRubro = "ZZ" then
                    Meta_Total = Meta_Total + cDbl( rs( "Neto_US$" ) )
                    Meta_ZZ = cDbl( rs( "Neto_US$" ) )
                    Proyectado_Total = Proyectado_Total + cDbl( rs( "Neto_US$" ) )
                    Proyectado_ZZ = cDbl( rs( "Neto_US$" ) )
                    Neto_0_ZZ = cDbl( rs( "Neto_US$" ) )
                else
                    Proyectado_Total = Proyectado_Total + cDbl( rs( "Proyectado" ) )
                    Meta_Total = Meta_Total + cDbl( rs( "Metas_Mes" ) )
                end if

                if saveGrupo = "SYS" and saveRubro = "ZZ" then
                tMetas_Mes  = cDbl( tMetas_Mes ) + cDbl( rs( "Neto_US$" ) )
                tProyectado = cDbl( tProyectado ) + cDbl( rs( "Neto_US$" ) )
                else
                tMetas_Mes  = cDbl( tMetas_Mes ) + cDbl( rs( "Metas_Mes" ) )
                tProyectado = cDbl( tProyectado ) + cDbl( rs( "Proyectado" ) )
                end if

                Neto_0 = Neto_0 + cDbl( rs( "Neto_US$" ) )
                if found then
                
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
                Tto_OCPA = Tto_OCPA + cDbl( rs( "Tto_OCPA" ) )

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

               

                tCompras    = cDbl( tCompras ) + cDbl( rs( "Compras" ) )

                tExi_Act = cDbl( tExi_Act ) + cDbl( rs( "Exi_Act" ) )

                tTto_Mes_A = cDbl( tTto_Mes_A ) + cDbl( rs( "Tto_Mes_Ant" ) )
                tTto_Mes_0 = cDbl( tTto_Mes_0 ) + cDbl( rs( "Tto_Mes" ) )
                tTto_Mes_1 = cDbl( tTto_Mes_1 ) + cDbl( rs( "Tto_Mes_1" ) )
                tTto_Mes_2 = cDbl( tTto_Mes_2 ) + cDbl( rs( "Tto_Mes_2" ) )
                tTto_Fut   = cDbl( tTto_Fut ) + cDbl( rs( "Tto_Fut" ) )
                tTto_OCPA  = cDbl( tTto_OCPA ) + cDbl( rs( "Tto_OCPA" ) )

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

                'if found is true then
                
                strHTML = strHTML & "<tr style='font-family: MS Sans Serif; font-size: 12px;'>"
                 
                   
                
                'strHTML = strHTML & "<td Align='right'>" & found & "</td>"
                
                'strHTML = strHTML & "<td Align='right'>" & found & "</td>"
                strHTML = strHTML & "<td Align='center'>" & rs( "Grupo" ) & "</td>"
                strHTML = strHTML & "<td Align='center'>" & rs( "Rubro" ) & "</td>"
                strHTML = strHTML & "<td Align='left' nowrap>" & rs( "Nombre" ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Neto_US$" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "CifA_US$" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "CPA_US$" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "%_Mes" ), 7 ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Neto_1" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "CifA_1" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "CPA_1" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "%_1" ), 7 ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Neto_2" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "CifA_2" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "CPA_2" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "%_2" ), 7 ) & "</td>"
                'end if
                ' Meta - %Log
                if saveGrupo = "SYS" and saveRubro = "ZZ" then
                'if found is true then
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Neto_US$" ), 2 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( 100, 7 ) & "</td>"
                'end if
                Metas_Mes = rs( "Neto_US$" )
                'Meta_Total = Meta_Total + cDbl( rs( "Neto_US$" ) )
                else
                'if found is true then
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Metas_Mes" ), 2 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "%_Log" ), 7 ) & "</td>"
                'end if
                Metas_Mes = rs( "Metas_Mes" )
                'Meta_Total = Meta_Total + cDbl( rs( "Metas_Mes" ) )
                end if

                ' Proyectado - %Proy
                if saveGrupo = "SYS" and saveRubro = "ZZ" then
                'if found is true then
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Neto_US$" ), 7 ) & "</td>"
                'end if
                Proyectado = rs( "Neto_US$" )
                'Proyectado_Total = Proyectado_Total + cDbl( rs( "Neto_US$" ) )
                else
                'if found is true then
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Proyectado" ), 7 ) & "</td>"
                'end if
                Proyectado = rs( "Proyectado" )
                'Proyectado_Total = Proyectado_Total + cDbl( rs( "Proyectado" ) )
                end if

                '
                if isNull( Proyectado ) then Proyectado = 0 
                Proyectado = cDbl( Proyectado )

                if isNull( Metas_Mes ) then Metas_Mes = 0 
                Metas_Mes = cDbl( Metas_Mes )

                if Metas_Mes >  0  then
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( ( Proyectado / Metas_Mes ) * 100, 7 ) & "</td>"
                else
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>&nbsp;</td>"
                end if
                'if found is true then
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Compras" ), 7 ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Exi_Act" ), 7 ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Tto_Mes_Ant" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Tto_Mes" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Tto_Mes_1" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Tto_Mes_2" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Tto_Fut" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Tto_OCPA" ), 7 ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "CifOri_US$" ), 7 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "Exi_Mes_1" ), 7 ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Q_Merc" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Q_Merc_1" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Q_Merc_2" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Lin" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Lin_1" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Lin_2" ), 0 ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Neto_$" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Impto_$" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "ILA_$" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "DIH_$" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Total_$" ), 0 ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Neto_$_1" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Impto_$_1" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "ILA_$_1" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "DIH_$_1" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Total_$_1" ), 0 ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Neto_$_2" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Impto_$_2" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "ILA_$_2" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "DIH_$_2" ), 0 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( rs( "Total_$_2" ), 0 ) & "</td>"

                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "%_Lin" ), 2 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "%_Lin_1" ), 2 ) & "</td>"
                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( rs( "%_Lin_2" ), 2 ) & "</td>"

                strHTML = strHTML & "</tr>"
                

                if saveGrupo = "SYS" and saveRubro = "ZZ" then
                    NetoZZSys = cDbl( rs( "Neto_US$" ) )
                    MetaZZSys = cDbl( rs( "Metas_Mes" ) )
                end if
                end if
                k = k +  1
                
                rs.movenext

                if rs.eof then
                    exit do
                end if

              

                if saveGrupo <> rs( "Grupo" ) then
                    exit do
                end if
                'end if
            loop
            k = k +  1

            porc_0 = 0
            if cDbl( Neto_0 ) > 0 then
                porc_0 = ( ( cDbl( Neto_0 ) - cDbl( CPA_0 ) ) / cDbl( Neto_0 ) ) * 100
            end if
            porc_1 = 0
            if cDbl( Neto_1 ) > 0 then
                porc_1 = ( ( cDbl( Neto_1 ) - cDbl( CPA_1 ) ) / cDbl( Neto_1 ) ) * 100
            end if
            porc_2 = 0
            if cDbl( Neto_2 ) > 0 then
                porc_2 = ( ( cDbl( Neto_2 ) - cDbl( CPA_2 ) ) / cDbl( Neto_2 ) ) * 100
            end if

            strHTML = strHTML & "<tr style='font-family: MS Sans Serif; font-size: 12px;'>"
            strHTML = strHTML & "<td align='right' colspan='3'><b>Sub-total " & saveGrupo & "</br></td>"

            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Neto_0, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( CifA_0, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( CPA_0, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( porc_0, 7 ) & "</td>"

            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Neto_1, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( CifA_1, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( CPA_1, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( porc_1, 7 ) & "</td>"

            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Neto_2, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( CifA_2, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( CPA_2, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( porc_2, 7 ) & "</td>"

            ' Meta - %Log
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Meta_Total, 2 ) & "</td>"
            IF Meta_Total > 0 then
                 if saveGrupo = "SYS" then
                    strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( ( (Neto_0 - Neto_0_ZZ)  / (Meta_Total - Meta_ZZ ) ) * 100, 7 ) & "</td>"
                else
                        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( ( Neto_0 / Meta_Total  ) * 100, 7 ) & "</td>"
                end if
            else
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( 0, 7 ) & "</td>"
            end if

            IF FALSE THEN
                Response.write( "saveGrupo: " & saveGrupo & "<br>" )
                Response.write( "saveRubro: " & saveRubro & "<br>" )
                Response.write( "Neto_0: " & Neto_0 & "<br>" )
                Response.write( "NetoZZSys: " & NetoZZSys & "<br>" )
                Response.write( "Metas_Mes: " & Metas_Mes & "<br>" )
                Response.write( "MetaZZSys: " & MetaZZSys & "<br>" )
                Response.write( "Meta_Total: " & Meta_Total & "<br><br>" )
                if saveGrupo = "SYS" then
                    if Metas_Mes - MetaZZSys >  0 then
                        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( ( ( Neto_0 - NetoZZSys ) / ( Metas_Mes - MetaZZSys ) ) * 100, 7 ) & "</td>"
                    else
                        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( 0, 7 ) & "</td>"
                    end if
                else
                    if Metas_Mes >  0 then
                        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( ( Neto_0 / Metas_Mes ) * 100, 7 ) & "</td>"
                    else
                        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( 0, 7 ) & "</td>"
                    end if
                end if
            END IF

            ' Proyectado - %Proy
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Proyectado_Total, 7 ) & "</td>"
            IF Meta_Total > 0 then
                if saveGrupo = "SYS" then

                strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( ( (Proyectado_Total - Proyectado_ZZ) / (Meta_Total - Meta_ZZ) ) * 100, 7 ) & "</td>"
                else
                    strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( ( (Proyectado_Total ) / (Meta_Total ) ) * 100, 7 ) & "</td>"
                end if
            else
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( 0, 7 ) & "</td>"
            end if

            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Compras, 7 ) & "</td>"

            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Exi_Act, 7 ) & "</td>"

            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Tto_Mes_A, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Tto_Mes_0, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Tto_Mes_1, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Tto_Mes_2, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Tto_Fut, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Tto_OCPA, 7 ) & "</td>"

            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( CifOri, 7 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( Exi_Mes_1, 7 ) & "</td>"

            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Q_Merc_0, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Q_Merc_1, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Q_Merc_2, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Lin_0, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Lin_1, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Lin_2, 0 ) & "</td>"

            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Peso_0, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Impto_0, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( ILA_0, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( DIH_0, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Total_0, 0 ) & "</td>"

            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Peso_1, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Impto_1, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( ILA_1, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( DIH_1, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Total_1, 0 ) & "</td>"

            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Peso_2, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Impto_2, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( ILA_2, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( DIH_2, 0 ) & "</td>"
            strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( Total_2, 0 ) & "</td>"

            strHTML = strHTML & "<td Align='right'>&nbsp;</td>"
            strHTML = strHTML & "<td Align='right'>&nbsp;</td>"
            strHTML = strHTML & "<td Align='right'>&nbsp;</td>"
            strHTML = strHTML & "</tr>"

            if rs.eof then
                exit do
            end if
        loop

        porc_0 = 0
        if cDbl( tNeto_0 ) > 0 then
            porc_0 = ( ( cDbl( tNeto_0 ) - cDbl( tCPA_0 ) ) / cDbl( tNeto_0 ) ) * 100
        end if
        porc_1 = 0
        if cDbl( tNeto_1 ) > 0 then
            porc_1 = ( ( cDbl( tNeto_1 ) - cDbl( tCPA_1 ) ) / cDbl( tNeto_1 ) ) * 100
        end if
        porc_2 = 0
        if cDbl( tNeto_2 ) > 0 then
            porc_2 = ( ( cDbl( tNeto_2 ) - cDbl( tCPA_2 ) ) / cDbl( tNeto_2 ) ) * 100
        end if

        ' Total General
        strHTML = strHTML & "<tr style='font-family: MS Sans Serif; font-size: 12px;'>"
        strHTML = strHTML & "<td align='right' colspan='3'><b>Total General: </br></td>"

        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tNeto_0, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tCifA_0, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tCPA_0, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( porc_0, 7 ) & "</td>"

        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tNeto_1, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tCifA_1, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tCPA_1, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( porc_1, 7 ) & "</td>"

        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tNeto_2, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tCifA_2, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tCPA_2, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( porc_2, 7 ) & "</td>"

        ' Meta - %Log
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tMetas_Mes, 2 ) & "</td>"
        if tMetas_Mes > 0 then
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( ( tNeto_0 / tMetas_Mes ) * 100, 7 ) & "</td>"
        else
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( 0, 7 ) & "</td>"
        end if

        ' Proyectado - %Proy
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tProyectado, 7 ) & "</td>"
        if tProyectado > 0 then
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( ( tProyectado / tMetas_Mes ) * 100, 7 ) & "</td>"
        else
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( 0, 7 ) & "</td>"
        end if

        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tCompras, 7 ) & "</td>"

        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tExi_Act, 7 ) & "</td>"

        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tTto_Mes_A, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tTto_Mes_0, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tTto_Mes_1, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tTto_Mes_2, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tTto_Fut, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tTto_OCPA, 7 ) & "</td>"

        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tCifOri, 7 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_2'>" & FormatNumber( tExi_Mes_1, 7 ) & "</td>"

        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tQ_Merc_0, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tQ_Merc_1, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tQ_Merc_2, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tLin_0, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tLin_1, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tLin_2, 0 ) & "</td>"

        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tPeso_0, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tImpto_0, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tILA_0, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tDIH_0, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tTotal_0, 0 ) & "</td>"

        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tPeso_1, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tImpto_1, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tILA_1, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tDIH_1, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tTotal_1, 0 ) & "</td>"

        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tPeso_2, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tImpto_2, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tILA_2, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tDIH_2, 0 ) & "</td>"
        strHTML = strHTML & "<td Align='right' class='FormatNumber_0'>" & FormatNumber( tTotal_2, 0 ) & "</td>"

        strHTML = strHTML & "<td Align='right'>&nbsp;</td>"
        strHTML = strHTML & "<td Align='right'>&nbsp;</td>"
        strHTML = strHTML & "<td Align='right'>&nbsp;</td>"
        strHTML = strHTML & "</tr>"

         ' Fecha del informe
        strHTML = strHTML & "<tr style='font-family: MS Sans Serif; font-size: 12px;'>"
        strHTML = strHTML & "<td align='left' colspan='52'>&nbsp;</td>"
        strHTML = strHTML & "</tr>"
        strHTML = strHTML & "<tr style='font-family: MS Sans Serif; font-size: 12px;'>"
        strHTML = strHTML & "<td align='left' colspan='52'>Fecha informe: " & FechaSistema & "</td>"
        strHTML = strHTML & "</tr>"

        strHTML = strHTML & "</table>"
    else
        strHTML = strHTML &  "<table>"
        strHTML = strHTML &  "<tr>"
        strHTML = strHTML &  "<td>"
        strHTML = strHTML &  "No hay informacion"
        strHTML = strHTML &  "</td>"
        strHTML = strHTML &  "</tr>"
        strHTML = strHTML &  "</table>"
    end if
    IF flagDebug THEN
        Response.write( strHTML )
        Response.end
    END IF
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
    <% = strHTML %>
</body>
</html>
