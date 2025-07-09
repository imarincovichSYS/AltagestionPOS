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
    if Request("fleje_"&i)="Verde" then
        Puerto1 = "LPT2"
        for cant=1 to Request("Cant_"&i)
          precio  = formatNumber(Request("Precio_"&i),0)
          if Request("prom_"&i) > 0 then
            precio  = formatNumber(Request("prom_"&i),0)
          end if
          Marca = trim(left(request("Marca_"&i),7))
		      Linea1 = trim(left(request("Desc_"&i),25))
			    Linea2 = Trim(Left(mid(request("Desc_"&i),25,25),24))
          if precio >= 100000 then  
            Etiqueta = Etiqueta & "^XA^FO120,450^ARN,270,230^FD" & precio &  " ^FS"  & _
			"^FO30,750^A0,30,30^FD" & Marca & "^FS" &_
            "^FO220,750^A0,30,30^FD" & Linea1 & "^FS" &_
			"^FO220,780^A0,30,30^FD" & Linea2 & "^FS" &_
            "^FO610,810^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
            if Request("grs_"&i) > 0 then 
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xKilo " & formatNumber((precio*1000)/Request("grs_"&i),0) & "^FS"
            elseif Request("cc_"&i) > 0 then
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xLitro " & formatNumber((precio*1000)/Request("cc_"&i),0) & "^FS"
            end if
            Etiqueta = Etiqueta & "^XZ"  
          elseif precio < 1000 then
            Etiqueta = Etiqueta & "^XA^FO220,440^ARN,300,300^FD" & precio &  " ^FS"  & _
           	"^FO30,750^A0,30,30^FD" & Marca & "^FS" &_
            "^FO220,750^A0,30,30^FD" & Linea1 & "^FS" &_
			"^FO220,780^A0,30,30^FD" & Linea2 & "^FS" &_
            "^FO610,810^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"    
          if Request("grs_"&i) > 0 then 
               Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xKilo " & formatNumber((precio*1000)/Request("grs_"&i),0) & "^FS"
          elseif Request("cc_"&i) > 0 then
               Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xLitro " & formatNumber((precio*1000)/Request("cc_"&i),0) & "^FS"
          end if
          Etiqueta = Etiqueta & "^XZ"
          elseif precio >= 1000 and  precio < 10000 then 
            Etiqueta = Etiqueta & "^XA^FO160,450^ARN,290,290^FD" & Precio &  " ^FS"  & _
           "^FO30,750^A0,30,30^FD" & Marca & "^FS" &_
            "^FO220,750^A0,30,30^FD" & Linea1 & "^FS" &_
			"^FO220,780^A0,30,30^FD" & Linea2 & "^FS" &_
            "^FO610,810^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
            if Request("grs_"&i) > 0 then 
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xKilo " & formatNumber((Precio*1000)/Request("grs_"&i),0) & "^FS"
            elseif Request("cc_"&i) > 0 then
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xLitro " & formatNumber((Precio*1000)/Request("cc_"&i),0) & "^FS"
            end if
            Etiqueta = Etiqueta & "^XZ"
          else
            Etiqueta = Etiqueta & "^XA^FO130,450^ARN,280,263^FD" & Precio &  " ^FS"  & _
			"^FO30,750^A0,30,30^FD" & Marca & "^FS" &_
            "^FO160,750^A0,30,30^FD" & Linea1 & "^FS" &_
			"^FO160,780^A0,30,30^FD" & Linea2 & "^FS" &_
            "^FO610,810^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
            if Request("grs_"&i) > 0 then 
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xKilo " & formatNumber((Precio*1000)/Request("grs_"&i),0) & "^FS"
            elseif Request("cc_"&i) > 0 then
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xLitro " & formatNumber((Precio*1000)/Request("cc_"&i),0) & "^FS"
            end if
            Etiqueta = Etiqueta & "^XZ"  
          end if        
          %><br><%    
        next    
    else
        Puerto1 = "LPT2"
        for cant=1 to Request("Cant_"&i)
          precio_Antes  = formatNumber(Request("Precio_"&i),0)
          if Request("prom_"&i) > 0 and Clng(Request("prom_"&i)) < Clng(Request("Precio_"&i)) then
            precio_Promocion  = formatNumber(Request("prom_"&i),0)
          end if
      Linea1 = trim(left(request("Desc_"&i),30))
      Linea2 = Trim(Left(mid(request("Desc_"&i),30,30),29))
      Marca = trim(left(request("Marca_"&i),7))
          if precio_Promocion >= 100000 then  
              Etiqueta = Etiqueta & "^XA^FO110,430^ARN,200,174^FD$" & precio_Promocion &  "^FS"  & _
              "^FO130,610^ARN,60,100^FDAntes $" & precio_Antes &  "^FS"  & _
              "^FO110,730^A0,30,30^FD" & Request("Stock_"&i) & " Unidad(es)^FS" &_
              "^FO330,730^A0,30,30^FDHasta " & Request("fecha_promocion_"&i) & " o agotar stock ^FS" &_
            "^FO50,760^A0,30,30^FD" & Marca & " " & Linea1 & "^FS" &_
            "^FO100,780^A0,30,30^FD^FS" &_ 
            "^FO600,800^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"                
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
            if Request("grs_"&i) > 0 then 
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xKilo " & formatNumber((precio_Promocion*1000)/Request("grs_"&i),0) & "^FS"
            elseif Request("cc_"&i) > 0 then
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xLitro " & formatNumber((precio_Promocion*1000)/Request("cc_"&i),0) & "^FS"
            end if
            Etiqueta = Etiqueta & "^XZ"  
          elseif precio_Promocion < 1000 then
          Linea1 = trim(left(request("Desc_"&i),43))
            Etiqueta = Etiqueta & "^XA^FO130,430^ARN,200,180^FD  $" & precio_Promocion &  " ^FS"  & _
              "^FO180,610^ARN,60,90^FDAntes $" & precio_Antes &  "^FS"  & _
              "^FO110,730^A0,30,30^FD" & Request("Stock_"&i) & " Unidad(es)^FS" &_
              "^FO330,730^A0,30,30^FDHasta " & Request("fecha_promocion_"&i) & " o agotar stock ^FS" &_
            "^FO50,760^A0,30,30^FD" & Marca & " " & Linea1 & "^FS" &_
            "^FO100,780^A0,30,30^FD^FS" &_ 
            "^FO600,800^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"                
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"    
          if Request("grs_"&i) > 0 then 
               Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xKilo " & formatNumber((precio_Promocion*1000)/Request("grs_"&i),0) & "^FS"
          elseif Request("cc_"&i) > 0 then
               Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xLitro " & formatNumber((precio_Promocion*1000)/Request("cc_"&i),0) & "^FS"
          end if
          Etiqueta = Etiqueta & "^XZ"
          elseif precio_Promocion >= 1000 and  precio_Promocion < 10000 then 
            Linea1 = trim(left(request("Desc_"&i),43))
            Etiqueta = Etiqueta & "^XA^FO130,430^ARN,200,180^FD $" & precio_Promocion &  " ^FS"  & _
              "^FO175,610^ARN,60,100^FDAntes $" & precio_Antes &  "^FS"  & _
              "^FO110,730^A0,30,30^FD" & Request("Stock_"&i) & " Unidad(es)^FS" &_
              "^FO330,730^A0,30,30^FDHasta " & Request("fecha_promocion_"&i) & " o agotar stock ^FS" &_
            "^FO50,760^A0,30,30^FD" & Marca & " " & Linea1 & "^FS" &_ 
            "^FO100,780^A0,30,30^FD^FS" &_ 
            "^FO600,800^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"   esto en lin 136  " & Linea2 & "
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
            if Request("grs_"&i) > 0 then 
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xKilo " & formatNumber((precio_Promocion*1000)/Request("grs_"&i),0) & "^FS"
            elseif Request("cc_"&i) > 0 then
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xLitro " & formatNumber((precio_Promocion*1000)/Request("cc_"&i),0) & "^FS"
            end if
            Etiqueta = Etiqueta & "^XZ"
          else
            Linea1 = trim(left(request("Desc_"&i),43))
             Etiqueta = Etiqueta & "^XA^FO130,430^ARN,200,170^FD $" & precio_Promocion &  " ^FS"  & _
            "^FO130,610^ARN,60,90^FDAntes $" & precio_Antes &  "^FS"  & _
            "^FO110,730^A0,30,30^FD" & Request("Stock_"&i) & " Unidad(es)^FS" &_
            "^FO330,730^A0,30,30^FDHasta " & Request("fecha_promocion_"&i) & " o agotar stock ^FS" &_
            "^FO50,760^A0,30,30^FD" & Marca & " " & Linea1 & "^FS" &_
            "^FO100,780^A0,30,30^FD^FS" &_ 
            "^FO600,800^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"                
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
            if Request("grs_"&i) > 0 then 
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xKilo " & formatNumber((precio_Promocion*1000)/Request("grs_"&i),0) & "^FS"
            elseif Request("cc_"&i) > 0 then
                 Etiqueta = Etiqueta & "^FO630,680^A0,20,20^FD Pr.xLitro " & formatNumber((precio_Promocion*1000)/Request("cc_"&i),0) & "^FS"
            end if
            Etiqueta = Etiqueta & "^XZ"  
          end if        
          %><br><%    
        next    
    end if
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
'If Locales.InicioImpresion("LPT1") then
  Locales.imprimir "<%=Etiqueta%>"
  Locales.FinImpresion
end if
If Locales.InicioImpresion("<%=Puerto3%>") then
  Locales.imprimir "<%=Etiqueta3%>"
  Locales.FinImpresion
'Else
''  Msgbox "Verifique el estado de la impresora",16,"Error" 	
End if
Locales.FinImpresion

</Script>

