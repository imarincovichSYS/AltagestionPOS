<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
Cache

Set Conn = Server.CreateObject("ADODB.Connection")
Conn.Open Session( "DataConn_ConnectionString" )
Conn.CommandTimeout = 3600
    
Error = "N"
MsgError = ""
    
Login = Request("Usuario")
Clave = Request("Clave")
Session("Supervisor_elimina") = ""
Session("autorizadopor") = ""


'Verificar si clave seguridad corresponde al codigo de seguridad del supervisor
strSQL="select entidad_comercial from entidades_comerciales with(nolock) where empresa='sys' and " &_
       "codigo_seguridad='"&Left(Login,12)&"' and clave_seguridad='"&Clave&"'"
Set rs = Conn.Execute(strSQL)
if not rs.EOF then
  Session("Supervisor_elimina") = Login
  Session("autorizadopor") = trim(rs("entidad_comercial"))
else
  Error = "S"
  MsgError = "Supervisor o clave incorrecta"
end if    
Rs.Close
Set Rs = Nothing
Conn.Close
    
if Error = "N" then
  Response.Write "S|" & MsgError 'Si es supervisor(a)
else
  Response.Write "N|" & MsgError 'No lo es
end if      
%>
