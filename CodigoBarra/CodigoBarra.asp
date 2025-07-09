<%
    Url = Request("Url")
%>
<HTML>
<BODY Onload="Javascript:fUrl()">
    <OBJECT ID="CodigoBarra" CLASSID="CLSID:B6E4F684-09FE-4356-930D-B1238ABF121D" CODEBASE="CodigoBarra.CAB#version=1,0,0,0">
    </OBJECT>
</BODY>

    <script language="Javascript">
        function fUrl()
        {
            location.href = "<%=Url%>"
        }
    </script>
</HTML>
