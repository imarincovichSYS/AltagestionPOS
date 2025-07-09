<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
	Switch = 0


	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

	Producto		= Request ("Producto")
    Bodega			= Request ("Bodega")
    Superfamilia	= Request ("Slct_SuperFam")
    Familia			= Request ("Slct_Familia")
    Subfamilia		= Request ("Slct_SubFamilia")
	Empresa			= Session ("Empresa_usuario")
	cSql = "Exec PRB_Toma_Inventario "	cSql = cSql & "'" & Session ("Empresa_usuario") & "', "	cSql = cSql & "'" & Bodega & "', "
	cSql = cSql & "'" & Producto & "', "
	cSql = cSql & "'" & Superfamilia & "', "
	cSql = cSql & "'" & Familia & "', "
	cSql = cSql & "'" & SubFamilia & "'"

'Response.Write cSql
	SET Rs	=	Conn.Execute( cSql )				
		if Not Rs.Eof then 
			Switch = 1		
			TotalCampos = Rs.FIELDS.COUNT
				Set oBitacora = Server.CreateObject("Scripting.FileSystemObject")
				NombreArchivo = "TomaInventario_" & Year(date()) & Right("00" & Month(date()), 2) & Right("00" & Day(date()), 2) & "_" & Replace(time(), ":","") & ".csv"
				UrlDesarrollo = Server.MapPath(".") & "\"
				Set fnBitacora = oBitacora.OpenTextFile(UrlDesarrollo + NombreArchivo, 2, True, 0)
					For	i=0 to TotalCampos-1
						if i<>0 then
							fnBitacora.Write ","
						end if
						fnBitacora.Write ( Rs.fields(i).name )
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
