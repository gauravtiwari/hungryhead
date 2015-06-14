/**
 * @jsx React.DOM
 */

var ConversationMeta = React.createClass({

  getInitialState: function(){
    return {
      deleting: false
    }
  },

  handleDelete: function() {
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: Routes.conversation_path(this.props.active_conversation.id),
      type: "DELETE",
      dataType: "json",
      success: function (data) {
        this.setState({deleting: false});
        this.setState({sure: false});
        console.log(data);
        this.props.removeConversation(data.id);
        if(data.deleted){
            var options =  {
              content: data.message,
              style: "snackbar", // add a custom class to your snackbar
              timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
            }
            $.snackbar(options);
          } else if(data.error) {
             var options =  {
              content: data.error.message,
              style: "snackbar", // add a custom class to your snackbar
              timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
            }
            $.snackbar(options);
          }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  cancelDelete: function() {
    this.setState({sure: false});
  },

  checkDelete: function() {
    this.setState({sure: true});
  },

  render: function() {
    conversation = this.props.active_conversation;
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-check-circle': this.state.deleting
    });
    var deleteClass = cx({
      'fa fa-spinner fa-spin': this.state.deleting
    });
    var delete_text = this.state.sure ? 'Are you sure?' : '';

    var action_style = {
      fontSize: '14px'
    }

    if(this.state.sure) {
      var confirm_delete = <span>{delete_text}<a style={action_style} onClick={this.handleDelete}><i className={classes}></i> confirm</a> or <a style={action_style} onClick={this.cancelDelete}> cancel</a></span>;
    } else {
      var confirm_delete = <a onClick={this.checkDelete} rel="nofollow" className="m-r-10"><i className="fa fa-trash"></i> {delete_text}</a>;
    }

    var participants = _.map(this.props.active_conversation.participants, function(participant){
      return <ConversationParticipant participant={participant} key={Math.random()} />
    });

    if(this.props.active_conversation.is_trashed) {
      var conversation_actions = ""
    } else {
      var conversation_actions = <div className="conversation-actions pull-right">
            <a onClick={this.props.handleReply}>
              <i className="fa fa-reply m-r-10"></i>
            </a>
            {confirm_delete}
          </div>;
    }

    return (
       <div className="conversation-meta padding-10 clearfix">
          {conversation_actions}
          <div className="participants">
            <div className="participant">
              {participants}
            </div>
          </div>
          <div className="subject m-r-10">
            <h6>
              {this.props.active_conversation.subject}
            </h6>
          </div>
           <small className="text-muted">
            {moment(this.props.active_conversation.created_at).fromNow()}
           </small>
      </div>
    );

  },

});



