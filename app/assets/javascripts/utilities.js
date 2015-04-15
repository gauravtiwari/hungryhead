var $ = jQuery.noConflict();

$(document).ready(function () {
  //Load user data remote
  $(document).on('mouseover', '.load-card', function() {
    var callback, el, url;
    $('.load-card').popover('destroy');
    el = $(this);
    url = $(this).data('popover-href');
    setTimeout(function() {
      callback = function(response) {
        return el.unbind('mousehover').popover({
          content: response,
          html: true,
          container: 'body',
        }).popover('show');
      };
    return $.get(url, '', callback, '');
    }, 500);
  });

  $('.load-card').on('hidden.bs.popover', function () {
    $('.load-card').popover('destroy')
  });

  $('html').on('mouseup', function(e) {
      if(!$(e.target).closest('.popover').length) {
          $('.popover').each(function(){
              $(this).popover('destroy');
          });
      }
  });

});

