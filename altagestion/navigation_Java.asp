<!-- #include file="Fun_dbo.inc"-->
<!-- #include file="Scripts/Inc/Cache.Inc" -->
<%
	Cache
	SET Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Session("Dataconn_ConnectionString")
	Conn.commandtimeout=3600
	cSql = "Exec USR_ListaModulos_PerfilesUsuario '" & Session("Login") & "', Null, Null, Null, Null"
'Response.Write cSql
	Set RsModulos = Conn.Execute( cSql )
	Do While Not RsModulos.eof
		cModulos = cModulos & RsModulos("Modulo") & "|"
		RsModulos.MoveNext
	Loop
	RsModulos.Close
	Set RsModulos = nothing
%>	
<html>
	<head>		  
		<title><%=Session.SessionId%></title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	</head>

<body background="<%=Session("ImagenFondo")%>" text="black">

<% if Request.ServerVariables("REMOTE_ADDR") = "11192.168.30.12" then 
			cMenu = ""
			cSql = "Exec USR_ListaFuncionesPerfilesUsuario '" & Session("Login") & "', Null, Null, Null, 1"
'Response.Write cSql			
			Set RsOpciones = Conn.Execute( cSql )
			Do While Not RsOpciones.eof 
				AModulo = RsOpciones("Modulo")
				d = 0 
				cMenu = cMenu & "['" & AModulo & "','','','','',,,], " & vbCrLf 
				Do While Trim(AModulo) = Trim(RsOpciones("Modulo"))
					ASubMenu = RsOpciones("Grupo") 
					cMenu = cMenu & "['|" & ASubMenu & "','','','','',,,], "  & vbCrLf 
					k = 0
					Do While Trim(AModulo) = Trim(RsOpciones("Modulo")) And Trim(ASubMenu) = Trim(RsOpciones("Grupo"))
						if RsOpciones("Funcion") = "asignarempre" then
							if ( len(trim(Session("Empresa_usuario"))) = 0 Or IsNull(Session("Empresa_usuario")) ) then 
								cMenu = cMenu & "['||" & RsOpciones("Nombre") & "', 'LlamaPaso.asp?NomFun=" & RsOpciones("Funcion") & "','','','',,,], "  & vbCrLf 
							k = k + 1
							end if						
						else
							cMenu = cMenu & "['||" & RsOpciones("Nombre") & "', 'LlamaPaso.asp?NomFun=" & RsOpciones("Funcion") & "','','','',,,], "  & vbCrLf 
							k = k + 1
						end if 
						RsOpciones.MoveNext
							
						if RsOpciones.eof then
							exit do
						end if
					Loop
					d = d + 1
					if RsOpciones.eof then
						exit do
					end if
				Loop
				if RsOpciones.eof then
					exit do
				end if
		Loop
		RsOpciones.Close
		Set RsOpciones = nothing

%>
<HTML>
	<head>
		<title>Nuevo menu</title>
		<script type="text/javascript" language="JavaScript1.2" src="Scripts/Js/apymenu.js"></script>
	</head>

	<body bgcolor=#FFFFFF>

		<input type=hidden name="apy0gk" value="">

		<p align=center>
		<script type="text/javascript" language="JavaScript1.2" wsrc="datacross1.js">
			var blankImage="imagenes/blank.gif";
			var isHorizontal=1;
			var menuWidth="500";
			var absolutePos=0;
			
			var posX=0;
			var posY=0;
			
			var floatable=1;
			var floatIterations=8;
			
			var movable=0;
			var moveCursor="default";
			var moveImage="";
			var moveWidth=0;
			var moveHeight=0;
			
			var fontStyle="normal 8pt Tahoma";
			var fontColor=["#FFFF00","#FFFFFF"];
			var fontDecoration=["none","none"];
			
			var itemBackColor=["#6b8e23","#006400"];
			var itemBorderWidth=0;
			var itemAlign="left";
			var itemBorderColor=["",""];
			var itemBorderStyle=["",""];
			var itemBackImage=["",""];
			var itemSpacing=0;
			var itemPadding=4;
			var itemCursor="hand";
			var itemTarget="Trabajo";
			
			var iconTopWidth=0;
			var iconTopHeight=0;
			var iconWidth=0;
			var iconHeight=0;
			
			var menuBackImage="";
			var menuBackColor="#FFFFFF";
			var menuBorderColor="#000000 ";
			var menuBorderStyle=["solid"];
			var menuBorderWidth=1;
			
			var subMenuAlign="";
			
			var transparency=100;
			var transition=39;
			var transDuration=400;
			
			var shadowColor="#B6B6B6";
			var shadowLen=5;
			
			var arrowImageMain=["",""];
			var arrowImageSub=["imagenes/arrow1_n.gif","imagenes/arrow1_o.gif"];
			var arrowWidth=6;
			var arrowHeight=6;
			
			var separatorImage="imagenes/separ1.gif";
			var separatorWidth="100%";
			var separatorHeight="1";
			var separatorAlignment="";
			var separatorVImage="";
			var separatorVWidth="0";
			var separatorVHeight="100%";
			
			var statusString="link";
			var pressedItem=-1;

			var itemStyles = [
			   ["fontStyle=bold 8pt Tahoma","itemBackColor=#FFD900,#FF812D",],
			   ["itemBackColor=#000000,#3F3F3F","itemBorderColor=#FFFFFF,#FFFFFF",],
			   ["itemBackColor=#BAFF17,#FF962D",],
			];

			var menuStyles = [
			   ["menuBorderColor=#25AD12",],
			];

			var menuItems = [
			   ["Fin sessión","JavaScript:fInicio()","","","",,,], 
			   <%=cMenu%>
			];
			apy_initFrame("fset",0,1,0);
		</script>
		</p>

	</body>
</HTML>
<%else%>

	<%if Len(trim(cModulos)) > 0 then	%>
	   <form name=menu>    
		<table align=center border="0" cellpadding="0" cellspacing="0">
			<tr>
			<td valign=top nowrap>
				<input 
					Style = "	font-family:Arial; 
								font-size:12; 
								line-height:12pt;
								color: rgb(<%=Replace(Session("ColTxtBotNor")," ",",")%>);
								background-color: rgb(<%=Replace(Session("ColBotNormal")," ",",")%>);
								font-weight: bold"
					type=button 
					name="BotonInicio" 
					value="Fin Sesión" 
					OnClick="JavaScript:fInicio()"
					OnMouseOver = "JavaScript:fCambioColorOver()"
					OnMouseOut = "JavaScript:fCambioColorOut()"
				>
			</td>

			<td nowrap>&nbsp;</td>

			<td nowrap>
	<%	
	'	Response.Write len(trim(Session("Empresa_usuario"))) & " *** " & IsNull(Session("Empresa_usuario"))

		cSql = "Exec USR_ListaFuncionesPerfilesUsuario '" & Session("Login") & "', Null, Null, Null, 1"
		Set RsOpciones = Conn.Execute( cSql )
		Do While Not RsOpciones.eof
	'		cOpciones = cOpciones & RsOpciones("Modulo") & "¬" & RsOpciones("Grupo") & "¬" & RsOpciones("Funcion") & "¬" & RsOpciones("Nombre") & "|"%>
			<applet width="95" height="24" code="PopupNavigator/PopupNavigatorApplet.class"    codebase="./" archive="PopupNavigator/PopupNavigator.jar" VIEWASTEXT id=Applet1>
				<param name="DefaultFrame"	value="Trabajo">
				<param name="StatusText"		value="Seleccione una opción">
				<param name="MenuPosition"	value="Bottom">
				<param name="MouseoverLabel" value=';;;12;<%=Session("ColTxtBotOvr")%>;<%=Session("ColBotOver")%>'>
				<param name="MissingUrl"		value="IGNORE">  
				<param name="Label" value='<%=RsOpciones("Modulo")%>;Arial;Bold;12;<%=Session("ColTxtBotNor")%>;<%=Session("ColBotNormal")%>'>
		<%		AModulo = RsOpciones("Modulo")
				d = 0 
				Do While Trim(AModulo) = Trim(RsOpciones("Modulo"))
					ASubMenu = RsOpciones("Grupo") 
					k = 0%>
					<param name="<%=d%>" value='<%=RsOpciones("Grupo")%>;Arial;Bold;12'>
		<%				Do While Trim(AModulo) = Trim(RsOpciones("Modulo")) And Trim(ASubMenu) = Trim(RsOpciones("Grupo"))
							if RsOpciones("Funcion") = "asignarempre" then
								if ( len(trim(Session("Empresa_usuario"))) = 0 Or IsNull(Session("Empresa_usuario")) ) then %>
									<param name="<%=d%>;<%=k%>" value='<%=RsOpciones("Nombre")%>;LlamaPaso.asp?NomFun=<%=RsOpciones("Funcion")%>'>
				<%				k = k + 1
								end if						
							else%>
								<param name="<%=d%>;<%=k%>" value='<%=RsOpciones("Nombre")%>;LlamaPaso.asp?NomFun=<%=RsOpciones("Funcion")%>'>
				<%				k = k + 1
							end if 
							RsOpciones.MoveNext
							
							if RsOpciones.eof then
								exit do
							end if
						Loop
						d = d + 1
						if RsOpciones.eof then
							exit do
						end if
				Loop
				if RsOpciones.eof then
					exit do
				end if%>
				</applet>
		<%Loop
		RsOpciones.Close
		Set RsOpciones = nothing
	%>	
				</applet>
			</td>
		   </tr>              
		</table>
			<input type=Hidden name="LimpiaVarSesion" value="">
	  </form>
	</body>

	</html>

	<%Conn.Close()
	else%>
		<script language="JavaScript">
			alert ( 'Este usuario no tiene opciones asociadas al perfil. \n\n Contáctese con el administrador.' ) ;
			parent.top.location.href = "Index1.htm";
		</script>
	<%end if%>
	
<%end if%>

	<script language="JavaScript">
		function fInicio()
		{
			parent.top.location.href = 'InicioSession.asp'
		}
			
		function fCambioColorOver()
		{
			document.menu.BotonInicio.style.color = 'yellow' ;
			document.menu.BotonInicio.style.background = '#4e9c54' ;
		}
			
		function fCambioColorOut()
		{
			document.menu.BotonInicio.style.color = '#2e4b3d' ;
			document.menu.BotonInicio.style.background = '#96be9d' ;			
		}

	</script>

	<iframe Id="Paso1" Name="Paso1" src="empty.asp" width=0 height=0></iframe>
	<iframe Id="Paso2" Name="Paso2" src="empty.asp" width=0 height=0></iframe>
	<iframe Id="Paso3" Name="Paso3" src="empty.asp" width=0 height=0></iframe>
	<iframe Id="Paso4" Name="Paso4" src="empty.asp" width=0 height=0></iframe>
	<iframe Id="Paso5" Name="Paso5" src="empty.asp" width=0 height=0></iframe>
