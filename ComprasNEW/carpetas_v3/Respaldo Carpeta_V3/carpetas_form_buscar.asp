<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
titulo = "Administracion de Carpetas (v3)"

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

width   = "1280"
height  = "800"
openConn
%>
<table width="1430px" align="left" cellPadding=0 cellSpacing=0 border=0>
    <tr>
        <td>
            <table width="100%" align="left" cellPadding=0 cellSpacing=0 border=0>
                <tr align="center" bgcolor="#444444">
                    <td style="width: 100px;">&nbsp;</td>
                    <td style="font-size: 11px; color:#CCCCCC;"><b><%=Ucase(titulo)%>:&nbsp;BUSCAR CARPETAS</b></td>
                    <td style="width: 100px;"><a class="linkmenuprincipal" href="<%=RutaProyecto%>index.htm">Menú principal</a></td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td>
            <table id="tabla_botonera_general" name="tabla_botonera_general" width="100%" align="left" cellPadding=0 cellSpacing=0 border=0>
                <tr id="texto_11" height="30" bgcolor="#DDDDDD" style="color:#444444;">
                    <td width="100">&nbsp;<b>DOC.:</b>&nbsp;
                        <select id="documento_respaldo" name="documento_respaldo" style="width: 40px;">
                            <option value="R">R</option><option value="TU">TU</option><option value="Z">Z</option>
                        </select>
                    </td>

                    <td width="100"><b>AÑO:</b>&nbsp;
                        <select id="anio" name="anio" style="width: 50px;">
                            <% v_anio = year(date())
                            for i=2006 to year(date())%>
                            <option value="<%=v_anio%>"><%=v_anio%></option>
                            <% v_anio = v_anio - 1
                            next%>
                        </select>
                    </td>

                    <td width="130">&nbsp;<b>MES:</b>&nbsp;
                        <select id="mes" name="mes" style="width: 80px;">
                            <%for i=1 to 12%>
                            <option value="<%=i%>"
                            <%if i=month(date()) then%>
                            selected 
                            <%end if%>
                            ><%=GetMes(i)%></option>
                            <%next%>
                        </select>
                    </td>

                    <td width="70">&nbsp;<b>N°:</b>&nbsp;
                        <input onfocus="select();" onkeypress="return Valida_Digito(event);"
                        type="text" id="num_carpeta" name="num_carpeta" maxlength="7" style="width: 40px;"></td>
                        <td><input class="boton_Buscar_on" type="button" title="Buscar carpeta" id="bot_buscar" name="bot_buscar">&nbsp;
                        <input class="boton_Nuevo_on" type="button" title="Crear nueva carpeta" id="bot_nuevo" name="bot_nuevo">&nbsp;
                    </td>
                </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td>
            <table width="100%" align="center" cellPadding=0 cellSpacing=0 border=0 xstyle='border: 1 solid #ff0000;'>
                <tr>
                    <td id="td_lista" name="td_lista"></td>
                </tr>
            </table>
        </td>
    </tr>
</table>

