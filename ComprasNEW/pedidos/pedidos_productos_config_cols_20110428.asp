<%
band_readonly = false
'if accion="EDITAR" then band_readonly = true

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
col.column_name       = "numero_de_linea"
col.tipo              = "char"
col.readonly          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 60
col.maxlength         = 9
col.caption           = "PRODUCTO"
col.column_name       = "producto"
col.tipo              = "char"
col.expresionRegular  = "^[\wnÑ]+$"
col.readonly          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 60
col.maxlength         = 9
col.caption           = "PROD COD PROV"
col.column_name       = "producto_cod_prov"
col.tipo              = "char"
col.expresionRegular  = "^[\wnÑ]+$"
col.readonly          = band_readonly
col.nullable          = true
grid.add_col col

'if checktodos = "true" then 
'end if

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
if tcp_1 or tcp_2 or tcp_3 or tcp_4 or tcp_5 then 
  col.width             = 200
else
  col.width             = 298
end if
col.caption           = "DESCRIPCION"
col.column_name       = "nombre_producto"
col.tipo              = "char"
col.readonly          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "right"	
col.width             = 44
col.maxlength         = 9
col.column_length     = 8
col.column_scale      = 2
col.caption           = "CANT"&chr(13)&"M."	
col.column_name       = "cantidad_mercancias"
col.tipo              = "number"
col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
col.readonly          = band_readonly
col.separadorMiles    = true
grid.add_col col

set col               = new agrid_col
col.kind              = "select"
col.width             = 44
col.caption           = " UN."&chr(13)&"COMP."
col.column_name       = "unidad_de_medida_compra"
col.tipo              = "char"
col.sqlselect         = "select unidad value, unidad text from unidades_de_medida where visible_compra=1 order by text"
col.readonly          = band_readonly
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "right"	
col.width             = 30
col.maxlength         = 5
col.caption           = "CANT X M."	
col.column_name       = "cantidad_um_compra_en_caja_envase_compra"
col.tipo              = "number"
col.expresionRegular  = "^\d+$"
col.readonly          = band_readonly
grid.add_col col

set col               = new agrid_col
col.kind              = "select"
col.width             = 44
col.caption           = " UN."&chr(13)&"VTA"
col.column_name       = "unidad_de_medida_consumo"
col.tipo              = "char"
col.sqlselect         = "select unidad value, unidad text from unidades_de_medida where visible_venta=1 order by text"
col.readonly          = band_readonly
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "right"	
col.width             = 30
col.maxlength         = 5
col.caption           = "CANT X UN"	
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
col.caption           = "CANT"&chr(13)&"VTA"	
col.column_name       = "cantidad_entrada"
col.tipo              = "number"
col.expresionRegular  = "^\d+$"
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

if tcp_1 then
  '----------- TCP 1 ----------
  cant_TCP = cant_TCP + 1
  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 26
  col.caption           = "TIPO"&chr(13)&" 1"
  col.column_name       = "documento_respaldo_1"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "   N°"&chr(13)&" 1"
  col.column_name       = "numero_documento_respaldo_1"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "ITEM"&chr(13)&" 1"
  col.column_name       = "numero_de_linea_1"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 32
  col.maxlength         = 5
  col.caption           = "CANT"&chr(13)&" 1"	
  col.column_name       = "cantidad_entrada_1"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  grid.add_col col
end if

if tcp_2 then
  '----------- TCP 2 ----------
  cant_TCP = cant_TCP + 1
  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 26
  col.caption           = "TIPO"&chr(13)&" 2"
  col.column_name       = "documento_respaldo_2"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "   N°"&chr(13)&" 2"
  col.column_name       = "numero_documento_respaldo_2"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "ITEM"&chr(13)&" 2"
  col.column_name       = "numero_de_linea_2"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 32
  col.maxlength         = 5
  col.caption           = "CANT"&chr(13)&" 2"
  col.column_name       = "cantidad_entrada_2"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  grid.add_col col
end if
if tcp_3 then
  '----------- TCP 3 ----------
  cant_TCP = cant_TCP + 1
  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 26
  col.caption           = "TIPO"&chr(13)&" 3"
  col.column_name       = "documento_respaldo_3"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "   N°"&chr(13)&" 3"
  col.column_name       = "numero_documento_respaldo_3"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "ITEM"&chr(13)&" 3"
  col.column_name       = "numero_de_linea_3"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 32
  col.maxlength         = 5
  col.caption           = "CANT"&chr(13)&" 3"
  col.column_name       = "cantidad_entrada_3"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  grid.add_col col
end if

if tcp_4 then
  '----------- TCP 4 ----------
  cant_TCP = cant_TCP + 1
  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 26
  col.caption           = "TIPO"&chr(13)&" 4"
  col.column_name       = "documento_respaldo_4"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "   N°"&chr(13)&" 4"
  col.column_name       = "numero_documento_respaldo_4"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "ITEM"&chr(13)&" 4"
  col.column_name       = "numero_de_linea_4"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 32
  col.maxlength         = 5
  col.caption           = "CANT"&chr(13)&" 4"
  col.column_name       = "cantidad_entrada_4"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  grid.add_col col
end if

if tcp_5 then
  '----------- TCP 5 ----------
  cant_TCP = cant_TCP + 1
  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 26
  col.caption           = "TIPO"&chr(13)&" 5"
  col.column_name       = "documento_respaldo_5"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "   N°"&chr(13)&" 5"
  col.column_name       = "numero_documento_respaldo_5"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "ITEM"&chr(13)&" 5"
  col.column_name       = "numero_de_linea_5"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 32
  col.maxlength         = 5
  col.caption           = "CANT"&chr(13)&" 5"
  col.column_name       = "cantidad_entrada_5"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  grid.add_col col
end if

if tcp_1 or tcp_2 or tcp_3 or tcp_4 or tcp_5 then 
  set col               = new agrid_col
  col.kind              = "text"	
  col.align             = "right"	
  col.width             = 60
  col.maxlength         = 5
  col.caption           = "ANULADOS"
  col.column_name       = "cantidad_anulados"
  col.tipo              = "number"
  col.expresionRegular  = "^\d+$"
  col.readonly          = band_readonly
  grid.add_col col

  set col               = new agrid_col
  col.kind              = "text"
  col.align             = "center"
  col.width             = 28
  col.caption           = "DIF"
  col.column_name       = "diferencia"
  col.tipo              = "char"
  col.readonly          = true
  grid.add_col col
end if
%>