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

pend                = Request.Form("pend")
'response.write year(date)-1 & right("0" & month(date),2)
'response.end 
'documento_respaldo  = "R"
'mes                 = "7"
'anio                = "2011"
 strWhere = " "
if num_carpeta <> "" then strWhere = " and replace(right(Carpeta,PATINDEX('%-%',Carpeta)),'-','')="&num_carpeta
if pend = "true" then 
  if documento_respaldo = "R" then
    strWhere = strWhere & " and carpeta in (select carpeta 	from documentos_no_valorizados where empresa='SYS' and documento_no_valorizado='TCP' " &_
                          " and (documento_respaldo ='R' or documento_respaldo ='DS') )"
  else
    strWhere = strWhere & " and carpeta in (select carpeta 	from documentos_no_valorizados where empresa='SYS' and documento_no_valorizado='TCP' and documento_respaldo ='" & documento_respaldo & "')"
  end if
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
if pend <> "true" then
  str_count_carpetas = "select count(*) as cant_carpetas from carpetas_final  " &_
                       "where convert(varchar(6),anio_mes,112) = '" & anio & right("0"+mes,2) & "' " &_
  	                   "and documento_respaldo='"&documento_respaldo&"' " & strWhere	                  
  set rs_count_carpetas = Conn.Execute(str_count_carpetas)
  
  if documento_respaldo = "R" then
    str_carpetas = "select carpeta, num_carpeta, anio_mes , fecha_salida = convert(varchar(8),fecha_salida,5), fecha_llegada= convert(varchar(8),fecha_llegada,5), manifiesto " &_
                   "from carpetas_final c " &_ 
                   "where convert(varchar(6),anio_mes,112) =  '" & anio & right("0"+mes,2) &"' and (documento_respaldo='R' or documento_respaldo='DS')  " & strWhere &_
                   " order by anio_mes,num_carpeta"
  else
    str_carpetas = "select carpeta, num_carpeta, anio_mes , fecha_salida = convert(varchar(8),fecha_salida,5), fecha_llegada= convert(varchar(8),fecha_llegada,5), manifiesto " &_
                   "from carpetas_final c " &_ 
                   "where convert(varchar(6),anio_mes,112) =  '" & anio & right("0"+mes,2) &"' and documento_respaldo='"&documento_respaldo&"' " & strWhere &_
                   " order by anio_mes,num_carpeta"
  end if
  set rs_carpetas = Conn.Execute(str_carpetas)
else
  if documento_respaldo = "R" then
    str_count_carpetas = "select count(*) as cant_carpetas from carpetas_final  " &_
                         "where convert(varchar(6),anio_mes,112) >= '" & year(date)-1 & right("0" & month(date),2) & "' " &_
    	                   "and (documento_respaldo='R' or documento_respaldo='DS') " & strWhere	                  
  else
    str_count_carpetas = "select count(*) as cant_carpetas from carpetas_final  " &_
                         "where convert(varchar(6),anio_mes,112) >= '" & year(date)-1 & right("0" & month(date),2) & "' " &_
    	                   "and documento_respaldo='"&documento_respaldo&"' " & strWhere	                  
  end if
  set rs_count_carpetas = Conn.Execute(str_count_carpetas)
  
  if documento_respaldo = "R" then
    str_carpetas = "select carpeta, num_carpeta, anio_mes , fecha_salida = convert(varchar(8),fecha_salida,5), fecha_llegada= convert(varchar(8),fecha_llegada,5), manifiesto " &_
                   "from carpetas_final c " &_ 
                   "where convert(varchar(6),anio_mes,112) >=  '" & year(date)-1 & right("0" & month(date),2) &"' and " &_
                   "(documento_respaldo='R' or documento_respaldo='DS') " & strWhere &_
                   " order by anio_mes,num_carpeta"
  else
    str_carpetas = "select carpeta, num_carpeta, anio_mes , fecha_salida = convert(varchar(8),fecha_salida,5), fecha_llegada= convert(varchar(8),fecha_llegada,5), manifiesto " &_
                 "from carpetas_final c " &_ 
                 "where convert(varchar(6),anio_mes,112) >=  '" & year(date)-1 & right("0" & month(date),2) &"' and documento_respaldo='"&documento_respaldo&"' " & strWhere &_
                 " order by anio_mes,num_carpeta"
  end if
  set rs_carpetas = Conn.Execute(str_carpetas)
end if 
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
              <%
              v_carpeta = rs_carpetas("carpeta")
              if pend <> "true" then
                if documento_respaldo = "R" then
                  strSQL =  "Select Numero_documento_respaldo, Codigo_postal, documento_no_valorizado, Fecha_recepcion, fecha_emision, entidad_comercial, " &_
                            "paridad_conversion_a_dolar paridad, isnull(monto_neto_us$,0) total_cif_ori, isnull(monto_adu_us$,0) total_cif_adu, Apellidos_persona_o_nombre_empresa nombre_proveedor, " &_
                          	
                            "prov_mop = (select top 1 Codigo_postal from movimientos_productos mop, entidades_comerciales ent " &_ 
		                        "where mop.empresa='SYS' and documento_no_valorizado in ('TCP','RCP')   " &_
		                        "and mop.Fecha_movimiento= dnv.Fecha_recepcion " &_
		                        "and mop.numero_documento_de_compra = dnv.Numero_documento_respaldo " &_
		                        "and mop.proveedor = ent.entidad_comercial) " &_
		
                            "from DOCUMENTOS_NO_VALORIZADOS dnv, entidades_comerciales ent " &_                          
                            "where  dnv.proveedor = ent.entidad_comercial and dnv.empresa='SYS' and documento_no_valorizado in ('TCP','RCP') and case when Fecha_recepcion is not Null then convert(varchar(4),Fecha_recepcion,112) else convert(varchar(4), ( select Fecha_llegada from carpetas_final carp (nolock) where carp.Carpeta = dnv.Carpeta ) ,112) end = '" & anio  &"' " &_ 
  	                        "and (documento_respaldo='R' or documento_respaldo='DS') " &_
  	                        " and carpeta='" & rs_carpetas("carpeta") & "' ORDER BY Codigo_postal, Numero_documento_respaldo"
                else
                  strSQL =  "Select Numero_documento_respaldo, Codigo_postal, documento_no_valorizado, Fecha_recepcion, fecha_emision, entidad_comercial, " &_
                            "paridad_conversion_a_dolar paridad, isnull(monto_neto_us$,0) total_cif_ori, isnull(monto_adu_us$,0) total_cif_adu, Apellidos_persona_o_nombre_empresa nombre_proveedor, " &_
                          	
                            "prov_mop = (select top 1 Codigo_postal from movimientos_productos mop, entidades_comerciales ent " &_ 
		                        "where mop.empresa='SYS' and documento_no_valorizado in ('TCP','RCP')   " &_
		                        "and mop.Fecha_movimiento= dnv.Fecha_recepcion " &_
		                        "and mop.numero_documento_de_compra = dnv.Numero_documento_respaldo " &_
		                        "and mop.proveedor = ent.entidad_comercial) " &_
		
                            "from DOCUMENTOS_NO_VALORIZADOS dnv, entidades_comerciales ent " &_
                            "where  dnv.proveedor = ent.entidad_comercial and dnv.empresa='SYS' and documento_no_valorizado in ('TCP','RCP') and case when Fecha_recepcion is not Null then convert(varchar(4),Fecha_recepcion,112) else convert(varchar(4), ( select Fecha_llegada from carpetas_final carp (nolock) where carp.Carpeta = dnv.Carpeta ) ,112) end = '" & anio  &"' " &_ 
  	                        "and documento_respaldo='"&documento_respaldo&"' " &_
  	                        " and carpeta='" & rs_carpetas("carpeta") & "' ORDER BY Codigo_postal, Numero_documento_respaldo"
                end if
  	                      set rs = Conn.Execute(strSQL)
  	          else
  	            if documento_respaldo = "R" then
                  strSQL =  "Select Numero_documento_respaldo, Codigo_postal, documento_no_valorizado, Fecha_recepcion, fecha_emision, entidad_comercial, " &_
                            "paridad_conversion_a_dolar paridad, isnull(monto_neto_us$,0) total_cif_ori, isnull(monto_adu_us$,0) total_cif_adu, Apellidos_persona_o_nombre_empresa nombre_proveedor, " &_

                            "prov_mop = (select top 1 Codigo_postal from movimientos_productos mop, entidades_comerciales ent " &_ 
		                        "where mop.empresa='SYS' and documento_no_valorizado in ('TCP','RCP')   " &_
		                        "and mop.Fecha_movimiento= dnv.Fecha_recepcion " &_
		                        "and mop.numero_documento_de_compra = dnv.Numero_documento_respaldo " &_
		                        "and mop.proveedor = ent.entidad_comercial) " &_

                            "from DOCUMENTOS_NO_VALORIZADOS dnv, entidades_comerciales ent " &_
                            "where  dnv.proveedor = ent.entidad_comercial and dnv.empresa='SYS' and documento_no_valorizado in ('TCP','RCP') and case when Fecha_recepcion is not Null then convert(varchar(4),Fecha_recepcion,112) else convert(varchar(4), ( select Fecha_llegada from carpetas_final carp (nolock) where carp.Carpeta = dnv.Carpeta ) ,112) end >= '" & anio-1  &"' " &_ 
  	                        "and (documento_respaldo='R' or documento_respaldo='DS') " &_
  	                        " and carpeta='" & rs_carpetas("carpeta") & "' ORDER BY Codigo_postal, Numero_documento_respaldo"
                  else
                    strSQL =  "Select Numero_documento_respaldo, Codigo_postal, documento_no_valorizado, Fecha_recepcion, fecha_emision, entidad_comercial, " &_
                            "paridad_conversion_a_dolar paridad, isnull(monto_neto_us$,0) total_cif_ori, isnull(monto_adu_us$,0) total_cif_adu, Apellidos_persona_o_nombre_empresa nombre_proveedor, " &_

                            "prov_mop = (select top 1 Codigo_postal from movimientos_productos mop, entidades_comerciales ent " &_ 
		                        "where mop.empresa='SYS' and documento_no_valorizado in ('TCP','RCP')   " &_
		                        "and mop.Fecha_movimiento= dnv.Fecha_recepcion " &_
		                        "and mop.numero_documento_de_compra = dnv.Numero_documento_respaldo " &_
		                        "and mop.proveedor = ent.entidad_comercial) " &_

                            "from DOCUMENTOS_NO_VALORIZADOS dnv, entidades_comerciales ent " &_
                            "where  dnv.proveedor = ent.entidad_comercial and dnv.empresa='SYS' and documento_no_valorizado in ('TCP','RCP') and case when Fecha_recepcion is not Null then convert(varchar(4),Fecha_recepcion,112) else convert(varchar(4), ( select Fecha_llegada from carpetas_final carp (nolock) where carp.Carpeta = dnv.Carpeta ) ,112) end >= '" & anio-1  &"' " &_ 
  	                        "and documento_respaldo='"&documento_respaldo&"' " &_
  	                        " and carpeta='" & rs_carpetas("carpeta") & "' ORDER BY Codigo_postal, Numero_documento_respaldo"
                  end if
  	                      set rs = Conn.Execute(strSQL) 
              end if 	          
              fila = 0
              do while not rs.EOF                
              %>
              <tr height="15" OnDblClick="Generar_Informe('<%=rs("Numero_documento_respaldo")%>','<%=rs("documento_no_valorizado")%>','<%=documento_respaldo%>','<%=rs("Fecha_recepcion")%>','<%=rs("entidad_comercial")%>','<%=rs("nombre_proveedor")%>','<%=rs("fecha_emision")%>','<%=rs("paridad")%>','<%=rs("total_cif_ori")%>','<%=rs("total_cif_adu")%>','<%=v_carpeta%>')">
                <%if  rs("documento_no_valorizado") = "RCP" then%>
                  <td style="width:50px;" id="grid_TD_1"><%=rs("numero_documento_respaldo")%></td>
                  <td style="width:70px;" id="grid_TD_1"><%=ltrim(rtrim(rs("prov_mop")))%>&nbsp;</td>
                <%else%>
                  <td style="width:50px;" id="grid_TH_2"><%=rs("numero_documento_respaldo")%></td>
                  <td style="width:70px;" id="grid_TH_2"><%=ltrim(rtrim(rs("prov_mop")))%>&nbsp;</td>                  
                <%end if%>
              </tr>    
              <%
              if documento_respaldo = "R" then
	        strSQL="Select P.Superfamilia , sum(Cantidad_entrada * Costo_CIF_ADU_US$) as total_rubro " &_ 
					"from movimientos_productos MOP inner join Productos P on P.Producto = MOP.producto where MOP.empresa='SYS' " &_
                    "and documento_no_valorizado='TCP' and (tipo_documento_de_compra='R' or tipo_documento_de_compra='DS') " &_
                    "and numero_documento_de_compra=" & rs("numero_documento_respaldo")&" group by P.Superfamilia"
              else
              	strSQL="Select P.Superfamilia , sum(Cantidad_entrada * Costo_CIF_ADU_US$) as total_rubro " &_ 
					   "from movimientos_productos MOP inner join Productos P on P.Producto = MOP.producto where MOP.empresa='SYS' " &_
                       "and documento_no_valorizado='TCP' and tipo_documento_de_compra='"&documento_respaldo&"' " &_
                       "and numero_documento_de_compra=" & rs("numero_documento_respaldo")&" group by P.Superfamilia"
              end if
            
	      set rs_rubros = Conn.Execute(strSQL) 
              suma_rubro = 0
              do while not rs_rubros.EOF
              %>
              <tr bgcolor="#E2F1F3">
      		      <td id="grid_TD_1" align="center"><%=rs_rubros("Superfamilia")%></td>
      		      <td id="grid_TD_1" align="right"><%=FormatNumber(rs_rubros("total_rubro"),2)%>&nbsp;</td>
              </tr>
              <%  suma_rubro = cdbl(suma_rubro) + cdbl(rs_rubros("total_rubro"))
              	  rs_rubros.MoveNext
              	loop
              %>
              <tr bgcolor="#E2EDFC">
      		      <td id="grid_TD_1" align="right">Total:</td>
      		      <td id="grid_TD_1" align="right"><%=FormatNumber(suma_rubro,2)%>&nbsp;</td>
              </tr>
              <%
              	fila = fila + 1
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
