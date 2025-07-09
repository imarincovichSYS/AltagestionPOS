<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then

set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 3600

MensajeError = ""

on error resume next

sub log_error(Sql,SqlError)
		set Conector = server.createobject("ADODB.Connection")
		Conector.open session("DataConn_ConnectionString")
		Conector.CommandTimeout = 3600
		SqlError = replace( SqlError , "[Microsoft][ODBC SQL Server Driver][SQL Server]", "")
 		Conector.Execute( "exec LOG_Insert '" & trim(Session("Login")) & "','" & replace( Sql ,"'",chr(34)) & "','" & replace( SqlError ,"'",chr(34)) & "','" & replace( Request.ServerVariables("SCRIPT_NAME") ,"'",chr(34)) & "'" )
		Conector.close
		set Conector = nothing
end sub

if Request("Accion") & "*" = "Terminado*" then

   if clng( "0" & trim(Request("Numero_boleta")) ) > 0 then
      if Request("Accion") = "Manual" then
         Tipo_boleta = "M"
      else
         Tipo_boleta = "F"
      end if
			For n = 1 to 5
      Conn.BeginTrans
      Conn.execute("Exec DOV_Actualiza_folio_boleta '" & trim(Session("Login")) & "',0" & Request("Numero_boleta") & ",'" & Tipo_boleta & "',0" & Request("Numero_caja") )
			if session("Login_punto_venta") <> "" and session("Login_punto_venta") <> session("Login") then
				 Conn.execute("EXEC PUN_Cambia_responsable '" & trim(Session("Login")) & "','" & trim(Session("Login_punto_venta")) & "'")
			end if
      Conn.execute("EXEC PUN_Libera_cajera '" & trim(Session("Login")) & "'")

      'Se elimina la boleta fantasma de la lista
      if Tipo_boleta = "F" and clng( "0" & trim(Request("Numero_caja")) ) > 0 then
         conn.Execute( "exec PUN_Elimina_boleta_fiscal_impresa '" & _
                             Session("empresa_usuario") & "', '" & +_
                             Session("xCentro_de_venta") & "',0" & +_
                             Request("Numero_boleta") & ",0" & +_
                             Request("Numero_caja") )
      end if

      if len(trim(Err.Description)) > 0 then
         Terminado = false
         Conn.RollbackTrans
			   MsgError = LimpiaError(Err.Description)
				 Log_error "Error SQL al liberar cajera después de imprimir" , Err.Description 
      else
         Terminado = true
         Conn.CommitTrans
         Session("Cliente_boleta") = ""
         Session("Forma_pago") = ""
				 Session("Login_punto_venta") = ""
				 response.redirect "Boleta_PuntoVentaZF.asp?Imprimiendo=Si"
				 exit for
	    end if
			next
   else
	    Log_error "Error al tratar de liberar cajera después de imprimir" , "El número de la boleta estaba en cero"  
   end if
   
end if

Conn.Close

%>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">
<script language="JavaScript">
<%if Terminado then%>
location.href = "Boleta_PuntoVentaZF.asp?Imprimiendo=Si";
<%end if%>
function Iniciar()
{
parent.top.frames[1].document.all.Accion.value = "Iniciar";
parent.top.frames[1].document.Formulario.submit();
}
</script>
</head>
<body bgcolor="<%=Session("ColorFondo")%>" leftmargin=0 topmargin=0 text="#000000" background="../../<%=Session("ImagenFondo")%>">
	
<table width=100% border=0 cellspacing=0 cellpadding=0>
<tr>
<td align="center">
<a href="javascript:Iniciar()"><img src="f2_boleta.gif" border="0"/></a>
</td> 
</tr>
</table>

</body>
</html>
<%else
	Response.Redirect "../../index.htm"
end if%>