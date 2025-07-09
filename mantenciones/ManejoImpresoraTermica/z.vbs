Dim fso, archivo, rutaArchivo, texto, fechaHoy

' Obtiene la fecha de hoy en formato yyyyMMdd
fechaHoy = Year(Now) & Right("00" & Month(Now), 2) & Right("00" & Day(Now), 2)

' Define la ruta del archivo con el nombre basado en la fecha
rutaArchivo = "C:\z\" & fechaHoy & ".txt" 'Asegúrate de que la ruta sea válida

' El contenido que deseas escribir
texto = "Este es un nuevo registro para el "

Set fso = CreateObject("Scripting.FileSystemObject")

' Si el archivo ya existe, lo abre en modo de agregar texto, sino lo crea
If fso.FileExists(rutaArchivo) Then
    Set archivo = fso.OpenTextFile(rutaArchivo, 8) ' 8 es el modo de agregar (Append)
Else
    Set archivo = fso.CreateTextFile(rutaArchivo, True) ' Crea el archivo si no existe
End If

' Escribe el texto en el archivo
archivo.WriteLine(texto)

' Cierra el archivo
archivo.Close

' Limpieza
Set archivo = Nothing
Set fso = Nothing