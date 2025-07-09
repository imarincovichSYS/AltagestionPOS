<%@ Language=VBScript %>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

busqueda_aprox      = Request.Form("busqueda_aprox")
documento_respaldo  = Request.Form("documento_respaldo")
mes                 = Request.Form("mes")
anio                = Request.Form("anio")
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
  strSQL = "select num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida, fecha_llegada,manifiesto " &_
           "from carpetas_final CAR where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
           "CAR.anio_mes = '"&fec_anio_mes&"' "&strWhere&" " &_
           "order by CAR.num_carpeta"
           
elseif   documento_respaldo = "R" then
  strSQL = "select num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida = isnull(fecha_salida,0), fecha_llegada,manifiesto " &_
           "from carpetas_final CAR where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
           "CAR.anio_mes = '"&fec_anio_mes&"' " & strWhere   &_
           " order by CAR.num_carpeta"
           
ELSE
  strSQL ="select num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida = isnull(fecha_salida,0), fecha_llegada,manifiesto, A.carpeta, " &_ 
	        "A.documento_respaldo, B.carpeta, B.documento_no_valorizado " &_
          "from " &_
          "(select num_carpeta, id_embarcador, id_transporte, id_origen, fecha_salida = isnull(fecha_salida,0), fecha_llegada,manifiesto, carpeta, documento_respaldo " &_
          "from carpetas_final CAR " &_ 
          "where CAR.documento_respaldo='"&documento_respaldo&"' and " &_
          "CAR.anio_mes = '"&fec_anio_mes&"' "&strWhere&" ) A," &_
          "(select carpeta, documento_no_valorizado " &_
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
  width = "900"
  %>
  <table width="100%" align="center" cellpadding=0 cellspacing=0 border=0>
  <tr>
    <td>
    <div name="capaEncListaCarpeta" id="capaEncListaCarpeta" style="width: <%=width%>px; border-left: 1px solid #CCC; border-top: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto; overflow-x:hidden;">
    <table style="width:<%=width-19%>px;" border=0 cellpadding=0 cellspacing=0">
    <tr valign="top" height="16">
      <td style="width:25px;" id='grid_TH_1'>&nbsp;</td>
      <td style="width:60px;" id='grid_TH_1'>N°</td>
      <td style="width:100px;" id='grid_TH_1'>TRANSPORTE</td>
      <td style="width:120px;" id='grid_TH_1'>ORIGEN</td>
      <td style="width:120px;" id='grid_TH_1'>FECHA SALIDA</td>
      <td style="width:120px;" id='grid_TH_1'>FECHA LLEGADA</td>
      <td style="width:120px;" id='grid_TH_1'>MANIFIESTO</td>      
      <td id='grid_TH_1'>EMBARCADOR</td>
    </tr>
    </table>
    </div>
    <div align="left" name="capaListaCarpeta" onscroll="capaEncListaCarpeta.scrollLeft=this.scrollLeft;" 
    style="width:<%=width%>; height: 438px; border-left: 1px solid #CCC; border-bottom: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto;">
    <table style="width:<%=width-19%>px;" cellpadding=0 cellspacing=0 border=0>
    <%
    fila = 0
    color_de_fondo = "grid_TD_1"
    do while not rs.EOF
    if documento_respaldo = "Z" then
      if rs("documento_no_valorizado")="TCP" then
          color_de_fondo = "grid_TH_2"
      else
          color_de_fondo = "grid_TD_1"
      end if
    end if
    %>
    <tr 
    OnDblClick="Editar_Carpeta()"
    Onclick="SetChecked_Radio(document.getElementsByName('radio_carpetas'),<%=fila%>);"
    OnMouseOver="SetColor(this,'#E2EDFC','');this.style.cursor='pointer'" OnMouseOut="SetColor(this,'','')"  
    align="center" align="center" id=<%=color_de_fondo%>  name="tr_carpetas_<%=fila%>">
      <td style="width:25px;" id="grid_TD_1"><input 
      documento_respaldo  = "<%=documento_respaldo%>"
      anio                = "<%=anio%>" 
      mes                 = "<%=mes%>" 
      num_carpeta         = "<%=rs("num_carpeta")%>" 
      id_embarcador       = "<%=rs("id_embarcador")%>"
      id_origen           = "<%=rs("id_origen")%>"
      id_transporte       = "<%=rs("id_transporte")%>"
      fecha_salida        = "<%=rs("fecha_salida")%>"
      fecha_llegada       = "<%=rs("fecha_llegada")%>"
      manifiesto          = "<%=rs("manifiesto")%>"      
      class="grid_RADIOBOX" name="radio_carpetas" type="radio"></input></td>
      <td style="width:60px;" id="grid_TD_1"><%=rs("num_carpeta")%></td>
      <td style="width:100px;" id="grid_TD_1" align="left"><%=ObjDict_TRANSPORTES.Item(trim(rs("id_transporte")))%>&nbsp;</td>
      <td style="width:120px;" id="grid_TD_1" align="left"><%=ObjDict_ORIGENES.Item(trim(rs("id_origen")))%>&nbsp;</td>
      <td style="width:120px;" id="grid_TD_1"><%=rs("fecha_salida")%>&nbsp;</td>
      <td style="width:120px;" id="grid_TD_1"><%=rs("fecha_llegada")%>&nbsp;</td>
      <td style="width:120px;" id="grid_TD_1"><%=rs("manifiesto")%>&nbsp;</td>
      <%
        'srt_carpeta="Select Numero_documento_respaldo, Codigo_postal from DOCUMENTOS_NO_VALORIZADOS dnv, entidades_comerciales ent " &_ 
        ''            "where dnv.proveedor = ent.entidad_comercial and dnv.empresa='SYS' and documento_no_valorizado='RCP' and " &_
        ''            "carpeta = '" & documento_respaldo & "-" & anio & "-" & mes & "-" & rs("num_carpeta") & "'" &_
        ''            "order by Numero_documento_respaldo"     
        'set rs_carpeta = Conn.Execute(srt_carpeta)
      %>
      <!--<td style="width:111px;" id="grid_TD_1" >-->
        <!--<select id="grid_TD_1" style="width:110px;">-->
          <%'do while not rs_carpeta.EOF%>
            <!--<option value="1"> <%'=rs_carpeta("Numero_documento_respaldo") & " - " & rs_carpeta("Codigo_postal")%></option>--> 
          <%'rs_carpeta.MoveNext
          'loop%>           
        <!--</select>-->
      <!--</td>-->
  
      <!--<td style="width:80px;" id="grid_TD_1"><%'=rs("TCP")%>&nbsp;</td>-->
                 
      <%
        'srt_carpeta_tcp="Select Numero_documento_respaldo, Codigo_postal from DOCUMENTOS_NO_VALORIZADOS dnv, entidades_comerciales ent " &_ 
        ''            "where dnv.proveedor = ent.entidad_comercial and dnv.empresa='SYS' and documento_no_valorizado='TCP' and " &_
        ''            "carpeta = '" & documento_respaldo & "-" & anio & "-" & mes & "-" & rs("num_carpeta") & "'" &_
        ''            "order by Numero_documento_respaldo"      
        'set rs_carpeta_tcp = Conn.Execute(srt_carpeta_tcp)
      %>
      <!--<td style="width:111px;" id="grid_TD_1">-->
        <!--<select id="grid_TD_1" style="width:110px;">-->
          <%'do while not rs_carpeta_tcp.EOF%>
            <!--<option value="1"> <%'=rs_carpeta_tcp("Numero_documento_respaldo")& " - " & rs_carpeta_tcp("Codigo_postal")%></option>--> 
          <%'rs_carpeta_tcp.MoveNext
          'loop%>           
        <!--</select>-->
      <!--</td>-->           
      <td id="grid_TD_1" align="left"><%=ObjDict_EMBARCADORES.Item(trim(rs("id_embarcador")))%>&nbsp;</td>
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
