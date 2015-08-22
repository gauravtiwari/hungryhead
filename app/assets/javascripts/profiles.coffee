$ = jQuery.noConflict()

$(document).ready ->

  #Ajax bind to check when profile is updated
  $('#edit-profile').on 'ajax:complete', (event, xhr, status, error) ->
    $('body').pgNotification {style: "simple", message: xhr.responseText.toString(), position: "bottom-left", type: 'warning', timeout: 5000}
      .show();
    return