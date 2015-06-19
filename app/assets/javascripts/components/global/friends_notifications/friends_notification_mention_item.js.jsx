
var FriendsNotificationMentionItem = React.createClass({

  loadActivity: function() {
    $.getScript(Routes.activity_path(this.props.item.activity_id));
  },

  render: function() {
    var html_id = "feed_"+this.props.item.id;

    if(window.currentUser.name === this.props.item.actor.actor_name) {
      var actor = "You";
    } else {
      var actor = this.props.item.actor.actor_name;
    }

    if(this.props.item.actor.actor_avatar) {
      var placeholder = <img src={this.props.item.actor.actor_avatar} width="40" height="40" />
    } else {
      var placeholder = <span className="placeholder no-padding bold text-white">{this.props.item.actor.actor_name_badge}
              </span>;
    }

    if(this.props.item.recipient.recipient_name == window.currentUser.name) {
      var recipient_name = "you";
    } else {
      var recipient_name = this.props.item.recipient.recipient_name;
    }

    return (<li className="alert-list padding-10" id={html_id}>
               <div className="p-l-10 col-xs-height col-middle col-xs-9 overflow-ellipsis fs-13">
                 <a className="text-complete" href={this.props.item.actor.url}>
                   <div className="thumbnail-wrapper d32 fs-12 user-pic circular inline m-r-10">
                     {placeholder}
                   </div>
                   <strong>{actor}</strong>
                 </a>
                 <span className="text">
                   <span className="verb p-l-5 inline text-master">
                     {this.props.item.verb}
                   </span>
                   <span className="text-master p-l-5">{recipient_name}</span>
                   <span className="recipient p-l-5">
                     in a comment
                   </span>
                 </span>
                 <span className="meta clearfix">
                  <span className="text-master hint-text inline fs-12">{moment(this.props.item.created_at).fromNow()}</span>
                  <span><a className="inline fs-12 p-l-10" onClick={this.loadActivity}>View {this.props.item.event.event_name}</a></span>
                 </span>
               </div>
             </li>
      );
  }
});