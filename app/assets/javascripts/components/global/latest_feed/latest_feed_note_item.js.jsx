
var LatestFeedNoteItem = React.createClass({
  mixins: [SetIntervalMixin],
  componentDidMount: function() {
    var interval = this.props.item.created_at || 60000;
    this.setInterval(this.forceUpdate.bind(this), interval);
  },
  render: function() {
    var html_id = "feed_"+this.props.item.id;
    if(window.currentUser.name === this.props.item.actor) {
      var actor = "You";
    } else {
      var actor = this.props.item.actor;
    }
    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-12 clearfix">
          <span className="inline">
            <a className="text-master" href={this.props.item.url}>
              <strong>{actor}</strong>
            </a>
            <span className="verb p-l-5">
              shared a note
            </span>
          <span className="date p-l-10 fs-11 text-danger">{moment(Date.parse(this.props.item.created_at)).fromNow()}</span>
          </span>
        </li>
      );
  }
});