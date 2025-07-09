// function Set_Modal_Crear_Proveedor(v_id_tab_factura)
// function Set_Modal_Crear_Producto(v_id_tab_factura)
// function Cargar_typeahead_marcas()
// function Cargar_typeahead_modelos(v_id_marca)
// function Cargar_Lista_Detalle_Factura(v_id_tab_factura)
// function Eliminar_Factura(v_id_tab_factura)
// function Cargar_typeahead_proveedores()
// function Cargar_typeahead_productos(v_id_tab)
// function Set_Proveedor(v_nombre_proveedor)
// function Bloquear_Typeahead_Proveedor()
// function Bloquear_Typeahead_Proveedor_Origen()
// function Crear_Proveedor()
// function Crear_Marca(v_n_marca)
// function Crear_Modelo(v_id_marca, v_n_modelo)
// function Crear_Compra()
// function Crear_Factura(z_id_tab_factura)
// function Actualizar_Factura(z_object)
// function Set_Facturas()
// function Config_Form_Tab_General()

// $(document).ready(function ()
// Inicio config eventos tab facturas


function Set_Modal_Crear_Proveedor(v_id_tab_factura){
	$("#id_nacional").val("");
	$("#nombre").val("");
	$("#bot_cancelar_proveedor").attr("disabled",false);
	$("#bot_crear_proveedor").attr("disabled",false);
	$('#ModalProveedor').modal('show');
}

function Set_Modal_Crear_Producto(v_id_tab_factura){
	$("#bot_editar_crear_marca").css("visibility","hidden");
	$("#n_marca").val("");
	$("#n_marca").data("id_dato","");
	
	$("#bot_editar_crear_modelo").css("visibility","hidden");
	$("#n_modelo").attr("disabled",true);
	$("#n_modelo").val("");
	$("#n_modelo").data("id_dato","");
	
	$("#nombre_producto").val("");
	
	$("#hidden_id_tab_producto").val(v_id_tab_factura)
	$('#ModalProducto').modal('show');
	Cargar_typeahead_marcas();
}

function Cargar_typeahead_marcas(){
	var ObjThis = $("#n_marca");
	$("#n_marca").data('typeahead', (data = null));
	$.ajax({
		dataType: "json",
		type: "POST",
		url: ruta_modulo_compras+"/getmarcas",
		success:  function(data){
			str_source_typeahead_marcas = ""
			$.each(data['marcas'], function(id_dato, n_dato){
				str_source_typeahead_marcas+='{"id_dato": "'+id_dato+'", "n_dato": "'+n_dato.replace(/"/g,"")+'"},'
			});
			str_source_typeahead_marcas=str_source_typeahead_marcas.substring(0,str_source_typeahead_marcas.length-1);
			//console.log(str_source_typeahead);
			var array_typeahead_marcas = eval('['+str_source_typeahead_marcas+']'); var array_marcas_tmp = []; var map_marcas = {};
			$.each(array_typeahead_marcas, function (i, dato) {
				map_marcas[dato.n_dato] = dato;
				array_marcas_tmp.push(dato.n_dato);
			});
			
			ObjThis.typeahead({
				source: function (query, process) {	 
					process(array_marcas_tmp);
				},
				items: 5,
				updater: function (item) {
					ObjThis.data("id_dato",map_marcas[item].id_dato);
					$("#icon_bot_editar_crear_marca").removeClass("icon-plus");
					$("#icon_bot_editar_crear_marca").addClass("icon-edit");			
					$("#bot_editar_crear_marca").css("visibility","");
					ObjThis.attr("disabled",true);
					Cargar_typeahead_modelos(map_marcas[item].id_dato)
					return item;
				}
			});
			
			ObjThis.on(
			{
				blur: function()
				{
					setTimeout(function()
					{
						if(ObjThis.is(':disabled') == false)
						{ 
							if( ObjThis.val() != "" )
							{
								$("#bot_editar_crear_marca").css("visibility","");
								$("#icon_bot_editar_crear_marca").removeClass("icon-edit");
								$("#icon_bot_editar_crear_marca").addClass("icon-plus");			
								$("#n_modelo").attr("disabled",true);
							}
							else
								$("#bot_editar_crear_marca").css("visibility","hidden");
						}
						else
							$("#n_modelo").removeAttr("disabled");
					}, 100);
				},
				keydown: function (event)
				{
					if(event.which==13)
					{
						if (ObjThis.val() == "")
							ObjThis.trigger('blur'); //para que no se cierre el modal
						else
						{
							v_type_is_block = false;
							$("ul.typeahead.dropdown-menu").each(function() {
								if ($(this).css("display") == "block")
									v_type_is_block = true;
							});
							if(!v_type_is_block)
								ObjThis.trigger('blur'); //para que no se cierre el modal
						}
					}
				}
			});
			
			ObjThis.attr("disabled",false);
		},
		error: function(data, opt, thw){err(data.responseText);}
	});
}

function Cargar_typeahead_modelos(v_id_marca){
	var ObjThis = $("#n_modelo");
	ObjThis.removeAttr("disabled");
	ObjThis.attr("readonly",true);
	ObjThis.off();
	ObjThis.data('typeahead', (data = null))
	$.ajax({
		dataType: "json",
		type: "POST",
		url: ruta_modulo_compras+"/getmodelos/"+v_id_marca,
		success:  function(data){
			str_source_typeahead_modelos = ""
			$.each(data['modelos'], function(id_dato_modelo, n_dato_modelo){
				str_source_typeahead_modelos+='{"id_dato": "'+id_dato_modelo+'", "n_dato": "'+n_dato_modelo.replace(/"/g,"")+'"},'
			});
			str_source_typeahead_modelos=str_source_typeahead_modelos.substring(0,str_source_typeahead_modelos.length-1);
			//console.log(str_source_typeahead_modelos);
			var array_typeahead_modelos = eval('['+str_source_typeahead_modelos+']'); var array_modelos_tmp = []; var map_modelos = {};
			$.each(array_typeahead_modelos, function (j, dato_modelo) {
				map_modelos[dato_modelo.n_dato] = dato_modelo;
				array_modelos_tmp.push(dato_modelo.n_dato);
			});
			ObjThis.typeahead({
				source: function (query, process) {	 
					process(array_modelos_tmp);
				},
				items: 5,
				updater: function (item) {
					ObjThis.data("id_dato",map_modelos[item].id_dato);
					$("#icon_bot_editar_crear_modelo").removeClass("icon-plus");
					$("#icon_bot_editar_crear_modelo").addClass("icon-edit");			
					$("#bot_editar_crear_modelo").css("visibility","");
					ObjThis.attr("disabled",true);
					$("#nombre_producto").focus();
					return item;
				}
			});
			
			
			ObjThis.on(
			{
				blur: function()
				{
					setTimeout(function()
					{
						if (ObjThis.is(':disabled') == false)
						{		
							if(ObjThis.val() != "")
							{
								$("#bot_editar_crear_modelo").css("visibility","");
								$("#icon_bot_editar_crear_modelo").removeClass("icon-edit");
								$("#icon_bot_editar_crear_modelo").addClass("icon-plus");
							}
							else
								$("#bot_editar_crear_modelo").css("visibility","hidden");
						}
						else
						{
							if(ObjThis.val() != "")
								$("#nombre_producto").focus();
						}
					}, 100);
				},
				keydown: function (event)
				{
					if(event.which==13)
					{
						if (ObjThis.val() == "")
							ObjThis.trigger('blur'); //para que no se cierre el modal
						else
						{
							v_type_is_block = false;
							$("ul.typeahead.dropdown-menu").each(function() {
								if ($(this).css("display") == "block")
									v_type_is_block = true;
							});
							if(!v_type_is_block)
								ObjThis.trigger('blur'); //para que no se cierre el modal
						}
					}
				}
			});
			ObjThis.attr("readonly",false);
			ObjThis.focus();
		},
		error: function(data, opt, thw){err(data.responseText);}
	});
}

function Cargar_Lista_Detalle_Factura(v_id_tab_factura){
	$("#det_factura"+v_id_tab_factura).html("<div style='text-align:center'><br><br><p class='muted'><small>Cargando lista detalle...</small></p><img src='"+ruta_imagenes+"/loading32.gif' width=30 height=30 border=0></div>");
	$.ajax({
		url: ruta_modulo_compras+"/detalle_lista",
		type: "POST",
		async: true,
		dataType: "html",
		success: 
		function(data){
			$("#det_factura"+v_id_tab_factura).html(data);
			$("#bot_agregar_item"+v_id_tab_factura).show();
		}
	});
}

function Eliminar_Factura(v_id_tab_factura){
	x_numero_factura = $("#numero_factura"+v_id_tab_factura).val()
	questbox("Â¿EstÃ¡ seguro que desea eliminar la factura "+x_numero_factura+"?", "Confirmaci&oacute;n",  "Aceptar", "Cancelar", 
    function(){
		$("#det_factura"+v_id_tab_factura).html("");
		$("#numero_factura"+v_id_tab_factura).val("");
		$("#fecha_factura"+v_id_tab_factura).val("");
		$("#proveedor"+v_id_tab_factura).val("");
		$("#proveedor_origen"+v_id_tab_factura).val("");
		$("#proveedor"+v_id_tab_factura).val("");
		$("#proveedor_origen"+v_id_tab_factura).val("");
		/*$("#a_factura" + v_id_tab_factura).html("Factura "+v_id_tab_factura+"&nbsp;<button style='width: 20px; height:20px;' class='close' id='bot_cerrar_factura_tab"+v_id_tab_factura+"' name='bot_cerrar_factura_tab' data-indice='"+v_id_tab_factura+"'>&times;</button>");
		$("#bot_cerrar_factura_tab"+v_id_tab_factura).mouseover(function (){
			$(this).css('background-image', ruta_imagenes+'/bg_close_tab_20.png');
		});
		$("#bot_cerrar_factura_tab"+v_id_tab_factura).mouseout(function (){
			$(this).css('background-image', '');
		});
		$("#bot_cerrar_factura_tab"+v_id_tab_factura).click(function (){
			Eliminar_Factura($(this).data("indice"));
		});
		*/
		Config_Tab_Factura(v_id_tab_factura)
		$("#li_factura" + v_id_tab_factura).hide(500);
		$("#tabs_compras a[href='#tab_general']").tab("show");
		$("#bot_agregar_factura").show();
	});
}

function Cargar_typeahead_proveedores(){
	$.ajax({
		dataType: "json",
		type: "POST",
		url: ruta_modulo_compras+"/getproveedores",
		success:  function(data){
			str_source_typeahead_proveedores = ""
			$.each(data['proveedores'], function(id_dato, n_dato){
				str_source_typeahead_proveedores+='{"id_dato": "'+id_dato+'", "n_dato": "'+n_dato+'"},'
			});
			str_source_typeahead_proveedores=str_source_typeahead_proveedores.substring(0,str_source_typeahead_proveedores.length-1);
			//console.log(str_source_typeahead);
			var array_typeahead_proveedores = eval('['+str_source_typeahead_proveedores+']'); var array_proveedores_tmp = []; var map_proveedores = {};
			$.each(array_typeahead_proveedores, function (i, dato) {
				map_proveedores[dato.n_dato] = dato;
				array_proveedores_tmp.push(dato.n_dato);
			});
			
			$("input[name='proveedor']").typeahead({
				source: function (query, process) {	 
					process(array_proveedores_tmp);
				},
				updater: function (item) {
					Bloquear_Typeahead_Proveedor();
					return item;
				}
			});
			
			$("input[name='proveedor_origen']").typeahead({
				source: function (query, process) {	 
					process(array_proveedores_tmp);
				},
				updater: function (item) {
					Bloquear_Typeahead_Proveedor_Origen();
					return item;
				}
			});
		},
		error: function(data, opt, thw){err(data.responseText);}
	});
}

function Cargar_typeahead_productos(v_id_tab){
	$("#li_cantidades"+v_id_tab).css("visibility","hidden");
	$("#li_totales"+v_id_tab).css("visibility","hidden");
	$("#li_dimensiones"+v_id_tab).css("visibility","hidden");
	$("#li_otros"+v_id_tab).css("visibility","hidden");
	
	$("#accion_cancelar_item"+v_id_tab).css("visibility","hidden");
	$("#accion_grabar_item"+v_id_tab).css("visibility","hidden");
	$("#producto"+v_id_tab).attr("disabled",true);
	$("#editar_busqueda_producto"+v_id_tab).attr("disabled",true);
	
	$("#editar_busqueda_producto"+v_id_tab).click(function (){
		$(this).attr("disabled", true);
		$("#producto"+v_id_tab).removeAttr("disabled");
		$("#producto"+v_id_tab).val("");
		$("#producto"+v_id_tab).focus();
	});
	
	$.ajax({
		dataType: "json",
		type: "POST",
		url: ruta_modulo_compras+"/getproductos",
		success:  function(data){
			str_source_typeahead_productos = ""
			$.each(data['productos'], function(id_dato, n_dato){
				str_source_typeahead_productos+='{"id_dato": "'+id_dato+'", "n_dato": "'+n_dato.replace(/"/g,"")+'"},'
			});
			str_source_typeahead_productos=str_source_typeahead_productos.substring(0,str_source_typeahead_productos.length-1);
			//console.log(str_source_typeahead);
			var array_typeahead_productos = eval('['+str_source_typeahead_productos+']'); var array_productos_tmp = []; var map_productos = {};
			$.each(array_typeahead_productos, function (i, dato) {
				map_productos[dato.n_dato] = dato;
				array_productos_tmp.push(dato.n_dato);
			});
			
			$("#producto"+v_id_tab).typeahead({
				source: function (query, process) {	 
					process(array_productos_tmp);
				},
				updater: function (item) {
					//alert(map[item].id_dato);
					$("#producto"+v_id_tab).attr("disabled",true);
					$("#editar_busqueda_producto"+v_id_tab).attr("disabled",false);
					return item;
				}
			});
			$("#li_cantidades"+v_id_tab).css("visibility","");
			$("#li_totales"+v_id_tab).css("visibility","");
			$("#li_dimensiones"+v_id_tab).css("visibility","");
			$("#li_otros"+v_id_tab).css("visibility","");
	
			$("#td_cargando_list_productos"+v_id_tab).css("visibility","hidden");
			$("#producto"+v_id_tab).attr("disabled",false)
			$("#accion_cancelar_item"+v_id_tab).css("visibility","");
			$("#accion_grabar_item"+v_id_tab).css("visibility","");
		},
		error: function(data, opt, thw){err(data.responseText);}
	});
}

function Set_Proveedor(v_nombre_proveedor){
	$("#proveedor"+id_tab_actual).val(v_nombre_proveedor.toUpperCase());
	Bloquear_Typeahead_Proveedor()
}

function Bloquear_Typeahead_Proveedor(){
	$("#proveedor"+id_tab_actual).attr("disabled", true);
	$("#bot_editar_proveedor"+id_tab_actual).removeAttr("disabled");
}

function Bloquear_Typeahead_Proveedor_Origen(){
	$("#proveedor_origen"+id_tab_actual).attr("disabled", true);
	$("#bot_editar_proveedor_origen"+id_tab_actual).removeAttr("disabled");
}

function Crear_Proveedor(){
	$.ajax({
		url: ruta_modulo_compras+"/crear_proveedor/"+$('#id_nacional').val()+"/"+$('#nombre').val(),
		type: "POST",
		async: true,
		success: 
		function(data){
			Set_Proveedor($("#nombre").val())
			$("#ModalProveedor").modal('hide');
		}
	});
}

function Crear_Marca(v_n_marca){
	var ObjThis = $("#n_marca");
	$.ajax({
		url: ruta_modulo_compras+"/crear_marca/"+v_n_marca,
		type: "POST",
		async: true,
		success: 
		function(data){
			//Recargar typeahead marcas y setear la marca nueva
			console.log(data);
			ObjThis.data("id_dato",data);
			$("#icon_bot_editar_crear_marca").removeClass("icon-plus");
			$("#icon_bot_editar_crear_marca").addClass("icon-edit");			
			$("#bot_editar_crear_marca").css("visibility","");
			ObjThis.attr("disabled",true);
			Cargar_typeahead_modelos(data);
		}
	});
}

function Crear_Modelo(v_id_marca, v_n_modelo){
	var ObjThis = $("#n_modelo");
	$.ajax({
		url: ruta_modulo_compras+"/crear_modelo/"+v_id_marca+"/"+v_n_modelo,
		type: "POST",
		async: true,
		success: 
		function(data){
			//Recargar typeahead modelos y setear el nuevo modelo
			console.log(data);
			ObjThis.data("id_dato",map_modelos[item].id_dato);
			$("#icon_bot_editar_crear_modelo").removeClass("icon-plus");
			$("#icon_bot_editar_crear_modelo").addClass("icon-edit");			
			$("#bot_editar_crear_modelo").css("visibility","");
			ObjThis.attr("disabled",true);
			$("#nombre_producto").focus();
		}
	});
}

function Crear_Compra(){
	v_anio = $("#anio").val();
	v_id_documento = $("#id_documento").val();
	v_numero_legalizacion = $("#numero_legalizacion").val();
	v_sn_legalizacion = 0;
	if($("#check_sn_legalizacion").is(':checked'))
		v_sn_legalizacion = 1;
	$.ajax({
		url: ruta_modulo_compras+"/crear_compra/"+v_anio+"/"+v_id_documento+"/"+v_numero_legalizacion+"/"+v_sn_legalizacion,
		type: "POST",
		async: false,
		success: 
		function(data){
			console.log(data);
			if(data=="EXISTE")
			{
				$("#numero_legalizacion").val("");
				err("El número de legalización <b>"+v_numero_legalizacion+"</b> ya existe para el año <b>"+v_anio+"</b>");
			}
			else
			{
				$("#id_compra").val(data);
				
			}
		}
	});
}

function Crear_Factura(z_id_tab_factura){
	v_id_compra = $("#id_compra").val();
	$.ajax({
		url: ruta_modulo_compras+"/crear_factura/"+v_id_compra,
		type: "POST",
		async: false,
		success: 
		function(data){
			console.log(data);
			$("#id_factura"+z_id_tab_factura).val(data);
		}
	});
}

function Actualizar_Factura(z_object){
	v_id_compra 		= $("#id_compra").val();
	z_id_tab_factura	= z_object.data("id_tab");
	v_id_factura 		= $("#id_factura"+z_id_tab_factura).val();
	v_nom_campo 		= z_object.attr("name");
	v_valor 			= z_object.val();
	v_tipo_dato 		= z_object.data("tipo_dato");
	//console.log("z_id_tab_factura: "+z_id_tab_factura+"; v_id_factura: "+v_id_factura+"; v_nom_campo: "+v_nom_campo+"; v_valor: "+v_valor+"; v_tipo_dato: "+v_tipo_dato);
	$.ajax({
		url: ruta_modulo_compras+"/actualizar_factura/"+v_id_compra+"/"+v_id_factura+"/"+v_nom_campo+"/"+v_valor+"/"+v_tipo_dato,
		type: "POST",
		async: false,
		success: 
		function(data){
			//console.log(data);
			//$("#id_factura"+z_id_tab_factura).val(data);
		}
	});
}

function Set_Facturas(){
	v_id_compra = $("#id_compra").val();
	z_id_tab_factura = 1;
	$.ajax({
		dataType: "json",
		type: "POST",
		url: ruta_modulo_compras+"/get_facturas/"+v_id_compra,
		success:  function(data){
			$.each(data.facturas, function(){
				arr_facturas = this;
				//console.log("id_factura: "+arr_facturas.id_factura+"; numero_factura: "+arr_facturas.numero_factura+"; fecha_factura: "+arr_facturas.fecha_factura);
				//console.log("nombre proveedor: "+arr_facturas.n_proveedor+"; nombre proveedor origen: "+arr_facturas.n_proveedor_origen);
				$("#li_factura" + z_id_tab_factura).show();
				//$("#tabs_compras a[href='#tab_factura" + z_id_tab_factura + "']").tab("show");
				$("#proveedor"+ z_id_tab_factura).data("id_dato",arr_facturas.id_proveedor);
				$("#proveedor"+ z_id_tab_factura).val(arr_facturas.n_proveedor);
				$("#proveedor_origen"+ z_id_tab_factura).data("id_dato",arr_facturas.id_proveedor);
				$("#proveedor_origen"+ z_id_tab_factura).val(arr_facturas.n_proveedor_origen);
				$("#id_factura" + z_id_tab_factura).val(arr_facturas.id_factura);
				$("#numero_factura" + z_id_tab_factura).val(arr_facturas.numero_factura);
				$("#numero_factura" + z_id_tab_factura).data("oldvalue",arr_facturas.numero_factura);
				$("#fecha_factura" + z_id_tab_factura).val(arr_facturas.fecha_factura);
				$("#fecha_factura" + z_id_tab_factura).data("oldvalue",arr_facturas.fecha_factura);
				$("#total_fob" + z_id_tab_factura).val(arr_facturas.total_fob);
				$("#total_cif" + z_id_tab_factura).val(arr_facturas.total_cif);
				
				Config_Tab_Factura(z_id_tab_factura);
				z_id_tab_factura++;
			});
		},
		error: function(data, opt, thw){err(data.responseText);}
	});
}

function Config_Form_Tab_General(){
	$("#anio").attr("disabled", true);
	$("#id_documento").attr("disabled", true);
	$("#numero_legalizacion").attr("disabled", true);
	$("#label_check_sn_legalizacion").hide();
	if($("#check_sn_legalizacion").is(':checked'))
		$("#label_check_sn_legalizacion").show();
	$("#div_datos_generales4").show();
	$("#div_datos_generales5").show();
	$("#div_datos_generales6").show();
	$("#div_bot_agregar_factura").show();
	if($("#id_documento").val() == "3")
		$("input[name='total_fob']").attr("disabled", true);
}

function Config_Tab_Factura(x_id_tab_factura){
	$("#a_factura" + x_id_tab_factura).html("F. " + $("#numero_factura" + x_id_tab_factura).val() + "&nbsp;<button style='width: 20px; height:20px;' class='close' id='bot_cerrar_factura_tab"+x_id_tab_factura+"' name='bot_cerrar_factura_tab' data-indice='"+x_id_tab_factura+"'>&times;</button>");
	
	$("#bot_cerrar_factura_tab"+x_id_tab_factura).on({
		mouseover: function(){
			$("#bot_cerrar_factura_tab"+x_id_tab_factura).css('background-image', ruta_imagenes+'/bg_close_tab_20.png');
		},
		mouseout:function(){
			$("#bot_cerrar_factura_tab"+x_id_tab_factura).css('background-image', '');
		},
		click:function(){
			Eliminar_Factura(x_id_tab_factura);
		}
	});
}

$(document).ready(function (){
	$("input[name='proveedor_origen']").change(function(){
		x_id_tab = $(this).data("id_tab")
		$("#proveedor_origen"+x_id_tab).attr("disabled", true);
		$("#bot_editar_proveedor_origen"+x_id_tab).removeAttr("disabled");
	});
	
	$('a[data-toggle="tab"]').on('shown', function (e) {
		v_ruta_tab		= e.target // activated tab
		e.relatedTarget // previous tab
		array_ruta_tab	= v_ruta_tab.toString().split("#");
		array_tab 		= array_ruta_tab[1].toString().split("tab_factura");
		id_tab_actual	= array_tab[1];
	});
	
	$("#bot_agregar_factura").click(function (){
		//Econtrar el 1° tab de factura disponible
		x_id_tab_factura = "";
		for(i=1;i<=total_tabs;i++)
		{
			if($('#li_factura'+i).is(':hidden')) 
			{
				x_id_tab_factura = i;
				break;
			}
		}
		if(x_id_tab_factura!="")
		{
			//Tab de factura (x_id_tab_factura) disponible
			Crear_Factura(x_id_tab_factura);
			$("#li_factura" + x_id_tab_factura).show();
			$("#tabs_compras a[href='#tab_factura" + x_id_tab_factura + "']").tab("show");
			$("#proveedor" + x_id_tab_factura).focus();
		}
		
		//Chequear si quedan mas tab de factura disponible-->Si no quedan se esconde el botón de "crear facturas"
		band_tab_factura_disponible = false;
		for(i=1;i<=total_tabs;i++)
		{
			if($('#li_factura'+i).is(':hidden')) 
			{
				band_tab_factura_disponible = true;
				break;
			}
		}
		if(!band_tab_factura_disponible)
			$("#bot_agregar_factura").hide();
	});
	
	$("#numero_legalizacion").on({
		blur: function (){
			if($("#numero_legalizacion").val()!="")
			{
				x_numero_legalizacion = $("#numero_legalizacion").val();
				questbox("¿Está seguro que desea grabar la compra n° "+x_numero_legalizacion+"?", "Confirmaci&oacute;n",  "Aceptar", "Cancelar", 
				function(){
					$("#numero_legalizacion").val(x_numero_legalizacion);
					Crear_Compra();
					Config_Form_Tab_General();
				});
			}
		},
		keydown: function (event){
			if (event.which==13)
				$(this).trigger('blur');
		}
	});

	$("#bot_crear_proveedor").click(function (){
		if($("#id_nacional").val() == "")
		{
			$("#msg_modal_proveedor").addClass("text-warning");
			$("#msg_modal_proveedor").text("Ingrese identificación proveedor");
			$("#id_nacional").focus();
		}
		else if($("#nombre").val() == "")
		{
			$("#msg_modal_proveedor").addClass("text-warning");
			$("#msg_modal_proveedor").text("Ingrese nombre proveedor");
			$("#nombre").focus();
		}
		else
		{
			$("#msg_modal_proveedor").removeClass("text-warning");
			$("#msg_modal_proveedor").addClass("muted");
			$("#bot_cancelar_proveedor").attr("disabled",true);
			$("#bot_crear_proveedor").attr("disabled",true);
			$("#msg_modal_proveedor").html("Creando proveedor...&nbsp;<img src='"+ruta_imagenes+"/loading_F5F5F5_32.gif' width=15 height=15 border=0>");
			Crear_Proveedor()
		}
	});

	$("#check_sn_legalizacion").click(function (){
		if($(this).is(':checked'))
		{
			Crear_Compra()
			Config_Form_Tab_General();
		}
		else
		{
			$("#numero_legalizacion").removeAttr("disabled");
			$("#fecha_legalizacion").removeAttr("disabled");
			$("#fecha_recepcion").removeAttr("disabled");
			$("#numero_legalizacion").val("");
			$("#numero_legalizacion").focus();
		}
	});
	$("#paridad_usd").attr("disabled", true);
	//=========================================================
	// Inicio config eventos tab facturas
	//=========================================================
	$("button[name='bot_cerrar_factura_tab']").on({
		click: function (){
			Eliminar_Factura($(this).data("indice"));
		},
		mouseover: function (){
			$(this).css('background-image', ruta_imagenes+'/bg_close_tab_20.png');
		},
		mouseout: function (){
			$(this).css('background-image', '');
		}
	});

	$("input[id*=numero_factura]").on({
		blur: function (){
			if($(this).val() != "" && $(this).val()!=$(this).data("oldvalue"))
			{
				Actualizar_Factura($(this));
				x_id_tab_factura = $(this).data("indice");
				Config_Tab_Factura(x_id_tab_factura);
			}
		},
		keydown: function (event){
			if(event.which==13)
				$(this).trigger('blur');
		}
	});
	
	$("input[id*=fecha_factura]").on({
		blur: function (){
			if($(this).val()!=$(this).data("oldvalue"))
				Actualizar_Factura($(this));
		}
	});
	/*
	var floatRegex = "[-+]?([0-9]*\.[0-9]+|[0-9]+)"; 
	$("input[id*=total_fob]").filter(function(){
        return this.value.match(/"+floatRegex+"/);
    });
	*/
	
	$("div[id*=div_input_append_proveedor_origen]").css("visibility", "hidden");
	$("button[name='bot_editar_proveedor']").attr("disabled", true);
	$("button[name='bot_editar_proveedor']").click(function (){
		$(this).attr("disabled", true);
		x_id_tab_factura = $(this).data("indice");
		$("#proveedor"+x_id_tab_factura).removeAttr("disabled");
		$("#proveedor"+x_id_tab_factura).val("");
		$("#proveedor"+x_id_tab_factura).focus();
	});

	$("input[name='proveedor_origen']").attr("disabled", true);
	$("button[name='bot_editar_proveedor_origen']").attr("disabled", true);
	$("button[name='bot_editar_proveedor_origen']").click(function (){
		$(this).attr("disabled", true);
		x_id_tab_factura = $(this).data("indice");
		$("#proveedor_origen"+x_id_tab_factura).removeAttr("disabled");
		$("#proveedor_origen"+x_id_tab_factura).val("");
		$("#proveedor_origen"+x_id_tab_factura).focus();
	});

	$("input[name='check_proveedor_origen']").click(function (){
		x_id_tab_factura = $(this).data("indice");
		if($(this).is(':checked'))
		{
			//$("#div_input_append_proveedor_origen"+x_id_tab_factura).show('fast');
			$("#div_input_append_proveedor_origen"+x_id_tab_factura).css('visibility','');
			$("#proveedor_origen"+x_id_tab_factura).removeAttr("disabled");
			$("#proveedor_origen"+x_id_tab_factura).focus();
		}
		else
		{
			$("#proveedor_origen"+x_id_tab_factura).attr("value", "");
			$("#proveedor_origen"+x_id_tab_factura).attr("disabled", true);
			$("#bot_editar_proveedor_origen"+x_id_tab_factura).attr("disabled", true);
			$("#div_input_append_proveedor_origen"+x_id_tab_factura).css('visibility','hidden');
		}
	});

	$("button[name='bot_agregar_item']").click(function (){
		x_id_tab_factura = $(this).data("indice");
		$(this).hide(500);
		$.ajax({
			url: ruta_modulo_compras+"/detalle_form",
			type: "POST",
			data: "id_tab_factura="+x_id_tab_factura,
			async: true,
			dataType: "html",
			success: 
			function(data){
				$("#det_factura"+x_id_tab_factura).html(data);
				Cargar_typeahead_productos(x_id_tab_factura);
			}
		});
	});

	$("input[name='total_fob']").on("copy paste", function(){return false;});
	$("input[name='total_cif']").on("copy paste", function(){return false;});
	
	Cargar_typeahead_proveedores();
	
	$("#n_marca").attr("disabled",true);
	$("#bot_editar_crear_marca").css("visibility","hidden");
	$("#bot_editar_crear_marca").click(function (){
		if($("#n_marca").is(':disabled'))
		{
			$("#bot_editar_crear_modelo").css("visibility","hidden");
			$("#n_modelo").attr("disabled",true);
			$("#n_modelo").data("id_dato","");
			$("#n_modelo").val("");
			
			$("#bot_editar_crear_marca").css("visibility","hidden");
			$("#n_marca").data("id_dato","");
			$("#n_marca").attr("disabled", true);
			$("#n_marca").removeAttr("disabled");
			$("#n_marca").val("");
			$("#n_marca").focus();
		}
		else
		{
			//crear nueva marca
			msg_confirm = "Â¿EstÃ¡ seguro que desea crear la marca "+$('#n_marca').val().toUpperCase()+"?"
			if(confirm(msg_confirm))
			{
				console.log("crear marca");
				Crear_Marca($("#n_marca").val());
			}
			
			/*$("#ModalProducto").modal('hide');
			questbox(msg_confirm, "Confirmaci&oacute;n",  "Aceptar", "Cancelar", function()
			{
				console.log("crear marca")
				$("#ModalProducto").modal('show');
			});*/
		}
	});
	
	$("#n_modelo").attr("disabled",true);
	$("#bot_editar_crear_modelo").css("visibility","hidden");
	$("#bot_editar_crear_modelo").click(function ()
	{
		if($("#n_modelo").is(':disabled'))
		{
			$("#bot_editar_crear_modelo").css("visibility","hidden");
			$("#n_modelo").data("id_dato","");
			$("#n_modelo").removeAttr("disabled");
			$("#n_modelo").val("");
			$("#n_modelo").focus();
		}
		else
		{
			//crear nuevo modelo para la marca ingresada
			msg_confirm = "¿Está seguro que desea crear el modelo "+$('#n_modelo').val().toUpperCase()+" para la marca "+$('#n_marca').val().toUpperCase()+"?"
			if(confirm(msg_confirm))
			{
				console.log("crear modelo");
				Crear_Modelo($("#n_marca").data("id_dato"), $("#n_modelo").val());
			}
		}
	});
	
	$("#nombre_producto").on(
	{
		keydown: function (event)
		{
			if ($("#n_marca").val() == "" && event.which==13)
				$(this).trigger('blur');
		}
	});
	
	if($("#id_compra").val() != "")
	{
		//Se está editando una compra
		Config_Form_Tab_General();
		Set_Facturas();
	}
});