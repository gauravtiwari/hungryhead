
var FriendsNotificationCommentItem = React.createClass({

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

    if(this.props.item.recipient.recipient_type === "idea") {
      var recipient = this.props.item.recipient.recipient_name;
    } else {
      var recipient = "";
    }

    if(this.props.item.actor.actor_avatar) {
      var placeholder = <img src={this.props.item.actor.actor_avatar} width="32" height="32" />
    } else {
      var placeholder = <span className="placeholder no-padding bold text-white">{this.props.item.actor.actor_name_badge}
              </span>;
    }
    return (<li className="alert-list padding-10" id={html_id}>
             <div className="p-l-10 col-xs-height col-middle col-xs-9 overflow-ellipsis fs-13">
               <a className="text-complete" href={this.props.item.actor.url}>
                 <div className="thumbnail-wrapper d32 fs-12 user-pic circular inline m-r-10">
                   {placeholder}
                 </div>
                 <strong>{actor}</strong>
               </a>
               <span>
                 <span className="text-master p-l-5">{this.props.item.verb}</span>
                 <span className="text-master p-l-5">on your {this.props.item.recipient.recipient_type}</span>
                 <span className="recipient p-l-5 text-master">
                   <a href={this.props.item.recipient.recipient_url}>{recipient}</a>
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