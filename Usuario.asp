<!--#include file="Scripts/Inc/Cache.Inc" -->
<%
  Cache
%> 
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Expires" content="0">
  <title>Ingreso al sistema</title>

  <!-- Bootstrap local -->
  <link href="CSS/bootstrap.min.css" rel="stylesheet">
  <script src="JS/bootstrap.bundle.min.js"></script> 

  <!-- Tu JS -->
  <script src="Scripts/Js/Caracteres.js"></script>
</head>
<body class="bg-light" style="background-image: url('<%=Session("ImagenFondo")%>'); background-size: cover; background-repeat: no-repeat; background-position: center center;">

  <div class="container min-vh-100 d-flex align-items-center justify-content-center">
    <div class="card shadow w-100" style="max-width: 500px;">
      <div class="card-header text-center fw-bold">
        <%=session("websystem")%>
      </div>
      <div class="card-body">
        <form name="Formulario" method="post" target="Paso">
          <div class="mb-3">
            <label for="Usuario" class="form-label">Usuario</label>
            <input type="text" name="Usuario" id="Usuario" maxlength="12" class="form-control" required>
          </div>
          <div class="mb-3">
            <label for="Clave" class="form-label">Clave de acceso</label>
            <input type="password" name="Clave" id="Clave" maxlength="12" class="form-control" required>
          </div>
          <div class="mb-3 text-center small">Si desea cambiar su clave, ingr&eacute;sela a continuaci&oacute;n:</div>
          <div class="mb-3 d-flex gap-2">
            <input type="password" name="Nva_Clave" maxlength="10" class="form-control" placeholder="Nueva clave">
            <input type="password" name="Reingreso_Nva_Clave" maxlength="10" class="form-control" placeholder="Reingreso">
          </div>
          <div class="d-grid">
            <button type="button" onclick="fIngresar()" class="btn btn-primary">Aceptar</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    function fCambiarClave() {
      var ClaveNueva = document.Formulario.Nva_Clave.value;
      var ReingresoClaveNueva = document.Formulario.Reingreso_Nva_Clave.value;

      if (ClaveNueva !== ReingresoClaveNueva) {
        alert('El reingreso de la clave no es consistente, por favor revise.');
        document.Formulario.Reingreso_Nva_Clave.focus();
        return;
      }

      document.Formulario.action = "CambioClave_Usuario.asp";
      document.Formulario.submit();
    }

    function fIngresar() {
      var ClaveNueva = document.Formulario.Nva_Clave.value.trim();
      var ReingresoClaveNueva = document.Formulario.Reingreso_Nva_Clave.value.trim();

      if (ClaveNueva !== "" || ReingresoClaveNueva !== "") {
        fCambiarClave();
      } else {
        document.Formulario.action = "Validacion_Usuario.asp";
        document.Formulario.submit();
      }
    }

    document.getElementById("Usuario").focus();
  </script>
</body>
</html>
