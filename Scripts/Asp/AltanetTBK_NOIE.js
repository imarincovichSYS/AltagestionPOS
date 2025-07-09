function jsTBKTransaccion(Transaccion, callback, withLoading) {
	if (Transaccion.TBK.Ejecutar_Pago_Transbak === 1) {
		if (("WebSocket" in window && window.WebSocket != undefined) || ("MozWebSocket" in window)) {
			(() => {
				return new Promise((resolve, reject) => {
					var server = new WebSocket('ws://localhost:40443/Servicios');
						server.onopen = () => { resolve(server) };
						server.onerror = (err) => { reject(err) };
				});
			})().then(server => {
				server.onmessage = e => {
					responseResult(JSON.parse(e.data), callback);
				}
				(async () => {
					// showLoading(withLoading);
					await server.send(JSON.stringify(Transaccion.TBK));
				})();
			}).catch(err => {
				errorResult("Error de conectividad, contactar Altanet.", callback);
			});
		}
		else {
			errorResult("Navegador no soportado, contactar Altanet.", callback);
		}
	}
	else {
		errorResult("Transaccion(error) -> " + Transaccion.TBK.Mensaje, callback);
	}
}