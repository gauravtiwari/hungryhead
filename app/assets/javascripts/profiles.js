var $ = jQuery.noConflict();

$(document).ready(function () {

  try {
    $('.chosen-select').chosen({
      allow_single_deselect: true,
      no_results_text: 'No friends found',
      width: '100%'
    });
  } catch(e) {}

});

