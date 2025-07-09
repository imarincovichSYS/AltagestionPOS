<!-- #include file="../../Scripts/Inc/Cache.Inc" -->
<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
	Cache
if len(trim( Session( "DataConn_ConnectionString") )) > 0 then

	msgerror=""
	error=0
	j = request("j")+1
  Fecha_solicitada_informe = request("Fecha_solicitada_informe")
  
		Set ConnManejo_rut= Server.CreateObject("ADODB.Connection")
		ConnManejo_rut.Open Session( "DataConn_ConnectionString" )
		ConnManejo_rut.BeginTrans
		
	cSql_rut = "select distinct count(rut_cajero) as n from	_informe_retiros where " +_
             "fecha between convert(datetime, convert(varchar, month('" & Fecha_solicitada_informe & "')) + '-'+ convert(varchar, day('" & Fecha_solicitada_informe & "')) + '-' + convert(varchar, year('" & Fecha_solicitada_informe & "'))) and convert(datetime, convert(varchar, month('" & Fecha_solicitada_informe & "')) + '-'+ convert(varchar, day('" & Fecha_solicitada_informe & "')) + '-' + convert(varchar, year('" & Fecha_solicitada_informe & "')) + ' ' + convert(varchar, '23:59:59'))"
response.write(cSql_rut)			 
  Set RsManejo_rut = ConnManejo_rut.Execute( cSQL_rut )

  If Not RsManejo_rut.EOF Then  
    n = RsManejo_rut("n")
  End if  


		Set ConnManejo_rut_cajero= Server.CreateObject("ADODB.Connection")
		ConnManejo_rut_cajero.Open Session( "DataConn_ConnectionString" )
		ConnManejo_rut_cajero.BeginTrans
		
	cSql_rut_cajero = "select distinct rut_cajero as rut_cajero from	retiros_cajas where " +_
             "fecha between convert(datetime, convert(varchar, month('" & Fecha_solicitada_informe & "')) + '-'+ convert(varchar, day('" & Fecha_solicitada_informe & "')) + '-' + convert(varchar, year('" & Fecha_solicitada_informe & "'))) and convert(datetime, convert(varchar, month('" & Fecha_solicitada_informe & "')) + '-'+ convert(varchar, day('" & Fecha_solicitada_informe & "')) + '-' + convert(varchar, year('" & Fecha_solicitada_informe & "')) + ' ' + convert(varchar, '23:59:59')) group by rut_cajero"
  
  'response.write(cSql_rut_cajero)	
  Set RsManejo_rut_cajero = ConnManejo_rut_cajero.Execute( cSql_rut_cajero )



	   for i=1 to n '--> cantidad de retiros
	     for k=1 to j '--> cantidad de cajeros(as)
	       	Set ConnManejo= Server.CreateObject("ADODB.Connection")
 		      ConnManejo.Open Session( "DataConn_ConnectionString" )
		      ConnManejo.BeginTrans
		      'If Not RsManejo_rut_cajero.EOF Then  
	      	cSQL	=	"Exec RET_Modificar_Retiro_caja '"	& request("num_retiro_" & k & "_" & RsManejo_rut_cajero("rut_cajero")) & "', '" 	& +_
	      	                                              request("Fecha_solicitada_informe") & "', '" & +_
											                                  request("total_" & k & "_" & RsManejo_rut_cajero("rut_cajero")) & "', '" & +_
											                                  session("login") & "'"
					'End If
					Set RsManejo = ConnManejo.Execute( cSQL )
					'response.write cSQL & "<br>"
					ConnManejo.CommitTrans
	     next
	     RsManejo_rut_cajero.MoveNext
	   next

'response.end


		
%>

<%
'response.write puerto
%>


<body bgcolor="<%=Session("ColorFondo")%>" background="../../<%=Session("ImagenFondo")%>" leftmargin=0 topmargin=0 text="#000000">
</body>

<script language="JavaScript">
  	parent.top.frames[2].location.href = "Botones_CambCodProd.asp";
		parent.top.frames[1].location.href = "Inicial_CambCodProd.asp";
</script>
<%else
	Response.Redirect "../../index.htm"
end if%>
