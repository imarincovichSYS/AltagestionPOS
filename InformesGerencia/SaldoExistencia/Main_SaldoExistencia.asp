<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
    titulo = "Totales x Rubro x Grupo"
    Session("Nombre_Aplicacion") = titulo

    session("entidad_comercial") = "13512435"
    width = "1350"
    height = "480"
    fecha_primero = cdate(Get_Fecha_Hoy()) - day(Get_Fecha_Hoy()) + 1
    if day(Get_Fecha_Hoy()) = 1 then
      fecha_primero = cdate(Get_Fecha_Hoy()) - day(Get_Fecha_Hoy())
      fecha_primero = cdate(fecha_primero) - day(fecha_primero) + 1
    end if

    fecha_hoy = cdate(Get_Fecha_Hoy()) - 1

    actual = Now()
    actual = FormatDateTime(Actual, 4)
    if hour(actual) >=22 then
      fecha_hoy = cdate(Get_Fecha_Hoy()) 
    end if

    openConn
%>
<html>
    <head>
        <title>AltaGestión - <%=titulo%></title>
        <script language="JavaScript">
        var RutaProyecto  = "<%=RutaProyecto%>"; var resolucion_H  = "1024"; var fecha_hoy = "<% = fecha_hoy %>"
        </script>

        <link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">
        <link rel="stylesheet" href="<%=RutaProyecto%>css/calendario.css" type="text/css">

        <script language="javascript" src="<%=RutaProyecto%>js/mootools-1.11.js"></script>
        <script language="JavaScript" src="<%=RutaProyecto%>js/tools.js"></script>
        <script language="javascript" src="<%=RutaProyecto%>js/calendario.js"></script>

        <link rel="stylesheet" href="<%=RutaProyecto%>ACIDgrid/grid.css" type="text/css">

        <script language="JavaScript" src="<%=RutaProyecto%>ACIDGrid/grid.js"></script>
        <script language="JavaScript" src="<%=RutaProyecto%>ACIDGrid/grid_calendario.js"></script>
        <script language="javascript" src="SaldoExistencia.js"></script>
    </head>
<%
    if  session("login")="7001569" or session("login")="9817604" or session("login")="182015725" or session("login")="10948121" or session("login")="18201572" then
      jlinea = "true"
    else
      jlinea = "false"
    end if
%>
    <body bgcolor="#9B9DAA" style='overflow:hidden;'>
        <table width="100%"align="center"><tr align="center"><td id="texto_2">
            </td>
            </tr>
        </table>
        <table id="table_enc" width="<%=width%>" cellPadding="0" cellSpacing="0" align="center">
            <tr align="center">
                <td>
                    <table width="100%" cellPadding="0" cellSpacing="0" align="center" border=0>
                        <tr bgcolor="#444444">
                            <td align="center" style="font-size: 11px; color:#FFFFFF;"><b><label id="label_accion_modulo" name="label_accion_modulo">SALDO  EXISTENCIA</label></font></b></td>
                            <td width="5"><input type="text" name="celda_vacio" style="height:0px;width:0px; border-top:0; border-bottom:0; border-left:0; border-right:0;" maxlength="0"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="top" xheight="730">
                    <table id="tabla_botonera_general" name="tabla_botonera_general" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
                        <tr id="texto_11" height="30" bgcolor="#DDDDDD">
                            <td id="td_cab_4" name="td_cab_4" width="140">&nbsp;<b>Servidor:</b>
                                <select id='Servidor'>
                                    <option value='P' selected>Produccion</option>
                                    <% if jlinea="true" then %>
                                    <option value='Replica'>Replica</option>
                                    <option value='Test'>Test</option>
                                    <% end if %>
                                </select>
                                <input value="<%=fecha_hoy%>" type="hidden" id="Fecha_desde" name="Fecha_desde">
                                <!-- <input value="<%=fecha_hoy%>" onfocus="select();" onkeypress="return Valida_Caracteres_Fecha(event);" onclick="displayCalendarEjectFunction(this,'dd/mm/yyyy',this,true)" type="text" id="Text1" name="Fecha_desde" maxlength="10" style="width: 64px;"> -->
                            </td>

                            <td id="td1" name="td_cab_4" width="140">&nbsp;<b>Tipo:</b>
                                <select id='Informe'>
                                    <option value='R' selected>Resumen</option>
                                    <option value='D'>Detalle</option>
                                </select>
                            </td>

                            <td id="td2" name="td_cab_4" width="240">&nbsp;<b>Agrupado por:</b>
                                <select id='xgrupado'>
                                    <option value='G'>por Grupo</option>
                                    <option value='R' selected>Rubro</option>
                                    <option value='F'>Familia</option>
                                    <option value='S'>Subfamilia</option>
                                </select>
                            </td>

                            <!--
                            <td id="td_cab_4" name="td_cab_4" width="140"><b>HASTA:</b>
                                <input value="<%=fecha_hoy%>" onfocus="select();" onkeypress="return Valida_Caracteres_Fecha(event);" onclick="displayCalendarEjectFunction(this,'dd/mm/yyyy',this,true)" type="text" id="Fecha_hasta" name="Fecha_hasta" maxlength="10" style="width: 64px;">
                            </td>
                            -->

                            <%if jlinea="true" then%>
                            <td width="70"> 
                            <%else%>
                            <td width="90">
                            <%end if%>
        
                                <input class="boton_Buscar_on" type="button" title="Mostrar informe" OnClick="Mostrar_SaldoExistencia(true,1,false)" id="bot_buscar" name="bot_buscar" style='display: none;'>&nbsp; 
                                <input class="boton_Excel_off" type="button" title="Exportar informe a Excel" OnClick="javascript:Exportar_SaldoExistencia();" id="bot_excel" name="bot_excel">&nbsp;
    
                            <%if jlinea="false" then%>
                                <!-- <input class="boton_Atras_off" type="button" title="Ir atrás" disabled OnClick="Cancelar_SaldoExistencia(false)" id="bot_atras" name="bot_atras"> -->
                            <%else%>
                                <!-- <input class="boton_Atras_off" type="button" title="Ir atrás" disabled OnClick="Cancelar_SaldoExistencia(true)" id="bot_atras" name="bot_atras"> -->
                            <%end if%>
                            </td>

                            <!--
                            <td>
                                <input  type=checkbox name="pend" id="pend">  <b>Ordenado por Logro</b>    
                            </td>
                            -->
                            <td width='0'>&nbsp;</td>
                        </tr>
                    </table>

                    <table width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
                        <tr>
                            <td bgcolor="#FFFFFF">
                                <div id="grilla_carpetas" name="grilla_carpetas" style="width: <%=width-4%>px; height: 538px; overflow:auto;">
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        <script language="Javascript">
            /*
            CentrarCapa("capaDatosCarpeta")
            document.getElementById("capaDatosCarpeta").style.left = parseInt(document.getElementById("capaDatosCarpeta").style.left) - 11
            CentrarCapa("capaFrame")
            document.getElementById("capaFrame").style.left = parseInt(document.getElementById("capaFrame").style.left) - 11
            CentrarCapa("capaLoadFile")
            document.getElementById("capaLoadFile").style.left = parseInt(document.getElementById("capaLoadFile").style.left) - 11

            Cancelar_Busqueda_Carpeta("<%=jlinea%>")
            */

            window.parent.frames[0].document.body.style.backgroundColor = "#9B9DAA"
            window.parent.frames[2].location.href = "footer.asp"
            window.parent.frames[3].location.href = "footer.asp"

            SetBackgroundImageInput(bot_excel, RutaProyecto + "imagenes/Ico_Excel_24X24_on.gif")
            bot_excel.disabled = false

		</script>
    </body>
<html>
