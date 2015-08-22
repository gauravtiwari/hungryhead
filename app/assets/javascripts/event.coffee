jQuery(document).ready ->
  $('#new_event').click (e) ->
    eventable_id = $(this).data('eventable-id')
    eventable_type = $(this).data('eventable-type')
    $.getScript(Routes.new_event_path(eventable_id: eventable_id, eventable_type: eventable_type))