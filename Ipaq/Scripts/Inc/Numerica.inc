<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">
	Sub ChequeaNumero(objeto,Indice)		'Ricardo              
	    
	    Tecla = window.event.keyCode                            

	    If Not Isnumeric(Indice) Then  
	       
	       If Trim(document.all(objeto).value) <> "" Then       
			  If Tecla = 190 Or _
	             Tecla = 110 Or _
	             (Tecla >= 48 And Tecla <=57) Or _
	             (Tecla >= 96 And Tecla <=105) Then 
	          
	             If Tecla = 190 Or Tecla = 110 Then
	                Puntos = 0             
	             
	                For i = 1 to Len(document.all(objeto).value)
	                    If Mid(document.all(objeto).value,i,1) = "." Then
	                       Puntos = Puntos + 1
	                    End if
	                Next
	          
	                If Puntos > 1 Then
	                   document.all(objeto).value = Left(document.all(objeto).value,Len(document.all(objeto).value)-1)   
	                End if   
	             End if          
	          Else
	             If Not Isnumeric(Mid(document.all(objeto).value,Len(document.all(objeto).value))) Then          
	                document.all(objeto).value = Left(document.all(objeto).value,Len(document.all(objeto).value)-1)
	             End if   
	          End if       
	       End if
	    
	    Else 'If Not Isnumeric(Indice) Then  
	       Indice = CInt(Indice)
	       
	       If Trim(document.all(objeto)(Indice).value) <> "" Then       
	          If Tecla = 190 Or _
	             Tecla = 110 Or _
	             (Tecla >= 48 And Tecla <=57) Or _
	             (Tecla >= 96 And Tecla <=105) Then 
	          
	             If Tecla = 190 Or Tecla = 110 Then
	                Puntos = 0             
	             
	                For i = 1 to Len(document.all(objeto)(Indice).value)
	                    If Mid(document.all(objeto)(Indice).value,i,1) = "." Then
	                       Puntos = Puntos + 1
	                    End if
	                Next
	          
	                If Puntos > 1 Then
	                   document.all(objeto)(Indice).value = Left(document.all(objeto)(Indice).value,Len(document.all(objeto)(Indice).value)-1)   
	                End if   
	             End if          
	          Else
	             If Not Isnumeric(Mid(document.all(objeto)(Indice).value,Len(document.all(objeto)(Indice).value))) Then          
	                document.all(objeto)(Indice).value = Left(document.all(objeto)(Indice).value,Len(document.all(objeto)(Indice).value)-1)
	             End if   
	          End if       
	       End if

	    End if 'If Not Isnumeric(Indice) Then  
	End Sub
</script>