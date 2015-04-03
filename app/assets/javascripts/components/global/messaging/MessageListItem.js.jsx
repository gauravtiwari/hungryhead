/**
 * @jsx React.DOM
 */
var SetIntervalMixin = {
    componentWillMount: function() {
        this.intervals = [];
    },
    setInterval: function(fn, ms) {
        this.intervals.push(setInterval(fn, ms));
    },
    componentWillUnmount: function() {
        this.intervals.forEach(clearInterval);
    }
};

var MessageListItem = React.createClass({
  mixins: [SetIntervalMixin],
  componentDidMount: function() {
    var interval = this.props.message.created_at || 60000;
    this.setInterval(this.forceUpdate.bind(this), interval);
  },
  render: function() {
    var message = this.props.message;
    var message_class = this.props.message_class;
    var classes = "message-list-item ";
    var message_id = "message-"+message.uuid;
    return (
       <li className={classes} id={message_id}>
        <div className="user-avatar"><img src={message.user_avatar} width="30px" /></div>
        <div className="tree-content">
          <div className="message" dangerouslySetInnerHTML={{__html: message.body}}></div>
          <span>{moment(this.props.message.created_at).fromNow()}</span>
        </div>
      </li>
    );
  }

});
