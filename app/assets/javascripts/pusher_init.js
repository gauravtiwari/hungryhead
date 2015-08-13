var adapter_ready;
window.adapter_ready = false
if(window.currentUser && window.currentUser.authenticated && !adapter_ready) {
  var pusher = new Pusher(window.PUSHER_APP_KEY)
  var channel = pusher.subscribe('private-user-' + window.currentUser.id)
  var presence_channel = pusher.subscribe('presence-user-' + window.currentUser.id)
}

