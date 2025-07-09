<!-- #include file="../../Scripts/Asp/Conecciones.asp" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") ))> 0 then

    SET Conn = AbrirConexion ( Session("Dataconn_ConnectionString") )
    
    SuperFamilia = Request("SuperFamilia")
        if len(trim(SuperFamilia)) = 0 then SuperFamilia = "Null" Else SuperFamilia = "'" & SuperFamilia & "'"
    
    Familia = "<Select class='FuenteInput' name='Slct_Familia' style='width:150' Onchange='JavaScript:fCargaSubFamilia( document.Frm_Mantencion.Slct_SuperFam.value, this.value );'>"
    Familia = Familia & "<option value=''></option>"
    cSql = "Exec FAM_ListaFamilias Null, " & SuperFamilia & ", Null, 1"
    Set Rs = Conn.Execute ( cSql )
    Do While Not Rs.Eof
        Familia = Familia & "<option value='" & Rs("Familia") & "'>" & Rs("Nombre") & " (" & Rs("Familia") & ")</option>"
        Rs.MoveNext
    Loop
    Rs.Close
    Set Rs = Nothing
    Familia = Familia & "</Select>"
    
    CerrarConexion ( Conn )
    
    Response.Write Familia
end if
%>
