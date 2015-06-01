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

    if(this.props.conversation.sender_avatar) {
      var placeholder = <img  width="40px" className="participant-avatar m-r-10" src={this.props.conversation.sender_avatar} width="32" height="32" />
    } else {
      var placeholder = <span className="thumbnail-wrapper d32 circular inline  m-r-10">
        <span className="placeholder no-padding bold text-white participant-avatar">{this.props.conversation.sender_name_badge}
              </span></span>;
    }

    return (
        <div className="list-view-group-container">
          <div className="list-view-group-header text-uppercase">
            a
          </div>
          <ul>
            <li className="conversations-user-list clearfix">
              <a data-view-animation="push-parrallax" data-view-port="#conversations" data-navigate="view" className="" href="#">
                <span className="col-xs-height col-middle">
                  {placeholder}
                </span>
                <p className="p-l-10 col-xs-height col-middle col-xs-12">
                  <span className="text-master">{this.props.conversation.subject}</span>
                  <span className="block text-master hint-text fs-12" dangerouslySetInnerHTML={{__html: this.props.conversation.last_message_body}}></span>
                  <span className="text-muted">
                    {moment(this.props.conversation.last_message_created_at).fromNow()}
                  </span>
                </p>
              </a>
            </li>
          </ul>
      </div>
    );
  }

  });

