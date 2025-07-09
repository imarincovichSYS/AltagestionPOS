<!-- #include file = "grid_col.asp" -->
<%
delimiter         = "~"
delimiter_select  = "¬"
'The Grid
class agrid
	public cols(), recordset, strHTML_options, Cell_borderColor, Table_borderColor, Width, Height, TH_BackgroundColor, TH_Color, TH_Height, Title, delimiter, delimiter_select, scroll_Div_Totales
	private cantCols
		
	private sub class_initialize()			
		cantCols            = 0
		Cell_borderColor    = "#CCCCCC"
		Table_borderColor   = ""
		TH_BackgroundColor  = "#227982"
		TH_Color            = "#FFFFFF"
		TH_Height           = "30"
		Height              = 100
		Width               = 200
		Title               = ""
		delimiter           = "~"
		delimiter_select    = "¬"
		scroll_Div_Totales  = "0"
	end sub
		
	private sub class_terminate()
	end sub
	
   public function getHeaderHeight()
	   If TH_Height > 99 Then TH_Height = 99
	   getHeaderHeight = TH_Height
	end function
		
	public sub add_col(columna)			
		redim preserve cols(cantCols + 1)
		set cols(cantCols) = columna
		cols(cantCols).index = cantCols
		cantCols = cantCols + 1
	end sub	
			
	public function get_drawGrid()
	  tot_rows = recordset.RecordCount
	  
    ' BEGIN: ESCRIBE HEADER
    strHTML = "<script language='javascript'>" & vbCrlf
    h_values    = ""
    g_propietes = ""
    s_op_values = ""
    s_op_texts  = ""
		for i=0 to ubound(cols)-1		   
		  h_values    = h_values & delimiter & cols(i).caption
		  if cols(i).getTypeCode()=3 then 'Tipo Select
		    cols(i).ExecuteSQL()
			  s_op_values = s_op_values & delimiter & cols(i).str_op_values
			  s_op_texts  = s_op_texts  & delimiter & cols(i).str_op_texts
			else
			  s_op_values = s_op_values & delimiter & "NO_OPTIONS"
			  s_op_texts  = s_op_texts  & delimiter & "NO_OPTIONS"
		  end if
		     
	    g_propietes = g_propietes & delimiter & _
	                   cols(i).getTypeCode() & _               
	                   cols(i).getWidth() & _
	                   cols(i).getTextAlignCode() & _
	                   Abs(cols(i).readonly)  & _
	                   Abs(cols(i).editable)  & _
	                   cols(i).getMaxLength() & _
	                   cols(i).getCType() & _
	                   cols(i).getCScale() & _
	                   cols(i).getCName() & _
	                   cols(i).getNull() & _
	                   cols(i).getdisplayCalendar() & _
	                   cols(i).getuseSaveChanges() & _
	                   cols(i).getSeparadorMiles() & _
	                   cols(i).getOptionEmpty() & _
	                   cols(i).getColSaltoLinea() & _
	                   cols(i).getMovHorizontal() & _
	                   cols(i).getColorText() & _
	                   Nvl(Replace(cols(i).expresionRegular, "\", "\\\\"), " ")
		next
		h_values    = Mid(h_values, 2)
		g_propietes = Mid(g_propietes, 2)
		s_op_values = Mid(s_op_values, 2)
		s_op_texts  = Mid(s_op_texts, 2)

    strHTML = strHTML & "setTotRows(" & tot_rows & ");" & vbCrlf
		strHTML = strHTML & "setTHHeight(" & TH_Height_tmp & ");" & vbCrlf
		strHTML = strHTML & "setWidth(" & width & ");" & vbCrlf
		strHTML = strHTML & "setHeight(" & height & ");" & vbCrlf
		strHTML = strHTML & "setScroll_Div_Totales(" & scroll_Div_Totales & ");" & vbCrlf
		strHTML = strHTML & "writeHeader(""" & Replace(h_values, vbCr, "\n") & """, """ & g_propietes & """, """ & s_op_values & """, """ & s_op_texts & """);" & vbCrlf
		' END: ESCRIBE HEADER
		
			
		'BEGIN: ESCRIBE BODY
		if isobject(recordset) then
			do while not recordset.eof
			   r_values = ""
				for i=0 to ubound(cols)-1
				  if not IsNull(recordset(i).value) then
				    if cols(i).getSeparadorMiles() then
				      r_values    = r_values  & delimiter & FormatNumber(Replace(Trim(recordset(i).value),"'","\'"),cint(cols(i).getColumn_scale()))
				    else
				      'if cint(cols(i).getColumn_scale()) > 0 then
				      '  v_valor = Replace(FormatNumber(cdbl(recordset(i).value),cint(cols(i).getColumn_scale())),",","")
				      '  r_values    = r_values  & delimiter & v_valor
				      'else
				      '  r_values    = r_values  & delimiter & Replace(Trim(recordset(i).value),"'","\'")
				      'end if
				      r_values    = r_values  & delimiter & Replace(Trim(recordset(i).value),"'","\'")
				    end if
				  else
				    r_values    = r_values  & delimiter & Trim(recordset(i).value)
				  end if
				next
				r_values = Mid(r_values, 2)
				strHTML = strHTML & "writeRow('" & r_values & "');" & vbCrlf
				recordset.movenext
			loop
		end if
		'END: ESCRIBE BODY
		
		'BEGIN: ESCRIBE FOOTER
   		strHTML = strHTML & "writeFooter();" & vbCrlf
		'END: ESCRIBE FOOTER
		
		strHTML = strHTML & "writeInnerHTML();" & vbCrlf
	   strHTML = strHTML &  "</script>" & vbCrlf
      
      
		'if len(strHTML_options) > 0 then
		'	strHTML = strHTML &  vbtab & vbtab & "<td colspan=" &ubound(cols)& ">" & strHTML_options & "</td>"
		'	strHTML = strHTML &  vbtab & "</tr>" &vbcrlf
		'end if
		'strHTML = strHTML &  "</table></div>"
		'strHTML = strHTML &  "</form>"
		'strHTML = strHTML & vbcrlf & "</div>" & vbcrlf
		get_drawGrid = strHTML
	end function	
	
end class
%>
<script language="javascript">
var delimiter = "<%=delimiter%>", delimiter_select = "<%=delimiter_select%>"
</script>