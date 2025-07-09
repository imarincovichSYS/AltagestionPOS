<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
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

