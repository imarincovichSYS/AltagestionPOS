<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	on error resume next
	OK=0
	grabar =false
	SET Proceso = Server.CreateObject("ADODB.Connection")
	Proceso.Open Session("Dataconn_ConnectionString")
	Proceso.commandtimeout=600
	Proceso.BeginTrans()

    Fecha_emision=mid(request("Fecha_cierre_solicitado"),7,4)&"/"&mid(request("Fecha_cierre_solicitado"),4,2)&"/"&mid(request("Fecha_cierre_solicitado"),1,2) & " " & mid(request("Fecha_cierre_solicitado"),12)
	sql="exec CDC_Oficializa_cierre '" & session("empresa_usuario") & "','" & +_
											Session("login") & "','" & +_
											Fecha_emision & "',0" &+_
											request("totalmoneda$") & ",0" &+_
											request("totalmonedaUS$")
	'Response.Write(sql)
		Proceso.Execute(sql)
	If  Proceso.Errors.Count = 0 then
		Proceso.CommitTrans				
		OK=1
		msgerror	= "Proceso terminado satisfactoriamente."
	Else
		Proceso.RollbackTrans
		msgerror	= "No se puede ingresar/modificar este cierre de caja."
	End if


	
	Proceso.Close
	Set Proceso = Nothing

%>

<%	if Session("Browser") = 1 then %>
		<script language="vbScript">
			Sub Mensajes_frame( valor )
				parent.top.frames(3).document.all("IdMensaje").InnerHtml = valor
			End Sub
		</script>
<%	else%>
		<script language="JavaScript">
			function Mensajes_frame( valor )
			{
				with (parent.top.frames[3].document.IdMensaje.document)
				{
				  open();
				  write(valor);
				  close();
				}
			}
		</script>
<%	end if
%>

<script language="javascript">
Mensajes_frame('<%=msgerror%>');
//alert('<%=msgerror%>');
if (<%=OK%>==1)
{
	location.href="Mant_CierreCaja.asp?Accion=N"
	parent.top.frames[2].location.href = "BotonesMantencion_CierreCaja.asp";		
//	parent.top.frames[1].document.Formulario.action="Comprobante_CierreCaja.asp";
//	parent.top.frames[1].document.Formulario.submit();
}
else
{
	history.back();
}
</script>	
<%else
	Response.Redirect "../../index.htm"
end if
%>
