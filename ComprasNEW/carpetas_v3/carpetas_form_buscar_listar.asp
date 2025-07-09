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
  strSQL = "select num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida, fecha_llegada, fecha_recepcion, manifiesto, numero_documento_respaldo = Numero_aduana, Fecha_aduana = 0, NDP " &_
           "from carpetas_final CAR where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
           "CAR.anio_mes = '"&fec_anio_mes&"' "&strWhere&" " &_
           "order by CAR.num_carpeta"
           
  'strSQL = "select num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida, fecha_llegada, fecha_recepcion, manifiesto, '' numero_documento_respaldo " &_
  '         "from carpetas_final CAR where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
  '         "CAR.anio_mes = '"&fec_anio_mes&"' "&strWhere&" " &_
  '         "order by CAR.num_carpeta"
elseif   documento_respaldo = "R" then
  strSQL = "select num_carpeta, id_embarcador, id_transporte, id_origen, " &_
           "fecha_salida = isnull(fecha_salida,0), fecha_llegada = isnull(fecha_llegada,0), " &_
           "manifiesto, numero_documento_respaldo = Numero_aduana, fecha_recepcion = isnull(fecha_recepcion,0), Fecha_aduana = 0, NDP " &_
           "from carpetas_final CAR where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
           "CAR.anio_mes = '"&fec_anio_mes&"' " & strWhere   &_
           " order by CAR.num_carpeta"
           
  'strSQL = "select num_carpeta, id_embarcador, id_transporte, id_origen, " &_
  '         "fecha_salida = isnull(fecha_salida,0), fecha_llegada = isnull(fecha_llegada,0), " &_
  '         "manifiesto, ' ' as numero_documento_respaldo, fecha_recepcion = isnull(fecha_recepcion,0) " &_
  '         "from carpetas_final CAR where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
  '         "CAR.anio_mes = '"&fec_anio_mes&"' " & strWhere   &_
  '         " order by CAR.num_carpeta"
ELSE
  strSQL ="select distinct num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida = isnull(fecha_salida,0), fecha_llegada, manifiesto, A.carpeta, " &_ 
          "A.documento_respaldo, B.carpeta, B.documento_no_valorizado, fecha_recepcion = isnull(fecha_recepcion,0), fecha_aduana = isnull(fecha_aduana,0)," &_
          "numero_documento_respaldo = A.Numero_aduana, A.NDP " &_
          "from " &_
          "(select num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida = isnull(fecha_salida,0), fecha_llegada,manifiesto, carpeta, documento_respaldo, fecha_recepcion = isnull(fecha_recepcion,0), Numero_aduana, fecha_aduana = isnull(fecha_aduana,0), NDP " &_
          "from carpetas_final CAR " &_ 
          "where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
          "CAR.anio_mes = '"&fec_anio_mes&"' "&strWhere&" ) A left join " &_
          "(select distinct carpeta, documento_no_valorizado, numero_documento_respaldo  " &_
          "from documentos_no_valorizados DOV with  (nolock index= IX_Empresa_DNV_Carpeta_FechaEmision) " &_
          "where empresa='SYS' and documento_no_valorizado in ('TCP','RCP')) B on  A.carpeta = B.carpeta  " &_
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
  width = 1120
  %>
  <table width="100%" align="center" cellpadding=0 cellspacing=0 border=0 bgcolor="#FFFFFF">
  <tr>
    <td>
    <!-- <div name="capaEncListaCarpeta" id="capaEncListaCarpeta" style="width: <%=width%>px; border-left: 1px solid #CCC; border-top: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto; overflow-x:hidden;"> -->
    <div name="capaEncListaCarpeta" id="capaEncListaCarpeta" style="width: 90%; border-left: 1px solid #CCC; border-top: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto; overflow-x:hidden;">
    <table style="width:<%=width-19%>px;" border=0 cellpadding=0 cellspacing=0">
    <tr valign="top" height="16">
      <td style="width:60px;" id='grid_TH_1'>N°</td>
      <td style="width:100px; text-align:left;" id='grid_TH_1'>&nbsp;TRANSPORTE</td>
      <td style="width:120px; text-align:left;" id='grid_TH_1'>&nbsp;ORIGEN</td>
      <td style="width:120px;" id='grid_TH_1'>FECHA SALIDA</td>
      <td style="width:120px;" id='grid_TH_1'>FECHA LLEGADA</td>
      <% if documento_respaldo = "Z" then %>
      <td style="width:120px;" id='grid_TH_1'>FECHA ADUANA</td>
      <% end if %>
      <td style="width:120px;" id='grid_TH_1'>FECHA RECEPC.</td>
      <td style="width:120px;" id='grid_TH_1'>MANIFIESTO</td>      
      <td style="width:120px;" id='grid_TH_1'>NDP</td>      
      <td id='grid_TH_1'>EMBARCADOR</td>
      <td style="width:80px;" id='grid_TH_1'>N° <%=documento_respaldo%></td>
    </tr>
    </table>
    </div>
    <!-- <div align="left" name="capaListaCarpeta" onscroll="capaEncListaCarpeta.scrollLeft=this.scrollLeft;" style='width:<%=width%>; height: 682px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto;'> -->
    <div align="left" name="capaListaCarpeta" onscroll="capaEncListaCarpeta.scrollLeft=this.scrollLeft;" style="width: 100%; height: 550px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto;">
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
      Manifiesto = rs("manifiesto")
      NDP = rs("NDP")

      Fecha_salida = rs("Fecha_salida")
      if isNull(Fecha_salida) or Fecha_salida = 0 or Fecha_salida = "01/01/1900" then
            Fecha_salida = ""
      end if
      Fecha_llegada = rs("Fecha_llegada")
      if isNull(Fecha_llegada) or Fecha_llegada = 0 or Fecha_llegada = "01/01/1900" then
            Fecha_llegada = ""
      end if
      Fecha_aduana = rs("Fecha_aduana")
      if isNull(Fecha_aduana) or Fecha_aduana = 0 or Fecha_aduana = "01/01/1900" then
            Fecha_aduana = ""
      end if
      Fecha_recepcion = rs("Fecha_recepcion")
      if isNull(Fecha_recepcion) or Fecha_recepcion = 0 or Fecha_recepcion = "01/01/1900" then
            Fecha_recepcion = ""
      end if

      IF ucase ( NDP ) = "NULA" THEN %>
        <tr 
        align="center" align="center" id=<%=color_de_fondo%>  name="tr_carpetas_<%=fila%>">
          <td style="width:60px;" id="grid_TD_1"><%=rs("num_carpeta")%></td>
          <td colspan ='8' align='center'><%=rs("manifiesto")%>&nbsp;</td>
        </tr>
      <%
      ELSE
    %>
    <tr 
    OnClick="Cargar_Form_Ingresar('<%=rs("num_carpeta")%>', '<% = rs("numero_documento_respaldo") %>')"
    OnMouseOver="SetColor(this,'#EEEEEE','');this.style.cursor='pointer'" OnMouseOut="SetColor(this,'','')"  
    align="center" align="center" id=<%=color_de_fondo%>  name="tr_carpetas_<%=fila%>">
      <td style="width:60px;" id="grid_TD_1"><%=rs("num_carpeta")%></td>
      <td style="width:100px;" id="grid_TD_1" align="left">&nbsp;<%=ObjDict_TRANSPORTES.Item(trim(rs("id_transporte")))%></td>
      <td style="width:120px;" id="grid_TD_1" align="left">&nbsp;<%=ObjDict_ORIGENES.Item(trim(rs("id_origen")))%></td>
      <td style="width:120px;" id="grid_TD_1"><% = Fecha_salida %>&nbsp;</td>
      <td style="width:120px;" id="grid_TD_1"><% = Fecha_llegada %>&nbsp;</td>
      <% if documento_respaldo = "Z" then %>
      <td style="width:120px;" id="grid_TD_1"><% = Fecha_aduana %>&nbsp;</td>
      <% end if %>
      <td style="width:120px;" id="grid_TD_1"><% = Fecha_recepcion %>&nbsp;</td>
      <td style="width:120px;" id="grid_TD_1"><%=rs("manifiesto")%>&nbsp;</td>
      <td style="width:120px;" id="grid_TD_1"><%=rs("NDP")%>&nbsp;</td>
      <td id="grid_TD_1" align="left"><%=ObjDict_EMBARCADORES.Item(trim(rs("id_embarcador")))%>&nbsp;</td>
      <td style="width:80px;" id="grid_TD_1" align="center">&nbsp;<%=trim(rs("numero_documento_respaldo"))%></td>
    </tr>
    <%END IF
        fila = fila + 1
      rs.MoveNext
    loop%>
    </table>
    </div>
    </td>
  </tr>
  </table>
<%end if%>
