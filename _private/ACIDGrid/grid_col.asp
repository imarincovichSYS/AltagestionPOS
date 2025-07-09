<%
class agrid_col	
	public kind, width, align, caption, recordset, editable, readonly
	public expresionRegular, index, class_css, style_css, maxlength, tipo, column_name
	public column_length, column_scale, nullable, displayCalendar, useSaveChanges, colorText
	public separadorMiles, optionEmpty, colSaltoLinea, movHorizontal, sqlselect, str_op_values, str_op_texts
		
	public sub class_initialize
		kind            = "text"
		width           = 10
		align           = "center"
		set recordset   = nothing
		caption         = "caption"
		editable        = true
		readonly        = false
		regExp          = ".*"
		index           = 0
		class_css       = ""
		style_css       = ""
		maxlength       = 10
		tipo            = "number"
		column_name     = ""
		column_scale    = 0
		nullable        = false
		displayCalendar = false
		useSaveChanges  = false
		separadorMiles  = false
		optionEmpty     = false
		colSaltoLinea   = 0
		movHorizontal   = true
		colorText       = "000000"
		sqlselect       = ""
		str_op_values   = ""
		str_op_texts    = ""
	end sub
	
	public function ExecuteSQL()
	  set rs_executeSQL = Conn.Execute(sqlselect)
	  str_op_values = "" : str_op_texts = ""
	  do while not rs_executeSQL.EOF
	    str_op_values = str_op_values & delimiter_select & trim(rs_executeSQL(0))
	    str_op_texts  = str_op_texts  & delimiter_select & trim(rs_executeSQL(1))
	    rs_executeSQL.MoveNext
	  loop
	  str_op_values = Mid(str_op_values, 2)
	  str_op_texts  = Mid(str_op_texts, 2)
	end function
	
	public function get_str_op_values()
	  get_str_op_values = str_op_values
	end function
	
	public function get_str_op_texts()
	  get_str_op_texts = str_op_texts
	end function
	
	public function getNull()
	   getNull = Abs(nullable)
	end function
	
	public function getMovHorizontal()
	   getmovHorizontal = Abs(movHorizontal)
	end function
	
	public function getdisplayCalendar()
	   getdisplayCalendar = Abs(displayCalendar)
	end function
	
	public function getuseSaveChanges()
	   getuseSaveChanges = Abs(useSaveChanges)
	end function
	
	public function getSeparadorMiles()
	   getSeparadorMiles = Abs(separadorMiles)
	end function
	
	public function getOptionEmpty()
	   getOptionEmpty = Abs(optionEmpty)
	end function
	
	public function getColSaltoLinea()
	   getColSaltoLinea = colSaltoLinea
	end function
	
	public function getColorText()
	   getColorText = colorText
	end function
	
	public function getColumn_scale()
	  'Se utiliza para formatear un numero en grid.asp, línea: 100
	   getColumn_scale = column_scale
	end function
	
	public function getTypeCode()
	   select case lcase(kind)
	      case "text":      getTypeCode = 0 
	      case "submmit":   getTypeCode = 1
	      case "hidden":    getTypeCode = 2
	      case "select":    getTypeCode = 3
	      case "checkbox":  getTypeCode = 4
	      case "file":      getTypeCode = 5
	      case "button":    getTypeCode = 6
	   end select
	end function
	
	public function getWidth()
	   getWidth = LPad(width, 3, 0)
	end function
	
	public function getTextAlignCode()
	   select case lcase(align)
	      case "left":    getTextAlignCode = 0
        case "center":  getTextAlignCode = 1
	      case "right":   getTextAlignCode = 2
	   end select
	end function
	
   public function getMaxLength()
      getMaxLength = LPad(maxlength, 3, 0)
   end function
	
	public function getCScale()
	   getCScale = LPad(column_scale, 2, 0)
	end function
	
	public function getCName()
	   getCName = LPad(column_name, 50, " ")
	end function
	
	public function getCType()
	   getCType = 0
	   select case lcase(tipo)
	      case "number": getCType = 0
        case "char":   getCType = 1
	      case "date":   getCType = 2
	      case "hora":   getCType = 3
	   end select
	end function
end class
%>