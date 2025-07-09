<!-- #include file="../../Scripts/Inc/MontoEscrito.Inc" -->
<!-- #include file="../../Scripts/Inc/caracteres.Inc" -->
<HTML>

<body leftmargin=0 topmargin=0 background="../../<%=Session("ImagenFondo")%>">
   <OBJECT id=Locales style="LEFT: 0px; TOP: 0px" codeBase=http://altanet1/Epysa/impresion/Impresora.CAB#version=1,1,0,2 
	height=19 width=19 classid="CLSID:EFF5C013-BD27-11D2-9689-0080ADB4B9A9">
	<PARAM NAME="_ExtentX" VALUE="503">
	<PARAM NAME="_ExtentY" VALUE="503"></OBJECT>

   
   <Script language="VBScript">

j=0

<% 	        

SET Conn = Server.CreateObject("ADODB.Connection")
Conn.Open Session("Dataconn_ConnectionString")							  
Conn.commandtimeout=600


Nro_int = Request("NroInt")  

Arreglo_Nro_int = split(Nro_int,"|")

Empresa	= session ( "Empresa_usuario" )

'response.write(Nro_int)
for i=0 to ubound(Arreglo_Nro_int) -1
	Sql = "Exec DOV_Rescata_DV_por_NumeroInterno "  & Arreglo_Nro_int(i) 

'Response.Write Sql
		SET RsUpdate	=	Conn.Execute( SQL )
		If Not RsUpdate.eof then
			Numero				                    = RsUpdate ( "Numero_documento_valorizado" )
			Fecha         		                    = RsUpdate ( "Fecha_emision" )
			Fecha_vencimiento	                    = RsUpdate ( "Fecha_vencimiento" )
			Nombre		         		            = RsUpdate ( "Nombre" )
			Numero_documento_valorizado         	= RsUpdate ( "Numero_documento_valorizado" )
			Empresa         		                = RsUpdate ( "Empresa" )
			Direccion         						= RsUpdate ( "Direccion" )
			Moneda_documento		         		= RsUpdate ( "Moneda_documento" )
			Moneda_nominal_documento         		= RsUpdate ( "Moneda_nominal_documento" )
			if Moneda_nominal_documento = "$" then
				Monto_nominal_documento		         	= round(RsUpdate ( "Monto_nominal_documento" ),0)
				Montos									= split(formatnumber(round(Monto_nominal_documento,0),0),",")
				Partentera								= replace(Montos(0),",","")
				Decimales								= 0
			else
				Monto_nominal_documento		         	= RsUpdate ( "Monto_nominal_documento" )
				Montos									= split(formatnumber(Monto_nominal_documento,2),",")
				Partentera								= replace(Montos(0),",","")
				Decimales								= Montos(1)
			end if
			'Enteros									= split(Monto_nominal_documento,",")
			'Partentera								= Enteros(0)
			'Decimales								= Enteros(1)
			Comuna									= RsUpdate ( "Comuna" )
			Ciudad									= RsUpdate ( "Ciudad" )
			RUT										= RsUpdate ( "RUT" )
		else
			RegistroExistente		= "N"
		end if
		RsUpdate.Close
		'Conn.Close  		
		set RsUpdate=nothing
		
%>



	linea = space(80)
	linea= mid(linea,1,70) & <%=Numero%>
	Locales.InicioImpresion("LPT1")
'Locales.InicioImpresion("<%=session("impresora_FAV")%>")  
'Locales.InicioImpresion("\\michilla\HPDeskJe") 
'Dim puerto
'if Locales.ElegirImpresora(puerto) then
'Locales.InicioImpresion(puerto) 
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	linea = space(80)
	linea= mid(linea,1,84) & space(4) & "<%=formatnumber(Monto_nominal_documento,2)%>"
	Locales.Imprimir (Linea)
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	linea = space(80)
	linea= mid(linea,1,20) & cdbl(j)+1 & "         " & "<%=ubound(Arreglo_Nro_int)%>" & space(25) & "<%=day(fecha)%>" & "      " & "<%=Ucase(monthName(month(fecha)))%>" & space(27 - <%=len(trim(monthName(month(fecha))))%>) & "<%=year(fecha)%>"
	Locales.Imprimir (Linea)
	Locales.Imprimir (" ")
	linea = space(80)
	linea= mid(linea,1,20) & "<%=day(fecha_vencimiento)%>" & "  de  " & "<%=Ucase(monthName(month(fecha_vencimiento)))%>" & " de  " & "<%=year(fecha_vencimiento)%>"
	Locales.Imprimir (Linea)
	
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir ("                         <%=mid(Escribir(Partentera),1,50)%> -")
	Locales.Imprimir (" ")
	<%if Moneda_documento = "$" then%>
		Locales.Imprimir ("               <%=mid(Escribir(Partentera),51)%> PESOS")
	<%else%>
		Locales.Imprimir ("               <%=mid(Escribir(Partentera),51)%> COMA <%=decimales%>/100 <%if moneda_documento = "US$" then response.write("DOLARES") else response.write("Unidades de Fomento") end if%>")
	<%end if%>
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")
	Locales.Imprimir (" ")

	Linea = space(80)
	Linea = space(20) & "<%=Mid(Nombre,1,50)%>"   
	Locales.Imprimir (Linea)
	Locales.Imprimir (" ")
	Linea = space(80)
	Linea = space(20) & "<%=Mid(Direccion,1,50)%>"  
	Locales.Imprimir (Linea)
	Locales.Imprimir (" ")
	Linea = space(80)
	Linea = space(20) & "<%=Mid(Comuna,1,15)%>"   & space(25 - len(trim("<%=Mid(Comuna,1,15)%>"))) & "   " & "<%=Mid(Ciudad,1,30)%>"
	Locales.Imprimir (Linea)
	Locales.Imprimir (" ")
	Linea = space(80)
	Linea = space(20) & "<%=Mid(RUT,1,20)%>"   
	Locales.Imprimir (Linea)

	j=j+1
'	if j=2 then
'		j=0
'		Locales.Imprimir (chr(12))
'	else
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
		Locales.Imprimir (" ")
'	end if
	Locales.FinImpresion	
<%next
Conn.Close%>
'end if
 </Script>

<BR>
<BR>
<center><font color="RED" face="arial" size="6"><b>
	&nbsp;Imprimiendo ...
		</b>
	</font></center>
<script language="javascript">
function salir()
{
	if( '<%=request("Reimpresion")%>' == 'S')
	{
		parent.top.frames[3].location.href = "../../mensajes.asp?Msg=Documento Nº <%=Numero%> se está imprimiendo";
	}
	else
	{
		//parent.top.frames[1].reset();
		//parent.top.frames[1].location.href = "main_EmisionLetra.asp";
		parent.top.frames[2].location.href = "Botones_EmisionLetra.asp";
	}
}
</script>
</body>
</HTML>
