<!-- #include file="../../Scripts/Inc/Caracteres.inc" -->
<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<%
Cache
Session("xObservaciones") = ""
Session("xBloqueado") = "N"
Session("xEconomato") = ""
Session("xMulticredito") = ""

ModoVendedor = "S"  ' S=Select, I=Input
Session( "Vendedor" ) = ""
Session( "FechaDespacho" ) = ""

'RESPONSE.WRITE Session("xCentro_de_venta")

'Response.Write Session("xEconomato") & " *** "

if len(trim( Session( "DataConn_ConnectionString") )) = 0 then
	Response.Redirect "../../index.htm"
end if

set conn = server.createobject("ADODB.Connection")
conn.open session("DataConn_ConnectionString")
Conn.commandtimeout = 3600

on error resume next

Function CajaConBordes(nTop,nLeft,nWidth,nHeight)
  CajaConBordes = "<div style='position:absolute; top:" & (nTop - 10) & "px; left:" & (nLeft -10) & "px; width:" & (nWidth + 20) & "px; height:" & (nHeight + 20) & "px; z-index:0' style='border: 2px #808080 solid'></div>" & chr(13) & chr(10) & _
         "<div style='position:absolute; top:" & (nTop - 2) & "px; left:" & (nLeft - 2) & "px; width:" & (nWidth + 4) & "px; height:" & (nHeight + 4) & "px; z-index:0' style='border: 1px #999999 solid'></div>" & chr(13) & chr(10) & _
         "<div style='position:absolute; top:" & nTop & "px; left:" & nLeft & "px; width:" & nWidth & "px; height:" & nHeight & "px; z-index:0' style='background-color:#CCCD94;'></div>"
  CajaConBordes = replace( CajaConBordes , "'" , chr(34) )
End Function

Function StrZero(Numero,Posiciones)
   StrZero = Right( "0000000000000000000000000000" & Numero , Posiciones)
End Function

function Get_Vendedor( Vendedor, Modo )
    IF Modo = "I" THEN
        resultado = "<input type='text' name='Vendedor' value='" & Session( "Vendedor" ) & "' size='12' maxlength='12' />"
    END IF

    IF Modo = "S" THEN
        resultado = "<select name='Vendedor' style='width: 145px; font-size: 10px;'>"
        resultado = resultado & "<option value='' selected></option>"
        SQL = "Exec ECP_ListaVendedores_Vendedor '" & Session("empresa_usuario") & "', Null, Null"
        SET rs = Conn.Execute( SQL )
        do while not rs.eof
            if ucase( Vendedor ) = ucase( rs( "Entidad_comercial" ) ) then
                resultado = resultado & "<option value='" & rs( "Entidad_comercial" ) & "' selected>" & rs( "Nombre" ) & "</option>"
            else
                resultado = resultado & "<option value='" & rs( "Entidad_comercial" ) & "'>" & rs( "Nombre" ) & "</option>"
            end if
            rs.movenext
        loop
        rs.close
        resultado = resultado & "</select>"
    END IF

	Get_Vendedor = resultado
end function


if ( Request("Accion") = "Cliente" or Request("Accion") = "Iniciar" ) and len(trim(Request("Accion"))) > 0 then
   Session("Cliente_boleta") = Request("Cliente_boleta")
   Session("Forma_pago") = Request("Forma_pago")

    Session( "Vendedor" ) = Request("Vendedor")
    Session( "FechaDespacho" ) = Request("FechaDespacho")
    'Response.write( Session( "Vendedor" ) & "<br>" )
    'Response.write( Session( "FechaDespacho" ) & "<br>" )
    'Response.end
end if

Session("Tipo_documento_venta") = request("Tipo_documento_venta")
session("Nombre_usuario_boleta") = session("Nombre_usuario")

if request("Login_punto_venta") <> "" then
   Session("Login_punto_venta") = request("Login_punto_venta")
	 session("Nombre_usuario_boleta") = Session("Login_punto_venta")
end if

' El usuario puede modificar al responsable
Permite_cambio_responsable = false
Set rs = Conn.execute("EXEC PUN_Permite_cambio_responsable '" & trim(Session("Login")) & "'" )
if not rs.eof then
   if rs("Permite_cambio_responsable") = "S" then
      Permite_cambio_responsable = true
   end if
end if
rs.close
set rs = nothing

'Revisando si no hay una venta abierta
lReimprimir = false
Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'" )
'response.write "Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'"
if not rs.eof then
   Session("Cliente_boleta") = rs("Cliente")
   Numero_interno_DVT_activa = rs("Numero_interno_documento_no_valorizado")
else
   Numero_interno_DVT_activa = 0
   session("producto_eliminado") = 0
   Session("Tipo_documento_venta") = request("Tipo_documento_venta")
end if
rs.close
set rs = nothing

'Response.Write Request("Accion") & " *** " & Request("Cliente_boleta") & " *** " & Session("Cliente_boleta")
'Response.End

if Conn.Errors.Count > 0 then
   MensajeError = "Error al iniciar proceso de venta, debe llamar a asistencia técnica"
end if

if Numero_interno_DVT_activa > 0 and Request("Imprimiendo") & "*" <> "Si*" then
   Set rs = Conn.execute("Exec DOV_consulta_existencia_documento_venta_de_DVT " & Numero_interno_DVT_activa )
   'response.write "Exec DOV_consulta_existencia_documento_venta_de_DVT " & Numero_interno_DVT_activa
   'response.end
   if not rs.eof then
      Session("Tipo_documento_venta") = rs("Documento_valorizado")
      if rs("Documento_valorizado") = "BOV" then
         'response.write " aún sin liberar"
         lReimprimir = true
      end if
   end if
   rs.close
   set rs = nothing
	 if Conn.Errors.Count > 0 then
   		MensajeError = "Error al iniciar proceso de venta, debe llamar a asistencia técnica"
	 end if
else
  if Request("Imprimiendo") = "Si" then bTerminada = true
end if

if len(trim(Session("Cliente_boleta"))) = 0 then
   Session("Cliente_boleta") = "CLI_BOLETA"
end if

MensajeError	= ""
lIniciar = false
ControlFoco = "Cliente_boleta"


'Chequea si el cliente ingresado es nuevo
if Session("Cliente_boleta") <> Request("Cliente_boleta_anterior") then  
   Set rs = Conn.execute("EXEC PUN_Consulta_cliente '" & Session("Cliente_boleta")  & "'" )
   if not rs.eof then
      Apellido_cliente                      = rs("Apellidos_persona_o_nombre_empresa")
      Nombre_cliente                        = rs("Nombres_persona")
      Direccion_cliente                     = rs("Direccion")
      Comuna_cliente                        = rs("Comuna")
      Telefono_cliente                      = rs("Telefono")
      Mail_cliente                          = rs("Mail")
      Dv_cliente                            = valida_rut( StrZero( replace( trim( Session("Cliente_boleta") ) , ".", "" ) ,8) )
      Session("xBloqueado")                 = rs("Cliente_bloqueado")
      Session("tipo_entidad_comercial")     = rs("tipo_entidad_comercial")
      if IsNull(rs("clasificacion_de_empleado")) then
        Session("clasificacion_de_empleado")  = ""
      else
        Session("clasificacion_de_empleado")  = rs("clasificacion_de_empleado")
      end if
   else
      Apellido_cliente                      = Request("Apellido_cliente")
      Nombre_cliente                        = Request("Nombre_cliente")
      Direccion_cliente                     = Request("Direccion_cliente")
      Comuna_cliente                        = Request("Comuna_cliente")
      Telefono_cliente                      = Request("Telefono_cliente")
      Mail_cliente                          = Request("Mail_cliente")
      Dv_cliente                            = Request("Dv_cliente")
      if left(Session("Cliente_boleta"),1)="0" then
        MensajeError	                        = "No se debe anteponer un cero en el Rut"
      elseif left(Session("Cliente_boleta"),1)= " " then
        MensajeError	                        = "No se debe anteponer un valor vacío en el Rut"
      else
        MensajeError	                        = "El cliente es nuevo, debe ingresar sus datos"
      end if
      Session("xBloqueado")                 = "N"
      Session("tipo_entidad_comercial")     = ""
      Session("clasificacion_de_empleado")  = ""
   end if
   rs.close
   set rs = nothing
else
   Apellido_cliente   = Request("Apellido_cliente")
   Nombre_cliente     = Request("Nombre_cliente")
   Direccion_cliente  = Request("Direccion_cliente")
   Comuna_cliente     = Request("Comuna_cliente")
   Telefono_cliente   = Request("Telefono_cliente")
   Mail_cliente       = Request("Mail_cliente")
   Dv_cliente         = Request("Dv_cliente")
end if

'Verifica si la caja (IP) está autorizada para vender con descuento de personal 
if session("tipo_entidad_comercial") = "E" then
  'Response.Write session("tipo_entidad_comercial")
  'Response.End
  IP_EQUIPO = Request.ServerVariables("REMOTE_ADDR")
  z_strSQL="select caja_ip from cajas with(nolock) where caja_ip = '"&IP_EQUIPO&"' and permite_desc_personal = 1"
  'MensajeError = z_strSQL
  set rs = Conn.Execute(z_strSQL)
  if rs.EOF then
    MensajeError = "Esta caja no está autorizada para realizar descuento de personal"
    ControlFoco = "Cliente_boleta"
  end if
  rs.close
  set rs = nothing
end if


if ( Request("Accion") = "Iniciar" or Ucase(Trim(Session("Cliente_boleta"))) = "CLI_BOLETA" ) and len(trim(Request("Accion"))) > 0 then

   ' Validaciones generales
   if Request("Accion") = "Iniciar" then
      Digito = trim( valida_rut( StrZero( replace( trim( Session("Cliente_boleta") ) , ".", "" ) ,8) ) )
      if len(trim(Dv_cliente)) = 0 then
         MensajeError	= "Se requiere seleccionar el digito verificador"
         ControlFoco = "Dv_cliente"
      elseif Dv_cliente <> Digito then
         MensajeError	= "El digito seleccionado " & Dv_cliente & " no corresponde al rut ingresado"
         ControlFoco = "Dv_cliente"
      end if
   end if

   if len(trim(Comuna_cliente)) = 0 then
      MensajeError	= "Debe seleccionar una comuna para el cliente cliente"
      ControlFoco = "Comuna_cliente"
   end if
   
   if len(trim(Direccion_cliente)) = 0 then
      MensajeError	= "Debe ingresar la dirección del cliente"
      ControlFoco = "Direccion_cliente"
   end if
   
   if len(trim(Apellido_cliente)) = 0 then
      MensajeError	= "Debe ingresar el nombre del cliente"
      ControlFoco = "Apellido_cliente"
   end if

   'Valor de la paridad para la fecha actual
   Set rs = Conn.execute( "EXEC PUN_Valor_paridad_dia_actual" )
   if rs.eof then
      MensajeError	= "No hay un valor de moneda US$ (Dolar) ingresado en paridades para hoy"
      Session("Tipo_cambio_boleta") = 0
   else
      Session("Tipo_cambio_boleta") = cdbl( rs("Paridad_para_facturacion") )
   end if
   rs.close
   set rs = nothing

    ' ------------ Dolar Cambio
    IF true THEN
       Set rsDolar = Conn.execute( "EXEC DCA_RescataUltimoDolarCambio" )
       if rsDolar.eof then
            Session("DolarCambio") = 1
       else
            Session("DolarCambio") = cdbl( rsDolar("Valor_Dolar") )
       end if
       rsDolar.close
       set rsDolar = nothing
    END IF

   'Nombre de la comuna
   Session("Comuna_boleta") = Comuna_cliente
   Set rs = Conn.execute("EXEC PUN_Nombre_comuna '" & Comuna_cliente & "'" )
   if not rs.eof then
      Session("Nombre_comuna_boleta") = rs("Nombre")
   end if
   rs.close
   set rs = nothing
   
   'Cliente para factura
   if Session("Cliente_boleta") = "CLI_BOLETA" and Session("Tipo_documento_venta") = "FAV" then
      MensajeError	= "Debe ingresar un cliente para factura"
   end if

  'Revisando si no hay una venta abierta con otro cliente
  Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT '" & trim(Session("Login")) & "'" )
  if not rs.eof then
     if Session("Cliente_boleta") <> rs("Cliente") then
        MensajeError	= "Debe terminar la venta para el cliente " & rs("Cliente") & " antes de iniciar una nueva venta"
     end if
  end if
  rs.close
  set rs = nothing
  
  'Verificar que el responsable es un empleado (Validación sólo para cajas que TIENEN AUTORIZACION para modificar el responsable)
  if Permite_cambio_responsable then 'Computación (Digitación) y Supervisoras
    if request("Login_punto_venta") = "" then
      MensajeError  = "Ingrese Responsable"
      ControlFoco   = "Login_punto_venta"
    else
      'Verificar si el responsable corresponde a una cajera ingresada en el sistema
      rut_responsable = trim(request("Login_punto_venta"))
      'z_strSQL="select entidad_comercial from entidades_comerciales where entidad_comercial = '"&rut_responsable&"'"
      z_strSQL="select entidad_comercial from entidades_comerciales with(nolock) where empresa='SYS' and entidad_comercial = '"&rut_responsable&"' and Tipo_entidad_comercial='E'"
      set rs = Conn.Execute(z_strSQL)
      if rs.EOF then
        MensajeError  = "El Rut Responsable NO corresponde a un empleado del sistema"
        ControlFoco   = "Login_punto_venta"
      end if
      rs.close
      set rs = nothing
    end if
  end if
  
  if len(trim(MensajeError)) = 0 then
     '---------------------------------- Valores generales --------------------------------------------
     'Multicredito
      Session("xMulticredito") = ""
      cSql = "Exec TMU_Lista_Asociados '" & Session("Empresa_usuario") & "', '" & Session("Cliente_boleta") & "'"
      Set RsASE = Conn.Execute ( cSql )
      If Not RsASE.Eof then
         Session("xMulticredito") = "Si"
      end if
      RsASE.Close
      
     'Economato
      Session("xEconomato") = ""
      cSql = "Exec ASE_Lista_Asociados '" & Session("Empresa_usuario") & "', Null, '" & Session("Cliente_boleta") & "', Null, Null"
      Set RsASE = Conn.Execute ( cSql )
      If Not RsASE.Eof then
         Session("xEconomato") = RsASE("Economato")
      end if
      RsASE.Close
      
      Session("xEconomato_nombre") = ""
      
      Session("xEconomato_fecha_cobro") = ""
      Session("xEconomato_tope")        = 0
      Session("xEconomato_supera_tope") = 0
      Session("xEconomato_temporada")   = ""
      
      if Session("xEconomato") <> "" then
         cSql = "Exec ECO_Lista_Economatos '" & Session("Empresa_usuario") & "','" & Session("xEconomato") & "', Null, Null, Null"
         Set RsASE = Conn.Execute ( cSql )
         If Not RsASE.Eof then
            'Response.Write RsASE("Nombre")
            'Response.End
            Session("xEconomato_nombre") = RsASE("Nombre")
            
            strSQL="select fecha_cobro_eco_tmp, tope, supera_tope from economatos with(nolock) " &_
                   "where empresa='SYS' and economato = '"&Session("xEconomato")&"' and temporada = 1 and (getdate() between fecha_ini  and fecha_fin)"
            'Response.Write Session("xEconomato")
            'Response.End
            set rs_eco = Conn.Execute(strSQL)
            if not rs_eco.EOF then
              eco_fecha_cobro = rs_eco("fecha_cobro_eco_tmp")
              eco_tope        = rs_eco("tope")
              eco_supera_tope = rs_eco("supera_tope")
            end if
            Session("xEconomato_fecha_cobro") = eco_fecha_cobro
            Session("xEconomato_tope")        = eco_tope
            Session("xEconomato_supera_tope") = eco_supera_tope
            Session("xEconomato_temporada")   = "1"
            'Response.Write eco_tope
            'Response.End
         end if
         RsASE.Close
      end if

      session("Economatos") = ","
      Set rs = Conn.execute("EXEC PUN_Consulta_economatos '" & Session("empresa_usuario")  & "'" )
      do while not rs.Eof
         session("Economatos") = session("Economatos") & rs("Documento_de_cobro_asociado") & ","
         rs.movenext
      loop
      rs.close
     
     'Bloqueado
     Session("xBloqueado") = "N" : session("tipo_entidad_comercial") = "" : session("clasificacion_de_empleado") = ""
     Set rs = Conn.execute("EXEC PUN_Consulta_cliente '" & Session("Cliente_boleta")  & "'" )
     if not rs.eof then
        Session("xBloqueado")                 = rs("Cliente_bloqueado")
        Session("tipo_entidad_comercial")     = rs("tipo_entidad_comercial")
        if IsNull(rs("clasificacion_de_empleado")) then
          session("clasificacion_de_empleado")  = ""
        else
          session("clasificacion_de_empleado")  = rs("clasificacion_de_empleado")
        end if
     end if
     rs.close
     
     'Economato Express
     session("saldo_empleado_ECO_EXP") = 0
     Set Rs_saldo_empleado = Conn.Execute("Exec ECO_Express_Consulta_Saldo '"&Session("Cliente_boleta")&"'")
     session("saldo_empleado_ECO_EXP") = Rs_saldo_empleado(0)
     
     'Tipo entidad comercial

     'Cuenta puente
     Set rs = Conn.execute("EXEC PUN_Cuenta_puente" )
     if not rs.eof then
        Session("cuenta_puente") = "'" & rs("Valor_texto") & "'"
     else
        Session("cuenta_puente") = "null"
     end if
     rs.close

     'Mensaje del día
     Session("Mensaje_del_dia") = ""
     Set rs = Conn.execute( "EXEC PUN_Mensaje_del_dia" )
     if not rs.eof then
        Session("Mensaje_del_dia") = trim(rs("Valor_texto"))
     end if
     rs.close
     set rs = nothing

     'Permite mostrar CIF
     Session("Ver_CIF") = "N"
     Set rs = Conn.execute( "EXEC PUN_Permite_mostrar_CIF" )
     if not rs.eof then
        Session("Ver_CIF") = trim(rs("Valor_texto"))
     end if
     rs.close
     set rs = nothing

    ' Máximo descuento de cajera
    Session("Maximo_descuento_cajera") = 0
    Session("Permite_hacer_descuento_empleado") = true
    Set rs = Conn.execute("EXEC PUN_Descuentos_cajera '" & trim(Session("Login")) & "'" )
    if not rs.eof then
       Session("Maximo_descuento_cajera") = cdbl( rs("Porcentaje_descuento_maximo_permitido_para_vender") )
       if rs("Permite_hacer_descuento_empleado") = "N" then
          Session("Permite_hacer_descuento_empleado") = false
       end if
    end if
    rs.close
    set rs = nothing

   ' Descuento Cliente - En esta pantalla corresponde al descuento del documento si Forma de Pago lo permite
   Session("Descuento_cliente") = 0
   Set rs = Conn.execute("EXEC PUN_Descuento_cliente '" & Session("Cliente_boleta") & "'" )
   if not rs.eof then
      Session("Descuento_cliente") = cdbl( rs("Maximo_porcentaje_descuento_autorizado") )
   end if
   rs.close
   set rs = nothing

   'Valor Paridad
   Session("Valor_paridad_margenes") = 0
   Set Rs = Conn.Execute("Exec MOP_Valor_paridad_moneda_oficial '" & Session("empresa_usuario") & "'")
   if Not Rs.EOF then
      Session("Valor_paridad_margenes") = cdbl( rs("Paridad_para_calculo_de_margenes") )
   end if
   Rs.close
   set Rs = nothing

   ' Descuento Empleado
   Session("Porcentaje_descuento_empleado") = 0
   if Session("Cliente_boleta") <> "CLI_BOLETA" then
      Set rs = Conn.execute("EXEC PUN_Descuento_empleado 0" & Session("Cliente_boleta") )
      if not rs.eof then
         Session("Porcentaje_descuento_empleado") = cdbl( rs("Porcentaje_descuento_sobre_margen_para_comprar") )
      end if
      rs.close
      set rs = nothing
   end if

   ' Descuento Institucional
   Session("Porcentaje_descuento_institucional") = 0
   Set rs = Conn.execute("EXEC PUN_Descuento_institucional '" & Session("Cliente_boleta") & "'" )
   if not rs.eof then
      Session("Porcentaje_descuento_institucional") = cdbl( rs("Maximo_porcentaje_descuento_autorizado") )
   end if
   rs.close
   set rs = nothing

   ' Máximo descuento a la cabecera
   Session("Maximo_descuento_cabecera") = 0
   Set rs = Conn.execute("EXEC PUN_Maximo_descuento_cabecera" )
   if not rs.eof then
      Session("Maximo_descuento_cabecera") = cdbl( rs("Valor_numerico") )
   end if
   rs.close
   set rs = nothing

   ' Máximo descuento a la línea
   Session("Maximo_descuento_linea") = 0
   Set rs = Conn.execute("EXEC PUN_Maximo_descuento_linea" )
   if not rs.eof then
      Session("Maximo_descuento_linea") = cdbl( rs("Valor_numerico") )
   end if
   rs.close
   set rs = nothing

   ' Documentos de pago sin descuento
   Session("Documentos_sin_descuento") = ","
   Set Rs = Conn.Execute("EXEC PUN_Documentos_sin_descuento")
   do While Not Rs.EOF
      if rs("Admite_descuento") = "N" then
         Session("Documentos_sin_descuento") = Documentos_sin_descuento & rs("Documento") & ","
      end if
      rs.MoveNext
   Loop
   Rs.close
   set Rs = nothing

   ' Valores CIF máximos de boletas
   Session("Maximo_cif_bov") = 499.99
   Session("Maximo_cif_fav") = 749.99
   Set Rs = Conn.Execute("EXEC PUN_Maximos_CIF_boletas")
   if Not Rs.EOF then
      Session("Maximo_cif_bov") = cdbl( rs("Maximo_cif_boleta") )
      Session("Maximo_cif_fav") = cdbl( rs("Maximo_cif_factura") )
   end if
   Rs.close
   set Rs = nothing

   Session("Nombre_cliente_boleta") = left( trim(Apellido_Cliente) & "," & Nombre_cliente , 25 )
   Session("Direccion_boleta") = Direccion_cliente
   Session("Codigo_ultimo_producto") = ""

   Session("Forma_pago") = "EFI"
   Sql = "Exec ECP_GrabaClienteBoleta_Zona_franca '" & _
               Session("Cliente_boleta") & "','" & _
               ucase(Direccion_cliente) & "','" & _
               Comuna_cliente & "','" & _
               Telefono_cliente & "','" & _
               Mail_cliente & "','" & _
               ucase(Apellido_cliente) & "','" & _
               ucase(Nombre_cliente) & "','" & _
               Session("Tipo_documento_venta") & "'"
   Conn.Execute( Sql )

  if Conn.Errors.Count = 0 then
     'Response.redirect "Mant_PuntoVentaZF.asp"
     lIniciar = true
	Else
     MensajeError	= "Error, no se puede iniciar la venta"
	End if
  
  end if

end if

if Session("Cliente_boleta") = "CLI_BOLETA" and not lIniciar then
   Session("Cliente_boleta")            = ""
   Session("tipo_entidad_comercial")    = ""
   Session("clasificacion_de_empleado") = ""
   Nombre_cliente                       = ""
   Direccion_cliente                    = ""
   Comuna_cliente                       = ""
   Telefono_cliente                     = ""
   Mail_cliente                         = ""
   session("saldo_empleado_ECO_EXP")    = ""
end if

'**************************************************************************
'Total venta base (piso) MAYORISYA
strSQL="select valor_numerico from parametros with(nolock) where parametro='BASETOTMAY'" 
Set rs = Conn.Execute(strSQL)
if not rs.EOF then Session("BASETOTMAY") = rs("valor_numerico")
'**************************************************************************

'**************************************************************************
'Tramos descuentos MAYORISTA
strSQL="select desde, hasta, descuento from TRAMOS with(nolock) where tipo='MAYORISTA'" 
Set rs = Conn.Execute(strSQL) : strTramos = "" : separaTramos=""
do while not rs.EOF
  strTramos=strTramos & separaTramos & rs("desde") & "#" & rs("hasta") & "#" & rs("descuento")
  separaTramos="@"
  rs.MoveNext
loop
session("TramosMayorista") = strTramos
'**************************************************************************

'Valores por defecto
if len(trim(Comuna_cliente)) = 0 then Comuna_cliente = "290"

' Documentos autorizados cajera
Permite_boleta = false
Permite_factura = false
Set rs = Conn.execute( "EXEC PUN_Documentos_autorizados_cajera '" & trim(Session("Login")) & "'" )
if not rs.eof then
   if rs("Permite_boleta") = "S" then Permite_boleta = true
   if rs("Permite_factura") = "S" then Permite_factura = true
end if
rs.close
set rs = nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title>Inicio boleta</title>
		<link rel="stylesheet" type="text/css" href="estilos.css">	
</head>
<body bgcolor="" leftmargin="0" topmargin="0" text="#000000" onload='javascript:fncFechaDespacho();'>

<form name="Formulario" method="post" action="Boleta_PuntoVentaZF.asp">

<input type="hidden" name="Accion" id="Accion" value="">

<%=CajaConBordes(110,210,550,285)%>

<div style="position:absolute; top:145px; left:230px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Documento<br>
Cliente<br>
Apellido o Empresa<br>
Nombre<br>
Dirección<br>
Comuna<br>
Teléfono<br>
Mail<br />
Vendedor<br />
Fecha despacho
</div>

<%if Permite_cambio_responsable then%>
<div style="position:absolute; top:140px; left:500px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
Responsable &nbsp;<input id="Login_punto_venta" type="text" name="Login_punto_venta" size="12" maxlength="10" value="<%=Session("Login_punto_venta")%>">
</div>
<%end if%>

<div style="position:absolute; top:145px; left:390px; z-index:1"  style="font-size: 16px; font-family: sans-serif;font-weight: bold; line-height: 150%;">
     &nbsp;<select class="FuenteInput" name="Tipo_documento_venta" onchange='javascript:fncFechaDespacho();'>
<%if Permite_boleta then%>
     <option value="BOV" <%if Session("Tipo_documento_venta") = "BOV" then Response.Write("selected ")%>>Boleta</option>
<%end if
  if Permite_factura then%>
     <option value="FAV" <%if Session("Tipo_documento_venta") = "FAV" then Response.Write("selected ")%>>Factura</option>
<%end if%>
     </select> <br>
     &nbsp;<input onfocus="select()" id="Cliente_boleta" type="text" name="Cliente_boleta" size="12" maxlength="10" value="<%=Session("Cliente_boleta")%>">
     <input type="hidden" name="Cliente_boleta_anterior" value="<%=Session("Cliente_boleta")%>">
     &nbsp;-&nbsp;
     &nbsp;<select class="FuenteInput" name="Dv_cliente" onfocus="Digito=true;" onblur="Digito=false;">
     <option value=""></option>
     <option value="0" <%if Dv_cliente = "0" then Response.Write("selected ")%>>0</option>
     <option value="1" <%if Dv_cliente = "1" then Response.Write("selected ")%>>1</option>
     <option value="2" <%if Dv_cliente = "2" then Response.Write("selected ")%>>2</option>
     <option value="3" <%if Dv_cliente = "3" then Response.Write("selected ")%>>3</option>
     <option value="4" <%if Dv_cliente = "4" then Response.Write("selected ")%>>4</option>
     <option value="5" <%if Dv_cliente = "5" then Response.Write("selected ")%>>5</option>
     <option value="6" <%if Dv_cliente = "6" then Response.Write("selected ")%>>6</option>
     <option value="7" <%if Dv_cliente = "7" then Response.Write("selected ")%>>7</option>
     <option value="8" <%if Dv_cliente = "8" then Response.Write("selected ")%>>8</option>
     <option value="9" <%if Dv_cliente = "9" then Response.Write("selected ")%>>9</option>
     <option value="K" <%if Dv_cliente = "K" then Response.Write("selected ")%>>K</option>
     </select> <br>
     &nbsp;<input id="Apellido_cliente" type="text" name="Apellido_cliente" size="40" maxlength="50" value="<%=Apellido_cliente%>"> <br>
     &nbsp;<input id="Nombre_cliente" type="text" name="Nombre_cliente" size="25" maxlength="30" value="<%=Nombre_cliente%>"> <br>
     &nbsp;<input id="Direccion_cliente" type="text" name="Direccion_cliente" size="40" maxlength="50" value="<%=Direccion_cliente%>"> <br>
<%Sql = "Exec COM_ListaComunas '' ,'','', 2, ''" 
	'Response.Write Sql
	SET Rs	=	Conn.Execute( SQL ) %>
	   &nbsp;<select name="Comuna_cliente"  style="width:250">
<%do while not rs.eof%>
     <option <%if Comuna_cliente = rs("Comuna") then Response.Write("selected ")%> value='<%=rs("Comuna")%>'><%=rs("Nombre")%>&nbsp;(<%=rs("Comuna")%>)</option>
<%rs.movenext
 	loop
 	rs.close
	set rs=nothing%>
    </select> <br>
    &nbsp;<input id="Telefono_cliente" type="text" name="Telefono_cliente" size="30" maxlength="50" value="<%=Telefono_cliente%>"> <br>
    &nbsp;<input id="Mail_cliente" type="text" name="Mail_cliente" size="30" maxlength="50" value="<%=Mail_cliente%>"> <br>
    <br />
    &nbsp;<% = Get_Vendedor( Session( "Vendedor" ), ModoVendedor ) %> <br>
    &nbsp;<input type='text' name='FechaDespacho' value='<% = Session( "FechaDespacho" ) %>' size="10" maxlength="10" /> <br>
</div>

<%  if Ucase(Trim(Session("xBloqueado"))) = "S" Then 
       MensajeError = Session("RELACIONCOM")
    end if %>

<div style="position:absolute; top:410px; left:220px; width=800px; z-index:1; color=#ff0000; font-weight: bold; font-family: Verdana, Sans Serif, Arial, Helvetica; font-size: 18px; text-decoration: blink;"><%=MensajeError%></div>

</form>

</body>
</html>
<%
conn.close
set conn = nothing

'Response.Write lReimprimir & " -- " & lIniciar
'Response.End
%>
<script language="JavaScript">
    <%if lReimprimir then%>
//alert ( 1 )
        parent.Botones.location.href = "Chequea_imprimir_PuntoVentaZF.asp";
    <%elseif lIniciar then%>
//alert ( 2 )
        document.Formulario.Comuna_cliente.focus();
        document.Formulario.Comuna_cliente.blur();
        location.href = "Chequea_impresora_PuntoVentaZF.asp";
        parent.Botones.location.href = "Botones_Mant_PuntoVentaZF.asp";
    <%elseif bTerminada then%>
        parent.Botones.location.href = "Botones_Boleta_PuntoVentaZF.asp";
    <%else%>
        <%if ControlFoco = "Nombre_cliente" then%>
//alert ( 3 )
            document.Formulario.Nombre_cliente.focus();
        <%elseif ControlFoco = "Direccion_cliente" then%>
//alert ( 4 )
            document.Formulario.Direccion_cliente.focus();
        <%elseif ControlFoco = "Comuna_cliente" then%>
//alert ( 5 )
            document.Formulario.Comuna_cliente.focus();
        <%elseif ControlFoco = "Dv_cliente" then%>
//alert ( 6 )
            document.Formulario.Dv_cliente.focus();
        <%else%>
//alert ( 7 )
            document.Formulario.Comuna_cliente.focus();
            document.Formulario.Comuna_cliente.blur();
            document.Formulario.Cliente_boleta.focus();
        <%end if
    end if%>

    function Cliente()
    {
        document.all.Accion.value = "Cliente";
        document.Formulario.submit();
    }
    
    function Iniciar()
    {
        document.all.Accion.value = "Iniciar";
        document.Formulario.submit();
    }

    var blnDOM = false, blnIE4 = false, blnNN4 = false; 
    var Digito = false;
	
	if (document.layers) blnNN4 = true;
	else if (document.all) blnIE4 = true;
	else if (document.getElementById) blnDOM = true;

	function getKeycode(e)
	{
		var TeclaPresionada = ""
		
		if (blnNN4)
		{
			var NN4key = e.which
			TeclaPresionada = NN4key;
		}
		if (blnDOM)
		{
			var blnkey = e.which
			TeclaPresionada = blnkey;
		}
		if (blnIE4)
		{
			var IE4key = event.keyCode
			TeclaPresionada = IE4key
		}
    if (Digito) {
	     if ( TeclaPresionada == 8 ) // Back en Digito
		  {
		   return false;
		}}

		if ( TeclaPresionada == 13 ) // Enter
		{
		   Cliente();
		}
<%if not lReimprimir then%>
		if ( TeclaPresionada == 113 ) // F2 Iniciar
		{
		   Iniciar();
		}
<%end if%>
	}

	document.onkeydown = getKeycode;
	if (blnNN4) document.captureEvents(Event.KEYDOWN);

 //document.onmousedown = click ;

  function click(e) 
  {
// Explorer
    if (event.button == 2)
    {
    alert('Operacion no permitida');
    return false ;
    }
}
	
    function fncFechaDespacho() {
        TipoDocto = document.Formulario.Tipo_documento_venta.value;
        if (TipoDocto == "BOV") {
            document.Formulario.FechaDespacho.style.visibility = "hidden";
        }
        if (TipoDocto == "FAV") {
            document.Formulario.FechaDespacho.style.visibility = "visible";
        }
    }

</script>
