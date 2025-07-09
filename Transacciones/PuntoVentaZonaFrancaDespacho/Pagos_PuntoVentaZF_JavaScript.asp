<script language="JavaScript">
    <%if Imprimir_boleta or Imprimir_factura or Accion_a_ejecutar = "Terminar" then%>
        onsubmit = "Si";
    <%else%>
        onsubmit = "No";
    <%end if%>

    function fVerificaDoc( obj )
    {
		n = obj.id.substr( 21 );
		if ( n > 1 ) {
			arrayValue = obj.value.split(";");
			if ( arrayValue[2] > 0 ) {
				objCad = $("#objCad").val();
				if ( objCad.indexOf(arrayValue[2]) != -1 ) {
					alert( "Este documento de pago ya fue seleccionado." );
					document.getElementById(obj.id).value = "EFI;0;0;";
					return false;
				}
			}
		}
		
        var aDatos = obj.value.split(";")
        Economatos = "<%=session("Economatos")%>";
        if ( Economatos.indexOf(aDatos[0]) != -1 )
        {
            if ( validEmpty( '<%=Session("xEconomato")%>') )
            {
                var sValue = undefined;        
                do
                {
                    var sValue = window.showModalDialog ("ListaEconomatos_ZF.asp", "valor", "dialogWidth:30;dialogHeight:15;center:yes;edge:sunken;unadorned:yes;status:no;help:no;")
                }
                while(sValue == undefined);
                
                if ( sValue == "CANCELAR" || sValue == "ACEPTAR" )
                {
                    if ( sValue == "CANCELAR" )
                    {
                        obj.value = "EFI"
                    }
                    submitform();
                }
            }
            else
            {
                submitform();
            }
        }
        if ( aDatos[0] == "TMU" )
        {
            if ( validEmpty( '<%=Session("xMulticredito")%>') )
            {
                var sValue = undefined;        
                do
                {
                    var sValue = window.showModalDialog ("AsociaMulticredito_ZF.asp", "valor", "dialogWidth:30;dialogHeight:15;center:yes;edge:sunken;unadorned:yes;status:no;help:no;")
                }
                while(sValue == undefined);
                
                if ( sValue == "CANCELAR" || sValue == "ACEPTAR" )
                {
                    if ( sValue == "CANCELAR" )
                    {
                        obj.value = "EFI"
                    }
                    submitform();
                }
            }
            else
            {
                submitform2(obj.id, obj.selectedIndex, obj.value);
            }
        }
        else
        {
            submitform2(obj.id, obj.selectedIndex, obj.value);
        }
    } 

    function submitform()
    {
        if ( onsubmit == "Si" ) 
        {}
        else 
        {
            onsubmit = "Si";
            document.formulario.submit(); 
        }
    }

    function submitform2(objId, objSel, objVal)
    {
		//console.log( "objId: " + objId + "   objSel: " + objSel + "   objVal: " + objVal);
		
        if ( onsubmit == "Si" ) 
        {}
        else 
        {
			n = objId.substr( 21 );

			newCad = "";
			objCad = $("#objCad").val();
			nPos = objCad.indexOf("[" + n + ":");
			if (nPos >= 0) {
				arrayCad = objCad.split(";");
				for ( kk = 0; kk < arrayCad.length - 1; kk++ ) {
					if (arrayCad[kk] != arrayCad[n-1]) {
						newCad += arrayCad[kk] + ";";
					}
				}
				$("#objCad").val(newCad);
			}

			arrayVal = objVal.split(';');
			
			objCad = $("#objCad").val();
			if ( objCad == "" ) { objCad = "[" + n + ":" + objSel + ":" + arrayVal[2] + "];"; }
			else { objCad += "[" + n + ":" +objSel + ":" + arrayVal[2] + "];"; }

			$("#objId").val(objId);
			$("#objSel").val(objSel);
			$("#objVal").val(objVal);
			$("#objCad").val(objCad);
			$("#objObj").val(n);
			
            onsubmit = "Si";
            document.formulario.submit(); 
        }
    }

    <%if Imprimir_boleta then%>
        parent.Botones.location.href = "Imprime_boleta_PuntoVentaZF.asp?Accion=Imprimir&Boleta_actual=<%=session("Boleta_Actual")%>"
    <%elseif Imprimir_factura then%>
        parent.Botones.location.href = "Imprime_factura_PuntoVentaZF.asp?Accion=Imprimir"
    <%end if%>
    <%if Numero_documentos_cobro > 0 then%>
        document.formulario.Tipo_documento_cobro_1.focus();
    <%end if%>

    document.all.Accion.value = "";
    var ultimafila="";
    var ultimocolor="";
    function salidafila() {
    if ( ultimafila == "" ) {} else {
       ultimafila.bgcolor=ultimocolor;}
    }

    function cambio_imagen(fila,imagen)
    {
        salidafila();
        ultimafila=document.all[fila];
        ultimocolor=ultimafila.bgcolor;
        document.all[fila].bgcolor='#ffffcc';
        document.all.imagen.src=imagen;
    }

    function agrega_cheques()
    {
        document.all.Accion.value = "AgregaCheques";
        document.formulario.submit();
    }

    function modifica_descuento_linea(Linea)
    {
        document.all.Numero_documentos_cobro.value = "1";
        document.all.Accion.value = "Modificar";
        document.all.Linea.value = Linea;
        document.formulario.submit();
    }
    function modifica_precio_linea(Linea)
    {
        document.all.Numero_documentos_cobro.value = "1";
        document.all.Accion.value = "ModificarPrecio";
        document.all.Linea.value = Linea;
        document.formulario.submit();
    }
    function Descuentos()
    {
      //Se saco la condición que pida autorización supervisor sólo en L02-->Debe ser siempre (L01 y L02). Actualización: cmartinez 2013-10-11 14:30:00
      //if ( ('<%=Session("Login")%>' != '13884785' && '<%=Session("Login")%>' != '15308847' && '<%=Session("Login")%>' != '15309968' && '<%=Session("Login")%>' != '15711196' && '<%=Session("Login")%>' != '15923212' && '<%=Session("Login")%>' != '13859206' && '<%=Session("Login")%>' != '17629393' && '<%=Session("Login")%>' != '17587517' && '<%=Session("Login")%>' != '9926612') && '<%=Session("Muestra_descuentos")%>' == 'No')
      if ( ('<%=Session("Login")%>' != '13884785' && '<%=Session("Login")%>' != '15308847' && '<%=Session("Login")%>' != '15309968' && '<%=Session("Login")%>' != '15711196' && '<%=Session("Login")%>' != '15923212' && '<%=Session("Login")%>' != '13859206' && '<%=Session("Login")%>' != '17629393' && '<%=Session("Login")%>' != '17587517' && '<%=Session("Login")%>' != '9926612') && '<%=session("Convenio_base")%>' == 'L02' && '<%=Session("Muestra_descuentos")%>' == 'No')
      {
          var sValue = undefined;        
          do
          {
            var sValue = window.showModalDialog ("LoginSupervisor_PuntoVentaZF.asp", "valor", "dialogWidth:20;dialogHeight:20;center:yes;edge:sunken;unadorned:yes;status:no;help:no;")
          }
          while(sValue == undefined);
      }
      if ( sValue != 2 )
      {
        document.all.Accion.value = "Descuentos";
        document.formulario.submit();
      }
    }

    function Venta()
    {
        <%if Numero_documentos_cobro > 0 then%>
        document.formulario.Tipo_documento_cobro_1.focus();
        document.formulario.Tipo_documento_cobro_1.blur();
        <%end if%>
        window.location.href = 'Mant_PuntoVentaZF.asp'
        parent.Botones.location.href = "Botones_Mant_PuntoVentaZF.asp";
    }

function fObservaciones()
{
    var sValue = window.showModalDialog ("Observaciones_ZF.asp", "valor", "dialogWidth:30;dialogHeight:15;center:yes;edge:sunken;unadorned:yes;status:no;help:no;")
    //document.formulario.submit();
}

function AgregaDocumento()
{
document.all.Accion.value = "AgregaDocumentoCobro";
document.formulario.submit();
}
function EliminaDocumento()
{
document.all.Accion.value = "EliminaDocumentoCobro";
document.formulario.submit();
}

<%if not Imprimir_boleta and not Imprimir_factura and Accion_a_ejecutar <> "Terminar" then%>

function Terminar()
{
	Numero_documentos_cobro = parent.top.frames[1].document.getElementById("Numero_documentos_cobro").value;
	for ( kk = 1; kk < Numero_documentos_cobro - 0; kk++ ) {
		objId = "Tipo_documento_cobro_" + kk;
		parent.top.frames[1].document.getElementById(objId).setAttribute("disabled","");
	}

document.all.Accion.value = "Terminar";
document.formulario.submit();
}

	var blnDOM = false, blnIE4 = false, blnNN4 = false; 

	if (document.layers) blnNN4 = true;
	else if (document.all) blnIE4 = true;
	else if (document.getElementById) blnDOM = true;

	function getKeycode(e)
	{
		var TeclaPresionada = ""
		
		if (blnNN4)
		{
			var NN4key = e.which
			TeclaPresionada = NN4key;
		}
		if (blnDOM)
		{
			var blnkey = e.which
			TeclaPresionada = blnkey;
		}
		if (blnIE4)
		{
			var IE4key = event.keyCode
			TeclaPresionada = IE4key
		}

    if ( onsubmit == "No" ) 
    {
		if ( TeclaPresionada == 117 ) // F6 Agrega documento cobro
		{  
       onsubmit = "Si";
       AgregaDocumento();
		}
		if ( TeclaPresionada == 118 ) // F7 Eliminar documento cobro
		{    
      <%if cint(Numero_documentos_cobro) > 1 then%> 
        onsubmit = "Si";
        EliminaDocumento()
       <%end if%>
		}
		if ( TeclaPresionada == 120 ) // F7 Descuentos documento cobro
		{  
       onsubmit = "Si";
       Descuentos()
		}
		if ( TeclaPresionada == 13 ) // ENTER Termina e imprime
		{
       onsubmit = "Si";
		   Terminar();
		}
		if ( TeclaPresionada == 27 ) // F9 Termina e imprime
		{
       onsubmit = "Si";
		   Venta();
		}
		if ( TeclaPresionada == 119 ) // F8 Observaciones
		{
            //onsubmit = "Si";
		    fObservaciones();
		}
    document.all.tecla.value = TeclaPresionada;
    
    }
    
	}

	document.onkeydown = getKeycode;
	if (blnNN4) document.captureEvents(Event.KEYDOWN);

<%end if%>
  
function ventanitaerror()
{
var ventana = window.open('Ventanita_error_PuntoVentaZF.asp','error','height=200,width=500,scrollbars=no,location=no,directories=no,status=yes,menubar=no,toolbar=no,resizable=yes,title=no,dependent=yes');
}

function Valida_Descuento(e){
  //Sólo para IE
  regexp = /^\d{0,2}(\.)?\d{0,1}$/;
  if(!regexp.test(String.fromCharCode(e.keyCode)))
    return false;
  else
    return true;
}

function Valida_Digito(e){
  //Sólo para IE
  regexp = /\d/;
  if(!regexp.test(String.fromCharCode(e.keyCode)))
    return false;
  else
    return true;
}

function Valida_Caracteres_Fecha(e){
  //Sólo para IE (digitos y "/")
  regexp = /^[\d\/]+$/;
  if(!regexp.test(String.fromCharCode(e.keyCode)))
    return false;
  else
    return true;
}
</script>
