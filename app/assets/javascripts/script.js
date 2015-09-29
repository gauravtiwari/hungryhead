var $ = jQuery.noConflict();

// TODO: Old code to be converted

$(document).ready(function () {

	 var render, select;

	  render = function(term, data, type) {
	    return term;
	  }

	  select = function(term, data, type){
	    $('#overlay-search').val(term);
	    $('ul#soulmate').hide();
	    return window.location.href = data.link
	  }

	  $('#search').soulmate({
	    url: '/search/search',
	    types: ['ideas','people', 'schools'],
	    renderCallback : render,
	    selectCallback : select,
	    minQueryLength : 2,
	    maxResults     : 10
	  });


});

