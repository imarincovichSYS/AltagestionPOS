<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">

Sub SinEspacios (ByRef vardato) 
    Dato = vardato
    varDato = ""
 For nStep = 1 To Len(Dato)
     If Mid(Dato,nStep,1) <> " " Then
     vardato = vardato + Mid(Dato,nStep,1)
  End if
 Next
End Sub

function valida_rut(entrada)

   largo=len(trim(entrada))
   if largo>8 or largo<7 then
	valida_rut=""
	exit function
   end if

   desde=largo

   suma=0

   for n=0 to 5
	suma=suma+mid(entrada,desde-n,1)*(n+2)
   next
   suma=suma+mid(entrada,desde-6,1)*2

   if largo=8 then
	suma=suma+mid(entrada,1,1)*3
   end if

   resultado=11-(suma mod 11)

   if resultado=10 then
	valida_rut="K"
	exit function
   end if
   if resultado=11 then
	valida_rut="0"
	exit function
   end if
   valida_rut=resultado

end function

Function ValidaRut(Rut,Digito)

   DigitoCorrecto = ""

   If not isnumeric(Rut) then 
      ValidaRut = False
      exit function
   End if

   largo = len(trim(Rut))

   If largo > 8 or largo < 7 then
      ValidaRut = False
      exit function
   End If

   desde   = largo
   lasuma  = 0

   For n = 0 to 5
       lasuma = lasuma + Mid(Rut,desde - n,1) * (n + 2)
   Next

   lasuma = lasuma + mid(Rut,desde - 6,1) * 2

   If largo = 8 then
	  lasuma = lasuma + mid(Rut,1,1) * 3
   End If

   resultado = 11 - (lasuma mod 11)

   If resultado = 10 then
      DigitoCorrecto = "K"
   Else   
      If resultado = 11 then
         DigitoCorrecto = "0"
      Else
         DigitoCorrecto = resultado      
      End If
   End If  

   If Cstr(DigitoCorrecto) <> Cstr(Digito) then
      ValidaRut = False
   Else
      ValidaRut = True
   End if

End Function

function valida_perfil(Funcion)

   session("mensaje_error")  = ""
   'Session("session_pagina") = Request.ServerVariables("SCRIPT_NAME")
   valida_perfil             = TRUE

   Funcion = trim(lcase( Funcion ))
   do while instr( Funcion , "/" ) > 0
      Funcion = mid(Funcion,instr( Funcion , "/" )+1)
   loop
   nAt = instr( Funcion , "_" )
   if nAt > 0 then Funcion = mid(Funcion,nAt+1)
   nAt = instr( Funcion , ".asp" )
   if nAt > 0 then Funcion = mid(Funcion,1,nAt-1)

 '  if Session("valida_"&Funcion) <> Session("session_codigo_usuario") then

      set conn = server.createobject("adodb.connection")
      conn.open Session("DataConn_ConnectionString")

      if valida_perfil then

		  Sql = "exec FPR_ListaFuncionesPerfil " +_
                "'" &  Session("session_codigo_perfil") &"'," + _
                "'" &  Funcion & "',1"
'response.write (sql)
		  Set RS = Conn.Execute (sql)

'response.write(RS("Fecha_caducidad") & "-" & date())
         if RS.Eof or len(Session("session_codigo_perfil"))=0 or (RS("Fecha_caducidad") < date() and RS("Fecha_caducidad") <> "01/01/1900") then
            valida_perfil = FALSE
         end if
      end if

      RS.close
      Conn.close

	'  if valida_perfil then Session("valida_"&Funcion) = Session("session_codigo_usuario")

 '  end if
end function

     Function AjustaTexto( texto, ancho )
          for c=1 to ancho
	     cCadena = cCadena & " "
	  next
		  NvoTexto = ""
	if len(texto) < ancho then 
	   AjustaTexto = Trim(texto)
	else
	   for a=1 to len(texto)
	         texto = texto & cCadena
	      for b=ancho to 1 step -1
	          if Mid(texto,b,1) = " " then
		     NvoTexto = Trim(NvoTexto) & Trim(Mid(texto,1,b)) & "<br>"
		     texto = Trim(Mid(texto,b,len(texto) ))
		     exit for
		   end if     
	      next
	    next
	    AjustaTexto = Trim(NvoTexto)
  	 end if
     End function


	Function Repetir( caracter, cantidad)		
		Cadena = ""
		for a=1 to Int(cantidad)
			Cadena = Cadena & caracter
		next
		Repetir = Cadena
	End function

	Function FormateoNumerico( valor, Decimales )
		if valor > 0 then
		  Dec = Int((valor - Int(valor)) * 10^int(Decimales))
		  Entera = Replace(Replace(Int(valor),",",""),".","")
                   if Int(Decimales) = 0 then
		     FormateoNumerico =  cStr(Entera) 
		   else
		     FormateoNumerico =  cStr(Entera) & "." & left(cStr(Dec) & Repetir("0", cdbl(Decimales)),cdbl(Decimales))
		   end if
		Else
		  FormateoNumerico = 0
		end if
	End function

</SCRIPT>