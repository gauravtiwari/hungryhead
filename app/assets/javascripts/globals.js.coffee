
jQuery(document).ready ->

	#Initialize AutoGrow plugin

	$('body textarea').focus ->
		$(this).autosize()

	$('#form-register').validate();
	$('#form-login').validate();
	$('#information-form').validate();
	$("[data-toggle='tooltip']").tooltip()

	$.each flashMessages, (key, value) ->
	  $('body').pgNotification {style: "simple", message: value.toString(), position: "bottom-left", type: 'warning', timeout: 5000}
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
			      'paragraph'
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

	$('.scrollable').slimScroll height: '300px'

	$(window).scroll ->
		if Modernizr.mq 'only screen and (min-width: 991px)'
			$('.sticky').css(position: "fixed", width: "16.90rem", height: "auto")
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
