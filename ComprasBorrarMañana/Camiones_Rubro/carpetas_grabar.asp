<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_sys.asp" -->
<%
accion              = Request.Form("accion")
documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")
nom_campo           = Request.Form("nom_campo")
valor               = Request.Form("valor")
nom_tabla           = "carpetas_final"
fec_anio_mes = anio & "/" & mes & "/1"
OpenConn
if accion = "insertar" then
  nuevo_num_carpeta = Get_Nuevo_Numero_Carpeta_X_Fec_Anio_y_Mes(documento_respaldo,fec_anio_mes)
  '####################################################################################################
  'Crear el directorio físico que almacenará todos los documentos de esta nueva carpeta
  'Set fso = CreateObject("Scripting.FileSystemObject")
  'RutaFISICA_Carpetas = Request.ServerVariables("APPL_PHYSICAL_PATH") & "Compras\Carpetas\Documentos\"
  'carpeta = anio & "-" & mes & "_" & num_carpeta
  'directorio = RutaFISICA_Carpetas & carpeta
  'if Not fso.FolderExists(directorio) then Set fol = fso.CreateFolder(directorio)
  'TODOS LOS ARCHIVOS SE ALMACENAN EN LA CARPETA "filesUpload" (raiz del proyecto)
  '####################################################################################################
  'Crear los registros de gastos por defecto (tipos de gastos fijos: fijo=1)
  strSQL="insert into carpetas_final_gastos(documento_respaldo, anio_mes,num_carpeta,id_gasto) " &_
         "(select '"&documento_respaldo&"', '"&fec_anio_mes&"',"&nuevo_num_carpeta&",id_gasto from tb_gastos where fijo=1)"
  'Response.Write strSQL
  'Response.End
  set rs = Conn.Execute(strSQL)
  '------------------------- registro encabezado carpeta ------------------------
  strSQL="insert into "&nom_tabla&"(documento_respaldo, anio_mes,num_carpeta) " &_
         "values('"&documento_respaldo&"','"&fec_anio_mes&"',"&nuevo_num_carpeta&")"
  Response.Write nuevo_num_carpeta
elseif accion = "actualizar" then
  if nom_campo="fecha_salida" then valor = year(cdate(valor)) & "/" & month(cdate(valor)) & "/" & day(cdate(valor))
  strSQL="update "&nom_tabla&" set "&nom_campo&"='"&valor&"' " &_
         "where documento_respaldo='"&documento_respaldo&"' and anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta
elseif accion = "eliminar" then
  'Chequear que la carpeta no esté asociada a ninguna RCP o TCP
  strSQL="select carpeta from documentos_no_valorizados " &_
         "where empresa='SYS' and (documento_no_valorizado='RCP' or documento_no_valorizado='TCP') and " &_
         "carpeta='"&documento_respaldo&"-"&anio&"-"&cint(mes)&"-"&num_carpeta&"'"
  'Response.Write strSQL
  set rs_existe = Conn.Execute(strSQL)
  if not rs_existe.EOF then 
    Response.Write "CARPETA_ASOCIADA"
    Response.End
  end if
  
  'Eliminar todos los gastos asociados a la carpeta
  strSQL="delete carpetas_final_gastos " &_
         "where documento_respaldo='"&documento_respaldo&"' and anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta
  'Response.Write strSQL
  set rs = Conn.Execute(strSQL)
  '------------------------------------------------
  'Eliminar todos los archivos adjuntados en gastos asociados a la carpeta (POR AHORA SE DEJAN LOS ARCHIVOS)
  strSQL=""
  'Response.Write strSQL
  'set rs = Conn.Execute(strSQL)
  '------------------------------------------------
  'Eliminar encabezado de carpeta
  strSQL="delete "&nom_tabla&" " &_
         "where documento_respaldo='"&documento_respaldo&"' and anio_mes='"&fec_anio_mes&"' and num_carpeta="&num_carpeta
end if
'Response.Write strSQL
set rs = Conn.Execute(strSQL)
%>