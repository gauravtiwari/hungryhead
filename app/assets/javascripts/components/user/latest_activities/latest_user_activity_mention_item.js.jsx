
var LatestUserActivityMentionItem = React.createClass({
  render: function() {
    var html_id = "feed_"+this.props.item.id;

    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-13 clearfix">
          <span className="inline text-master">
            <span className="verb p-l-5 inline b-b b-grey p-b-5">
              <i className="fa fa-at"></i> {this.props.item.verb}
            </span>
            <span className="recipient p-l-5 inline">
              <a href={this.props.item.recipient.recipient_url}>{this.props.item.recipient.recipient_name.split(' ')[0]}</a>
            </span>
            <span className="recipient p-l-5 inline">
              in a comment
            </span>
          </span>
        </li>
      );
  }
});