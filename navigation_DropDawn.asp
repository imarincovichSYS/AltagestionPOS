<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!-- #include file="Fun_dbo.inc"-->
<!-- #include file="Scripts/Inc/Cache.Inc" -->
<!-- #include file="Scripts/Asp/Conecciones.Asp" -->
<%
	SET Conn = AbrirConexion ( Session("Dataconn_ConnectionString") )

	cSql = "Exec USR_ListaModulos_PerfilesUsuario '" & Session("Login") & "', Null, Null, Null, Null"

    nroMenu = 0
	Set RsModulos = Conn.Execute( cSql )
	Do While Not RsModulos.eof
        nroMenu = cDbl( nroMenu ) +  1
		cModulos = cModulos & RsModulos("Modulo") & "|"
		RsModulos.MoveNext
	Loop
	RsModulos.Close
	Set RsModulos = nothing

    d = 0 
    cadenaMenu = ""
    cadenaMenu = cadenaMenu & "<li class='top'><a href='javascript:fInicio();' class='top_link'><span>Salir</span></a></li>"
    if len( trim( cModulos ) ) > 0 then
		cSql = "Exec USR_ListaFuncionesPerfilesUsuario '" & Session("Login") & "', Null, Null, Null, 1"
		Set RsOpciones = Conn.Execute( cSql )
		do while not RsOpciones.eof
            AModulo = RsOpciones("Modulo")
			d = cInt(d) + 1 

            cadenaMenu = cadenaMenu & "<li class='top'><a href='#' id='' class='top_link'><span class='down'>" & AModulo & "</span></a>"
            cadenaMenu = cadenaMenu & "<ul class='sub'>"

			k = 0
			do while trim(AModulo) = trim(RsOpciones("Modulo"))
				ASubMenu = RsOpciones("Grupo") 

				k = cInt(k) + 1
                par_impar = false
                cadenaMenu = cadenaMenu & "<li><a href='#' class='fly'>" & ASubMenu & "</a>"
                cadenaMenu = cadenaMenu & "<ul style='overflow-x: hidden; overflow-y: auto; height: ___px;'>"

                x = 0
                do while trim(AModulo) = trim(RsOpciones("Modulo")) And trim(ASubMenu) = trim(RsOpciones("Grupo"))
                    Nombre = RsOpciones("Nombre")
				    if RsOpciones("Funcion") = "asignarempre" then
					    if ( len(trim(Session("Empresa_usuario"))) = 0 Or IsNull(Session("Empresa_usuario")) ) then
                            x = cInt(x) + 1
                            if par_impar then
                                cadenaMenu = cadenaMenu & "<li><a id='linkOpcion_" & d & "_" & k & "_" & x & "' href=""javascript:fLink('LlamaPaso.asp?NomFun=" & rsopciones( "Funcion" ) & "', '" & d & "_" & k & "_" & x & "');"">" & RsOpciones("Nombre") & "</a></li>"
                            else
                                cadenaMenu = cadenaMenu & "<li><a id='linkOpcion_" & d & "_" & k & "_" & x & "' href=""javascript:fLink('LlamaPaso.asp?NomFun=" & rsopciones( "Funcion" ) & "', '" & d & "_" & k & "_" & x & "');"">" & RsOpciones("Nombre") & "</a></li>"
                            end if
                        end if
                    else
                        x = cInt(x) + 1
                        if par_impar then
                            cadenaMenu = cadenaMenu & "<li><a id='linkOpcion_" & d & "_" & k & "_" & x & "' href=""javascript:fLink('LlamaPaso.asp?NomFun=" & rsopciones( "Funcion" ) & "', '" & d & "_" & k & "_" & x & "');"">" & RsOpciones("Nombre") & "</a></li>"
                        else
                            cadenaMenu = cadenaMenu & "<li><a id='linkOpcion_" & d & "_" & k & "_" & x & "' href=""javascript:fLink('LlamaPaso.asp?NomFun=" & rsopciones( "Funcion" ) & "', '" & d & "_" & k & "_" & x & "');"">" & RsOpciones("Nombre") & "</a></li>"
                        end if
                    end if
                    par_impar = not( par_impar )
                    RsOpciones.MoveNext

					if RsOpciones.eof then
						exit do
					end if
				Loop
                cadenaMenu = cadenaMenu & "</ul>"
                cadenaMenu = cadenaMenu & "</li>"
                '
                if cDbl( x ) <= 25 then
                    heightUL = ( 500 * cDbl(x) ) / 25
                    cadenaMenu = replace( cadenaMenu, "___px;", heightUL & "px;" )
                else
                    cadenaMenu = replace( cadenaMenu, "___px;", "400px;" )
                end if

				if RsOpciones.eof then
					exit do
				end if
            loop
            cadenaMenu = cadenaMenu & "</ul>"
            cadenaMenu = cadenaMenu & "</li>"
			if RsOpciones.eof then
				exit do
			end if
        loop
		RsOpciones.Close
		Set RsOpciones = nothing
    else
        cadenaMenu = ""
    end if

    Conn.Close()
%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />

        <script src="pro_dropdown_2/stuHover.js" type="text/javascript"></script>
        <link rel="stylesheet" type="text/css" href="pro_dropdown_2/pro_dropdown_2.css" />
        <link rel="stylesheet" type="text/css" href="CSS/Estilos.css">

        <title><%=Session.SessionId%></title>

        <style type="text/css">
            .colorVisited {
                background-color: #FFFFFF;
                font-size: 12px;
                font-weight: bold;
            }
            .colorActive {
                background-color: #FFFFFF;
                font-size: 11px;
                font-weight: normal;
            }
        </style>

    </head>

    <body onmouseover='javascript:fOver();' onmouseout='javascript:fOut();' background="<%=Session("ImagenFondo")%>" text="black" xstyle='background-color: #2E76AE;'>
        <form name="menu">
        <% if len( trim( cModulos ) ) > 0 then %>
            <table align=center width='100%' border="0" cellpadding="0" cellspacing="0">
                <tr style='font-size: 20px; xbackground-color: #2e76ae;'>
			        <td width='120' class="FuenteEncabezados" align=left nowrap>
                    <% if len(trim(Session("LogoEmpresa"))) > 0 then %>
                        <img id='imgEmpresa' name='imgEmpresa' src='imagenes/<%=Session("LogoEmpresa")%>' width='100px' height="28px" border=0 />
                    <% else%>
                        <img id='imgEmpresa' name='imgEmpresa' src='imagenes/blank.gif' width='100px' height="28px" border=0 />
                    <% end if%>
                    </td>
                    
                    <td align=center valign=top nowrap width='1'>&nbsp;</td>
			        <td valign=top nowrap width='1'>&nbsp;</td>

                    <td valign=top nowrap width='100%'>
                    <!-- <td valign=top nowrap width='650'> -->
                        <ul id="nav">
                            <% Response.write( cadenaMenu ) %>
                        </ul>
                    </td>

			        <td valign=top width='150' class="FuenteEncabezados" align=center nowrap>
			        <!-- <td valign=top width='33%' class="FuenteEncabezados" align=center nowrap> -->
                        <span id="spanNombreEmpresa"><%=Session("Nombre_Empresa")%>&nbsp;</span>
                    </td>

                </tr>
            </table>
            <input type=Hidden name="LimpiaVarSesion" value="">
            <input type=Hidden name="UltimaOpcionSeleccionada" value="">
        <% else %>
		    <script language="JavaScript">
		        alert('Este usuario no tiene opciones asociadas al perfil. \n\n Contáctese con el administrador.');
		        parent.top.location.href = "Index1.htm";
		    </script>
        <% end if %>
        </form>
    </body>
    <script type='text/javascript'>
        function fOver() {
            parent.top.frames['frameMenu'].rows = '100%, 0, 0, 0';
        }
        function fOut() {
            parent.top.frames['frameMenu'].rows = '20px, *, 5%, 5%';
        }

        function fLink(url, obj) {
            var UltimaOpcionSeleccionada = document.menu.UltimaOpcionSeleccionada.value;
            if (UltimaOpcionSeleccionada != "") {
                // ver.1.0
                eval('document.all("' + UltimaOpcionSeleccionada + '").style.color = "#000"');
                // ver.1.1
                eval('document.all("' + UltimaOpcionSeleccionada + '").className = "colorActive"');
            }
            document.menu.UltimaOpcionSeleccionada.value = "linkOpcion_" + obj;

            // ver.1.0
            eval('document.all("linkOpcion_' + obj + '").style.color = "#000"');
            // ver.1.1
            eval('document.all("linkOpcion_' + obj + '").className = "colorVisited"');

            parent.top.frames['frameMenu'].rows = '20px, *, 5%, 5%';
            parent.top.Trabajo.location.href = url;
        }

        function fInicio() {
            parent.top.location.href = 'InicioSession.asp';
        }
    </script>
</html>

<iframe frameborder="0" Id="Paso1" Name="Paso1" src="empty.asp" width=0 height=0></iframe>
<iframe frameborder="0" Id="Paso2" Name="Paso2" src="empty.asp" width=0 height=0></iframe>
<iframe frameborder="0" Id="Paso3" Name="Paso3" src="empty.asp" width=0 height=0></iframe>
<iframe frameborder="0" Id="Paso4" Name="Paso4" src="empty.asp" width=0 height=0></iframe>
<iframe frameborder="0" Id="Paso5" Name="Paso5" src="empty.asp" width=0 height=0></iframe>
