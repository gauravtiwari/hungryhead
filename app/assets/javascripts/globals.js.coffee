
jQuery(document).ready ->

	#Initialize AutoGrow plugin

	$('body textarea').autosize()

	$('#form-register').validate();
	$('#form-login').validate();

	$.each flashMessages, (key, value) ->
	  $('body').pgNotification {style: "simple", message: value.toString(), position: "bottom-left", type: 'info', timeout: 5000}
	  	.show();
	$('[data-provider="summernote"]').each ->
		$(this).summernote 
			tabsize: 2
			focus: true
			toolbar: [
			  [
			    'style'
			    [
			      'bold'
			      'italic'
			      'underline'
			    ]
			  ]
			  [
			    'para'
			    [
			      'ul'
			      'ol'
			    ]
			  ]
			  [
			  	'insert'
			  	[
			  		'video'
			  		'picture'
			  		'link'
			  	]
			  ]
			]


	$(window).scroll ->
		if Modernizr.mq 'only screen and (min-width: 991px)'
			$('.sticky').css(position: "fixed", width: "17.85rem", height: "auto")
			$('.profile-sidebar.sticky').css(position: "fixed", width: "23.75rem", height: "auto")
		else
			$('.sticky').css(position: "relative", width: "100%")
			$('.profile-sidebar.sticky').css(position: "relative", width: "100%")

	if Modernizr.mq 'only screen and (max-width: 991px)'
		$('.col-md-3').each ->
			$(@).removeClass 'no-padding'

	$('.list-view-wrapper').scrollbar()
	

	$('.panel-collapse label').on 'click', (e) ->
	  e.stopPropagation()
	  return


	return
