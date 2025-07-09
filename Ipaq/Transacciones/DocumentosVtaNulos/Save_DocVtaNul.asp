<!-- #include file ="../../Scripts/inc/Fechas.inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache

If len(trim( Session( "DataConn_ConnectionString") )) > 0 then

 	On Error Resume Next

    Set Conn= Server.CreateObject("ADODB.Connection")
	Conn.Open Session( "DataConn_ConnectionString" )
	Conn.CommandTimeOut = 3600
    Conn.Begintrans
    
	Empresa		= session ( "Empresa_usuario" )
	Folio_nulo	= Request ( "Folio_nulo" )
	Documento	= Request ( "Documento" )
	Fecha		= Request ( "Fecha" )
	Tipo		= Request ( "Tipo" )
	if len(trim(Fecha)) = 0 then Fecha = "Null" Else Fecha = "'" & Cambia_fecha(Fecha) & "'"

	MsgError   = ""
	Error      = "N"

    cSql = "Exec DOV_Agrega_DocumentoNulo_Zona_Franca '" & Empresa & "', " 
    cSql = cSql & "'" & Documento					& "', 0"
    cSql = cSql & Folio_nulo						& ", " 
    cSql = cSql & "'" & Request("Vendedor")			& "', "
    cSql = cSql & Fecha								& ", "
    cSql = cSql & "'" & Tipo						& "'"
	Set Rs = Conn.Execute( cSQL )
	If len(trim(Err.Description)) = 0 then 
		Conn.CommitTrans
		MsgError	= "Proceso terminado satisfactoriamente."
	Else
		Conn.RollbackTrans
		Error = "S"
		MsgError	= Err.Description
	End if
    Rs.close
    Conn.close
    
    MsgError = LimpiaError(MsgError)
%>
    <body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
    </body>

    <script language="JavaScript">
        alert ( "<%=MsgError%>" );
        if ( '<%=Error%>' == 'N' )
        {
            parent.top.location.href = 'Find_DocVtaNul.asp';
        }
        else
        {
            history.back();
        }
    </script>
<%Else
	Response.Redirect "../../index.htm"
End if%>
