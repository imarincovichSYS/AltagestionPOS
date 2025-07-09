<%
   Sub AbrirConeccion( StringConeccion )
    Dim Conn 
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open StringConeccion
	Conn.commandtimeout = 100	
   End Sub

   Function CerrarConeccion()
	Conn.Close()
	Set Conn = Nothing
   End Function

'***********************************************************************************************

   Function AbrirConexion( StringConeccion )
    Dim Conneccion 
	Set Conneccion = Server.CreateObject("ADODB.Connection")
	Conneccion.Open StringConeccion
	Conneccion.commandtimeout = 100
    Set AbrirConexion = Conneccion	
   End Function

   Function CerrarConexion( Obj )
	Obj.Close()
	Set Obj = Nothing
   End Function

'***********************************************************************************************

%>
