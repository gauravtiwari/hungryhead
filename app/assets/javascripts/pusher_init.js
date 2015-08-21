if(window.currentUser && window.currentUser.authenticated) {
  var pusher = new Pusher(window.PUSHER_APP_KEY, {
    wsHost: "0.0.0.0",
    wsPort: "9000",
    wssPort: "9000",
    enabledTransports: ['ws', 'flash']
  });
  var channel = pusher.subscribe('private-user-' + window.currentUser.id)
  var presence_channel = pusher.subscribe('presence-user-' + window.currentUser.id)
}

