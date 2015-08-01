var $ = jQuery.noConflict();

$(document).ready(function () {
  //Load user data remote
  $(document).on('mouseover', '.load-card', function() {
    var callback, el, url;
    $('.load-card').popover('destroy');
    el = $(this);
    url = $(this).data('popover-href');
    el.off('mouseover');
    setTimeout(function() {
      $.get(url, function(d) {
        el.popover({
          content: d,
          html: true,
          container: 'body'
        }).popover('show');
      });
    }, 500);
  });

  $('.load-card').on('hidden.bs.popover', function () {
    $('.load-card').popover('destroy')
  });


  $(document).on('mouseup', function(e) {
    if(!$(e.target).closest('.popover').length) {
      $('.load-card').each(function(){
        $(this).popover('destroy');
      });
    }
  });

});

