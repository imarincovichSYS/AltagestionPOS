//********************************************************************
// function setWidth(v_width)
// function setHeight(v_height)
// function setTHHeight(v_height)
// function makeOptions(op_values, op_texts)
// function writeHeader(h_values, g_properties)
// function writeFooter()
// function writeRow(r_values)
// function writeInnerHTML(v_num_grid)
// function Focus(obj)
// function KeyDown(obj, ev, p_row, p_col)
// function Validator(evt, src, re)
// function selText(input)
//***********************************************************************
var ARRIBA = 38; ABAJO = 40 ; DERECHA = 39 ; IZQUIERDA = 37 ; ENTER = 13
//***********************************************************************

var str_rows    = "";
var str_cols;
var v_types     = Array('text', 'submit', 'hidden', 'select','checkbox','file','button');
var v_aligns    = Array('left', 'center', 'right');
var v_readonly  = Array('', 'readonly');
var v_editable  = Array('disabled', '');
var v_ctypes    = Array('number', 'char', 'date');
var v_op_values;
var v_op_texts;
var str_op_values;
var str_op_texts;
var g_width     = 500;
var g_height    = 400;
var g_th_height = 30;
var r_index     = 1;
var g_property;
var t_rows;
var scroll_Div_Totales;
var g_num_grid = 1;
var g_tipo_scroll = 1;
var g_marcarFilaClickCheckbox = 0;
var g_cantCols = 1;

function setScroll_Div_Totales(v_sdt) {
   scroll_Div_Totales = v_sdt;
}

function setTotRows(v_rows) {
   t_rows = v_rows;
}
  
function setWidth(v_width) {
   g_width = v_width;
}
   
function setHeight(v_height) {  
   g_height = v_height;
}
   
function setTHHeight(v_height){
   g_th_height = v_height;
}

function setNumGrid(v_num_grid){
   g_num_grid = v_num_grid;
}

function setTipoScroll(v_tipo_scroll){
   g_tipo_scroll = v_tipo_scroll;
}

function setMarcarFilaClickCheckbox(v_marcarFilaClickCheckbox){
   g_marcarFilaClickCheckbox = v_marcarFilaClickCheckbox;
}
   
/*function makeOptions(op_values, op_texts)
{
   v_op_texts  = op_texts.split(delimiter);
   v_op_values = op_values.split(delimiter);
}*/
       
function writeHeader(h_values, g_properties, s_op_values, s_op_texts)
{
   h_value        = h_values.split(delimiter);
   g_property     = g_properties.split(delimiter); 
   str_op_values  = s_op_values.split(delimiter);
   str_op_texts   = s_op_texts.split(delimiter);
   h_height       = g_th_height;
   str_header     = "";
   
   strTiene_Filas = ""
   if(parseInt(t_rows)>0)
     strTiene_Filas = "1"
   for(i=0;i<h_value.length;i++)  
   {
      h_name    = "celda_th_" + g_num_grid + "_" + (i + 1);
      h_width   = g_property[i].substr(1,3).toInt();        /*PROPIEDAD: WIDTH*/
      r_type    = g_property[i].substr(0,1); 
      r_colorCell_BorderRight = g_property[i].substr(88,6); /*PROPIEDAD: COLOR HEXADECIMAL BORDER RIGHT DE LA CELDA */
       
      str_header += " <td class='grid_TH' width='" + (h_width) +  "px' style='border-right: 1px solid #"+r_colorCell_BorderRight+";'>";
      str_header += " <textarea readonly id='grid_TEXT_TH'";  /*    ID     */
      str_header += " style=\"";                         /*BEGIN STYLE*/
      //if(navegador != "IE" && r_type == 4)
      //  h_width = parseInt(h_width) + 7 //Sólo para Firefox
      str_header += " width:" + (h_width) + "px;";       /*   WIDTH   */
      str_header += " height:" + (h_height) + "px;";     /*   HEIGHT   */
      str_header += " \"";                               /*  ND STYLE */
      str_header += ">" + h_value[i] + "</textarea></td>";
   }
   str_header = "<table border=0 cellpadding=0 cellspacing=0 style='width:" + (g_width - 17) + "px; height:" + h_height + "px' >\n<tr>" + str_header + "</tr>\n</table></td></tr><tr><td>\n";
   str_header = "<div name='grillaEnc' id='grillaEnc' style='width:" + (g_width - 17) + "px;'>\n" + str_header + "</div>";
   str_header += "<input type='hidden' id='hidden_tiene_filas_"+g_num_grid+"' name='hidden_tiene_filas_"+g_num_grid+"' value='"+strTiene_Filas+"'>\n"
   
   if(scroll_Div_Totales=="1")
   {
      str_header  = "<div id='grilla' style='width:" + g_width + "; z-index:0; border: 1px solid #999999;'>\n" + str_header;
      str_header += "<div name='grillaDatos' id='grillaDatos' onscroll='$(\"grillaEnc\").scrollLeft=this.scrollLeft;grillaTotales.scrollLeft=this.scrollLeft' "
      str_header += "style='"
      if(g_tipo_scroll=="1")
        str_header += "overflow: scroll;"
      else if(g_tipo_scroll=="2")
        str_header += "overflow-y: scroll;"
      else if(g_tipo_scroll=="3")
        str_header += "overflow-x: scroll;"
      else if(g_tipo_scroll=="4")
        str_header += "overflow: auto;"
      str_header += " width:" + (g_width) + "; height:" + g_height + ";'>\n";     
      str_header += "<table border=0 cellpadding=0 cellspacing=0 style='boder-left:1px; width: " + (g_width-17) + "px;'>\n";
   }
   else
   {
      str_header  = "<div id='grilla' style='width:" + g_width + "; z-index:0; border: 1px solid #999999;'>\n" + str_header;
      str_header += "<div name='grillaDatos' id='grillaDatos' onscroll='$(\"grillaEnc\").scrollLeft=this.scrollLeft;' ";
      str_header += "style='"
      if(g_tipo_scroll=="1")
        str_header += "overflow: scroll;"
      else if(g_tipo_scroll=="2")
        str_header += "overflow-y: scroll;"
      else if(g_tipo_scroll=="3")
        str_header += "overflow-x: scroll;"
      else if(g_tipo_scroll=="4")
        str_header += "overflow: auto;"
      str_header += " width:" + (g_width) + "; height:" + g_height + ";'>\n";     
      str_header += "<table border=0 cellpadding=0 cellspacing=0 style='boder-left:1px; width: " + (g_width-17) + "px;'>\n";
   }
}
   
function writeFooter()
{
   str_footer  = "</table>\n"; 
   str_footer += "</div>\n";      /*CIERRA DIV GRILLADATOS*/
   str_footer += "</div>\n";      /*CIERRA DIV GRILLA*/
}
   
function writeRow(r_values)
{
   r_value     = r_values.split(delimiter);     
   var r_type, r_width, r_re;
   str_cols = "";
   for(i=0;i<r_value.length;i++)
   {
      r_name            = "celda_" + g_num_grid + "_" + r_index  + "_" + (i + 1);
      r_type            = g_property[i].substr(0,1);                        /*PROPIEDAD: TYPE  = 0,1,2,3,4*/
      r_width           = g_property[i].substr(1,3).toInt();                /*PROPIEDAD: WIDTH = XXX*/
      r_align           = g_property[i].substr(4,1).toInt();                /*PROPIEDAD: ALIGN = 1, 2, 3*/  
      r_readonly        = g_property[i].substr(5,1).toInt();                /*PROPIEDAD: READONLY = 0, 1*/ 
      r_editable        = g_property[i].substr(6,1).toInt();                /*PROPIEDAD: EDITABLE = 0, 1*/
      r_maxlength       = g_property[i].substr(7,3).toInt();                /*PROPIEDAD: MAXLENGTH = XXX*/
      r_ctype           = g_property[i].substr(10,1).toInt();               /*PROPIEDAD: CTYPE  = 0, 1, 2*/
      r_cscale          = g_property[i].substr(11,2).toInt();               /*PROPIEDAD: CSCALE = XX*/
      r_cname           = g_property[i].substr(13,50).replace(/^\s+/,"");   /*PROPIEDAD: CNAME  = \c{50}*/
      r_null            = g_property[i].substr(63,1).toInt();               /*PROPIEDAD: NULL*/ 
      r_displayCal      = g_property[i].substr(64,1).toInt();               /*PROPIEDAD: DISPLAY CALENDAR*/ 
      r_useSaveChanges  = g_property[i].substr(65,1);                       /*PROPIEDAD: USE SAVEVALUES*/
      r_separadorMiles  = g_property[i].substr(66,1);                       /*PROPIEDAD: FORMATEAR CON SEPARADOR DE MILES = 0, 1*/  
      r_option_empty    = g_property[i].substr(67,1);                       /*PROPIEDAD: AGREGAR UN "OPTION" VACIO EN UN SELECT = 0, 1*/  
      r_col_salto_linea = g_property[i].substr(68,1);                       /*PROPIEDAD: INDICA SI EL ONBLUR DE LA CELDA DEBE HACER UN SALTO DE LINEA A LA COLUMNA=r_col_salto_linea (igual a 0 funciona normalmente)*/
      r_mov_horizontal  = g_property[i].substr(69,1);                       /*PROPIEDAD: INDICA SI SE DEBE ESTABLECER EN LA COLUMNA DE IZQUIERDA O DERECHA SEGÚN SE PRODUZCA EL EVENTO*/    
      r_colorText       = g_property[i].substr(70,6);                       /*PROPIEDAD: COLOR HEXADECIMAL DEL TEXTO DE LA CELDA */
      
      r_colorCell_Background    = g_property[i].substr(76,6);                       /*PROPIEDAD: COLOR HEXADECIMAL BACKGROUND DE LA CELDA */
      r_colorCell_BorderLeft    = g_property[i].substr(82,6);                       /*PROPIEDAD: COLOR HEXADECIMAL BORDER LEFT DE LA CELDA */
      r_colorCell_BorderRight   = g_property[i].substr(88,6);                       /*PROPIEDAD: COLOR HEXADECIMAL BORDER RIGHT DE LA CELDA */
      r_colorCell_BorderTop     = g_property[i].substr(94,6);                       /*PROPIEDAD: COLOR HEXADECIMAL BORDER TOP DE LA CELDA */
      r_colorCell_BorderBottom  = g_property[i].substr(100,6);                      /*PROPIEDAD: COLOR HEXADECIMAL BORDER BOTTOM DE LA CELDA */
      r_re                      = g_property[i].substr(106);                        /*PROPIEDAD: EXPRESION REGULAR (Este siempre se debe dejar al final porque es variable*/ 
      
      //if(i==0)
      //alert("r_colorCell_BorderRight: "+r_colorCell_BorderRight)
               
      if(r_type < 3) /*TYPE TEXT, SUBMIT, HIDDEN*/
      {
         str_input  = " <input ";
         str_input += " class='grid_TEXT' id='"  + r_name + "'"; /*ID*/
         str_input += " name='"  + r_name + "'";                /*NAME*/            
         str_input += " type=\""  + v_types[r_type] +  "\"";    /*TYPE*/
         if(r_ctype == 2)
         {
           str_input += " value=\"" + Replace(r_value[i],"/","-") + "\"";          /*VALUE DATE, Formato dd-mm-yyyy*/
           if(r_displayCal == 1)
            str_input += " onclick=\"displayCalendarEjectFunction(this,'dd-mm-yyyy',this,true);\"";  /*DISPLAY CALENDAR*/
         }
         else
           str_input += " value=\"" + r_value[i] + "\"";          /*VALUE*/
         str_input += " onkeydown=\"KeyDown(this, event," +  r_index + ", " + (i + 1) + ", " +r_mov_horizontal + ", " + g_num_grid + ");\"";  /*KEYDOWN*/
         //alert("r_name: "+r_name+", r_separadorMiles: "+r_separadorMiles+", r_readonly: "+r_readonly)
         if (r_separadorMiles == 1)
           str_input += " onfocus=\"if(!this.readOnly){LimpiarSeparadorMiles(this);Focus(this);}\"";                                               /*FOCUS*/
         else
           str_input += " onfocus=\"Focus(this);\"";                                               /*FOCUS*/
         //str_input += " onmouseup=\"return false;\"";                                              /*MOUSEUP*/
         str_input += " onkeyup=\"return false;\"";                                                /*KEYUP*/
         str_input += " onblur=\"SaveChanges(this," + r_index + ", " + (i + 1) + ", " + r_ctype + ", '" + r_cname  + "'," + r_cscale + "," + r_maxlength + ", " + r_null + ", '" + nom_tabla + "');\"";          /*BLUR*/
         str_input += " onkeypress=\"return Validator(event, this, '" + r_re.replace(/^\s+/, "") + "');\"";                                           /*KEYPRESS*/
         str_input += " style=\"";                                       /*BEGIN STYLE*/
         str_input += " width:" + r_width.toInt() + "px;";                /*WIDTH*/
         str_input += " text-align:" + v_aligns[r_align.toInt()] + ";";  /*ALIGN*/
         if(r_readonly==1)str_input +=" background-color:#EEEEEE;";      /*BACKGROUND-COLOR*/
         str_input += " color:#" + r_colorText + ";";                    /*COLOR TEXT*/
         str_input += "\"";                                              /*END STYLE*/
         str_input += " " + v_readonly[r_readonly];                      /*READONLY*/
         str_input += " " + v_editable[r_editable];                      /*DISABLED*/
         if(r_maxlength>0) str_input += " maxlength=" + r_maxlength      /*MAXLENGTH*/
         
         //si tiene esta propiedad: cada vez que se sale de esta celda (onblur) se va a la columna indicada en este atributo
         //(igual a 0 funciona normalmente:funcion KeyDown())
         str_input +=" col_salto_linea=" + r_col_salto_linea + " ";        /*SALTO DE LINEA a la celda columna=salto_linea*/
         str_input += "></input>";
      }
      else if (r_type == 3) /*TYPE SELECT*/
      {
         str_input  = " <select o_value='"+r_value[i]+"' "; 
         str_input += " class='grid_SELECT' id='"  + r_name + "'";                                                       /*ID*/
         str_input += " name='" + r_name + "'";                                                  /*NAME*/
         if(r_readonly==1)
          str_input += " disabled ";                                                             /*READONLY -- DISABLED*/
         str_input += " style=\"";                                                               /*BEGIN STYLE*/
         str_input += " width:" + r_width.toInt() + "px;";                                       /*WIDTH*/
         str_input += "\"";                                                                      /*END STYLE*/
         str_input += " onkeydown=\"return Mover_Focus_Valido_Select(event," +  r_index + ", " + (i + 1) + ", " +r_mov_horizontal + ", " + g_num_grid + ");\"";
         str_input += " onchange=\"SaveChanges(this," + r_index + ", " + (i + 1) + ", " + r_ctype + ", '" + r_cname  + "'," + r_cscale + "," + r_maxlength + ", " + r_null + ", '" + nom_tabla + "');\""; /*CHANGE*/
         
         //si tiene esta propiedad: cada vez que se sale de esta celda (onblur) se va a la columna indicada en este atributo
         //(igual a 0 funciona normalmente:funcion KeyDown())
         str_input +=" col_salto_linea=" + r_col_salto_linea + " ";        /*SALTO DE LINEA a la celda columna=salto_linea*/
         
         str_input += ">\n";
         v_op_values  = str_op_values[i].split(delimiter_select)
         v_op_texts   = str_op_texts[i].split(delimiter_select)
         if(r_option_empty == 1)
           str_input += "\n<option value=''></option>";
         for(j=0;j<=v_op_values.length-1;j++)     /*OPTIONS*/
         {
            str_input += "\n<option "
            if(r_value[i]==v_op_values[j])str_input += " selected "
            str_input += " value='" + v_op_values[j] + "'>" + v_op_texts[j] + "</option>";
         }
         str_input += "\n</select>\n";
      }
      else if (r_type == 4) /*TYPE CHECKBOX*/
      {
        str_input  = " <input ";
        str_input += " class='grid_CHECKBOX' id='"  + r_name + "'";                    /*ID*/
        str_input += " name='"  + r_name + "'";                /*NAME*/            
        str_input += " type=\""  + v_types[r_type] +  "\"";    /*TYPE*/
        if(r_readonly==1)
          str_input += " disabled ";                           /*READONLY -- DISABLED*/
        str_input += " value=\"" + r_value[i] + "\"";          /*VALUE*/
        if(r_useSaveChanges==1)
        {
          str_input += " onclick=\"if(this.checked==true)this.value='1';else this.value='0';SaveChanges(this," + r_index + ", " + (i + 1) + ", " + r_ctype + ", '" + r_cname  + "'," + r_cscale + "," + r_maxlength + ", " + r_null + ", '" + nom_tabla + "');\""; /*CHANGE*/
          if(r_value[i]=="1") str_input += " checked";                 /*CHECKED CHECKBOX*/
        }
        else
        {
          if(g_marcarFilaClickCheckbox=="1")
            str_input += " onclick=\"if(this.checked==true)MarcarFila(" + g_num_grid + ", " + r_index + ");else DesMarcarFila(" + g_num_grid + ", " + r_index + ");\""; /*OnClick*/
        }
        str_input += " onkeydown=\"KeyDown(this, event," +  r_index + ", " + (i + 1) + ", " +r_mov_horizontal + ", " + g_num_grid + ");\"";  /*KEYDOWN*/
        str_input += " onfocus=\"Focus(this);\"";                                               /*FOCUS*/
        str_input += " style=\"";                                                               /*BEGIN STYLE*/
        str_input += " width:" + r_width.toInt() + "px;";                                        /*WIDTH*/
        str_input += "\"";                                                                      /*END STYLE*/
        //si tiene esta propiedad: cada vez que se sale de esta celda (onblur) se va a la columna indicada en este atributo
        //(igual a 0 funciona normalmente:funcion KeyDown())
        str_input +=" col_salto_linea=" + r_col_salto_linea + " ";        /*SALTO DE LINEA a la celda columna=salto_linea*/
        str_input += "></input>";
      }
      else if (r_type == 5) /*TYPE FILE*/
      {
        str_input  = " <input class='grid_boton' title='Agregar Archivo' ";
        str_input += " id='"  + r_name + "'";                     /*ID*/
        str_input += " name='"  + r_name + "'";             /*NAME*/            
        str_input += " type='button'";                      /*TYPE*/
        if(r_readonly==1)
          str_input += " disabled ";                           /*READONLY -- DISABLED*/
        str_input += " onkeydown=\"KeyDown(this, event," +  r_index + ", " + (i + 1) + ", " +r_mov_horizontal + ", " + g_num_grid + ");\"";  /*KEYDOWN*/
        str_input += " onkeypress='return false' onclick=\"Set_Load_File(this," + r_index + ", " + (i + 1) + ", '" + r_cname  + "');\"";
        if(r_value[i]=="")
          str_input += " value='Adjuntar'"                    /*VALUE*/
        else
          str_input += " value='Cambiar'"                    /*VALUE*/
        str_input += " style=\"";                           /*BEGIN STYLE*/
        str_input += " width:44px";                         /*WIDTH*/
        str_input += "\"";                                  /*END STYLE*/
        //si tiene esta propiedad: cada vez que se sale de esta celda (onblur) se va a la columna indicada en este atributo
        //(igual a 0 funciona normalmente:funcion KeyDown())
        str_input +=" col_salto_linea=" + r_col_salto_linea + " ";        /*SALTO DE LINEA a la celda columna=salto_linea*/
        str_input += "></input>";
      }
      else if (r_type == 6) /*TYPE BUTTON*/
      {
        str_input  = " <input class='grid_boton' title='Agregar Datos' ";
        str_input += " id='grid_FILE'";                     /*ID*/
        str_input += " name='"  + r_name + "'";             /*NAME*/            
        str_input += " type='button'";                      /*TYPE*/
        str_input += " onkeydown=\"KeyDown(this, event," +  r_index + ", " + (i + 1) + ", " +r_mov_horizontal + ", " + g_num_grid + ");\"";  /*KEYDOWN*/
        str_input += " onkeypress='return false' onclick=\"Set_Load_Datos(this," + r_index + ", " + (i + 1) + ");\"";
        str_input += " value='Datos'"                       /*VALUE*/
        str_input += " style=\"";                           /*BEGIN STYLE*/
        str_input += " width:" + r_width.toInt() + "px;";   /*WIDTH*/
        str_input += "\"";                                  /*END STYLE*/
        //si tiene esta propiedad: cada vez que se sale de esta celda (onblur) se va a la columna indicada en este atributo
        //(igual a 0 funciona normalmente:funcion KeyDown())
        str_input +=" col_salto_linea=" + r_col_salto_linea + " ";        /*SALTO DE LINEA a la celda columna=salto_linea*/
        str_input += "></input>";
      }
      str_cols  += "<td style='height:8px; border-right: solid 1px #" + r_colorCell_BorderRight + ";'; class='grid_TD' id='grid_TD_" + g_num_grid + "_" +  r_index + "_" + (i + 1) + "' name='grid_TD_" + g_num_grid + "_" +  r_index + "_" + (i + 1) + "' "
      if(r_readonly==1)
        str_cols += " bgcolor='#EEEEEE' "
      if (r_type == 5) /*TYPE FILE (Botones para visualizar y eliminar archivos) */
      {
        str_cols += " valign='middle' width=" + r_width.toInt();   /*WIDTH*/
        str_cols += " nowrap>" +str_input;
        str_cols += "&nbsp;"
        if(r_value[i]!="")
          str_cols += "<a target='_blank' href='"+RutaProyecto+"filesUpload/"+r_value[i]+"'>";
        str_cols += "<img id='IMG_FILE_12' src='"+RutaProyecto+"ACIDGrid3/file_adj_12.gif' align='middle' title='Ver Archivo'";
        if(r_value[i]=="")
          str_cols +=" style='visibility: hidden;'";
        str_cols += ">"
        if(r_value[i]!="")
          str_cols += "</a>";
        str_cols += "&nbsp;<img "
        if(r_readonly!=1)
          str_cols += " onclick=\"Delete_File(" + r_index + ", " + (i + 1) + ", '" + r_cname  + "','"+r_value[i]+"');\"' " 
        str_cols += " id='IMG_FILE_12' src='"+RutaProyecto+"ACIDGrid3/file_del_12.gif' align='middle' title='Eliminar Archivo'";
        if(r_value[i]=="" || r_readonly==1)
          str_cols +=" style='visibility: hidden;'";
        str_cols += ">";
        str_cols += "</td>";
      }
      else
        str_cols  +=">" + str_input + "</td>";
   }
   str_rows += "<tr style='height:8px';>" + str_cols + "</tr>\n"; 
   r_index++;
}
   
function writeInnerHTML(v_num_grid)
{
  $("t" + v_num_grid).innerHTML = str_header + str_rows + str_footer;
  $("t" + v_num_grid).setAttribute("t_rows",t_rows);
  r_index  = 1;
  str_rows = "";
}
   
function Focus(v_id_obj)
{
  if(v_id_obj.getAttribute("o_value")==null)
    v_id_obj.setAttribute("o_value", v_id_obj.value);
  v_id_obj.select();
}
   
function KeyDown(obj, ev, p_row, p_col, p_mov_horizontal, p_num_grid)
{
  if(navegador=="IE")
    num_event = ev.keyCode
  else
    num_event = ev.which
  if(num_event==0 || num_event==8) //Para Firefox
    return true;
  
  var z_row = p_row, z_col = p_col;
  origin_cell = document.getElementById("celda_" + p_num_grid + "_" + p_row + "_" + p_col)
  switch(num_event)
  { 
    case IZQUIERDA: 
      if(p_mov_horizontal)
      {
        z_col--;
        break;
      }
      else
        return;
    case DERECHA:
      if(p_mov_horizontal)
      {
        z_col++;
        break;
      }
      else
        return;
    case ARRIBA:    z_row--;break;
    case ABAJO:     z_row++;break;
    case ENTER:
      z_col++;
      if(origin_cell.getAttribute("col_salto_linea")>0)
      {
        z_col=origin_cell.getAttribute("col_salto_linea");
        z_row++;
      }
      break;
    default: return;
  }
  //console.log("celda_" + p_num_grid + "_" + z_row + "_" + z_col)
  //console.log(num_event)
  target_cell = document.getElementById("celda_" + p_num_grid + "_" + z_row + "_" + z_col)
  id_object_celda_vacio = document.getElementById("celda_vacio")
  id_object_celda_vacio.focus()
  if(num_event==ENTER)
    Set_Foco_Siguiente_Celda_Habilitada(z_row, z_col, p_num_grid)
  else
  {
    if(target_cell && target_cell.disabled==false) 
    {
      target_cell.focus();
      setTimeout(function() { target_cell.select(); }, 10);
    }
    else
    {
      origin_cell.focus();    
      setTimeout(function() { origin_cell.select(); }, 10);
    }
  }
}

function Set_Foco_Siguiente_Celda_Habilitada(s_row, s_col, s_num_grid)
{
  var w_row = s_row, w_col = s_col;
  for(w=w_col; w<40; w++)
  {
    target_cell = document.getElementById("celda_" + s_num_grid + "_" + w_row + "_" + w)
    if(!target_cell)
      break;
    if(target_cell.type=="select-one")
    {
      if(target_cell.disabled==false) 
      {
        target_cell.focus()
        break;
      }
    }
    else // input
    {
      //console.log("celda_" + s_num_grid + "_" + w_row + "_" + w)
      if(target_cell.readOnly==false)
      {
        target_cell.focus()
        //setTimeout(function() { target_cell.select(); }, 10); //En el evento ENTER funciona el select() sin problemas
        break;
      }
    }
  }
}
   
function Validator(evt, src, re)
{
  //para IE: e.keyCode
  //para Firefox: e.which
  
  if(navegador=="IE")
    num_event = evt.keyCode
  else
    num_event = evt.which
  
  if(num_event==0 || num_event==8) //Para Firefox (0:escape, 8: backspace)
    return true;
  
  var t_value, s_value;
  if(re == "") return(true);
  	   
  //s_value = selText(src);
  //t_value = src.value + String.fromCharCode(num_event);	   
  //if(s_value == src.value) t_value = String.fromCharCode(num_event);
  t_value = String.fromCharCode(num_event);
  //t_value = src.value + String.fromCharCode(num_event);	   
  eval("var regE = /" + re + "/;");
  return(regE.test(t_value));
}      
	
function selText(input){
   var range = document.selection.createRange();
   var bookmark = range.getBookmark();
   var caret_pos = bookmark.charCodeAt(2) - 2;
   return(range.text);
} 

function LimpiarSeparadorMiles(v_id_obj){
  v_id_obj.value = Replace(v_id_obj.value,",","") //Separador de miles (,)
  //v_id_obj.value = Replace(v_id_obj.value,".","") //Separador de miles (.)
}

function setCantCols(v_cantCols){
  g_cantCols = v_cantCols;
}

function MarcarFila(v_num_grid, v_row){
  for(j1=1; j1<=g_cantCols; j1++)
  {
    v_id_celda = $("grid_TD_" + v_num_grid + "_" + v_row + "_" + j1);
    //v_id_celda.style.borderTop    = "1px solid #000";
    //v_id_celda.style.borderBottom = "1px solid #000";
    v_id_celda.style.backgroundColor = "#0000AA";
  }
}

function DesMarcarFila(v_num_grid, v_row){
  for(j1=1; j1<=g_cantCols; j1++)
  {
    v_id_celda = $("grid_TD_" + v_num_grid + "_" + v_row + "_" + j1);
    //v_id_celda.style.borderTop    = "0px solid #FFF";
    //v_id_celda.style.borderBottom = "0px solid #FFF";
    v_id_celda.style.backgroundColor = "";
  }
}

//#########################################################################################################################################################################
//Esta funcion se creo porque en Chrome la tecla izquierda y derecha en un keydown de un select realiza el mismo movimiento 
//que arriba (izquierda) y abajo (derecha); por lo tanto se desactivo el movimiento lateral y se movio el foco donde corresponde (Set_Foco_Siguiente_Celda_Habilitada)
//#########################################################################################################################################################################
function Mover_Focus_Valido_Select(evt,x_row, x_col, x_num_grid){
  v_key = Navegador_No_IE ? evt.which : evt.keyCode;
  w_row = x_row; w_col = x_col;
  //console.log("w_row: "+w_row+", w_col: "+w_col+", x_num_grid: "+x_num_grid)
  origin_cell = document.getElementById("celda_" + x_num_grid + "_" + x_row + "_" + x_col)
  if(v_key == IZQUIERDA || v_key == DERECHA || v_key == ENTER)
  {
    if(v_key == DERECHA || v_key == ENTER)
      w_col++;
    else
      w_col--;  
    Set_Foco_Siguiente_Celda_Habilitada(w_row, w_col, x_num_grid)
    
    if(v_key == IZQUIERDA || v_key == DERECHA)
      return false;
    else
      return true;
  }
  else if(v_key == ARRIBA || v_key == ABAJO)
  {
    if(v_key == ARRIBA)
      w_row--;
    else
      w_row++;  
    target_cell = document.getElementById("celda_" + x_num_grid + "_" + w_row + "_" + w_col)
    if(!target_cell)
    {
      origin_cell.focus()
      return true;
    }
    else if(target_cell.disabled)
    {
      origin_cell.focus()
      return true;
    }
    else
    {
      target_cell.focus();
      return false;
    }
  }  
}