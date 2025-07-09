<!-- #include file="../../Scripts/Asp/Conecciones.asp" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") ))> 0 then

    SET Conn = AbrirConexion ( Session("Dataconn_ConnectionString") )
    
    SuperFamilia = Request("SuperFamilia")
        if len(trim(SuperFamilia)) = 0 then SuperFamilia = "Null" Else SuperFamilia = "'" & SuperFamilia & "'"
    Familia = Request("Familia")
        if len(trim(Familia)) = 0 then Familia = "Null" Else Familia = "'" & Familia & "'"
    
    SubFamilia = "<Select class='FuenteInput' name='Slct_SubFamilia' style='width:150'>"
    SubFamilia = SubFamilia & "<option value=''></option>"
    cSql = "Exec SBF_ListaSubfamilias Null, " & Familia & ", " & SuperFamilia & ", Null, 1"
    Set Rs = Conn.Execute ( cSql )
    Do While Not Rs.Eof
        SubFamilia = SubFamilia & "<option value='" & Rs("SubFamilia") & "'>" & Rs("Nombre") & " (" & Rs("SubFamilia") & ")</option>"
        Rs.MoveNext
    Loop
    Rs.Close
    Set Rs = Nothing
    SubFamilia = SubFamilia & "</Select>"
    
    CerrarConexion ( Conn )
    
    Response.Write SubFamilia
end if
%>
