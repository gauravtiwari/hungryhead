if(window.currentUser && window.currentUser.authenticated) {
  var pusher = new Pusher(window.PUSHER_APP_KEY)
  var channel = pusher.subscribe('private-user-' + window.currentUser.id)
  var presence_channel = pusher.subscribe('presence-user-' + window.currentUser.id)
  if(channel) {
    channel.bind('new_badge', function(data) {
     channel.bind('new_badge', function(data) {
        $('body').pgNotification({style: "simple", message: data.message, position: "top-right", type: "success",timeout: 5000}).show();
      });
    });
    channel.bind('new_notification', function(data){
      $('body').pgNotification({style: "simple", message: data.data.msg, position: "top-right", type: "success",timeout: 5000}).show();
    });
  }
}
