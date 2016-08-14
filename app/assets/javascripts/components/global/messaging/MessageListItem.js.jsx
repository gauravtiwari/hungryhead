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
    var message_owner_classes = classNames({
      "chat-bubble": true,
      "from-me": this.props.message.user_id == window.currentUser.id,
      "from-them": this.props.message.user_id != window.currentUser.id
    });

    var message_id = "message-"+message.uuid;

    if(message.user_avatar != null) {
      var avatar =  <div className="profile-img-wrapper m-t-5 inline">
            <img className="col-top" src={message.user_avatar}  data-src={message.user_avatar} data-src-retina={message.user_avatar} width="30" height="30" />
        </div>;
    } else {
      var avatar = <div className="thumbnail-wrapper d32 circular bordered b-white">
              <span className="placeholder bold text-white">
                {message.user_badge}
              </span>
            </div>;
    }

    if(this.props.message.user_id == window.currentUser.id) {
      var message =<div className={message_owner_classes} dangerouslySetInnerHTML={{__html: message.body}}>
        </div>;
    } else {
      var message = <div>
        {avatar}
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
