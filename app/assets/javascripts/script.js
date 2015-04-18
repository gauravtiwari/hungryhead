var $ = jQuery.noConflict();


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
	    types: ['ideas','students', 'schools', 'mentors', 'teachers'],
	    renderCallback : render,
	    selectCallback : select,
	    minQueryLength : 2,
	    maxResults     : 10
	  });

});
