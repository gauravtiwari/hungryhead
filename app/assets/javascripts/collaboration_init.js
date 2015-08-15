if(window.ideaMeta && window.ideaMeta.slug) {
  var idea_collaboration_channel = pusher.subscribe("presence-idea-collaboration-" + window.ideaMeta.slug);
}
