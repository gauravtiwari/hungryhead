### Resets all callbacks ###
Pusher::reset = ->
  $.each @channels.channels, (name, channel) ->
    channel.callbacks._callbacks = {}
    return
  return

$(document).on 'page:receive', ->
  $.each Pusher.instances, (index, instance) ->
    instance.reset()
    return
  return
return
) jQuery, Pusher