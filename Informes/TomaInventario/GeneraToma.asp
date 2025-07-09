<!-- #include file="../../Scripts/Asp/Conecciones.Asp" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then

    On Error Resume Next
    MsgError = ""
    Error = "N"
    
	Producto		= Request ("Producto")
    Bodega			= Request ("Bodega")
    Superfamilia	= Request ("Slct_SuperFam")
    Familia			= Request ("Slct_Familia")
    Subfamilia		= Request ("Slct_SubFamilia")

	SET Conn = AbrirConexion ( Session("Dataconn_ConnectionString") )
	Conn.BeginTrans()
	
    cSql = "Exec PRB_PreCarga_Toma_Inventario '" & Session("Empresa_usuario") & "', "
	cSql = cSql & "'" & Bodega & "', "
	cSql = cSql & "'" & Producto & "', "
	cSql = cSql & "'" & Superfamilia & "', "
	cSql = cSql & "'" & Familia & "', "
	cSql = cSql & "'" & SubFamilia & "', "
    cSql = cSql & "'" & Session("Login") & "'"
    Set Rs = Conn.Execute ( cSql )

    if Conn.Errors.Count > 0 then
        Error = "S"
        MsgError = Err.Description
        Conn.RollbackTrans
    else
        Conn.CommitTrans
    end if    
    CerrarConexion ( Conn )

    MsgError = LimpiaError ( MsgError )
%>
    <form name="Formulario" method=post action="<%=Request("URL")%>" target="_self">
        <input type=hidden name="Producto"      value="<%=Request ("Producto")%>">
        <input type=hidden name="Bodega"        value="<%=Request ("Bodega")%>">
        <input type=hidden name="Superfamilia"  value="<%=Request ("Slct_SuperFam")%>">
        <input type=hidden name="Familia"       value="<%=Request ("Slct_Familia")%>">
        <input type=hidden name="Subfamilia"    value="<%=Request ("Slct_SubFamilia")%>">
    </form>
    <script language="Javascript">
    <%  if Error = "N" then 
            if Request("Ventana") = "S" then %>
    			var winURL		 = "<%=Request("URL")%>";
    			var winName		 = "WndToma";
    			var winFeatures  = "status=no," ; 
    				winFeatures += "resizable=no," ;
    				winFeatures += "toolbar=no," ;
    				winFeatures += "location=no," ;
    				winFeatures += "scrollbars=yes," ;
    				winFeatures += "menubar=0," ;
    				winFeatures += "width=650," ;
    				winFeatures += "height=300," ;
    				winFeatures += "top=30," ;
    				winFeatures += "left=50" ;
    			var Wnd = window.open(winURL , winName , winFeatures , 'mainwindow')
        <%  else %>
                document.Formulario.submit();            
        <%  end if %>
    <%  else %>
            parent.top.frames[3].location.href = "../../Mensajes.asp?Msg=<%=MsgError%>"
    <%  end if %>
    </script>
<%
else
	Response.Redirect "../../index.htm"
end if
%>
