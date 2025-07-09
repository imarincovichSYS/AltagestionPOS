<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
    Cache

    Set Conn = Server.createobject("ADODB.Connection")
    Conn.Open Session("DataConn_ConnectionString")
    Conn.CommandTimeout = 3600
    
    if Ucase(Trim(Request("Accion"))) = "ACEPTAR" then
        cSql = "Exec ASE_Graba_Asociado '" & Session("Empresa_usuario") & "', '" & Request("Economato") & "', '" & Session("Cliente_boleta") & "'"
        Conn.Execute ( cSql )
        
        Session("xEconomato") = Request("Economato")  
         
         cSql = "Exec ECO_Lista_Economatos_Anuales '" & Session("Empresa_usuario") & "','" & Session("xEconomato") & "', Null, Null, Null"
         Set RsASE = Conn.Execute ( cSql )
         If Not RsASE.Eof then
            Session("xEconomato_nombre") = RsASE("Nombre")
         end if
         RsASE.Close
         
        %>
        <script language="Javascript">            
            this.window.close();
        </script>
<%  end if
    
    Economatos = "<option value=''></option>"
    cSql = "Exec ECO_Lista_Economatos_Anuales '" & Session("Empresa_usuario") & "', Null, Null, Null, Null"
    Set Rs = Conn.Execute ( cSql )
    Do While Not Rs.Eof
        Economatos = Economatos & "<option "
            if Session("xEconomato") = Rs("Economato") Then
                Economatos = Economatos & " selected " 
            end if 
        Economatos = Economatos & " value='" & Rs("Economato") & "'>" & Rs("Nombre") & "</option>"
        Rs.MoveNext
    Loop
    Rs.Close

%>

<html>
    <head>
        <title>Economatos</title>
        <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
        <script src="../../Scripts/Js/Caracteres.js"></script>
    </head>

    <body bgcolor="#CCCD94" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
    
        <center>
            <form name="Formulario">
                
                <input type=hidden name="Accion" value="">
                
                <table align="center" width="95%" border=0 cellpadding=0 cellspacing=0>
                    <tr height=50>
                        <td class="FuenteEncabezados" align="center">Indique el economato del cliente</td>
                    </tr>
                    
                    <tr height=50>
                        <td align=center>
                            <Select class="FuenteInput" name="Economato" style="width:200px" >
                                <% Response.Write Economatos %>
                            </Select>
                        </td>
                    </tr>

                    <tr height=50>
                        <td align=center>
                            <input class=FuenteInput type="button" value="Aceptar" name="Aceptar" onclick="javascript:fAceptar()" >
                            <input class=FuenteInput type="button" value="Cancelar" name="Cancelar" onclick="javascript:fCancelar()" >
                        </td>
                    </tr>
                </table>
            
            
            </form>
        
        </center>
    </body>

</html>
<%
    Conn.Close
%>

<script language="JavaScript">
    function fAceptar()
    {
        var Economato = document.Formulario.Economato.value;
        if ( validEmpty(Economato) )
        {
            alert ( 'Debe seleccionar un economato, revise por favor.' )
            document.Formulario.Economato.focus();
            return;
        }
        
        var Rsp = confirm ( '¿ Esta seguro(a) de asociar al cliente este economato ?' )
        if ( Rsp )
        {
            document.Formulario.Accion.value = "ACEPTAR"
            document.Formulario.method = "post"
            document.Formulario.target = "_self"
            document.Formulario.action = "ListaEconomatos_ZF.asp"
            document.Formulario.submit();
            window.returnValue = "ACEPTAR";
            this.window.close();
        }
    }
    
    function fCancelar()
    {
        window.returnValue = "CANCELAR";
        this.window.close();
    }
    
    
</script>
