<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.inc" -->
<!-- #include file="../../Scripts/Inc/Montoescrito.Inc" -->
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
	Cache
%>
<% Session.LCID = 11274 %>
<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
<%

'response.end

i=1
j=0
flag = 0
OpenConn
lineas_seleccionadas = 0
lineas_en_guias = 0 'esta variable es para que se hagan guias de no mas de 10 lineas  
lineas_grabadas = 0

for i=1 to Request("Lineas")	
  if Request("check_"&i)="on" then
    lineas_seleccionadas = lineas_seleccionadas + 1
    strSQL = "select Stock_real from productos_en_bodegas where empresa='SYS' and producto = '" & Request("Producto"&i) & "' and bodega='0010'"
    set rs = Conn.Execute(strSQL)
  	if cdbl(Request("pedido_"&i)) > cdbl(rs("Stock_real")) then
      response.write ("La cantidad solicitada para el código " & Request("Producto"&i) & " supera el stock de Bodega")
      flag = 1  
      exit for
    end if
    'response.write rs("Stock_real") & " "
    'response.write Request("Pedido"&i)
  end if
next
if flag=0 then 'Todas las cantidades a pedir estan correctas
  if lineas_seleccionadas > 0 then
    %><table border=1 align=center cellpadding=0 cellspacing=0 width="20%">
      <tr class="FuenteCabeceraTabla">
        <DIV value="Descripcion">Guias Creadas</DIV>
      </tr>
    <%
    for i=1 to Request("Lineas")	
      if Request("check_"&i)="on" then
        if lineas_grabadas = 0 or lineas_grabadas = 11  then
          strSql = "exec DOC_NuevoFolio 'TBE'"
          set rs_nuev_folio = Conn.Execute(strSQL)
          
          strSql="exec DNV_GrabaTransferencia 0,0,'SYS'," & rs_nuev_folio("Folio") & ",'"&Session("Login")&"','0011','0010','" & year(date()) & "/" & Month(date()) & "/" & day(date()) &  " " & hour(Now()) & ":"  & Minute(Now()) & ":" & Second(Now()) & "','TBE','TEB'," & Request("numero_ped") & ",'','PRE','Solicitado  por : "& Request("pedido_por") &_
                 " Preparado por :  ','"&Session("Login")&"','"&Session("Login")&"',00,00,'T',Null,'M.ABAST'"
                 
                 
          set rs = Conn.Execute(strSQL)
          
          %>
            <tr>
              <td> <a href="javascript:transito('<%=rs_nuev_folio("Folio")%>')"><%=rs_nuev_folio("Folio")%></a>
            </tr>
        
          <%
          
          strSql = "Select Numero_interno_documento_no_valorizado from documentos_no_valorizados where empresa='SYS' and documento_no_valorizado='TBS' and numero_documento_no_valorizado=" & rs_nuev_folio("Folio")
          set rs1 = Conn.Execute(strSQL)
          lineas_grabadas = 1
        end if
        if cdbl(Request("pedido_"&i)) > 0 then          
            strSql = "exec MOP_GrabaMovimientoProducto 0," & rs1("Numero_interno_documento_no_valorizado") & ",'SYS','TBS'," & rs_nuev_folio("Folio") & "," & lineas_grabadas & " ,'" & Request("Producto"&i) & "'," & Request("numero_ped") & ",null,'0010',Null,null,null,'"&Session("Login")&"',NULL,0,0,0," & rs_nuev_folio("Folio") & ",'" & year(date()) & "/" & Month(date()) & "/" & day(date()) &  " " & hour(Now()) & ":"  & Minute(Now()) & ":" & Second(Now()) & "',0, 0,0," & Request("pedido_"&i) & ", null,'$',1,'" & year(date()) & "/" & Month(date()) & "/" & day(date()) & "',0,0,0,0,0,0,0,'Solicitado por : " & Request("pedido_por") &_
                     " Preparado por :  ','',0,0,'PRE'"
            set rs = Conn.Execute(strSQL)
            strSql = "exec MOP_GrabaMovimientoProducto 0," & rs1("Numero_interno_documento_no_valorizado") & ",'SYS','TBE'," & rs_nuev_folio("Folio") & "," & lineas_grabadas & " ,'" & Request("Producto"&i) & "'," & Request("numero_ped") & ",null,'0011',Null,null,null,'"&Session("Login")&"',NULL,0,0,0," & rs_nuev_folio("Folio") & ",'" & year(date()) & "/" & Month(date()) & "/" & day(date()) &  " " & hour(Now()) & ":"  & Minute(Now()) & ":" & Second(Now()) & "',0, 0," & Request("pedido_"&i) & ",0, null,'$',1,'" & year(date()) & "/" & Month(date()) & "/" & day(date()) & "',0,0,0,0,0,0,0,'Solicitado por : " & Request("pedido_por") &_
                     " Preparado por :  ','',0, 0, 'PRE'"
            set rs = Conn.Execute(strSQL)          
            lineas_grabadas = lineas_grabadas + 1
        end if
      end if
    next
      %></table><%
  end if
end if
%>
</body>
</html>
<%
    'response.write strsql
    'response.end
    'response.write Request("Pedido"&i) & response.write(" ")
    %>

<script language=javascript>
	function transito(numero_guia)
	{
		var winURL		 = "Imprimir_TraspBodega.asp?NumGuia="+numero_guia;
		var winName		 = "Wnd_Productos";
		var winFeatures  = "status=no," ; 
			winFeatures += "resizable=no," ;
			winFeatures += "toolbar=no," ;
			winFeatures += "location=no," ;
			winFeatures += "scrollbars=no," ;
			winFeatures += "menubar=0," ;
			winFeatures += "width=800," ;
			winFeatures += "height=500," ;
			winFeatures += "top=30," ;
			winFeatures += "left=0" ;
			window.open(winURL,winName,winFeatures);
	}
</script>
