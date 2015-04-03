/**
 * @jsx React.DOM
 */

var OpenConversationsThread = React.createClass({

  getInitialState: function () {
    return {
      loading: false,
      active: false, 
      unread_messages_count: this.props.unread_messages_count
    };
  },
  componentDidMount: function() {
    var self = this;
     $.pubsub('subscribe', 'conversation_dropdown_closed', function(msg, data) {
      self.setState({active: data});
    });
   },

  openConversations: function() {
    this.setState({loading: true});
    this.setState({active: !this.state.active});
    var parentdrop = $('li.drop.conversation-threads').find('.dropdown');
    if(!this.state.active) {
        React.render(
          <ThreadSection key={Math.random()} path={this.props.path} />,
          document.getElementById('threads-section')
        );
        parentdrop.removeClass('active');
        parentdrop.addClass('active');
        $('body').addClass('stop-scrolling');
    } else {
        parentdrop.removeClass('active');
        $('body').removeClass('stop-scrolling');
    }
  },

  render: function() {
    if(this.state.unread_messages_count > 0) {
      var thread_count = <span>{this.state.unread_messages_count}</span>
    }
    return(
        <a className="open-conversations-thread" onClick={this.openConversations}>
            <i className="ion-chatbubbles"></i>
            {thread_count}
        </a>
      )
  }
});
