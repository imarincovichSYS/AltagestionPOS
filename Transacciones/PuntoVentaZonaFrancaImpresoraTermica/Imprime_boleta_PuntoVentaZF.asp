<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
Cache
set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 3600
'Conn.BeginTrans

MensajeError = ""

es_mueble = "N"
es_cabina = "N"


Dim objXMLHTTP
Dim url
Dim respuesta

url = "http://"&session("IP")&":8080/phpcaja/docs/respaldo.php?entidad='"&Session("Login")&"'"

Set objXMLHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")

objXMLHTTP.Open "GET", url, False

objXMLHTTP.Send

Set objXMLHTTP = Nothing

' ---------------------------------------- Terminar Boleta -------------------------------------------

Impresa = false
Liberar = false

Boleta_actual = clng( "0" & request("Boleta_actual") )

'response.write Boleta_actual
'response.end
	 
if Request("Accion") = "Reintentar"  or Request("Accion") = "Imprimir" then

	 'Chequea si el número a imprimir ya se intento utilizarlo
	 Set rs = Conn.execute("Exec PUN_consulta_ultima_boleta_fiscal '" & trim(Session("Login")) & "'" )
	 Boleta_a_imprimir = clng( "0" & rs("Numero_boleta_fiscal_a_imprimir") )
   if Boleta_a_imprimir > 0 and Boleta_a_imprimir < Boleta_actual then
	 		'Significa que la boleta ya se imprimió
	    Impresa = true
	 end if
   rs.close
   set rs = nothing
	 if not Impresa then
	 		'Se guarda el número de la boleta que se va a imprimir
	 		Conn.execute("Exec PUN_graba_ultima_boleta_fiscal '" & trim(Session("Login")) & "',0" & Boleta_actual )
	 end if
	 
   ' ------------------- Genera String para enviar a Impresora -----------------------
   Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT_impresion_factura '" & trim(Session("Login")) & "'" )
   do while not rs.eof

      Numero_despacho_de_venta = rs("Numero_documento_no_valorizado")
      rs.movenext
   loop
   rs.close
   set rs = nothing

   

   'Chequea si ya está impresa la boleta
	 'Set rs = Conn.execute("Exec DOV_consulta_numero_impresora_fiscal 0" & Numero_despacho_de_venta )
   'if not rs.eof then
	 ''   if clng("0" & rs("Numero_impresora_fiscal")) > 0 then
	''		   Liberar = true
	''		end if
	 'end if
   'rs.close
   'set rs = nothing	 


end if

sql = "exec CAJ_Obtener_por_direccion_IP '"&session("IP")&"'"
Set Rs = Conn.Execute ( sql )

If Not Rs.Eof then
   bodega = Rs("bodega")
   caja_numero = Rs("caja_numero")
   FolioBoleta = Rs("numero_documento_valorizado")   
end if

Rs.close
set Rs = nothing




if Request("Accion") = "Manual" or Request("Accion") = "Terminado" or Impresa then

'response.write "if Request(!Accion!) = !Manual! or Request(!Accion!) = !Terminado! or Impresa then"
'response.end

   if clng( "0" & trim(Request("Numero_boleta")) ) > 0 then
   'if Cdbl(0" & trim(Request("Numero_boleta")) ) > 0 then
      if Request("Accion") = "Manual" then
         Tipo_boleta = "M"
      else
         Tipo_boleta = "F"
      end if
			if Impresa then
				 Numero_boleta = Boleta_a_imprimir
			else
			 	 Numero_boleta = Request("Numero_boleta")
			end if
      Conn.BeginTrans
      Conn.execute("Exec DOV_Actualiza_folio_boleta '" & trim(Session("Login")) & "',0" & Numero_boleta & ",'" & Tipo_boleta & "',0" & Request("Numero_caja") )
			if session("Login_punto_venta") <> "" and session("Login_punto_venta") <> session("Login") then
				 Conn.execute("EXEC PUN_Cambia_responsable '" & trim(Session("Login")) & "','" & trim(Session("Login_punto_venta")) & "'")
			end if
      Conn.execute("EXEC PUN_Libera_cajera '" & trim(Session("Login")) & "'")
      if len(trim(Err.Description)) > 0 then
         Terminado = false
         Conn.RollbackTrans
			   MsgError = LimpiaError(Err.Description)
      else
         Terminado = true
         Conn.CommitTrans
         Session("Cliente_boleta") = ""
         Session("Forma_pago") = ""
				 Session("Login_punto_venta") = ""
				 response.redirect "Boleta_PuntoVentaZF.asp?Imprimiendo=Si"
	    end if

   end if

elseif Liberar or Request("Accion") = "Liberar" then

'response.write "elseif Liberar or Request(!Accion!) = !Liberar! then"
'response.end

   Conn.BeginTrans
   Conn.execute("EXEC PUN_Libera_cajera '" & trim(Session("Login")) & "'")
   if len(trim(Err.Description)) > 0 then
      Conn.RollbackTrans
      MsgError = LimpiaError(Err.Description)
   else
      Conn.CommitTrans
      Session("Cliente_boleta") = ""
      Session("Forma_pago") = ""
      Session("Login_punto_venta") = ""
			response.redirect "Boleta_PuntoVentaZF.asp?Imprimiendo=Si"
   end if

end if


%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Imprimir boleta</title>
  <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
</head>
<body leftmargin=0 topmargin=0 text="#000000" >
<%

   response.write Request("Accion") & " - " & Liberar & " - " & Impresa & " - " & Boleta_actual & " - " & true

   response.write " Terminado ->  " & Terminado  
   if ( Request("Accion") = "Reintentar" or Request("Accion") = "Imprimir" )  and not Liberar and not Impresa and Boleta_actual > 0 then %>	           
<%


conn.close
set conn = nothing


' Define la URL que necesitas llamar
url = "http://"&session("IP")&":8080/phpcaja/docs/boleta.php?entidad='"&Session("Login")&"'"
'&numeroBoleta="&FolioBoleta

' Crea el objeto para realizar la solicitud HTTP
Set objXMLHTTP = Server.CreateObject("MSXML2.ServerXMLHTTP.6.0")


' Configura la solicitud HTTP
objXMLHTTP.Open "GET", url, False

' Envía la solicitud al servidor
objXMLHTTP.Send

' Captura y muestra la respuesta
If objXMLHTTP.Status = 200 Then
    ' Solicitud exitosa, manejar la respuesta si es necesario
    respuesta = objXMLHTTP.ResponseText

    
    'Response.Write "Respuesta del servidor: " & respuesta
      Terminado = true
    'response.redirect = "Boleta_PuntoVentaZF.asp"
    'location.href = "Botones_Boleta_PuntoVentaZF.asp?Accion=Terminado&Numero_boleta="&FolioBoleta&"&Numero_caja="&caja_numero
Else
   
    ' Error al llamar la URL
    'Response.Write "Error al llamar la URL. Código de estado: " & objXMLHTTP.Status
    response.redirect = "Imprime_boleta_PuntoVentaZF.asp?Accion=Error"
    'location.href = "Imprime_boleta_PuntoVentaZF.asp?Accion=Error"
End If

' Libera el objeto



%>

          
				
        
			
	
<%else%>

<form name="Formulario" method="post" action="Imprime_boleta_PuntoVentaZF.asp">
<table height="100%" valign="bottom">
<tr>
   <td>Error al imprimir  <%=MsgError%></td>
   <td><input type="button" value="Reintentar" name="BotonReintentar" onclick="reintentar()"></td>
   <td>Si el error persiste debe hacer boleta manual e indicar el número</td><%=Request("Accion")%>
   1 <%=Liberar%>
   2 <%=Impresa%>

   3  <%=Boleta_actual%>
   <td>Folio boleta manual <input type="text" value="" name="Numero_boleta" onkeydown="if ( event.keyCode == 13 ) { enviar(); }"></td>
   <td><input type="button" value="Manual" name="BotonManual" onclick="enviar()">
   <input type="hidden" name="Accion">
   </td>

</tr>
</table>
</form>
<%end if%>
</body>
</html>
<script language="JavaScript">
<%
   'response.write "iF tERMINADO"

   if objXMLHTTP.Status = 200 then
      Session("Cliente_boleta") = ""
      Session("Forma_pago") = ""
      Session("Login_punto_venta") = ""
   
%>
  parent.Trabajo.location.href = "Boleta_PuntoVentaZF.asp?Imprimiendo=Si";
<%else%>
  parent.Botones.location.href = "../../empty.asp"
  document.Formulario.Numero_boleta.focus();
  function enviar(){
  document.Formulario.Accion.value = 'Manual';
  document.Formulario.submit();
  }
  function reintentar(){
  document.Formulario.Accion.value = 'Reintentar';
  document.Formulario.submit();
  }
<%end if

Set objXMLHTTP = Nothing
%>
</script>
