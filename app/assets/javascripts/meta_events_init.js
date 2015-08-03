$(document).ready(function() {
  window.RAILS_ENV_CONSTANT = $('#RAILS_ENV_CONSTANT').text();
  if (window.RAILS_ENV_CONSTANT === "production") {
    MetaEvents.forAllTrackableElements(document, function(id, element, eventName, properties) {
      mixpanel.track_links("#" + id, eventName, properties);
    });
  }
});

