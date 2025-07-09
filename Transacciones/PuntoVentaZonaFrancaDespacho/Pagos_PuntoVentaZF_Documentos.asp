<%=CajaConBordes(120,28-delta,ancho_caja_bg_derecha,151)%>
<div style="position:absolute; top:123px; left:<%=60-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Documento</div>
<div style="position:absolute; top:123px; left:<%=215-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Valor&nbsp;$</div>
<div style="position:absolute; top:123px; left:<%=310-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Fecha</div>
<div style="position:absolute; top:123px; left:<%=405-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Banco</div>
<div style="position:absolute; top:123px; left:<%=705-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Num.Doc.</div>
<div style="position:absolute; top:123px; left:<%=795-delta%>px; z-index:1"  style="font-size: 14px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
#Cuotas &nbsp;&nbsp;<%=TituloTMU%></div>

<div style="position:absolute; overflow:auto; top:145px; left:<%=28-delta%>px;  z-index:2; width=<%=ancho_caja_bg_derecha%>px; height=126px; background-color: #999966;" >

<table border="0" cellspacing="1" cellpadding="0">
<%

'Bancos
Dim Banco(100)
Dim Nombre_banco(100)
Set Rs = Conn.Execute("Exec BAN_ListaBancos Null, Null, 2")
Bancos = 0
do While Not Rs.EOF
   Bancos = Bancos + 1
   Banco(Bancos) = rs("Banco")
   Nombre_banco(Bancos) = rs("Nombre")
   Rs.MoveNext
Loop
Rs.close
set Rs = nothing

'Documentos de cobranza
Dim Seleccionado_cobranza(100)
Dim Eliminado_cobranza(100)
Dim Documento_cobranza(100)
Dim Nombre_cobranza(100)
Dim Numero_documento_cobranza(100)
Dim Numero_interno_documento_cobranza(100)
Dim Saldo_a_favor_cobranza(100)
Dim Economato(100)

'Response.write( "objId: " & objId & " - " )
'Response.write( "objSel: " & objSel & " - " )
'Response.write( "objVal: " & objVal & " - " )
'Response.write( "objCad: " & objCad & " - " )
'Response.write( "objObj: " & objObj & "<br>" )

'El cliente ingresado esta bloqueado por morosidades solo se puede vender con pago en efectivo
if Session("xBloqueado") = "S" Then 
    cSql = "EXEC DOC_Lista_DocumentosCobro_x_CLiente '" & Session("Cliente_boleta") & "'"
else
    cSql = "EXEC PUN_Documentos_de_cobranza_ASHLEY '" & Session("empresa_usuario") & "','" & Session("Cliente_boleta") & "'"
end if
Set Rs = Conn.Execute( cSql )

Documentos_cobranza = 0
do While Not Rs.EOF
    agrega_tipo_cobro = true
    if Rs("documento") = "EXP" then
      'Verificar que el empleado tiene saldo para pagar con ECO EXP--> Si no, no puede pagar con ECO EXP
      if cdbl(session("saldo_empleado_ECO_EXP")) = 0 then agrega_tipo_cobro = false
      'Verificar que la venta es menor a $5000 --> no se puede pagar con ECO EXP
      if cdbl(Total_pesos) < 5000 then agrega_tipo_cobro = false
    end if
    
    if agrega_tipo_cobro then
      Documentos_cobranza = Documentos_cobranza + 1
      Seleccionado_cobranza(Documentos_cobranza) = "n"
      Eliminado_cobranza(Documentos_cobranza) = "n"
      Documento_cobranza(Documentos_cobranza) = rs("Documento")
      Nombre_cobranza(Documentos_cobranza) = rs("Nombre")
      Numero_documento_cobranza(Documentos_cobranza) = clng(rs("Numero_documento"))
      Numero_interno_documento_cobranza(Documentos_cobranza) = clng(rs("Numero_interno_documento"))
      Saldo_a_favor_cobranza(Documentos_cobranza) = clng(rs("Saldo_a_favor"))
    
      if IsNull(rs("Economato")) Then Economato(Documentos_cobranza) = "" Else Economato(Documentos_cobranza) = rs("Economato")
    end if
    Rs.MoveNext
Loop
Rs.close
set Rs = nothing

Total_por_pagar = Total_pesos

ColorLinea = "#dcdcbb"
PrimerTMU = false

x_total_pesos_a_cobrar_ECO = 0
tieneUEI = 0

for n = 1 to Numero_documentos_cobro
    Numero_interno_documento = 0
    Saldo_a_favor = 0
   if ColorLinea = "#dcdcbb" then
      ColorLinea = "#ededbb"
   else
      ColorLinea = "#dcdcbb"
   end if
%>
<tr bgcolor="<%=ColorLinea%>" class="FuenteInput">
   <td width="20" align="center"><%=n%>
    <input type=hidden name="NroDeLaCuota_<%=n%>" value="<%=NroDeLaCuota(n)%>">
    <input type=hidden name="DocumentoSeleccionado_<%=n%>" value="<%=Tipo_documento_cobro(n)%>">
   </td>
   <td>&nbsp;
       <select class="FuenteInput" id="Tipo_documento_cobro_<%=n%>" name="Tipo_documento_cobro_<%=n%>" style="width:150" Onchange="if( this.value == 'UEI;0;0;' ) { document.getElementById('Monto_documento_cobro_<%=n%>').value = 0;    };javascript:fVerificaDoc(this)" qonchange="submitform()">

<%  
    for u = 1 to Documentos_cobranza
        Numero_interno_documento = 0
        Saldo_a_favor = 0
        if Seleccionado_cobranza(u) = "n" then 'and Total_por_pagar > Saldo_a_favor_cobranza(u) then
            if Numero_interno_documento_cobranza(u) > 0 and Tipo_documento_cobro(n) = Documento_cobranza(u) then
				nPos = inStr( 1, objCad, ":" & Numero_interno_documento_cobranza(u) & "]" )
				if cDbl( nPos ) > 0 then
					'Seleccionado_cobranza(u) = "s"
				end if
            elseif Tipo_documento_cobro(n) = "EFI" and Tipo_documento_cobro(n) = Documento_cobranza(u)then
                'Seleccionado_cobranza(u) = "s"
            end if
            Numero_interno_documento = Numero_interno_documento_cobranza(u)
            Saldo_a_favor = Saldo_a_favor_cobranza(u)

            if Instr(1, Economato(u), Session("xEconomato") ) > 0 then %>
                <option value='<%=Documento_cobranza(u)&";"&Saldo_a_favor&";"&Numero_interno_documento & ";" & Economato(u)%>' <%if Tipo_documento_cobro(n) = Documento_cobranza(u) then response.write "selected"%>><%=Nombre_cobranza(u)%>&nbsp;(<%=Documento_cobranza(u)%>)</option>
        <%  elseif InStr(1, session("Economatos"), Documento_cobranza(u) ) > 0 and Session("xEconomato") <> "" then%>
        <%  else%>
                <option value='<%=Documento_cobranza(u)&";"&Saldo_a_favor&";"&Numero_interno_documento & ";" & Economato(u)%>' <%if Tipo_documento_cobro(n) = Documento_cobranza(u) then response.write "selected"%>><%=Nombre_cobranza(u)%>&nbsp;(<%=Documento_cobranza(u)%>)</option>
        <%  end if%>
    <%  end if
    next
%>
       </select>
   </td>

   <td>
   &nbsp;<input onkeypress="return Valida_Digito(event);"
   Class="FuenteInput" type="text" id="Monto_documento_cobro_<%=n%>" name="Monto_documento_cobro_<%=n%>" size="12" maxlength="10" value="<%=Monto_documento_cobro(n)%>" onchange="submitform()">
       <input type="hidden" name="Saldo_a_favor_cobranza_<%=n%>" value="<%=Saldo_a_favor%>">
       <input type="hidden" name="Numero_interno_documento_cobro_<%=n%>" value="<%=Numero_interno_documento%>">
<%      if Tipo_documento_cobro(n) = "UEI" then
           response.write "<font color=#ff0033 > <b> Equivalentes a $ " & ( Monto_documento_cobro(n) * DolarCambioSupervisoraCajas ) \ 1 & "&nbsp;(pesos) </b></font>"
            tieneUEI = 1
            Vuelto = Round(Vuelto / 10) * 10
        end if
        if Tipo_documento_cobro(n) = Documento_para_vuelto and Vuelto > 0 then
           if Billete <> "" then
              response.write "<b> Pagado con $ " & Billete & " : <font color=#ff0033 size=5>Vuelto de $ " & Vuelto & "&nbsp;</b></font>"
           else
              response.write "<b> <font color=#ff0033 size=5>Vuelto de $ " & Vuelto & "&nbsp;</b></font>"
           end if
            vuelto = 0
        end if
        %>
   </td>

<%if Tipo_documento_cobro(n) <> "DEI" and Tipo_documento_cobro(n) <> "NCV" and Tipo_documento_cobro(n) <> "EFI" and Tipo_documento_cobro(n) <> "UEI" then%>
   <td align=center>&nbsp;
<%if Tipo_documento_cobro(n) = "TMU" and not PrimerTMU then%>
       <input onkeypress="return Valida_Caracteres_Fecha(event);"
       Class="FuenteInput" type="text" id="Fecha_documento_cobro_<%=n%>" name="Fecha_documento_cobro_<%=n%>" 
       size="12" maxlength="10" value="<%=Fecha_documento_cobro(n)%>" 
       onBlur="DateFormat(this,this.value,event,false,'3')" onchange="submitform()">
       <input type="hidden" name="Tipo_documento_TMU_anterior_<%=n%>" value="TMU">
<%   PrimerTMU = true
  elseif Tipo_documento_cobro(n) = "TMU" and PrimerTMU then%>
       <input type="hidden" id="Fecha_documento_cobro_<%=n%>" name="Fecha_documento_cobro_<%=n%>" size="12" maxlength="10" value="<%=Fecha_documento_cobro(n)%>"><b><%=Fecha_documento_cobro(n)%></b>
<%   PrimerTMU = true
  else
    if Tipo_documento_cobro(n) = "ECO" or Tipo_documento_cobro(n) = "EXP" Then 'Para que no se modifique la fecha de vencimiento del economato
      x_total_pesos_a_cobrar_ECO = cdbl(x_total_pesos_a_cobrar_ECO) + cdbl(Monto_documento_cobro(n))
    %>
       <b><%=Fecha_documento_cobro(n)%></b>
       <input type="hidden" id="Fecha_documento_cobro_<%=n%>" name="Fecha_documento_cobro_<%=n%>" size="12" maxlength="10" value="<%=Fecha_documento_cobro(n)%>" >
<%  else %>
       <input onkeypress="return Valida_Caracteres_Fecha(event);"
       Class="FuenteInput" type="text" id="Fecha_documento_cobro_<%=n%>" name="Fecha_documento_cobro_<%=n%>" 
       size="12" maxlength="10" value="<%=Fecha_documento_cobro(n)%>" 
       onBlur="DateFormat(this,this.value,event,false,'3')">
<%  end if%>
<%end if%>
   &nbsp;</td>
   <td>&nbsp;
<%if InStr(1, session("Economatos"), Tipo_documento_cobro(n) ) = 0 then 
    if Tipo_documento_cobro(n) <> "EXP" then%>   
       <select Class="FuenteInput" id="Banco_documento_cobro_<%=n%>" name="Banco_documento_cobro_<%=n%>" style="width:300" >
<%
     for u = 1 to Bancos
         if not ( Tipo_documento_cobro(n) = "CHI" and Banco(u) = "." ) then%>
       <option value="<%=Banco(u)%>" <%=Selected(Banco_documento_cobro(n),Banco(u))%>><%=Nombre_banco(u)%>&nbsp;(<%=Banco(u)%>)</option>
<%       end if
     next%>			
       </select>
     <%else%>
    <span style="width:300">&nbsp;<%=Session("xEconomato_nombre")%></span>
    <%end if%>
<%else%>
<span style="width:300">&nbsp;<%=Session("xEconomato_nombre")%></span>
<%end if%>
   </td>
   <td>&nbsp;<input onkeypress="return Valida_Digito(event);"
   Class="FuenteInput" type="text" id="Numero_documento_cobro_<%=n%>" name="Numero_documento_cobro_<%=n%>" size="12" maxlength="10" 
   value="<%=Numero_documento_cobro(n)%>"></td>
<%elseif Tipo_documento_cobro(n) = "DEI" or Tipo_documento_cobro(n) = "NCV" then%>
<%else%>
   <td colspan="3">&nbsp;</td>
<%end if
  if Tipo_documento_cobro(n) <> "DEI" and Tipo_documento_cobro(n) <> "NCV" and Tipo_documento_cobro(n) <> "EFI" and Tipo_documento_cobro(n) <> "UEI" and n = Numero_documentos_cobro then%>
   <td><input onkeypress="return Valida_Digito(event);"
   Class="FuenteInput" type="text" id="Numero_documentos_adicionales" name="Numero_documentos_adicionales" size="3" maxlength="2" value="1" 
   onchange="agrega_cheques()"></td>
<%   else%>
   <td></td>
<%end if%>
<%if Tipo_documento_cobro(n) = "TMU" then%>
   <td>&nbsp;<%=Fecha_vencimiento_tmu(n)%>&nbsp;
       <input type="hidden" name="Fecha_vencimiento_tmu_<%=n%>" value="<%=Fecha_vencimiento_tmu(n)%>"
   </td>
<%end if%>
</tr>
<%
next
%>
</table>

</div>
<script type="text/javascript">
  function documentReady(){
    tieneUEI = '<%=tieneUEI%>';
    if(tieneUEI == "1")
      document.getElementById('Total_dolares').innerHTML = '<%=replace(formatnumber(Total_dolares,0),",",".") & "US$"%>';
  }
</script>
