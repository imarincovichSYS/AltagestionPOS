<%@ Language=VBScript %>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

busqueda_aprox      = Request.Form("busqueda_aprox")
documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")

if num_carpeta <> "" then 
  strWhere = " and CAR.num_carpeta="&num_carpeta&" "
  if busqueda_aprox = "1" then strWhere = " and CAR.num_carpeta like '%"&num_carpeta&"%' "
end if  
    
OpenConn
'on error resume next
set ObjDict_ORIGENES = Server.CreateObject("Scripting.Dictionary")
Cargar_Diccionario ObjDict_ORIGENES,"select id_origen value, n_origen text from tb_origenes order by value"
set ObjDict_TRANSPORTES = Server.CreateObject("Scripting.Dictionary")
Cargar_Diccionario ObjDict_TRANSPORTES,"select id_transporte value, n_transporte text from tb_transportes order by value"
set ObjDict_EMBARCADORES = Server.CreateObject("Scripting.Dictionary")
Cargar_Diccionario ObjDict_EMBARCADORES,"select id_embarcador value, n_embarcador text from tb_embarcadores order by value"


           '"rcp = (SELECT COUNT(NUMERO_DOCUMENTO_RESPALDO) " &_
  		     ''   "FROM DOCUMENTOS_NO_VALORIZADOS " &_
  		     ''   "WHERE EMPRESA='SYS' AND documento_no_valorizado='RCP' AND CONVERT(VARCHAR(6),FECHA_RECEPCION,112) = CONVERT(VARCHAR(6),anio_mes,112) AND CONVERT(VARCHAR(6),FECHA_EMISION,112) = CONVERT(VARCHAR(6),anio_mes,112) " &_
  		     ''   "AND Documento_respaldo = '"&documento_respaldo&"' " &_
  		     ''   "AND substring(Carpeta,11,2) = CAR.num_carpeta), " &_
           '"tcp = (SELECT COUNT(NUMERO_DOCUMENTO_RESPALDO) " &_
  		     ''   "FROM DOCUMENTOS_NO_VALORIZADOS " &_
  		     ''   "WHERE EMPRESA='SYS' AND documento_no_valorizado='TCP' AND CONVERT(VARCHAR(6),FECHA_RECEPCION,112) = CONVERT(VARCHAR(6),anio_mes,112) AND CONVERT(VARCHAR(6),FECHA_EMISION,112) = CONVERT(VARCHAR(6),anio_mes,112) " &_
  		     ''   "AND Documento_respaldo = '"&documento_respaldo&"' " &_
  		     ''   "AND substring(Carpeta,11,2) = CAR.num_carpeta) " &_		        
fec_anio_mes = anio & "/" & mes & "/1"
IF documento_respaldo = "TU" THEN
  strSQL = "select num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida, fecha_llegada, manifiesto, '' numero_documento_respaldo, tipo_moneda, IsNull(contenedor1,'') as contenedor1, IsNull(contenedor2,'') as contenedor2 " &_
           "from carpetas_final CAR where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
           "CAR.anio_mes = '"&fec_anio_mes&"' "&strWhere&" " &_
           "order by CAR.num_carpeta"
           
elseif   documento_respaldo = "R" then
  strSQL = "select num_carpeta, id_embarcador, id_transporte, id_origen, " &_
           "fecha_salida = isnull(fecha_salida,0), fecha_llegada = isnull(fecha_llegada,0), " &_
           "manifiesto, ' ' as numero_documento_respaldo, tipo_moneda, IsNull(contenedor1,'') as contenedor1, IsNull(contenedor2,'') as contenedor2 " &_
           "from carpetas_final CAR where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
           "CAR.anio_mes = '"&fec_anio_mes&"' " & strWhere   &_
           " order by CAR.num_carpeta"
           
ELSE
  strSQL ="select distinct num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida = isnull(fecha_salida,0), fecha_llegada, manifiesto, A.carpeta, " &_ 
	        "A.documento_respaldo, B.carpeta, B.documento_no_valorizado, B.numero_documento_respaldo, tipo_moneda, IsNull(contenedor1,'') as contenedor1, IsNull(contenedor2,'') as contenedor2 " &_
          "from " &_
          "(select num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida = isnull(fecha_salida,0), fecha_llegada,manifiesto, " &_
          "carpeta, documento_respaldo, tipo_moneda, contenedor1, contenedor2 " &_
          "from carpetas_final CAR " &_ 
          "where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
          "CAR.anio_mes = '"&fec_anio_mes&"' "&strWhere&" ) A," &_
          "(select distinct carpeta, documento_no_valorizado, numero_documento_respaldo  " &_
          "from documentos_no_valorizados DOV " &_
          "where empresa='SYS' and documento_no_valorizado in ('TCP','RCP')) B " &_
          "where A.carpeta *= B.carpeta " &_
          "order by Num_carpeta " 
           'response.write strSQL
           'response.end
END IF
 '"rcp =  (SELECT COUNT(NUMERO_DOCUMENTO_RESPALDO) " &_
  		     ''   "FROM DOCUMENTOS_NO_VALORIZADOS " &_
  		     ''   "WHERE EMPRESA='SYS' AND documento_no_valorizado='RCP' AND CONVERT(VARCHAR(6),FECHA_RECEPCION,112) = CONVERT(VARCHAR(6),anio_mes,112) AND CONVERT(VARCHAR(6),FECHA_EMISION,112) = CONVERT(VARCHAR(6),anio_mes,112) " &_
  		     ''   "AND Documento_respaldo = '"&documento_respaldo&"' " &_
  		     ''   "AND substring(Carpeta,10,2) = CAR.num_carpeta), " &_
           '"tcp = (SELECT COUNT(NUMERO_DOCUMENTO_RESPALDO) " &_
  		     ''   "FROM DOCUMENTOS_NO_VALORIZADOS " &_
  		     ''   "WHERE EMPRESA='SYS' AND documento_no_valorizado='TCP' AND CONVERT(VARCHAR(6),FECHA_RECEPCION,112) = CONVERT(VARCHAR(6),anio_mes,112) AND CONVERT(VARCHAR(6),FECHA_EMISION,112) = CONVERT(VARCHAR(6),anio_mes,112) " &_
  		     ''   "AND Documento_respaldo = '"&documento_respaldo&"' " &_
  		     ''   "AND substring(Carpeta,10,2) = CAR.num_carpeta) " &_           		        
  		     
'Response.Write strSQL
'Response.End
set rs = Conn.Execute(strSQL)

if not rs.EOF then
  width = 1140
  %>
  <table width="100%" align="center" cellpadding=0 cellspacing=0 border=0 bgcolor="#FFFFFF">
  <tr>
    <td>
    <div name="capaEncListaCarpeta" id="capaEncListaCarpeta" style="width: <%=width%>px; border-left: 1px solid #CCC; border-top: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto; overflow-x:hidden;">
    <table style="width:<%=width-19%>px;" border=0 cellpadding=0 cellspacing=0">
    <tr valign="top" height="16">
      <td style="width:50px;" id='grid_TH_1'>N°</td>
      <td style="width:80px; text-align:left;" id='grid_TH_1'>&nbsp;TRANSPORTE</td>
      <td style="width:120px; text-align:left;" id='grid_TH_1'>&nbsp;ORIGEN</td>
      <td style="width:120px;" id='grid_TH_1'>FECHA SALIDA</td>
      <td style="width:120px;" id='grid_TH_1'>FECHA LLEGADA</td>
      <td style="width:120px;" id='grid_TH_1'>MANIFIESTO</td>      
      <td id='grid_TH_1'>EMBARCADOR</td>
      <td style="width:60px;" id='grid_TH_1'>MON. ORI.</td>
      <td style="width:200px;" id='grid_TH_1'>N° CONTENEDOR(ES)</td>
      <td style="width:80px;" id='grid_TH_1'>N° <%=documento_respaldo%></td>
    </tr>
    </table>
    </div>
    <div align="left" name="capaListaCarpeta" onscroll="capaEncListaCarpeta.scrollLeft=this.scrollLeft;" 
    style="width:<%=width%>; height: 550px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto;">
    <table style="width:<%=width-19%>px;" cellpadding=0 cellspacing=0 border=0>
    <%
    fila = 0
    color_de_fondo = "grid_TD_1"
    do while not rs.EOF
      if documento_respaldo = "Z" then
        color_de_fondo = "grid_TH_2"
        if rs("documento_no_valorizado") <> "TCP" then color_de_fondo = "grid_TD_1"
      end if
      num_carpeta = rs("num_carpeta")
      str_contenedor = ""
      if trim(rs("contenedor1")) <> "" then str_contenedor = trim(rs("contenedor1"))
      if trim(rs("contenedor2")) <> "" then 
        if str_contenedor <> "" then str_contenedor = str_contenedor & " / "
        str_contenedor = str_contenedor & trim(rs("contenedor2"))
      end if
    %>
    <tr 
    OnClick="Cargar_Form_Ingresar('<%=rs("num_carpeta")%>')"
    OnMouseOver="SetColor(this,'#EEEEEE','');this.style.cursor='pointer'" OnMouseOut="SetColor(this,'','')"  
    align="center" align="center" id=<%=color_de_fondo%>  name="tr_carpetas_<%=fila%>">
      <td style="width:50px;" id="grid_TD_1"><%=rs("num_carpeta")%></td>
      <td style="width:80px;" id="grid_TD_1" align="left">&nbsp;<%=ObjDict_TRANSPORTES.Item(trim(rs("id_transporte")))%></td>
      <td style="width:120px;" id="grid_TD_1" align="left">&nbsp;<%=ObjDict_ORIGENES.Item(trim(rs("id_origen")))%></td>
      <td style="width:120px;" id="grid_TD_1"><%=rs("fecha_salida")%>&nbsp;</td>
      <td style="width:120px;" id="grid_TD_1"><%=rs("fecha_llegada")%>&nbsp;</td>
      <td style="width:120px;" id="grid_TD_1"><%=rs("manifiesto")%>&nbsp;</td>
      <td id="grid_TD_1" align="left"><%=ObjDict_EMBARCADORES.Item(trim(rs("id_embarcador")))%>&nbsp;</td>
      <td style="width:60px;" id="grid_TD_1" align="center">&nbsp;<%=trim(rs("tipo_moneda"))%></td>
      <td style="width:200px;" id="grid_TD_1" align="center">&nbsp;<%=str_contenedor%></td>
      <td style="width:80px;" id="grid_TD_1" align="center">&nbsp;<%=trim(rs("numero_documento_respaldo"))%></td>
    </tr>
    <%fila = fila + 1
      rs.MoveNext
    loop%>
    </table>
    </div>
    </td>
  </tr>
  </table>
<%end if%>
