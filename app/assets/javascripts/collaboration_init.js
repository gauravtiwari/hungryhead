if(window.idea && window.idea.slug && !adapter_ready) {
  var idea_collaboration_channel = pusher.subscribe("presence-idea-collaboration-" + window.idea.slug);
}
