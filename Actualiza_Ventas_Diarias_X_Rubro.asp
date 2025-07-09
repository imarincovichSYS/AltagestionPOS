<%@ Language=VBScript %>
<!--#include file="_private/config.asp" -->
<!--#include file="_private/funciones_generales.asp" -->
<%
Response.Buffer = false
Server.ScriptTimeout = 2000
function Get_Fecha_Formato_YYYY_MM_DD(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
  Get_Fecha_Formato_YYYY_MM_DD = c_anio&"/"&Lpad(c_mes,2,0)&"/"&Lpad(c_dia,2,0)
end function

'*********** Especifica la codificación y evita usar caché **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

OpenConn

anio  = 2013
mes   = 11

fecha_inicio  = "01-" & mes & "-" & anio
fecha_termino = GetMaxDias(fecha_inicio) & "-" & mes & "-" & anio

fecha_inicio_YYYYMMDD  = Get_Fecha_Formato_YYYY_MM_DD(fecha_inicio)
fecha_termino_YYYYMMDD = Get_Fecha_Formato_YYYY_MM_DD(fecha_termino)

strSQL="select superfamilia from historico_ventas_diarias_por_local_y_rubro where year(fecha) = " & anio & " and month(fecha) = " & mes
set rs_existe = Conn.Execute(strSQL)
if not rs_existe.EOF then
  Response.Write "<font color='#CC0000'><center><b>Año: "&anio&" - mes: "&mes&", ya fue actualizado en el sistema</b></center></font>"
  Response.End
else
  'strSQL="select B.superfamilia, A.fecha, A.valor from " &_
  '       "(select R = substring(producto,1,1), fecha=convert(varchar(10), fecha_movimiento,111), valor = sum(valor_movimiento/valor_paridad_moneda_oficial) " &_
  '       "from movimientos_productos (nolock) " &_
  '       "where empresa='SYS' and (documento_no_valorizado = 'DVT' or documento_no_valorizado='DDV') " &_
  '       "and (fecha_movimiento between '"&fecha_inicio_YYYYMMDD&"' and '"&fecha_termino_YYYYMMDD&" 23:59:59') " &_
  '       "group by convert(varchar(10), fecha_movimiento,111), substring(producto,1,1) ) A, " &_
  '       "(select superfamilia from superfamilias) B " &_
  '       "where A.R=*B.superfamilia " &_
  '       "order by superfamilia, fecha"
  strSQL="select bodega, superfamilia = substring(producto,1,1), fecha = convert(varchar(10), fecha_movimiento,111), " &_
         "valor = sum(valor_movimiento/valor_paridad_moneda_oficial) " &_
         "from movimientos_productos (nolock) where empresa='SYS' and (documento_no_valorizado = 'DVT' or documento_no_valorizado='DDV') " &_
         "and (fecha_movimiento between '"&fecha_inicio_YYYYMMDD&"' and '"&fecha_termino_YYYYMMDD&" 23:59:59') " &_
         "group by bodega, substring(producto,1,1), convert(varchar(10), fecha_movimiento,111) " &_
         "order by bodega, substring(producto,1,1), convert(varchar(10), fecha_movimiento,111) "
  set rs = Conn.Execute(strSQL)
  do while not rs.EOF
    if not IsNull(rs("bodega")) and not IsNull(rs("fecha")) and not IsNull(rs("valor")) then
      bodega            = trim(rs("bodega"))
      superfamilia      = trim(rs("superfamilia"))
      fecha_YYYY_MM_DD  = Get_Fecha_Formato_YYYY_MM_DD(rs("fecha"))
      valor             = Replace(rs("valor"),",",".")
      strSQL="insert into historico_ventas_diarias_por_local_y_rubro(bodega, superfamilia, fecha, valor) values " &_
             "('"&bodega&"', '"&superfamilia&"', '"&fecha_YYYY_MM_DD&"', "&valor&")"
      'Response.Write strSQL & "<br>"
      Conn.Execute(strSQL)
    end if
    rs.MoveNext
  loop
  Response.Write "<center><b>Datos cargados exitosamente!!, mes: " & mes & ", año: " & anio & "</b></center>"
end if
%>
