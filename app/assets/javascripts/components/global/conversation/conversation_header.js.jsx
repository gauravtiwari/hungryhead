/**
 * @jsx React.DOM
 */

var ConversationHeader = React.createClass({

  render: function() {

    if(this.props.mailbox === 'Trash') {
      var box_action_link =  <a className="btn btn-danger pull-right" data-method="delete" href={Routes.empty_trash_conversations_path()}>Empty Trash</a>;
    } else {
      var box_action_link =  <a className="btn btn-primary pull-right" href={Routes.new_message_path()}>Send Message</a>;
    }

    return (
      <div className="col-md-12 conversation-box-header clearfix">
        <ul className="mailbox-nav m-t-10">
          <li className="mailbox">
            <a href={Routes.conversations_path({box: 'inbox'})}><i className="fa fa-chevron-left m-r-10"></i>All conversations</a>
          </li>
        </ul>
        {box_action_link}
      </div>
    );

  },

});

