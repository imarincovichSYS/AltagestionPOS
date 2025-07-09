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
  strWhere = " and replace(right(dov.Carpeta,PATINDEX('%-%',dov.Carpeta)),'-','')="&num_carpeta&" "
  if busqueda_aprox = "1" then strWhere = " and replace(right(dov.Carpeta,PATINDEX('%-%',dov.Carpeta)),'-','') like '%"&num_carpeta&"%' "
end if  
    
OpenConn
'on error resume next
set ObjDict_ORIGENES = Server.CreateObject("Scripting.Dictionary")
Cargar_Diccionario ObjDict_ORIGENES,"select id_origen value, n_origen text from tb_origenes order by value"
set ObjDict_TRANSPORTES = Server.CreateObject("Scripting.Dictionary")
Cargar_Diccionario ObjDict_TRANSPORTES,"select id_transporte value, n_transporte text from tb_transportes order by value"
set ObjDict_EMBARCADORES = Server.CreateObject("Scripting.Dictionary")
Cargar_Diccionario ObjDict_EMBARCADORES,"select id_embarcador value, n_embarcador text from tb_embarcadores order by value"

	            
fec_anio_mes = anio & "/" & mes & "/1"
str_count_carpetas = "select count (distinct (dov.carpeta)) as cant_carpetas from documentos_no_valorizados dov " &_
                     "where dov.empresa='SYS' and dov.documento_no_valorizado in ('TCP','RCP') and convert(varchar(6),dov.Fecha_recepcion,112) = '" & anio & right("0"+mes,2) &"'" &_
	                   " and dov.documento_respaldo='"&documento_respaldo&"' " & strWhere
set rs_count_carpetas = Conn.Execute(str_count_carpetas)

str_carpetas = "select distinct dov.carpeta as carpeta, num_carpeta, anio_mes , fecha_salida = convert(varchar(8),fecha_salida,5), fecha_llegada= convert(varchar(8),fecha_llegada,5), manifiesto " &_
               "from documentos_no_valorizados dov, carpetas_final c " &_ 
               "where dov.carpeta = c.carpeta " &_
	             "and empresa='SYS' and documento_no_valorizado in ('TCP','RCP') and " &_ 
               "convert(varchar(6),Fecha_recepcion,112) =  '" & anio & right("0"+mes,2) &"' and dov.documento_respaldo='"&documento_respaldo&"' " & strWhere &_
               " order by anio_mes,num_carpeta"
            
set rs_carpetas = Conn.Execute(str_carpetas)
	
i=0
if not rs_count_carpetas.EOF then
      width = "120"  %>
      <%do while i < rs_count_carpetas("cant_carpetas") %>
      <table align="Left" cellpadding=0 cellspacing=0 border=0 >
        <td>

          <div name="capaEncListaCarpeta" id="capaEncListaCarpeta" style="width: <%=width-18%>px; border-left: 1px solid #CCC; border-top: 1px solid #CCC; border-right: 1px solid #CCC; overflow: auto; overflow-x:hidden;">          
            <table style="width:<%=width-18%>px;" border=0 cellpadding=0 cellspacing=0">
              <tr valign="top" height="15">
                <td style="width:100px;" id='grid_TH_3' colspan=2><%=rs_carpetas("carpeta")%></td>
              </tr>            
          </div>            
              <tr  height="18">
                <td style="width:60px;" id='grid_TD_1'><%="Manif."%></td>
                <td style="width:60px;" id='grid_TD_1'><%=rs_carpetas("manifiesto")%></td>
              </tr>

              <tr height="15">
                <td style="width:60px;" id='grid_TH_3'><%="F. Sal."%></td>
                <td style="width:60px;" id='grid_TH_3'><%="F. Lle."%></td>
              </tr>

              <tr valign="top" height="30">
                <td style="width:60px;" id='grid_TD_1'><%=left(ltrim(rtrim(rs_carpetas("fecha_salida"))),5)%></td>
                <td style="width:60px;" id='grid_TD_1'><%=left(ltrim(rtrim(rs_carpetas("fecha_llegada"))),5)%></td>
              </tr>

              <tr valign="top" height="15">
                <td style="width:50px;" id='grid_TH_3'><%="Doc."%></td>
                <td style="width:70px;" id='grid_TH_3'><%="Prov."%></td>
              </tr>

              <tr height="15">
              <%
              strSQL =  "Select Numero_documento_respaldo, Codigo_postal, documento_no_valorizado from DOCUMENTOS_NO_VALORIZADOS dnv, entidades_comerciales ent " &_
                        "where  dnv.proveedor = ent.entidad_comercial and dnv.empresa='SYS' and documento_no_valorizado in ('TCP','RCP') and convert(varchar(6),Fecha_recepcion,112) = '" & anio & right("0"+mes,2) &"' " &_ 
	                      "and documento_respaldo='"&documento_respaldo&"' " &_
	                      " and carpeta='" & rs_carpetas("carpeta") & "' ORDER BY Codigo_postal, Numero_documento_respaldo"
	                      set rs = Conn.Execute(strSQL)
              fila = 0
              do while not rs.EOF%>
                <%if  rs("documento_no_valorizado") = "RCP" then%>
                  <td style="width:50px;" id="grid_TD_1"><%=rs("numero_documento_respaldo")%></td>
                  <td style="width:70px;" id="grid_TD_1"><%=ltrim(rtrim(rs("Codigo_postal")))%>&nbsp;</td>
                <%else%>
                  <td style="width:50px;" id="grid_TH_2"><%=rs("numero_documento_respaldo")%></td>
                  <td style="width:70px;" id="grid_TH_2"><%=ltrim(rtrim(rs("Codigo_postal")))%>&nbsp;</td>                  
                <%end if%>
              </tr>    
              <%fila = fila + 1
                rs.MoveNext                
              loop%>
            </table>  
            
            <table style="width:<%=width-18%>px;" border=0 cellpadding=0 cellspacing=0">
              <tr valign="top" height="30">
                <td style="width:100px;" id='grid_TD_1' colspan=1><%="Cant. Docs = " & fila%></td>                
              </tr>
            </table>
                    
        </td>

      </table>
            <%i=i+1 
            rs_carpetas.MoveNext
            loop%>      
<%end if%>
