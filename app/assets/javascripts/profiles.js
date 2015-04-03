var $ = jQuery.noConflict();

$(document).ready(function () {

  $('#countable_field').simplyCountable({
    counter:            '#counter',
    countType:          'characters',
    maxCount:           140,
    strictMax:          false,
    countDirection:     'down',
    safeClass:          'safe',
    overClass:          'over',
    thousandSeparator:  ',',
    onOverCount:        function(count, countable, counter){},
    onSafeCount:        function(count, countable, counter){},
    onMaxCount:         function(count, countable, counter){}
  });


  $('#who_am_i_field').simplyCountable({
    counter:            '#counter',
    countType:          'characters',
    maxCount:           300,
    strictMax:          false,
    countDirection:     'down',
    safeClass:          'safe',
    overClass:          'over',
    thousandSeparator:  ',',
    onOverCount:        function(count, countable, counter){},
    onSafeCount:        function(count, countable, counter){},
    onMaxCount:         function(count, countable, counter){}
  });


});

