<!--#include file="../../_private/config.asp" -->
<!--#include file="../../_private/funciones_generales.asp" -->
<%
'*********** Especifica la codificaci�n y evita usar cach� **********
Response.AddHeader "Content-Type", "text/html; charset=iso-8859-1"
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"

documento_respaldo  = Request.Form("documento_respaldo")
anio                = Request.Form("anio")
mes                 = Request.Form("mes")
num_carpeta         = Request.Form("num_carpeta")
'numero_linea        = Request.Form("numero_linea")
NumeroAduana        = Request.Form("Numero_aduana")
carpeta             = "'"& documento_respaldo & "-"& anio &"-"& mes &"-"& num_carpeta &"'"

OpenConn
if documento_respaldo = "Z" then
    strSQL=""
end if


h_tr = 25
color= "#555555"
bgcolor_tabla = "#CCCCCC"
%>


<table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 bgcolor="<%=bgcolor_tabla%>" style='border: 1px solid #AAAAAA; table-layout: fixed;'>
    <tr valign='top'>
        <td colspan='2' align='center' bgcolor='#FFFFFF'><b>Ingreso / Modificacion de Buque</b>&nbsp;</td>
    </tr>
</table>

<table id="tabla_movimiento_buque">
  <thead>
    <th> </th>
    <th>Lugar</th>
    <th>F.Llegada</th>
    <th>F.Salida</th>
    <th>B.Base</th>
    <th>Viaje</th>

    <th>Lugar</th>
    <th>F.Llegada</th>
    <th>F.Salida</th>
    <th>B.Base</th>
    <th>Viaje</th>
  </thead>
  <tbody>
   <%		  strSQL="exec sp_c_Carpetas_Embarcador " & carpeta 
          set rs = Conn.Execute(strSQL)
          Dim fldF, intRec 
          i=0
		For intRec=1 To rs.PageSize
			If Not rs.EOF Then%>

                <td style="font-size:9;" align="right">
                    <label id="lbl_actualizar_movimiento<%=i%>" name="lbl_actualizar_movimiento<%=i%>" class="bot_success btn_update_buque">
                        <img src="<%=RutaProyecto%>imagenes/Ico_Glyph_White_Edit_14X14.png" width=10 height=10 border=0 align="top">
                    </label>
                </td>


				<td>&nbsp;
                  <a class="FuenteDetalleLink">  
                    <input value="<%=rs("Lugar")%>" id="Lugar<%=i%>"  name="Lugar" style="font-size:9; width:80px;background-color:#fffef6;">    
                  </a>
                </td>

                <td>&nbsp;
                  <a class="FuenteDetalleLink">  
                    <input value="<%=rs("Fecha_llegada")%>" id="Fecha_llegada<%=i%>" name="Fecha_llegada" style="font-size:9; width:50px;background-color:#fffef6;">    
                  </a>
                </td>

                <td>&nbsp;
                  <a class="FuenteDetalleLink">  
                    <input value="<%=rs("Fecha_Salida")%>" id="Fecha_Salida<%=i%>" name="Fecha_Salida" style="font-size:9; width:50px;background-color:#fffef6;">    
                  </a>
                </td>

                <td>&nbsp;
                  <a class="FuenteDetalleLink">  
                    <input value="<%=rs("Buque_Base")%>" id="Buque_Base<%=i%>" name="Buque_Base" style="font-size:9; width:50px;background-color:#fffef6;">    
                  </a>
                </td>                


                <td>&nbsp;
                  <a class="FuenteDetalleLink">  
                    <input value="<%=rs("Viaje")%>" id="Viaje<%=i%>" name="Viaje" style="font-size:9; width:50px;background-color:#fffef6;">    
                  </a>
                </td>                

                <td>&nbsp;
                  <a class="FuenteDetalleLink">  
                    <input value="<%=rs("Bit_Lugar")%>" id="Bit_Lugar<%=i%>" name="Bit_Lugar" style="font-size:9; width:80px;background-color:#f0f0f0;" readonly>    
                  </a>
                </td>                

                <td>&nbsp;
                  <a class="FuenteDetalleLink">  
                    <input value="<%=rs("Bit_Fecha_llegada")%>" id="Bit_Fecha_llegada<%=i%>" name="Bit_Fecha_llegada" style="font-size:9; width:50px;background-color:#f0f0f0;" readonly>    
                  </a>
                </td>                

                <td>&nbsp;
                  <a class="FuenteDetalleLink">  
                    <input value="<%=rs("Bit_Fecha_Salida")%>" id="Bit_Fecha_Salida<%=i%>" name="Bit_Fecha_Salida" style="font-size:9; width:50px;background-color:#f0f0f0;" readonly>    
                  </a>
                </td>                

                <td>&nbsp;
                  <a class="FuenteDetalleLink">  
                    <input value="<%=rs("Bit_Buque_Base")%>" id="Bit_Buque_Base<%=i%>" name="Bit_Buque_Base" style="font-size:9; width:50px;background-color:#f0f0f0;" readonly>    
                  </a>
                </td>                                                                                

                <td>&nbsp;
                  <a class="FuenteDetalleLink">  
                    <input value="<%=rs("Bit_Viaje")%>" id="Bit_Viaje<%=i%>" name="Bit_Viaje" style="font-size:9; width:50px;background-color:#f0f0f0;" readonly>    
                  </a>
                </td>                                                                                


	</tr>
		<%	rs.MoveNext
		  End If
		  i=i+1
	Next%>
  </tbody>
</table>

<table align="center" width="100%" cellpadding=0 cellspacing=0 border=0 bgcolor="<%=bgcolor_tabla%>" style='border: 1px solid #AAAAAA; table-layout: fixed;'>
 
 
    <tr valign='top'>
        <td colspan='2' align='center' bgcolor='#FFFFFF'>
            <table align="center" width="100%" cellpadding=0 cellspacing=0 border=0>
                <tr>
                    <tr><td colspan='2' align='center' bgcolor='#FFFFFF'><b> </b>&nbsp;</td><tr>
                <td>&nbsp;</td>
        
                <td style="width:10px;">&nbsp;</td>
                <td style="width:70px;">
                    <label id="label_cancelar" name="label_cancelar" class="bot_inverse">
                    <img src="<%=RutaProyecto%>imagenes/Ico_Glyph_White_Cancel_15X16.png" width=15 height=16 border=0 align="top">&nbsp;&nbsp;Cancelar&nbsp;</label>
                </td>
                <td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
