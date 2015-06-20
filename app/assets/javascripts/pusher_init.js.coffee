pusher = new Pusher(window.PUSHER_APP_KEY)
channel = pusher.subscribe('private-user-' + window.currentUser.uid)
presence_channel = pusher.subscribe('presence-user-' + window.currentUser.uid)
if channel
  channel.bind 'new_badge', (data) ->
    $('body').pgNotification(
      style: 'simple'
      message: data.message
      position: 'top-right'
      type: 'success'
      timeout: 5000).show()
    return
  channel.bind 'new_notification', (data) ->
    $('body').pgNotification(
      style: 'simple'
      message: data.data.msg
      position: 'top-right'
      type: 'success'
      timeout: 5000).show()
    return

    (($, Pusher) ->