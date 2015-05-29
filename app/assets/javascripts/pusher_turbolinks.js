(function($, Pusher) {
  Pusher.prototype.reset = function() {
    $.each(this.channels.channels, function(name, channel) {
      channel.callbacks._callbacks = {}
    })
  }

  $(document).on('page:change', function() {
    $.each(Pusher.instances, function(index, instance) {
      instance.reset()
    })
  })
})(jQuery, Pusher);