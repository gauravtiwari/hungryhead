var $ = jQuery.noConflict();
$(document).ready(function () {
  if(window.idea && window.idea.slug) {
    var idea_collaboration_channel = pusher.subscribe("presence-idea-collaboration-" + window.idea.slug);
  }
});