/**
 * @jsx React.DOM
 */

var ConversationsListBox = React.createClass({
  getInitialState: function() {
    return {
      conversations: [],
      mailbox_size: [],
      mailbox: [],
      form:[],
      recipients_options: "",
      current_user_id: null,
      messaging: false
    };
  },

  componentDidMount: function() {
    if(this.isMounted()) {
      this.loadConversations();
    }
  },

  loadConversations: function(){
    $.ajaxSetup({ cache: false });
    this.setState({ loading: true});
    $.getJSON(this.props.source, function(data, textStatus) {
        this.setState({
          conversations: data.conversations,
          mailbox: data.mailbox,
          current_user_id: data.current_user_id,
          recipients_options: data.recipients_options,
          mailbox_size: data.mailbox_size,
          form: data.form,
          loading: false
        });
    }.bind(this));
  },

  updateConversations: function(id) {
    new_conversations = _.without(this.state.conversations, _.findWhere(this.state.conversations, {id: id}));
     this.setState({
        conversations: new_conversations
      });
      if(this.state.conversations.length === 0) {
        window.location.href = Routes.conversations_path();
      }
  },

  removeConversation: function(id){
    new_conversations = _.without(this.state.conversations, _.findWhere(this.state.conversations, {id: id}));
    this.setState({
      conversations: new_conversations
    });
  },

  render: function() {
    var cx = React.addons.classSet;
    var conversations_header_classes = cx({
      'conversations-header white-background': true,
      'show': !this.state.loading,
      'hidden': this.state.loading
    });

    var updateConversations = this.updateConversations;
    var removeConversation = this.removeConversation;
    if(this.state.conversations.length > 0) {
      var conversationsList = _.map(this.state.conversations, function(conversation) {
        return <ConversationListBoxItem removeConversation={removeConversation} updateConversations={updateConversations} key={conversation.uuid} conversation={conversation} />;
      });
    } else {
      if (this.state.loading) {
       var conversationsList = <div className="no-content conversations text-center"><i className="fa fa-spinner fa-spin"></i> <h1>Loading conversations</h1></div>
      } else {
        var conversationsList = <div className="no-content conversations text-center"><i className="fa fa-fw fa-inbox"></i> <h1>No {this.state.mailbox} messages</h1></div>
      }
    }

    var conversation_active_classes = cx({
      'conversations-list': true
    });

    if(this.state.mailbox === 'trash') {
      var box_action_link =  <a className="btn btn-danger pull-right" data-method="delete" href={Routes.empty_trash_conversations_path()}>Empty Trash</a>;
    } else {
      var box_action_link =  <a className="btn btn-primary pull-right" href={Routes.new_message_path()}>Send Message</a>;
    }

    return (
      <div className="conversations-box panel panel-default">
        <div className={conversations_header_classes}>
          <div className="col-md-4 search-box margin-top">
            <ul className="mailbox-nav no-margin no-padding">
              <li className={this.state.mailbox === 'inbox' ? 'mailbox active' : 'mailbox'}><a href="/conversations?box=inbox">Inbox ({this.state.mailbox_size.inbox_count})</a></li>
              <li className={this.state.mailbox === 'sent' ? 'mailbox active' : 'mailbox'}><a href="/conversations?box=sent">Sent ({this.state.mailbox_size.sentbox_count})</a></li>
              <li className={this.state.mailbox === 'trash' ? 'mailbox active' : 'mailbox'}><a href="/conversations?box=trash">Trash ({this.state.mailbox_size.trash_count})</a></li>
            </ul>
          </div>
           {box_action_link}
        </div>
        <div className="conversation-list-box">
            <div className={conversation_active_classes}>
              {conversationsList}
            </div>
        </div>
      </div>
      );

  },

});