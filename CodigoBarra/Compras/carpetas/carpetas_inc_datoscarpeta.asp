<%
strSQL="select id_embarcador, n_embarcador from tb_embarcadores order by n_embarcador"
set rs_embarcadores = Conn.Execute(strSQL)

strSQL="select id_origen, n_origen from tb_origenes order by n_origen"
set rs_origenes = Conn.Execute(strSQL)

strSQL="select id_transporte, n_transporte from tb_transportes order by n_transporte"
set rs_transportes = Conn.Execute(strSQL)
%>
<div id="capaDatosCarpeta" name="capaDatosCarpeta" style="position:absolute; width: 988px; top: 30px; z-index:1; visibility:hidden;">
  <fieldset id="fieldset_datos_generales" name="fieldset_datos_generales" align="center" style="width:100%; height:50px;">
    <legend id="texto_10">DATOS GENERALES</legend>
    <table id="texto_11" width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
    <tr height="22">
      <td width="80">&nbsp;<b>DOC.:</b>&nbsp;<br>
      <select id="documento_respaldo" name="documento_respaldo" style="width: 40px;">
      <option value="R">R</option><option value="TU">TU</option><option value="Z">Z</option>
      </select></td>
      <td width="84">&nbsp;<b>AÑO:</b>
      <select id="anio" name="anio" style="width: 50px;">
      <option value="2011">2011</option>
      <option value="2010">2010</option>
      </select>
      <td width="116">
      &nbsp;<b>MES:</b>
      <select 
      OnChange="if(this.value!='')Grabar_Carpeta_Inicial()"
      id="mes" name="mes" style="width: 80px;">
      <option value=""></option>
      <%for i=1 to 12%>
        <option value="<%=i%>"><%=GetMes(i)%></option>
      <%next%>
      </select></td>
      <td id="td_cab_1" name="td_cab_1" width="40"><b>N°:</b>
      <input type="text" id="num_carpeta" name="num_carpeta" style="width: 20px;"></td>
      <td id="td_cab_2" name="td_cab_2" width="158"><b>ORIGEN:</b>
      <select 
      OnChange="if(this.value!='')Actualizar_Datos_Carpeta(this.name,this.value)"
      id="id_origen" name="id_origen" style="width: 110px;">
      <option value=""></option>
      <%do while not rs_origenes.EOF%>
        <option value="<%=rs_origenes("id_origen")%>"><%=rs_origenes("n_origen")%></option>
      <%rs_origenes.MoveNext
      loop%>
      </select>
      </td>
      <td id="td_cab_3" name="td_cab_3" width="146"><b>TRANSP.:</b>
      <select 
      OnChange="if(this.value!='')Actualizar_Datos_Carpeta(this.name,this.value)"
      id="id_transporte" name="id_transporte" style="width: 90px;">
      <option value=""></option>
      <%do while not rs_transportes.EOF%>
      <option value="<%=rs_transportes("id_transporte")%>"><%=rs_transportes("n_transporte")%></option>
      <%rs_transportes.MoveNext
      loop%>
      </select>
      </td>
      <td id="td_cab_4" name="td_cab_4" width="140"><b>FEC. SALIDA:</b>
      <input value="<%=fecha_hoy%>" 
      onfocus="select();"
      onblur="this.value=GetFechaCompleta(this.value,'<%=fecha_hoy%>');if(this.value!='')Actualizar_Datos_Carpeta(this.name,this.value)"
      onkeypress="return Valida_Caracteres_Fecha(event);" 
      onclick="displayCalendarEjectFunction(this,'dd/mm/yyyy',this,true)"
      type="text" id="fecha_salida" name="fecha_salida" maxlength="10" style="width: 64px;"></td>
      
      
      <td id="td_cab_6" name="td_cab_6" width="140"><b>FEC. LLEGADA:</b>
      <input value="<%=fecha_hoy%>" 
      onfocus="select();"
      onblur="this.value=GetFechaCompleta(this.value,'<%=fecha_hoy%>');if(this.value!='')Actualizar_Datos_Carpeta(this.name,this.value)"
      onkeypress="return Valida_Caracteres_Fecha(event);" 
      onclick="displayCalendarEjectFunction(this,'dd/mm/yyyy',this,true)"
      type="text" id="fecha_llegada" name="fecha_llegada" maxlength="10" style="width: 64px;"></td>
            <td id="td_cab_6" name="td_cab_6" width="140"><b>Manifiesto:</b>
      <input value="0" 
      onfocus="select();"
      onblur="if(this.value!='')Actualizar_Datos_Carpeta(this.name,this.value)"
      type="text" id="Manifiesto" name="manifiesto" maxlength="10" style="width: 64px;"></td>
            
      
      <td id="td_cab_5" name="td_cab_5"><b>EMBARCADOR:</b>
      <select OnChange="if(this.value!='')Actualizar_Datos_Carpeta(this.name,this.value)"
      id="id_embarcador" name="id_embarcador" style="width: 130px;">
      <option value=""></option>
      <%do while not rs_embarcadores.EOF%>
        <option value="<%=rs_embarcadores("id_embarcador")%>"><%=rs_embarcadores("n_embarcador")%></option>
      <%rs_embarcadores.MoveNext
      loop%>
      </select>
      </td>
    </tr>
    </table>
  </fieldset>
  <fieldset id="fieldset_gastos" name="fieldset_gastos" align="center" style="width:100%; height:410px; visibility: hidden;">
    <legend id="texto_10">GASTOS</legend>
    <table align="center" width="380" border="0" cellpadding="0" cellspacing="0">
    <tr align="center" height="30">
      <td id="td_texto_id_gasto" name="td_texto_id_gasto"><b>Tipos de Gasto:</b></td>
      <td width="210" id="td_id_gasto" name="td_id_gasto"></td>
      <td>
      <input class="boton_Agregar_on" type="button" title="Agregar Gasto" 
      OnClick="if(id_gasto.value!='')Agregar_Gasto()" id="bot_agregar_gasto" name="bot_agregar_gasto">&nbsp;
      <input class="boton_Eliminar" type="button" title="Eliminar Gasto(s)"
      OnClick="Eliminar_Gastos()" id="bot_eliminar_gasto" name="bot_eliminar_gasto">
      </td>
    </tr>
    </table>
    <table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr><td id="grilla_gastos" name="grilla_gastos"></td></tr>
    </table>
  </fieldset>
  <table width="100%" align="center" cellPadding="0" cellSpacing="0" border=0>
  <tr bgcolor="#DDDDDD">
    <td width="300"><label class="msg_accion" id="msg_accion_3" name="msg_accion_3"></label></td>
    <td align="right">
    <input class="boton_Atras_on" type="button" title="Volver atrás" 
    OnFocus="Cancelar_Ingreso_Carpeta()" id="bot_cancelar_carpeta" name="bot_cancelar_carpeta">&nbsp;</td>
  </tr>
  </table>
</div>
<div id="capaFrame" name="capaFrame" style="position:absolute; width: 840px; height:220px; top: 180px; visibility:hidden;">
<iframe id="frameOcultar" name="frameOcultar" scrolling="no" frameborder="0" style="position:absolute; width: 600px; height:220px; border:none; display:block; z-index:0"></iframe>
</div>
<div id="capaLoadFile" bgcolor="#FFFFFF" style="position:absolute; width: 840px; height:220px; top: 180px; border: 1px solid #999; z-index:5; visibility: hidden;">
  <table align="center" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td>
    <table align="center" width="500" border="0" cellpadding="0" cellspacing="0">
    <tr align="center" height="40">
      <td colspan="2"><b>ADJUNTAR ARCHIVO</b></td>
    </tr>
    <tr height="50">
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td width="250">
      <iframe width="370" height="100" name="frameArchivo" id="frameArchivo" frameborder="0"></iframe>
      </td>
      <td valign="top"><input Onclick="Cancelar_Load_File()" class="boton_70" type="button" value="Cancelar" name="bot_cancelar_load_file"></td>
    </tr>
    </table>
    </td>
  </tr>
  </table>
</div>
