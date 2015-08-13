(function($, Pusher) {
  Pusher.prototype.reset = function() {
    var pusher = new Pusher(window.PUSHER_APP_KEY)
    $.each(this.channels.channels, function(name, channel) {
      channel.callbacks._callbacks = {}
      pusher.unsubscribe(channel)
    })
  }

  $(document).on('page:change', function() {
    $.each(Pusher.instances, function(index, instance) {
      instance.reset()
    })
  })
})(jQuery, Pusher);