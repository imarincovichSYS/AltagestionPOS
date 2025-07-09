<!-- #include file="../Scripts/Inc/Cache.Inc" -->
<%
	Cache
%>
<HTML>
<HEAD>
	<style>
	.oculto
	{
	    CLEAR: both;
	    DISPLAY: none
	}
	</style>

<!-- detect Java Web Start in Netscape -->
	<script language="JavaScript">
		javawsInstalled = 0; 
		javaws12Installed = 0; 
		javaws142Installed=0; 
		isIE = "false"; 
		if (navigator.mimeTypes && navigator.mimeTypes.length) {    
		  x = navigator.mimeTypes['application/x-java-jnlp-file'];    
		  if (x || (navigator.userAgent.indexOf("Gecko") !=-1)) { 
		    javawsInstalled = 1; 
		    javaws12Installed=1;       
		    javaws142Installed=1;    
		  } 
		} 
		else {    
		  isIE = "true"; 
		}
	</script>

	<!-- detect Java Web Start in IE -->
	<SCRIPT LANGUAGE="VBScript">
		on error resume next
		If isIE = "true" Then
		  If Not(IsObject(CreateObject("JavaWebStart.isInstalled"))) Then
		     javawsInstalled = 0
		  Else
		     javawsInstalled = 1
		  End If
		  If Not(IsObject(CreateObject("JavaWebStart.isInstalled.2"))) Then
		     javaws12Installed = 0
		  Else
		     javaws12Installed = 1
		  End If
		  If Not(IsObject(CreateObject("JavaWebStart.isInstalled.1.4.2.0"))) Then
		     javaws142Installed = 0
		  Else
		     javaws142Installed = 1
		  End If  
		End If
	</SCRIPT>

	<SCRIPT LANGUAGE="JavaScript"> 

		function checkNetscape() {
		  document.msDefault.src = "images/no.gif";
		  document.msInstalled.src = "images/no.gif";
		  document.msSecurity.src = "images/no.gif";
		  msInfo ="You are not using Internet Explorer so you cannot use the Microsoft Java VM. ";

		  found = false;
		  version = "";
		  pluginFound = false;
		  s = "";
		  for (i = 0; (i < navigator.mimeTypes.length) && (!pluginFound); i++) {
		    p = navigator.mimeTypes[i].enabledPlugin;
		    if (p != null) {
		      if (p.description.toLowerCase().substring(0, 4) == "java") {
		        version = p.description;
		        pluginFound = true;
		      }
		    }
		  }
		  if (pluginFound) {
		    document.pluginDefault.src = "images/yes.gif";
		    document.pluginInstalled.src = "images/yes.gif";
		    document.pluginSecurity.src = "images/yes.gif";
		    pluginInfo = "You have the Sun Java Plug-in ("+version+") installed as default Java version. Nevertheless the Java Web Start version is recommended since you can run it off-line. Please note that you will get a security warning when you start the Design Wizard. You have to give Design Wizard full permission, otherwise you will not be able to save the generated design to a file on your harddisk.";
		      if (javawsInstalled) {
		        document.webstartDefault.src = "images/no.gif";
		        document.webstartInstalled.src = "images/yes.gif";
		        document.webstartSecurity.src = "images/yes.gif";
		        //document.cookieform.designwizardversion[2].checked=true;
		        webstartInfo = "You can run the Java Web Start version. This is preferred because you will be able to run Design Wizard off-line. Please note that you will get a security warning when you start the Design Wizard. You have to give the Design Wizard full permission, otherwise you will not be able to save the generated design to a file on your harddisk.";
		      }
		      else {
		        document.webstartDefault.src = "images/no.gif";
		        document.webstartInstalled.src = "images/no.gif";
		        document.webstartSecurity.src = "images/no.gif";
		        //document.cookieform.designwizardversion[1].checked=true;
		        webstartInfo = "Although you have the Java Plug-in installed, you cannot run the Java Web Start version. This might mean that you have to reinstall Sun's Java Runtime Environment if you want to use Web Start.";
		      }
		  }
		  else {
		    document.pluginDefault.src = "images/no.gif";
		    document.pluginInstalled.src = "images/no.gif";
		    document.pluginSecurity.src = "images/no.gif";
		    pluginInfo = "You are running Netscape, but no Java Plug-in is installed.";
		    pluginInfo += "If you download the latest Netscape version, the Java Plug-in will be installed automatically.";
		    pluginInfo += "You can download the latest Netscape from:<p><a href='http://download.netscape.com' target='netscape'>http://download.netscape.com</a>";
		    pluginInfo += "<p>After installing the latest Netscape version, please visit this page again.";
		    pluginInfo += "<p>Instead of installing a new version of Netscape, you can install the latest Java Runtime Environment. ";
		    pluginInfo += "If you open the Java Plugin version of the Design Wizard, the download should start automatically.";
		      if (javawsInstalled) {
		        document.webstartDefault.src = "images/no.gif";
		        document.webstartInstalled.src = "images/yes.gif";
		        document.webstartSecurity.src = "images/yes.gif";
		        //document.cookieform.designwizardversion[2].checked=true;
		        webstartInfo = "You can run the Java Web Start version. This is preferred because you will be able to run Design Wizard off-line. Please note that you will get a security warning when you start the Design Wizard. You have to give the Design Wizard full permission, otherwise you will not be able to save the generated design to a file on your harddisk.";
		      }
		      else {
		        document.webstartDefault.src = "images/no.gif";
		        document.webstartInstalled.src = "images/no.gif";
		        document.webstartSecurity.src = "images/no.gif";
		        webstartInfo = "You do not have the Sun Java Plug-in or Web Start installed on your system. ";
		        webstartInfo += "If you download the latest Netscape version, the Java Plug-in will be installed automatically.";
		        webstartInfo += "You can download the latest Netscape from:<p><a href='http://download.netscape.com' target='netscape'>http://download.netscape.com</a>";
		        webstartInfo += "<p>After installing the latest Netscape version, please visit this page again.";
		      }

		  }
		  
		}

		function checkMicrosoft() {
		  applet = document.appletNoPlugin;
		  try {
		    applet.getJavaVersion();
		  }
		  catch (e) {
		    // no Microsoft Java
			applet = null;
		  }
		  if (!navigator.javaEnabled() || applet == null) {
		    document.msDefault.src = "images/no.gif";
		    document.msInstalled.src = "images/no.gif";
		    document.msSecurity.src = "images/no.gif";

		    msInfo ="You are running Internet Explorer without any Java Virtual Machine installed.";
		    msInfo += "Please enable the Java VM or install the Java plug-in from:";
		    msInfo += "<p><a href='http://java.sun.com/getjava' target='javavm'>http://java.sun.com/getjava</a>";
		    msInfo += "<p>After installing the Java Plug-in, please visit this page again.";
		    
		    document.pluginDefault.src = "images/no.gif";
		    document.pluginInstalled.src = "images/no.gif";
		    document.pluginSecurity.src = "images/no.gif";
		    
		    pluginInfo = msInfo;
		    
		    document.webstartDefault.src = "images/no.gif";
		    document.webstartInstalled.src = "images/no.gif";
		    document.webstartSecurity.src = "images/no.gif";
		    
		    if (javawsInstalled) {
		      document.webstartDefault.src = "images/no.gif";
		      document.webstartInstalled.src = "images/yes.gif";
		      document.webstartSecurity.src = "images/yes.gif";
		      //document.cookieform.designwizardversion[2].checked=true;
		      webstartInfo = "You can run the Java Web Start version. This is preferred because you will be able to run Design Wizard off-line. Please note that you will get a security warning when you start the Design Wizard. You have to give the Design Wizard full permission, otherwise you will not be able to save the generated design to a file on your harddisk.";
		    }
		    else {
		      document.webstartDefault.src = "images/no.gif";
		      document.webstartInstalled.src = "images/no.gif";
		      document.webstartSecurity.src = "images/no.gif";
		      webstartInfo = msInfo;
		    }
		  }
		  else {
		    version = applet.getJavaVersion();
		    if (1.0*version.substring(0, 3) >= 1.2) {
		      document.msDefault.src = "images/no.gif";
		      document.msInstalled.src = "images/question.gif";
		      document.msSecurity.src = "images/question.gif";
		      msInfo = "You have the Sun Java Plug-in ("+version+") installed as default Java version. This means that you can run the Java Plug-in and/or the Java Web Start version.";

		      document.pluginDefault.src = "images/yes.gif";
		      document.pluginInstalled.src = "images/yes.gif";
		      document.pluginSecurity.src = "images/yes.gif";
		      pluginInfo = "You have the Sun Java Plug-in ("+version+") installed as default Java version. Nevertheless the Java Web Start version is recommended since you can run it off-line. Please note that you will get a security warning when you start the Design Wizard. You have to give the Design Wizard full permission, otherwise you will not be able to save the generated design to a file on your harddisk.";

		      if (javawsInstalled) {
		        document.webstartDefault.src = "images/no.gif";
		        document.webstartInstalled.src = "images/yes.gif";
		        document.webstartSecurity.src = "images/yes.gif";
		        //document.cookieform.designwizardversion[2].checked=true;
		        webstartInfo = "You can run the Java Web Start version. This is preferred because you will be able to run Design Wizard off-line. Please note that you will get a security warning when you start the Design Wizard. You have to give the Design Wizard full permission, otherwise you will not be able to save the generated design to a file on your harddisk.";
		      }
		      else {
		        document.webstartDefault.src = "images/no.gif";
		        document.webstartInstalled.src = "images/no.gif";
		        document.webstartSecurity.src = "images/no.gif";
		        //document.cookieform.designwizardversion[1].checked=true;
		        webstartInfo = "Although you have the Java Plug-in installed, you cannot run the Java Web Start version. This might mean that you have to reinstall Sun's Java Runtime Environment if you want to use Web Start.";
		      }
		    }
		    else {  // version = 1.1
		      document.msDefault.src = "images/yes.gif";
		      document.msInstalled.src = "images/yes.gif";
		      var b = applet.securityTest();

		      if (b) document.msSecurity.src = "images/yes.gif";
		      else document.msSecurity.src = "images/no.gif";

		      if (b) msInfo = " Your security settings are OK, so you can run the Design Wizard using the Microsoft VM.";
		      else {
		          msInfo = "<p>In order to save the generated design to your local hard disk you need to change the security ";
		          msInfo += "settings of your browser:";
		          msInfo += "<ul>";
		          msInfo += "<li>Start Internet Explorer and click on Tools (in IE 4: view) and then Internet Options. Choose the Security tab.";
		          msInfo += "<li>Click on the icon Trusted Sites (in IE 4: pull-down menu)";
		          msInfo += "<li>Click on Sites (in IE 4: Add sites...)";
		          msInfo += "<li>Make sure that Require server verification (https:) for all sites in this zone is <b>NOT</b> checked!";
		          msInfo += "<li>Enter in the text field: <tt>http://www.win.tue.nl</tt>";
		          msInfo += "<li>Click the Add button"; 
		          msInfo += "Click OK.";
		          msInfo += "<li>Now select Custom level";
		          msInfo += "<li>Find Java Permissions in the list and selecten <i>Custom</i>, a new button appears in the bottom left corner: Java Custom Settings. Click on this button.";
		          msInfo += "<li>Click the Edit Permissions tab.";
		          msInfo += "<li>Click on Run unsigned content: Enable";
		          msInfo += "<li>Click on Run signed content: Enable";
		          msInfo += "<li>Click some times on Ok until all dialogs have disappeared.";
		          msInfo += "</ul>";
		          msInfo += "Now restart your browser. If you did everything right, you should see a green check with Trusted Zone in the right side of the status bar.";
		      }

		      document.pluginDefault.src = "images/no.gif";
		      
		      applet2 = document.appletPlugin;
		      if (applet2 == null) {
		        msInfo = "You have the Microsoft Virtual Machine installed as default Java version."+msInfo;
		        document.pluginInstalled.src = "images/no.gif";
		        document.pluginSecurity.src = "images/no.gif";
		        //document.cookieform.designwizardversion[0].checked=true;
		        pluginInfo = "You do not have the Sun Java Plug-in installed as default Java version. You have to use the Microsoft VM.";
		    pluginInfo += "<p>Alternatively, you can install the latest Java Runtime Environment. ";
		    pluginInfo += "If you open the Java Plugin version of the Design Wizard, the download should start automatically.";      }
		      else {
		        msInfo = "You could use the Sun Java Plug-in version, but you have the Microsoft Virtual Machine installed as default Java version."+msInfo;

		        document.pluginInstalled.src = "images/yes.gif";
		        document.pluginSecurity.src = "images/yes.gif";
		        pluginInfo = "You have the Sun Java Plug-in (version "+applet2.getJavaVersion()+") installed, but it is not registered as default Java version. You have to use the Microsoft VM. ";
		        //document.cookieform.designwizardversion[1].checked=true;
		        var version2 = applet2.getJavaVersion();
		        if (1.0*version.substring(0, 3) >= 1.4) {
		          pluginInfo += " You can also choose to set the Sun Java Plug-in ("+version2+") as default Java version. "; 
		          pluginInfo += "If you want this, change the following settings in Internet Explorer:";
		          pluginInfo += "<ul><li>Go to the <b>Tools</b> menu, then choose <b>Internet Options</b>";
		          pluginInfo += "<li>Go to the <b>Advanced</b> tab";
		          pluginInfo += "<li>Locate the <b>Java (sun)</b> section";
		          pluginInfo += "<li>Enable the checkbox <b>Use Java 2 for &lt;applet&gt; (requires restart)</b>";
		          pluginInfo += "<li>Press OK, and restart the browser.</ul>"  
		        }        
		      }
		      if (javawsInstalled) {
		        document.webstartDefault.src = "images/no.gif";
		        document.webstartInstalled.src = "images/yes.gif";
		        document.webstartSecurity.src = "images/yes.gif";
		        //document.cookieform.designwizardversion[2].checked=true;
		        webstartInfo = "You can run the Java Web Start version. This is preferred because you will be able to run Design Wizard off-line. Please note that you will get a security warning when you start the Design Wizard. You have to give the Design Wizard full permission, otherwise you will not be able to save the generated design to a file on your harddisk.";
		      }
		      else {
		        document.webstartDefault.src = "images/no.gif";
		        document.webstartInstalled.src = "images/no.gif";
		        document.webstartSecurity.src = "images/no.gif";
		        webstartInfo = "You do not have the Sun Java Plug-in or Web Start installed on your system. You have to use the Microsoft VM.";
		      }
		    }
		  }

		}

		function checkJavaPlugin() {
		  var javapar = document.getElementById("javapar");
		  if (isIE == "true") checkMicrosoft();
		  else checkNetscape();
		}
	</SCRIPT> 
</head>


<body class=oculto onload="checkJavaPlugin();">

<OBJECT 
    classid = "clsid:8AD9C840-044E-11D1-B3E9-00805F499D93"
    codebase_disabledownloading = "http://www.altanet.cl/descargas/jinstall-1_4-windows-i586.cab#Version=1,3,0,0"
    WIDTH = "2" HEIGHT = "2" NAME = "appletPlugin" ID = "appletPlugin">
    <PARAM NAME = CODE VALUE = "DetectPluginApplet.class" >
    <PARAM NAME = CODEBASE VALUE = "." >
    <PARAM NAME = NAME VALUE = "appletNoPlugin" >
    <PARAM NAME = "type" VALUE = "application/x-java-applet;version=1.3">
    <PARAM NAME = "scriptable" VALUE = "true">
    <PARAM NAME = "mayscript" VALUE = "true">

    <COMMENT>
    <EMBED 
            type = "application/x-java-applet;version=1.3" \
            CODE = "DetectPluginApplet.class" \
            JAVA_CODEBASE = "." \
            NAME = "appletPlugin" \
            WIDTH = "2" \
            HEIGHT = "2" \
        scriptable = true \
        MAYSCRIPT = true \ 
        pluginspage_disabledownloading = "http://java.sun.com/products/plugin/index.html#download">
        <NOEMBED>
            
            </NOEMBED>
    </EMBED>
    </COMMENT>
</OBJECT>


<applet code="DetectPluginApplet.class" codebase="." name="appletNoPlugin" width="2" height="2"></applet>

<table>
	<tr>
		<td class="green">Default</td>
		<td class="green">Java Version</td>
		<td class="green">Installed</td>
		<td class="green">Security Settings</td>
	</tr>

	<tr>
		<th><img src="images/question.gif" name="msDefault"></th>
		<td>Microsoft VM</td>
		<th><img src="images/question.gif" name="msInstalled"></th>
		<th><img src="images/question.gif" name="msSecurity"></th>
	</tr>

	<tr>
		<th><img src="images/question.gif" name="pluginDefault"></th>
		<td>Sun Java Plug-in</td>
		<th><img src="images/question.gif" name="pluginInstalled"></th>
		<th><img src="images/question.gif" name="pluginSecurity"></th>
	</tr>

	<tr>
		<th><img src="images/question.gif" name="webstartDefault"></th>
		<td>Java Web Start</td>
		<th><img src="images/question.gif" name="webstartInstalled"></th>
		<th><img src="images/question.gif" name="webstartSecurity"></th>
	</tr>
</table> 

<script language="javascript">
	function Respuesta()
	{
		var Mensaje = ""		
		var i = 0
		if ( document.all("msInstalled").src.indexOf('yes.gif') > 0 )
		{
			Mensaje = "Máquina Virtual de Java está instalada."
			i ++
		}
		else  
		{
			Mensaje = "Máquina Virtual de Java no está instalada."
		}

		if ( document.all("pluginInstalled").src.indexOf('yes.gif') > 0 )
		{
			Mensaje = "Java está instalado."
			i ++
		}
		else
		{
			Mensaje = "Java no está instalado."
		}

		if ( i == 0 )
		{
			//Que muestre el link de descarga.			
			document.write("<table border=0 width=100% cellspacing=5 cellpadding=0>");
			document.write("<tr>");
			document.write("<td>Se ha detectado que usted no tiene instalado:</td>");
			document.write("</tr>");
			document.write("<tr>");
			document.write("<td>1.- La máquina virtual de JAVA</td>");
			document.write("</tr>");
			document.write("<tr>");
			document.write("<td>2.- JAVA</td>");
			document.write("</tr>");
			document.write("<tr>");
			document.write("<td>A continuación se presenta un link, que le permitirá descargar JAVA.</td>");
			document.write("</tr>");
			document.write("<tr>");
			document.write("<td><a href='http://www.altanet.cl/descargas/j2re-1_4_2_08-windows-i586-p.exe'>Descargar Java</a></td>");
			document.write("</tr>");
			document.write("<tr>");
			document.write("<td>1.- Presionar Guardar y seleccione una carpeta en su computador. Comenzará a descargar (tomará unos minutos dependiendo de su conexión).</td>");
			document.write("</tr>");
			document.write("<tr>");
			document.write("<td>2.- Una vez finalizado ejecútelo; vaya donde lo descargó y presione doble click sobre el archivo.</td>");
			document.write("</tr>");
			document.write("<tr>");
			document.write("<td>3.- Siga los pasos propios de la instalación de JAVA.</td>");
			document.write("</tr>");
			document.write("<tr>");
			document.write("<td>4.- Una vez finalizada la instalación de JAVA estará en condiciones de ingresar al sistema.</td>");
			document.write("</tr>");
			document.write("</table>");
		}
		else
		{
			//Que pase a la página directo.
			parent.top.location.href = "../Autentificacion.asp";
		}
	}
	
	setTimeout("Respuesta()",2000); 
	
</script>

</body>
</html>
