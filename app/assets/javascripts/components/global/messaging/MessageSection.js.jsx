var MessageSection = React.createClass({

  render: function() {
    if(this.props.messages) {
      var messages = this.props.messages;
      var messageListItems = this.props.messages.map(function(message){
        return <MessageListItem message= {message} key={message.uuid} />
      });
    }

    var styles = {
      height: $(window).height() - 103 + 'px'
    }
    return (
      <div className="chat-inner" style={styles} id="idea-conversation" ref="messageList">
        {messageListItems}
      </div>
    );
  },

  sizeContent: function() {
      var newHeight = $("html").height() - 103 + "px";
      $(".chat-inner").css("height", newHeight.toString());
  },

  componentDidMount: function() {
    $(window).resize(this.sizeContent);
    this._scrollToBottom();
    $('a[data-toggle="quickview"]').on('click', function(){
      $('body').removeClass('show-collaboration');
      $('.quickview-wrapper').removeClass('open');
    });
  },

  componentDidUpdate: function() {
    this._scrollToBottom();
  },

  _scrollToBottom: function() {
    var ul = this.refs.messageList;
    ul.scrollTop = ul.scrollHeight;
  },

});
