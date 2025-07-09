<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	Switch = 0


	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout = 3600

	Mes		= Request("Mes")
	Anno	= Request("Anno")

	cSql = "Exec INF_Importaciones " &+_
          "'"  & Session("Empresa_usuario")		& "'," & +_
          "'"  & Request("Proveedor")			& "'," & +_
          "'"  & Request("Carpeta")				& "'," & +_
          "0"  & Request("NroOCP")				& ", " & +_
          "'"  & Request("Fecha_desde")			& "'," & +_
          "'"  & Request("Fecha_hasta")			& "'," & +_
          "'"  & Request("Rec_desde")			& "'," & +_
          "'"  & Request("Rec_hasta")			& "'," & +_
          "'"  & Request("Modo")				& "'"

'Response.Write cSql
	SET Rs	=	Conn.Execute( cSQL )				
		if Not Rs.Eof then 
			Switch = 1		
			TotalCampos = Rs.FIELDS.COUNT
				Set oBitacora = Server.CreateObject("Scripting.FileSystemObject")
				NombreArchivo = "InformeImportaciones_" & Year(date()) & Right("00" & Month(date()), 2) & Right("00" & Day(date()), 2) & "_" & Replace(time(), ":","") & ".csv"
				UrlDesarrollo = Server.MapPath(".") & "\"
				Set fnBitacora = oBitacora.OpenTextFile(UrlDesarrollo + NombreArchivo, 2, True, 0)
					For	i=0 to TotalCampos-1

						if Trim(Rs.fields(i).name) <> "Monto_afecto_moneda_oficial"  and _
						   Trim(Rs.fields(i).name) <> "Monto_exento_moneda_oficial" and  _
						   Trim(Rs.fields(i).name) <> "Monto_iva_moneda_oficial" and _
						   Trim(Rs.fields(i).name) <> "Valor_paridad_moneda_oficial" and _
						   Trim(Rs.fields(i).name) <> "Fecha_paridad_moneda_oficial" then
							if i<>0 then
								fnBitacora.Write ","
							end if
							fnBitacora.Write ( Rs.fields(i).name ) 
						end if
					Next
					fnBitacora.Write chr(13) & chr(10)
					
				Do while Not Rs.Eof 
					For	i=0 to TotalCampos-1
						if Trim(Rs.fields(i).name) <> "Monto_afecto_moneda_oficial"  and _
						   Trim(Rs.fields(i).name) <> "Monto_exento_moneda_oficial" and  _
						   Trim(Rs.fields(i).name) <> "Monto_iva_moneda_oficial" and _
						   Trim(Rs.fields(i).name) <> "Valor_paridad_moneda_oficial" and _
						   Trim(Rs.fields(i).name) <> "Fecha_paridad_moneda_oficial" then
							if i<>0 then
								fnBitacora.Write ","
							end if
							if Rs.fields(i).type = 200 or Rs.fields(i).type = 129 Or Rs.fields(i).type = 135 then ' varchar y char
								if Rs.fields(i).type = 135 then
									if Rs.fields(i).value <> "" then
										fnBitacora.Write ( day(Rs.fields(i).value) & "/" & month(Rs.fields(i).value) & "/" & year(Rs.fields(i).value) )
									end if
								else
									fnBitacora.Write ( chr(34) & Rs.fields(i).value & chr(34))
								end if
							elseif Rs.fields(i).type = 2 or Rs.fields(i).type = 3 or Rs.fields(i).type = 17 or Rs.fields(i).type = 131 then  ' smallint & integer & tinyint & numeric
	'Response.Write Rs.fields(i).value & Chr(13) & Chr(10)
								if IsNull(Rs.fields(i).value) then
									fnBitacora.Write ( 0 )
								else
									fnBitacora.Write ( Rs.fields(i).value )
								end if
							end if							
						end if							
					Next
					fnBitacora.Write chr(13) & chr(10)
					Rs.MoveNext				
				Loop				
				fnBitacora.Close				
		End if
	Rs.Close
	Conn.Close
	if Switch = 1 then
		'Response.Redirect NombreArchivo%>
	  <script language="JavaScript">
		location.href ="../../Download/Download.asp?Archivo=<%=NombreArchivo%>&RutaArchivo=<%=Replace(Server.MapPath( NombreArchivo ),"\","*") %>"
	  </script>
	<%else %>
		<script language="JavaScript">
			alert ( "Con el criterio especificado no se encontró información por lo tanto no se generó el archivo." );
		</script>
<% end if %>
