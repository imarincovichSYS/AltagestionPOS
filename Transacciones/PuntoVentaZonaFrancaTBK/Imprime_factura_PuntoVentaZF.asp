<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.inc" -->
<!-- #include file="../../Scripts/Inc/Montoescrito.Inc" -->
<%Cache

SET Conn = Server.CreateObject("ADODB.Connection")
   Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600

cSql = "Exec PAR_ListaParametros 'IMPFACTURAS'"
Set Rs = Conn.Execute ( cSql )
If Not Rs.Eof then
   Impresora = Rs("Valor_texto")
else
   Impresora = "LPT1"
end if
Rs.Close
Set Rs = Nothing

Function TxtPrint(Margen_izquierdo,valor)
   valor = cambia_chr(valor)
   if Instr(1,valor,chr(13)) > 0 then
      cTexto = ""
      caracter = "¬"
      valor = Replace(valor,chr(13),caracter)
      Do While Instr(1,valor,caracter) > 0 
         nPosIni = Instr(1,valor,caracter)
         cTexto = cTexto & "Locales.imprimir " & chr(34) & space(Margen_izquierdo) & Mid(valor,1,nPosIni-1) & chr(34) & chr(13)
         valor =  Mid(valor,nPosIni+1)
      Loop
      cTexto = cTexto & "Locales.imprimir " & chr(34) & space(Margen_izquierdo) & valor & chr(34) & chr(13)
      TxtPrint = cTexto
   else
      TxtPrint = "Locales.imprimir " & chr(34) & valor & chr(34)
   end if
End Function
  
Function PadR(Texto,Posiciones)
   PadR = Left( Texto & Space(500) , Posiciones)
End Function

Function PadL(Texto,Posiciones)
   PadL = Right( Space(500) & Texto , Posiciones)
End Function

Function StrZero(Numero,Posiciones)
   StrZero = Right( "0000000000000000000000000000" & Numero , Posiciones)
End Function

function saca(byref cData,cSeparador)
   if instr(cData,cSeparador) = 0 then cData = cData & cSeparador
   nAt = instr(cData,cSeparador)
   saca = mid(cData,1,nAt-1)
   cData = mid(cData,nAt+len(cSeparador))
end function

Function FechaLarga( valor )
   Dia = Day(Valor)
   Mes = Month(Valor)
   Ano = Year(Valor)
   FechaLarga = Right("00" & Dia,2) & "/" & Ucase(Left(NombreMes(Mes),3)) & "/" & Ano
End Function

Margen_izquierdo =  2 'Margen izquierdo ?
Crlf = chr(13)
Comprimida = chr(18) & chr(15)
Normal = chr(27) & chr(54) & chr(18) & chr(27) & chr(58) ' chr(27) & "M" <- EPSON ' chr(18) & chr(27) & chr(58) <- OKI '               'chr(28) 'chr(27) & chr(63) & chr(2)
SaltoPagina = chr(12)
Inicio_bold = chr(27) & chr(69)
Fin_bold = chr(27) & chr(70)
Inicio_doble = chr(27) & chr(87) & chr(49)
Fin_doble = chr(27) & chr(87) & chr(48)

Set rs = Conn.execute("EXEC PUN_Datos_cliente_para_factura '" & Session("Cliente_boleta") & "'" )
if not rs.eof then
   if rs("Nombres_persona") <> rs("Apellidos_persona_o_nombre_empresa") then
      Nombre_cliente = trim(rs("Nombres_persona")) & " " & rs("Apellidos_persona_o_nombre_empresa")
   else
      Nombre_cliente = rs("Apellidos_persona_o_nombre_empresa")
   end if
   Direccion_cliente = rs("Direccion")
   Rut_Cliente	= rs("Rut_entidad_comercial") & "-" & cStr( valida_rut(Right(cStr("00000000" & rs("Rut_entidad_comercial")),8)) )
   Ciudad_o_comuna = rs("Ciudad_o_comuna")
end if
rs.close
set rs = nothing
  
'Nombre de la comuna
Set rs = Conn.execute("EXEC PUN_Nombre_comuna '" & Ciudad_o_comuna & "'" )
if not rs.eof then
   Comuna = rs("Nombre")
end if
rs.close
set rs = nothing

Cabecera = Comprimida  & Crlf & _
         space(90) & FechaLarga(now()) & Crlf & Crlf & Crlf & _
         space(5) & PadR(Nombre_cliente,50) & PadR(Direccion_cliente & "," & Comuna,50) & space(15) & PadL(Rut_cliente,12) & Crlf & Crlf

Factura = Cabecera & Comprimida & Crlf & Crlf
Total_cif = 0
Total = 0
Impuesto = 0

Numero_despacho_de_venta = 0
   
Pagina = 1
n = 1
nl = 0
Lineas_detalle = 17

Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT_impresion_factura '" & trim(Session("Login")) & "'" )
n = 0

porcentajeILA_1 =  0
porcentajeILA_2 =  0
do while not rs.eof
   Numero_despacho_de_venta = rs("Numero_documento_no_valorizado")
   Cantidad = cint(rs("Cantidad_salida"))
   Precio = cdbl( rs("Precio_final_con_descuentos_impreso") )
   Cif = cdbl(rs("Costo_CIF_ORI_US$_total_2_decimales"))
   Total_cif = Total_cif + Cif
   Total = Total + Precio * Cantidad
   Impuesto = Impuesto + cdbl( rs("Monto_impuesto_aduanero_moneda_oficial") )

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

   Factura = Factura & PadL(Cantidad,7) & "     " & _
               PadL(rs("Unidad_de_medida_consumo"),9) & "  " & _
               PadR(rs("Producto"),10) & "  " & _
               PadR( replace( rs("Nombre_producto") , chr(34) ,"P" ) ,30) & "     " & _
               PadL( FormatNumber(Precio,0) , 12 ) & "   " & _
               PadR( left(rs("Tipo_documento_de_compra"),1) & "-" & strzero(rs("Numero_documento_de_compra"),6) & "-" & strzero(rs("Año_recepcion_compra"),4) & "-" & strzero(rs("Numero_de_linea_en_RCP_o_documento_de_compra"),3) ,20) & "  " & _
               PadL( FormatNumber(Cif,2) , 8 ) & "       " & _
               PadL( FormatNumber(Precio * Cantidad,0) , 10 ) & Crlf
   n = n + 1
   nl = nl + 1
   if nl > Lineas_detalle - 1 then
      Pagina = Pagina + 1
      Factura = Factura & _
                  space(80) & "continua en pagina " & Pagina
      For lineas = nl to Lineas_detalle
            Factura = Factura & Crlf
      Next
      'Avanza zona de descuentos
      Factura = Factura & Crlf & Crlf & Crlf & Crlf & Crlf & Crlf & Crlf & Crlf & Crlf
      'Avanza para llegar a la siguiente página
      Factura = Factura & Normal & Crlf & Crlf & Crlf & Crlf
      'Inicio de factura (Igual que al comerzar la primera vez
      Factura = Factura & Cabecera & Comprimida & Crlf & Crlf
      nl = 0
   end if
   rs.movenext
loop
rs.close
set rs = nothing
  
Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT_impresion_factura_ILA '" & trim(Session("Login")) & "'" )

' Linea del ILA
if rs("Monto_ILA_10") > 0 or Rs("Monto_ILA_18") > 0 or Rs("Monto_ILA_20_5") > 0 or Rs("Monto_ILA_31_5") > 0 then
   Factura = Factura & "      Impto I.L.A.: "
   if rs("Monto_ILA_10") > 0 then
         Factura = Factura & "(" & ltrim( PadL( "10", 5 ) ) & "%) " & formatNumber(rs("Monto_ILA_10"),0) & "   "
   end if
   if rs("Monto_ILA_18") > 0 then
         Factura = Factura & "(" & ltrim( PadL( "18", 5 ) ) & "%) " & formatNumber(rs("Monto_ILA_18"),0) & "   "
   end if
   if rs("Monto_ILA_20_5") > 0 then
         Factura = Factura & "(" & ltrim( PadL( "20.5", 5 ) ) & "%) " & formatNumber(rs("Monto_ILA_20_5"),0)
   end if
   if rs("Monto_ILA_31_5") > 0 then
         Factura = Factura & "(" & ltrim( PadL( "31.5", 5 ) ) & "%) " & formatNumber(rs("Monto_ILA_31_5"),0)
   end if
   Factura = Factura & Crlf
   nl = nl + 1
end if

'Se completa el largo de la página
For n = nl to Lineas_detalle
   Factura = Factura & Crlf
Next

Cobros = ""
Numero_cobros = 0
Set rs = Conn.execute("Exec PUN_consulta_documento_cobros_venta 0" & Numero_despacho_de_venta )
'response.write "Exec PUN_consulta_documento_cobros_venta 0" & Numero_despacho_de_venta
if rs.eof then
   Cobros = Cobros & "EFECTIVO           $ " & padl( formatnumber(Total,0) , 15 ) & "|"
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
      Numero_cobros = Numero_cobros + 1
      if rs("Documento_valorizado") = "EFI" then
         Cobros = Cobros & Space(20) & "EFECTIVO           $ " & padl( formatnumber(clng(rs("Monto_total_moneda_oficial")),0) , 15 ) & "|"
      elseif rs("Documento_valorizado") = "CHI" then
         Cobros = Cobros & Space(20) & "CHEQUE             $ " & padl( formatnumber(clng(rs("Monto_total_moneda_oficial")),0) , 15 ) & "|"
      elseif rs("Documento_valorizado") = "TAC" then
         Cobros = Cobros & Space(20) & "TARJETA DE CREDITO $ " & padl( formatnumber(clng(rs("Monto_total_moneda_oficial")),0) , 15 ) & "|"
      elseif rs("Documento_valorizado") = "TAR" then
         Cobros = Cobros & Space(20) & "TARJETA DE DEBITO  $ " & padl( formatnumber(clng(rs("Monto_total_moneda_oficial")),0) , 15 ) & "|"
      elseif rs("Documento_valorizado") = "VPR" then
         Cobros = Cobros & Space(20) & "CUPON              $ " & padl( formatnumber(clng(rs("Monto_total_moneda_oficial")),0) , 15 ) & "|"
      elseif rs("Documento_valorizado") = "ORC" then
         Cobros = Cobros & Space(20) & "ORC                $ " & padl( formatnumber(clng(rs("Monto_total_moneda_oficial")),0) , 15 ) & "|"
         Cobros = Cobros & Space(20) & " " & padl( rs("Observaciones") , 55 ) & "|"
      elseif rs("Documento_valorizado") = "TJO" or rs("Documento_valorizado") = "TAE" or rs("Documento_valorizado") = "TPR" then
         Cobros = Cobros & Space(20) & "OTROS 1            $ " & padl( formatnumber(clng(rs("Monto_total_moneda_oficial")),0) , 15 ) & "|"
      elseif rs("Documento_valorizado") = "LTR" or rs("Documento_valorizado") = "ECO" then
         Cobros = Cobros & Space(20) & "OTROS 2            $ " & padl( formatnumber(clng(rs("Monto_total_moneda_oficial")),0) , 15 ) & "|"
      elseif rs("Documento_valorizado") = "TMU" then
         Cobros = Cobros & Space(20) & "OTROS 3            $ " & padl( formatnumber(clng(rs("Monto_total_moneda_oficial")),0) , 15 ) & "|"
      else
         Cobros = Cobros & "OTROS 4            $ " & padl( formatnumber(clng(rs("Monto_total_moneda_oficial")),0) , 15 ) & "|"
      end if
      rs.movenext
   loop
end if
rs.close
set rs = nothing

if Numero_cobros > 4 then
   for u = 1 to 500
      Cobros = Replace( Cobros , "  ", " " )
   next
   Documentos_cobro = ""
   Cobros = Replace( Cobros , "EFECTIVO", "EFEC." )
   Cobros = Replace( Cobros , "CHEQUE", "CHEQ." )
   Cobros = Replace( Cobros , "TARJETA DE CREDITO", "T.CRED." )
   Cobros = Replace( Cobros , "TARJETA DE DEBITO", "T.CRED." )
   Documentos_cobro = Space(20) & Saca(Cobros,"|") & " /"
   Documentos_cobro = Documentos_cobro & Saca(Cobros,"|") & " /"
   Documentos_cobro = Documentos_cobro & Saca(Cobros,"|") & " /"
   Documentos_cobro = Documentos_cobro & Saca(Cobros,"|") & "|"
   do while len( trim( Cobros ) ) > 0
      Documentos_cobro = Documentos_cobro & Saca(Cobros,"|") & " / "
      Documentos_cobro = Documentos_cobro & Saca(Cobros,"|") & " / "
      Documentos_cobro = Documentos_cobro & Saca(Cobros,"|") & " / "
      Documentos_cobro = Documentos_cobro & Saca(Cobros,"|") & " / "
      Documentos_cobro = Documentos_cobro & Saca(Cobros,"|") & "|"
   loop
   for u = 1 to 100
      Cobros = Replace( Cobros , " /  / ", "" )
   next
else
   Documentos_cobro = Cobros
end if

Factura = Factura & Crlf
Factura = Factura & Space(22) & "SON: " & PadR( Escribir( Total ) & " PESOS" , 107 - 27 ) & PadL( FormatNumber( Total_cif ,2) , 8 ) & "     " & _
                                 PadL( FormatNumber( Total,0) , 12 ) & Crlf
Factura = Factura & padR( Space(5) & Saca(Documentos_cobro,"|"),120 ) & Crlf
Factura = Factura & padR( Space(5) & Saca(Documentos_cobro,"|"),120 ) & PadL( FormatNumber( Impuesto ,0) , 12 ) & Crlf
Factura = Factura & padR( Space(5) & Saca(Documentos_cobro,"|"),120 ) & Crlf
Factura = Factura & padR( Space(5) & Saca(Documentos_cobro,"|"),120 ) & PadL( FormatNumber( Total,0) , 12 ) & Crlf
Factura = Factura & padR( Space(5) & Saca(Documentos_cobro,"|"),120 ) & Crlf
Factura = Factura & padR( Space(5) & Saca(Documentos_cobro,"|"),120 ) & Crlf
Factura = Factura & padR( Space(5) & Saca(Documentos_cobro,"|"),120 ) & Crlf

Factura = Factura & Normal & Crlf & Crlf & Crlf & Crlf

Factura = TxtPrint(Margen_izquierdo,Factura)

Terminado = true
if session("Login_punto_venta") <> "" and session("Login_punto_venta") <> session("Login") then
   Conn.execute("EXEC PUN_Cambia_responsable '" & trim(Session("Login")) & "','" & trim(Session("Login_punto_venta")) & "'")
   
   'se Agrega modificacion para poder realizar eliminacion de factura 
   'en caso de que se vuelva a la seleccion de medios de pago
   Conn.Execute("update Documentos_valorizados set DOV_de_punto_de_venta_ya_impreso = 'SI' where Empresa = '" & Session("Empresa_usuario") & "'' and Documento_valorizado = 'FAV' and Numero_despacho_de_venta = " & Numero_despacho_de_venta)
end if

Conn.execute("EXEC PUN_Libera_cajera '" & trim(Session("Login")) & "'")  
Session("Cliente_boleta") = ""
Session("Forma_pago") = ""%>
<HTML>
   <h3>Imprimiendo factura ...</h3>
   <OBJECT classid="CLSID:B829BCD0-3892-11D3-A519-0000216ABE11" 
         codebase="../../Impresion/Impresora.CAB#version=2,0,0,1" 
      id=Locales style="LEFT: 0px; TOP: 0px">
      <PARAM NAME="_ExtentX" VALUE="503">
      <PARAM NAME="_ExtentY" VALUE="503">
   </OBJECT>

   <Script language="VBScript">
      Dim Puerto    
      If Locales.InicioImpresion("<%=Impresora%>") then
      <%	Response.Write Factura %>
         Locales.FinImpresion
      Else
         Msgbox "Verifique el estado de la impresora",16,"Error" 	
      End if
   </Script>
</HTML>

<%if Terminado then%>
   <script language="JavaScript">
      parent.Trabajo.location.href = "Main_PuntoVentaZF.asp"
   </script>
<%end if%>
