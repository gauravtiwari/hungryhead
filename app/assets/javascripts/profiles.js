var $ = jQuery.noConflict();

$(document).ready(function () {

  try {
    $('.chosen-select').chosen();
  } catch(e) {}

});

