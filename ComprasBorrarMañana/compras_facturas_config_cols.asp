<%
band_readonly = false
if documento_no_valorizado="RCP" then band_readonly = true

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
col.column_name       = "numero_linea"
col.tipo              = "char"
col.readonly          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "select"
col.width             = 100
col.caption           = "TIPO GASTO"
col.column_name       = "tipo_gasto"
col.tipo              = "char"
col.sqlselect         = "select tipo_gasto value, n_tipo_gasto text from tb_tipos_gastos_facturas where order by tipo_gasto"
col.readonly          = band_readonly
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "left"
col.width             = 130
col.maxlength         = 20
col.caption           = "N° FACTURA ORIGINAL"
col.column_name       = "numero_factura_original"
col.tipo              = "char"
col.expresionRegular  = "^[\w\s°/\.αινσϊρΡ:*$%&()=?Ώ!‘+-]+$"
col.readonly          = band_readonly
col.nullable          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "right"	
col.width             = 80
col.maxlength         = 12
col.caption           = "N° FACTURA"	
col.column_name       = "numero_factura_parcial"
col.tipo              = "number"
col.expresionRegular  = "^\d+$"
col.readonly          = band_readonly
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "right"	
col.width             = 140
col.caption           = "N° FACTURA FINAL"	
col.column_name       = "numero_factura_final"
col.tipo              = "number"
col.readonly          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "right"	
col.width             = 70
col.maxlength         = 10
col.column_length     = 8
col.column_scale      = 2
col.caption           = "TOTAL"
col.column_name       = "total"
col.tipo              = "number"
col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
col.readonly          = band_readonly
col.separadorMiles    = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "right"	
col.width             = 70
col.maxlength         = 10
col.column_length     = 8
col.column_scale      = 2
col.caption           = "MONTO"
col.column_name       = "monto"
col.tipo              = "number"
col.expresionRegular  = "^\d{0,8}(\.)?\d{0,2}$"
col.readonly          = band_readonly
col.separadorMiles    = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 140
col.maxlength         = 100
col.caption           = "OBSERVACION"
col.column_name       = "observacion"
col.tipo              = "char"
col.readonly          = band_readonly
col.nullable          = true
col.expresionRegular  = "^[\w\s°/\.αινσϊρΡ:*$%&()=?Ώ!‘+-]+$"
col.movHorizontal     = false
grid.add_col col
%>