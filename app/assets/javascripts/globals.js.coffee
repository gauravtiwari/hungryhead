
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
			$('.sticky').css(position: "fixed", width: "17.85rem", height: "auto")
			$('.profile-sidebar.sticky').css(position: "fixed", width: "23.75rem", height: "auto")
		else
			$('.sticky').css(position: "relative", width: "100%")
			$('.profile-sidebar.sticky').css(position: "relative", width: "100%")

	if Modernizr.mq 'only screen and (max-width: 991px)'
		$('.col-md-3').each ->
			$(@).removeClass 'no-padding'

	$('.list-view-wrapper').scrollbar()
	
	$('[data-pages="search"]').search
	  searchField: '#overlay-search'
	  closeButton: '.overlay-close'
	  suggestions: '#overlay-suggestions'
	  brand: '.brand'
	  onSearchSubmit: (searchString) ->
	    console.log 'Search for: ' + searchString
	    return
	  onKeyEnter: (searchString) ->
	    console.log 'Live search for: ' + searchString
	    searchField = $('#overlay-search')
	    searchResults = $('.search-results')
	    clearTimeout $.data(this, 'timer')
	    searchResults.fadeOut 'fast'
	    wait = setTimeout((->
	      searchResults.find('.result-name').each ->
	        if searchField.val().length != 0
	          $(this).html searchField.val()
	          searchResults.fadeIn 'fast'
	        return
	      return
	    ), 500)
	    $(this).data 'timer', wait
	    return
	$('.panel-collapse label').on 'click', (e) ->
	  e.stopPropagation()
	  return


	return
