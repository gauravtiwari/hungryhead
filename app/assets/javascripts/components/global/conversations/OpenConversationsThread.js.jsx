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
    if($('#conversationsPanel').length) {
      $('#conversationsPanel').addClass('open');
    } else {
      $.getScript(this.props.path, function(data, textStatus) {
        /*optional stuff to do after getScript */
      });
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
