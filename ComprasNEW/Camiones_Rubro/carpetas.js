function Grabar_Carpeta_Inicial(){
  if(confirm("¿Está seguro que desea crear una nueva carpeta?"))
  {
    document.body.style.cursor = "wait"
    var ajx1 = new Ajax("carpetas_grabar.asp",{
      method:'post', 
      async:false,
      data: 'accion=insertar&documento_respaldo='+documento_respaldo.value+
      '&anio='+anio.value+'&mes='+mes.value,
      onComplete: function(respuesta){
        //alert(respuesta)
        //msg_accion_3.innerText = respuesta
        //return
        document.body.style.cursor        = ""
        documento_respaldo.disabled       = true
        anio.disabled                     = true
        anio.style.backgroundColor        = "#EEEEEE"
        mes.disabled                      = true
        mes.style.backgroundColor         = "#EEEEEE"
        num_carpeta.value                 = respuesta
        num_carpeta.disabled              = true
        num_carpeta.style.backgroundColor = "#EEEEEE"
        Mostrar_Form_Carpeta(true)
        fieldset_gastos.style.visibility  = ""
        Cargar_Gastos("INGRESAR",documento_respaldo.value,anio.value,mes.value,num_carpeta.value)
        Config_Msg_Accion("CARPETA CREADA SATISFACTORIAMENTE...",msg_accion_3)
      }
    });
    ajx1.request();
  }
  else
    mes.value=""
}

function Mostrar_Form_Carpeta(v_band){
  if(v_band)
  {
    td_cab_1.style.visibility=""
    td_cab_2.style.visibility=""
    td_cab_3.style.visibility=""
    td_cab_4.style.visibility=""
    td_cab_5.style.visibility=""
  }
  else
  {
    td_cab_1.style.visibility="hidden"
    td_cab_2.style.visibility="hidden"
    td_cab_3.style.visibility="hidden"
    td_cab_4.style.visibility="hidden"
    td_cab_5.style.visibility="hidden"
  }
}

function Actualizar_Datos_Carpeta(v_nom_campo,v_valor){
  document.body.style.cursor = "wait"
  var ajx = new Ajax("carpetas_grabar.asp",{
    method:'post', 
    async:false,
    data: 'accion=actualizar&documento_respaldo='+documento_respaldo.value+
    '&anio='+anio.value+'&mes='+mes.value+'&num_carpeta='+num_carpeta.value+
    '&nom_campo='+v_nom_campo+'&valor='+v_valor,
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor = ""
      Config_Msg_Accion("DATOS ACTUALIZADOS...",msg_accion_3)
    }
  });
  ajx.request();
}

function Editar_Carpeta(){
  if(Radio_Es_Arreglo(radio_carpetas))
  {
    for(i=0;i<=radio_carpetas.length-1;i++)
      if(radio_carpetas[i].checked==true)
      { 
        v_documento_respaldo  = radio_carpetas[i].documento_respaldo
        v_anio                = radio_carpetas[i].anio
        v_mes                 = radio_carpetas[i].mes
        v_num_carpeta         = radio_carpetas[i].num_carpeta
        v_id_embarcador       = radio_carpetas[i].id_embarcador
        v_id_origen           = radio_carpetas[i].id_origen
        v_id_transporte       = radio_carpetas[i].id_transporte
        v_fecha_salida        = radio_carpetas[i].fecha_salida
        break;
      }
  }
  else
  {
    v_documento_respaldo  = radio_carpetas.documento_respaldo
    v_anio                = radio_carpetas.anio
    v_mes                 = radio_carpetas.mes
    v_num_carpeta         = radio_carpetas.num_carpeta
    v_id_embarcador       = radio_carpetas.id_embarcador
    v_id_origen           = radio_carpetas.id_origen
    v_id_transporte       = radio_carpetas.id_transporte
    v_fecha_salida        = radio_carpetas.fecha_salida
  }
  documento_respaldo.value          = v_documento_respaldo
  documento_respaldo.disabled       = true
  anio.value                        = v_anio
  anio.disabled                     = true
  anio.style.backgroundColor        = "#EEEEEE"
  mes.value                         = v_mes
  mes.disabled                      = true
  mes.style.backgroundColor         = "#EEEEEE"
  num_carpeta.value                 = v_num_carpeta
  num_carpeta.disabled              = true
  num_carpeta.style.backgroundColor = "#EEEEEE"
  id_embarcador.value               = v_id_embarcador
  id_origen.value                   = v_id_origen
  id_transporte.value               = v_id_transporte
  fecha_salida.value                = v_fecha_salida
    
  grilla_carpetas.style.visibility        = "hidden"
  tabla_botonera_general.style.visibility = "hidden"
  label_accion_modulo.innerText           = "EDITANDO CARPETA"
  capaDatosCarpeta.style.visibility       = ""
  fieldset_gastos.style.visibility        = ""
  Mostrar_Form_Carpeta(true)
  Cargar_Gastos("INGRESAR",documento_respaldo.value,anio.value,mes.value,num_carpeta.value)
}

function Eliminar_Carpeta(){
  if(confirm("¿Está seguro que desea eliminar esta carpeta?\nSe borrarán todos los gastos asociados a esta carpeta"))
  {
    if(Radio_Es_Arreglo(radio_carpetas))
    {
      for(i=0;i<=radio_carpetas.length-1;i++)
        if(radio_carpetas[i].checked==true)
        { 
          v_anio          = radio_carpetas[i].anio
          v_mes           = radio_carpetas[i].mes
          v_num_carpeta   = radio_carpetas[i].num_carpeta
          break;
        }
    }
    else
    {
      v_anio          = radio_carpetas.anio
      v_mes           = radio_carpetas.mes
      v_num_carpeta   = radio_carpetas.num_carpeta
    }
    document.body.style.cursor = "wait"
    var ajx = new Ajax("carpetas_grabar.asp",{
      method:'post', 
      async:false,
      data: 'accion=eliminar&documento_respaldo='+buscar_documento_respaldo.value+
      '&anio='+v_anio+'&mes='+v_mes+'&num_carpeta='+v_num_carpeta,
      onComplete: function(respuesta){
        document.body.style.cursor = ""
        //alert(respuesta)
        if(respuesta=="CARPETA_ASOCIADA")
          alert("Carpeta asociada a documento de compra. No se puede eliminar")
        else
          Buscar_Carpetas(true,1)
      }
    });
    ajx.request();
  }
}

function Cancelar_Ingreso_Carpeta(){
  documento_respaldo.disabled             = false
  anio.disabled                           = false
  anio.style.backgroundColor              = ""
  mes.value                               = ""
  mes.disabled                            = false
  mes.style.backgroundColor               = ""
  fecha_salida.value                      = fecha_hoy
  capaDatosCarpeta.style.visibility       = ""
  grilla_gastos.innerHTML                 = ""
  
  tabla_botonera_general.style.visibility = ""
  label_accion_modulo.innerText           = "BUSCAR CARPETA"
  capaDatosCarpeta.style.visibility       = "hidden"
  grilla_carpetas.style.visibility        = ""
  Cancelar_Busqueda_Carpeta()
}

function Set_Nuevo(){
  Mostrar_Form_Carpeta(false)
  fieldset_gastos.style.visibility        = "hidden"
  tabla_botonera_general.style.visibility = "hidden"
  label_accion_modulo.innerText           = "INGRESAR NUEVA CARPETA"
  capaDatosCarpeta.style.visibility       = ""
  mes.value                               = ""
  mes.focus()
  
  
  //fieldset_gastos.style.visibility  = ""
  //mes.value=1
  //num_carpeta.value=1
  //Cargar_Gastos("INGRESAR",documento_respaldo.value,anio.value,mes.value,num_carpeta.value)
}

function Cancelar_Busqueda_Carpeta(){
  buscar_documento_respaldo.disabled        = false
  buscar_num_carpeta.value                  = ""
  buscar_num_carpeta.disabled               = false
  buscar_num_carpeta.style.backgroundColor  = ""
  buscar_anio.disabled                      = false
  buscar_anio.style.backgroundColor         = ""
  buscar_mes.disabled                       = false
  buscar_mes.style.backgroundColor          = ""
  
  SetBackgroundImageInput(bot_buscar,RutaProyecto+"imagenes/ico_buscar_24X24_on.gif")
  //SetBackgroundImageInput(bot_nuevo,RutaProyecto+"imagenes/ico_nuevo_24X24_on.gif")
  //SetBackgroundImageInput(bot_editar,RutaProyecto+"imagenes/ico_editar_24X24_off.gif")
  //SetBackgroundImageInput(bot_eliminar,RutaProyecto+"imagenes/ico_eliminar_24X24_off.gif")
  SetBackgroundImageInput(bot_atras,RutaProyecto+"imagenes/ico_atras_24X24_off.gif")
  
  bot_buscar.disabled   = false
  pend.disabled = false
  //bot_nuevo.disabled    = false
  //bot_editar.disabled   = true
  //bot_eliminar.disabled = true
  bot_atras.disabled    = true
  
  grilla_carpetas.innerHTML    = ""
  if(buscar_mes.value == '')
  {
	buscar_mes.disabled                       = true
	buscar_mes.style.backgroundColor          = "#EEEEEE"
  }
}

function Buscar_Carpetas(v_async,v_busqueda_aprox){
  strCargando ="<br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Listando carpetas...espere un momento</b></font><br><br></center>"
  grilla_carpetas.innerHTML   = strCargando
  document.body.style.cursor  = "wait"
  buscar_documento_respaldo.disabled        = true
  buscar_anio.disabled                      = true
  buscar_anio.style.backgroundColor         = "#EEEEEE"
  buscar_mes.disabled                       = true
  buscar_mes.style.backgroundColor          = "#EEEEEE"
  buscar_num_carpeta.disabled               = true
  buscar_num_carpeta.style.backgroundColor  = "#EEEEEE"
 
  bot_buscar.disabled = true
  pend.disabled = true
  //bot_nuevo.disabled  = true
  SetBackgroundImageInput(bot_buscar,RutaProyecto+"imagenes/ico_buscar_24X24_off.gif")
  //SetBackgroundImageInput(bot_nuevo,RutaProyecto+"imagenes/ico_nuevo_24X24_off.gif") 
  var ajx = new Ajax("carpetas_listar.asp",{
    method:'post', 
    async:eval(v_async),
    data: 'busqueda_aprox='+v_busqueda_aprox+
    '&documento_respaldo='+buscar_documento_respaldo.value+
    '&anio='+buscar_anio.value+'&mes='+buscar_mes.value+
    '&num_carpeta='+buscar_num_carpeta.value+
    '&pend='+pend.checked,
    update:$("grilla_carpetas"),
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor = ""
      grilla_carpetas.style.cursor  = ""
      if(respuesta=="")
        Cancelar_Busqueda_Carpeta()
      else
      {
        //SetChecked_Radio(radio_carpetas,0)
        //SetBackgroundImageInput(bot_eliminar,RutaProyecto+"imagenes/ico_eliminar_24X24_on.gif")
        //SetBackgroundImageInput(bot_editar,RutaProyecto+"imagenes/ico_editar_24X24_on.gif")
        SetBackgroundImageInput(bot_atras,RutaProyecto+"imagenes/ico_atras_24X24_on.gif")
        //bot_editar.disabled   = false
        //bot_eliminar.disabled = false
        bot_atras.disabled    = false
      }
    }
  });
  ajx.request();
}

function Cargar_Gastos(v_accion,v_documento_respaldo,v_anio,v_mes,v_num_carpeta){
  strCargando ="<br><br><center><img src='"+RutaProyecto+"imagenes/new_loader.gif' width='32' height='32' "
  strCargando+="border='0' align='top'><br><br><font color='#848284'><b>Cargando datos...espere un momento</b></font><br><br></center>"
  grilla_gastos.innerHTML             = strCargando
  document.body.style.cursor          = "wait"
  grilla_gastos.style.cursor          = "wait"
  bot_agregar_gasto.style.visibility  = "hidden"
  bot_eliminar_gasto.style.visibility = "hidden"
  td_id_gasto.innerHTML               = "<img src='"+RutaProyecto+"imagenes/new_loader.gif' width='20' height='20' border='0' align='top'>"
  var ajx = new Ajax("carpetas_gastos_grilla.asp",{
    method:'post', 
    data: 'accion='+v_accion+'&documento_respaldo='+v_documento_respaldo+
    '&anio='+v_anio+'&mes='+v_mes+'&num_carpeta='+v_num_carpeta,
    evalScripts:true,
    update:$("grilla_gastos"),
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor  = ""
      grilla_gastos.style.cursor  = ""
      Cargar_Gastos_Tipos()
    }
  });
  ajx.request();
}

function Cargar_Gastos_Tipos(){
  document.body.style.cursor="wait"
  var ajx = new Ajax("carpetas_gastos_tipos.asp",{
    method:'post', 
    data:'documento_respaldo='+documento_respaldo.value+
    '&anio='+anio.value+'&mes='+mes.value+'&num_carpeta='+num_carpeta.value,
    update:$("td_id_gasto"),
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor          = ""
      td_texto_id_gasto.style.visibility  = ""
      td_id_gasto.style.visibility        = ""
      bot_agregar_gasto.style.visibility  = ""
      bot_eliminar_gasto.style.visibility = ""
      if(id_gasto.value=="")
      {
        td_texto_id_gasto.style.visibility  = "hidden"
        td_id_gasto.style.visibility        = "hidden"
        bot_agregar_gasto.style.visibility  = "hidden"
      }
    }
  });
  ajx.request();
}

function Agregar_Gasto(){
  document.body.style.cursor="wait"
  var ajx = new Ajax("carpetas_gastos_grabar.asp",{
    method:'post', 
    data:'accion=insertar&documento_respaldo='+documento_respaldo.value+
    '&anio='+anio.value+'&mes='+mes.value+'&num_carpeta='+num_carpeta.value+'&id_gasto='+id_gasto.value,
    onComplete: function(respuesta){
      //alert(respuesta)
      document.body.style.cursor=""
      Cargar_Gastos("INGRESAR",documento_respaldo.value,anio.value,mes.value,num_carpeta.value)
    }
  });
  ajx.request();
}


function SaveChanges(cell, c_row, c_col, c_type, c_name, c_scale, c_maxlength, c_null){
  c_value   = cell.value; c_ovalue  = cell.getAttribute("o_value");
  if(c_type == 0){
    c_value   = Replace(cell.value, ".", "");
    c_ovalue  = Replace(cell.getAttribute("o_value"), ".","");
  }
  if(c_value == c_ovalue) 
  {
    //cell.value  = Formatear_Separador_Miles(c_value)
    //cell.setAttribute("o_value", Formatear_Separador_Miles(c_ovalue.toString()));
    cell.value  = c_value
    cell.setAttribute("o_value", c_ovalue.toString());
    return;
  }
  if(!c_null && c_value == "")
  {
    alert("Debe ingresar un valor")
    cell.value = cell.getAttribute("o_value");
    cell.focus();
    return;   
  }
    
  if(c_type == 0) /*number*/
  {
    if(!IsNum(Replace(c_value,".", ",")))
    {
      alert("Ingrese un valor numérico")
      cell.value = cell.getAttribute("o_value");
      cell.focus();
      return;   
    }
             
    //Armar string de rango maximo
    if( parseInt(c_scale)>0 )
      rango_maximo=LPad("9",parseInt(c_maxlength)-parseInt(c_scale) - 1,"9")+"."+LPad("9",parseInt(c_scale),"9")
    else
      rango_maximo=LPad("9",parseInt(c_maxlength)-parseInt(c_scale),"9")
    c_value = roundNumber(c_value, c_scale);
    if( parseFloat(c_value) < 0 || parseFloat(c_value) > parseFloat(rango_maximo))
    {
      alert("Valor fuera de Rango")
      cell.value = cell.getAttribute("o_value");
      cell.focus();
      return;
    }
    str_c_value = c_value
  }
  v_id_gasto  = eval("document.all.celda_" + c_row + "_2").value
  document.body.style.cursor="wait"  
  var ajx = new Ajax(RutaProyecto+"comprasNEW/carpetas/carpetas_gastos_grabar.asp",{
    method:'post', 
    async:false,
    data: 'accion=actualizar&documento_respaldo='+documento_respaldo.value+'&anio='+anio.value+'&mes='+mes.value+
    '&num_carpeta='+num_carpeta.value+'&id_gasto='+v_id_gasto+'&nom_campo='+escape(c_name)+'&valor='+escape(c_value),
    onComplete: function(respuesta){
      //alert(respuesta)
      cell.value = c_value.toString();
      cell.setAttribute("o_value", c_value.toString());
      Config_Msg_Accion("DATOS ACTUALIZADOS...",msg_accion_3)
      document.body.style.cursor=""
    }
  });
  ajx.request();
}

function Eliminar_Gastos(){
  if(!Verificar_Check_Tuplas()){
    alert("No ha seleccionado registros!")
    return;
  }
  
  if(confirm("¿Está seguro que desea eliminar estos registros?"))
  {
    document.body.style.cursor="wait"
    strId_Gasto = ""
    for(i=1;i<=t_rows;i++)  
      if(eval("document.all.celda_" + i + "_1").checked==true)
      {
        if(strId_Gasto!="")        
          strId_Gasto=strId_Gasto+delimiter
        strId_Gasto  = strId_Gasto+eval("document.all.celda_" + i + "_2").value
      }
    
    var ajx = new Ajax("carpetas_gastos_grabar.asp",{
      method:'post', 
      data:'accion=eliminar&documento_respaldo='+documento_respaldo.value+
      '&anio='+anio.value+'&mes='+mes.value+'&num_carpeta='+num_carpeta.value+'&strId_Gasto='+escape(strId_Gasto),
      onComplete: function(respuesta){
        //alert(respuesta)
        Config_Msg_Accion("DATOS ELIMINADOS...",msg_accion_3)
        Cargar_Gastos("INGRESAR",documento_respaldo.value,anio.value,mes.value,num_carpeta.value)
      }
    });
    ajx.request();
  }
}

function Verificar_Check_Tuplas(){
  for(k=1;k<=t_rows;k++) 
  {
    if(eval("document.all.celda_" + k + "_1").checked==true)
      return true;
  }
  return false;
}

function Config_Msg_Accion(str_Msg_Accion,id_msg_accion){
  id_msg_accion.innerText = str_Msg_Accion
  if(id_msg_accion.name=="msg_accion_1")
    setTimeout("msg_accion_1.innerText=''",3000);
  else if(id_msg_accion.name=="msg_accion_2")
    setTimeout("msg_accion_2.innerText=''",3000);
  else if(id_msg_accion.name=="msg_accion_3")
    setTimeout("msg_accion_3.innerText=''",3000);
}

//##################### FUNCIONES CON ARCHIVOS ###########################
function Delete_File(c_row, c_col, c_name, c_nom_file){
  if(confirm("¿Está seguro que desea eliminar este archivo?"))
  {
    id_gasto_tmp  = eval("document.all.celda_" + c_row + "_2").value
    url_tmp = RutaProyecto+"comprasNEW/carpetas/carpetas_archivo_eliminar.asp"
    var ajx = new Ajax(url_tmp,{
      method:'post', 
      data: 'documento_respaldo='+documento_respaldo.value+
      '&anio='+anio.value+'&mes='+mes.value+'&num_carpeta='+num_carpeta.value+
      '&id_gasto='+id_gasto_tmp+'&nom_campo='+c_name+'&nom_archivo='+escape(c_nom_file),
      onComplete: function(respuesta){
        //alert(respuesta)
        Config_Msg_Accion("ARCHIVO ELIMINADO SATISFACTORIAMENTE...",msg_accion_3)
        Cargar_Gastos("INGRESAR",documento_respaldo.value,anio.value,mes.value,num_carpeta.value)
      }
    });
    ajx.request();
  }
}

function Load_File_OK(){  
  Cancelar_Load_File()
  Config_Msg_Accion("ARCHIVO ADJUNTADO SATISFACTORIAMENTE...",msg_accion_3)
  Cargar_Gastos("INGRESAR",documento_respaldo.value, anio.value,mes.value,num_carpeta.value)
}

function Set_Load_File(cell, c_row, c_col, c_name){
  id_gasto_tmp = eval("document.all.celda_" + c_row + "_2").value
  frameArchivo.document.location.href=RutaProyecto+"comprasNEW/carpetas/carpetas_archivo.asp?documento_respaldo="+documento_respaldo.value+"&anio="+anio.value+"&mes="+mes.value+
  "&num_carpeta="+num_carpeta.value+"&id_gasto="+id_gasto_tmp+"&nom_campo="+c_name
  OcultarCapa("grilla_gastos")
  ResetCapa("capaLoadFile")
}

function Cancelar_Load_File(){
  OcultarCapa("capaLoadFile")
  ResetCapa("grilla_gastos")
}

function Generar_Informe(v_numero_documento_respaldo,v_documento_no_valorizado,v_documento_respaldo,v_fecha_recepcion,v_proveedor, v_nombre_proveedor,v_fecha_emision,v_paridad,v_total_cif_ori,v_total_cif_adu,v_carpeta){
  parametros ="documento_no_valorizado="+v_documento_no_valorizado+"&numero_documento_respaldo="+v_numero_documento_respaldo
  parametros+="&documento_respaldo="+v_documento_respaldo+"&proveedor="+v_proveedor+"&nombre_proveedor="+escape(v_nombre_proveedor)
  parametros+="&fecha_recepcion="+v_fecha_recepcion+"&fecha_emision="+v_fecha_emision+"&paridad="+v_paridad+"&total_cif_ori="+v_total_cif_ori+"&total_cif_adu="+v_total_cif_adu+"&carpeta="+v_carpeta
  ruta_informe = "compras_listar_detalle"  
  var h = (screen.availHeight - 36), w = (screen.availWidth - 10),  x = 0 , y = 0
  str = "width="+w+", height="+h+", screenX="+x+", screenY="+y+", left="+x+", top="+y+", scrollbars=3,  menubar=no, toolbar=no, status=no"
  WinInforme = open("../"+ruta_informe+".asp?"+parametros, "Inf", str, "replace=1")
}

function marcar(i)
{
  if (buscar_mes.value == '')
  {
	buscar_mes.disabled                       = false
	buscar_mes.style.backgroundColor          = ""
    buscar_mes[i].selected					  = true

  }
  else
  {
	  //alert(buscar_mes.selectedindex)
	  buscar_mes.disabled                       = true
	  buscar_mes.style.backgroundColor          = "#EEEEEE"
      buscar_mes.value 							= ""
	  	
  }
}