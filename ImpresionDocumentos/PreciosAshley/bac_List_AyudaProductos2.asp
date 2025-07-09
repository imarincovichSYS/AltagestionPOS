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
    if Request("fleje_"&i)="Fleje" then
      IF Request("oferta_"&i)<>"on" then 'EL PRECIO ES FLEJE NORMAL
        Puerto1 = "LPT1"
        for cant=1 to Request("Cant_"&i)
          if Request("Precio_"&i) >= 100000 then      
              Etiqueta = Etiqueta & "^XA^FO230,30^ARN,160,165^FD" & Request("Precio_"&i) &  " ^FS"  & _
              "^FO390,170^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" & _
              "^FO170,220^A0,20,20^FD" & Request("Desc_"&i) & "^FS"
              if Request("PMay_"&i) >0 then
                  Etiqueta = Etiqueta & "^FO230,20^A0,20,20^FD" & formatNumber(Request("PMay_"&i),0) & "^FS"
                  Etiqueta = Etiqueta & "^FO230,40^A0,20,20^FD" & formatNumber(Request("CMay_"&i),0) & "^FS"
              end if
              if Request("grs_"&i) > 0 then 
                   Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xKilo " & formatNumber((Request("Precio_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xLitro " & formatNumber((Request("Precio_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta = Etiqueta & "^XZ" 
          elseif Request("Precio_"&i) < 1000 then
              Etiqueta = Etiqueta & "^XA^FO320,20^ARN,175,180^FD" & Request("Precio_"&i) &  " ^FS"  & _
              "^FO400,170^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" &_ 
              "^FO190,215^A0,20,20^FD" & Request("Desc_"&i) & "^FS"
              '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
              ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
              if cdbl(Request("PMay_"&i)) >0 then
		              Etiqueta = Etiqueta & "^FO720,240^A0,25,25^FD" & formatNumber(Request("PMay_"&i),0) & "^FS"
                  Etiqueta = Etiqueta & "^FO720,260^A0,25,25^FD" & formatNumber(Request("CMay_"&i),0) & "^FS"
              end if
              if Request("grs_"&i) > 0 then 
                   Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xKilo " & formatNumber((Request("Precio_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta = Etiqueta & "^FO390,245^A0,20,20^FD Pr.xLitro " & formatNumber((Request("Precio_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta = Etiqueta & "^XZ"
          elseif Request("Precio_"&i) >= 1000 and  Request("Precio_"&i) < 10000 then      
              Etiqueta = Etiqueta & "^XA^FO235,20^ARN,175,180^FD" & Request("Precio_"&i) &  " ^FS"  & _
              "^FO350,170^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" & _
              "^FO188,215^A0,20,20^FD" & Request("Desc_"&i) & "^FS"  
              if Request("PMay_"&i) >0 then
                  Etiqueta = Etiqueta & "^FO720,240^A0,25,25^FD" & formatNumber(Request("PMay_"&i),0) & "^FS"
                  Etiqueta = Etiqueta & "^FO720,260^A0,25,25^FD" & formatNumber(Request("CMay_"&i),0) & "^FS"
              end if
              if Request("grs_"&i) > 0 then 
                   Etiqueta = Etiqueta & "^FO355,245^A0,20,20^FD Pr.xKilo " & formatNumber((Request("Precio_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta = Etiqueta & "^FO355,245^A0,20,20^FD Pr.xLitro " & formatNumber((Request("Precio_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta = Etiqueta & "^XZ" 
          else
              Etiqueta = Etiqueta & "^XA^FO210,20^ARN,175,180^FD" & Request("Precio_"&i) &  " ^FS"  & _
              "^FO350,170^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" & _
              "^FO188,215^A0,20,20^FD" & Request("Desc_"&i) & "^FS"  
              if Request("PMay_"&i) >0 then
                  Etiqueta = Etiqueta & "^FO710,240^A0,25,25^FD" & formatNumber(Request("PMay_"&i),0) & "^FS"
                  Etiqueta = Etiqueta & "^FO710,260^A0,25,25^FD" & formatNumber(Request("CMay_"&i),0) & "^FS"
              end if
              if Request("grs_"&i) > 0 then 
                   Etiqueta = Etiqueta & "^FO355,245^A0,20,20^FD Pr.xKilo " & formatNumber((Request("Precio_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta = Etiqueta & "^FO355,245^A0,20,20^FD Pr.xLitro " & formatNumber((Request("Precio_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta = Etiqueta & "^XZ" 
          end if        
          %><br><%    
        next
      ELSE 'EL PRECIO ES FLEJE OFERTA
        if request.servervariables("REMOTE_ADDR") = "192.168.4.176" or request.servervariables("REMOTE_ADDR") = "192.168.4.132" then
          Puerto2 = "LPT1"
        else
          Puerto2 = "LPT2"
        end if
        for cant=1 to Request("Cant_"&i)
          if Request("Prom_"&i) >= 100000 then      
              Etiqueta2 = Etiqueta2 & "^XA^FO230,40^ARN,160,165^FD" & Request("Prom_"&i) &  " ^FS"  & _
              "^FO390,180^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" & _
              "^FO190,230^A0,20,20^FD" & Request("Desc_"&i) & "^FS"
              if Request("PMay_"&i) >0 then
                  Etiqueta2 = Etiqueta2 & "^FO450,30^A0,20,20^FD" & formatNumber(Request("PMay_"&i),0) & "^FS"
                  Etiqueta2 = Etiqueta2 & "^FO450,50^A0,20,20^FD" & formatNumber(Request("CMay_"&i),0) & "^FS"
              end if
              if Request("grs_"&i) > 0 then 
                   Etiqueta2 = Etiqueta2 & "^FO390,255^A0,20,20^FD Pr.xKilo " & formatNumber((Request("Prom_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta2 = Etiqueta2 & "^FO390,255^A0,20,20^FD Pr.xLitro " & formatNumber((Request("Prom_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta2 = Etiqueta2 & "^XZ" 
          elseif Request("Prom_"&i) < 1000 then
              Etiqueta2 = Etiqueta2 & "^XA^FO320,40^ARN,175,180^FD" & Request("Prom_"&i) &  " ^FS"  & _
              "^FO400,190^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" &_ 
              "^FO190,235^A0,20,20^FD" & Request("Desc_"&i) & "^FS"
              '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
              ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
              if Request("PMay_"&i) >0 then
                  Etiqueta2 = Etiqueta2 & "^FO710,260^A0,25,25^FD" & formatNumber(Request("PMay_"&i),0) & "^FS"
                  Etiqueta2 = Etiqueta2 & "^FO710,280^A0,25,25^FD" & formatNumber(Request("CMay_"&i),0) & "^FS"
              end if
              if Request("grs_"&i) > 0 then 
                   Etiqueta2 = Etiqueta2 & "^FO390,265^A0,20,20^FD Pr.xKilo " & formatNumber((Request("Prom_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta2 = Etiqueta2 & "^FO390,265^A0,20,20^FD Pr.xLitro " & formatNumber((Request("Prom_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta2 = Etiqueta2 & "^XZ"
          elseif Request("Prom_"&i) >= 1000 and  Request("Prom_"&i) < 10000 then      
              Etiqueta2 = Etiqueta2 & "^XA^FO235,40^ARN,175,180^FD" & Request("Prom_"&i) &  " ^FS"  & _
              "^FO350,190^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" & _
              "^FO188,235^A0,20,20^FD" & Request("Desc_"&i) & "^FS"  
              if Request("PMay_"&i) >0 then
                  Etiqueta2 = Etiqueta2 & "^FO710,260^A0,25,25^FD" & formatNumber(Request("PMay_"&i),0) & "^FS"
                  Etiqueta2 = Etiqueta2 & "^FO710,280^A0,25,25^FD" & formatNumber(Request("CMay_"&i),0) & "^FS"
              end if
              if Request("grs_"&i) > 0 then 
                   Etiqueta2 = Etiqueta2 & "^FO355,265^A0,20,20^FD Pr.xKilo " & formatNumber((Request("Prom_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta2 = Etiqueta2 & "^FO355,265^A0,20,20^FD Pr.xLitro " & formatNumber((Request("Prom_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta2 = Etiqueta2 & "^XZ" 
          else
              Etiqueta2 = Etiqueta2 & "^XA^FO220,40^ARN,175,180^FD" & Request("Prom_"&i) &  " ^FS"  & _
              "^FO350,190^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" & _
              "^FO188,235^A0,20,20^FD" & Request("Desc_"&i) & "^FS"  
              if Request("PMay_"&i) >0 then
                  Etiqueta2 = Etiqueta2 & "^FO710,260^A0,25,25^FD" & formatNumber(Request("PMay_"&i),0) & "^FS"
                  Etiqueta2 = Etiqueta2 & "^FO710,280^A0,25,25^FD" & formatNumber(Request("CMay_"&i),0) & "^FS"
              end if
              if Request("grs_"&i) > 0 then 
                   Etiqueta2 = Etiqueta2 & "^FO355,265^A0,20,20^FD Pr.xKilo " & formatNumber((Request("Prom_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta2 = Etiqueta2 & "^FO355,265^A0,20,20^FD Pr.xLitro " & formatNumber((Request("Prom_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta2 = Etiqueta2 & "^XZ" 
          end if        
          %><br><%    
        next
      END IF
    else 'EL PRECIO ES GANCHO
      if Request("oferta_"&i)<>"on" then 'ES GANCHO NORMAL
        if request.servervariables("REMOTE_ADDR") = "192.168.4.176" or request.servervariables("REMOTE_ADDR") = "192.168.4.132" then
          Puerto3 = "LPT1"
        else
          Puerto3 = "LPT3"
        end if
        for cant=1 to Request("Cant_"&i)
          if Request("Precio_"&i) >= 10000 then
              Etiqueta3 = Etiqueta3 & "^XA^FO95,20^ARN,130,135^FD" & Request("Precio_"&i) &  " ^FS"  & _
              "^FO200,150^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" &_ 
              "^FO65,190^A0,17,17^FD" & Request("Desc_"&i) & "^FS"
              if Request("grs_"&i) > 0 then 
                   Etiqueta3 = Etiqueta3 & "^FO200,220^A0,17,17^FD Pr.xKilo " & formatNumber((Request("Precio_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta3 = Etiqueta3 & "^FO200,220^A0,17,17^FD Pr.xLitro " & formatNumber((Request("Precio_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta3 = Etiqueta3 & "^XZ"
          elseif Request("Precio_"&i) < 1000 then
              Etiqueta3 = Etiqueta3 & "^XA^FO140,20^ARN,155,160^FD" & Request("Precio_"&i) &  " ^FS"  & _
              "^FO180,150^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" &_ 
              "^FO65,190^A0,17,17^FD" & Request("Desc_"&i) & "^FS"
              '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
              ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
              'if Request("PMay_"&i) >0 then
              ''    Etiqueta = Etiqueta & "^FO750,240^A0,25,25^FD" & formatNumber(Request("PMay_"&i),0) & "^FS"
              ''    Etiqueta = Etiqueta & "^FO750,260^A0,25,25^FD" & formatNumber(Request("CMay_"&i),0) & "^FS"
              'end if
              if Request("grs_"&i) > 0 then 
                   Etiqueta3 = Etiqueta3 & "^FO200,220^A0,17,17^FD Pr.xKilo " & formatNumber((Request("Precio_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta3 = Etiqueta3 & "^FO200,220^A0,17,17^FD Pr.xLitro " & formatNumber((Request("Precio_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta3 = Etiqueta3 & "^XZ"           
          else
              Etiqueta3 = Etiqueta3 & "^XA^FO120,20^ARN,140,135^FD" & Request("Precio_"&i) &  " ^FS"  & _
              "^FO180,150^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" &_ 
              "^FO65,190^A0,17,17^FD" & Request("Desc_"&i) & "^FS"
              if Request("grs_"&i) > 0 then 
                   Etiqueta3 = Etiqueta3 & "^FO200,220^A0,17,17^FD Pr.xKilo " & formatNumber((Request("Precio_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta3 = Etiqueta3 & "^FO200,220^A0,17,17^FD Pr.xLitro " & formatNumber((Request("Precio_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta3 = Etiqueta3 & "^XZ"          
          end if        
          %><br><%    
        next
      ELSE        'EL GANCHO ES OFERTA
        if request.servervariables("REMOTE_ADDR") = "192.168.4.176" or request.servervariables("REMOTE_ADDR") = "192.168.4.132" then
          Puerto2 = "LPT1"
        else
          Puerto2 = "LPT2"
        end if
        for cant=1 to Request("Cant_"&i)
          if Request("Prom_"&i) >= 10000 then
              Etiqueta2 = Etiqueta2 & "^XA^FO95,40^ARN,130,135^FD" & Request("Prom_"&i) &  " ^FS"  & _
              "^FO200,160^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" &_ 
              "^FO65,210^A0,17,17^FD" & Request("Desc_"&i) & "^FS"
              if Request("grs_"&i) > 0 then 
                   Etiqueta2 = Etiqueta2 & "^FO200,230^A0,17,17^FD Pr.xKilo " & formatNumber((Request("Prom_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta2 = Etiqueta2 & "^FO200,230^A0,17,17^FD Pr.xLitro " & formatNumber((Request("Prom_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta2 = Etiqueta2 & "^XZ"
          elseif Request("Prom_"&i) < 1000 then
              Etiqueta2 = Etiqueta2 & "^XA^FO140,40^ARN,155,160^FD" & Request("Prom_"&i) &  " ^FS"  & _
              "^FO180,160^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" &_ 
              "^FO65,210^A0,17,17^FD" & Request("Desc_"&i) & "^FS"
              '"^FO3,180^BEN,50,N,N^FD" & request("Codigo_Ean13_"&i) & "^FS"
              ''"^FO10,5^BEN,80^FD" & request("Codigo_Ean13_"&i) & "^FT450,80^BER" & "^FS"
              'if Request("PMay_"&i) >0 then
              ''    Etiqueta = Etiqueta & "^FO750,240^A0,25,25^FD" & formatNumber(Request("PMay_"&i),0) & "^FS"
              ''    Etiqueta = Etiqueta & "^FO750,260^A0,25,25^FD" & formatNumber(Request("CMay_"&i),0) & "^FS"
              'end if
              if Request("grs_"&i) > 0 then 
                   Etiqueta2 = Etiqueta2 & "^FO200,230^A0,17,17^FD Pr.xKilo " & formatNumber((Request("Prom_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta2 = Etiqueta2 & "^FO200,230^A0,17,17^FD Pr.xLitro " & formatNumber((Request("Prom_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta2 = Etiqueta2 & "^XZ"           
          else
              Etiqueta2 = Etiqueta2 & "^XA^FO120,40^ARN,140,135^FD" & Request("Prom_"&i) &  " ^FS"  & _
              "^FO180,160^ARN,2,2^FD" & Request("Producto_"&i) & "^FS" &_ 
              "^FO65,210^A0,17,17^FD" & Request("Desc_"&i) & "^FS"
              if Request("grs_"&i) > 0 then 
                   Etiqueta2 = Etiqueta2 & "^FO200,230^A0,17,17^FD Pr.xKilo " & formatNumber((Request("Prom_"&i)*1000)/Request("grs_"&i),0) & "^FS"
              elseif Request("cc_"&i) > 0 then
                   Etiqueta2 = Etiqueta2 & "^FO200,230^A0,17,17^FD Pr.xLitro " & formatNumber((Request("Prom_"&i)*1000)/Request("cc_"&i),0) & "^FS"
              end if
              Etiqueta2 = Etiqueta2 & "^XZ"          
          end if        
          %><br><%    
        next
      END IF
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

