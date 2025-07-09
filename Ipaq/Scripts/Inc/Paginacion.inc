<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">
   Function PaginacionPocket(abspage,TotalPag,RegLista)
	'abspage  = página a la nos movemos resultado del recordset
	'TotalPag = total de páginas devueltas por el recordset
	'RegLista = Valor que indica en los mensajes cuantos registros se van a mostrar.
		Response.Write "<table Width=95% border=0 align=center cellspacing=0 cellpadding=0 >" & chr(13)
		Response.Write cSpaces(23) & "<tr class=FuenteEncabezados>" & chr(13)
		'Response.Write cSpaces(31) & "<td class=FuenteInput width=1%>&nbsp;</td>" & chr(13)
		if abspage > 1 then
			Response.Write cSpaces(31) & "<td class=FuenteInput nowrap width=15%><a href=" & chr(34) & "javascript:PrimeraPag();" & chr(34) & "><img src='../../Imagenes/arrows_double_left.gif' width=10 heigth=10 border=0></img></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td class=FuenteInput  width=15%>&nbsp;</td>" & chr(13)
		end if
		if abspage > 1 or pagecnt <> abspage then
		end if

		if abspage > 1 then
			Response.Write cSpaces(31) & "<td class=FuenteInput nowrap width=15%><a href=" & chr(34) & "javascript:repag();" & chr(34) & " ><img src='../../Imagenes/arrows_left.gif' width=10 heigth=10 border=0></img></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td class=FuenteInput width=15%>&nbsp;</td>" & chr(13)
		end if

		if pagecnt <> abspage then
			Response.Write cSpaces(31) & "<td class=FuenteInput nowrap width=15%><a href=" & chr(34) & "javascript:avpag();" & chr(34) & " ><img src='../../Imagenes/arrows_right.gif' width=10 heigth=10 border=0></img></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td class=FuenteInput width=15%>&nbsp;</td>" & chr(13)
		end if

		if pagecnt > 1 And pagecnt <> abspage then
			Response.Write cSpaces(31) & "<td class=FuenteInput nowrap width=15%><a href=" & chr(34) & "javascript:UltimaPag();" & chr(34) & " ><img src='../../Imagenes/arrows_double_right.gif' width=10 heigth=10 border=0></img></td>" & chr(13)
		else
			Response.Write cSpaces(31) & "<td class=FuenteInput width=15%>&nbsp;</td>" & chr(13)
		end if
		if TotalPag > 0 then
			Response.Write cSpaces(31) & "<td class=FuenteInput align=right>Pág.:&nbsp;&nbsp;" & abspage & "&nbsp;/&nbsp;" & TotalPag & "</td>" & chr(13)
		end if
	Response.Write cSpaces(23) & "</tr>" & chr(13)
	Response.Write cSpaces(16) & "</table>" & chr(13)
   End Function
   
   Function cSpaces( valor )
		Dim a
		a=0
		if valor >= 1 then
			For a=1 to valor
				Response.Write " "
			next
		end if
   End Function
</SCRIPT>
