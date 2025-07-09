<%
website = Request.ServerVariables("SERVER_NAME")
If website = "www.altahoteleria.cl" then
   websystem = "AltaHoteleria"
   webtitle = "AltaHotelería, el primer sistema de control y gestión hotelera por internet."
elseif website = "www.altarestaurantes.cl" then
   websystem = "AltaRestaurantes"
   webtitle = "AltaRestaurantes, el primer sistema de control y gestión de restaurantes por internet."
else
   websystem = "AltaGestion"
   webtitle = "AltaGestion, el primer sistema de control y gestión por internet."
end if
%>
<html>
	<head>
		<title><%=websystem%> - Abonados</title>
	</head>
	<body>
		<center>
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width="800" height="60" id="TituloAlgestion" align="middle" VIEWASTEXT>
<param name="allowScriptAccess" value="sameDomain" />
<param name="movie" value="TituloAlgestion.swf" /><param name="loop" value="false" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" /><embed src="TituloAlgestion.swf" loop="false" quality="high" bgcolor="#ffffff" width="800" height="60" name="TituloAlgestion" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>

	<table width=95% align=center border=0 cellspacing=5 cellpadding=0>
<%If websystem = "AltaGestion" Then%>
		<tr valign=bottom height=100>
			<td align=center>
				<a href="JavaScript:Autentifica('FloraCenter')"><img src="abonados/FloraCenter.gif" width=110 height=51 border=0></a>
			</td>
			<td align=center>
				<a href="JavaScript:Autentifica('Altanet')"><img src="abonados/altanet.jpg" width=110 height=51 border=0></a>
			</td>
			<td align=center>
				<a href="JavaScript:Autentifica('LavaMovil')"> <img src="abonados/LogoLavaMovil.gif" width=70 height=70 border=0>Gestion</a>
			</td>

		</tr>

		<tr>
			<td align=center>
				<a href="JavaScript:Autentifica('LavaMovil_II')"> <img src="abonados/LogoLavaMovil.gif" width=70 height=70 border=0>SII</a>
			</td>

			<td align=center>
				<a href="JavaScript:Autentifica('HIDRONOR')"><img src="abonados/Hidronor.jpg" border=0></a>
			</td>

			<td align=center>
				<a href="JavaScript:Autentifica('Cartoni')"><img src="abonados/Cartoni.jpg" width=159 height=61 border=0></a>
			</td>
		</tr>

		<tr>
			<td align=center>
				<a href="JavaScript:Autentifica('Cavada')"><img src="abonados/cavada.jpg" width=189 height=59 border=0></a>
			</td>
			<td align=center>
				<a href="JavaScript:Autentifica('VL')"><img src="abonados/VictoriaLine.gif" width=100 height=100 border=0></a>
			</td>

			<td align=center>
				<a href="JavaScript:Autentifica('AltoLavado')">
				   <img src="abonados/Logotipo.gif" width=125 height=130 border=0>
				</a>
			</td>
		</tr>

		<tr>
			<td align=center>
				<a href="JavaScript:Autentifica('Inser')"><img src="abonados/inser.jpg" width=90 height=90 border=0></a>
			</td>
			<td align=center>
				<a href="JavaScript:Autentifica('TotalPack')"><img src="abonados/TotalPack.gif" width=159 height=48 border=0></a>
			</td>

<!--
			<td align=center>
				<a href="JavaScript:Autentifica('ResterFood')"><img src="abonados/ResterFood.jpg" width=90 height=90 border=0></a>
			</td>
-->
			<td align=center>
				<a href="JavaScript:Autentifica('Gandhi')">GANDHI</a>
			</td>
		</tr>

		<tr>
			<td align=center>
				<a href="JavaScript:Autentifica('CROCS')">CROCS</a>
			</td>
			<td align=center>
				<a href="JavaScript:Autentifica('Demostracion')"><img src="abonados/Demostracion.jpg" width=159 height=61 border=0></a>
			</td>
		</tr>
<%End If%>		
	</table>

		<form name="Destino" action="Autentificacion.asp" method="POST">
			<input type=hidden name="Abonado">
		</form>
		</center>
	</body>
	<Script language="JavaScript">
		function Autentifica(Abonado)
		{
			if ( Abonado == 'FloraCenter' )
			{
				document.Destino.action = 'Abonados/Floracenter/Autentificacion.asp';	
			}
			if ( Abonado == 'TotalPack' )
			{
				document.Destino.action = 'Abonados/TotalPack/Autentificacion.asp';	
			}
			if ( Abonado == 'LavaMovil' || Abonado == 'LavaMovil_II' )
			{
				document.Destino.action = 'Abonados/LavaMovil/Autentificacion.asp';	
			}
			if ( Abonado == 'VL' )
			{
				document.Destino.action = 'Abonados/VictoriaLine/Autentificacion.asp';	
			}
			if ( Abonado == 'AltoLavado' )
			{
				document.Destino.action = 'Abonados/AltoLavado/Autentificacion.asp';	
			}
			if ( Abonado == 'Cavada' )
			{
				document.Destino.action = 'Abonados/Cavada/Autentificacion.asp';	
			}
			if ( Abonado == 'Cartoni' )
			{
				document.Destino.action = 'Abonados/Cartoni/Autentificacion.asp';	
			}
			if ( Abonado == 'Inser' )
			{
				document.Destino.action = 'Abonados/Inser/Autentificacion.asp';	
			}
			if ( Abonado == 'HIDRONOR' )
			{
				document.Destino.action = 'Abonados/Hidronor/Autentificacion.asp';	
			}
			if ( Abonado == 'ResterFood' )
			{
				document.Destino.action = 'Abonados/ResterFood/Autentificacion.asp';	
			}
			if ( Abonado == 'Gandhi' )
			{
				document.Destino.action = 'Abonados/Gandhi/Autentificacion.asp';	
			}
			if ( Abonado == 'CROCS' )
			{
				document.Destino.action = 'Abonados/Crocs/Autentificacion.asp';	
			}
			if ( Abonado == 'Demostracion' )
			{
				document.Destino.action = 'Demo.asp';	
			}
			document.Destino.Abonado.value = Abonado;
			document.Destino.submit();
		}
	</Script>
</html>