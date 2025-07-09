<!-- #include file="Scripts/Inc/Cache.Inc" -->
<%
	Cache
	NomFuncion = Request("NomFun")
	Response.Redirect "Paso.asp?Hora=" & Now() & "&NomFun=" & NomFuncion
%>