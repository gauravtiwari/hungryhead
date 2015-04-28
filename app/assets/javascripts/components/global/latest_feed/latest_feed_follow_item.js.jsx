
var LatestFeedFollowItem = React.createClass({
  mixins: [SetIntervalMixin],
  componentDidMount: function() {
    var interval = this.props.refreshMillis || 60000;
    this.setInterval(this.forceUpdate.bind(this), interval);
  },
  render: function() {
    var html_id = "feed_"+this.props.item.id;
    if(window.currentUser.name === this.props.item.actor) {
      var actor = "You";
    } else {
      var actor = this.props.item.actor;
    }

    if(window.currentUser.name === this.props.item.recipient) {
      var recipient = "You"
    } else {
      var actor = this.props.item.recipient;
    }
    return (
        <li id={html_id} className="p-l-15 p-r-15 p-b-10 p-t-10 fs-12 clearfix">
          <span className="inline">
            <a className="text-master hint-text" href={this.props.item.url}>
              <strong>{actor}</strong>
            </a>
            <span className="icon p-l-5"><i className="fa fa-user-plus"></i></span>
            <span className="verb p-l-5">
              {this.props.item.verb}
            </span>
            <span className="recipient p-l-5">
              {recipient}
            </span>
          <span className="date p-l-10 fs-11 text-danger">{moment(Date.parse(this.props.item.created_at)).fromNow()}</span>
          </span>
        </li>
      );
  }
});