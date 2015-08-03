$(document).ready(function() {
  MetaEvents.forAllTrackableElements(document, function(id, element, eventName, properties) {
    mixpanel.track_links("#" + id, eventName, properties);
  })
});