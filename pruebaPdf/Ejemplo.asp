<%@language=vbscript%>
<!--#include file="../_private/fpdf.asp"-->
<%

strTipoDocumento = request("strTipoDocumento")
strFecha = request("strFecha")
strCodigo = request("strCodigo")
strNombreCliente = request("strNombreCliente")
strCIF = request("strCIF")
strDireccion = request("strDireccion")
strProvincia = request("strProvincia")
strCodigoPostal = request("strCodigoPostal")
strPoblacion = request("strPoblacion")
strTel = request("strTel")
strFax = request("strFax")
strFormaPago = request("strFormaPago")
strDesc = request("strDesc")
lngUnidades = Replace(request("lngUnidades"),",",".")
lngImporteUnidad = Replace(request("lngImporteUnidad"),",",".")
lngIVA = Replace(request("lngIVA"),",",".")
lngNumLineas = request("lngNumLineas")

Sub CrearCarpeta(Anyo, Documento)

	strDirDestino = Server.MapPath(LCase(Documento) & "S\Documentos\"& CStr(Anyo))
		dim fs,f
		set fs=Server.CreateObject("Scripting.FileSystemObject")
		if not fs.FolderExists(strDirDestino) then
			set f=fs.CreateFolder(strDirDestino)
		end if
	
	set f=nothing
	set fs=nothing

end sub 

Sub EscribeCabeceraDoc

	'Logo Disoltec
	strLogo = "LogoDisoltec.jpg"
	pdf.Image strLogo,10,10,40,30

	'Factura, fecha
	pdf.SetFont "Arial","BI",16
	pdf.SetXY -70, 10
	pdf.Cell 100,10,UCase(strTipoDocumento)
	pdf.SetXY -70, 20
	pdf.SetFont "Arial","B",14
	pdf.Cell 260,10,strCodigo
	pdf.SetXY -70, 30
	pdf.SetFont "Arial","",14
	pdf.Cell 130,10,"Fecha:   " & strFecha

	strAnyo=""
	If strFecha <> "" Then strAnyo = CStr(Year(strFecha))

	'Datos Cliente
	pdf.SetXY 10, 45
	pdf.SetFont "Arial","B",14
	pdf.SetDrawColor 100,100,100
	pdf.Cell 190,36,"",1
	pdf.SetFont "Arial","B",14
	pdf.SetTextColor 0,0,0
	pdf.Text 12, 53, "CLIENTE"
	pdf.SetFont "Arial","",11
	pdf.Text 12, 58, strNombreCliente
	pdf.SetFont "Arial","",8
	pdf.Text 12, 62, "CIF/NIF " & strCIF
	pdf.Text 12, 66, strDireccion
	pdf.Text 12, 70, strProvincia
	pdf.Text 12, 74, strCodigoPostal & " " & strPoblacion
	pdf.Text 12, 78, "Tel. " & strTel & " Fax " & strFax

	'Conceptos factura
	pdf.SetTextColor 100,100,100
	pdf.SetFont "Arial","B",11
	pdf.Text 10, 87, "CONCEPTOS"

	'Cabecera tabla
	pdf.SetXY 10, 88
	pdf.SetDrawColor 100,100,100
	pdf.Cell 190,6,"",1
	pdf.SetTextColor 0,0,0
	pdf.SetFont "Arial","B",8
	pdf.Text 12, 92, "Ref." 
	pdf.Text 24, 92, "Descripción"
	pdf.Text 140, 92, "Cantidad"
	pdf.Text 157, 92, "Precio"
	pdf.Text 172, 92, "% IVA"
	pdf.Text 189, 92, "Total"
End Sub

Sub EscribeNumPagina
	pdf.SetFont "Arial","",8
	pdf.Text 100, 289, CStr(pdf.PageNo())
End sub

clv1 = request("clv1")

Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF()
pdf.SetPath("../_private/fpdf/")
pdf.SetFont "Arial","BI",16
pdf.Open()
pdf.AddPage()
'pdf.SetXY 10, 10

'Escribimos la cabecera del documento
EscribeCabeceraDoc

	If lngNumLineas = "" Then lngNumLineas = 1

 If lngNumLineas <> "" Then

	If IsNumeric(lngNumLineas) Then
		lngNumLineas = CDbl(lngNumLineas)
	Else
		lngNumLineas = 1
	End If 

	'If lngNumLineas > 100 Then
'		lngNumLineas = 100 
	'End If 
	
	lngPosSigLinea = 98 'Inicio
	lngPosLinea = 98

	For j = 1 To CInt(lngNumLineas)
		
		'Hacemos más páginas (no cabe)
		If lngPosLinea > 185 Then 'Salir de esta y hacer segunda página de factura
			'Escribimos y salimos de la página
			pdf.SetFont "Arial","I",11
			pdf.Text 100, lngPosLinea+10, " ... SIGUE EN LA PÁGINA SIGUIENTE ... -->"
			EscribeNumPagina
			pdf.AddPage()
			EscribeCabeceraDoc
			lngPosSigLinea = 98 'Inicio
			lngPosLinea = 98
		End If
	
		strRef = j
		If IsNull(lngUnidades) Or not IsNumeric(lngUnidades)  Then lngUnidades = 0
		If IsNull(lngImporteUnidad) Or not IsNumeric(lngImporteUnidad)  Then lngImporteUnidad = 0		
		lngImporteLinea = Round(lngUnidades * lngImporteUnidad,2)
		If IsNull(lngIVA) Or not IsNumeric(lngIVA)  Then lngIVA = 0
		lngImporteIVA = Round(lngUnidades * lngImporteUnidad * lngIVA / 100,2)
		lngImporteLinea = lngImporteLinea + lngImporteIVA

		TotalImporteIVA = TotalImporteIVA + lngImporteIVA
		TotalImporteLinea = TotalImporteLinea + lngImporteLinea

		'Falta formato numeros y alinearlos a la derecha

		'Lineas Documento
		pdf.SetFont "Arial","",8
		pdf.Text 12, lngPosLinea, "00030" 
		'Mirar el tamaño de la descripcion de factura y dividirla en varias lineas
		lngTamMax = 106
		lngTamDesc = pdf.GetStringWidth(strDesc)
		
		'Recortamos en varias lineas si la descripción es muy larga, siempre usando espacio entre palabras
		If lngTamDesc > lngTamMax Then 
			strAux = strDesc
			lngAux = Len(strAux)
			i = 0
			intPos_old = 0
			While (lngAux > 0) and (lngTamDesc > lngTamMax) and (i < 1000)
				intPos = InStr(intPos_old + 1,strAux," ")
				If intPos < lngAux And intPos > 1 Then
					lngTamDesc = pdf.GetStringWidth(Left(strAux,intPos))
					If lngTamDesc > lngTamMax Then 'El anterior era el ultimo espacio, cortamos texto
						pdf.Text 24, lngPosSigLinea, Left(strAux,intPos_old)
						strAux = Right(strAux,lngAux-intPos_old)
						intPos = 0
						lngPosSigLinea = lngPosSigLinea + 3
					End If 
				Else
					lngAux = 0
				End If 
				lngAux = Len(strAux)
				lngTamDesc = pdf.GetStringWidth(strAux)
				intPos_old = intPos
				i = i + 1
			Wend 
			'lngPosSigLinea = lngPosSigLinea + 3
			pdf.Text 24, lngPosSigLinea, strAux
		Else 'Se pone tal cual
			pdf.Text 24, lngPosLinea, strDesc
		End If
		'Con lngTamNum y lngPosX conseguimos que los numericos salgan alineados a la derecha, 
		'se hace igual en todas las posiciones donde haya numericos
		lngTamNum = pdf.GetStringWidth(FORMATNUMBER(lngUnidades, 2, true, false, true))
		lngPosX = 151 - lngTamNum
		pdf.Text lngPosX, lngPosLinea, FORMATNUMBER(lngUnidades, 2, true, false, true) 
		lngTamNum = pdf.GetStringWidth(FORMATNUMBER(lngImporteUnidad, 2, true, false, true))
		lngPosX = 166 - lngTamNum
		pdf.Text lngPosX, lngPosLinea, FORMATNUMBER(lngImporteUnidad, 2, true, false, true)
		lngTamNum = pdf.GetStringWidth(FORMATNUMBER(lngIVA, 1, true, false, true))
		lngPosX = 181 - lngTamNum
		pdf.Text lngPosX, lngPosLinea, FORMATNUMBER(lngIVA, 1, true, false, true)
		lngTamNum = pdf.GetStringWidth(FORMATNUMBER(lngImporteLinea, 2, true, false, true))
		lngPosX = 198 - lngTamNum
		pdf.Text lngPosX, lngPosLinea, FORMATNUMBER(lngImporteLinea, 2, true, false, true)

		'Nueva linea
		lngPosLinea = lngPosSigLinea + 5
		lngPosSigLinea = lngPosSigLinea + 5
	
	Next 

End If

'Resto de lineas (controlar ancho de texto para cortar lineas, con función GetStringWidth(string s) devuelve anchura
pdf.Line 10,197,200,197

'Forma de pago, impuestos, totales
pdf.SetTextColor 100,100,100
pdf.SetFont "Arial","B",11
pdf.Text 10, 205, "FORMA DE PAGO"
pdf.Text 62, 205, "IMPUESTOS"
pdf.Text 142, 205, "TOTALES"

'Dibujo de cajas
pdf.SetXY 10, 206
pdf.SetDrawColor 100,100,100
pdf.Cell 48,6,"",1
pdf.SetXY 60, 206
pdf.Cell 78,6,"",1
pdf.SetXY 140, 206
pdf.Cell 60,30,"",1
pdf.Line 142,226,198,226

'Datos de totales etc ...
pdf.SetTextColor 0,0,0
pdf.SetFont "Arial","",8
pdf.Text 12, 210, strFormaPago
pdf.SetFont "Arial","B",8
pdf.Text 62, 210, "Base de IVA"
pdf.SetFont "Arial","",8
lngTamNum = pdf.GetStringWidth(FORMATNUMBER(TotalImporteLinea, 2, true, false, true))
lngPosX = 92 - lngTamNum
pdf.Text lngPosX, 210, FORMATNUMBER(TotalImporteLinea, 2, true, false, true)
pdf.SetFont "Arial","B",8
pdf.Text 94, 210, "% IVA"
pdf.SetFont "Arial","",8
lngTamNum = pdf.GetStringWidth(FORMATNUMBER(lngIVA, 1, true, false, true))
lngPosX = 110 - lngTamNum
pdf.Text lngPosX, 210, FORMATNUMBER(lngIVA, 1, true, false, true)
pdf.SetFont "Arial","B",8
pdf.Text 114, 210, "Cuota"
pdf.SetFont "Arial","",8
lngTamNum = pdf.GetStringWidth(FORMATNUMBER(TotalImporteIVA, 2, true, false, true))
lngPosX = 135 - lngTamNum
pdf.Text lngPosX, 210, FORMATNUMBER(TotalImporteIVA, 2, true, false, true)
pdf.SetFont "Arial","B",8
pdf.Text 142, 214, "Neto"
pdf.Text 142, 220, "Total IVA"
pdf.Text 142, 232, "TOTAL Euro"

pdf.SetFont "Arial","B",10
lngTamNum = pdf.GetStringWidth(FORMATNUMBER(TotalImporteLinea, 2, true, false, true))
lngPosX = 191 - lngTamNum
pdf.Text lngPosX, 214, FORMATNUMBER(TotalImporteLinea, 2, true, false, true)
lngTamNum = pdf.GetStringWidth(FORMATNUMBER(TotalImporteIVA, 2, true, false, true))
lngPosX = 191 - lngTamNum
pdf.Text lngPosX, 220, FORMATNUMBER(TotalImporteIVA, 2, true, false, true)
lngTamNum = pdf.GetStringWidth(FORMATNUMBER((CDbl(TotalImporteLinea) + CDbl(TotalImporteIVA)), 2, true, false, true))
lngPosX = 191 - lngTamNum
pdf.Text lngPosX, 232, FORMATNUMBER((CDbl(TotalImporteLinea) + CDbl(TotalImporteIVA)), 2, true, false, true) 

'Datos cuenta Bancaria
pdf.SetFont "Arial","",8
pdf.Text 10, 220, "Cheque o pagaré nominativo a Neptuno S.L. o"
pdf.Text 10, 224, "Transferencia bancaria a Neptuno S.L. "
pdf.SetFont "Arial","",10
pdf.Text 10, 231, "BANCO URANO"
pdf.Text 10, 236, "9999 9999 99 9999999999"

'Texto datos fiscales
pdf.SetFont "Arial","",6
pdf.Text 10, 256, "Los datos fiscales del emisor (Neptuno S.L.) constan en el margen izquierdo"
pdf.Text 10, 259, "de la factura. la sociedad está inscrita en el Registro de Europs, Tomo 9999, Libro 9999"
pdf.Text 10, 262, "Folio 999, Sección 9, hoja V999999, Inscripción 9ª"

pdf.Text 10, 266, "CIF: B96990099. Domicilio: C/ Marte s/n. 99999 Plutón (Júpiter)"
pdf.Text 10, 269,  "Web: www.disoltec.es . Mail: disoltec@disoltec.es . Tel. 961173342. Fax 969999999"

'Num Pagina
pdf.SetFont "Arial","",8
pdf.Text 100, 289, CStr(pdf.PageNo())

If strAnyo = "" Then strAnyo = CStr(Year(Date()))

'Creamos carpeta para el año si no existia ya
'CrearCarpeta strAnyo, strTipoDocumento

strCodigo = Replace(strCodigo,"/","-")

'Guardamos factura y redirigimos a la misma (por la noche borrar temporal)
pdf.Output (server.MapPath("Documento.pdf")),True
'pdf.Output (Server.MapPath(LCase(strTipoDocumento) & "S/Documentos/"& CStr(strAnyo) & "/" & strCodigo & ".pdf")),True 
pdf.Close()

response.redirect "Documento.pdf"
'response.redirect LCase(strTipoDocumento) & "S/Documentos/"& CStr(strAnyo) & "/" & strCodigo & ".pdf"

'pdf.Output()

%> 

