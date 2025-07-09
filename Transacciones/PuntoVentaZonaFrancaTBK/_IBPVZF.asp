<!-- #include file="../../Scripts/Inc/ImpFiscal.Inc" -->
<!-- #include file="../../Scripts/Inc/Numerica.Inc" -->
<%
Function PadR(Texto,Posiciones)
   PadR = Left( Texto & Space(500) , Posiciones)
   PadR = Left( Texto & "_" , Posiciones)
End Function
  
Function PadL(Texto,Posiciones)
   PadL = Right( Space(500) & Texto , Posiciones)
   PadL = Right( "_" & Texto , Posiciones)
End Function

Function StrZero(Numero,Posiciones)
   StrZero = Right( "0000000000000000000000000000" & Numero , Posiciones)
End Function

set conn = server.createobject("ADODB.Connection")
conn.open "DSN=AG_Sanchez;UID=AG_Sanchez;PWD=adsentel;APP=;WSID=;DATABASE=Sanchez"
Conn.CommandTimeout = 3600

   Numero_despacho_de_venta = 0
   Set rs = Conn.execute("Exec MOP_Lista_detalle_DVT_impresion_factura 'altanet'" )

      Numero_despacho_de_venta = rs("Numero_documento_no_valorizado")
      Producto = PadR(rs("Producto"),13)
      Descripcion = Left( rs("Nombre_para_boleta") , 20 )
      if len(trim(Descripcion)) = 0 then
         Descripcion = Left( rs("Nombre_producto") , 20 )
      end if
      Descripcion = replace( Descripcion , chr(34) , "" )
      Cantidad    = clng(rs("Cantidad_salida"))
      Decimales = "000"

      PrecioNeto = cdbl( "0" & rs("Precio_final_con_descuentos_impreso") )

			PrecioConIva = PrecioNeto
			PrecioUnit   = StrZero(PrecioNeto,9)

      SubTotalNeto = PrecioConIva * Cantidad
      TotalNeto    = StrZero(SubTotalNeto,9)
      Cantidad     = StrZero(Cantidad,6)

      Porcentaje_impuesto_1 = cdbl( rs("Porcentaje_impuesto_1") )
      if cDbl( Porcentaje_impuesto_1 ) >  0 then
			if cDbl( porcentajeILA_1 ) =  0 then
				porcentajeILA_1 = Porcentaje_impuesto_1
			end if
			if cDbl( porcentajeILA_2 ) =  0 then
				if cDbl( Porcentaje_impuesto_1 ) <> cDbl( porcentajeILA_1 ) then
					porcentajeILA_2 = Porcentaje_impuesto_1
				end if
			end if
      end if

      Total = Total + SubTotalNeto

      Marca = PadR(rs("Marca"),12)
      SuperFamilia = PadR(rs("Rubro"),2)
      Familia = PadR(rs("Familia"),2)
      Subfamilia = PadR(rs("Subfamilia"),3)
      Genero = PadR(rs("Genero"),1)

      Producto_alfanumerico = PadR(rs("Producto"),7)
      Producto_numerico = PadR(rs("Producto_numerico"),9)

      Response.write( "Producto: " & Producto & "<br>" )
      Response.write( "Cantidad: " & Cantidad & "<br>" )
      Response.write( "Decimales: " & Decimales & "<br>" )
      Response.write( "PrecioUnit: " & PrecioUnit & "<br>" )
      Response.write( "TotalNeto: " & TotalNeto & "<br>" )

      Response.write( "Marca: " & Marca & "<br>" )
      Response.write( "SuperFamilia: " & SuperFamilia & "<br>" )
      Response.write( "Familia: " & Familia & "<br>" )
      Response.write( "Subfamilia: " & Subfamilia & "<br>" )
      Response.write( "Genero: " & Genero & "<br>" )

      Response.write( "Producto_alfanumerico: " & Producto_alfanumerico & "<br>" )
      Response.write( "Producto_numerico: " & Producto_numerico & "<br>" )

      Response.write( "Descripcion: " & left( Descripcion , 90 ) & "<br>" )
      Response.write( "<br>" )

			Detalle	= Detalle & ( "13111" & Producto & Cantidad & Decimales & PrecioUnit & TotalNeto & Marca & " " & SuperFamilia & Familia & Subfamilia & " " & Genero & Producto_alfanumerico & " " & Producto_numerico & " " & left( Descripcion, 20 ) & "|¬|")
            if trim(mid(Producto,1,1))="K" then
                es_mueble = "S"
            end if
            if trim(mid(Producto,1,5))="KCTDB" then
                es_cabina = "S"
            end if        

    Response.write( Detalle )

   rs.close
   set rs = nothing
   conn.close
%>
