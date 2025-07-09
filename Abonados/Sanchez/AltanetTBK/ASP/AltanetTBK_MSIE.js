function jsTBKTransaccion(Transaccion, callback, withLoading) {
	(function ($) {
		if (Transaccion.TBK.Ejecutar_Pago_Transbak === 1) {
			$.support.cors = true;
			$.ajax({
				type: "post",
				url: "http://localhost:40443/api/tbk/Servicios?_=" + Date.now(),
				crossDomain: true,
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				async: false,
				headers: {
					'Accept': 'application/json',
					'Content-Type': 'application/json'
				},
				beforeSend: function () {/** showLoading(withLoading); */},
				data: JSON.stringify(Transaccion.TBK),
				success: function (j) {
					responseResult(JSON.parse(j), callback);
				},
				error: function (xhr) {
					errorResult("AJAX(error) -> " + xhr.status + "/" + xhr.statusText, callback);
				}
			});
		}
		else {
			errorResult("Transaccion(error) -> " + Transaccion.TBK.Mensaje, callback);
		}
	})(jQuery);
}