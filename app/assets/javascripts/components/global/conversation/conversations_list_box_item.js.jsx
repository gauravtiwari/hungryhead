/**
 * @jsx React.DOM
 */

var ConversationListBoxItem = React.createClass({
  getInitialState: function(){
    return {
      deleting: false,
      restoring: false,
      sure: false,
      is_unread: this.props.conversation.is_unread
    }
  },

  componentDidMount: function() {
    $('[data-toggle="tooltip"]').tooltip();
  },

  handleDelete: function() {
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: Routes.conversation_path(this.props.conversation.id),
      type: "DELETE",
      dataType: "json",
      success: function ( data ) {
        this.setState({deleting: false});
        this.setState({sure: false});
        if(data.deleted){
            var options =  {
              content: data.message,
              style: "snackbar", // add a custom class to your snackbar
              timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
            }
            $.snackbar(options);
            this.props.removeConversation(this.props.conversation.id);
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

  markAsRead: function() {
    $('[data-toggle="tooltip"]').tooltip('destroy');
    $.post(Routes.mark_as_read_conversation_path(this.props.conversation.id), function(data){
      this.setState({is_unread: data.unread});
      if(data.unread){
        var options =  {
          content: "Conversation has marked unread",
          style: "snackbar", // add a custom class to your snackbar
          timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
        }
        $.snackbar(options);
      } else {
         var options =  {
          content: "Conversation has marked read",
          style: "snackbar", // add a custom class to your snackbar
          timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
        }
        $.snackbar(options);
      }
      $('[data-toggle="tooltip"]').tooltip();
    }.bind(this));
  },

  restoreConversation: function() {
    this.setState({restoring: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: Routes.restore_conversation_path(this.props.conversation.id),
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        this.setState({restoring: false});
        if(data.restored){
            var options =  {
              content: data.message,
              style: "snackbar", // add a custom class to your snackbar
              timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
            }
            $.snackbar(options);
            this.props.updateConversations(data.id);
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
  var cx = React.addons.classSet;
  var classes = cx({
    'ion-check': this.state.deleting
  });
  var deleteClass = cx({
    'fa fa-spinner fa-spin': this.state.deleting
  });
  var restoringClass = cx({
    'fa fa-spinner fa-spin': this.state.restoring
  });
  var delete_text = this.state.sure ? 'Are you sure?' : '';

  var action_style = {
    fontSize: '14px' 
  }

  var conversation_status_classes = cx({
    'conversation clearfix': true,
    'read': !this.state.is_unread,
    'unread': this.state.is_unread
  });

  if(this.state.sure) {
    var confirm_delete = <span>{delete_text}<a style={action_style} onClick={this.handleDelete}><i className={classes}></i> confirm</a> or <a style={action_style} onClick={this.cancelDelete}> cancel</a></span>;
  } else {
    var confirm_delete = <a onClick={this.checkDelete} rel="nofollow"><i className="ion-trash-b"></i> {delete_text}</a>;
  } 

  var participantImage = _.map(this.props.conversation.participants, function(participant) {
    return <a key={Math.random()}  href="javascript:void(0)" data-popover-href={participant.sender_path} className='load-card'>
    <img width="40px" className="participant-avatar margin-right" src={participant.sender_avatar} alt="Avatar img 20121207 022806" />
    </a>;
  });

  if(this.state.is_unread) {
    var mark_as_read = <a data-toggle="tooltip" data-placement="top" title="Mark as read" onClick={this.markAsRead} className="padding-right"><i className="ion-checkmark-circled"></i></a>
  } else {
    var mark_as_read = <a data-toggle="tooltip" data-placement="top" title="Mark as unread" onClick={this.markAsRead} className="padding-right"><i className="fa fa-fw fa-circle-o"></i></a>
  }

  if(this.props.conversation.is_trashed) {
    var conversation_actions = <a onClick={this.restoreConversation}>
              <i className="ion-refresh"></i> <i className={restoringClass}></i>
            </a>
  } else {
    var conversation_actions = confirm_delete;
  }
  return (
    <div className={conversation_status_classes}>
      <div className="participants col-md-3">
        <div className="participant">   
          {participantImage}
        </div>
      </div>
      <div className="conversation-body col-md-6">
        <div className="subject margin-right">
          <a href={this.props.conversation.conversation_path}>{this.props.conversation.subject}</a>
          <span className="text-muted"> ({this.props.conversation.messages_count})</span>    
        </div>

        <div className="last-message clearfix margin-right" dangerouslySetInnerHTML={{__html: jQuery.truncate(this.props.conversation.last_message_body, {length: 50})}}>
              
        </div>
         <small>
          <span className="text-muted">
            {moment(this.props.conversation.last_message_created_at).fromNow()}
          </span>
          </small>
      </div>
       <div className="conversation-actions pull-right">
           {mark_as_read}
           {conversation_actions}   
        </div>
    </div>
    );

  },

});