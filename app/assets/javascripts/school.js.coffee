jQuery(document).ready ->
  loaded = false
  $('#load_school_ideas').click (e) ->
    if(!loaded)
      $("#tab_ideas").html("<div class='no-content'><i class='fa fa-spinner fa-spin'></i></div>")
      url = $(e.target).data('url');
      $.getScript(url);
      $("html, body").animate({ scrollTop: $('#tab_ideas').offset().top }, 500);
      loaded = true
