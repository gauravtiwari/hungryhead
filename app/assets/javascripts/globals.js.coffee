
jQuery(document).ready ->
	
	#Initialize AutoGrow plugin

	jQuery -> 
		$('body textarea').autosize()

	jQuery ->
		$('#form-register').validate();
		$('#form-login').validate();

	$.each flashMessages, (key, value) ->
	  $('body').pgNotification {style: "simple", message: value.toString(), position: "bottom-left", type: 'info', timeout: 5000}
	  	.show();

	$(window).scroll ->
		if Modernizr.mq 'only screen and (min-width: 991px)'
			$('.user-sidebar.sticky').css(position: "fixed", width: $('.user-sidebar.sticky').width())
		else
			$('.user-sidebar.sticky').css(position: "relative", width: "100%")

	return
