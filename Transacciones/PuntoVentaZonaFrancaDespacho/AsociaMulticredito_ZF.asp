<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
    Cache

    Set Conn = Server.createobject("ADODB.Connection")
    Conn.Open Session("DataConn_ConnectionString")    
    Conn.CommandTimeout = 3600
    
    if Ucase(Trim(Request("Accion"))) = "ACEPTAR" then

        cSql = "Exec TMU_Graba_Asociado '" & Session("Empresa_usuario") & "','" & Session("Cliente_boleta") & "','"
	      cSql = cSql & "A',0" & request("Dia_cierre")
        Conn.Execute ( cSql )
        Session("xMulticredito") = request("Dia_cierre")

        %>
        <script language="Javascript">            
            this.window.close();
        </script>
<%  end if
    
%>

<html>
    <head>
        <title>Multicredito</title>
        <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
        <script src="../../Scripts/Js/Caracteres.js"></script>
    </head>

    <body bgcolor="#CCCD94" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
    
        <center>
            <form name="Formulario">
                
                <input type=hidden name="Accion" value="">
                
                <table align="center" width="95%" border=0 cellpadding=0 cellspacing=0>
                    <tr height=50>
                        <td class="FuenteEncabezados" align="center">Indique el día de cierre</td>
                    </tr>
                    
                    <tr height=50>
                        <td align=center>
                            <Select class="FuenteInput" name="Dia_cierre">
<%for n = 1 to 30%>
                                <option value="<%=n%>"><%=n%></option>
<%next%>
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
            document.Formulario.Accion.value = "ACEPTAR"
            document.Formulario.method = "post"
            document.Formulario.target = "_self"
            document.Formulario.action = "AsociaMulticredito_ZF.asp"
            document.Formulario.submit();
            window.returnValue = "ACEPTAR";
            this.window.close();
    }
    
    function fCancelar()
    {
        window.returnValue = "CANCELAR";
        this.window.close();
    }
    
    
</script>
