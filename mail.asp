<% 
set msg = Server.CreateObject("CDO.Message")
msg.From = "fbarrientos@sanchezysanchez.cl"
msg.To = "fbarrientos@sanchezysanchez.cl"
msg.Subject = "prueba3"
msg.TextBody = "prueba2"
v_html = "<center><b><a href='www.rexsys.cl'><font color='#000099'>rexsys</font></a></b></center>"
msg.HTMLBody = v_html

msg.Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail.sanchezysanchez.cl"
msg.Configuration.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 1

msg.Configuration.Fields.Update

msg.Send
set msg = nothing
%>