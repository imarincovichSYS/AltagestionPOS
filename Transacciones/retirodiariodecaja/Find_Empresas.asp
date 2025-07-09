<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<script src="../../js/jquery-1.7.2.min.js" type="text/javascript"></script>

<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	if Session("Browser") = 1 then
		largocampo = 30
	else
		largocampo = 20
	end if

'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'buscamos el puerto de la impresora fiscal en PARÁMETROS

set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 3600

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
Puerto = trim( replace( ucase( Puerto ) , "COM" , "" ) )


Sql = "select top 1 Usr_Bodega from entidades_comerciales where entidad_comercial = '"&Session("Login")&"'"
set rs_bodega=conn.Execute(Sql)
If Not rs_bodega.EOF Then
  if rs_bodega("Usr_Bodega") <> "0011" then
    Response.Redirect "Empty.asp"
  end if
end if
conn.close
set conn = nothing

'fin puerto
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**

%>

<html>
<head>
	<title><%=session("title")%></title>
	<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">

	<!--<script src="../../Scripts/Js/Caracteres.js"></script>-->
</head>

	<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">

<%
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'código para obtener el número de la Impresora Fiscal

%>

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
    'Msgbox "Se produjo un error con la impresora: " & chr(13) & TextoError, vbOkOnly + 16, "Error"
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
           Msgbox "La impresora no esta conectada u otro problema la afecta, apague y encienda." & chr(13) & TextoError, vbOkOnly + 16, "Error"
    	   parent.document.frames(1).location.href = "List_Empresas.asp?Boleta_actual=0&Fiscal_actual=0"
        else
           aRegistro = Split( xError , ":" )
           if aRegistro(48) = "2" then
              'Msgbox "Advertencia : " & chr(13) & "No se ha sacado un informe Z en mas de 24 horas", vbOkOnly + 16, "Advertencia"
           end if
           if aRegistro(43) = "2" and aRegistro(48) = "3" then
              'Msgbox "Error con la impresora fiscal ! " & chr(13) & "Debe emitir un informe Z y hacer Apertura del período para iniciar las ventas", vbOkOnly + 16, "Error"
              parent.document.frames(1).location.href = "List_Empresas.asp?Boleta_actual=" & ( clng( aRegistro(2) ) + 1 ) & "&Fiscal_actual=" & clng( aRegistro(30) ) & "&msg=" & xError & "&lIniciar" & lIniciar
           elseif aRegistro(48) = "3" then
              'Msgbox "Error con la impresora fiscal ! " & chr(13) & chr(13) & "No se ha sacado un informe Z en mas de 26 horas", vbOkOnly + 16, "Error"
              parent.document.frames(1).location.href = "List_Empresas.asp?Boleta_actual=" & ( clng( aRegistro(2) ) + 1 ) & "&Fiscal_actual=" & clng( aRegistro(30) ) & "&msg=" & xError & "&lIniciar" & lIniciar
           elseif aRegistro(43) = "2" then
              'Msgbox "" & chr(13) & chr(13) & "Debe hacer Apertura del período para iniciar las ventas", vbOkOnly + 16, "Error"
              parent.document.frames(1).location.href = "List_Empresas.asp?Boleta_actual=" & ( clng( aRegistro(2) ) + 1 ) & "&Fiscal_actual=" & clng( aRegistro(30) ) & "&msg=" & xError & "&lIniciar" & lIniciar
           else
              lIniciar = false          
              parent.document.frames(1).location.href = "List_Empresas.asp?Boleta_actual=" & ( clng( aRegistro(2) ) + 1 ) & "&Fiscal_actual=" & clng( aRegistro(30) ) & "&msg=" & xError & "&lIniciar" & lIniciar
              
           end if
        end if
else
    location.href = "List_Empresas.asp?Boleta_actual=" & ( clng( aRegistro(2) ) + 1 ) & "&Fiscal_actual=" & clng( aRegistro(30) ) & "&msg=" & xError & "&lIniciar" & lIniciar
 end if

<%
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**--**
'fin codigo para obtener el numero de la Impresora Fiscal
%>
</script>
<script language="JavaScript"> 
   $( document ).ready(function() {
      $("#monto_retiro").keydown(function(event) {
         var keyCode = event.keyCode || event.which;
         if(event.which == 113) { //F2
            VBFuncCajon();          
            return false;
         }
         if ((keyCode < 48 || keyCode > 57) && !isNavigationKey(keyCode,$("#monto_retiro").val())) {
            event.preventDefault();
         }	
      });
   });

   function isNavigationKey(keyCode, inputValue) {
      if(inputValue==""){
         hasValue = false;
      }else{
         hasValue = inputValue.trim().length > 0;
      }
      return (
        keyCode === 8 || // Retroceso
        keyCode === 9 || // Tabulación
        (keyCode === 13 && hasValue) || // Entrada (Enter) si hay al menos un carácter
        keyCode === 27 || // Escape
        keyCode === 46 || // Suprimir
        (keyCode >= 35 && keyCode <= 40) || // Flechas
        (keyCode >= 48 && keyCode <= 57) || // Números estándar
        (keyCode >= 96 && keyCode <= 105) // Números del teclado numérico
      );
   }
</script>
		<table width=100% align=center border=0 cellspacing=0 cellpadding=0 >
			<tr>
				<td width=100% class="FuenteTitulosFunciones" align=center nowrap><%=session("title")%></td> 
			</tr>
		</table>
		<Form name="Frm_mantencion_x" method="post" action="Save_Empresas.asp" target="Listado">

			<table width=100% align=center border=0 cellspacing=0 cellpadding=0>
				<tr>
					<td class="FuenteEncabezados" width=10% align=right ><b>Monto $&nbsp;</b></td>
					<td width=80% align=left class="FuenteEncabezados">
						<input align=left id="monto_retiro" type=Text name="monto_retiro" size=13 maxlength=8>&nbsp; (Presionar Enter para ingresar el monto)
					</td>
				</tr>
					<tr>
					<td class="FuenteEncabezados" width=10% align=right ><b>Medio $&nbsp;</b></td>
					<td width=80% align=left>
						<select align=left Class="FuenteInput" id="monto_medio" name="monto_medio">
              <option name="monto_medio" value="EFI"> EFECTIVO (EFI) </option>
              <!--<option name="monto_concepto" value="B"> OTRO RETIRO </option>
              <option name="monto_concepto" value="C"> OTRO RETIRO </option>
              <option name="monto_concepto" value="D"> OTRO RETIRO </option>-->
            </select>
					</td>
				</tr>
				<tr>
					<td class="FuenteEncabezados" width=10% align=right ><b>Concepto &nbsp;</b></td>
					<td width=80% align=left>
						<select align=left Class="FuenteInput" id="monto_concepto" name="monto_concepto">
              <option name="monto_concepto" value="P"> RETIRO PARCIAL DE CAJA </option>
              <option name="monto_concepto" value="L"> RETIRO POR LIMITE DE CAJA </option>
              <!--<option name="monto_concepto" value="C"> OTRO RETIRO </option>
              <option name="monto_concepto" value="D"> OTRO RETIRO </option>-->
            </select>
					</td>
				</tr>
				<tr></tr>
				<tr>
				<td></td>
				
				<td>
				
        <!--  <input align=left Class="FuenteInput" type=submit name="retiro" value="Ingresar retiro" size=13 maxlength=8 > -->
				</td>
				<!--	<td class="FuenteEncabezados" width=10% align=left >Nombre</td>
					<td width=80% align=left >
						<input Class="FuenteInput" type=Text name="Nombre" size="<%=largocampo%>" maxlength=50 value="<%=session("Nombre")%>" aonblur="javascript:validaCaractesPassWord(this.value , this)">
					</td>-->
				</tr>    
			</table>
		</form>
    
	</body>
</html>

<%else
	Response.Redirect "../../index.htm"
end if%>

<script language="VbScript">
	sub VBFuncCajon()
	Set MSComm1 = CreateObject("MSCOMMLib.MSComm")
	MSComm1.Settings = "19200,N,8,1"
	MSComm1.CommPort = "1"
	MSComm1.PortOpen = True        
	MSComm1.Output = Chr(135) + "34100000" + Chr(136)
	'Msgbox "abre cajon .",vbOKOnly," :. Advertencia .: "
	MSComm1.PortOpen = False
	end sub

   Sub MyFunction()
   Set MSComm1 = CreateObject("MSCOMMLib.MSComm")
	MSComm1.Settings = "19200,N,8,1"
	MSComm1.CommPort = "1"
	MSComm1.PortOpen = True   
            If Err Then
            MsgBox "COM" & MSComm1.CommPort & ": not opened, Sorry!"
            Exit Sub
            End If
         	MSComm1.Output = Chr(135) + "34100000" + Chr(136)
	'Msgbox "abre cajon .",vbOKOnly," :. Advertencia .: "
	MSComm1.PortOpen = False
    End Sub
</script>