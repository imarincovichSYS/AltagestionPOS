<%
band_readonly = false
if accion="EDITAR" and documento_no_valorizado="RCP" then band_readonly = true

set col         = new agrid_col
col.kind        = "checkbox"
col.width       = 15
col.caption     = ""
col.column_name = ""
col.readonly    = band_readonly
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "center"
col.width             = 28
col.caption           = "ITEM"
col.column_name       = "numero_de_linea_en_rcp_o_documento_de_compra"
col.tipo              = "char"
col.readonly          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "center"
col.width             = 30
col.caption           = " ITEM"&chr(13)&"BASE"
col.column_name       = "numero_de_linea_en_rcp_o_documento_de_compra_padre"
col.tipo              = "char"
col.readonly          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 66
col.maxlength         = 9
col.caption           = "PRODUCTO"
col.column_name       = "producto"
col.tipo              = "char"
col.expresionRegular  = "^[\wnñÑ]+$"
'if accion="EDITAR" and documento_no_valorizado="RCP" then col.readonly = true
col.readonly          = true
'if documento_no_valorizado = "TCP" then col.colorText         = "EEEEEE"
grid.add_col col

if checktodos = "true" then
  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "left"
  col.width             = 200
  col.maxlength         = 50
  col.caption           = "NOMBRE PRODUCTO PROVEEDOR"
  col.column_name       = "nombre_producto_proveedor"
  col.tipo              = "char"
  col.readonly          = band_readonly
  col.nullable          = true
  col.expresionRegular  = "^[\w\s°/\.áéíóúñÑ:*$%&()=?¿!¡+-]+$"
  col.movHorizontal     = false
  grid.add_col col
end if

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 270
col.maxlength         = 50
col.caption           = "NOMBRE"
col.column_name       = "nombre_producto"
col.tipo              = "char"
col.readonly          = band_readonly
col.expresionRegular  = "^[\w\s°/\.áéíóúñÑ:*$%&()=?¿!¡+-]+$"
col.movHorizontal     = false
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "right"	
col.width             = 44
col.maxlength         = 9
col.column_length     = 8
col.column_scale      = 2
col.caption           = "  CANT"&chr(13)&"COMP."	
col.column_name       = "cantidad_mercancias"
col.tipo              = "number"
col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
col.readonly          = band_readonly
col.separadorMiles    = true
grid.add_col col

if vista = "NORMAL" then
  set col               = new agrid_col
  col.kind              = "select"
  col.width             = 65
  col.caption           = " U/M"&chr(13)&"COMP."
  col.column_name       = "unidad_de_medida_compra"
  col.tipo              = "char"
  col.sqlselect         = "select unidad value, unidad text from unidades_de_medida with(nolock) where visible_compra=1 order by text"
  col.readonly          = band_readonly
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 40
  col.maxlength         = 5
  col.caption           = "CANT U/M C."	
  col.column_name       = "cantidad_um_compra_en_caja_envase_compra"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "select"
  col.width             = 65
  col.caption           = " U/M"&chr(13)&"VTA."
  col.column_name       = "unidad_de_medida_consumo"
  col.tipo              = "char"
  col.sqlselect         = "select unidad value, unidad text from unidades_de_medida with(nolock) where visible_venta=1 order by text"
  col.readonly          = band_readonly
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 44
  col.maxlength         = 5
  col.caption           = "CANT U/M V."	
  col.column_name       = "cantidad_x_un_consumo"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 30
  col.maxlength         = 5
  col.caption           = "CANT"&chr(13)&"VTA."	
  col.column_name       = "cantidad_entrada"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = true
  col.separadorMiles    = true
  grid.add_col col

  if documento_respaldo = "TU" then
    set col               = new agrid_col
    col.kind              = "text"	
    col.align             = "right"	
    col.width             = 58
    col.column_scale      = 4
    col.caption           = "CIF ORI (US$)"	
    col.column_name       = "costo_cif_ori_us$"
    col.tipo              = "number"
    col.readonly          = true
    col.separadorMiles    = true
    grid.add_col col
    
    set col               = new agrid_col
    col.kind              = "text"	
    col.align             = "right"	
    col.width             = 64
    col.maxlength         = 10
    col.column_length     = 8
    col.column_scale      = 2
    col.caption           = "CIF ORI" &chr(13)&"TOTAL (US$)"
    col.column_name       = "total_cif_ori"
    col.tipo              = "number"
    col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
    col.readonly          = band_readonly
    col.separadorMiles    = true
    grid.add_col col
  end if
  
  if documento_respaldo = "DS" then
    set col               = new agrid_col
    col.kind              = "text"	
    col.align             = "right"	
    col.width             = 78
    col.maxlength         = 18
    col.column_length     = 11
    col.column_scale      = 7
    col.caption           = "CIF ORI (US$)"	
    col.column_name       = "costo_cif_ori_us$"
    col.tipo              = "number"
    col.expresionRegular  = "^\d{0,8}(\.)?\d{0,4}$"
    col.readonly          = band_readonly
    col.separadorMiles    = true
    grid.add_col col
    
    set col               = new agrid_col
    col.kind              = "text"	
    col.align             = "right"	
    col.width             = 88
    col.maxlength         = 10
    col.column_length     = 8
    col.column_scale      = 4
    col.caption           = "CIF ORI" &chr(13)&"TOTAL (US$)"
    col.column_name       = "total_cif_ori"
    col.tipo              = "number"
    col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
    col.readonly          = band_readonly
    col.separadorMiles    = true
    grid.add_col col
  end if

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 58
  col.column_scale      = 4
  col.caption           = "CIF ADU (US$)"	
  col.column_name       = "costo_cif_adu_us$"
  col.tipo              = "number"
  col.readonly          = true
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 64
  col.maxlength         = 10
  col.column_length     = 8
  col.column_scale      = 2
  col.caption           = "CIF ADU" &chr(13)&"TOTAL (US$)"
  col.column_name       = "total_cif_adu"
  col.tipo              = "number"
  col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
  col.readonly          = band_readonly
  col.separadorMiles    = true
  col.colSaltoLinea     = 4
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 40
  col.maxlength         = 10
  col.column_length     = 8
  col.column_scale      = 2
  col.caption           = "&Delta; CPA"&chr(13)&"(US$)"	
  col.column_name       = "delta_cpa_us$"
  col.tipo              = "number"
  col.expresionRegular  = "^(-)?\d{0,8}(\.)?\d{0,2}$"
  col.readonly          = band_readonly
  col.separadorMiles    = true
  grid.add_col col

  if checktodos = "true" then
    set col               = new agrid_col
    col.kind              = "text"
    col.align             = "left"
    col.width             = 200
    col.maxlength         = 50
    col.caption           = "OBS. &Delta; CPA"
    col.column_name       = "obs_delta_cpa_us$"
    col.tipo              = "char"
    col.readonly          = band_readonly
    col.nullable          = true
    col.expresionRegular  = "^[\w\s°/\.áéíóúñÑ:-]+$"
    grid.add_col col
  end if

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 58
  col.maxlength         = 12
  col.column_length     = 8
  col.column_scale      = 4
  col.caption           = "CPA"&chr(13)&"(US$)"	
  col.column_name       = "costo_cpa_us$"
  col.tipo              = "number"
  col.expresionRegular  = "^\d{0,8}(\.)?\d{0,4}$"
  col.readonly          = true
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 46
  col.maxlength         = 8
  col.caption           = "PRECIO ($)"
  col.column_name       = "precio_de_lista_modificado"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "right"
  col.width             = 36
  col.column_scale      = 2
  col.caption           = "  MG"&chr(13)&"(%)"
  col.column_name       = "margen"
  col.tipo              = "number"
  'col.expresionRegular  = "^\d+$"
  col.readonly          = true
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 32
  col.maxlength         = 5
  col.column_length     = 4
  col.column_scale      = 1
  col.caption           = " ALT."&chr(13)&"(cm)"
  col.column_name       = "alto"
  col.tipo              = "number"
  col.expresionRegular  = "^\d{0,4}(\.)?\d{0,1}$"
  col.readonly          = band_readonly
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 32
  col.maxlength         = 5
  col.column_length     = 4
  col.column_scale      = 1
  col.caption           = " ANC."&chr(13)&"(cm)"	
  col.column_name       = "ancho"
  col.tipo              = "number"
  col.expresionRegular  = "^\d{0,4}(\.)?\d{0,1}$"
  col.readonly          = band_readonly
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 32
  col.maxlength         = 5
  col.column_length     = 4
  col.column_scale      = 1
  col.caption           = " LAR."&chr(13)&"(cm)"	
  col.column_name       = "largo"
  col.tipo              = "number"
  col.expresionRegular  = "^\d{0,4}(\.)?\d{0,1}$"
  col.readonly          = band_readonly
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 32
  col.maxlength         = 5
  col.caption           = "CANT"&chr(13)&"CAJA"	
  col.column_name       = "cantidad_x_caja"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "right"
  col.width             = 52
  col.column_scale      = 6
  col.caption           = "  VOL"&chr(13)&"(m3)"
  col.column_name       = "volumen"
  col.tipo              = "char"
  col.readonly          = true
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 40
  col.maxlength         = 5
  col.column_length     = 3
  col.column_scale      = 2
  col.caption           = "P/CAJA"&chr(13)&"(kg)"	
  col.column_name       = "peso_x_caja"
  col.tipo              = "number"
  col.expresionRegular  = "^\d{0,3}(\.)?\d{0,2}$"
  col.readonly          = band_readonly
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 36
  col.maxlength         = 5
  col.column_length     = 3
  col.column_scale      = 2
  col.caption           = " P/U"&chr(13)&"(kg)"
  col.column_name       = "peso"
  col.tipo              = "number"
  col.expresionRegular  = "^\d{0,3}(\.)?\d{0,2}$"
  col.readonly          = true
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "left"
  col.width             = 60
  col.maxlength         = 10
  col.caption           = " FEC.VENC."&chr(13)&"dd/mm/yyyy"
  col.column_name       = "fecha_impresion"
  col.tipo              = "date"
  col.readonly          = band_readonly
  col.nullable          = true
  col.expresionRegular  = "^\d{0,2}(\/)?\d{0,2}(\/)?\d{0,4}$"
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "select"
  col.width             = 44
  col.caption           = "TEMP."
  col.column_name       = "temporada"
  col.tipo              = "char"
  'col.sqlselect         = "select temporada value, temporada text from tb_temporadas where visible=1 and temporada <> '' order by text"
  col.sqlselect         = "select temporada value, temporada text from tb_temporadas with(nolock) where visible=1 and temporada <> '' and temporada <> 'ILA' order by text"
  col.readonly          = band_readonly
  col.nullable          = true
  col.optionEmpty       = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 36
  col.maxlength         = 5
  col.column_length     = 3
  col.column_scale      = 2
  col.caption           = "ILA"&chr(13)&"(%)"	
  col.column_name       = "porcentaje_ila"
  col.tipo              = "number"
  col.expresionRegular  = "^\d{0,3}(\.)?\d{0,2}$"
  col.readonly          = true
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 50
  col.maxlength         = 8
  col.caption           = "COD. ARANC."	
  col.column_name       = "codigo_arancelario"
  col.tipo              = "char"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  col.colSaltoLinea     = 4
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "left"
  col.width             = 70
  col.caption           = "PROVEEDOR"
  col.column_name       = "codigo_postal"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col
end if

set col               = new agrid_col
col.kind              = "text"	
col.align             = "left"
col.width             = 60
col.maxlength         = 12
col.caption           = "  PROV."&chr(13)&"ORI."
col.column_name       = "proveedor_origen"
col.tipo              = "char"
col.expresionRegular  = "^[\w\s°/\.áéíóúñÑ:*$%&()=?¿!¡+-]+$"
col.readonly          = band_readonly
col.readonly          = false
col.nullable          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "Left"	
col.width             = 60
col.maxlength         = 10
col.column_length     = 8
col.column_scale      = 4
col.caption           = "COD. CAJA"	
col.column_name       = "codcaja"
col.tipo              = "char"
'col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
'col.separadorMiles    = true
col.readonly          = band_readonly
grid.add_col col


set col               = new agrid_col
col.kind              = "text"	
col.align             = "Left"	
col.width             = 60
col.maxlength         = 10
col.column_length     = 8
col.column_scale      = 4
col.caption           = "COD. ANTIGUO"	
col.column_name       = "codigo_antiguo"
col.tipo              = "char"
'col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
'col.separadorMiles    = true
col.readonly          = true
'col.readonly          = false
grid.add_col col


'---- Nuevas columnas 17 agosto 2012 -----
set col               = new agrid_col
col.kind              = "text"	
col.align             = "left"
col.width             = 90
col.maxlength         = 20
col.caption           = "  CODIGO "&chr(13)&"PROV."	
col.column_name       = "producto_proveedor"
col.tipo              = "char"
col.expresionRegular  = "^[\w\s°/\.áéíóúñÑ:*$%&()=?¿!¡+-]+$"
'col.readonly          = band_readonly
'col.colSaltoLinea     = 4
col.nullable          = true
grid.add_col col


'---- Nuevas columnas 03 octubre 2016 (modificadas y nuevas)-----
if documento_respaldo = "Z" then

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 44
  col.maxlength         = 9
  col.column_length     = 8
  col.column_scale      = 2
  col.caption           = "  CANT"&chr(13)&"ORI."	
  col.column_name       = "cantidad_origen"
  col.tipo              = "number"
  col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
  'col.readonly          = band_readonly
  col.separadorMiles    = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "select"
  col.width             = 65
  col.caption           = " U/M"&chr(13)&"ORI"
  col.column_name       = "unidad_de_medida_origen"
  col.tipo              = "char"
  col.sqlselect         = "select unidad value, unidad text from unidades_de_medida with(nolock) where visible_compra=1 order by text"
  'col.readonly          = band_readonly
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 80
  col.column_scale      = 7
  col.caption           = "EX FAB"	
  col.column_name       = "costo_ex_fab_moneda_origen"
  col.tipo              = "number"
  col.separadorMiles    = true
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 64
  col.maxlength         = 10
  col.column_length     = 8
  col.column_scale      = 2
  col.caption           = "EX FAB" & chr(13) & "TOTAL"
  col.column_name       = "total_ex_fab"
  col.tipo              = "number"
  col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
  'col.readonly          = band_readonly
  col.separadorMiles    = true
  grid.add_col col

  'set col               = new agrid_col
  'col.kind              = "text"	
  'col.align             = "right"	
  'col.width             = 80
  'col.column_scale      = 7
  'col.caption           = "FOB"&chr(13)&"US$"	
  'col.column_name       = "costo_fob_us$"
  'col.tipo              = "number"
  'col.separadorMiles    = true
  'col.readonly          = true
  'grid.add_col col

  'set col               = new agrid_col
  'col.kind              = "text"	
  'col.align             = "right"	
  'col.width             = 64
  'col.maxlength         = 10
  'col.column_length     = 8
  'col.column_scale      = 2
  'col.caption           = "FOB US$" & chr(13) & "TOTAL"
  'col.column_name       = "total_fob_us$"
  'col.tipo              = "number"
  'col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
  'col.readonly          = band_readonly
  'col.separadorMiles    = true
  'grid.add_col col
end if

'------------------------------------------
if vista = "NORMAL" then  
  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "ITEM"
  col.column_name       = "item_1"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col
end if
%>
