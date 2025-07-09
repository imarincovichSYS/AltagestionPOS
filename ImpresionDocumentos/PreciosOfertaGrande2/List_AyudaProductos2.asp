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
        Puerto1 = "LPT1"
        for cant=1 to Request("Cant_"&i)
          precio  = formatNumber(Request("Precio_"&i),0)
          if Request("prom_"&i) > 0 then
            precio  = formatNumber(Request("prom_"&i),0)
          end if
          if precio >= 100000 then  
            Etiqueta = Etiqueta & "^XA^FO120,450^ARN,270,230^FD" & precio &  " ^FS"  & _
            "^FO80,770^A0,30,30^FD" & Request("Desc_"&i) & "^FS" &_
            "^FO630,820^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
            if Request("grs_"&i) > 0 then 
                 Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xKilo " & formatNumber((precio*1000)/Request("grs_"&i),0) & "^FS"
            elseif Request("cc_"&i) > 0 then
                 Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xLitro " & formatNumber((precio*1000)/Request("cc_"&i),0) & "^FS"
            end if
            Etiqueta = Etiqueta & "^XZ"  
          elseif precio < 1000 then
            Etiqueta = Etiqueta & "^XA^FO220,440^ARN,300,300^FD" & precio &  " ^FS"  & _
            "^FO80,770^A0,30,30^FD" & Request("Desc_"&i) & "^FS" &_
            "^FO610,815^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"    
          if Request("grs_"&i) > 0 then 
               Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xKilo " & formatNumber((precio*1000)/Request("grs_"&i),0) & "^FS"
          elseif Request("cc_"&i) > 0 then
               Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xLitro " & formatNumber((precio*1000)/Request("cc_"&i),0) & "^FS"
          end if
          Etiqueta = Etiqueta & "^XZ"
          elseif precio >= 1000 and  precio < 10000 then 
            Etiqueta = Etiqueta & "^XA^FO160,450^ARN,290,290^FD" & Precio &  " ^FS"  & _
            "^FO80,770^A0,30,30^FD" & Request("Desc_"&i) & "^FS" &_
            "^FO610,815^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
            if Request("grs_"&i) > 0 then 
                 Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xKilo " & formatNumber((Precio*1000)/Request("grs_"&i),0) & "^FS"
            elseif Request("cc_"&i) > 0 then
                 Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xLitro " & formatNumber((Precio*1000)/Request("cc_"&i),0) & "^FS"
            end if
            Etiqueta = Etiqueta & "^XZ"
          else
            Etiqueta = Etiqueta & "^XA^FO130,450^ARN,280,263^FD" & Precio &  " ^FS"  & _
            "^FO80,770^A0,30,30^FD" & Request("Desc_"&i) & "^FS" &_
            "^FO630,820^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
            '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
            ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
            if Request("grs_"&i) > 0 then 
                 Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xKilo " & formatNumber((Precio*1000)/Request("grs_"&i),0) & "^FS"
            elseif Request("cc_"&i) > 0 then
                 Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xLitro " & formatNumber((Precio*1000)/Request("cc_"&i),0) & "^FS"
            end if
            Etiqueta = Etiqueta & "^XZ"  
          end if        
          %><br><%    
        next    
    else
        Puerto1 = "LPT1"
        for cant=1 to Request("Cant_"&i)
          precio  = formatNumber(Request("Precio_"&i),0)
          if Request("prom_"&i) > 0 then
            precio  = formatNumber(Request("prom_"&i),0)
          end if
          if precio >= 100000 then
              Etiqueta = Etiqueta & "^XA^FO120,400^ARN,270,230^FD" & precio &  " ^FS"  & _
              "^FO80,710^A0,30,30^FD" & Request("Desc_"&i) & "^FS" &_
              "^FO610,755^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
              '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
              ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
              if Request("grs_"&i) > 0 then 
                   Etiqueta = Etiqueta & "^FO610,650^A0,20,20^FD Pr.xKilo " & formatNumber((precio*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta = Etiqueta & "^FO610,650^A0,20,20^FD Pr.xLitro " & formatNumber((precio*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta = Etiqueta & "^XZ"  
          elseif precio < 1000 then
              Etiqueta = Etiqueta & "^XA^FO220,380^ARN,300,300^FD" & precio &  " ^FS"  & _
              "^FO80,710^A0,30,30^FD" & Request("Desc_"&i) & "^FS" &_
              "^FO610,755^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
              '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
              ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
              if Request("grs_"&i) > 0 then 
                   Etiqueta = Etiqueta & "^FO610,650^A0,20,20^FD Pr.xKilo " & formatNumber((precio*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta = Etiqueta & "^FO610,650^A0,20,20^FD Pr.xLitro " & formatNumber((precio*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta = Etiqueta & "^XZ"
          elseif precio >= 1000 and  precio < 10000 then     
              Etiqueta = Etiqueta & "^XA^FO160,400^ARN,290,290^FD" & precio &  " ^FS"  & _
              "^FO80,710^A0,30,30^FD" & Request("Desc_"&i) & "^FS" &_
              "^FO610,755^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
              '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
              ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
              if Request("grs_"&i) > 0 then 
                   Etiqueta = Etiqueta & "^FO610,650^A0,20,20^FD Pr.xKilo " & formatNumber((precio*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta = Etiqueta & "^FO610,650^A0,20,20^FD Pr.xLitro " & formatNumber((precio*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta = Etiqueta & "^XZ"
          else
              Etiqueta = Etiqueta & "^XA^FO130,400^ARN,280,263^FD" & precio &  " ^FS"  & _
              "^FO80,710^A0,30,30^FD" & Request("Desc_"&i) & "^FS" &_
              "^FO610,755^ARN,2,2^FD" & Request("Producto_"&i) & "^FS"               
              '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
              ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
              if Request("grs_"&i) > 0 then 
                   Etiqueta = Etiqueta & "^FO610,650^A0,20,20^FD Pr.xKilo " & formatNumber((precio*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta = Etiqueta & "^FO610,650^A0,20,20^FD Pr.xLitro " & formatNumber((precio*1000)/Request("cc_"&i),0) & "^FS"
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

