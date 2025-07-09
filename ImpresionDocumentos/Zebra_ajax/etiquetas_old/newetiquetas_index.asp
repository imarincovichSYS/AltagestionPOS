<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
	'*********** Especifica la codificación y evita usar caché **********
	Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
	Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
	NomFun = Request.QueryString("NomFun")
	tipo_usuario = "adm" 'se dejara como adm, pero el valor default es visita'
	If  NomFun="ETIQJRAJAXA" Then tipo_usuario= "adm"
	OpenConn_Alta
	fecha_hoy_YYYY_MM_DD = Get_Fecha_Formato_YYYY_MM_DD(Date)
	nom_dia_semana = GetDiaSemana(Weekday(date,0))
	strSQL="select A.numero_interno_etiqueta, A.fecha, A.nombre_etiqueta, A.responsable, A.tipo_etiqueta, B.n_responsable from " &_
	"(select  numero_interno_etiqueta, fecha, nombre_etiqueta, responsable, tipo_etiqueta from etiquetas) A, " &_
	"(select  entidad_comercial,  Apellidos_persona_o_nombre_empresa + ' ' + Nombres_persona as n_responsable from entidades_comerciales where empresa='SYS') B " &_
	"where A.responsable=B.entidad_comercial order by nombre_etiqueta"
	'and A.numero_interno_etiqueta=C.numero_interno_etiqueta
	' "(select numero_interno_etiqueta, detalle from etiquetas_detalle) C " &_
	'response.write strSQL
	'response.end
	Set rs = ConnAlta.Execute(strSQL)
	If Not rs.EOF Then
		w_fecha=80
		w_responsable=250
		w_tipo_etiqueta=80
		w_table=770
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/etiqueta.css">
	</head>
	<body>
		<div id="lienzoetiqueta2" style="overflow:auto;">
			<table style="width:100%;">
				<tr>
					<td>
						<%If tipo_usuario = "adm" then%>
							<img src="images/newetiqueta.png" height="37px" width="90px" alt="Nueva Etiqueta" style="cursor:pointer;" onclick="javascript:location.href='newetiquetas.asp'">
						<%End if%>
					</td>
				</tr>
				<tr>
					<td class="tdbackground">
						Fecha
					</td>
					<td class="tdbackground">
						Nombre
					</td>
					<td class="tdbackground">
						Tipo Etiqueta
					</td>
					<td class="tdbackground">
						Responsable
					</td>
				</tr>
				<%
					Do While Not rs.EOF%>
					<tr onclick="javascript:location.href='newetiqueta_editar.asp?numero_interno_etiqueta=<%=rs("numero_interno_etiqueta")%>&tipo_usuario=<%=tipo_usuario%>';" class="trfontlistar">
						<td align="center"><%=Left(rs("fecha"),10)%></td>
						<td>&nbsp;<%=Rs("nombre_etiqueta")%></td>
						<td>&nbsp;<%=rs("tipo_etiqueta")%></td>
						<td>&nbsp;<%=rs("n_responsable")%></td>
					</tr>
				<%
					rs.MoveNext
				loop%>
			</table>
		</div>
	</body>
</html>
<%End if%>