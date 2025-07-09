<!-- #include file="../../Scripts/Inc/Cache.Inc" -->

<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
'conexión para obtener el puerto en Parámetros'
set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 3600

MensajeError = ""

'on error resume next

Puerto = "COM1"
Puerto = trim( replace( ucase( Puerto ) , "COM" , "" ) )

cSql_1 = "EXEC PUN_Consulta_cliente '" & session("login") & "'"
Set Rs_1 = Conn.Execute ( cSql_1 )

Nombre_cajero = left(Rs_1("Apellidos_persona_o_nombre_empresa") + " " + Rs_1("Nombres_persona"), 40)

Conn.Close

Fiscal_actual = request("Fiscal_actual")

%>



