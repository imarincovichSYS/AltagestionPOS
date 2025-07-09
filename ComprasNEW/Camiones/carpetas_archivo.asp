<%@ Language=VBScript %>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
documento_respaldo  = Request.QueryString("documento_respaldo")
anio                = Request.QueryString("anio")
mes                 = Request.QueryString("mes")
num_carpeta         = Request.QueryString("num_carpeta")
id_gasto            = Request.QueryString("id_gasto")
nom_campo           = Request.QueryString("nom_campo")
msg_accion          = Request.QueryString("msg_accion")
%>
<head>
<link rel="stylesheet" href="<%=RutaProyecto%>/css/style.css" type="text/css">
<script language="JavaScript" src="<%=RutaProyecto%>js/tools.js"></script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<form name="formArchivo" id="formArchivo" method="post" enctype="multipart/form-data">
<tr>
  <td width="370" id="td_accion_file" name="td_accion_file" align="right">Seleccione un archivo:&nbsp;</td>
  <td><input Onchange="Subir_Archivo();" title="Agregar Archivo (Excel, Word, Power Point)" id="text_FILE" name="archivo" 
  type="file" onkeypress="return false;"></input>
  </td>
</tr>
</form>
</table>
<script language="JavaScript">
function Subir_Archivo(){
  if(Filtrar_Archivo(document.formArchivo.archivo.value))
  {
    parent.bot_cancelar_load_file.disabled        = true
    parent.document.body.style.cursor             = "wait"
    document.body.style.cursor                    = "wait"
    document.formArchivo.archivo.style.visibility = "hidden"
    td_accion_file.innerHTML ="<font color='#CCCCCC'><b>Subiendo archivo, espere un momento...</b></font>&nbsp;&nbsp;<img src='<%=RutaProyecto%>imagenes/new_loader.gif' align='middle' width='32' height='32' border='0'>"
    anio_tmp        = "<%=anio%>"
    mes_tmp         = "<%=mes%>"
    num_carpeta_tmp = "<%=num_carpeta%>"
    id_gasto_tmp    = "<%=id_gasto%>"
    nom_campo_tmp   = "<%=nom_campo%>"
    extension       = document.formArchivo.archivo.value.slice(document.formArchivo.archivo.value.indexOf(".")).toLowerCase();
    //alert("carpetas_archivo_subir.asp?anio="+anio_tmp+"&mes="+mes_tmp+"&num_carpeta="+num_carpeta_tmp+"&id_gasto="+id_gasto_tmp+"&nom_campo="+nom_campo_tmp+"&extension="+escape(extension))
    document.formArchivo.action="carpetas_archivo_subir.asp?documento_respaldo="+documento_respaldo+"&anio="+anio_tmp+
    "&mes="+mes_tmp+"&num_carpeta="+num_carpeta_tmp+"&id_gasto="+id_gasto_tmp+"&nom_campo="+nom_campo_tmp+"&extension="+escape(extension)
    document.formArchivo.submit()
  }
  else
  {
    alert("Sólo se pueden agregar archivos gif o jpg!")
    document.formArchivo.reset()
  }
}
<%if msg_accion="ok" then%>
  //Archivo subido al servidor
  parent.Load_File_OK()
  parent.bot_cancelar_load_file.disabled=false
  parent.document.body.style.cursor=""
<%elseif error="error" then%>
  alert("ERROR: el archivo no se pudo subir al servidor!")
<%end if%>
</script>
</body>