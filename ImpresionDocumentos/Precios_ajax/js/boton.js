$(document).ready(function() {
		$('#menu-jquery li a').hover(
		function() {
		$(this).css('padding', '5px 15px').animate({'paddingLeft':'25px','paddingRight':'25px','backgroundColor':'rgba(0,0,0,0.5)'},'fast');
		}, 
		function(){
		$(this).css('padding', '5px 25px')	
		.animate({'paddingLeft':'15px','paddingRight':'15px','backgroundColor' :'rgba(0,0,0,0.2)'},'fast');
		}).mousedown(function() {
		$(this).animate({'backgroundColor': 'rgba(0,0,0,0.1)'}, 'fast');
		}).mouseup(function() {
		$(this).animate({'backgroundColor': 'rgba(0,0,0,0.5)'}, 'fast');
		});				
		});