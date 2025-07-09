<%   
set col         = new agrid_col
col.kind        = "checkbox"
col.width       = 25
col.caption     = ""
col.column_name = ""
if accion="EDITAR" then col.readonly = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "center"
col.width             = 26
col.caption           = "N°"
col.column_name       = "id_gasto"
col.tipo              = "char"
col.readonly          = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"
col.align             = "left"
col.width             = 280
col.caption           = "GASTO"
col.column_name       = "n_gast0"
col.tipo              = "char"
col.readonly = true
grid.add_col col

set col               = new agrid_col
col.kind              = "text"	
col.align             = "right"	
col.width             = 40
col.maxlength         = 5
col.caption           = "VALOR"	
col.column_name       = "valor"
col.tipo              = "number"
col.expresionRegular  = "^\d+$"
if accion="EDITAR" then col.readonly = true
grid.add_col col

set col         = new agrid_col
col.kind        = "file"
col.width       = 100
col.tipo        = "char"
col.caption     = "ARCHIVO"
col.column_name = "nom_archivo"
if accion="EDITAR" then col.readonly = true
grid.add_col col
%>