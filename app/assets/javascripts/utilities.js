var $ = jQuery.noConflict();

$(document).ready(function () {
  //Load user data remote
  $(document).on('click', '.load-card', function() {
    var callback, el, url;
    el = $(this);
    url = $(this).data('popover-href');
    callback = function(response) {
      return el.unbind('click').popover({
        content: response,
        html: true,
        container: '#container',
        delay: {
          show: 2000, 
          hide: 100
        }
      }).popover('show');
    };
    return $.get(url, '', callback, '');
  });
});

  $('.load-card').on('hidden.bs.popover', function () {
    $('.load-card').popover('destroy')
  });

  $('html').on('mouseup', function(e) {
      if(!$(e.target).closest('.popover').length) {
          $('.popover').each(function(){
              $(this).popover('hide');
          });
      }
  });