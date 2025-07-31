<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>AltaGestion</title>
    <style>
        html, body {
            margin: 0;
            height: 100%;
            font-family: sans-serif;
        }
        .layout {
            display: grid;
            grid-template-rows: 10% 1fr 5% 5%;
            height: 100vh;
        }
        iframe {
            width: 100%;
            border: none;
        }
    </style>
</head>
<body>
    <div class="layout">
        <iframe src="navigation.asp?Usuario=Hoteleria" name="Menu" scrolling="no"></iframe>
        <iframe src="Empty.asp" name="Trabajo" scrolling="auto"></iframe>
        <iframe src="Empty.asp" name="Botones" scrolling="no"></iframe>
        <iframe src="Mensajes.asp" name="Mensajes" scrolling="no"></iframe>
    </div>

    <noscript>
        <p>Su navegador no soporta JavaScript o está desactivado. <a href='Index.htm'>Inicio</a></p>
    </noscript>
</body>
</html>
