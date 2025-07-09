<%
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
col.width             = 46
col.maxlength         = 4
col.caption           = "  ITEM"&chr(13)&"DESTINO"
col.column_name       = "numero_de_linea_destino"
col.tipo              = "number"
col.expresionRegular  = "^\d+$"
col.nullable          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 60
col.maxlength         = 9
col.caption           = "PRODUCTO"
col.column_name       = "producto"
col.tipo              = "char"
col.readonly          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 300
col.maxlength         = 50
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
col.readonly          = true
col.separadorMiles    = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "right"	
col.width             = 44
col.maxlength         = 9
col.column_length     = 8
col.column_scale      = 2
col.caption           = "CANT"&chr(13)&"TRASP"	
col.column_name       = "cantidad_traspaso"
col.tipo              = "number"
col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
col.readonly          = true
col.separadorMiles    = true
col.colSaltoLinea     = 2
grid.add_col col
%>
