<%
Dim RutaProyecto
StrSite       = mid(Request.ServerVariables("SCRIPT_NAME"),1,instr(mid(Request.ServerVariables("SCRIPT_NAME"), 2), "/")+1)
RutaProyecto  = "http://" &Request.serverVariables("Server_Name")& StrSite

strConnect_MSAccess = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & Server.MapPath("novaxion/general/datos/GesCom.mdb")
'strConnect_MSAccess = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & Server.MapPath("novaxion/general/datos/GesCom.mdb") & ";Mode=Share Exclusive"
Dim ConnAccess : set ConnAccess = Server.CreateObject("ADODB.Connection")

sub OpenConn_Access()
  ConnAccess.Open strConnect_MSAccess
end sub

OpenConn_Access

strSQL="SELECT  A.EmplRut as Rut, A.EmplDigito as Dv, (A.EmplApellidoP + ' '+ A.EmplApellidoM + ' ' + A.EmplNombre) as Nombre, " &_
       "    A.EmplFechaNac as FechaNac, B.EmprPaterno as Empresa, " &_
       "    d.MovMenFechaContrato as FechaContrato, " &_
       "    IIf(G.CodRCodigo='1', '0021', IIf(G.CodRCodigo='2', '0011', IIf(G.CodRCodigo='3', '0032', IIf(G.CodRCodigo='4', '0020', IIf(G.CodRCodigo='5', '0007', IIf(G.CodRCodigo='6', '0023', IIf(G.CodRCodigo='7', '0022', IIf(G.CodRCodigo='8', '0004', IIf(G.CodRCodigo='9', '0008', IIf(G.CodRCodigo='10', '0005', IIf(G.CodRCodigo='11', '0009', IIf(G.CodRCodigo='12', '0002', IIf(G.CodRCodigo='13', '0024', ))))))))))))) as Centro_Costo, " &_
       "    G.CodRDescrip as Centro_Costo_Nombre,  e.carNombre as Cargo, MovMenLabor AS Labor, MovMenHorario as Clasif, " &_
       "    (select H.InprNombre from InstPrevisional H where A.EmprCod=H.EmprCod and H.InprCodigo=D.MovMenAFPCod) as AFP, " &_
       "    (select I.InprNombre from InstPrevisional I where A.EmprCod=I.EmprCod and I.InprCodigo=D.MovMenISACod) as Salud, " &_
       "    c.HabDesAno as Año, c.HabDesMes as Mes, " &_
       "     c.MovMenSdoBaseGanado as SueldoBase, " &_
       "     c.MovMenOtrosImponibles as BonoAntiguedad, " &_
       "     c.MovMenGratificacionPagada as Gratif, " &_
       "     c.MovMenSdoImponible as Total_Sueldo_Imp, " &_
       "     c.MovMenTotImponible as Total_Imp, " &_
       "     c.MovMenSdoImponibleAFC as Total_SueldoImpAFC, " &_
       "     c.MovMenAsigMovilizacionPagada as Movil, " &_
       "     c.MovMenTotalNoImponoble as TotNoImp, " &_
       "     c.MovMenTotHaber as TotalH, " &_
       "     c.MovMenAFPTotalPagada as DescAFP," &_
       "     c.MovMenISATotPagada as DescSalud, " &_
       "     c.MovMenISADifIsap as DescDifSalud, " &_
       "     c.MovMenAFCMonto as DescAFC, " &_
       "     c.MovMenOtroDescuentos as DescOtros, " &_
       "     c.MovMenTotDescuentos as TotalDesc, " &_
       "     c.MovMenAlcLiquido as TotalPagLiq, " &_
       "     IIf((select J.MovMenTotalMontoAPV from MovMensualAPV J where A.EmprCod=J.EmprCod and A.EmplRut=MID(TRIM(J.EmplRut),1,LEN(TRIM(J.EmplRut))-1) and c.HabDesAno=J.HabDesAno and c.HabDesMes=J.HabDesMes),'',0) as Total_APV, " &_
       "     c.MovMenTotPagar as TotalPagar, " &_
       "     c.MovMenLey20255 as DescFondoVejez, " &_
       "     d.MovMenLey20255, " &_
       "     d.MovMenTrabLey20255, " &_
       "     c.MovMenSdoTributable, " &_
       "     c.MovMenOtrosNoImponible, " &_
       "     c.MovMenTotAnticipos, " &_
       "     c.MovMenSaldoNeg, " &_
       "     c.MovMenValorCargaFamiliarPagada, " &_
       "     c.MovMenDiasAusenteMonto, " &_
       "     c.MovMenDiasLicenciaMonto, " &_
       "     c.MovMenAFPCtaAhorroMontoPagada, " &_
       "     c.MovMenAFCAporteEmple, " &_
       "     c.MovMenSdoImponibleSIS, " &_
       "     d.EmplExtranjero, " &_
       "     d.HabDesAno, " &_
       "     d.HabDesMes, " &_
       "     d.MovMenCorrel, " &_
       "     d.MovMenCodigo, " &_
       "     d.MovMenFechaInicial, " &_
       "     d.MovMenFechaTermino, " &_
       "     d.MovMenRut, " &_
       "     d.MovMenExt, " &_
       "     d.MovMenTrabAgric, " &_
       "     d.MovMenSdoBasePactado, " &_
       "     d.MovMenDiasContra, " &_
       "     d.MovMenDiasAusente, " &_
       "     d.MovMenDiasNoContratado, " &_ 
       "     d.MovMenDiasLicencia, " &_
       "     d.MovMenHXNormales, " &_
       "     d.MovMenHXNocturnas, " &_
       "     d.MovMenHDescuento, " &_
       "     d.MovMenHXFestivos, " &_
       "     d.MovMenXHNorMonto, " &_
       "     d.MovMenXHNocMonto, " &_
       "     d.MovMenXHFesMonto, " &_
       "     d.MovMenHDesMonto, " &_
       "     d.MovMenOtroImponible, " &_
       "     d.MovMenOtroIsapre, " &_
       "     d.MovMenImptoUnico, " &_
       "     d.MovMenImptoUnicoRel, " &_
       "     d.MovMenAFPCod, " &_
       "     d.MovMenAFPCotAdicTipo, " &_
       "     d.MovMenAFPCotAdicMonto, " &_
       "     d.MovMenAFPCotObli, " &_
       "     d.MovMenAFPCotVolu, " &_
       "     d.MovMenAFPCtaAhorroTipo, " &_
       "     d.MovMenAFPCtaAhorroMonto, " &_
       "     d.MovMenISACod, " &_
       "     d.MovMenISATipoCot, " &_
       "     d.MovMenISACotAdicTipo, " &_
       "     d.MovMenISACotAdicMonto, " &_
       "     d.MovMenTieneDosPor, " &_
       "     d.MovMenISATipoDosPor, " &_
       "     d.MovMenISADosPorMonto, " &_
       "     d.MovMenGratificaTipo, " &_
       "     d.MovMenGratificaMonto, " &_
       "     d.InstCodigo, " &_
       "     d.SucuCodigo, " &_
       "     d.CodResultado, " &_
       "     d.MovMenCargoDesem, " &_
       "     d.MovMenRetroSimple, " &_
       "     d.MovMenRetroMaternales, " &_
       "     d.MovMenRetroInvalidez, " &_
       "     d.MovMenTipoSueldo, " &_
       "     d.MovMenTipMonedaCodigo, " &_ 
       "     d.MovMenDiaCambio, " &_
       "     d.MovMenAsigColacion, " &_
       "     d.MovMenAsigMovilizacion, " &_
       "     d.MovMenAsigZonaEx, " &_
       "     d.MovMenLabor, " &_
       "     d.MovMenHorario, " &_
       "     d.MovMenNCuenta, " &_
       "     d.MovMenFormaPago, " &_
       "     d.MovMenDiasLaborales, " &_
       "     d.MovMenHorasSemanales, " &_
       "     d.MovMenRetroMonto, " &_
       "     d.MovMenCargaSimple, " &_
       "     d.MovMenCargaMaternal, " &_
"            d.MovMenCargaInvalidez, " &_
"            d.MovMenCargaMonto, " &_
"            d.MovMenDiasColacion, " &_
"            d.MovMenDiasMovilizacion, " &_
"            d.MovMenFechaFiniquito, " &_
"            d.MovMenISAServicios, " &_
"            d.MovMenAFPExtranjero, " &_
"            d.MovMenIsaExtranjero, " &_
"            d.MovMenSdoProporcional, " &_
"            d.MovMenTipoHE, " &_
"            d.MovMenFeLeProgresivo, " &_
"            d.MovMenSegDes, " &_
"            d.MovMenInstSegDes, " &_
"            d.MovMenTipContrato, " &_
"            d.MovMenDepositoConvenido, " &_
"            d.MovMenZonaExtrema, " &_
"            d.MovMenPorZonaExtrema, " &_
"            d.MovMenAfiliadoCCHC, " &_
"            d.MovMenTipoPlanCCHC, " &_
"            d.MovMenNoProporcional, " &_
"            d.MovMenActual, " &_
"            d.MovMenFechaIRetro, " &_ 
"            d.MovMenFechaTRetro " &_
"FROM        ((((Empleados AS A INNER JOIN Empresas AS B ON A.EmprCod = B.EmprCod) " &_
"                                INNER JOIN MovimientoMensualAPagar AS C ON A.EmplRut=MID(TRIM(C.EmplRut),1,LEN(TRIM(C.EmplRut))-1)) " &_
"                                 INNER JOIN MovimientoMensual AS D ON (A.EmplRut = MID(TRIM(D.EmplRut),1,LEN(TRIM(D.EmplRut))-1)) AND (C.HabDesAno=D.HabDesAno) AND (C.HabDesMes=d.HabDesMes)) " &_
"                                  INNER JOIN Cargos AS E ON (A.EmprCod=E.EmprCod) AND (D.MovMenCargoDesem=E.CarCod)) " &_
"                                   INNER JOIN CodResult AS G ON D.CodResultado=G.CodRCodigo " &_
"WHERE A.emplRut<>'' and c.habdesmes>0 " &_
"ORDER BY c.habdesmes, A.EmplRut"

strSQL="select * from empleados"
set rs = ConnAccess.Execute(strSQL)
%>
<table width="100%" border=0>
<%
do while not rs.EOF%>
<tr>
  <td><%=rs(0)%></td>
  <td><%=rs(1)%></td>
</tr>
<%rs.MoveNext
loop%>
