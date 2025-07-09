<!--#include file="conf/config.asp" -->
<!--#include file="clases/utils.asp" -->
<%
	'*********** Especifica la codificación y evita usar caché **********
	Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
	Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
	OpenConn_Alta
	v_numero_interno_etiqueta=Request.form("numero_interno_etiqueta")
	strSQL="select * from etiquetas where numero_interno_etiqueta='"+v_numero_interno_etiqueta+"'"
	Set rs = ConnAlta.Execute(strSQL)
%>
<div name="encabezado_tabla" id="encabezado_tabla">
	<table name="tabla_encabezado" id="tabla_encabezado">
		<tr>
			<td>
				tama&ntilde;o
				<select name="tamagnoEtiqueta" id="tamagnoEtiqueta" disabled>
					<option value="<%=rs("tipo_etiqueta")%>" selected><%=rs("tipo_etiqueta")%> cm</option>
				</select>
			</td>
			<td>
				<img src="images/plus.png" height="24" width="24" style="cursor:pointer;" onclick="javascript:AgregarCampos(1);" id="agregar_linea" name="agregar_linea">
				<img src="images/minus.png" height="24" width="24" style="cursor:pointer;" onclick="javascript:AgregarCampos(2);" id="quitar_linea" name="agregar_linea">
			</td>
			<td>
				Cantidad Imprimir <input type="text" name="cantidad" id="cantidad" size="5" maxlength="3" value="1" OnKeyPress="return Valida_Numerico(event)">
			</td>
			<td><input type="button" name="imprimir" id="imprimir" value="Imprimir" onclick="javascript:imprimir();"></td>
			<td><input type="button" name="guardar" id="guardar" value="Guardar" onclick="javascript:guardar_etiqueta();"></td>
			<td><input type="button" name="eliminar" id="eliminar" value="Eliminar" onclick="javascript:eliminar();"></td>
			<td><img src="images/home1.png" height="24px" width="24px" style="cursor:pointer;" onclick="javascript:location.href='newetiquetas_index.asp'"></td>
		</tr>
	</table>
</div>
<div id="parte_superior" name="parte_superior">
	<table name="tabla_encabezado" id="tabla_encabezado">
		<tr>
			<td><input type="hidden" name="numero_interno_etiqueta" id="numero_interno_etiqueta" value="<%=v_numero_interno_etiqueta%>"></td>
			<td>Titulo Etiqueta&nbsp;<input type="text" name="nombre_etiqueta" id="nombre_etiqueta" size="25" value="<%=rs("nombre_etiqueta")%>"></td>
			<td>
				Orientacion:&nbsp;
				<select name='orientacion' id='orientacion'>
					<option value="horizontal">Horizontal</option>
					<option value="vertical">Vertical</option>
				</select>
			</td>
		</tr>
	</table>
</div>
<div id="added" name="added">
</div>
<div id="word_preview" name="word_preview">
</div>