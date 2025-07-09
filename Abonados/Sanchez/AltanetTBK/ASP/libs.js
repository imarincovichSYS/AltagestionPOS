/*
function showLoading(isTrue) {
	if (isTrue) {
        if (!window.top.document.getElementById("TBKInProcess"))
            window.top.$('body').append("<div id=\"TBKInProcess\" style=\"position:absolute;border: outset;\"><table border=\"0\" cellpadding=\"2\" cellspacing=\"2\" bgcolor=\"#FFFFFF\"><tr><th width=\"16\"><img src=\"../../Imagenes/loader.gif\" width=\"16\" height=\"16\" /></th><th width=\"168\" align=\"left\" nowrap=\"nowrap\" class=\"FuenteInput\">Procesando, favor espere...</th></tr></table></div>");
        $('#TBKInProcess').css({ top: '50%', left: '50%', margin: '-' + ($('#TBKInProcess').height() / 2) + 'px 0 0 -' + ($('#TBKInProcess').width() / 2) + 'px' });
        $('#TBKInProcess').show();
    }
    else {
        $('#TBKInProcess').hide().remove();
    }
}
*/
function responseResult(result, callback) {
    // showLoading(false);
    if (result.StatusIsOK) {
        callback(null, {
            "StatusIsOK": result.StatusIsOK,
            "Mensaje": "Proceso OK",
            "DataResponse": result.DatosResponse
        });
    }
    else {
        errorResult(result.Mensaje, callback)
    }
}

function errorResult(info, callback) {
    // showLoading(false);
    callback({
        "StatusIsOK": false,
        "Mensaje": info,
        "DataResponse": null
    });
}