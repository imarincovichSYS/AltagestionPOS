<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<html>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>">

<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
	
	On error resume next
	OK=0
	
	SET Proceso = Server.CreateObject("ADODB.Connection")
	Proceso.Open Session("Dataconn_ConnectionString")
	Proceso.commandtimeout=3600
    
    Empresa	= session("Empresa_usuario")

    hasta=cint(request("registros"))	
   if request("SW") = "S" then
        	for i=0 to hasta-1
        			if request("Cambiar"&i) = "on" then
            
                        Sql = "MOP_Cambio_de_CPA_actualiza " &+_
                              "'" & request("Numero_interno_movimiento_producto"&i) & "'," & +_
                              "'" & request("Codigo_Nuevo") & "'," & +_
                              "'" & request("Codigo_actual") & "'," & +_
                			        "'" & request("Tipo_de_cambio") & "'," & +_
                			        "'" & session("login") & "'"
                			        
                			Proceso.Execute(sql)
        '	               Proceso.RollbackTrans
        					If Proceso.Errors.Count <> 0 then
        						MsgError = Err.Description 
                                grabar=false
        						exit for
        					else
        						grabar=true
        '						nomina=nomina & request("Numero_interno_documento_valorizado"&i) & "@"
        					End if
        ''        			rs.close
        ''        			set rs=nothing
                    end if
            next
''    grabar = true

    	If grabar then
    		Proceso.CommitTrans				
    		OK=1
    '	    Proceso.RollbackTrans
    
     		    msgerror	= "Proceso terminado satisfactoriamente."
 
    
        Else
    		Proceso.RollbackTrans
            msgerror = MsgError
    	End if
    else
        msgerror = "No hay registros seleccionados."
    end if
	Msgerror = LimpiaError(Msgerror)
	
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

'	for i=0 to hasta-1
    %><%'=request("Codigo_Actual")%><%
''    next
%>

<script language="javascript">
parent.top.frames[2].location.href = "Botones_CambCodProd.asp?nomina=N";
Mensajes_frame('<%=msgerror%>');

/*
//alert('<%=msgerror%>');
if (<%=OK%>==1)
{
	location.href="Nomina_CambCodProd.asp?Nomina=<%=Nomina%>";
}
else
{
	location.href="List_CambCodProd.asp";
}*/
</script>	
<%else
	Response.Redirect "../../index.htm"
end if
%>
</body>
</html>
