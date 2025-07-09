<!--#include file="./md5.asp" -->
<%
function fnGetUUID(largo)
	Dim intCounter,intDecimal,cGenRand
	
	For intCounter = 1 To largo
	    Randomize
	    intDecimal =  Int((26 * Rnd) + 1) + 64
	    fnGetUUID = fnGetUUID & Chr(intDecimal)
	Next
end function

KeySign = fnGetUUID(32)
sUUID = year(Now()) & "-" & right("00" & Month(Now()),2) & "-" & right("00" & Day(Now()),2) & "-" & uCase(KeySign)

Token_session_usuario = md5(sUUID)

if request("t") = 1 then
	sUUID = year(Now()) & "-" & right("00" & Month(Now()),2) & "-" & right("00" & Day(Now()),2) & "-" & uCase(request("KeySign"))
	response.write(uCase(md5(sUUID)))
	response.end()
end if


%>