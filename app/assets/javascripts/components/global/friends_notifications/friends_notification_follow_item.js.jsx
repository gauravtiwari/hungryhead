
var FriendsNotificationFollowItem = React.createClass({
  render: function() {
    var html_id = "feed_"+this.props.item.id;
    if(window.currentUser.name === this.props.item.actor.actor_name) {
      var actor = "You";
    } else {
      var actor = this.props.item.actor.actor_name;
    }

    if(window.currentUser.name === this.props.item.recipient.recipient_name) {
      var recipient = "You"
    } else {
      var recipient = this.props.item.recipient.recipient_name.split(' ')[0];
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
                 <span className="text">
                   <span className="text-master p-l-5">{this.props.item.verb}</span>
                   <span className="recipient p-l-5 text-master">
                     {recipient}
                   </span>
                 </span>
                 <span className="text-master hint-text fs-12 clearfix">{moment(this.props.item.created_at).fromNow()}</span>
               </div>
             </li>
      );
  }
});