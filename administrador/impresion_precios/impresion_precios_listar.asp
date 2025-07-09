<%@ Language=VBScript %>
<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
server.ScriptTimeout = 10000
tipo_precio = Request.Form("tipo_precio")
codigo = Request.Form("codigo")

strSQL="select * from "
descripcion = "CALCETIN DAMA MEDIA PANTALON 816 J.5"
precio = "480"
if tipo_precio = "15X21" then
%>
<br><br>
<center>
<label id="label_15X21_precio"><%=precio%></label>
<br><br><br><br>
<label id="label_15X21_descripcion"><%=descripcion%></label>
<br><br>
<label id="label_15X21_codigo"><b><%=codigo%></b></label>
</center>
<%elseif tipo_precio = "" then%>

<%end if%>