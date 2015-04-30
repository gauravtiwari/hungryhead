
var LatestFeedFeedbackItem = React.createClass({
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
    if(this.props.item.actor_avatar) {
      var placeholder = <img src={this.props.item.actor_avatar} width="32" height="32" />
    } else {
      var placeholder = <span className="placeholder no-padding bold text-white">{this.props.item.actor_name_badge}
              </span>;
    }
    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-12 clearfix">
          <span className="inline">
            <a className="text-master" href={this.props.item.url}>
              <div className="thumbnail-wrapper d32 user-pic circular inline m-r-10">
                {placeholder}
              </div>
              <strong>{actor}</strong>
            </a>
            <span className="verb p-l-5">
             left a feedback for
            </span>
            <span className="recipient p-l-5">
               {this.props.item.recipient}
            </span>
          <span className="date p-l-10 fs-11 text-danger">{moment(Date.parse(this.props.item.created_at)).fromNow()}</span>
          </span>
        </li>
      );
  }
});