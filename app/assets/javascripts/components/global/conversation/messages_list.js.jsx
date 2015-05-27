/**
 * @jsx React.DOM
 */

var ConversationMessagesList = React.createClass({
  render: function() {
    return (
      <div className="message opened">
        <div className="participants padding-10 full-width">
          <span className={this.props.message.mailbox_type === "Trashed"? 'message-badge padding-5 fs-12 b-rad-sm bg-danger text-white pull-right' : 'message-badge padding-5 fs-12 b-rad-sm bg-solid text-white pull-right'}>{this.props.message.mailbox_type}</span>
          <div className="participant">
            <a href={this.props.message.sender_path}>
              <img width="40px" className="participant-avatar float-left m-r-10" src={this.props.message.sender_avatar} alt="Avatar img 20121207 022806" />
            </a>
          </div>
          <span>
            <a href={this.props.message.sender_path}>{this.props.message.sender_name}</a>
          </span>
          <small className="text-muted clearfix">
           {moment(this.props.message.created_at).fromNow()}
          </small>
        </div>
        <div className="message-body padding-10 clearfix" dangerouslySetInnerHTML={{__html: this.props.message.body}}>
        </div>
      </div>
    );

  },

});

