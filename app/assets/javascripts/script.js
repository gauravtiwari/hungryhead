var $ = jQuery.noConflict();


$(document).ready(function () {

	/*-------------------------------------------------*/
		/* =  Dropdown on click
	/*-------------------------------------------------*/

	$('li.drop > a, li.drop .profile-option-drop').on('click', function(e){
		e.preventDefault();
		var parentdrop = $(this).parent('li.drop').find('.dropdown');

		if ( !parentdrop.hasClass('active')) {
			$('.dropdown').removeClass('active');
			parentdrop.addClass('active');
		} else {
			parentdrop.removeClass('active');
		}
	});

	$('#container').on('click', function(e){
		$('.dropdown').removeClass('active');
		$('body').removeClass('stop-scrolling');
	});


	$('li.drop > a, .profile-option-drop').bind('click', function(e) {
	    e.stopPropagation();
	});

	var $container = $('#activity-container');
	// init
	$container.isotope({
	  // options
	  itemSelector: '.feed-box',
	  layoutMode: 'fitRows'
	});

	/*-------------------------------------------------*/
	/* =  zoom nav menu
	/*-------------------------------------------------*/

	 var render, select;

	  render = function(term, data, type) {
	    return term;
	  }

	  select = function(term, data, type){
	    $('#search').val(term);
	    $('ul#soulmate').hide();
	    return window.location.href = data.link
	  }

	  $('#search').soulmate({
	    url: '/search/search',
	    types: ['ideas','students', 'universities', 'categories'],
	    renderCallback : render,
	    selectCallback : select,
	    minQueryLength : 2,
	    maxResults     : 10
	  });

	// Selectize for select

    $('.market_list').tokenfield({
	    autocomplete: {
	    	minLength: 2,
		    source: Routes.autocomplete_market_name_markets_path(),
		    delay: 100
		  },
		showAutocompleteOnFocus: false,
		limit: 3
    });

    function split( val ) {
      return val.split( /,\s*/ );
    }
    function extractLast( term ) {
      return split( term ).pop();
    }

    $('.user_list').tokenfield({
	    autocomplete: {
	    	minLength: 2,
		    source: Routes.autocomplete_user_name_users_path(),
		    delay: 100,
		    select: function( event, ui ) {
	         var terms = split( $('#invitees').val() );
	          // remove the current input
	          terms.pop();
	          // add the selected item
	          terms.push( ui.item.id );
	          // add placeholder to get the comma-and-space at the end
	          terms.push( "" );
	          $('#invitees').val(terms.join( ", " ))
	          return false;
	        },
	        renderItem: function( ul, item ) {
		      return $( "<li>" )
		        .append( "<a>" + item.id + "<br>" + item.value + "</a>" )
		        .appendTo( ul );
		    },
		    response: function(event, ui) {
		        if (!ui.content.length) {
		            $("#no-message").text("No results found");
		        } else {
		            $("#no-message").empty();
		        }
		    }

		  },
		showAutocompleteOnFocus: false,
		limit: 5
    });

   $('.location_list').tokenfield({
	    autocomplete: {
	    	minLength: 2,
		    source: Routes.autocomplete_location_name_locations_path(),
		    delay: 100
		  },
		showAutocompleteOnFocus: false,
		limit: 1
    });

  	$('.subject_list').tokenfield({
	    autocomplete: {
	    	minLength: 2,
		    source: Routes.autocomplete_subject_name_subjects_path(),
		    delay: 100
		  },
		showAutocompleteOnFocus: false,
		limit: 1
    });

   $('.skill_list').tokenfield({
	    autocomplete: {
	    	minLength: 2,
		    source: Routes.autocomplete_skill_name_skills_path(),
		    delay: 100
		  },
		showAutocompleteOnFocus: false,
		limit: 3
    });

    $('.service_list').tokenfield({
	    autocomplete: {
	    	minLength: 2,
		    source: Routes.autocomplete_service_name_services_path(),
		    delay: 100
		  },
		showAutocompleteOnFocus: false,
		limit: 3
    });

    $('.tokenize-typehead').on('tokenfield:createtoken', function (event) {
	    var existingTokens = $(this).tokenfield('getTokens');
	    $.each(existingTokens, function(index, token) {
	        if (token.value === event.attrs.value)
	            event.preventDefault();
	    });
	});

  $(".chosen-select").chosen({disable_search_threshold: 10});

	/* Clear form */

	/* Smooth Scroll */

	// Trimming white space
	$('p').filter(function () { return $.trim(this.innerHTML) == "" }).remove();


  	var investment_remaining = $("#first-circle").data("investment");

  	$('#first-circle').circleProgress({
        value: investment_remaining,
        size: 120,
        fill: {
            gradient: ["#fff", "#fff"]
                   }
    }).on('circle-animation-progress', function(event, progress) {
	    $(this).find('strong').html(parseInt(100 * $(this).data("investment")) + '<i>%</i>');
	});

	var feedbacks_remaining = $("#second-circle").data("investment");

	$('#second-circle').circleProgress({
        value: feedbacks_remaining,
        size: 120,
        fill: {
            gradient: ["#fff", "#fff"]
                   }
    }).on('circle-animation-progress', function(event, progress) {
	    $(this).find('strong').html(parseInt(100 * $(this).data("investment")) + '<i>%</i>');
	});


	/* Scroll for leaderboard */

	$('.sidebar-feed-box').slimScroll({
		height: '300px'
	});

	$('.link-list').slimScroll({
		height: '300px'
	});

	$('.comment-tree-list').height($(window).height()-165);

	$('.message-box .messages').slimScroll({
		height: $(window).height()-220
	});

	$('.conversations-list').height($(window).height()-155);

   	$('[data-toggle="tooltip"]').tooltip();

  	$('[data-toggle="popover"]').popover();

  	$('#slider').height($(window).height());
  	
  /*-------------------------------------------------*/
	/* =  Masonry
	/*-------------------------------------------------*/

 	$.each(flashMessages, function(key, value){
	  $.snackbar({content: value, style: key, timeout: 10000});
	});

	/*-------------------------------------------------*/
	/* =  TextArea Autosize
	/*-------------------------------------------------*/
	try {
		$('body textarea').on('focus', function(){
	    	$(this).autosize();
		});
	} catch(e) {}


	/* ---------------------------------------------------------------------- */
	/*	edit-profile mode
	/* ---------------------------------------------------------------------- */
	try {
		$('.edit-profile').on('click', function(e){
			e.preventDefault();
				$('.inner-profile-content').fadeOut("fast", function(){
				$('.profile-header').addClass('edit-mode panel panel-default');
				$('.idea-header').addClass('edit-mode panel panel-default');
				$('.cover-wrap').addClass('hidden');
				$('#cover-edit-menu').addClass('hidden');
				$('.edit-profile-mode').fadeIn();
			});
		});

		$('.for-cancel').on('click', function(e){
			e.preventDefault();
			$('.edit-profile-mode').fadeOut("fast", function(){
				$('.profile-header').removeClass('edit-mode panel panel-default');
				$('.idea-header').removeClass('edit-mode panel panel-default');
				$('#cover-edit-menu').removeClass('hidden');
				$('.inner-profile-content').fadeIn();
				$('.cover-wrap').removeClass('hidden');
			});
		});

		$('.profile-wrapper').on('click', '.edit-wrapper', function(e){
			e.preventDefault();
			$(this).addClass('edit-mode-opened');
			$(this).html('Save <i class="fa fa-floppy-o"></i>');
			$('.display-mode-profile').fadeOut("slow", function(){
				$('.edit-mode-section').fadeIn();
			});
		});

		$('.about-me-forms').on('click', '.for-cancel', function(e){
			e.preventDefault();
			$(this).removeClass('edit-mode-opened');
			$('.edit-wrapper').html('Edit <i class="fa fa-pencil"></i>')

			$('.edit-mode-section').fadeOut("slow", function() {
				$('.display-mode-profile').fadeIn();
			});

		});

	} catch(e){

	}

	/*-------------------------------------------------*/
	/* =  multiple select and profile page
	/*-------------------------------------------------*/

	/*-------------------------------------------------*/
	/* = all code in idea page
	/*-------------------------------------------------*/

	$('a.back-project').on('click', function(e){
		e.preventDefault();
		if( !$('.pledge-information-popup').hasClass('active')) {
			$('.pledge-information-popup').addClass('active');
		}
		else {
			$('.pledge-information-popup').removeClass('active');
		}
	});

	$('a#continue-step2').on('click', function(e){
		e.preventDefault();
		$('.pledge-information-popup').removeClass('active');
		$('.card-information-popup').addClass('active');
	});

	$('a#pledge').on('click', function(e){
		e.preventDefault();
		$('.card-information-popup').removeClass('active');
	});

	$('a.add-section-sidebar').on('click', function(e){
		e.preventDefault();
		$(this).fadeOut();

		$('.new-section-idea-sidebar').slideDown();
	});

	$('a.cancel-form-sidebar').on('click', function(e){
		e.preventDefault();
		$('a.add-section-sidebar').fadeIn();

		$('.new-section-idea-sidebar').slideUp();
	});

	$('a.image-section-adding').on('click', function(e){
		e.preventDefault();

		$(this).parent('form').find('div').slideDown(200);
	});

	/*---------------------------------------------------
	/*= Modal Like
	/*--------------------------------------------------*/

	$('#myModal-like .like-badges li a').on('click', function(e) {
		e.preventDefault();
		var NumberOfActive = $('#myModal-like .like-badges li a.active').length,
			$this = $(this);

		if(!$this.hasClass('active')) {
			if(NumberOfActive < 3) {
				$this.addClass('active');
			}
		} else {
			$this.removeClass('active');
		}
	});

	/*-------------------------------------------------*/
	/* =  Faqs accordion
	/*-------------------------------------------------*/

	$('.accord-elem a').on('click', function(e){
		e.preventDefault();
		var elemSlide = $(this).parent('.accord-elem').find('.accord-content');

		if( !$(this).hasClass('active') ) {
			$(this).addClass('active');
			elemSlide.slideDown(200);
		} else {
			$(this).removeClass('active');
			elemSlide.slideUp(200);
		}
	});

	/*--------------------------------------------------*/
	/*= Filter form
	/*--------------------------------------------------*/

	$('#filter').on('click', function(e){
		e.preventDefault();
		$('.filter-content').toggle(200);
	});


});
