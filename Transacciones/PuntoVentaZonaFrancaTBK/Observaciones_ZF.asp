<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
    Cache
    
    if Ucase(Trim(Request("Accion"))) = "ACEPTAR" then
        Session("xObservaciones") = Request("Observaciones")  %>
        <script language="Javascript">
            this.window.close();
        </script>
<%  end if %>

<html>
    <head>
        <title>Observaciones</title>
        <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
        <script src="../../Scripts/Js/Caracteres.js"></script>
    </head>

    <body bgcolor="#CCCD94" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
    
        <center>
            <form name="Formulario">
                
                <input type=hidden name="Accion" value="">
                
                <table align="center" width="95%" border=0 cellpadding=0 cellspacing=0>
                    <tr>
                        <td class="FuenteEncabezados" align="left">Observaciones</td>
                    </tr>
                    
                    <tr>
                        <td align=left>
                            <TextArea class=FuenteInput type=text name="Observaciones" rows=8 cols=80><%=Session("xObservaciones")%></TextArea>
                        </td>
                    </tr>
                </table>
            
                <input class=FuenteInput type="button" value="Aceptar" name="Aceptar" onclick="javascript:fAceptar()" >
                <input class=FuenteInput type="button" value="Cancelar" name="Cancelar" onclick="javascript:fCancelar()" >
            
            </form>
        
        </center>
    </body>

</html>
<script language="JavaScript">
    function fAceptar()
    {
        var Observaciones = document.Formulario.Observaciones.value;
        if ( ! validEmpty(Observaciones) )
        {
            if ( ! validaGlosa(Observaciones) )
            {
                alert ( 'Las observaciones ingresadas contiene caracteres no válidos, revise por favor.' )
                document.Formulario.Observaciones.focus();
                return;
            }
        }
        document.Formulario.Accion.value = "ACEPTAR"
        document.Formulario.method = "post"
        document.Formulario.action = "Observaciones_ZF.asp"
        document.Formulario.submit();
        this.window.close();
    }
    
    function fCancelar()
    {
        this.window.close();
    }
    
    
</script>
