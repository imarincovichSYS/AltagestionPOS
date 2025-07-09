<!-- #include file ="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/Fechas.Inc" -->
<%

objId = Request( "objId" )
objSel = Request( "objSel" )
objVal = Request( "objVal" )
objCad = Request( "objCad" )
objObj = Request( "objObj" )

'********************************************
'Parametros visualización valores ocultos
'********************************************
mostrar_valores = false
'mostrar_valores = true
'********************************************
Cache

if len(trim( Session( "DataConn_ConnectionString") )) = 0 then%>
<script language=javascript>
		parent.top.location.href = "../../index.htm"
	</script>
<%
end if

On Error Resume Next

set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.CommandTimeout = 3600

FechaActual = year( now() ) & "/" & right("00" & month( now() ),2) & "/" & right("00" & day( now() ) ,2)

set conn1 = server.createobject("ADODB.Connection")
conn1.open session("DataConn_ConnectionString")
Conn1.CommandTimeout = 3600

Imagen_actual = "../../imagenes/productos/noimagen.gif"
MensajeError = ""
Nombre = ""
Precio = ""

if Vacio(Request("Accion")) then
   Accion_a_ejecutar = "*"
else
   Accion_a_ejecutar = Request("Accion")
end if

Set Rs = Conn.Execute("EXEC DCA_RescataUltimoDolarCambio")
         
if not Rs.EOF then
  DolarCambioSupervisoraCajas = CDbl(rs("Valor_Dolar"))
else
  DolarCambioSupervisoraCajas = 1
end if

Rs.close
set Rs = nothing

'***************************************************
'---------------- Funciones   ----------------------
%>
<!-- #include file ="Pagos_PuntoVentaZF_Funciones.asp" -->
<%
'***************************************************

if Session("Muestra_descuentos") = "" then
   Session("Muestra_descuentos") = "No"
end if

if Accion_a_ejecutar = "Descuentos" then
   if Session("Muestra_descuentos") = "Si" then
      Session("Muestra_descuentos") = "No"
   else
      Session("Muestra_descuentos") = "Si"
  end if
end if

'Folio de factura
if Session("Tipo_documento_venta") = "FAV" then
   Folio_disponible = clng( "0" & request("Folio_factura") )
   if not vacio(Accion_a_ejecutar) and Accion_a_ejecutar = "Terminar" then
      if Folio_ingresado <> 0 then
         Folio_inicial = 0
         Folio_final = 0
         Set Rs = Conn.Execute("EXEC PUN_Consulta_folio_factura '" & Session("empresa_usuario") & "','" & Session("Login") & "',0" & Folio_disponible )
         if Rs.EOF then
            MensageError = "El folio ingresado no está asignado a la cajera actual o no existe."
         end if
         Rs.close
         set Rs = nothing
      elseif Folio_ingresado = 0 then
         MensageError = "Debe ingresar un folio para imprimir la factura"
      else
         Set Rs = Conn.Execute("EXEC PUN_Consulta_existe_factura '" & Session("empresa_usuario") & "',0" & Folio_disponible)
         if not Rs.EOF then
            MensageError = "Ya existe la factura en el sistema."
         end if
         Rs.close
         set Rs = nothing
      end if
   elseif Folio_disponible = 0 then
      Set Rs = Conn.Execute("EXEC PUN_Consulta_folio_disponible '" & Session("empresa_usuario") & "','" & Session("Login") & "'")
      if Not Rs.EOF then
         Folio_disponible = cdbl( "0" & rs("Folio_actual") )
         if Folio_disponible = 0 then
            Folio_disponible = cdbl( "0" & rs("Folio_inicial") )
         end if
      end if
      Rs.close
      set Rs = nothing
   end if
end if


'Tiene derecho al descuento ?
Admite_descuento = true
for n = 1 to cint( request("Numero_documentos_cobro") )
    if instr(1,Session("Documentos_sin_descuento"),Saca(request("Tipo_documento_cobro_" & n ),";") ) > 0 then
       Admite_descuento = false
       exit for
    end if
next

v_tipEntComer = Session("tipo_entidad_comercial")
v_clasDeEmpleado = Session("clasificacion_de_empleado")
'if v_tipEntComer = "A" or v_tipEntComer = "E" or v_tipEntComer = "U" then Admite_descuento = false
if (v_tipEntComer = "A" and v_clasDeEmpleado <> "") or v_tipEntComer = "E" or v_tipEntComer = "U" then Admite_descuento = false

'Descuento documento
Descuento_documento = request("Descuento_documento")
if len(trim(Descuento_documento)) > 0 then
    if IsNumeric(Descuento_documento) and Session("Permite_hacer_descuento_empleado") Then
        Descuento_documento = Cdbl(Descuento_documento)
    else
        Descuento_documento = 0
    end if
else
    Descuento_documento = 0
end if

Error_descuento_documento = ""
if Descuento_documento > Session("Maximo_descuento_cabecera") then
   Error_descuento_documento = "Sobrepasa descuento máximo documento"
   MensajeError = Error_descuento_documento
end if

' Determinando el número de documentos de cobro
Numero_documentos_cobro = cint( request("Numero_documentos_cobro") )
if Accion_a_ejecutar = "EliminaDocumentoCobro" then
   Numero_documentos_cobro = Numero_documentos_cobro - 1
end if


'*************************************************************************
'---------------- Chequeo de precios y descuentos   ----------------------
%>
<!-- #include file ="Pagos_PuntoVentaZF_ChequeaPreciosYDsctos.asp" -->
<%
'*************************************************************************
'total_productos viene del include anterior
if total_productos = 1 and (temporada="XMAY" or temporada="PATG" or temporada="NOV" or temporada="CHAO") then Admite_descuento = false 
if total_productos = 0 then Admite_descuento = false 'No se han pasado productos por caja, nose puede habilitar descuento a cero productos

Muestra_Mayorista       = false
'if Session("Cliente_boleta") <> "CLI_BOLETA" and (v_tipEntComer <> "A" and v_tipEntComer <> "E" and v_tipEntComer <> "U") then
if Session("Cliente_boleta") <> "CLI_BOLETA" then
  if v_tipEntComer = "C" or (v_tipEntComer = "A" and v_clasDeEmpleado = "") then
    v_num_int_DVT_activa	  = Get_Numero_Interno_DVT_Activa_X_Login(Session("Login"))
    v_existe_prod_mayorista	= Existe_Producto_Mayorista_En_Lista_DVT(v_num_int_DVT_activa)
    if v_existe_prod_mayorista then
      Total_Precio_Mayoristas = Get_Total_Precio_Mayoristas_Lista_DVT(v_num_int_DVT_activa)
      if cdbl(Session("BASETOTMAY")) > cdbl(Total_Precio_Mayoristas) then 
        Muestra_Mayorista = true
        Total_Pesos_Incluye_Mayorista = Total_Pesos
        Total_Precio_Normal           = Get_Total_Precio_Normal_Lista_DVT(v_num_int_DVT_activa)
      end if
    end if
  end if
end if

'***************************************************************************
'------------------ Chequeo Documentos y  Montos de Cobro-------------------
%>
<!-- #include file ="Pagos_PuntoVentaZF_ChequeaCobros.asp" -->
<%
'***************************************************************************
'***************************************************************************
'---------------------- Terminar Boleta ------------------------------------
%>
<!-- #include file ="Pagos_PuntoVentaZF_TerminarBoleta.asp" -->
<%
'***************************************************************************

Session("MensajeError") = LimpiaError(MensajeError)
if len(trim(Session("MensajeError"))) > 0 then MensajeError = "ERROR : " & left( Session("MensajeError") , 35 )
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Pagos Punto de Venta</title>
  <link rel="stylesheet" type="text/css" href="../../CSS/Estilos.css">	
	<script src="../../Scripts/Js/Fechas.js"></script>
	<script src="../../Scripts/Js/Numerica.js"></script>
	<script src="../../Scripts/Js/Caracteres.js"></script>
    <script src="../../js/jquery-1.7.2.min.js"></script>
</head>
<body leftmargin=0 topmargin=0 text="#000000" onload="documentReady()">

<form name="formulario" method="post" action="Pagos_PuntoVentaZF.asp">
<input type="hidden" name="objId" id="objId" value="<% = objId %>">
<input type="hidden" name="objSel" id="objSel" value="<% = objSel %>">
<input type="hidden" name="objVal" id="objVal" value="<% = objVal %>">
<input type="hidden" name="objCad" id="objCad" value="<% = objCad %>">
<input type="hidden" name="objObj" id="objObj" value="<% = objObj %>">
<input type="hidden" name="Accion" id="Accion" value="">

<input type="hidden" id="tecla">
<input type="hidden" name="Numero_documentos_cobro" id="Numero_documentos_cobro" value="<%=Numero_documentos_cobro%>">
<%
delta=14
ancho_caja_bg_derecha=974

Total_dolares = int(Total_pesos / DolarCambioSupervisoraCajas)+1
'***************************************************
'---------------- Cabecera   -----------------------
%><!-- #include file ="Pagos_PuntoVentaZF_Cabecera.asp" --><%
'***************************************************
%>
<%if not Imprimir_boleta and not Imprimir_factura then%>
<%
'***************************************************
'---------------- Documentos   ---------------------
%><!-- #include file ="Pagos_PuntoVentaZF_Documentos.asp" --><%
'***************************************************
'--------- Ecncabezado Listado productos   ---------
%><!-- #include file ="Pagos_PuntoVentaZF_EncListado.asp" --><%
'***************************************************
%>
<div style="position:absolute; overflow:auto; top:315px; left:<%=28-delta%>px; width=<%=ancho_caja_bg_derecha%>px; height=168px; background-color: #999966;" >

<%if Admite_descuento and Session("Muestra_descuentos") = "Si" then
'***************************************************************************
'---------------- Listado con input para descuentos   ----------------------
%><!-- #include file ="Pagos_PuntoVentaZF_ListadoDescuentos.asp" --><%
'***************************************************************************
else
'***************************************************************************
'---------------- Listado con input para descuentos   ----------------------
%><!-- #include file ="Pagos_PuntoVentaZF_ListadoNormal.asp" --><%
'***************************************************************************
end if%>
</div>
<%end if%>

<input type="hidden" id="Vendedor" name="Vendedor" value="<% = Session( "Vendedor" ) %>">
<input type="hidden" id="FechaDespacho" name="FechaDespacho" value="<% = Session( "FechaDespacho" ) %>">

</form>
</body>

    <script type='text/javascript'>
        /* onLoad */
        $(document).ready(function () {
			//alert( document.getElementById("Tipo_documento_cobro_1").selectedIndex );
			//alert( document.getElementById("Tipo_documento_cobro_1").value );
			
			objCad = $("#objCad").val();
			objSel = $("#objSel").val();
			objVal = $("#objVal").val();
			objObj = $("#objObj").val();
			objObj = "<% = Numero_documentos_cobro %>";

			arrayDoc = objCad.split(';');
			cadDelete = "";
			for ( kk = 0; kk < arrayDoc.length - 1; kk++ ) {
				arrayData = arrayDoc[kk].split(':');
				
				idPag = arrayData[0].replace("[","");
				idInd = arrayData[1];
				idNum = arrayData[2].replace("]","");
				cadDelete += idPag + "_" + idInd + "_;";
				
				objId = "Tipo_documento_cobro_" + idPag;
				document.getElementById(objId).selectedIndex = idInd; 
				if ( (kk+1) != objObj) {
					document.getElementById(objId).setAttribute("disabled","disabled");
				}

				objFecha = "#Fecha_documento_cobro_" + idPag;
				objBanco = "#Banco_documento_cobro_" + idPag;
				objNumero = "#Numero_documento_cobro_" + idPag;
				objAdic = "#Numero_documentos_adicionales";
				if (parseFloat(idNum) != 0) {
					$(objFecha).css("display", "none");
					$(objBanco).css("display", "none");
					$(objNumero).css("display", "none");
					$(objAdic).css("display", "none");
				}
				else {
					$(objFecha).css("display", "block");
					$(objBanco).css("display", "block");
					$(objNumero).css("display", "block");
					$(objAdic).css("display", "block");
				}
			}
			
			if (false) {
				objId = "Tipo_documento_cobro_" + objObj;
				arrayDel = cadDelete.split(';');
				for ( i = 0; i < arrayDel.length - 1; i++ ) {
					arrayData = arrayDel[i].split('_');

					if (false) {
						document.getElementById(objId).options[arrayData[1]].text = "";
						document.getElementById(objId).options[arrayData[1]].value = "";
					}

					if (false) {
						x = document.getElementById(objId); 
						if (x != null) {
							//if ( arrayDoc.length - 1 != objObj) {
								x.remove(arrayData[1]);
							//}
						}
					}
				}
			}
			
        });
        // onLoad
    </script>

</html>
<%
conn.close
set conn = nothing
conn1.close
set conn1 = nothing
'***************************************************
'---------------- Funciones Javascript  ----------------------
%><!-- #include file ="Pagos_PuntoVentaZF_JavaScript.asp" --><%
'***************************************************
%>
