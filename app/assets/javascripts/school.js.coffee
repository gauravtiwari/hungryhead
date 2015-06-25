jQuery(document).ready ->
  ideas_loaded = false
  $('#load_school_ideas').click (e) ->
    if(!ideas_loaded)
      $("#tab_ideas").html("<div class='no-content'><i class='fa fa-spinner fa-spin'></i></div>")
      url = $(e.target).data('url');
      $.getScript(url);
      $("html, body").animate({ scrollTop: $('#tab_ideas').offset().top }, 500);
      ideas_loaded = true

  events_loaded = false
  $('#load_school_events').click (e) ->
    if(!events_loaded)
      $("#tab_events").html("<div class='no-content'><i class='fa fa-spinner fa-spin'></i></div>")
      url = $(e.target).data('url');
      $.getScript(url);
      $("html, body").animate({ scrollTop: $('#tab_events').offset().top }, 500);
      events_loaded = true
