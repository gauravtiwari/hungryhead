
jQuery(document).ready ->

	#Initialize AutoGrow plugin

	$('body textarea').focus ->
		$(this).autosize()

	$('#form-register').validate();
	$('#form-login').validate();
	$('#information-form').validate();
	$('#feedback_form').validate();
	$('#edit-profile').validate();
	$('#pitch_idea_form').validate();
	$("[data-toggle='tooltip']").tooltip()

	$.each flashMessages, (key, value) ->
	  $('body').pgNotification {style: "simple", message: value.toString(), position: "bottom-left", type: 'warning', timeout: 5000}
	  	.show();

	$('.scrollable').slimScroll height: '200px'

	$('.follow-scrollable').slimScroll height: '350px'

	$('.single-tag').tagsinput maxTags: 1
	$('.three-tags').tagsinput maxTags: 3

	$('#edit-profile').on 'click', (e) ->
		e.preventDefault()
		$(@).closest('.profile-card').hide()
		$('.edit-profile').show()

	$('#cancel-edit-profile').on 'click', (e) ->
		e.preventDefault()
		$('.profile-card').show()
		$(@).closest('.edit-profile').hide()

	#$('.chat-inner').slimScroll height: $(window).height() - 103

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
