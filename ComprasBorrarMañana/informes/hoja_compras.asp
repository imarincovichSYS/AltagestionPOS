<%@ Language=VBScript %>
<%Response.Buffer = true%>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/files.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%  
Server.ScriptTimeout=2000
strMes        = getMes(month(date()))
nom_informe   = "hoja_compras"
Set ExcelApp  = CreateObject("Excel.Application")        
Set ExcelBook = ExcelApp.Workbooks.Open(RutaProyecto&"compras/informes/plantillas/"&nom_informe&".xls")
 
'ExcelBook.Worksheets(nom_hoja).range("B2")="1"

'*******************************************************************************
'---------------------------- GENERAR EL ARCHIVO .XLS --------------------------
'*******************************************************************************
'File = GenerateName(nom_informe&"_"&strMes)
File = nom_informe
'Archivo =  Server.Mappath(RutaInf) & "\" &File& ".xls"
'do while FileExists(Archivo)  'Dara vueltas hasta encontrar un Nombre Unico
'  File = GenerateName(nom_informe&"_"&strMes)
'  Archivo =  Server.Mappath(RutaInf) & "\" &File& ".xls"
'loop
'ExcelBook.SaveAs Archivo
ExcelApp.Application.Quit
Set ExcelApp = Nothing 
Response.Redirect RutaProyecto&"tmp/"&File&".xls"
%>