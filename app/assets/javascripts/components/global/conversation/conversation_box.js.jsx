var ConversationBox = React.createClass({
  getInitialState: function() {
    return {
      conversations: [],
      messages: [],
      search_form: [],
      mailbox: [],
      recipients_options: "",
      active_conversation: [],
      replying: false,
      messaging: false,
      loading: false
    }
  },
  componentDidMount: function() {
    if(this.isMounted()){
      this.loadConversation();
      $(window).resize(this.sizeContent);
    }
  },

  sizeContent: function() {
    var newHeight = $("html").height() - 220 + "px";
    $(".message-box .messages").css("height", newHeight.toString());
    $(".conversations-list").css("height", $("html").height() - 150 + "px");
  },

  loadConversation: function(){
    $.ajaxSetup({ cache: false });
    this.setState({loading: true});
    $.getJSON(this.props.source, function(data, textStatus) {
        this.setState({
          conversations: data.conversations,
          messages: data.messages,
          mailbox: data.mailbox,
          loading: false,
          recipients_options: data.recipients_options,
          active_conversation: data.active_conversation
        });
    }.bind(this));
  },

  handleReply: function(e) {
    e.preventDefault();
    $(".message-box .messages").slimScroll({destroy: true});
    this.setState({replying: true});
  },

  cancelReplying: function(e) {
    e.preventDefault();
    this.setState({replying: false});
  },

  handleReplySubmit: function(formdata) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.post(Routes.reply_conversation_path(this.state.active_conversation.id), formdata, function(data) {
      var new_messages = this.state.messages.reverse().concat(data);
      this.setState({messages: new_messages.reverse()});
      this.setState({replying: false, loading: false});
    }.bind(this));
  },

  removeConversation: function(id){
    new_conversations = _.without(this.state.conversations, _.findWhere(this.state.conversations, {id: id}));
    this.setState({
      conversations: new_conversations,
    });
    if(this.state.conversations.length === 0) {
      window.location.href = Routes.conversations_path();
    } else {
      this.setState({active_conversation: new_conversations[0]});
      window.location.href = Routes.conversation_path(new_conversations[0].id);
    }
  },

  render: function() {
    var active_id = this.state.active_conversation.id;
    var conversationslist = _.map(this.state.conversations, function(conversation) {
      return <ConversationList active_id={active_id} key={conversation.uuid} conversation={conversation} />;
    });

    var messagesList = _.map(this.state.messages, function(message){
      if (active_id === message.conversation_id) {
        return <ConversationMessagesList key={message.uuid} message={message} />
      }
    });

    var cx = React.addons.classSet;

    var messages_active_classes = cx({
      'messages scrollable': true,
      'show': !this.state.replying,
      'hidden': this.state.replying
    });

    return (
      <div className="container p-r-45">
        <div className="conversation-box panel panel-default">
          <ConversationHeader mailbox={this.state.mailbox} key={Math.random()} />
          <div className="col-md-12 conversations-list-box">
            <div className="col-md-4 no-padding">
              <div className="conversations-list scrollable">
                 {conversationslist}
               </div>
             </div>
             <div className="col-md-8 message-box">
               <div className="conversation">
                 <ConversationMeta removeConversation={this.removeConversation} key={Math.random()} handleReply={this.handleReply} key={Math.random()} active_conversation={this.state.active_conversation} />
                 <ConversationReplyForm loading={this.state.loading} handleReplySubmit={this.handleReplySubmit} cancelReplying={this.cancelReplying} replying={this.state.replying} active_conversation={this.state.active_conversation} />
                 <div className={messages_active_classes}>
                   {messagesList}
                 </div>
               </div>
             </div>
          </div>
        </div>
      </div>
    );

  },

});

