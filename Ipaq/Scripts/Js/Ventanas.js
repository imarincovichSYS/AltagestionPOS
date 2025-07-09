function maximizeWin()
{
  if (window.screen)
  {
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
