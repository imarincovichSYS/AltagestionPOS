<SCRIPT RUNAT=SERVER LANGUAGE="VBscript">

function NombreMes( valor )
  if valor = 01 then
	NombreMes = "Enero"
  elseif valor = 02 then
	NombreMes = "Febrero"
  elseif valor = 03 then
	NombreMes = "Marzo"
  elseif valor = 04 then
	NombreMes = "Abril"
  elseif valor = 05 then
	NombreMes = "Mayo"
  elseif valor = 06 then
	NombreMes = "Junio"
  elseif valor = 07 then
	NombreMes = "Julio"
  elseif valor = 08 then
	NombreMes = "Agosto"
  elseif valor = 09 then
	NombreMes = "Septiembre"
  elseif valor = 10 then
	NombreMes = "Octubre"
  elseif valor = 11 then
	NombreMes = "Noviembre"
  elseif valor = 12 then
	NombreMes = "Diciembre"
  end if
end function

Function ConvierteFecha(fecha,hora)
if not isDate(fecha) or not isDate(hora) or len(fecha)<>10 or len(hora)<>5 then	
	ConvierteFecha=""
	Exit Function
end if
cad = ""
dia = left(fecha,2)	
mes = mid(fecha,4,2)
agno = right(fecha,4) 
if mes > 12 then
	ConvierteFecha=""
	Exit Function
end if
hora = left(hora,2)
minutos = right(hora,2)
cad = agno & "/" & mes & "/" & dia
ConvierteFecha = cad
End Function

Sub ChequeaHora(objeto,Indice)		'Ricardo                            
    Dim MsgError
       
    If Not Isnumeric(Indice) Then
       Hora = document.all(objeto).value        
    Else
       Indice = CInt(Indice)               
       Hora  = document.all(objeto)(Indice).value
    End if
      
    If Trim(Hora) = "" Then
       'Hora esta en blanco
       Exit Sub
    Else         
       If Not Isdate(Hora) Then
          MsgError = "Hora no valida"         
       Else
  		  Partes = Split(Hora,":",-1,1)
      
  		  If Ubound(Partes) < 1 Then '0,1
		     MsgError = "Hora no valida" + chr(13) + "utilice el formato hh:mm"
		  Else
		     If Len(Partes(0)) > 2 Or Len(Partes(1)) > 2 Then
		        MsgError = "Hora no valida" + chr(13) + "utilice el formato hh:mm"
		     End if            		
		  End if                     
       End if                     
    End if                  
      
    If Trim(MsgError) <> "" Then
       Msgbox MsgError,16,"Error"
       
       on error resume next  
       
       If Not Isnumeric(Indice) Then
          document.all(objeto).value = ""
          document.all(objeto).focus
       Else            
          document.all(objeto)(Indice).value = ""
          document.all(objeto)(Indice).focus
       End if
         
       window.event.cancelBubble = True
    End if
End Sub

	Function ChequeaFechaMayor(FechaInicio,FechaFin)	'Ricardo               
	    If CDate(Trim(FechaInicio)) < CDate(Trim(FechaFin)) Then
	       ChequeaFechaMayor = True
	    Else
	       ChequeaFechaMayor = False
	    End if
	End Function

Sub ChequeaFecha(objeto,Indice)		'Ricardo              
    Dim MsgError
       
    If Not Isnumeric(Indice) Then
       Fecha = document.all(objeto).value        
    Else
       Indice = CInt(Indice)               
       Fecha  = document.all(objeto)(Indice).value
    End if
      
    If Trim(Fecha) = "" Then
       'Fecha esta en blanco
       Exit Sub
    Else         
       If Not Isdate(Fecha) Then
          MsgError = "Fecha no valida"         
       Else
          If Instr(1,Fecha,"-",1) And Instr(1,Fecha,"/",1) Then
             MsgError = "Fecha no valida" + chr(13) + "utilice solo un separador"
          Else
   		     If Instr(1,Fecha,"-",1) <= 0 And Instr(1,Fecha,"/",1) <= 0 Then
			    MsgError = "Fecha no valida" + chr(13) + "utilice algún separador"
			 Else
    		    If Instr(1,Fecha,"-",1) Then
 			       Separador = "-"
				Else
				   Separador = "/"
				End if   
      
				Partes = Split(Fecha,Separador,-1,1)
      
				If Ubound(Partes) < 2 Then '0,1,2
				   MsgError = "Fecha no valida" + chr(13) + "utilice el formato dd/mm/aaaa"
				Else
				   If Len(Partes(0)) > 2 Or Len(Partes(1)) > 2 Or Len(Partes(2)) < 4 Then
				      MsgError = "Fecha no valida" + chr(13) + "utilice el formato dd/mm/aaaa"
				   End if            
				End if				  
			 End if                     
          End if                  
       End if                     
    End if                  
      
    If Trim(MsgError) <> "" Then
       Msgbox MsgError,16,"Error"
       
       on error resume next  
       
       If Not Isnumeric(Indice) Then
          document.all(objeto).value = ""
          document.all(objeto).focus
       Else            
          document.all(objeto)(Indice).value = ""
          document.all(objeto)(Indice).focus
       End if
         
       window.event.cancelBubble = True
    End if
End Sub

Function Nombre_mes_castellano(mes)
select case mes
 case "01" nombre ="Enero"
    case "02" nombre ="Febrero"
    case "03" nombre ="Marzo"
    case "04" nombre ="Abril"
    case "05" nombre ="Mayo"
    case "06" nombre ="Junio"
    case "07" nombre ="Julio"
    case "08" nombre ="Agosto"
    case "09" nombre ="Septiembre"
    case "10" nombre ="Octubre"
    case "11" nombre ="Noviembre"
    case "12" nombre ="Diciembre"
end select
Nombre_mes_castellano = nombre
End Function

Function Cambia_idioma_mes(mes)
select case mes
   case "enero" nombre ="Jan"
   case "febrero" nombre ="Feb"
   case "marzo" nombre ="Mar"
   case "abril" nombre ="Apr"
   case "mayo" nombre ="May"
   case "junio" nombre ="Jun"
   case "julio" nombre ="Jul"
   case "agosto" nombre ="Aug"
   case "septiembre" nombre ="Sep"
   case "octubre" nombre ="Oct"
   case "noviembre" nombre ="Nov"
   case "diciembre" nombre ="Dec"
end select
   Cambia_idioma_mes = nombre
End Function

Function cambia_fecha_americana (fecha_in)
  if isnull(fecha_in) then
    cambia_fecha_americana = ""
  else
    nAM=Instr(fecha_in,"AM")
    nPM=Instr(fecha_in,"PM")
	if nAM > 0 then	fecha_in=MID(fecha_in,1,nAM -1)
	if nPM > 0 then	fecha_in=MID(fecha_in,1,nPM -1) 
    fecha1 = cDate(fecha_in)
	if InStr(fecha_in,":")=0 then
	  hora1=""
    else
     hora1 = Mid(fecha_in,InStr(fecha_in,":")-3)  
    end if

    dia = Day(fecha1)
    mes = Month(fecha1)
    ano = Year(fecha1)
      cambia_fecha_americana = dia & "/" & mes & "/" & ano & hora1
  end if
End Function

Function cambia_fecha (fecha_in)
  if isnull(fecha_in) then
    cambia_fecha= ""
  else
    nAM=Instr(fecha_in,"AM")
    nPM=Instr(fecha_in,"PM")
	if nAM > 0 then	fecha_in=MID(fecha_in,1,nAM -1)
	if nPM > 0 then	fecha_in=MID(fecha_in,1,nPM -1) 
    fecha1 = cDate(fecha_in)
	if InStr(fecha_in,":")=0 then
	  hora1=""
    else
     hora1 = Mid(fecha_in,InStr(fecha_in,":")-3)  
    end if

    dia = Right("00" & Day(fecha1),2)
    mes = Right("00" & Month(fecha1),2)
    ano = Year(fecha1)
    cambia_fecha=ano & "/" & mes & "/" & dia & hora1
  end if
End Function

Function cambia_formato_fecha (fecha_in)
if isnull(fecha_in) then
 cambia_formato_fecha= ""
else
 fecha=Cdate(fecha_in)
 dia=Day(fecha)
 mes = Month(fecha)
 nombre_mes=Cambia_idioma_mes(MonthName(mes))
 ano=Year(fecha)
 cambia_formato_fecha=nombre_mes & " " & dia & " " & ano
end if
End Function

</script>