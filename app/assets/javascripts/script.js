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

	  var responsiveHelper = undefined;
	  var breakpointDefinition = {
	      tablet: 1024,
	      phone: 480
	  };
	  var initTableWithSearch = function() {
	      var table = $('#tableWithSearch');
	      var settings = {
	          dom: "<'table-responsive't><'row'<p i>>",
	          resposive: true,
	          destroy: true,
	          scrollCollapse: true,
	          language: {
	              engthMenu: "_MENU_ ",
	              info: "Showing <b>_START_ to _END_</b> of _TOTAL_ entries"
	          },
	          displayLength: 5
	      };
	      table.dataTable(settings);
	      $('#search-table').keyup(function() {
	          table.fnFilter($(this).val());
	      });
	  }
	  initTableWithSearch();


});

