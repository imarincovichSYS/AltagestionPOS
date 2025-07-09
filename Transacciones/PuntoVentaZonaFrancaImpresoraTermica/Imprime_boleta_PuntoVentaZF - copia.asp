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

'on error resume next

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

   cSql = "Exec PAR_ListaParametros 'IMPBOLEVTA'"
   Set Rs = Conn.Execute ( cSql )
   If Not Rs.Eof then
      Puerto = Rs("Valor_Texto")
   else
      Puerto = "COM1"
   end if
   Rs.Close
   Puerto = trim( replace( ucase( Puerto ) , "COM" , "" ) )
   
   porcentajeILA_1 =  0
   porcentajeILA_2 =  0

   Total = 0
   Numero_despacho_de_venta = 0
   Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT_impresion_factura '" & trim(Session("Login")) & "'" )
   do while not rs.eof

'			Producto    = cStr(Left(Rs("Producto") & Space(13),13))
'			ProductoCat = cStr(Left(Rs("Producto_Catalago") & Space(13),13))
'			Descripcion = cStr(Left(Rs("Desc_producto"),90))
'			Cantidad    = cStr(Right("000000" & Int(cDbl(Rs("Cantidad_salida"))),6))
'			'Decimales	= cStr(cDbl(Rs("Cantidad_salida")) - Int(cDbl(Rs("Cantidad_salida"))))
'			Decimales	= Round(cStr(cDbl(Rs("Cantidad_salida")) - Int(cDbl(Rs("Cantidad_salida")))),4)
'			Decimales	= Left(Replace(Decimales,"0.","") & "000", 3)

'			PrecioNeto   = cDbl("0" & Rs("Neto")) 'cDbl("0" & Rs("Precio_de_lista_modificado"))
'			PrecioConIva = PrecioNeto  * ( 1 + ( cDbl("0" & Session("PCTGEIVA")) / 100 ) )

'			PrecioUnit   = cStr(Right("000000000" & Redondear(PrecioConIva+.1,0),9))  

'			SubTotalNeto = cDbl("0" & Redondear(PrecioConIva+.1,0)) * cDbl("0" & Rs("Cantidad_salida"))
'			TotalNeto    = cStr(Right("000000000" & Redondear(SubTotalNeto+.1,0),9))


      Numero_despacho_de_venta = rs("Numero_documento_no_valorizado")
      Producto = PadR(rs("Producto"),13)
      Descripcion = Left( rs("Nombre_para_boleta") , 90 )
      if len(trim(Descripcion)) = 0 then
         Descripcion = Left( rs("Nombre_producto") , 90 )
      end if
      Descripcion = replace( Descripcion , chr(34) , "" )
      Cantidad    = clng(rs("Cantidad_salida"))
      Decimales = "000"

      PrecioNeto = cdbl( rs("Precio_final_con_descuentos_impreso") )

			PrecioConIva = PrecioNeto
			PrecioUnit   = StrZero(PrecioNeto,9)

      SubTotalNeto = PrecioConIva * Cantidad
      TotalNeto    = StrZero(SubTotalNeto,9)
      Cantidad     = StrZero(Cantidad,6)
	  
	  Marca 		= Left((rs("Marca") & Space(12)),12)
	  If Ucase(Trim(Marca)) = "OCASIONAL" then
		Marca = Space(12)
	  End if
	  Superfamilia 	= Left((rs("Superfamilia") & space(2)),2)
	  Familia 		= Left((rs("Familia") & space(2)),2)
	  Subfamilia 	= Left((rs("Subfamilia") & space(3)),3)
	  Genero	 	= Left(rs("Genero"),1)

      Porcentaje_impuesto_1 = cdbl( rs("Porcentaje_impuesto_1") )
      if cDbl( Porcentaje_impuesto_1 ) >  0 then
			if cDbl( porcentajeILA_1 ) =  0 then
				porcentajeILA_1 = Porcentaje_impuesto_1
			end if
			if cDbl( porcentajeILA_2 ) =  0 then
				if cDbl( Porcentaje_impuesto_1 ) <> cDbl( porcentajeILA_1 ) then
					porcentajeILA_2 = Porcentaje_impuesto_1
				end if
			end if
      end if

      Total = Total + SubTotalNeto

      Marca = PadR(Marca,12)
      SuperFamilia = PadR(Superfamilia,2)
      Familia = PadR(Familia,2)
      Subfamilia = PadR(Subfamilia,3)
      Genero = PadR(Genero,1)

      if isNumeric( rs("Producto") ) then
          Producto_alfanumerico = PadR(rs("Producto_alternativo"),9)
          Producto_numerico = PadL(rs("Producto"),7)
      else
          Producto_alfanumerico = PadR(rs("Producto"),9)
          Producto_numerico = PadL(rs("Producto_numerico"),7)
      end if

      'Producto_alfanumerico = PadR(rs("Producto"),9)
      'Producto_numerico = PadL(rs("Producto_numerico"),7)

	  '        ....x....1....x....2....x....3....x....4....x....5....x....6....x....7....x....8....x....9
	  '        ....x....1.. R.F.S.. G ....x......x.... ....x....1....x....2....x....1....x....2....x....3
	  
			'Detalle	= Detalle & ( "13111" & Producto & Cantidad & Decimales & PrecioUnit & TotalNeto & left( Trim(Producto) & " -- " & Descripcion , 90 ) & "|¬|")
			''Detalle	= Detalle & ( "13111" & Producto & Cantidad & Decimales & PrecioUnit & TotalNeto & Marca & " " & SuperFamilia & Familia & Subfamilia & " " & Genero & left( Descripcion , 90 ) & "|¬|")
            if isNumeric( rs("Producto") ) then
                if cDbl( rs("Producto") ) >= 150000 then
			        Detalle	= Detalle & ( "13111" & Producto & Cantidad & Decimales & PrecioUnit & TotalNeto & Marca & " " & SuperFamilia & Familia & Subfamilia & " " & Genero & " " & Producto_numerico & "" & left( Descripcion, 50 ) & "|¬|")
                else
			        Detalle	= Detalle & ( "13111" & Producto & Cantidad & Decimales & PrecioUnit & TotalNeto & Marca & " " & SuperFamilia & Familia & Subfamilia & " " & Genero & " " & Producto_numerico & "" & Producto_alfanumerico & " " & left( Descripcion, 50 ) & "|¬|")
                end if
            else
    	        Detalle	= Detalle & ( "13111" & Producto & Cantidad & Decimales & PrecioUnit & TotalNeto & Marca & " " & SuperFamilia & Familia & Subfamilia & " " & Genero & " " & Producto_numerico & "" & Producto_alfanumerico & " " & left( Descripcion, 50 ) & "|¬|")
            end if
            if trim(mid(Producto,1,1))="K" then
                es_mueble = "S"
            end if
            if trim(mid(Producto,1,5))="KCTDB" then
                es_cabina = "S"
            end if        
      rs.movenext
   loop
   rs.close
   set rs = nothing

Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT_impresion_factura_ILA '" & trim(Session("Login")) & "'" )

  ' Linea del ILA
  LineaImpuestoILA = ""
  'if cDbl( porcentajeILA_1 ) >  0 or cDbl( porcentajeILA_2 ) >  0 then
  if rs("Monto_ILA_10") > 0 or Rs("Monto_ILA_18") > 0 or Rs("Monto_ILA_20_5") > 0 or Rs("Monto_ILA_31_5") > 0 then
      'LineaImpuestoILA = "Impto I.L.A.: "
  	  'if cDbl( porcentajeILA_1 ) >  0 then
  	  if rs("Monto_ILA_10") > 0 then
      		'LineaImpuestoILA = LineaImpuestoILA & "(" & ltrim( PadL( FormatNumber( porcentajeILA_1, 2 ), 5 ) ) & ") " 
      		LineaImpuestoILA = LineaImpuestoILA & ltrim( PadL( "10", 5 ) ) & "% " & formatNumber(rs("Monto_ILA_10"),0) & " "
  	  end if
  	  if rs("Monto_ILA_18") > 0 then
      		'LineaImpuestoILA = LineaImpuestoILA & "(" & ltrim( PadL( FormatNumber( porcentajeILA_1, 2 ), 5 ) ) & ") " 
      		LineaImpuestoILA = LineaImpuestoILA & ltrim( PadL( "18", 5 ) ) & "% " & formatNumber(rs("Monto_ILA_18"),0) & " "
  	  end if
  	  'if cDbl( porcentajeILA_2 ) >  0 then
  	  if rs("Monto_ILA_20_5") > 0 then
      		'LineaImpuestoILA = LineaImpuestoILA & "(" & ltrim( PadL( FormatNumber( porcentajeILA_2, 2 ), 5 ) ) & ") "
      		LineaImpuestoILA = LineaImpuestoILA & ltrim( PadL( "20.5", 5 ) ) & "% " & formatNumber(rs("Monto_ILA_20_5"),0)
  	  end if
  	  if rs("Monto_ILA_31_5") > 0 then
      		'LineaImpuestoILA = LineaImpuestoILA & "(" & ltrim( PadL( FormatNumber( porcentajeILA_2, 2 ), 5 ) ) & ") "
      		LineaImpuestoILA = LineaImpuestoILA & ltrim( PadL( "31.5", 5 ) ) & "% " & formatNumber(rs("Monto_ILA_31_5"),0)
  	  end if
  end if

   'Chequea si ya está impresa la boleta
	 Set rs = Conn.execute("Exec DOV_consulta_numero_impresora_fiscal 0" & Numero_despacho_de_venta )
   if not rs.eof then
	    if clng("0" & rs("Numero_impresora_fiscal")) > 0 then
			   Liberar = true
			end if
	 end if
   rs.close
   set rs = nothing	 

   Cobros = ""
   Set rs = Conn.execute("Exec PUN_consulta_documento_cobros_venta 0" & Numero_despacho_de_venta )
   'response.write "Exec PUN_consulta_documento_cobros_venta 0" & Numero_despacho_de_venta
   if rs.eof then
      Cobros = "261101" & strzero(Total,10) & "|"
   else
   do while not rs.eof
    				'2611 + 01 = Efectivo
    				'2611 + 02 = Cheque
    				'2611 + 03 = Tarjeta de credito
    				'2611 + 04 = Tarjeta de debito
    				'2611 + 05 = Tarjeta Propia
    				'2611 + 06 = Cupon
    				'2611 + 07 = Otros 1
    				'2611 + 08 = Otros 2
    				'2611 + 09 = Otros 3
    				'2611 + 10 = Otros 4
      if rs("Documento_valorizado") = "EFI" then
         Cobros = Cobros & "261101" & strzero(clng(rs("Monto_total_moneda_oficial")),10) & "|"
      elseif rs("Documento_valorizado") = "CHI" then
         Cobros = Cobros & "261102" & strzero(clng(rs("Monto_total_moneda_oficial")),10) & "|"
      elseif rs("Documento_valorizado") = "TAC" then
         Cobros = Cobros & "261103" & strzero(clng(rs("Monto_total_moneda_oficial")),10) & "|"
      elseif rs("Documento_valorizado") = "TAR" then
         Cobros = Cobros & "261104" & strzero(clng(rs("Monto_total_moneda_oficial")),10) & "|"
      elseif rs("Documento_valorizado") = "VPR" then
         Cobros = Cobros & "261106" & strzero(clng(rs("Monto_total_moneda_oficial")),10) & "|"
      elseif rs("Documento_valorizado") = "TJO" or rs("Documento_valorizado") = "TAE" or rs("Documento_valorizado") = "TPR" then
         Cobros = Cobros & "261107" & strzero(clng(rs("Monto_total_moneda_oficial")),10) & "|"
      elseif rs("Documento_valorizado") = "LTR" or rs("Documento_valorizado") = "ECO" or rs("Documento_valorizado") = "ORC" then
         Cobros = Cobros & "261108" & strzero(clng(rs("Monto_total_moneda_oficial")),10) & "|"
      elseif rs("Documento_valorizado") = "TMU" then
         Cobros = Cobros & "261109" & strzero(clng(rs("Monto_total_moneda_oficial")),10) & "|"
      else
         Cobros = Cobros & "261110" & strzero(clng(rs("Monto_total_moneda_oficial")),10) & "|"
      end if
      rs.movenext
   loop
   end if
   rs.close
   set rs = nothing
   'response.write Cobros

end if

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

Conn.Close

'Response.Write REPLACE( Detalle, "|¬|", CHR(13) ) & chr(13)
'Response.Write Total & " --- " & nPrecioCero
'Response.End


Function PadR(Texto,Posiciones)
   PadR = Left( Texto & Space(500) , Posiciones)
End Function
  
Function PadL(Texto,Posiciones)
   PadL = Right( Space(500) & Texto , Posiciones)
End Function

Function StrZero(Numero,Posiciones)
   StrZero = Right( "0000000000000000000000000000" & Numero , Posiciones)
End Function

'response.write "Accion:" & Request("Accion") & "<br>"
'response.write "Total:" & Total & "<br>"
'response.write "Liberar:" & Liberar & "<br>"
'response.write "Impresa:" & Impresa & "<br>"
'response.write "Boleta_actual:" & Boleta_actual & "<br>"
'response.write "Boleta_actual Request:" & request("Boleta_actual") & "<br>"

'response.end

es_sorteo         = "N"
tope_cupon        = 5000
Cantidad_cupones  = int(Total/ tope_cupon)  

'IP_Caja   = "192.168.3.80" 'Caja 10
'IP_Caja   = "192.168.0.45" 'PC Pancho

'if Session("Cliente_boleta") = "13512435" and Request.ServerVariables("REMOTE_HOST") = IP_Caja then 'IF PRUEBA
if Session("Tipo_documento_venta") = "BOV" and Session("tipo_entidad_comercial") <> "E" and Cantidad_cupones > 0 then 'IF OFICIAL
  es_sorteo   = "S"
  strCupones = " CUPON"
  if Cantidad_cupones > 1 then strCupones = " CUPONES"
end if 
es_sorteo   = "N"
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Imprimir boleta</title>
  <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
</head>
<body leftmargin=0 topmargin=0 text="#000000" OnLoad="document.Formulario.Numero_boleta.focus()">
<%if ( Request("Accion") = "Reintentar" or Request("Accion") = "Imprimir" ) and Total > 0 and not Liberar and not Impresa and Boleta_actual > 0 then%>
	<script language="VbScript">
           /*mtxDetalle(a+n+4) = "111Cajera:<%=left(session("Nombre_usuario"),20)%> 
          mtxDetalle(a+n+5) = "116Tienda:<%=left(session("xNombre_centro_de_venta"),20)%> 
         mtxDetalle(a+n+6) = "111<%=left(trim(Session("Mensaje_del_dia")),50)%> 
         */
            


<%
sql = "exec CAJ_Obtener_por_direccion_IP '"&session("IP")&"'"

Set Rs = Conn.Execute ( sql )
If Not Rs.Eof then
   bodega = Rs("bodega")
   caja_numero = Rs("caja_numero")
end if
Rs.Close
Rs = nothing


conn.close
set conn = nothing
%>

          
				location.href = "Botones_Boleta_PuntoVentaZF.asp?Accion=Terminado&Numero_boleta=" & NumeroBoleta & "&Numero_caja=" & NumeroCaja

            location.href = "Mant_PuntoVentaZF.asp?Boleta_actual=" & <%=FolioBoleta%> & "&Fiscal_actual=" & <%=caja_numero%> & "&msg="
        
			
	</script>
<%else%>
<form name="Formulario" method="post" action="Imprime_boleta_PuntoVentaZF.asp">
<table height="100%" valign="bottom">
<tr>
   <td>Error al imprimir  <%=MsgError%></td>
   <td><input type="button" value="Reintentar" name="BotonReintentar" onclick="reintentar()"></td>
   <td>Si el error persiste debe hacer boleta manual e indicar el número</td>
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
<%if Terminado then%>
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
<%end if%>
</script>
