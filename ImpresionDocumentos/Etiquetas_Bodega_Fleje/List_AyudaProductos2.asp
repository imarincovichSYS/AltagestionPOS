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
<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
<%
	Const adUseClient = 3
	Dim conn1
	conn1 = Session("DataConn_ConnectionString")
  cant=1
  i=1
  for i=1 to Request("Lineas")
    if Request("Ajuste_"&i)="on" then
     Puerto1 = "LPT1"
     for cant=1 to Request("Cant_"&i)
       Etiqueta = Etiqueta & "^XA^Fo420,30^ARN,80,50^FD" & Request("Codigo_antiguo_"&i) &  " ^FS"  & _
       "^FO20,115^A0,145,145^FD" & Request("Producto_"&i) & "^FS" &_
       "^Fo500,170^ARN,2,2^FD" & Request(""&i) & "^FS" &_  
       "^FO20,340^A0,30,30^FD" & Request("Desc_"&i) & "^FS" &_
       "^FO10,5^BEN,150^FD" & request("Codigo_Ean13_"&i) & "^FT700,70^BER,100,N" & "^FS" &_
	   "^FO20,250^A0,60,60^FD" & request("Superfamilia_"&i) & "^FS" &_
	   "^FO88,250^A0,60,60^FD" & request("Familia_"&i) & "^FS" &_
	   "^FO165,250^A0,60,60^FD" & request("Subfamilia_"&i) & "^FS" &_ 
	   "^FO283,250^A0,60,60^FD" & request("Genero_"&i) & "^FS" &_
	   "^FO340,250^A0,60,60^FD" & request("Marca_"&i) & "^FS" 
	   Etiqueta = Etiqueta & "^XZ" 
       %><br><%    
     next
    end if
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

