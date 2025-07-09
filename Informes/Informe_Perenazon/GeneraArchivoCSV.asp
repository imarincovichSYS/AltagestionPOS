<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	Switch = 0


	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	empresa=Session("empresa_usuario")
	Mes=request("Mes")
	Anno=request("Anno")
	cSql = "Exec	 ACO_LibroMayor " &+_
		      "'"  & empresa & "'," & +_
			  "'"  & Mes & "'," & +_
			  "'"  & Anno & "', " & Session.SessionID & ", 'A','" & request("cuenta_contable") & "'"

'Response.Write cSql
	SET Rs	=	Conn.Execute( cSQL )				
		if Not Rs.Eof then 
			Switch = 1		
			TotalCampos = Rs.FIELDS.COUNT
				Set oBitacora = Server.CreateObject("Scripting.FileSystemObject")
				NombreArchivo = "LibroMayor_" & Year(date()) & Right("00" & Month(date()), 2) & Right("00" & Day(date()), 2) & "_" & Replace(time(), ":","") & ".csv"
				UrlDesarrollo = Server.MapPath(".") & "\"
				'"D:\wwwroot\AltaGestion\Abonados\FloraCenter\Consultas\LibroMayor\"
				Set fnBitacora = oBitacora.OpenTextFile(UrlDesarrollo + NombreArchivo, 2, True, 0)
					For	i=0 to TotalCampos-1
						if i<>0 then
							fnBitacora.Write ","
						end if
						 if Rs.fields(i).name = "Numero_documento_no_valorizado" Then 
							fnBitacora.Write ( "Número" ) 
						elseif Rs.fields(i).name = "Fecha_asiento" Then 
							fnBitacora.Write ( "Fecha" ) 
						elseif Rs.fields(i).name = "Cuenta_contable" Then 
							fnBitacora.Write ( "Cod.Cta.Ctable" ) 
						elseif Rs.fields(i).name = "Nombre_cuenta_contable" Then 
							fnBitacora.Write ( "Cuenta contable" ) 
						elseif Rs.fields(i).name = "Documento_respaldo" Then 
							fnBitacora.Write ( "Docto.respaldo" )
						elseif Rs.fields(i).name = "Numero_Documento_respaldo" Then 
							fnBitacora.Write ( "Nro.Docto.respaldo" )
						elseif Rs.fields(i).name = "Observaciones" Then 
							fnBitacora.Write ( "Observaciones" )
						elseif Rs.fields(i).name = "Monto_debe" Then
							fnBitacora.Write ( "Debe" )
						elseif Rs.fields(i).name = "Monto_haber" Then 
							fnBitacora.Write ( "Haber" )
						elseif Rs.fields(i).name = "Saldo_Monto_debe" Then
							fnBitacora.Write ( "Saldo debe" )
						elseif Rs.fields(i).name = "Saldo_Monto_haber" Then 
							fnBitacora.Write ( "Saldo haber" )
						end if
					Next
					fnBitacora.Write chr(13) & chr(10)
					
				Do while Not Rs.Eof 
					For	i=0 to TotalCampos-1
						if i<>0 then
							fnBitacora.Write ","
						end if
						if Rs.fields(i).type = 200 or Rs.fields(i).type = 129 Or Rs.fields(i).type = 135 then ' varchar y char
							fnBitacora.Write ( chr(34) & Rs.fields(i).value & chr(34))
						elseif Rs.fields(i).type = 2 or Rs.fields(i).type = 3 or Rs.fields(i).type = 17 or Rs.fields(i).type = 131 then  ' smallint & integer & tinyint & numeric
							fnBitacora.Write ( "0" & Rs.fields(i).value) 
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
