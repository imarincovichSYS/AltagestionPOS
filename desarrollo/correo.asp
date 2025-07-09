<!--#include file="../_private/config.asp" -->
<%
openconn

srv = Request.ServerVariables("HTTP_HOST")

sql = "Exec usp_EnviarCorreo 'info@sanchezysanchez.cl','imarincovich@sanchezysanchez.cl,jandreuzzi@sanchezysanchez.cl','Prueba envio ASP de correo 110' ,'<b>Prueba envio ASP de correo!! 0.2</b>' , 'HTMLBody'"
Conn.Execute(sql)

%>



