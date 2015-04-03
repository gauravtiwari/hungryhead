/**
 * @jsx React.DOM
 */
var PureRenderMixin = React.addons.PureRenderMixin;

var UserMessage = React.createClass({
  mixins: [PureRenderMixin],
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
        $('.message-box .modal-body').slimScroll({
          height: $(window).height()-150
        });
    }
  },

  loadConversations: function(){
    $.ajaxSetup({ cache: false });
    this.setState({ loading: true});
    $.getJSON(this.props.source, function(data, textStatus) {
        this.setState({
          conversations: data.conversations,
          mailbox: data.mailbox,
          recipient_name: data.recipient_name,
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
  	var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    var updateConversations = this.updateConversations;
    var removeConversation = this.removeConversation;

    if(this.state.conversations.length > 0 && this.isMounted()) {
      var conversationsList = _.map(this.state.conversations, function(conversation) {
        return <ConversationListBoxItem removeConversation={removeConversation} updateConversations={updateConversations} key={conversation.uuid} conversation={conversation} />;
      });
    } else {
      if (this.state.loading) {
       var conversationsList = <div className="no-content conversations"><i className="fa fa-spinner fa-spin"></i> <h1>Loading conversations </h1></div>
      } else {
        var conversationsList = <div className="no-content conversations"><i className="fa fa-fw fa-inbox"></i> <h1>No {this.state.mailbox} messages</h1></div>
      }
    }

    var conversation_active_classes = cx({
      'conversations-list': true
    });

    if(this.state.mailbox === 'trash') {
      var box_action_link =  <a className="btn btn-danger float-right" data-method="delete" href={Routes.empty_trash_conversations_path()}>Empty Trash</a>;
    } else {
      var box_action_link =  <a className="btn btn-primary float-right" href={Routes.new_message_path()}>Send Message</a>;
    }


    return (
  	  <div className="chatapp message-box">
				<div className="modal fade" tabIndex="-1" role="dialog" id="modalPopup" aria-labelledby="modalPopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
				  <div className="modal-dialog modal-lg">
				    <div className="modal-content">
				      <div className="profile-wrapper-title">
				        <button type="button" className="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span className="sr-only">Close</span></button>
				        <h4 className="modal-title" id="myModalLabel"><i className="ion-chatbubbles"></i> Conversations with {this.state.recipient_name }</h4>
				      </div>
				      <div className="modal-body">
				      	 <div className="conversations-box">
                    <div className="conversation-list-box">
                        <div className={conversation_active_classes}>
                          {conversationsList}
                        </div>
                    </div>
                  </div>
				      </div>
				    </div>
				  </div>
				</div>
      </div>
    );
  }

});
