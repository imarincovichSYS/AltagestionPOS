<!-- #include file="../../Scripts/Asp/Conecciones.Asp" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then
'On error resume next
	
	Error = "N"
	MsgError = ""
    
    SET Conn = AbrirConexion ( Session( "DataConn_ConnectionString") )
	Conn.BeginTrans()

    nColumnas = Request("Columnas")
    for a = 3 to nColumnas-1
        Fecha = Request("Fecha_0_" & a)
        Dia = Left(Fecha,2)
        Mes = Mid( Fecha, 4, 2)
        Ano = Right(Fecha,4)
    
        cSql = "Exec PIE_Borra_presupuesto_ingreso_egreso_diario_x_dia '" & Session("Empresa_usuario") & "', "
        cSql = cSql & "'" & Request("Centro_de_venta") & "', "
        cSql = cSql & Mes & ", "
        cSql = cSql & Ano & ", "
        cSql = cSql & Dia
        Conn.Execute ( cSql )
        If Conn.Errors.Count > 0 then
            Error = "S"
            MsgError  = Err.Description
        end if

        if Error = "N" then
            Ingresos = Request("txtIngresoPresupuestado_10_" & a)
                if len(trim(Ingresos)) = 0 then Ingresos = 0
            Egresos  = Request("txtEgresoPresupuestado_17_" & a)
                if len(trim(Egresos)) = 0 then Egresos = 0
            if Ingresos > 0 Or Egresos > 0 then
                cSql = "Exec PIE_Graba_presupuesto_ingreso_egreso_diario '" & Session("Empresa_usuario") & "', "
                cSql = cSql & "'" & Request("Centro_de_venta") & "', "
                cSql = cSql & Dia & ", "
                cSql = cSql & Mes & ", "
                cSql = cSql & Ano & ", 0"
                cSql = cSql & Ingresos & ", 0"
                cSql = cSql & Egresos
                Conn.Execute ( cSql )
                If Conn.Errors.Count > 0 then
                    Error = "S"
                    MsgError  = Err.Description
                    exit for
                end if
            end if
        end if
    next
    
	If Error = "N" then
		Conn.CommitTrans				
		MsgError = "Se actualizaron los presupuestos."
	Else
		Conn.RollbackTrans
	End if
	
    MsgError = LimpiaError ( MsgError )
   
    CerrarConexion ( Conn )
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
<%	end if %>

<script language="javascript">
    Mensajes_frame('<%=MsgError%>');

    parent.top.frames[1][0].document.Listado.Recalcula_sin_cheques_ni_otros_ingresos.value = "N";
	parent.top.frames[1][0].document.Listado.action="List_FlujoCaja.asp";
	parent.top.frames[1][0].document.Listado.target="Listado";
	parent.top.frames[1][0].document.Listado.submit();
</script>	
<%else
	Response.Redirect "../../index.htm"
end if
%>
