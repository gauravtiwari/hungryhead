/**
 * @jsx React.DOM
 */

var ConversationMessagesList = React.createClass({
  render: function() {
    return (
      <div className="message opened">
        <div className="participants regular-padding full-width">
          <span className={this.props.message.mailbox_type === "Trashed"? 'badge danger pull-right' : 'badge primary pull-right'}>{this.props.message.mailbox_type}</span>
          <div className="participant">
            <a href="javascript:void(0)" data-popover-href={this.props.message.sender_path} className='load-card'>
              <img width="40px" className="participant-avatar float-left margin-right" src={this.props.message.sender_avatar} alt="Avatar img 20121207 022806" />
            </a>    
          </div>
          <span>
            <a href="javascript:void(0)" data-popover-href={this.props.message.sender_path} className='load-card'>{this.props.message.sender_name}</a>
          </span>   
          <small className="text-muted clearfix">
           {moment(this.props.message.created_at).fromNow()}
          </small>
        </div>
        <div className="message-body regular-padding clearfix" dangerouslySetInnerHTML={{__html: this.props.message.body}}>
        </div>
      </div>
    );

  },

});

