var $ = jQuery.noConflict();

$(document).scroll(function(){
    if($(this).scrollTop() > $( window ).height()) {   
        $('.sticky-sidebar').css({
        'padding-top': '0px',
		'position': 'fixed',
		'top': '10px',
		'width': '310px',
		'margin-top': '50px'});
    } else {
    	$('.sticky-sidebar').removeAttr('style');
    }
});