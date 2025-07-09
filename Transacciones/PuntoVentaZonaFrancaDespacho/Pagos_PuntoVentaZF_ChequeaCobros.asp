<%
dim Tipo_documento_cobro(100)
dim Numero_documento_cobro(100)
dim Fecha_documento_cobro(100)
dim Monto_documento_cobro(100)
dim Banco_documento_cobro(100)
dim Fecha_vencimiento_tmu(100)
Dim NroDeLaCuota(100)
dim Seleccionado_Tipo_documento_cobro(100)
'dim Seleccionado_Tipo_documento_cobro(100,100)

dim Numero_interno_documento_cobro(100)

Ultimo_tipo_documento_cobro = ""
Ultimo_numero_documento_cobro = ""
Ultima_fecha_documento_cobro = ""
Ultimo_monto_documento_cobro = 0
Ultimo_banco_documento_cobro = ""

Total_pesos_por_cobrar = Total_pesos
Total_pesos_cobrados = Total_pesos
if v_existe_prod_mayorista then
  if cdbl(Session("BASETOTMAY")) > cdbl(Total_Precio_Mayoristas) then 
    Total_pesos_cobrados = cdbl(Total_Precio_Normal)
    Total_pesos_por_cobrar = cdbl(Total_Precio_Normal)
  end if
end if

Numero_Numero_documentos_cobro = 0
Vuelto = 0
Documento_para_vuelto = ""
Billete = ""

if Numero_documentos_cobro = 0 then
   Numero_documentos_cobro = 1
end if

h = 0 
PrimerTMU = false 
PrimerECO = false
for n = 1 to Numero_documentos_cobro

    aDocumento = split( request("Tipo_documento_cobro_" & n ) & ";0;0" ,";" )

    Monto_cobro = clng( "0" & replace( request("Monto_documento_cobro_" & n ) , "-","" ) )
    if aDocumento(0) = "UEI" then
       Monto_cobro = ( Monto_cobro * DolarCambioSupervisoraCajas ) \ 1
       if Documento_para_vuelto = "" then Documento_para_vuelto = "UEI"
    end if
    if aDocumento(0) = "EFI" then
       Documento_para_vuelto = "EFI"
    end if

    Saldo_a_favor = clng( "0" & aDocumento(1) )
    
    if ( Saldo_a_favor > 0 and Saldo_a_favor < Monto_cobro ) or ( Saldo_a_favor > 0 and Numero_documentos_cobro = 1 and Monto_cobro < Total_pesos_cobrados ) then
       Numero_documentos_cobro = Numero_documentos_cobro + 1
       Monto_cobro = Saldo_a_favor
    end if

    Total_pesos_cobrados = Total_pesos_cobrados - Monto_cobro
    
    Tipo_documento_cobro(n) = aDocumento(0) 'request("Tipo_documento_cobro_" & n )
    if Tipo_documento_cobro(n) = "" then
       if Numero_documentos_cobro = 1 then
          Tipo_documento_cobro(n) = "EFI"
       else
          Tipo_documento_cobro(n) = "CHI"
       end if
    end if
    Numero_documento_cobro(n) = clng( "0" & request("Numero_documento_cobro_" & n ) )
    Fecha_documento_cobro(n) = request("Fecha_documento_cobro_" & n )
    
    if Fecha_documento_cobro(n) = "" then
       Fecha_documento_cobro(n) = Right("00" & day( now() ),2) & "/" & Right("00" & month( now() ),2) & "/" & year( now() )
    end if

    'joms 27/11/2007 - Nuevo para TMU
    '---------------------------------------------------------------------------
    if Tipo_documento_cobro(n) = "TMU" and PrimerTMU then 
       Fecha_documento_cobro(n) = DateAdd("m", 1, Ultima_fecha_TMU)
    end if
    if Tipo_documento_cobro(n) = "TMU" then
       PrimerTMU = true
       Ultima_fecha_TMU = Fecha_documento_cobro(n)
    end if 
    'Si se reemplazó un primer registro TMU entonces se recalcula la primera fecha
    if request("Tipo_documento_TMU_anterior_" & n ) = "TMU" and Tipo_documento_cobro(n) <> "TMU" then
       PrimerTMU = true
       Ultima_fecha_TMU = DateAdd("m", -1, Right("00" & day( now() ),2) & "/" & Right("00" & month( now() ),2) & "/" & year( now() ))
    end if

    Fecha_vencimiento_tmu(n) = request("Fecha_vencimiento_tmu_" & n )
    Banco_documento_cobro(n) = request("Banco_documento_cobro_" & n )
		Ultimo_banco_documento_cobro = Banco_documento_cobro(n)
    if trim( Banco_documento_cobro(n) ) <> "" and Numero_documento_cobro(n) = 0 then
       Numero_documento_cobro(n) = 1
    end if


   'Verificar si el documento es economato y contiene fecha de cierre y de cobro para establecer la fecha
   'Se hace una sola vez
   'JOMS 27-11-2007 Nuevo para ECO
    if not PrimerECO and Tipo_documento_cobro(n) = "ECO" then
      if Session("xEconomato_fecha_cobro") <> "" then
        Fecha_documento_cobro(n) = Session("xEconomato_fecha_cobro")
      else
        cSql = "Exec ECO_Lista_Economatos '" & Session("Empresa_usuario") & "','" & Session("xEconomato") & "', Null, Null, Null"
        Set Rs = Conn.Execute ( cSql )
        If Not Rs.Eof then
           Fecha_documento_cobro(n) = Rs("Fecha_cobro")
        end if
        Rs.Close
        Set Rs = Nothing
      end if
    end if
    'Response.Write Ultima_fecha_ECO
    'Response.End
    if Tipo_documento_cobro(n) = "ECO" and PrimerECO then 
      if Session("xEconomato_fecha_cobro") <> "" then
        Fecha_documento_cobro(n) = Session("xEconomato_fecha_cobro")
      else
        Fecha_documento_cobro(n) = DateAdd("m", 1, Ultima_fecha_ECO)
      end if
    end if

    if Tipo_documento_cobro(n) = "EXP" then 
      cSql = "Exec ECO_Lista_Economatos '" & Session("Empresa_usuario") & "','" & Session("xEconomato") & "', Null, Null, Null"
      Set Rs = Conn.Execute ( cSql )
      If Not Rs.Eof then
         Fecha_documento_cobro(n) = Rs("Fecha_cobro")
      end if
      Rs.Close
      Set Rs = Nothing
    end if
    
    if Tipo_documento_cobro(n) = "ECO" then
       PrimerECO = true
       if Session("xEconomato_fecha_cobro") <> "" then
          Ultima_fecha_ECO = Session("xEconomato_fecha_cobro")
       else
          Ultima_fecha_ECO = Fecha_documento_cobro(n)
       end if
    end if 

    NroDeLaCuota(n) = 1
    if Request("DocumentoSeleccionado_" & n) = Tipo_documento_cobro(n) then
        NroDeLaCuota(n) = Request("NroDeLaCuota_" & n )
    end if
    
    if Accion_a_ejecutar = "Modificar" or Accion_a_ejecutar = "ModificarPrecio" then
       Numero_documentos_cobro = 1
       Monto_documento_cobro(n) = Total_pesos_por_cobrar
       Ultimo_monto_documento_cobro = Total_pesos_por_cobrar
    elseif Accion_a_ejecutar = "AgregaCheques" and n = Numero_documentos_cobro and cint( request("Numero_documentos_adicionales") ) > 0 then
       Ultimo_monto_documento_cobro = Total_pesos_por_cobrar \ cint( request("Numero_documentos_adicionales") )
       Ultimo_monto_documento_cobro = ( Ultimo_monto_documento_cobro \ 100 ) * 100
       Monto_documento_cobro(n) = Total_pesos_por_cobrar - ( Ultimo_monto_documento_cobro * ( cint( request("Numero_documentos_adicionales") ) - 1 ) )
    else
       Ultimo_monto_documento_cobro = Monto_cobro
       ' Aquí se pone el valor en el arreglo
       Monto_documento_cobro(n) = Ultimo_monto_documento_cobro
    end if
    Ultimo_tipo_documento_cobro = Tipo_documento_cobro(n)
    Ultimo_numero_documento_cobro = Numero_documento_cobro(n)

    'JOMS Sep-2007
    if not vacio(Ultima_fecha_documento_cobro) then
      if Tipo_documento_cobro(n) <> "EFI" then
        if cdate(Ultima_fecha_documento_cobro) > cdate(Fecha_documento_cobro(n)) then
           MensajeError = "Error en fechas de pago"
        end if
      end if
    end if
    if cdate(Fecha_documento_cobro(n)) < cdate(FechaActual) then
       MensajeError = "Fecha pago anterior a hoy"
    end if

    Ultima_fecha_documento_cobro = Fecha_documento_cobro(n)

    if Total_pesos_por_cobrar <> 0 and Accion_a_ejecutar <> "AgregaCheques" and Accion_a_ejecutar <> "Modificar" and Accion_a_ejecutar <> "ModificarPrecio" then
       if Tipo_documento_cobro(n) = "EFI" and Total_pesos_por_cobrar < Monto_documento_cobro(n) then
          Billete = Monto_documento_cobro(n)
          Vuelto = Monto_documento_cobro(n) - Total_pesos_por_cobrar
          Monto_documento_cobro(n) = Total_pesos_por_cobrar
          Total_pesos_por_cobrar = 0
          Numero_Numero_documentos_cobro = Numero_Numero_documentos_cobro + 1
          Exit For
       elseif n = Numero_documentos_cobro and Total_pesos_por_cobrar <> 0 and Tipo_documento_cobro(n) <> "DEP" and Tipo_documento_cobro(n) <> "NCV" and Tipo_documento_cobro(n) <> "UEI" then
          'response.write "Paso por aquí cuando el valor es mayor que el monto de la boleta"
          Monto_documento_cobro(n) = Total_pesos_por_cobrar
       end if
    end if
    Total_pesos_por_cobrar = Total_pesos_por_cobrar - Monto_documento_cobro(n)

    'if Numero_Numero_documentos_cobro = 0 and ( Total_pesos_por_cobrar = 0 or n = Numero_documentos_cobro ) then
    
    if Monto_documento_cobro(n) > 0 then
       Numero_Numero_documentos_cobro = Numero_Numero_documentos_cobro + 1
    end if

   if Tipo_documento_cobro(n) = "UEI" then
      Monto_documento_cobro(n) = clng( "0" & replace( request("Monto_documento_cobro_" & n ) , "-","" ) )
   end if

   if Total_pesos_por_cobrar <= 0 then
      Exit For
   end if

next
Numero_documentos_cobro = Numero_Numero_documentos_cobro

if Total_pesos_cobrados > 0 then
   Accion_a_ejecutar = "Continuar"
end if

'response.write Total_pesos_por_cobrar

'   response.write n & "-" & Total_pesos_cobrados & " - " & Accion_a_ejecutar & "<br>"
if Total_pesos_por_cobrar < 0 and Numero_documentos_cobro > 0 then
   if Monto_documento_cobro(Numero_documentos_cobro) + Total_pesos_por_cobrar > 0 then
      Monto_documento_cobro(Numero_documentos_cobro) = Monto_documento_cobro(Numero_documentos_cobro) + Total_pesos_por_cobrar
   else
      Vuelto = -Total_pesos_por_cobrar
   end if
end if
'response.write Total_pesos_por_cobrar
if Total_pesos_por_cobrar > 0 and Accion_a_ejecutar <> "AgregaCheques" then
   if Numero_documentos_cobro = 1 then
      Tipo_documento_cobro(n) = "EFI"
   else
      Tipo_documento_cobro(n) = "CHI"
   end if
   Monto_documento_cobro(n) = Total_pesos_por_cobrar
   Numero_documentos_cobro = Numero_documentos_cobro + 1
end if

if Accion_a_ejecutar = "AgregaDocumentoCobro" then
   Numero_documentos_cobro = Numero_documentos_cobro + 1
   if Numero_documentos_cobro = 1 then
      Tipo_documento_cobro(n) = "EFI"
   else
      Tipo_documento_cobro(n) = "CHI"
   end if
end if

if Accion_a_ejecutar = "AgregaCheques" and Ultima_fecha_documento_cobro <> "" then

'Response.Write Ultima_fecha_documento_cobro & " -- " & DateAdd("m", 1, Ultima_fecha_documento_cobro)
'Response.Write Ultimo_monto_documento_cobro
'Response.End

   Ultimo_numero_documento_cobro = Ultimo_numero_documento_cobro
   Ultima_fecha_documento_cobro = cdate( Ultima_fecha_documento_cobro )
   dia = day( Ultima_fecha_documento_cobro )
   for n = 1 to cint( request("Numero_documentos_adicionales") ) - 1
      if Ultimo_tipo_documento_cobro = "ECO" then
        if Session("xEconomato_fecha_cobro") <> "" then
          Nueva_fecha_documento_cobro = Session("xEconomato_fecha_cobro")
        else
          Nueva_fecha_documento_cobro = DateAdd("m", 1, Ultima_fecha_documento_cobro)
        end if
      else
        Nueva_fecha_documento_cobro = DateAdd("m", 1, Ultima_fecha_documento_cobro)
      end if
       
       Ultima_fecha_documento_cobro = Nueva_fecha_documento_cobro
       Numero_documentos_cobro = Numero_documentos_cobro + 1
       Ultimo_numero_documento_cobro = Ultimo_numero_documento_cobro + 1
            
       
       Tipo_documento_cobro(Numero_documentos_cobro) = Ultimo_tipo_documento_cobro       
       Numero_documento_cobro(Numero_documentos_cobro) = Ultimo_numero_documento_cobro
       
       Fecha_documento_cobro(Numero_documentos_cobro) = Ultima_fecha_documento_cobro
       
       Monto_documento_cobro(Numero_documentos_cobro) = Ultimo_monto_documento_cobro
       Banco_documento_cobro(Numero_documentos_cobro) = Ultimo_banco_documento_cobro
       NroDeLaCuota(Numero_documentos_cobro) = Numero_documentos_cobro
   next
end if
' Agregar una observación
' Default EFECTIVO
' Colocar cliente - para % descuento
' GRabar Impuesto aduanero - Tipo cambio o paridad

'Multicrédito TMU - JOMS 09-2007
TituloTMU = ""
for n = 1 to Numero_documentos_cobro
    if Tipo_documento_cobro(n) = "TMU" then
       Fecha_documento = cdate(Fecha_documento_cobro(n))
       cSql = "Exec TMU_Lista_Asociados '" & Session("Empresa_usuario") & "', '" & Session("Cliente_boleta") & "'"
       'cSql = cSql & "Null, Null, '" & year(Fecha_documento) & "/" & month(Fecha_documento)& "/" & day(Fecha_documento) & "'"
       'response.write csql
       Set Rs = Conn.Execute ( cSql )
       If Not Rs.Eof then
          if Fecha_documento = cdate(Fecha_actual) then
             if weekday( Fecha_documento, vbMonday ) = 5 then
                'Viernes para Lunes
                Fecha_documento = DateAdd( "d" , 1, Fecha_documento )
             elseif weekday( Fecha_documento, vbMonday ) = 6 then
                'Sabado para Lunes
                Fecha_documento = DateAdd( "d" , 1, Fecha_documento )
             end if
          end if
          Dia_cierre = rs("Dia_cierre")
          Ciclos = 1
          if Dia_cierre >= 1 and Dia_cierre <= 10 then
             Dia_pago = 30
             if day(Fecha_documento) > 10  or day(Fecha_documento) >= Dia_cierre then
                Ciclos = 2
             end if
          elseif Dia_cierre >= 11 and Dia_cierre <= 20 then
             Dia_pago = 10
             if day(Fecha_documento) < 11 or day(Fecha_documento) > 20  or day(Fecha_documento) >= Dia_cierre then
                Ciclos = 2
             end if
          elseif Dia_cierre >= 21 then
             Dia_pago = 20
             if day(Fecha_documento) < 21 or day(Fecha_documento) >= Dia_cierre then
                Ciclos = 2
             end if
          end if
          do while Ciclos > 0
             Fecha_documento = DateAdd( "d" , 1, Fecha_documento )
             do while day(Fecha_documento) <> Dia_pago
                Fecha_documento = DateAdd( "d" , 1, Fecha_documento )
             loop
             Ciclos = Ciclos - 1
          loop
          Fecha_vencimiento_tmu(n) = Fecha_documento
       else
          Fecha_vencimiento_tmu(n) = Fecha_documento_cobro(n)
       end if
       Rs.Close
       Set Rs = Nothing
       TituloTMU = "TMU"
    end if
next

tipo_cobro_ECO = false : Total_Monto_Cobros_Eco = 0 : Total_Cobro_Permitido_ECO = 0 : Cant_Documentos_Cobro_ECO = 0
if Session("xEconomato_tope") <> "" then
  for k = 1 to Numero_documentos_cobro
    v_tipo_documento_cobro  = Tipo_documento_cobro(k)
    v_monto_documento_cobro = Monto_documento_cobro(k)
    if v_tipo_documento_cobro = "ECO" then
      tipo_cobro_ECO = true
      Total_Monto_Cobros_Eco = cdbl(Total_Monto_Cobros_Eco) + cdbl(v_monto_documento_cobro)
      Cant_Documentos_Cobro_ECO = cdbl(Cant_Documentos_Cobro_ECO)  + 1
    end if
  next
end if

'Response.Write Session("xEconomato")
'Response.End

if tipo_cobro_ECO and Session("xEconomato_temporada") <> "" then
  Total_Cobro_Maximo_ECO = cdbl(Cant_Documentos_Cobro_ECO) * cdbl(Session("xEconomato_tope"))
  'Response.Write Total_Cobro_Maximo_ECO
  'Response.End
  if cdbl(Total_Monto_Cobros_Eco)  > cdbl(Cant_Documentos_Cobro_ECO) * cdbl(Session("xEconomato_tope")) then
    'MensajeError = "Cobro de economato menor al tope del convenio ("& Replace(FormatNumber(cdbl(Session("xEconomato_tope")) + cdbl(Session("xEconomato_supera_tope")),0),",",".") &")"
    MensajeError = "Cobro de economato mayor al tope del convenio. Tope máximo: "& Replace( FormatNumber(cdbl(Session("xEconomato_tope")),0),",",".")
  end if
end if
'Response.Write Session("saldo_empleado_ECO_EXP")
if tipo_cobro_ECO_EXP and Session("saldo_empleado_ECO_EXP") <> "" then
  if cdbl(Total_Monto_Cobros_Eco_Exp)  > cdbl(Session("saldo_empleado_ECO_EXP")) then
    MensajeError = "Tope Eco $"& Replace( FormatNumber(cdbl(Session("saldo_empleado_ECO_EXP")),0),",",".") & ", No se puede realizar la venta"
  end if
end if

%>