<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
Cache
set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 100

MensajeError = ""

on error resume next

cSql = "Exec PAR_ListaParametros 'IMPBOLEVTA'"
Set Rs = Conn.Execute ( cSql )
If Not Rs.Eof then
   Puerto = Rs("Valor_Texto")
else
   Puerto = "COM1"
end if
Rs.Close
Rs = nothing
Permiso_punto_de_venta_oficina = 0
cSql = "Exec ECO_Permiso_punto_de_venta_oficina '"&Session("Login")&"'"
Set Rs = Conn.Execute ( cSql )
If Not Rs.Eof then
   if  RS("Permiso_punto_de_venta_oficina") = 1 then
      Permiso_punto_de_venta_oficina = 1
    end if
end if
Rs.Close
Rs = nothing

Puerto = trim( replace( ucase( Puerto ) , "COM" , "" ) ) 
conn.close
set conn = nothing
if  session("IP") = "192.168.9.65" or session("IP") = "192.168.9.55" or session("IP") = "192.168.9.56" or session("IP") = "192.168.9.34" or Permiso_punto_de_venta_oficina = 1   then
  '*************************************************************************
  'Comentar esta l�nea para que funciones la validaci�n de la impresora
  Response.Redirect "Mant_PuntoVentaZF.asp?Boleta_actual=0&Fiscal_actual=0"
  '************************************************************************
end if
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Chequea impresora fiscal</title>
  <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
</head>
<body leftmargin=0 topmargin=0 text="#000000">

<script language="VbScript">
 On Error resume next

 Dim xError
 Dim TextoError
 Dim MSComm1, Buffer
 Set MSComm1 = CreateObject("MSCOMMLib.MSComm")
 MSComm1.Settings = "19200,N,8,1"
 if len(Trim(Err.Description)) > 0 then
    xError = "060"
    TextoError = Err.Description
 end if
 if xError <> "060" then  
    MSComm1.CommPort = <%=Puerto%>
    if len(Trim(Err.Description)) > 0 then
       xError = "060"
       TextoError = Err.Description
    end if
 end if
 if xError <> "060" then  
    MSComm1.PortOpen = True          ' open port
    if len(Trim(Err.Description)) > 0 then
       xError = "060"
       TextoError = Err.Description
    end if
 end if
 if xError <> "060" then  
    MSComm1.InBufferCount = 0
    MSComm1.InputLen = 0              ' disable input
    MSComm1.InputMode = comInputModeText
    MSComm1.RTSEnable = True         ' Ensure high for power
 end if

 'msgbox "paso-1:" & xError
 if len(trim(TextoError)) > 0 then 
    Msgbox "Se produjo un error con la impresora: " & chr(13) & TextoError, vbOkOnly + 16, "Error"
 end if

	' Ojo!!! Esta linea se debe borrar, solamente se utiliza cuando no se tiene una impresora Fiscal.
	' xError = ""
	
 if xError <> "060" Then

        xError = ""
        MSComm1.Output = Chr(135) + "481" + Chr(136)
        xError = Lecturam(5)
        if len(Trim(Err.Description)) > 0 then
           TextoError = Err.Description
        end if
        MSComm1.PortOpen = False
        if xError = "060" or InStr(1, xError, "La impresora no responde") > 0 Then
           Msgbox "La impresora no est� conectada u otro problema la afecta, apague y encienda." & chr(13) & TextoError, vbOkOnly + 16, "Error"
           'location.href = "Boleta_PuntoVentaZF.asp"
    	   location.href = "Mant_PuntoVentaZF.asp?Boleta_actual=0&Fiscal_actual=0"
        else
           aRegistro = Split( xError , ":" )
           if aRegistro(48) = "2" then
              Msgbox "Advertencia : " & chr(13) & "No se ha sacado un informe Z en mas de 24 horas", vbOkOnly + 16, "Advertencia"
           end if
           if aRegistro(43) = "2" and aRegistro(48) = "3" then
              Msgbox "Error con la impresora fiscal ! " & chr(13) & "Debe emitir un informe Z y hacer Apertura del per�odo para iniciar las ventas", vbOkOnly + 16, "Error"
              location.href = "Boleta_PuntoVentaZF.asp"
           elseif aRegistro(48) = "3" then
              Msgbox "Error con la impresora fiscal ! " & chr(13) & chr(13) & "No se ha sacado un informe Z en mas de 26 horas", vbOkOnly + 16, "Error"
              location.href = "Boleta_PuntoVentaZF.asp"
           elseif aRegistro(43) = "2" then
              Msgbox "Error con la impresora fiscal ! " & chr(13) & chr(13) & "Debe hacer Apertura del per�odo para iniciar las ventas", vbOkOnly + 16, "Error"
              location.href = "Boleta_PuntoVentaZF.asp"
           else              
              location.href = "Mant_PuntoVentaZF.asp?Boleta_actual=" & ( clng( aRegistro(2) ) + 1 ) & "&Fiscal_actual=" & clng( aRegistro(30) ) & "&msg=" & xError
           end if
        end if

 else
    parent.top.frames(1).location.href = "Boleta_PuntoVentaZF.asp"
    parent.top.frames(2).location.href = "Botones_Boleta_PuntoVentaZF.asp"
 end if
</script>
</body>
</html>
