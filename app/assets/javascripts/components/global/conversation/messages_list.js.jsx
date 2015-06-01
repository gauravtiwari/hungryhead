/**
 * @jsx React.DOM
 */

var ConversationMessagesList = React.createClass({
  render: function() {

    if(this.props.message.sender_avatar) {
      var placeholder = <img  width="40px" className="participant-avatar m-r-10" src={this.props.message.sender_avatar} width="32" height="32" />
    } else {
      var placeholder = <span className="thumbnail-wrapper d32 circular inline  m-r-10">
        <span className="placeholder no-padding bold text-white participant-avatar">{this.props.message.sender_name_badge}
              </span></span>;
    }

    return (
      <div className="message opened">
        <div className="participants padding-10 full-width">
          <span className={this.props.message.mailbox_type === "Trashed"? 'message-badge padding-5 fs-12 b-rad-sm bg-danger text-white pull-right' : 'message-badge padding-5 fs-12 b-rad-sm bg-solid text-white pull-right'}>{this.props.message.mailbox_type}</span>
          <div className="participant">
            <a href={this.props.message.sender_path}>
              {placeholder}
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

