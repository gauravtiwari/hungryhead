
var LatestUserActivityShareItem = React.createClass({
  render: function() {
    var html_id = "feed_"+this.props.item.id;
    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-13 clearfix">
          <span className="inline text-master">
            <span className="verb b-b b-grey">
              <i className="fa fa-share"></i> {this.props.item.verb}
            </span>
            <span className="recipient p-l-5">
              <a href={this.props.item.recipient.recipient_url}>{this.props.item.recipient.recipient_name}</a>
            </span>
          </span>
        </li>
      );
  }
});