<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">
   Function Cache()
	Response.addHeader "pragma", "no-cache"
	Response.CacheControl = "Private"
	Response.ExpiresAbsolute = #1/5/2000 12:12:12#
   End Function

   Function ShowError( valor )
	Response.Write "<table width=95% align=center border=0 cellspacing=0 cellpadding=0 >"
	Response.Write "<tr class=FuenteError>"
	Response.Write "	<td width=100% align=center>Ocurrió un ¡¡¡ ERROR !!!</td>"
	Response.Write "</tr>"
	Response.Write "<tr class=FuenteError>"
	Response.Write "	<td width=100% align=center>" & Replace(valor ,"[Microsoft][ODBC SQL Server Driver][SQL Server]","") & "&nbsp;</td>"
	Response.Write "</tr>"
	Response.Write "<tr class=FuenteError>"
	Response.Write "	<td width=100% align=center>Comuníquese con el Administrador del Sistema para corregir el problema.</td>"
	Response.Write "</tr>"
	Response.Write "</table>"
   End Function

   Function LimpiaError( valor )
	if Instr(1,valor,"FK_Movimientos_productos_Productos") > 0 then
	     valor = "El item ingresado no existe, revise por favor."
	end if
        LimpiaError = Replace(Replace(valor ,"[Microsoft][ODBC SQL Server Driver][SQL Server]",""), "'", "")
   End Function

   Function Esperar(texto)
    if len(trim(Texto)) = 0 then Texto = "Buscando ...."
    Response.Buffer = True  
    Response.Write "<div id='loadingDiv'>"
    Response.Write "<table border=0 cellpadding=0 cellspacing=0 width=100% height=100% >"
    Response.Write "<tr>"
    Response.Write "<td height=10% valign=bottom align='center' Class='FuenteInput'>" & texto & "</td>"
    Response.Write "</tr>"
    Response.Write "<tr >"
    Response.Write "<td height=90% valign=top align='center' Class='FuenteInput'><img border=0 src='../../imagenes/progress_bar.gif' width=300px height=20px/></td>"
    Response.Write "</tr>"
    Response.Write "</table>"
    Response.Write "</div>"
    Response.Flush
   End Function

</SCRIPT>
