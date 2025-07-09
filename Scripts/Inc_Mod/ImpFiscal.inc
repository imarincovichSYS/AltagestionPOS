<script language="javascript">
function pausecomp(millis)
{
    date = new Date();
    var curDate = null;
    
    do { var curDate = new Date(); }
    while(curDate-date < millis);
}
</script>

<SCRIPT LANGUAGE="VBscript">

	     	Sub Delay(DelaySeconds)
			SecCount = 0
			Sec2 = 0
			While SecCount < DelaySeconds + 1
				Sec1 = Second(Time())
				If Sec1 <> Sec2 Then
					Sec2 = Second(Time())
					SecCount = SecCount + 1
				End If
			Wend
		End Sub

		Function Lectura(valor)
		    Dim bufferIF	    
	    
		    MSComm1.InputLen = MSComm1.InBufferCount
		    bufferIF = MSComm1.Input

		    If valor = 0 Then
		        If Len(Trim(bufferIF)) > 0 Then
		            If Mid(bufferIF, 1, 3) = "001" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Monto TOTAL DE TRANSACCION excedido                                            ": Exit Function
		            If Mid(bufferIF, 1, 3) = "002" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Monto TOTAL DE ÍTEM excedido                                                   ": Exit Function
		            If Mid(bufferIF, 1, 3) = "003" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Monto TOTAL DE ITEM no coincide                                                ": Exit Function
		            If Mid(bufferIF, 1, 3) = "004" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Monto TOTAL VENTAS DIARIAS excedido                                            ": Exit Function
		            If Mid(bufferIF, 1, 3) = "005" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Warning : Memoria Flash casi llena                                             ": Exit Function
		            If Mid(bufferIF, 1, 3) = "006" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Monto TOTAL DE TRANSACCIÓN cero o negativo                                     ": Exit Function
		            If Mid(bufferIF, 1, 3) = "007" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") TOTAL o SUBTOTAL de la transacción no coincide                                 ": Exit Function
		            If Mid(bufferIF, 1, 3) = "008" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Caracter no imprimible                                                         ": Exit Function
		            If Mid(bufferIF, 1, 3) = "009" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") El TOTAL de la Transacción no ha sido pagado                                   ": Exit Function
		            If Mid(bufferIF, 1, 3) = "010" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Memoria Flash llena                                                            ": Exit Function
		            If Mid(bufferIF, 1, 3) = "011" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Comando no Existe                                                                  ": Exit Function
		            If Mid(bufferIF, 1, 3) = "012" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Líneas de comentario excedidas                                                 ": Exit Function
		            If Mid(bufferIF, 1, 3) = "013" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Impresora no responde                                                              ": Exit Function
		            If Mid(bufferIF, 1, 3) = "014" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Error ocurrido al leer Memoria Flash Fiscal                                    ": Exit Function
		            If Mid(bufferIF, 1, 3) = "015" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Error ocurrido al escribir en la Memoria Flash Fiscal                              ": Exit Function
		            If Mid(bufferIF, 1, 3) = "016" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Informe(s) Z solicitado(s) no se encuentra(n) en Datos Fiscales                ": Exit Function
		            If Mid(bufferIF, 1, 3) = "017" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Campo numérico con caracteres no válidos                                       ": Exit Function
		            If Mid(bufferIF, 1, 3) = "018" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Largo del registro incorrecto                                                      ": Exit Function
		            If Mid(bufferIF, 1, 3) = "019" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Secuencia de comandos no válida                                                ": Exit Function
		            If Mid(bufferIF, 1, 3) = "020" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") No se encuentra ítem para anular                                               ": Exit Function
		            If Mid(bufferIF, 1, 3) = "021" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") No hay ítems para procesar comando                                             ": Exit Function
		            If Mid(bufferIF, 1, 3) = "022" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") No se ha ingresado recargo                                                     ": Exit Function
		            If Mid(bufferIF, 1, 3) = "023" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") No se ha ingresado descuento                                                   ": Exit Function
		            If Mid(bufferIF, 1, 3) = "024" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Número de caja no debe ser cero                                                ": Exit Function
		            If Mid(bufferIF, 1, 3) = "025" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Descuento mayor al 50%                                                         ": Exit Function
		            If Mid(bufferIF, 1, 3) = "026" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Día incorrecto                                                                 ": Exit Function
		            If Mid(bufferIF, 1, 3) = "027" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Mes incorrecto                                                                 ": Exit Function
		            If Mid(bufferIF, 1, 3) = "028" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Año incorrecto                                                                 ": Exit Function
		            If Mid(bufferIF, 1, 3) = "029" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Fecha u Hora es menor a la del último cierre                                   ": Exit Function
		            If Mid(bufferIF, 1, 3) = "030" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Hora incorrecta                                                                ": Exit Function
		            If Mid(bufferIF, 1, 3) = "031" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Minutos incorrectos                                                            ": Exit Function
		            If Mid(bufferIF, 1, 3) = "032" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Error al leer/escribir fecha hora desde el RTC                                 ": Exit Function
		            If Mid(bufferIF, 1, 3) = "033" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Valor fuera de rango permitido                                                 ": Exit Function
		            If Mid(bufferIF, 1, 3) = "034" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Ya se hizo Descuento                                                           ": Exit Function
		            If Mid(bufferIF, 1, 3) = "035" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Ya se hizo Recargo                                                             ": Exit Function
		            If Mid(bufferIF, 1, 3) = "036" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Monto forma de pago no coincide                                                ": Exit Function
		            If Mid(bufferIF, 1, 3) = "037" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Tipo de forma de pago no coincide                                                  ": Exit Function
		            If Mid(bufferIF, 1, 3) = "038" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Impresora sin Llaves cargadas                                                      ": Exit Function
		            If Mid(bufferIF, 1, 3) = "039" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Razón Social no válida                                                         ": Exit Function
		            If Mid(bufferIF, 1, 3) = "040" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Impresora no termina de imprimir                                               ": Exit Function
		            If Mid(bufferIF, 1, 3) = "041" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Comando no permitido sin jumper                                                ": Exit Function
		            If Mid(bufferIF, 1, 3) = "042" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Ya está en Modo Fiscal                                                         ": Exit Function
		            If Mid(bufferIF, 1, 3) = "043" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Falta Papel o la Tapa de Impresora está abierta                                ": Exit Function
		            If Mid(bufferIF, 1, 3) = "044" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Ya imprimió la línea de fecha-hora                                             ": Exit Function
		            If Mid(bufferIF, 1, 3) = "045" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") No hay power suficiente para procesar comando                                      ": Exit Function
		            If Mid(bufferIF, 1, 3) = "046" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Monto donación es mayor al vuelto                                                  ": Exit Function
		            If Mid(bufferIF, 1, 3) = "047" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") No se permite atrasar hora entre las 00:00 y las 00:59 hrs.                    ": Exit Function
		            If Mid(bufferIF, 1, 3) = "048" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") No se permite adelantar hora entre las 23:00 y las 23:59 hrs.                      ": Exit Function
		            If Mid(bufferIF, 1, 3) = "049" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Se permite sólo un Ajuste de Fecha Hora o de Reloj +/- 1 hora                      ": Exit Function
		            If Mid(bufferIF, 1, 3) = "050" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Rut no válido                                                                      ": Exit Function
		            If Mid(bufferIF, 1, 3) = "051" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Monto descuento/recargo no coincide                                            ": Exit Function
		            If Mid(bufferIF, 1, 3) = "052" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Indicador de PLD automático no habilitado                                          ": Exit Function
		            If Mid(bufferIF, 1, 3) = "054" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Máximo de líneas de artículo excedido                                              ": Exit Function
		            If Mid(bufferIF, 1, 3) = "055" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Error al borrar Memoria Flash de datos                                         ": Exit Function
		            If Mid(bufferIF, 1, 3) = "056" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Cambio de mercadería no habilitado                                             ": Exit Function
		            If Mid(bufferIF, 1, 3) = "058" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Comando no permitido en Modo Fiscal                                            ": Exit Function
		            If Mid(bufferIF, 1, 3) = "059" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Comando no puede hacerse en período de Venta                                   ": Exit Function
		            If Mid(bufferIF, 1, 3) = "060" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Comando no puede hacerse en período de No Venta                                ": Exit Function
		            If Mid(bufferIF, 1, 3) = "061" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Comando no aceptado dentro de la secuencia de boleta                           ": Exit Function
		            If Mid(bufferIF, 1, 3) = "062" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Fecha inicial mayor a Fecha final                                                  ": Exit Function
		            If Mid(bufferIF, 1, 3) = "063" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") No se puede hacer apertura de período de venta con jumper activo               ": Exit Function
		            If Mid(bufferIF, 1, 3) = "064" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Comando no permitido en  Modo Entrenamiento                                    ": Exit Function
		            If Mid(bufferIF, 1, 3) = "065" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") No se permite corrección de pago                                               ": Exit Function
		            If Mid(bufferIF, 1, 3) = "066" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") El almacenamiento intermedio no está vacío                                     ": Exit Function
		            If Mid(bufferIF, 1, 3) = "067" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Han transcurrido más de 26 horas de período de venta                           ": Exit Function
		            If Mid(bufferIF, 1, 3) = "068" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Warning : Han transcurrido más de 24 horas de período de venta                 ": Exit Function
		            If Mid(bufferIF, 1, 3) = "069" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Monto TOTAL FORMA DE PAGO DIARIA excedido                                          ": Exit Function
		            If Mid(bufferIF, 1, 3) = "071" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Monto TOTAL DONACIONES excedido                                                ": Exit Function
		            If Mid(bufferIF, 1, 3) = "076" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Error Grave. Data corrupta                                                     ": Exit Function
		            If Mid(bufferIF, 1, 3) = "077" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Error Grave. Overflow en TOTAL ACUMULADO                                       ": Exit Function
		            If Mid(bufferIF, 1, 3) = "078" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Máximo número de boletas diarias excedido                                          ": Exit Function
		            If Mid(bufferIF, 1, 3) = "079" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Sumatoria de formas de pago de la transacción excedida                         ": Exit Function
		            If Mid(bufferIF, 1, 3) = "080" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Error de impresión. Se espera comando repetir                                      ": Exit Function
		            If Mid(bufferIF, 1, 3) = "081" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Password incorrecta                                                            ": Exit Function
		            If Mid(bufferIF, 1, 3) = "082" Then Lectura = "(" & Mid(bufferIF, 1, 3) & ") Error de impresión. Se espera comando repetir                                      ": Exit Function 
		        End If
		        If Len(Trim(bufferIF)) = 0 Then Lectura = "La impresora no responde."
		    Else
		        Lectura = bufferIF
		    End If

		End Function

    Function Lecturam(segundos)
        Inicio = timer() 
		    Lecturam = ""
        readIF = ""
        Leido = false

        do while timer() - Inicio < segundos and Inicio <= timer()
           if MSComm1.InBufferCount > 0 then
              MSComm1.InputLen = MSComm1.InBufferCount
              readIF = MSComm1.Input
              if readIF = chr(10) then
                 'lecturam = lecturam & "chr(10)"
                 leido = true
                 exit do
              else
                 Lecturam = Lecturam & readIF
                 if instr(Lecturam,chr(13)) then
                    'lecturam = lecturam & "chr(13)"
                    leido = true
                    exit do
                 end if
              end if
           end if
        loop
        
		        If Len(Trim(lecturam)) > 0 Then
		            If Mid(lecturam, 1, 3) = "001" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Monto TOTAL DE TRANSACCION excedido                                            ": Exit Function
		            If Mid(lecturam, 1, 3) = "002" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Monto TOTAL DE ÍTEM excedido                                                   ": Exit Function
		            If Mid(lecturam, 1, 3) = "003" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Monto TOTAL DE ITEM no coincide                                                ": Exit Function
		            If Mid(lecturam, 1, 3) = "004" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Monto TOTAL VENTAS DIARIAS excedido                                            ": Exit Function
		            If Mid(lecturam, 1, 3) = "005" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Warning : Memoria Flash casi llena                                             ": Exit Function
		            If Mid(lecturam, 1, 3) = "006" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Monto TOTAL DE TRANSACCIÓN cero o negativo                                     ": Exit Function
		            If Mid(lecturam, 1, 3) = "007" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") TOTAL o SUBTOTAL de la transacción no coincide                                 ": Exit Function
		            If Mid(lecturam, 1, 3) = "008" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Caracter no imprimible                                                         ": Exit Function
		            If Mid(lecturam, 1, 3) = "009" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") El TOTAL de la Transacción no ha sido pagado                                   ": Exit Function
		            If Mid(lecturam, 1, 3) = "010" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Memoria Flash llena                                                            ": Exit Function
		            If Mid(lecturam, 1, 3) = "011" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Comando no Existe                                                              ": Exit Function
		            If Mid(lecturam, 1, 3) = "012" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Líneas de comentario excedidas                                                 ": Exit Function
		            If Mid(lecturam, 1, 3) = "013" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Impresora no responde                                                          ": Exit Function
		            If Mid(lecturam, 1, 3) = "014" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Error ocurrido al leer Memoria Flash Fiscal                                    ": Exit Function
		            If Mid(lecturam, 1, 3) = "015" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Error ocurrido al escribir en la Memoria Flash Fiscal                          ": Exit Function
		            If Mid(lecturam, 1, 3) = "016" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Informe(s) Z solicitado(s) no se encuentra(n) en Datos Fiscales                ": Exit Function
		            If Mid(lecturam, 1, 3) = "017" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Campo numérico con caracteres no válidos                                       ": Exit Function
		            If Mid(lecturam, 1, 3) = "018" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Largo del registro incorrecto                                                  ": Exit Function
		            If Mid(lecturam, 1, 3) = "019" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Secuencia de comandos no válida Pulse Aceptar para continuar !                 ": Exit Function
		            If Mid(lecturam, 1, 3) = "020" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") No se encuentra ítem para anular                                               ": Exit Function
		            If Mid(lecturam, 1, 3) = "021" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") No hay ítems para procesar comando                                             ": Exit Function
		            If Mid(lecturam, 1, 3) = "022" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") No se ha ingresado recargo                                                     ": Exit Function
		            If Mid(lecturam, 1, 3) = "023" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") No se ha ingresado descuento                                                   ": Exit Function
		            If Mid(lecturam, 1, 3) = "024" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Número de caja no debe ser cero                                                ": Exit Function
		            If Mid(lecturam, 1, 3) = "025" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Descuento mayor al 50%                                                         ": Exit Function
		            If Mid(lecturam, 1, 3) = "026" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Día incorrecto                                                                 ": Exit Function
		            If Mid(lecturam, 1, 3) = "027" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Mes incorrecto                                                                 ": Exit Function
		            If Mid(lecturam, 1, 3) = "028" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Año incorrecto                                                                 ": Exit Function
		            If Mid(lecturam, 1, 3) = "029" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Fecha u Hora es menor a la del último cierre                                   ": Exit Function
		            If Mid(lecturam, 1, 3) = "030" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Hora incorrecta                                                                ": Exit Function
		            If Mid(lecturam, 1, 3) = "031" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Minutos incorrectos                                                            ": Exit Function
		            If Mid(lecturam, 1, 3) = "032" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Error al leer/escribir fecha hora desde el RTC                                 ": Exit Function
		            If Mid(lecturam, 1, 3) = "033" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Valor fuera de rango permitido                                                 ": Exit Function
		            If Mid(lecturam, 1, 3) = "034" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Ya se hizo Descuento                                                           ": Exit Function
		            If Mid(lecturam, 1, 3) = "035" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Ya se hizo Recargo                                                             ": Exit Function
		            If Mid(lecturam, 1, 3) = "036" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Monto forma de pago no coincide                                                ": Exit Function
		            If Mid(lecturam, 1, 3) = "037" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Tipo de forma de pago no coincide                                              ": Exit Function
		            If Mid(lecturam, 1, 3) = "038" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Impresora sin Llaves cargadas                                                  ": Exit Function
		            If Mid(lecturam, 1, 3) = "039" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Razón Social no válida                                                         ": Exit Function
		            If Mid(lecturam, 1, 3) = "040" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Impresora no termina de imprimir                                               ": Exit Function
		            If Mid(lecturam, 1, 3) = "041" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Comando no permitido sin jumper                                                ": Exit Function
		            If Mid(lecturam, 1, 3) = "042" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Ya está en Modo Fiscal                                                         ": Exit Function
		            If Mid(lecturam, 1, 3) = "043" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Falta Papel o la Tapa de Impresora está abierta                                ": Exit Function
		            If Mid(lecturam, 1, 3) = "044" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Ya imprimió la línea de fecha-hora                                             ": Exit Function
		            If Mid(lecturam, 1, 3) = "045" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") No hay power suficiente para procesar comando                                  ": Exit Function
		            If Mid(lecturam, 1, 3) = "046" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Monto donación es mayor al vuelto                                              ": Exit Function
		            If Mid(lecturam, 1, 3) = "047" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") No se permite atrasar hora entre las 00:00 y las 00:59 hrs.                    ": Exit Function
		            If Mid(lecturam, 1, 3) = "048" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") No se permite adelantar hora entre las 23:00 y las 23:59 hrs.                  ": Exit Function
		            If Mid(lecturam, 1, 3) = "049" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Se permite sólo un Ajuste de Fecha Hora o de Reloj +/- 1 hora                  ": Exit Function
		            If Mid(lecturam, 1, 3) = "050" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Rut no válido                                                                  ": Exit Function
		            If Mid(lecturam, 1, 3) = "051" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Monto descuento/recargo no coincide                                            ": Exit Function
		            If Mid(lecturam, 1, 3) = "052" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Indicador de PLD automático no habilitado                                          ": Exit Function
		            If Mid(lecturam, 1, 3) = "054" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Máximo de líneas de artículo excedido                                              ": Exit Function
		            If Mid(lecturam, 1, 3) = "055" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Error al borrar Memoria Flash de datos                                         ": Exit Function
		            If Mid(lecturam, 1, 3) = "056" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Cambio de mercadería no habilitado                                             ": Exit Function
		            If Mid(lecturam, 1, 3) = "058" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Comando no permitido en Modo Fiscal                                            ": Exit Function
		            If Mid(lecturam, 1, 3) = "059" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Comando no puede hacerse en período de Venta                                   ": Exit Function
		            If Mid(lecturam, 1, 3) = "060" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Comando no puede hacerse en período de No Venta                                ": Exit Function
		            If Mid(lecturam, 1, 3) = "061" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Comando no aceptado dentro de la secuencia de boleta                           ": Exit Function
		            If Mid(lecturam, 1, 3) = "062" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Fecha inicial mayor a Fecha final                                                  ": Exit Function
		            If Mid(lecturam, 1, 3) = "063" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") No se puede hacer apertura de período de venta con jumper activo               ": Exit Function
		            If Mid(lecturam, 1, 3) = "064" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Comando no permitido en  Modo Entrenamiento                                    ": Exit Function
		            If Mid(lecturam, 1, 3) = "065" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") No se permite corrección de pago                                               ": Exit Function
		            If Mid(lecturam, 1, 3) = "066" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") El almacenamiento intermedio no está vacío                                     ": Exit Function
		            If Mid(lecturam, 1, 3) = "067" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Han transcurrido más de 26 horas de período de venta                           ": Exit Function
		            If Mid(lecturam, 1, 3) = "068" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Warning : Han transcurrido más de 24 horas de período de venta                 ": Exit Function
		            If Mid(lecturam, 1, 3) = "069" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Monto TOTAL FORMA DE PAGO DIARIA excedido                                          ": Exit Function
		            If Mid(lecturam, 1, 3) = "071" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Monto TOTAL DONACIONES excedido                                                ": Exit Function
		            If Mid(lecturam, 1, 3) = "076" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Error Grave. Data corrupta                                                     ": Exit Function
		            If Mid(lecturam, 1, 3) = "077" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Error Grave. Overflow en TOTAL ACUMULADO                                       ": Exit Function
		            If Mid(lecturam, 1, 3) = "078" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Máximo número de boletas diarias excedido                                          ": Exit Function
		            If Mid(lecturam, 1, 3) = "079" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Sumatoria de formas de pago de la transacción excedida                         ": Exit Function
		            If Mid(lecturam, 1, 3) = "080" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Error de impresión. Se espera comando repetir                                      ": Exit Function
		            If Mid(lecturam, 1, 3) = "081" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Password incorrecta                                                            ": Exit Function
		            If Mid(lecturam, 1, 3) = "082" Then lecturam = "(" & Mid(lecturam, 1, 3) & ") Error de impresión. Se espera comando repetir                                      ": Exit Function 
		        End If
            If not leido Then Lecturam = "La impresora no responde."

    End Function

</script>
