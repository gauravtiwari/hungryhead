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
    var parentdrop = $('li.conversation-threads').find('.conversation-dropdown');
    if(!this.state.active) {
        React.render(
          <ThreadSection key={Math.random()} path={this.props.path} />,
          document.getElementById('threads-section')
        );
        ReactRailsUJS.mountComponents();
        parentdrop.removeClass('open');
        parentdrop.addClass('open');
        $('body').addClass('stop-scrolling');
    } else {
        parentdrop.removeClass('open');
        $('body').removeClass('stop-scrolling');
    }
  },

  render: function() {
    if(this.state.unread_messages_count > 0) {
      var thread_count = <span className="bubble font-arial bold">{this.state.unread_messages_count}</span>
    }
    return(
        <a className="fa fa-envelope b-r b-grey p-r-10 b-dashed fs-22 text-brand pointer" onClick={this.openConversations}>
          {thread_count}
        </a>
      )
  }
});
