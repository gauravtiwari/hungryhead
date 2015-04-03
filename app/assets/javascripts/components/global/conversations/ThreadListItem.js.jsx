/**
 * @jsx React.DOM
 */

var ThreadListItem = React.createClass({
  getInitialState: function() {
    return {
      unread: this.props.conversation.unread
    }
  },

  render: function() {
      var conversation = this.props.conversation;
      if (this.props.conversation.messages) {
        var last_message = this.props.conversation.messages;
        var last_message_body = last_message.body;
        var last_message_date = moment(last_message.created_at).fromNow();
      } else {
        var last_message_body = "No messages";
        var last_message_date = "";
      }
     var cx = React.addons.classSet;

     if(this.state.unread) {
      var new_message = <div className='read-status-icon'><span>New message</span></div>;
     } else {
      var new_message = "";
     }

    var conversation_status_classes = cx({
      'conversation clearfix': true,
      'read': !this.props.conversation.is_unread,
      'unread': this.props.conversation.is_unread
    });

    return (
    <div className={conversation_status_classes}>
      <div className="participants">
        <div className="participant">
          <img key={Math.random()} width="40px" className="participant-avatar margin-right" src={this.props.conversation.sender_avatar} alt="Avatar img 20121207 022806" />
        </div>
      </div>
      <div className="conversation-body">
        <div className="subject margin-right">
          <a href={this.props.conversation.conversation_path}>{this.props.conversation.subject}</a>
          <span className="text-muted"> ({this.props.conversation.messages_count})</span>    
        </div>

        <div className="last-message clearfix" dangerouslySetInnerHTML={{__html: this.props.conversation.last_message_body}}>
              
        </div>
         <small>
          <span className="text-muted">
            {moment(this.props.conversation.last_message_created_at).fromNow()}
          </span>
          </small>
      </div>
    </div>
    );
  }

  });

