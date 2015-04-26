
var LatestFeedInvestmentItem = React.createClass({
  mixins: [SetIntervalMixin],
  componentDidMount: function() {
    var interval = this.props.item.created_at || 60000;
    this.setInterval(this.forceUpdate.bind(this), interval);
  },
  render: function() {
    var html_id = "feed_"+this.props.item.id;
    return (
        <li id={html_id} className="p-l-15 p-r-15 p-b-10 p-t-10 fs-12 clearfix">
          <span className="inline">
            <a className="text-master m-r-5 hint-text" href={this.props.item.url}>
              <strong>{this.props.item.actor}</strong>
            </a>
            <span className="icon p-l-5"><i className="fa fa-dollar"></i></span>
            <span className="verb p-l-5">
              {this.props.item.verb}
            </span>
            <span className="recipient p-l-5">
              in {this.props.item.recipient}
            </span>
          <span className="date p-l-10 fs-11 text-danger">{moment(Date.parse(this.props.item.created_at)).fromNow()}</span>
          </span>
        </li>
      );
  }
});