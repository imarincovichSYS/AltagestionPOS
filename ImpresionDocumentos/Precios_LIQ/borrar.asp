<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.inc" -->
<!-- #include file="../../Scripts/Inc/Caracteres.inc" -->
<!-- #include file="../../Scripts/Inc/Montoescrito.Inc" -->
<%
	Cache
%>
<% Session.LCID = 11274 %>

<html>
	<head>
		<title><%=session("title")%></title>
		<link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
		<script src="../../Scripts/Js/Caracteres.js"></script>
	</head>
<body >
<%
	Const adUseClient = 3
	Dim conn1
	
	response.write "HOLA"
   response.end 
	'conn1 = Session("DataConn_ConnectionString")
'cant=1
'i=1
'for i=1 to Request("Lineas")
  'if Request("Ajuste_"&i)="on" then
    'if Request("fleje_"&i)="Fleje" then
     '' IF Request("oferta_"&i)<>"on" then 'EL PRECIO ES FLEJE NORMAL
        Puerto1 = "LPT1"
      '' for cant=1 to Request("Cant_"&i)
          'if Request("Precio_"&i) >= 100000 then      
             x = 1
             for i = 1 to 433
              if X > 999 then
                Etiqueta = Etiqueta & "^XA^FWB^FO100,0^A0,170,150^FD "&X&" ^FS"                
                Etiqueta = Etiqueta & "^FWB^FO350,0^A0,170,150^FD "&X + 1&" ^FS"                
                Etiqueta = Etiqueta & "^FWB^FO620,0^A0,170,150^FD "&X + 2&" ^FS"
              elseif X > 99 then
                Etiqueta = Etiqueta & "^XA^FWB^FO100,40^A0,170,150^FD "&X&" ^FS"                
                Etiqueta = Etiqueta & "^FWB^FO350,40^A0,170,150^FD "&X + 1&" ^FS"                
                Etiqueta = Etiqueta & "^FWB^FO620,40^A0,170,150^FD "&X + 2&" ^FS"
              else
                Etiqueta = Etiqueta & "^XA^FWB^FO100,110^A0,170,150^FD "&X&" ^FS"                
                Etiqueta = Etiqueta & "^FWB^FO350,110^A0,170,150^FD "&X + 1&" ^FS"                
                Etiqueta = Etiqueta & "^FWB^FO620,110^A0,170,150^FD "&X + 2&" ^FS"              
              end if
                
                
                Etiqueta = Etiqueta & "^XZ"
                
                
                X = X + 3 
                
             next 
             
%>   

</body>
</html>

<OBJECT classid="CLSID:B829BCD0-3892-11D3-A519-0000216ABE11" 
codebase="../../Impresion/Impresora.CAB#version=2,0,0,1" 
id=Locales style="LEFT: 0px; TOP: 0px">
<PARAM NAME="_ExtentX" VALUE="503">
<PARAM NAME="_ExtentY" VALUE="503">
</OBJECT>

<Script language="VBScript">
If Locales.InicioImpresion("<%=Puerto1%>") then
  Locales.imprimir "<%=Etiqueta%>"
  Locales.FinImpresion
end if
If Locales.InicioImpresion("<%=Puerto3%>") then
  Locales.imprimir "<%=Etiqueta3%>"
  Locales.FinImpresion
end if
If Locales.InicioImpresion("<%=Puerto2%>") then
  Locales.imprimir "<%=Etiqueta2%>"
  Locales.FinImpresion
End if
Locales.FinImpresion

</Script>

