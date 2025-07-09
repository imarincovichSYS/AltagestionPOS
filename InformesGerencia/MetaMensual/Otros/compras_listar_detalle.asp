<%@ Language=VBScript %>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
function Get_Factor_Proyectado_X_Fecha_Y_Superfamilia(z_fecha, z_superfamilia)
  strSQL="select factor from estadistica_proyecciones_rubro_diciembre_factores " &_
         "where fecha='"&z_fecha&"' and superfamilia = '"&z_superfamilia&"'"
  set v_rs=Conn.Execute(strSQL) : z_factor = 0
  if not v_rs.EOF then z_factor = v_rs("factor")
  Get_Factor_Proyectado_X_Fecha_Y_Superfamilia = z_factor
end function 

function Get_Proyectado_X_Superfamilia(z_superfamilia)
  strSQL="select monto from estadistica_proyecciones_rubro_diciembre where superfamilia = '"&z_superfamilia&"'"
  set v_rs=Conn.Execute(strSQL) : z_monto = 0
  if not v_rs.EOF then z_monto = v_rs("monto")
  Get_Proyectado_X_Superfamilia = z_monto
end function 

function Get_Fecha_Formato_YYYY_MM_DD(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
  Get_Fecha_Formato_YYYY_MM_DD = c_anio&"/"&Lpad(c_mes,2,0)&"/"&Lpad(c_dia,2,0)
end function

server.ScriptTimeout      = 10000

desde             = Request.QueryString("fecha_desde")
hasta             = Request.QueryString("fecha_hasta")
orden             = Request.QueryString("pend")

periodo = year(desde) &  Lpad(month(desde),2,0)

if Lpad(month(desde),2,0)+1 = 13 then
  dia_fin_de_mes = 31
else
  dia_fin_de_mes = day(cdate(Lpad(day(desde),2,0)  & "/" & Lpad(month(desde),2,0)+1 & "/" & year(desde))  - 1)
end if

if orden then
  concatena_sql = " order by (A.NetoDolar / (case when d.Meta=0 then 1 else d.meta end)) * 100 desc"
else
  concatena_sql = " order by (case when F.superfamilia = '7' then 'Z7' else F.superfamilia end) "
end if
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition", "attachment; filename=Metas.xls"

width = "900"

fecha_hoy = Get_Fecha_Hoy()
hora      = Left(time(),8)
%>
<html xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:x="urn:schemas-microsoft-com:office:excel"
xmlns="http://www.w3.org/TR/REC-html40" >
<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=ProgId content=Excel.Sheet>
<meta name=Generator content="Microsoft Excel 10">
<link rel="stylesheet" href="<%=RutaProyecto%>css/style.css" type="text/css">

<!--[if gte mso 9]><xml>
 <o:DocumentProperties>
  <o:LastAuthor>ALTAGESTION</o:LastAuthor>
  <o:LastPrinted>2011-07-02T07:25:56Z</o:LastPrinted>
  <o:Created>2011-07-02T07:26:08Z</o:Created>
  <o:LastSaved>2011-07-02T07:30:14Z</o:LastSaved>
  <o:Version>11.5606</o:Version>
 </o:DocumentProperties>
</xml><![endif]-->
<style>
<!--table
	{mso-displayed-decimal-separator:"\.";
	mso-displayed-thousand-separator:"\,";}
@page
	{
<%if para = "" then%>
	margin:.4in 0in 0in 1.1in;
<%else%>
  margin:0in 0in 0in 0in;
<%end if%>
	mso-header-margin:0in;
	mso-footer-margin:0in;
	<%if para = "" then%>
	mso-page-orientation:landscape;
	<%end if%>}
-->
</style>
</head>
<body Leftmargin="0px" Topmargin="0px" Rightmargin="0px" Bottommargin="0px">

<%

'fecha_desde         = Request.Form("documento_respaldo")
'fecha_hasta         = Request.Form("mes")
fecha_desde             = Request.QueryString("fecha_desde")
fecha_hasta                   = Request.QueryString("fecha_hasta")

fecha_desde_YYYY_MM_DD = Replace(Get_Fecha_Formato_YYYY_MM_DD(fecha_desde),"/","-")
fecha_hasta_YYYY_MM_DD = Replace(Get_Fecha_Formato_YYYY_MM_DD(fecha_hasta),"/","-")

fecha_fin_mes = GetMaxDias(fecha_desde) & "-" & Lpad(month(fecha_desde),2,0) & "-" & year(fecha_desde)
fecha_fin_mes_YYYY_MM_DD = Replace(Get_Fecha_Formato_YYYY_MM_DD(fecha_fin_mes),"/","-")

periodo = year(fecha_desde) &  Lpad(month(fecha_desde),2,0)
periodo_1 = (year(fecha_desde)-1) &  Lpad(month(fecha_desde),2,0)
OpenConn
'on error resume next

sql_lineas_total = "select lineas_total = isnull(sum(lineas),0) from _estadistica1"
set rs_sql_lineas_total = Conn.Execute(sql_lineas_total)
lineas_total = cdbl(rs_sql_lineas_total("lineas_total"))

sql_lineas_1 = "select lineas_total_1 = isnull(sum(lineas),0) from _estadistica1 where convert(varchar(10),fecha_movimiento,103)='" & fecha_Hasta & "'"
set rs_sql_lineas_1 = Conn.Execute(sql_lineas_1)
lineas_total_1 = cdbl(rs_sql_lineas_1("lineas_total_1"))

dias_no_trabajados_str = "select count(id) cant_dias_no_trabajados from dias_no_trabajados where convert(varchar(6),fecha,112)= '" & periodo & "'"
set dias_no_trabajados = Conn.Execute(dias_no_trabajados_str)
cant_dias_no_trabajados = cdbl(dias_no_trabajados("cant_dias_no_trabajados"))

dias_no_trabajados_str = "select fecha from dias_no_trabajados where convert(varchar(6),fecha,112)= '" & periodo & "' order by fecha"
set dias_no_trabajados = Conn.Execute(dias_no_trabajados_str)
do while not dias_no_trabajados.EOF
  if  cdate(dias_no_trabajados("fecha")) <= cdate(fecha_Hasta) then
      paso_dia_no_trabajado = cdbl(paso_dia_no_trabajado) + 1
  end if
  dias_no_trabajados.movenext
loop
'response.write paso_dia_no_trabajado
'response.end


'####################################################################################################################
'########## Calcular factor de proyección por rubro (cantidad de veces de la venta al dia consultado) ###############
'####################################################################################################################
strSQL="select sum(meta_1) as total_meta from " &_
       "(select sum(meta) as meta_1 from metas where periodo = '"&periodo&"' " &_
       "UNION " &_
       "select SUM(NetoDolar) as meta_1 FROM _estadistica1 WHERE superfamilia = '7' " &_
       ") A"
set rs_total_meta = Conn.Execute(strSQL) : total_meta = 0
if not rs_total_meta.EOF then total_meta = rs_total_meta("total_meta")
'Response.Write "total_meta: " & total_meta & "<br>"

'calcular último periodo de estadistica de proyecciones
strSQL="select max(fecha) as fecha_max from estadistica_proyecciones"
set rs_max_fecha_estadistica_proy = Conn.Execute(strSQL) : fecha_max = ""
if not rs_max_fecha_estadistica_proy.EOF then 
  fecha_max = rs_max_fecha_estadistica_proy("fecha_max")
  if cint(month(fecha_max)) = cint(month(date())) then
    fecha_ini_proy_YYYY_MM_DD = fecha_desde_YYYY_MM_DD
    fecha_fin_proy_YYYY_MM_DD = fecha_fin_mes_YYYY_MM_DD
    v_fecha_hasta_YYYY_MM_DD  = fecha_hasta_YYYY_MM_DD
  else
    fecha_ini_proy_YYYY_MM_DD = year(fecha_max) & "-" & Lpad(month(fecha_max),2,0) & "-01"
    fecha_fin_proy_YYYY_MM_DD = Get_Fecha_Formato_YYYY_MM_DD(fecha_max)
    v_fecha_hasta_YYYY_MM_DD  = fecha_fin_proy_YYYY_MM_DD
  end if
end if

strSQL="select sum(monto) as tot_proy_mes from estadistica_proyecciones where fecha between '"&fecha_ini_proy_YYYY_MM_DD&"' and '"&fecha_fin_proy_YYYY_MM_DD&"'"
'response.write strSQL
'response.end
set rs_tot_proy_mes = Conn.Execute(strSQL) : tot_proy_mensual = 0
if not rs_tot_proy_mes.EOF then tot_proy_mes = rs_tot_proy_mes("tot_proy_mes")
'Response.Write "tot_proy_mes: " & tot_proy_mes & "<br>"

Factor_Meta_Sobre_Tot_Proy_Mes = cdbl(total_meta) / cdbl(tot_proy_mes)
'Factor_Meta_Sobre_Tot_Proy_Mes = cdbl(tot_proy_mes) / cdbl(total_meta)
'response.write "Factor_Meta_Sobre_Tot_Proy_Mes: " & Factor_Meta_Sobre_Tot_Proy_Mes & "<br>"
strSQL="select IsNull(sum("&Factor_Meta_Sobre_Tot_Proy_Mes&" * monto),0) as tot_proy_dia_actual from estadistica_proyecciones " &_
       "where fecha between '"&fecha_desde_YYYY_MM_DD&" 00:00:00' and '"&fecha_hasta_YYYY_MM_DD&" 23:59:59'"
'Response.Write strSQL
'Response.End
set rs_tot_proy_dia_actual = Conn.Execute(strSQL) : tot_proy_dia_actual = 0
if not rs_tot_proy_dia_actual.EOF then tot_proy_dia_actual = rs_tot_proy_dia_actual("tot_proy_dia_actual")
'Response.Write "tot_proy_dia_actual: " & tot_proy_dia_actual & "<br>"

strSQL="select sum(NetoDolar) as tot_venta_neta_dia_actual from _estadistica1"
set rs_tot_venta_neta_dia_actual = Conn.Execute(strSQL) : tot_venta_neta_dia_actual = 0
if not rs_tot_venta_neta_dia_actual.EOF then tot_venta_neta_dia_actual = rs_tot_venta_neta_dia_actual("tot_venta_neta_dia_actual")
'Response.Write "tot_venta_neta_dia_actual: " & tot_venta_neta_dia_actual & "<br>"

if cdbl(tot_proy_dia_actual) > 0 then porcentaje_cumplimiento_actual = (cdbl(tot_venta_neta_dia_actual) / cdbl(tot_proy_dia_actual)) * 100
'response.write "porcentaje_cumplimiento_actual: " & porcentaje_cumplimiento_actual & "<br>"
total_venta_proyectada = (cdbl(porcentaje_cumplimiento_actual) * cdbl(total_meta)) / 100
'Response.Write "total_venta_proyectada: " & total_venta_proyectada & "<br>"
FACTOR_PROYECCION = cdbl(total_venta_proyectada)/ cdbl(tot_venta_neta_dia_actual)
'Response.Write "FACTOR_PROYECCION: " & FACTOR_PROYECCION & "<br>"
'Response.End
'####################################################################################################################
'####################################################################################################################

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
sql = " SELECT  superfamilia = Isnull(F.Superfamilia,0), NetoDolar = Isnull(A.NetoDolar,0), totcia = Isnull(A.totcia,0), TotCpa= Isnull(A.TotCpa,0), " &_ 
      " Mg = Isnull(A.mg,0), Cantidad = Isnull(A.Cantidad,0), " &_
	    " T_Cif_Ori = Isnull(A.TotCio,0), Total_$ = Isnull(A.Bruto$,0), Neto_$ = Isnull(A.Neto$,0), DIH$ = IsNull(DIH$,0), DIH_1 = IsNull(DIH_1,0), Imp_$ = Isnull(A.imp$,0) ,Ila = Isnull(A.ILA,0), " &_ 
      " Lineas = Isnull(A.Lineas,0), " &_
	    " NetoDolar_1 = Isnull(B.NetoDolar_1,0), totcia_1 = Isnull(b.totcia_1,0), TotCpa_1 = Isnull(b.TotCpa_1,0), mg_1 = Isnull(b.mg_1,0), " &_ 
      " Cantidad_1 = Isnull(B.Cantidad_1,0), " &_
	    " T_Cif_Ori_1 = Isnull(B.TotCio_1,0), Total_$_1 = Isnull(B.Bruto$_1,0), Neto_$_1 = Isnull(B.Neto$_1,0), Imp_$_1 = Isnull(B.imp$_1,0), " &_ 
      " Ila_1 = Isnull(B.ILA_1,0), Lineas_1 = Isnull(B.Lineas_1,0), " &_
	    " NetoDolar_2 = Isnull(C.NetoDolar_2,0), totcia_2 = Isnull(c.totcia_2,0), TotCpa_2 = Isnull(c.TotCpa_2,0), mg_2 = Isnull(c.mg_2,0), " &_
	    " d.Meta, Total, Transito_mes, Transito_mes_mas_uno, Transito_mes_mas_dos, transito_futuro, IsNull(Exi,0) as Exi, docs = Isnull(A.docs,0), docs_1 = Isnull(A.docs1,0), docs_2 = Isnull(A.docs2,0), descr = G.Nombre, Porc = isnull(H.porcentaje,1) " &_
      " FROM " &_
    	" (SELECT superfamilia, " &_ 
    	" NetoDolar = SUM(NetoDolar), " &_
    	" totcia = sum(TotCia), " &_
    	" TotCpa = sum(TotCpa), " &_
    	" mg = case when (sum(NetoDolar)>0) then " &_
    	" 	convert(numeric(16,2),((sum(NetoDolar)-sum(TotCpa))/sum(NetoDolar))*100) " &_
    	"      else " &_
      " 	convert(numeric(16,2),0) " &_
    	"      end, " &_
    	" Cantidad = sum(ventas), " &_
    	" TotCio = sum (TotCio), " &_
    	" Bruto$ = sum(Bruto$), " &_
    	" Neto$ = sum(Neto$), " &_
      " DIH$ = sum(imp_dih), " &_
    	" imp$ = sum(imp$), " &_
    	" ILA = sum(ILA), " &_
    	" lineas = sum(lineas), " &_
    	" docs = max(docs), " &_
    	" docs1 = max(docs1), " &_
    	" docs2 = max(docs2) " &_
    	" from _estadistica1  " &_
    	" where convert(varchar(10),fecha_movimiento,103) between '" & fecha_desde & "' and '" & fecha_Hasta & "' group by superfamilia) A " &_
    	" left join (SELECT superfamilia, " &_
    	" NetoDolar_1 = SUM(NetoDolar), " &_
    	" totcia_1 = sum(TotCia), " &_
    	" TotCpa_1 = sum(TotCpa), " &_
    	" mg_1 = case when (sum(NetoDolar)>0) then " &_
    	" convert(numeric(16,2),((sum(NetoDolar)-sum(TotCpa))/sum(NetoDolar))*100) " &_
    	"      else " &_
      " convert(numeric(16,2),0) " &_
    	"      end, " &_
    	" Cantidad_1 = sum(ventas), " &_
    	" TotCio_1 = sum (TotCio), " &_
    	" Bruto$_1 = sum(Bruto$), " &_
    	" Neto$_1 = sum(Neto$), " &_
      " DIH_1 = sum(imp_dih), " &_
    	" imp$_1 = sum(imp$), " &_
    	" ILA_1 = sum(ILA), " &_
    	" lineas_1 = sum(lineas) " &_
    	" from _estadistica1  " &_
    	" where convert(varchar(10),fecha_movimiento,103) = '" & fecha_Hasta & "' group by superfamilia) B on a.superfamilia = b.superfamilia " &_
    	" left join (SELECT superfamilia,  " &_
    	" NetoDolar_2 = SUM(isnull(NetoDolar,0)), " &_
    	" totcia_2 = sum(isnull(TotCia,0)), " &_
    	" TotCpa_2 = sum(isnull(TotCpa,0)), " &_
    	" mg_2 = case when (sum(isnull(NetoDolar,0))>0) then " &_
    	" 	convert(numeric(16,2),((sum(isnull(NetoDolar,0))-sum(isnull(TotCpa,0)))/sum(isnull(NetoDolar,0)))*100) " &_
    	"      else " &_
    	" 	convert(numeric(16,2),0) " &_
    	"      end " &_
    	" from _estadistica1 " &_ 
    	" where convert(varchar(10),fecha_movimiento,103)='" & cdate(fecha_Hasta) -1 & "' group by superfamilia) C on a.superfamilia = c.superfamilia " &_
    	" left join (select Periodo, Superfamilia, Meta  from metas where periodo = '"&periodo&"') D on a.superfamilia = d.superfamilia " &_
    	" left join (select Periodo, Superfamilia, Total, Transito_mes = isnull(Transito_mes,0), Transito_mes_mas_uno = isnull(Transito_mes_mas_uno,0), Transito_mes_mas_dos = isnull(Transito_mes_mas_dos,0), " &_ 
      " transito_futuro = isnull(transito_futuro,0)  from compras where periodo = '"&periodo&"') E on a.superfamilia = e.superfamilia " &_
      " left join (select Periodo, Superfamilia, IsNull(Exi,0) as Exi  from Existencias where periodo = '"&periodo&"') F on a.superfamilia = f.superfamilia " &_
      " left join (select Superfamilia, Nombre from superfamilias) G on a.superfamilia = g.superfamilia " &_
      " left join (select Rubro, porcentaje  from proyectado_ano_anterior where periodo = '"&periodo_1&"' and dia =" & day(fecha_Hasta) & " ) H on a.superfamilia = h.superfamilia"  & concatena_sql    	

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'response.write Sql
'response.end
i=1
set rs = Conn.Execute(Sql)
      width = "1800"  %>
            <table>
              <tr id="inf_TD_FS_11">
                <td></td>
                <td align="center"><b><%=Hasta%></b></td>
                <td></td>
                <td Align="center"><b>Docs.</b></td> 
                <td><b><%=FormatNumber(rs("docs"),0)%></b></td> <td></td> <td></td> 
                <td Align="center"><b>Docs.-1</b></td> 
                <td><b><%=FormatNumber(rs("docs_1"),0)%></b></td> </td> <td></td> <td></td>
                <td Align="center"><b>Docs.-2</b></td> 
                <td><b><%=FormatNumber(rs("docs_2"),0)%></b></td>
              </tr>
              <tr valign="center" id="inf_TD_FS_11" >
                <td style="width:20px;" Align="Left"><b>R</b></td>
                <td style="width:110px;" Align="center"><b>Descripción</b></td>                
                <td style="width:60px;" Align="center"><b>Neto</b></td>
            		<td style="width:70px;" Align="center"><b>Cif.A</b></td>
            		<td style="width:70px;" Align="center"><b>CPA</b></td>
            		<td style="width:30px;" Align="center"><b>%</b></td>                
		            <td style="width:50px;" Align="center"><b><%=day(fecha_hasta)%></b></td>           
            		<td style="width:60px;" Align="center"><b>Cif.A <%=day(fecha_hasta)%></b></td>
            		<td style="width:60px;" Align="center"><b>CPA <%=day(fecha_hasta)%></b></td>
            		<td style="width:30px;" Align="center"><b>&#37;&nbsp;<%=day(fecha_hasta)%></b></td>              
             		<td style="width:50px;" Align="center"><b><%=day(fecha_hasta) - 1%></b></td>
            		<td style="width:60px;" Align="center"><b>Cif.A <%=day(fecha_hasta) - 1%></b></td>
            		<td style="width:60px;" Align="center"><b>CPA <%=day(fecha_hasta) - 1%></b></td>
            		<td style="width:30px;" Align="center"><b>&#37;&nbsp;<%=day(fecha_hasta) - 1%></b></td>                                		
            		<td style="width:58px;" Align="center"><b>Meta</b></td>
            		<td style="width:35px;" Align="center"><b>Log.</b></td>
            		<td style="width:58px;" Align="center"><b>Proyect.</b></td>		
            		<td style="width:60px;" Align="center"><b>Compras</b></td>
            		<td style="width:58px;" Align="center"><b>Exi. Act.</b></td>
            		<td style="width:54px;" Align="center"><b>Tto. Mes</b></td>			
            		<td style="width:54px;" Align="center"><b>T. Mes+1</b></td>
            		<td style="width:54px;" Align="center"><b>T. Mes+2</b></td>                		
            		<td style="width:54px;" Align="center"><b>T. Fut.</b></td>
		            <td style="width:58px;" Align="center"><b>Exi. <%= Lpad(month(fecha_desde)-1,2,0) &"/"& right(year(fecha_desde),2)%></b></td>      
            		<td style="width:55px;" Align="center"><b>Cantidad</b></td>    					
            		<td style="width:60px;" Align="center"><b>T.Cif.Ori</b></td>
            		<td style="width:80px;" Align="center"><b>Total$</b></td>
            		<td style="width:80px;" Align="center"><b>Neto$</b></td>                
            		<td style="width:60px;" Align="center"><b>Imp$</b></td>	
            		<td style="width:50px;" Align="center"><b>Ila</b></td>
                <td style="width:55px;" Align="center"><b>DIH$</b></td>     
            		<td style="width:40px;" Align="center"><b>Cant-1</b></td>    					
            		<td style="width:60px;" Align="center"><b>T.CiO-1</b></td>
            		<td style="width:60px;" Align="center"><b>Total$-1</b></td>
            		<td style="width:50px;" Align="center"><b>Neto$-1</b></td>
            		<td style="width:40px;" Align="center"><b>Imp$-1</b></td>                
            		<td style="width:40px;" Align="center"><b>Ila-1</b></td>
                <td style="width:55px;" Align="center"><b>DIH-1</b></td>               
                <td style="width:40px;" Align="center"><b>Lineas</b></td>		
            		<td style="width:30px;" Align="center"><b>Lin-1</b></td>		
                <td style="width:30px;" Align="center"><b>%Lin</b></td>		
                <td Align="center"><b>%Lin-1</b></td>                                		
              </tr>            
        <%
        
        	nNetoDolar = 0
	ntotcia = 0
	nTotCpa = 0
	
	nNetoDolar_1 = 0
	ntotcia_1 = 0
	nTotCpa_1 = 0
	
	nNetoDolar_2 = 0
	ntotcia_2 = 0
	nTotCpa_2 = 0
	
	nMeta = 0
	Logro = 0
	Proy = 0
	
	nCompras = 0 
	Exi_Actual = 0
	tto_mes = 0
	tto_mes_mas_uno = 0
	tto_mes_mas_dos = 0	
	tto_fut = 0
	Exi_ini = 0
	
	Cant = 0
	nCio = 0
	nTotal_ = 0 
  nNeto_ = 0
  nDIH = 0
  nDIH_1 = 0
  nImp = 0
  nIla = 0
  
  Cant_1 = 0
  nTcio_1 = 0
  nTotal_1 = 0
  nNeto_1 = 0
  nImp_1 = 0
  nIla_1 = 0
  Lineas = 0
  Lineas_1 = 0
        do while not rs.EOF
          if cdbl(Rs("Meta")) = 0 then
              meta = 1
            else
              meta =   FormatNumber(Rs("Meta"),2)
            end if%>
           <tr id="inf_TD_FS_11">
            <td align="left"><%=Rs("superfamilia")%></td>            
            <td><%=Rs("descr")%></td>            
				    <td align="right" class="FormatNumber_2"><%=cdbl(Rs("NetoDolar"))%></td>
  					<td align="right" class="FormatNumber_4"><%=cdbl(Rs("totcia"))%></td>
  					<td align="right" class="FormatNumber_4" ><%=cdbl(Rs("TotCpa"))%></td>
  					<td align="right" class="FormatNumber_2" ><%=cdbl(Rs("Mg"))%></td>
					  <td align="right" class="FormatNumber_2" ><%=cdbl(Rs("NetoDolar_1"))%></td>    
  					<td align="right" class="FormatNumber_4" ><%=cdbl(Rs("totcia_1"))%></td>
  					<td align="right" class="FormatNumber_4" ><%=cdbl(Rs("TotCpa_1"))%></td>
            <td align="right" class="FormatNumber_2" ><%=cdbl(Rs("Mg_1"))%></td>		                   
  					<td align="right" class="FormatNumber_2" ><%=cdbl(Rs("NetoDolar_2"))%></td>
  					<td align="right" class="FormatNumber_4" ><%=cdbl(Rs("totcia_2"))%></td>
  					<td align="right" class="FormatNumber_4" ><%=cdbl(Rs("TotCpa_2"))%></td>
            <td align="right" class="FormatNumber_2" ><%=cdbl(Rs("Mg_2"))%></td>           
            <td align="right" class="FormatNumber_2" ><%if Rs("superfamilia") = "ZZ" then                                'META
                                                        response.write(rs("NetoDolar"))
                                                      else
                                                         response.write(Rs("Meta"))
                                                      end if%></td>
            <td align="right" class="FormatNumber_2" ><%if Rs("superfamilia") = "ZZ" and Cdbl(rs("NetoDolar"))>0 then    'LOGRO
                                                        response.write("100")
                                                      elseif Rs("superfamilia") = "ZZ" and cdbl(rs("NetoDolar"))=0 then
                                                        response.write("0")
                                                      else
                                                        response.write(formatNumber(FormatNumber(Rs("NetoDolar"),2) / cdbl(meta) * 100,2))
                                                      end if%></td> 

            <td align="right" class="FormatNumber_2" ><%'if Rs("superfamilia") = "ZZ" and Cdbl(rs("NetoDolar"))>0 then    'PROYECTADO
                                                        'response.write(rs("NetoDolar"))
                                                      'else
                                                      '  response.write(cdbl( cdbl(Rs("NetoDolar")) / (cdbl(day(fecha_hasta)) - cdbl(paso_dia_no_trabajado) ) * (cdbl(dia_fin_de_mes) - cant_dias_no_trabajados)))
                                                      'end if
                                                      if Rs("superfamilia") = "ZZ" and Cdbl(rs("NetoDolar"))>0 then  'PROYECTADO
                                                        Nuevo_Proyectado = rs("NetoDolar")
                                                      else
                                                        Nuevo_Proyectado = Round(cdbl(rs("NetoDolar")) * cdbl(FACTOR_PROYECCION),2)
                                                      end if
                                                      'Response.Write FormatNumber(Nuevo_Proyectado,2)
                                                      Nuevo_Proyectado_Diciembre = Nuevo_Proyectado
                                                      'Nuevo_Proyectado_Diciembre = Get_Proyectado_X_Superfamilia(trim(Rs("superfamilia")))
                                                      'Factor_Proy_Diciembre = Get_Factor_Proyectado_X_Fecha_Y_Superfamilia(fecha_hasta_YYYY_MM_DD,trim(Rs("superfamilia")))
                                                      'Nuevo_Proyectado_Diciembre = cdbl(Rs("NetoDolar")) / (cdbl(Factor_Proy_Diciembre) / 100)
                                                      Response.Write FormatNumber(Nuevo_Proyectado_Diciembre,2)
                                                      %></td>
            <!--<td align="right" class="FormatNumber_2" ><%'=formatNumber( (cdbl(Rs("NetoDolar")) / cdbl(Rs("porc")))*100 ,2)%></td>-->            
             
            <td align="right" class="FormatNumber_4" ><%=cdbl(Rs("Total"))%></td> 
            <td align="right" class="FormatNumber_2" ><%=cdbl(cdbl(Rs("Exi")) + cdbl(Rs("Total")) - cdbl(Rs("totcia")))%></td>                                      				    
  					<td align="right" class="FormatNumber_2" ><%=cdbl(Rs("Transito_mes"))%></td>
  					<td align="right" class="FormatNumber_2" ><%=cdbl(Rs("Transito_mes_mas_uno"))%></td>
  					<td align="right" class="FormatNumber_2" ><%=cdbl(Rs("Transito_mes_mas_dos"))%></td>                          
  					<td align="right" class="FormatNumber_2" ><%=cdbl(Rs("transito_futuro"))%></td>         
            <td align="right" class="FormatNumber_2" ><%=cdbl(Rs("Exi"))%></td>           
            <td align="right"><%=FormatNumber(cdbl(Rs("Cantidad")),0)%></td>                        
            <td align="right" class="FormatNumber_2" ><%=cdbl(Rs("T_Cif_Ori"))%></td>
            <td align="right" ><%=FormatNumber(cdbl(Rs("Total_$")),0)%></td>
            <td align="right" ><%=FormatNumber(cdbl(Rs("Neto_$")),0)%></td>            
            <td align="right" ><%=FormatNumber(cdbl(Rs("Imp_$")),0)%></td>          
            <td align="right" ><%=FormatNumber(cdbl(Rs("Ila")),0)%></td>
            <td align="right"><%=FormatNumber(cdbl(Rs("DIH$")),0)%></td>    
            <td align="right" ><%=FormatNumber(cdbl(Rs("Cantidad_1")),0)%></td>                        
            <td align="right" class="FormatNumber_2" ><%=cdbl(Rs("T_Cif_Ori_1"))%></td>
            <td align="right" ><%=FormatNumber(cdbl(Rs("Total_$_1")),0)%></td>
            <td align="right" ><%=FormatNumber(cdbl(Rs("Neto_$_1")),0)%></td>
            <td align="right" ><%=FormatNumber(cdbl(Rs("Imp_$_1")),0)%></td>            
            <td align="right" ><%=FormatNumber(cdbl(Rs("Ila_1")),0)%></td>
            <td align="right"><%=FormatNumber(cdbl(Rs("DIH_1")),0)%></td>   
            <td align="right" ><%=FormatNumber(cdbl(Rs("Lineas")),0)%></td>
            <td align="right" ><%=FormatNumber(cdbl(Rs("Lineas_1")),0)%></td>   
            <td align="right" class="FormatNumber_2" ><%if lineas_total = 0 then response.write("0") else response.write(cdbl(Rs("Lineas")/lineas_total*100))%></td>          
            <td align="right" class="FormatNumber_2" ><%if lineas_total_1 = 0 then response.write("0") else  response.write(cdbl(Rs("Lineas_1")/lineas_total_1*100))%></td>
           </tr>
            <%
            nNetoDolar = nNetoDolar + cdbl(Rs("NetoDolar"))
          	ntotcia = ntotcia + cdbl(Rs("totcia"))
           	nTotCpa = nTotCpa + cdbl(Rs("TotCpa"))
            nNetoDolar_1 = nNetoDolar_1 + cdbl(Rs("NetoDolar_1"))      
           	ntotcia_1 = ntotcia_1 + cdbl(Rs("totcia_1"))
           	nTotCpa_1 = nTotCpa_1 + cdbl(Rs("TotCpa_1"))                 
            nNetoDolar_2 = nNetoDolar_2 + cdbl(Rs("NetoDolar_2"))
           	ntotcia_2 = ntotcia_2 + cdbl(Rs("totcia_2"))
           	nTotCpa_2 = nTotCpa_2 + cdbl(Rs("TotCpa_2"))     
             
            if Rs("superfamilia") = "ZZ" and  isnull(Rs("NetoDolar")) then
              meta = 0
            elseif Rs("superfamilia") = "ZZ" then
              meta = Rs("NetoDolar")
            else
              meta = Rs("meta")
            end if         
           	nMeta = nMeta + cdbl(meta)

         	  'Proy = Proy + cdbl((cdbl(Rs("NetoDolar")) / (cdbl(day(fecha_hasta)) - cdbl(paso_dia_no_trabajado)))*(cdbl(dia_fin_de_mes)- cant_dias_no_trabajados))
         	  'Proy = Proy + (cdbl(Rs("NetoDolar")) / cdbl(Rs("porc")))*100
            'Proy = cdbl(Proy) + cdbl(Nuevo_Proyectado) ---> linea original (CAGADA DE CRISTIAN)
         	  Proy = cdbl(Proy) + cdbl(Nuevo_Proyectado_Diciembre)

           	nCompras = nCompras + cdbl(Rs("Total"))
           	Exi_Actual = Exi_Actual + (cdbl(Rs("Exi")) + cdbl(Rs("Total")) - cdbl(Rs("totcia")))  
           	tto_mes = tto_mes + cdbl(Rs("Transito_mes"))
           	tto_mes_mas_uno = tto_mes_mas_uno + cdbl(Rs("Transito_mes_mas_uno"))
           	tto_mes_mas_dos = tto_mes_mas_dos + cdbl(Rs("Transito_mes_mas_dos"))           	
           	tto_fut = tto_fut + cdbl(Rs("transito_futuro"))                   
            Exi_ini = Exi_ini + cdbl(Rs("Exi"))
            Cant = Cant + CDBL(Rs("Cantidad"))
           	nCio = nCio + cdbl(Rs("T_Cif_Ori"))
           	nTotal_ = nTotal_ + cdbl(Rs("Total_$"))
            nNeto_ = nNeto_ + cdbl(Rs("Neto_$"))
            nDIH = nDIH + cdbl(Rs("DIH$"))
            nDIH_1 = nDIH_1 + cdbl(Rs("DIH_1"))
            nImp = nImp + cdbl(Rs("Imp_$"))
            nIla = nIla + cdbl(Rs("Ila"))
            Cant_1 = Cant_1 + cdbl(Rs("Cantidad_1"))
            nTcio_1 = nTcio_1 + cdbl(Rs("T_Cif_Ori_1"))
            nTotal_1 = nTotal_1 + cdbl(Rs("Total_$_1"))
            nNeto_1 = nNeto_1 + cdbl(Rs("Neto_$_1"))
            nImp_1 = nImp_1 + cdbl(Rs("Imp_$_1"))
            nIla_1 = nIla_1 + cdbl(Rs("Ila_1"))                     
            docs = rs("docs")
            docs_1 = rs("docs_1")
            lineas = lineas + cdbl(Rs("Lineas"))
            lineas_1 = lineas_1 + cdbl(Rs("Lineas_1"))            
            i=i+1
            
            rs.movenext
            loop%>     
        <tr id="inf_TD_FS_11">
               
        <%if nNetoDolar = 0 then
            mg_total = 0
          else 
             mg_total = FormatNumber(((nNetoDolar - nTotCpa)/nNetoDolar)*100,2)
          end if
          if nNetoDolar_1 = 0 then
            mg_total_1 = 0 
          else
            mg_total_1 = FormatNumber(((nNetoDolar_1 - nTotCpa_1)/nNetoDolar_1)*100,2)
          end if
          if nNetoDolar_2 = 0 then
            mg_total_2 = 0 
          else
            mg_total_2 = FormatNumber(((nNetoDolar_2 - nTotCpa_2)/nNetoDolar_2)*100,2)
          end if
          if docs = 0 then
            total_lineas_por_docs = 0 
          else
            total_lineas_por_docs = FormatNumber(lineas/docs,2)
          end if
          if docs_1 = 0 then
            total_lineas_por_docs_1 = 0 
          else
            total_lineas_por_docs_1 = FormatNumber(lineas_1/docs_1,2)
          end if%>
          <td >&nbsp; </B>&nbsp;</td>
          <td >&nbsp; </B>&nbsp;</td>        
        	<td class="FormatNumber_2"><%=Cdbl(nNetoDolar)%></td>
        	<td align="right" class="FormatNumber_4"><%=Cdbl(ntotcia)%></td>
        	<td align="right" class="FormatNumber_4"><%=Cdbl(nTotCpa)%></td>
        	<td align="right" class="FormatNumber_2"><%=Cdbl(mg_total)%></td>
	        <td align="right" class="FormatNumber_2"><%=Cdbl(nNetoDolar_1)%></td>  
        	<td align="right" class="FormatNumber_4"><%=Cdbl(ntotcia_1)%></td>
        	<td align="right" class="FormatNumber_4"><%=Cdbl(nTotCpa_1)%></td>
        	<td align="right" class="FormatNumber_2"><%=Cdbl(mg_total_1)%></td> 
          <td align="right" class="FormatNumber_2"><%=Cdbl(nNetoDolar_2)%></td>
        	<td align="right" class="FormatNumber_4"><%=Cdbl(ntotcia_2)%></td>
        	<td align="right" class="FormatNumber_4"><%=Cdbl(nTotCpa_2)%></td>
        	<td align="right" class="FormatNumber_2"><%=Cdbl(mg_total_2)%></td>         
        	<td align="right" class="FormatNumber_2"><%=Cdbl(nMeta)%></td>
        	<td align="right" class="FormatNumber_2"><%=Cdbl((nNetoDolar/nMeta)*100)%></td>
        	<td align="right" class="FormatNumber_2"><%=Cdbl(Proy)%></td>
        	<td align="right" class="FormatNumber_4"><%=Cdbl(nCompras)%></td>
        	<td align="right" class="FormatNumber_2"><%=Cdbl(Exi_Actual)%></td>               
         	<td align="right" class="FormatNumber_2"><%=Cdbl(tto_mes)%></td>
         	<td align="right" class="FormatNumber_2"><%=Cdbl(tto_mes_mas_uno)%></td>
         	<td align="right" class="FormatNumber_2"><%=Cdbl(tto_mes_mas_dos)%></td>                    	         	
        	<td align="right" class="FormatNumber_2"><%=Cdbl(tto_fut)%></td>          
	        <td align="right" class="FormatNumber_2"><%=Cdbl(Exi_ini)%></td>               
          <td align="right"><%=formatNumber(Cdbl(Cant),0)%></td>
          <td align="right" class="FormatNumber_2"><%=Cdbl(nCio)%></td>
        	<td align="right" ><%=formatNumber(Cdbl(nTotal_),0)%></td>
        	<td align="right" ><%=formatNumber(Cdbl(nNeto_),0)%></td>          
        	<td align="right" ><%=formatNumber(Cdbl(nImp),0)%></td>	
        	<td align="right" ><%=formatNumber(Cdbl(nIla),0)%></td>
          <td align="right"><%=formatNumber(Cdbl(nDIH),0)%></td>            
          <td align="right" ><%=formatNumber(Cdbl(Cant_1),0)%></td>
        	<td align="right" class="FormatNumber_2"><%=Cdbl(nTcio_1)%></td>	
        	<td align="right" ><%=formatNumber(Cdbl(nTotal_1),0)%></td>
          <td align="right" ><%=formatNumber(Cdbl(nNeto_1),0)%></td>
        	<td align="right" ><%=formatNumber(Cdbl(nImp_1),0)%></td>          
        	<td align="right" ><%=formatNumber(Cdbl(nIla_1),0)%></td>
          <td align="right"><%=formatNumber(Cdbl(nDIH_1),0)%></td>
        	<td align="right" ><%=formatNumber(Cdbl(lineas),0)%></td>        	
        	<td align="right" ><%=formatNumber(Cdbl(lineas_1),0)%></td>        	
        	<td align="right" class="FormatNumber_2"><%=Cdbl(total_lineas_por_docs)%></td>        	
        	<td align="right" class="FormatNumber_2"><%=Cdbl(total_lineas_por_docs_1)%></td>        	
        	
        </tr>
            
        </table>
<!--[if gte mso 9]><xml>
 <x:ExcelWorkbook>
  <x:ExcelWorksheets>
   <x:ExcelWorksheet>
    <x:Name>Estadistica</x:Name>
    <x:WorksheetOptions>
     <x:DefaultColWidth>10</x:DefaultColWidth>
     <x:Print>
      <x:ValidPrinterInfo/>
      <x:PaperSizeIndex>5</x:PaperSizeIndex>
      <x:Scale>100</x:Scale>
      <x:HorizontalResolution>120</x:HorizontalResolution>
      <x:VerticalResolution>72</x:VerticalResolution>
     </x:Print>
     <!--<x:ShowPageBreakZoom/> --> <!-- Muestra los número de página de Excel -->
     <x:PageBreakZoom>100</x:PageBreakZoom>
     <x:Selected/>
     
     <x:FreezePanes/>
     <x:FrozenNoSplit/>
     <x:SplitVertical>2</x:SplitVertical>
     <x:LeftColumnRightPane>2</x:LeftColumnRightPane>
     <x:SplitHorizontal>2</x:SplitHorizontal>
     <x:TopRowBottomPane>2</x:TopRowBottomPane>
     <x:ActivePane>1</x:ActivePane>
     
    <!--<x:DoNotDisplayGridlines/>-->
     <x:Panes>
      <x:Pane>
       <x:Number>3</x:Number>
      </x:Pane>
      <x:Pane>
       <x:Number>0</x:Number>
       <x:ActiveRow>0</x:ActiveRow>
       <x:ActiveCol>0</x:ActiveCol>
      </x:Pane>
     </x:Panes>
     <x:ProtectContents>False</x:ProtectContents>
     <x:ProtectObjects>False</x:ProtectObjects>
     <x:ProtectScenarios>False</x:ProtectScenarios>
    </x:WorksheetOptions>
    <!--<x:PageBreaks>
     <x:RowBreaks>
      <x:RowBreak>
       <x:Row>22</x:Row>
      </x:RowBreak>
     </x:RowBreaks>
    </x:PageBreaks>-->
   </x:ExcelWorksheet>
  </x:ExcelWorksheets>
  <x:WindowHeight>9210</x:WindowHeight>
  <x:WindowWidth>19995</x:WindowWidth>
  <x:WindowTopX>240</x:WindowTopX>
  <x:WindowTopY>60</x:WindowTopY>
  <x:ProtectStructure>False</x:ProtectStructure>
  <x:ProtectWindows>False</x:ProtectWindows>
 </x:ExcelWorkbook>
 <x:ExcelName>
  <x:Name>Print_Area</x:Name>
  <x:SheetIndex>1</x:SheetIndex>
  <%
  col_rango_final = "AB"
  if para <> "" then 
    fila = fila - 1
    col_rango_final = "M"
  end if
  %>
  <x:Formula>='Estadistica'!$A$1:$V$30</x:Formula>
 </x:ExcelName> 
</xml><![endif]-->
</body>
</html>
