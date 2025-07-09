function Cargar_Tab(v_url){
			$("#form_buscar").html("");//limpio las ventanas
			$("#form_listar").html("");//limpio las ventanas
			$("#tope_tabla").html("");
			$.ajax({
				url: v_url,
				async: true,
				dataType: "html"
			}).done(function(html){
				var v_tipo_busqueda;
				$("#form_buscar").html(html);
				if(v_url=="estructura.asp")
				{
					$("#superfamilia").change(function(){
						$("#form_listar").html("");//limpio las ventanas
						Cargar_Familia_X_Superfamilia($("#superfamilia").val());
					});/*Fin .change*/
					Cargar_Familia_X_Superfamilia($("#superfamilia").val());
				}
				if(v_url!="ultimocambio.asp")
				{
					$("#bot_buscar").click(function(){
						if(v_url=="producto.asp")
						{
							if($("#producto").val()=="" && $("#nombre").val() ==""){
								$().toastmessage('showToast', {
									text:'Los campos no pueden estar vacios',
									sticky   : false,
									position : 'middle-center',
									type     : 'error'
								});
								return;
							}
							v_tipo_busqueda = "producto"
						}
						else if(v_url=="estructura.asp")
							v_tipo_busqueda = "estructura"
						else if(v_url=="numerofolio.asp"){
							if($("#folio").val()==""){
								$().toastmessage('showToast', {
									text:'Los campos no pueden estar vacios',
									sticky   : false,
									position : 'middle-center',
									type     : 'error'
								});
								return;
							}
							v_tipo_busqueda = "folio"
						}
						else if(v_url=="ultimocambio.asp")
							v_tipo_busqueda = "ultimo_cambio"
						else if(v_url=="proveedor.asp")
							v_tipo_busqueda = "proveedor"
						Listar(v_tipo_busqueda);
					});
				}
			});/*fin del done*/
		}/*Fin del function*/
		function Listar(v_tipo_busqueda){
			$("#form_listar").html("<br><br><center>Cargando...</center>");//limpio las ventanas
			var v_producto, v_nombre, v_superfamilia, v_familia, v_subfamilia, v_folio, v_proveedor
			if(v_tipo_busqueda=="producto")
			{
				v_producto	= $("#producto").val()
				v_nombre	= $("#nombre").val()
			}
			else if(v_tipo_busqueda=="estructura")
			{
				v_superfamilia	= $("#superfamilia").val()
				v_familia		= $("#familia").val()
				v_subfamilia	= $("#subfamilia").val()
			}
			else if(v_tipo_busqueda=="folio"){
				v_folio	= $("#folio").val();
			}
			else if(v_tipo_busqueda=="ultimocambio"){
				$("#tope_tabla").html("");
				$("#form_buscar").html("");//limpio las ventanas
			}
			$.ajax({
				url: "listar.asp",
				data: "tipo_busqueda="+v_tipo_busqueda+
				"&producto="+v_producto+
				"&nombre="+escape(v_nombre)+
				"&superfamilia="+escape(v_superfamilia)+
				"&familia="+escape(v_familia)+
				"&subfamilia="+escape(v_subfamilia)+
				"&folio="+escape(v_folio)+
				"&proveedor="+escape(v_proveedor),
				type: "POST",
				async: true,
				dataType: "html"
			}).done(function(html){
				$("#form_listar").html(html);
			});/*fin del done*/
		}/*Fin del function*/

		function Cargar_Familia_X_Superfamilia(x_superfamilia){
			$("#form_listar").html("");//limpio las ventanas
			$("#tope_tabla").html("");
			var v_familia, v_superfamilia;
			$.ajax({
				url: "familias.asp", /*ASP para dibujar el select*/
				data: "superfamilia="+x_superfamilia, /*variable que le entrego*/
				type: "POST", /*metodo*/
				async: true,
				dataType: "html", /*tipo de documento para recibir la data*/
			}).done(function( html ){
			  $("#div_familia").html(html);
			  $("#familia").change(function(){
					v_superfamilia = $("#superfamilia").val()
					v_familia = $("#familia").val()
					Cargar_Subfamilia_X_Familia_X_Superfamilia(v_superfamilia, v_familia)
			  });/*Fin .Change*/
				v_superfamilia = $("#superfamilia").val()
				v_familia = $("#familia").val()
				Cargar_Subfamilia_X_Familia_X_Superfamilia(v_superfamilia, v_familia)
			});/*Fin del Done*/
		}/*Fin Function Cargar_Familia*/
		function Cargar_Subfamilia_X_Familia_X_Superfamilia(x_superfamilia, x_familia){
			$("#form_listar").html("");//limpio las ventanas
			$("#tope_tabla").html("");
			$.ajax({
				url: "subfamilias.asp",
				data: "superfamilia="+x_superfamilia+"&familia="+x_familia,
				type: "POST",
				async: true,
				dataType: "html",
			}).done(function(data){
				$("#div_subfamilia").html(data);
			});/*fin .done*/
		}/*Fin Cargar_subfamilia*/	