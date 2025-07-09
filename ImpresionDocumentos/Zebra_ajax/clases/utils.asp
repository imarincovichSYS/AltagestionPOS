<%
'Rellena Caracteres por la Izquerda
function LPad(Cadena, Largo, Caracter)
   LPad = Cadena
   For j = Len(Cadena) To Largo - 1
      LPad = Mid(Caracter, 1, 1) & LPad
   Next
end function

'*******************************************************
'Obtener la cantidad de dias para una fecha determinada
'*******************************************************
function GetMaxDias(fecha)
  m=month(fecha)
  a=year(fecha)
  select case m
    case 1,3,5,7,8,10,12
      maxDias=31
    case 4,6,9,11
      maxDias=30
    case 2
      if a Mod 4 = 0 then
        maxDias=29
      else
        maxDias=28
      end if
  end select
  GetMaxDias=maxDias
end function

function GetMes(num)
  Select Case num
    Case 1 name ="Enero"
    Case 2 name = "Febrero"
    Case 3 name = "Marzo"
    Case 4 name = "Abril"
    Case 5 name = "Mayo"
    Case 6 name = "Junio"
    Case 7 name = "Julio"
    Case 8 name = "Agosto"
    Case 9 name = "Septiembre"
    Case 10 name = "Octubre"
    Case 11 name = "Noviembre"
    Case 12 name = "Diciembre"
  end Select
  GetMes = name
end function

function GetMesCorto(num)
  Select Case num
    Case 1 name ="Ene"
    Case 2 name = "Feb"
    Case 3 name = "Mar"
    Case 4 name = "Abr"
    Case 5 name = "May"
    Case 6 name = "Jun"
    Case 7 name = "Jul"
    Case 8 name = "Ago"
    Case 9 name = "Sep"
    Case 10 name = "Oct"
    Case 11 name = "Nov"
    Case 12 name = "Dic"
  end Select
  GetMesCorto = name
end function

function GetDiaSemana(num)
  Select Case num
    Case 1 name = "Lunes"
    Case 2 name = "Martes"
    Case 3 name = "Miercoles"
    Case 4 name = "Jueves"
    Case 5 name = "Viernes"
    Case 6 name = "Sabado"
    Case 7 name = "Domingo"
  end Select
  GetDiaSemana = name
end function

function GetDiaSemanaCorto(num)
  Select Case num
    Case 1 name = "Lun"
    Case 2 name = "Mar"
    Case 3 name = "Mie"
    Case 4 name = "Jue"
    Case 5 name = "Vie"
    Case 6 name = "Sab"
    Case 7 name = "Dom"
  end Select
  GetDiaSemanaCorto = name
end function

function Get_Fecha_Formato_YYYY_MM_DD(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
  Get_Fecha_Formato_YYYY_MM_DD = c_anio&"/"&Lpad(c_mes,2,0)&"/"&Lpad(c_dia,2,0)
end function

function Get_Fecha_Formato_YYYY_DD_MM(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
  Get_Fecha_Formato_YYYY_DD_MM = c_anio&"/"&Lpad(c_dia,2,0)&"/"&Lpad(c_mes,2,0)
end function

function Get_Fecha_Formato_DD_MM_YYYY(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
  Get_Fecha_Formato_DD_MM_YYYY = Lpad(c_dia,2,0)&"/"&Lpad(c_mes,2,0)&"/"&c_anio
end function

function Get_Fecha_Formato_MM_DD_YYYY(v_fecha)
  c_dia = day(cdate(v_fecha))
  c_mes = month(cdate(v_fecha))
  c_anio = year(cdate(v_fecha))
  Get_Fecha_Formato_MM_DD_YYYY = Lpad(c_mes,2,0)&"/"&Lpad(c_dia,2,0)&"/"&c_anio
end function
%>