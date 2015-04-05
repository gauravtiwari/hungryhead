var $ = jQuery.noConflict();


$(document).ready(function () {

	/*-------------------------------------------------*/
	/* =  Soulmate
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

});
