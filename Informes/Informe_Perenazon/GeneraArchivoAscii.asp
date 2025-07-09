<!-- #include file="../../Scripts/Inc/Cache.inc"-->
<!-- #include file="../../Scripts/Inc/Fechas.inc"-->
<!-- #include file="../../Scripts/Inc/Caracteres.inc"-->
<%
	Cache
on error resume next

	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
	
	Fecha_desde = cambia_fecha(request("Fecha_desde")) & " 00:00:00"
	Fecha_hasta = cambia_fecha(request("Fecha_hasta")) & " 23:59:59"
	
	cSql = "Exec DOV_Informe_PARENAZON '" & Session("empresa_usuario") & "', '" &Fecha_desde&"','"&Fecha_hasta&"'"
'Response.Write cSql
	SET Rs	=	Conn.Execute( cSQL )				
	
	if len(trim(err.Description)) = 0 then
		if Not Rs.Eof then 
				Set oBitacora = Server.CreateObject("Scripting.FileSystemObject")
				NombreArchivo = "InformePerenazon_" & Year(date()) & Right("00" & Month(date()), 2) & Right("00" & Day(date()), 2) & "_" & Replace(time(), ":","") & ".txt"

				UrlDesarrollo = Server.MapPath(".") & "\"

				Set fnBitacora = oBitacora.OpenTextFile(UrlDesarrollo + NombreArchivo, 2, True, 0)
'				fnBitacora.Write "Registro" & chr(13) & chr(10)
		  	    Do while Not Rs.Eof 
					fnBitacora.Write Rs("Registro") &  chr(13) & chr(10)
					Rs.MoveNext				
				Loop				
				fnBitacora.Close				
		Rs.Close
		Conn.Close


		Dim objZip
		Dim filesys, filetxt, getname, path

		Set objZip = Server.CreateObject("XStandard.Zip")

		Set filesys = Server.CreateObject("Scripting.FileSystemObject")
		

		NombreArchivoZip = Replace(NombreArchivo,".txt",".zip")
		Url			= UrlDesarrollo
		ArchivoZip	= UrlDesarrollo & NombreArchivoZip
		ArchivoCSV	= UrlDesarrollo & NombreArchivo

		path = Server.MapPath(NombreArchivoZip)
		if filesys.FileExists(left(path,93)) then
			filesys.DeleteFile (left(path,93))
		end if
		
		objZip.Pack ArchivoCSV, ArchivoZip		
				
		Set objZip = Nothing
		
		Do While Not filesys.FileExists(path)
			Response.Write filesys.FileExists(path) & "<br>"
		Loop 
		filesys.DeleteFile( Server.MapPath(NombreArchivo) )		
		set filesys = nothing
		set objZip = nothing



		%>
        <script language="JavaScript">
            location.href ="../../Download/Download.asp?Archivo=<%=NombreArchivoZip%>&RutaArchivo=<%=Replace(Server.MapPath( NombreArchivoZip ),"\","*") %>"
        </script>
	<%	else %>
			<script language="JavaScript">
				alert ( "Con el criterio especificado no se encontró información por lo tanto no se generó el archivo." );
			</script>
	<%	end if 
	else 
		msgerror = limpiaerror(err.Description)
	%>
		<script language="JavaScript">
			alert ( "<%=msgerror%>" );
		</script>
<%	end if %>
