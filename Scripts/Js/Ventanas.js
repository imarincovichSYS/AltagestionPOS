function maximizeWin()
{
  if (window.screen)
  {
    window.resizeTo(0,0);
    var aw = screen.availWidth;
    var ah = screen.availHeight;
       window.moveTo(0, 0);
       window.resizeTo(aw, ah);
  }
}

function fScreenSizeY()
{
	var avTop = parseInt(screen.width);
	return avTop;
}

function fScreenSizeX()
{
	var avLeft = parseInt(screen.height);
	return avLeft;
}

function popupnr(mylink, windowname, refocus, wndFeatures)
{
	var mywin, href;
	if (typeof(mylink) == 'string')
		href=mylink;
	else
		href=mylink.href;
		mywin = window.open('', windowname, wndFeatures);

// if we just opened the window
	if ( mywin.closed || (! mywin.document.URL) || (mywin.document.URL.indexOf("about") == 0) )
		mywin.location=href;
	else if (refocus)
		mywin.focus();
		
	return false;
}

function Closepopupnr(mylink, windowname, refocus, wndFeatures)
{
	var mywin, href;
	if (typeof(mylink) == 'string')
		href=mylink;
	else
		href=mylink.href;
		mywin = window.open('', windowname, wndFeatures);

// if we just opened the window
	if ( mywin.closed || (! mywin.document.URL) || (mywin.document.URL.indexOf("about") == 0) )
	{
		mywin.location=href;
	}
	else if (refocus)
	{	
		mywin.focus();
	}
			
	mywin.close();
	
	return false;
}


//Obtiene el ancho y alto del browser o ventana abierta.
        function GetWH()
        {
            if (document.all)
            {
                cW=document.body.offsetWidth
                cH=document.body.offsetHeight
                window.resizeTo(500,500)
                barsW=500-document.body.offsetWidth
                barsH=500-document.body.offsetHeight
                wW=barsW+cW
                wH=barsH+cH
                window.resizeTo(wW,wH)
            }
            else
            {
                wW=window.outerWidth
                wH=window.outerHeight
            }
            return wW + ','+wH
        }
