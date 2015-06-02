# Handle flash messages in view

$(document).ready ->
  $(window).bind 'rails:flash', (e, params) ->
    $('body').pgNotification(
      style: 'circle'
      message: params.message
      position: 'bottom-left'
      type: params.type
      timeout: 5000).show()
    return
  return