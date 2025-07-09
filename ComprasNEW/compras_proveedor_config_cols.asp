<%
set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 220
col.maxlength         = 50
col.caption           = "NOMBRE EMPRESA"
col.column_name       = "apellidos_persona_o_nombre_empresa"
col.tipo              = "char"
col.expresionRegular  = "^[\w\s\.αινσϊρΡ-]+$"
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 300
col.maxlength         = 50
col.caption           = "DIRECCION"
col.column_name       = "direccion"
col.tipo              = "char"
col.expresionRegular  = "^[\w\s\.αινσϊρΡ-]+$"
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "left"	
col.width             = 100
col.maxlength         = 20
col.caption           = "TELEFONO"	
col.column_name       = "telefono"
col.tipo              = "char"
col.expresionRegular  = "^\d+$"
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 100
col.maxlength         = 12
col.caption           = "CODIGO PROVEEDOR"
col.column_name       = "codigo_postal"
col.tipo              = "char"
col.nullable          = true
col.expresionRegular  = "^[\wρΡ]+$"
grid.add_col col

set col               = new agrid_col
col.kind              = "select"
col.width             = 192
col.caption           = "COMUNA"
col.column_name       = "comuna"
col.tipo              = "char"
col.sqlselect         = "select comuna value, nombre text from Comunas with(nolock) order by text"
col.readonly          = band_readonly
'col.nullable          = true
col.optionEmpty       = true
grid.add_col col

'set col               = new agrid_col
'col.kind              = "select"
'col.width             = 140
'col.caption           = "CLASIFICACION PROVEEDOR"
'col.column_name       = "clasificacion_proveedor"
'col.tipo              = "char"
'col.sqlselect         = "select clasificacion_de_proveedor value, nombre text from clasificaciones_de_proveedores order by text"
'grid.add_col col
%>