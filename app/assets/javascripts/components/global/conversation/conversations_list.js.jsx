/**
 * @jsx React.DOM
 */

var ConversationList = React.createClass({

  render: function() {
  var cx = React.addons.classSet;
  var active_class = cx({
    'conversation clearfix': true,
    'read': !this.props.conversation.is_unread,
    'unread': this.props.conversation.is_unread,
    'active': this.props.conversation.id === this.props.active_id
  });
  console.log(this.props.conversation);
  return (
    <div className={active_class}>
      <div className="participants">
        <div className="participant">
        <a href={this.props.conversation.sender_path}>
          <img width="40px" className="participant-avatar m-r-10" src={this.props.conversation.sender_avatar} alt="Avatar img 20121207 022806" />
        </a>
        </div>
      </div>
      <div className="conversation-body">
        <div className="subject m-r-10">
          <a href={this.props.conversation.conversation_path}>{this.props.conversation.subject}</a>
          <span className="text-muted"> ({this.props.conversation.messages_count})</span>
        </div>

        <div className="last-message clearfix m-r-10" dangerouslySetInnerHTML={{__html: jQuery.truncate(this.props.conversation.last_message_body, {length: 50})}}>

        </div>
         <small>
          <span className="text-muted">
            {moment(this.props.conversation.last_message_created_at).fromNow()}
          </span>
          </small>
      </div>
    </div>
    );

  },

});