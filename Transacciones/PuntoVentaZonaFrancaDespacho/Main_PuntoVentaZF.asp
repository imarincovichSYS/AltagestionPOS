<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../_private/config.asp" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then

	Session("ValoresConIva") = "S"

	Session("Numero_OrdenVtaSUP")		= ""
	Session("Fecha_OrdenVtaSUP")		= date()
	Session("Estado_OrdenVtaSUP")		= ""
	Session("Proveedor_OrdenVtaSUP")	= ""
	Session("Posicion")					= 0
	Session("Elimina_producto")			= ""
	Error		= "N" 
	MsgError	= Request("Msg")
	if len(trim(Session("xBodega"))) = 0 then
		Error = "S"
		MsgError = "Para poder ingresar a esta opción debe tener asignada una bodega."
	end if

	if len(trim(Session("xCentro_de_venta"))) = 0 then 
		Error = "S"
		MsgError = "Para poder ingresar a esta opción debe estar asociado a un centro de venta."
	end if
    Session("xEconomato") = ""
  
  if Error = "N" then 'Tiene bodega y centro de venta asociado
    if trim(Session("xBodega")) <> trim(Session("xCentro_de_venta")) then 'Verificar que la bodega y el centro de venta sean iguales
      Error = "S"
		  MsgError = "Para poder ingresar a esta opción la bodega debe ser igual al centro de venta."
    else 'Verificar si la bodega y centro de venta corresponden al local físico (IP PC)
      OpenConn 
      IP_EQUIPO = Request.ServerVariables("REMOTE_ADDR")
      strSQL="select A.bodega, B.descripcion_breve from " &_
             "(select bodega from cajas with(nolock) where caja_ip = '"&IP_EQUIPO&"') A, " &_
             "(select bodega, descripcion_breve from bodegas with(nolock) where empresa = 'SYS') B " &_
             "where A.bodega = B.bodega "
      'Response.Write strSQL
      'Response.End
      set rs = Conn.Execute(strSQL)
      if rs.EOF then
        Error = "S"
		    MsgError = "Para poder ingresar a esta opción el equipo debe estar configurado para utilizar el Punto de Venta (IP equipo)"
		  else
		    n_bodega  = trim(rs("descripcion_breve"))
		    bodega    = trim(rs("bodega"))
		    'Response.Write bodega
		    'Response.End
		    rs.close
        set rs = nothing
		    if bodega <> "0099" then '-->Bodega = A001 corresponden a equipos de digitación o encargados de informática
		      if bodega <> trim(Session("xCentro_de_venta")) then 'Perfil de cajera incorrecto, tiene mal asociado el centro de venta
		        Error = "S"
		        MsgError = "Para poder ingresar a esta opción debe tener asociado el centro de venta: "&n_bodega
		      end if
		    end if
      end if
    end if
  end if
%>
<html>
  <body >
	<script language="JavaScript">
	<%	if Error = "N" Then %>
			parent.Trabajo.location.href = 'Inicial_PuntoVentaZF.asp?Orden=<%=Request("Orden")%>&pagenum=<%=Request("pagenum")%>'
	<%	else%>
			parent.top.frames[1].location.href = "../../empty.asp"
	<%	end if%>
			parent.Botones.location.href = "../../empty.asp"
			parent.Mensajes.location.href = '../../Mensajes.asp?Msg=<%=MsgError%>';
	</script>
  </body>
</html>
     
<%else
	Response.Redirect "../../index.htm"
end if%>
