<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn_Alta

fecha_hoy_YYYY_MM_DD = Get_Fecha_Formato_YYYY_MM_DD(Date)
nom_dia_semana = GetDiaSemana(Weekday(date,0))

strSQL="select A.numero_interno_etiqueta, A.fecha, A.nombre_etiqueta, A.responsable, A.tipo_etiqueta, B.n_responsable from " &_
              "(select  numero_interno_etiqueta, fecha, nombre_etiqueta, responsable, tipo_etiqueta from etiquetas) A, " &_
			  "(select  entidad_comercial,  Apellidos_persona_o_nombre_empresa + ' ' + Nombres_persona as n_responsable from entidades_comerciales where empresa='SYS') B " &_
			  "where A.responsable=B.entidad_comercial order by nombre_etiqueta"
'response.write strSQL
'response.end
Set rs = ConnAlta.Execute(strSQL)
If Not rs.EOF Then
	w_fecha					= 80
	w_responsable		= 250
	w_tipo_etiqueta	= 80
	w_table					= 770
%>
<div style="width:<%=w_table+17%>px;">
	<table class="table_cabecera" style="width:<%=w_table%>px;">
		<tr>
			<td align="center" style="width: <%=w_fecha%>px;">FECHA</td>
			<td>&nbsp;NOMBRE</td>
			<td style="width: <%=w_tipo_etiqueta%>px;">&nbsp;TIPO ETIQ.</td>
			<td style="width: <%=w_responsable%>px;">&nbsp;RESPONSABLE</td>
		</tr>
	</table>
</div>
<div style="width: <%=w_table+17%>px; height:350px; overflow:auto;">
<table class="table_detalle" style="width:<%=w_table%>px;">
	<%
	Do While Not rs.EOF%>
		<tr onclick="Cargar_Etiqueta('<%=rs("numero_interno_etiqueta")%>')">
		<td align="center" style="width: <%=w_fecha%>px;"><%=Left(rs("fecha"),10)%></td>
		<td>&nbsp;<%=Rs("nombre_etiqueta")%></td>
		<td style="width: <%=w_tipo_etiqueta%>px;">&nbsp;<%=rs("tipo_etiqueta")%></td>
		<td style="width: <%=w_responsable%>px;">&nbsp;<%=rs("n_responsable")%></td>
		</tr>
	<%
	  rs.MoveNext
	loop%>
</table>
</div>
<%End if%>