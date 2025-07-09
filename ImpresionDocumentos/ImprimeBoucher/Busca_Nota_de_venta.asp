<%
'Nombre_DSN = "AG_Sanchez_Productivo"
Nombre_DSN = "AG_Sanchez"
strConnect = "DSN="&Nombre_DSN&";UID=AG_Sanchez;PWD=Vp?T+!mZpJds;APP=BackOffice;WSID=" & Request.ServerVariables( "REMOTE_ADDR" ) & ";DATABASE=Sanchez;Network Library=DBMSSOCN"

RutaProyecto = "http://s01sys.sys.local/altagestion/"
'Response.Write RutaProyecto
'Response.End
SET Conn = Server.CreateObject("ADODB.Connection")
Conn.Open strConnect
Conn.commandtimeout=600

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

function Existe_ImagenProducto(v_imagen_producto)
  RutaFISICA_ImagenesProductos  = Request.ServerVariables("APPL_PHYSICAL_PATH") & "\Imagenes\Productos\"
  
  SinImagen   = "noimagen.gif"  
  archivo     = RutaFISICA_ImagenesProductos & v_imagen_producto
  Set objFSO  = Server.CreateObject("Scripting.FileSystemObject")
  imagen      = v_imagen_producto
  if not objFSO.FileExists(archivo) then imagen = SinImagen
  Existe_ImagenProducto = imagen
end function

codigo  = Ucase(trim(Request.Form("numero_nota_de_venta")))

  strSQL="select cantidad = sum(cantidad), producto, precio = max(precio),total = sum(precio*cantidad), cliente = max(cliente) from ordenes_de_ventas " &_ 
         "where numero_orden_de_venta =" & codigo & " and estado = 'A' group by producto having sum(cantidad)>0" 
         
  'Response.Write strSQL
  'Response.End
  set rs = Conn.Execute(strSQL)
  if not rs.EOF then
      Cliente = rs("cliente")%>
      <table width="100%" cellPadding="0" cellSpacing="0" align="center" border = 1>
      <form id="form_Nota_de_venta" name="form_Nota_de_venta" method="post" action="Mantencion_productos_Nota_de_venta.asp">
      <input type="Hidden" id="num_n_de_venta" name="num_n_de_venta">
      <input type="Hidden" id="cliente_nota_de_venta" name="cliente_nota_de_venta">
      </form>
      <tr id="texto_12">
        <td><b><u>Código</u></b></td>
        <td><b><u>Cantidad</u></b></td>
        <td><b><u>Precio</u></b></td>
        <td><b><u>Total</u></b></td>
      </tr>
      <%do while not rs.EOF%>
        <tr id="texto_12" OnMouseOver="SetColor(this,'#E2EDFC','');this.style.cursor='hand';" OnMouseOut="SetColor(this,'','');" OnClick="inserta_en_nota_de_venta('<%=codigo%>','<%=Cliente%>');">
          <td align = "Left"><%=rs("producto")%></td>  	
          <td align = "right"><%=rs("Cantidad")%></td>
          <td align = "right"><%=FormatNumber(rs("precio"),0)%></td>
          <td align = "right"><%=FormatNumber(rs("total"),0)%></td>          
        </tr>
      <%
      total_nv = total_nv + cdbl(rs("total"))
      rs.movenext
      loop%>
      <tr id="texto_12">
        <td colspan = 3 align = "right"><b>Total: </td>
        <td align = "right"><%=FormatNumber(total_nv,0)%></td>
      </tr>
      </table>
      <%  
  else
  %>
  <center><b>NOTA DE VENTA NO EXISTE</b></center>
  <%
  end if
'rs.close
'set rs = nothing
'Conn.Close
'set Conn = nothing
%>

<script language="javascript">

</script>

	
		
