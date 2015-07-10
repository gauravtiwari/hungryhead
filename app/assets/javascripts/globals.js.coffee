
jQuery(document).ready ->

	#Initialize AutoGrow plugin

	$('body textarea').focus ->
		$(this).autosize()

	$.ajaxSetup cache: false

	$(document).on 'click', '.pagination a[data-remote=true]', (e) ->
	  history.pushState {}, '', $(this).attr('href')
	  return
	$(window).on 'popstate', ->
	  $.getScript document.location.href
	  return

	$.validator.addMethod 'lettersonly', ((value, element) ->
	  @optional(element) or /^[a-z@-_-]+$/i.test(value)
	), 'Letters only please'

	$.validator.addMethod 'phoneUK', ((phone_number, element) ->
	  @optional(element) or phone_number.length > 9 and phone_number.match(/^(((\+44)? ?(\(0\))? ?)|(0))( ?[0-9]{3,4}){3}$/)
	), 'Please specify a valid phone number'

	$('#form-register').validate()

	try
		$('#formUsername').rules 'add', minlength: 3
		$('#formUsername').rules 'add', lettersonly: true
		$('#formPassword').rules 'add', minlength: 6
	catch e

	#Create infinite list view for activities container
	$activity_box_el = $('#main_activity_box')
	window.activityListView = new infinity.ListView($activity_box_el)

	NProgress.configure
	  showSpinner: true
	  ease: 'ease'
	  speed: 500

	$('#form-login').validate();
	$('.site-feedback-form').validate();
	$('#new_invite_request').validate();
	$('#information-form').validate();
	$('#feedback_form').validate();
	$('#edit-profile').validate();
	$('#pitch_idea_form').validate();
	$('#editProfileFormPopup').validate();
	$('#valid-form').validate();

	try
		$('#idea_high_concept_pitch').rules 'add', minlength: 20, maxlength: 50
		$('#idea_elevator_pitch').rules 'add', minlength: 100, maxlength: 140
	catch e

	$("[data-toggle='tooltip']").tooltip()

	#Initialize Pages modules

	$.Pages.init()

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

	$(window).scroll ->
		if Modernizr.mq 'only screen and (min-width: 991px)'
			$('.sticky').css(position: "fixed", width: "16.90rem", height: "auto")
			$('.profile-sidebar.sticky').css(position: "fixed", width: "22.80rem", height: "auto")
			$('.idea-sidebar.sticky').css(position: "fixed", width: "21.90rem", height: "auto")
		else
			$('.sticky').css(position: "relative", width: "100%")
			$('.profile-sidebar.sticky').css(position: "relative", width: "100%")

	if Modernizr.mq 'only screen and (max-width: 991px)'
		$('.col-md-3').each ->
			$(@).removeClass 'no-padding'

	$('.panel-collapse label').on 'click', (e) ->
	  e.stopPropagation()
	  return


	return
