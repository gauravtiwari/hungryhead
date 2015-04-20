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

    var cx = React.addons.classSet;
    var message_owner_classes = cx({
      "chat-bubble": true,
      "from-me": this.props.message.user_id == window.currentUser.id,
      "from-them": this.props.message.user_id != window.currentUser.id
    });

    var message_id = "message-"+message.uuid;
    if(this.props.message.user_id == window.currentUser.id) {
      var message =<div className={message_owner_classes} dangerouslySetInnerHTML={{__html: message.body}}>
        </div>;
    } else {
      var message = <div>
        <div className="profile-img-wrapper m-t-5 inline">
            <img className="col-top" src={message.user_avatar}  data-src={message.user_avatar} data-src-retina={message.user_avatar} width="30" height="30" />
        </div>
        <div className={message_owner_classes} dangerouslySetInnerHTML={{__html: message.body}}>
        </div></div>;
    }
    return (
      <div className="message clearfix">
      {message}
      </div>
    );
  }

});
