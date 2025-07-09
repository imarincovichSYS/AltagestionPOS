<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../_private/funciones_generales.asp" -->
<!-- #include file="../../_private/config.asp" -->
<%
OpenConn

ruta_imagen_oferta = "Ico_Cambiar_24X24.gif"

strAsunto = "Ofertas Exclusiva Sanchez & Sanchez"
strBody   =           "<style>"
strBody   = strBody & "BODY{PADDING-RIGHT: 0px;PADDING-LEFT: 0px;FONT-SIZE: 10px;PADDING-BOTTOM: 0px;MARGIN: 0px;PADDING-TOP: 0px;FONT-FAMILY: Arial, Helvetica, sans-serif, Tahoma, Verdana;}"
strBody   = strBody & "TABLE{FONT-SIZE: 10px;}"
strBody   = strBody & "</style>"
strBody   = strBody & "<table style=""width:610px;"" align=""center"" cellPadding=0 cellSpacing=0 border=0>"
strBody   = strBody & "<tr><td style=""font-size:11px; color:#222;"">Sr(a). XXX </td></tr>"
strBody   = strBody & "<tr>"
strBody   = strBody & "<td><img src=""http://www.sanchezysanchez.cl/ofertas/ofertas.jpg"" width=600 height=800 border=0></td>"
strBody   = strBody & "</tr><table>"
strBody   = strBody & "<table style=""width:610px;"" align=""center"" cellPadding=0 cellSpacing=0 border=0>"
strBody   = strBody & "<tr><td style=""font-size:11px; color:#222;"">El cliente debe presentar su cedula de identidad en caja antes de pasar sus productos.</td></tr>"
strBody   = strBody & "<tr><td style=""font-size:11px; color:#222;"">Las ofertas son válidas sólo para personas naturales, compras familiares. No se incluyen mayoristas y empresas.</td></tr>"
strBody   = strBody & "<tr><td style=""font-size:11px; color:#222;"">Oferta válida desde el 03 de agosto de 2013 al 11 de agosto de 2013.</td></tr>"
strBody   = strBody & "<tr><td style=""font-size:11px; color:#222;"">Estos precios no están publicados, son válidos sólo para nuestros clientes preferenciales al pasar.</td></tr>"
strBody   = strBody & "<td style=""font-size:11px; color:#222;""><br>NOTA: Este e-mail es generado en forma automática, por favor no responda a este mensaje.<br>"
strBody   = strBody & "Si no desea seguir recibiendo esta información, simplemente haga <a href=""#"">click aquí</a></td></tr>"
strBody   = strBody & "<table>"

Response.Write strBody
Response.End

'for i = 1 to 0
'  para = "c.martinez.a@gmail.com"
'  'para = "cbutendieck@sanchezysanchez.cl"
'  'para = "raravena@sanchezysanchez.cl"
'  'para = "hsola@sanchezysanchez.cl"
'  strSQL="exec usp_EnviarCorreo 'info@sanchezysanchez.cl', '"&para&"', '"&strAsunto&"', '"&strBody&"', 'HTMLBody'"
'  Conn.Execute(strSQL)
'next


Response.End
'strSQL="select entidad_comercial, Lower(mail) as email, Rtrim(Ltrim(Upper(Replace(Nombres_persona,'.','') + ' ' + Apellidos_persona_o_nombre_empresa))) as nombre " &_
'       "from entidades_comerciales where empresa='SYS' and tipo_entidad_comercial = 'C' and Mail like '%@%' " &_
'       "and entidad_comercial not in (select entidad_comercial from Vigencias_de_Listas_de_precios where lista_de_precios = 'LXMAY')"
'set rs = Conn.Execute(strSQL)
'do while not rs.EOF
'  entidad_comercial = trim(rs("entidad_comercial"))
'  strSQL="Exec VLP_Graba_vigencia_de_lista_de_precios 0, 'SYS', 'LOFERTA', '"&entidad_comercial&"', 'V', '2013/8/3', '2013/8/11', '', 0, 00"
'  Conn.Execute(strSQL)
'  rs.MoveNext
'loop
%>