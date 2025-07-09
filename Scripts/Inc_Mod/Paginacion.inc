<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">
   Function Paginacion(abspage,TotalPag,RegLista)
	'abspage  = página a la nos movemos resultado del recordset
	'TotalPag = total de páginas devueltas por el recordset
	'RegLista = Valor que indica en los mensajes cuantos registros se van a mostrar.
		Response.Write "<table Width=95% border=0 align=center cellspacing=0 cellpadding=0 >" & chr(13)
		Response.Write cSpaces(23) & "<tr class=FuenteEncabezados>" & chr(13)
		Response.Write cSpaces(31) & "<td width=1%>&nbsp;</td>" & chr(13)
		if abspage > 1 then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:PrimeraPag();Mensajes('')" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & " OnMouseMove=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " Onfocus=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " OnMouseOver=" & chr(34) & "Mensajes('Retrocede hasta la primera página, mostrando los " & RegLista & " primeros registros.')" & chr(34) & " OnMouseOut=" & chr(34) & "Mensajes('')" & chr(34) & "><b>Página 1</b></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if
		if abspage > 1 or pagecnt <> abspage then
		end if

		if abspage > 1 then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:repag();Mensajes('')" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & " OnMouseMove=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " Onfocus=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " OnMouseOver=" & chr(34) & "Mensajes('Retrocede una página mostrando los " & RegLista & " registros anteriores.')" & chr(34) & " OnMouseOut=" & chr(34) & "Mensajes('')" & chr(34) & "><B>Retroceder</B></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if

		if pagecnt <> abspage then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:avpag();Mensajes('')" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & " OnMouseMove=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " Onfocus=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " OnMouseOver=" & chr(34) & "javascript:Mensajes('Avanza una página mostrando los siguientes " & RegLista & " registros.')" & chr(34) & " OnMouseOut=" & chr(34) & "javascript:Mensajes('')" & chr(34) & "><b>Avanzar</b></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if

		if pagecnt > 1 And pagecnt <> abspage then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:UltimaPag();Mensajes('')" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & " OnMouseMove=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " Onfocus=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " OnMouseOver=" & chr(34) & "Mensajes('Avanza hasta la útlima página, mostrando los " & RegLista & " últimos registros.')" & chr(34) & " OnMouseOut=" & chr(34) & "Mensajes('')" & chr(34) & "><b>Última página</b></td>" & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if
		if TotalPag > 0 then
			Response.Write cSpaces(31) & "<td nowrap class=FuenteEncabezados align=right><b>Página actual :&nbsp;&nbsp;" & abspage & "&nbsp;/&nbsp;" & TotalPag & "</b></td>" & chr(13)
		end if
	Response.Write cSpaces(23) & "</tr>" & chr(13)
	Response.Write cSpaces(16) & "</table>" & chr(13)
   End Function
   
   Function Paginacion_Ayuda(abspage,TotalPag,RegLista)
	'abspage  = página a la nos movemos resultado del recordset
	'TotalPag = total de páginas devueltas por el recordset
	'RegLista = Valor que indica en los mensajes cuantos registros se van a mostrar.
		Response.Write "<table Width=95% border=0 align=center cellspacing=0 cellpadding=0 >" & chr(13)
		Response.Write cSpaces(23) & "<tr class=FuenteEncabezados>" & chr(13)
		Response.Write cSpaces(31) & "<td width=1%>&nbsp;</td>" & chr(13)
		if abspage > 1 then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:PrimeraPag()" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & "><b>Página 1</b></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if
		if abspage > 1 or pagecnt <> abspage then
		end if

		if abspage > 1 then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:repag()" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & "><B>Retroceder</B></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if

		if pagecnt <> abspage then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:avpag()" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & "><b>Avanzar</b></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if

		if pagecnt > 1 And pagecnt <> abspage then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:UltimaPag()" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & "><b>Última página</b></td>" & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if
		if TotalPag > 0 then
			Response.Write cSpaces(31) & "<td class=FuenteEncabezados align=right><b>Página actual :&nbsp;&nbsp;" & abspage & "&nbsp;/&nbsp;" & TotalPag & "</b></td>" & chr(13)
		end if
	Response.Write cSpaces(23) & "</tr>" & chr(13)
	Response.Write cSpaces(16) & "</table>" & chr(13)
   End Function

   Function Paginacion_PControl(abspage,TotalPag,RegLista)
	'abspage  = página a la nos movemos resultado del recordset
	'TotalPag = total de páginas devueltas por el recordset
	'RegLista = Valor que indica en los mensajes cuantos registros se van a mostrar.
		Response.Write "<table Width=95% border=0 align=center cellspacing=0 cellpadding=0 >" & chr(13)
		Response.Write cSpaces(23) & "<tr class=PC_FuenteEncabezados>" & chr(13)
		Response.Write cSpaces(31) & "<td width=1%>&nbsp;</td>" & chr(13)
		if abspage > 1 then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:PrimeraPag();" & chr(34) & " class=" & chr(34) & "PC_FuenteTextoAvRePagina" & chr(34) & "><b>&nbsp;<<&nbsp;</b></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if
		if abspage > 1 or pagecnt <> abspage then
		end if

		if abspage > 1 then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:repag();" & chr(34) & " class=" & chr(34) & "PC_FuenteTextoAvRePagina" & chr(34) & "><B>&nbsp;<&nbsp;</B></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if

		if pagecnt <> abspage then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:avpag();" & chr(34) & " class=" & chr(34) & "PC_FuenteTextoAvRePagina" & chr(34) & "><b>&nbsp;>&nbsp;</b></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if

		if pagecnt > 1 And pagecnt <> abspage then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:UltimaPag();" & chr(34) & " class=" & chr(34) & "PC_FuenteTextoAvRePagina" & chr(34) & "><b>&nbsp;>>&nbsp;</b></td>" & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if
		if TotalPag > 0 then
			Response.Write cSpaces(31) & "<td nowrap class=PC_FuenteEncabezados align=right><b>Página actual :&nbsp;&nbsp;" & abspage & "&nbsp;/&nbsp;" & TotalPag & "</b></td>" & chr(13)
		end if
	Response.Write cSpaces(23) & "</tr>" & chr(13)
	Response.Write cSpaces(16) & "</table>" & chr(13)
   End Function

   Function Paginacion_OCMaestra(abspage,TotalPag,RegLista)
	'abspage  = página a la nos movemos resultado del recordset
	'TotalPag = total de páginas devueltas por el recordset
	'RegLista = Valor que indica en los mensajes cuantos registros se van a mostrar.
		Response.Write "<table Width=95% border=0 align=center cellspacing=0 cellpadding=0 >" & chr(13)
		Response.Write cSpaces(23) & "<tr class=FuenteEncabezados>" & chr(13)
		Response.Write cSpaces(31) & "<td width=1%>&nbsp;</td>" & chr(13)
		if abspage > 1 then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:PrimeraPag();Mensajes('')" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & " OnMouseMove=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " Onfocus=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " OnMouseOver=" & chr(34) & "Mensajes('Retrocede hasta la primera página, mostrando los " & RegLista & " primeros registros.')" & chr(34) & " OnMouseOut=" & chr(34) & "Mensajes('')" & chr(34) & "><b>Página 1</b></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if
		if abspage > 1 or pagecnt <> abspage then
		end if

		if abspage > 1 then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:repag();Mensajes('')" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & " OnMouseMove=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " Onfocus=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " OnMouseOver=" & chr(34) & "Mensajes('Retrocede una página mostrando los " & RegLista & " registros anteriores.')" & chr(34) & " OnMouseOut=" & chr(34) & "Mensajes('')" & chr(34) & "><B>Retroceder</B></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if

		if pagecnt <> abspage then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:avpag();Mensajes('')" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & " OnMouseMove=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " Onfocus=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " OnMouseOver=" & chr(34) & "javascript:Mensajes('Avanza una página mostrando los siguientes " & RegLista & " registros.')" & chr(34) & " OnMouseOut=" & chr(34) & "javascript:Mensajes('')" & chr(34) & "><b>Avanzar</b></td>"  & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if

		if pagecnt > 1 And pagecnt <> abspage then
			Response.Write cSpaces(31) & "<td nowrap width=15%><a href=" & chr(34) & "javascript:UltimaPag();Mensajes('')" & chr(34) & " class=" & chr(34) & "FuenteTextoAvRePagina" & chr(34) & " OnMouseMove=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " Onfocus=" & chr(34) & "JavaScript:Limpia_BarraEstado()" & chr(34) & " OnMouseOver=" & chr(34) & "Mensajes('Avanza hasta la página hasta útlima página, mostrando los " & RegLista & " últimos registros.')" & chr(34) & " OnMouseOut=" & chr(34) & "Mensajes('')" & chr(34) & "><b>Última página</b></td>" & chr(13)
		else
			Response.Write cSpaces(31) & "<td width=15%>&nbsp;</td>" & chr(13)
		end if
		if TotalPag > 0 then
			Response.Write cSpaces(31) & "<td nowrap class=FuenteEncabezados align=right><b>Página actual :&nbsp;&nbsp;" & abspage & "&nbsp;/&nbsp;" & TotalPag & "</b></td>" & chr(13)
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
