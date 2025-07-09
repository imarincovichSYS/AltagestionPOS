<%
'Nombre_DSN = "AG_Sanchez_Productivo"
Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"

RutaProyecto = "http://s01sys.sys.local/altagestion/"
'Response.Write RutaProyecto
'Response.End
SET Conn = Server.CreateObject("ADODB.Connection")
SET Conn1 = Server.CreateObject("ADODB.Connection")
Conn.Open strConnect
Conn1.Open strConnect
Conn.commandtimeout=600

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
'codigo  = Ucase(trim(Request.Form("codigo")))
  strSQL="select distinct numero_orden_de_venta from ordenes_de_ventas where fecha ='" & month(date()) &"-"&day(date())&"-"&year(date())&"' and estado = 'A' order by numero_orden_de_venta desc"
  set rs1 = Conn1.Execute(strSQL)
  if not rs1.eof  then%>
    <table width="100%" cellPadding="0" cellSpacing="0" align="center" border = 1>
      <form id="form_Nota_de_venta" name="form_Nota_de_venta" method="post" action="Mantencion_productos_Nota_de_venta.asp">
        <input type="hidden" id="num_n_de_venta" name="num_n_de_venta">
        <input type="hidden" id="cliente_nota_de_venta" name="cliente_nota_de_venta">
      </form>
      <tr id="texto_12">
        <td><b><u>Num. Nota Vta.</u></b></td>
        <td><b><u>Fecha</u></b></td>
        <td><b><u>Cliente</u></b></td>
      </tr><%
    do while not rs1.eof
      strSQL="select top 1 numero_orden_de_venta, fecha, cliente from ordenes_de_ventas where numero_orden_de_venta =" & rs1("numero_orden_de_venta")
      set rs = Conn.Execute(strSQL)
      %>
      <tr id="texto_12" OnMouseOver="SetColor(this,'#E2EDFC','');this.style.cursor='hand';" OnMouseOut="SetColor(this,'','');" OnClick="inserta_en_nota_de_venta('<%=rs("numero_orden_de_venta")%>','<%=rs("cliente")%>');">
          <td align = "Left"><%=rs("numero_orden_de_venta")%></td>  	
          <td align = "right"><%=rs("fecha")%></td>
          <td align = "right"><%=rs("cliente")%></td>  
        </tr>
      <%
      rs1.movenext  
    loop%>
    </table>
  <%else%>
    <center><b>NO EXISTE NOTAS DE VENTA PARA HOY</b></center>
  <%end if
'rs.close
'set rs = nothing
'Conn.Close
'set Conn = nothing
%>

	
		
