/**
 * @jsx React.DOM
 */
var MessageSection = React.createClass({

  render: function() {
    if(this.props.messages) {
      var messages = this.props.messages;
      var messageListItems = this.props.messages.map(function(message){
      return <MessageListItem message= {message} key={message.uuid} />
      });
    }
    return (
      <div className="chat-inner" id="my-conversation" ref="messageList">
        {messageListItems}
      </div>
    );
  },

  componentDidMount: function() {
    this._scrollToBottom();
    $('a[data-toggle="quickview"], #content').on('click', function(){
      $('body').removeClass('show-collaboration');
      $('.quickview-wrapper').removeClass('open');
    });
  },

  componentDidUpdate: function() {
    this._scrollToBottom();
  },

  _scrollToBottom: function() {
    var ul = this.refs.messageList.getDOMNode();
    ul.scrollTop = ul.scrollHeight;
  },

});
