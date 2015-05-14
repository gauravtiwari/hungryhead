
var LatestUserActivityBadgeItem = React.createClass({
  render: function() {
    var html_id = "feed_"+this.props.item.id;
    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-13 clearfix">
          <span className="inline text-master">
            <span className="verb b-b b-grey p-b-5">
              <i className="fa fa-certificate"></i>
            </span>
            <span className="recipient p-l-5">
             {this.props.item.recipient.badge_description}
            </span>
          </span>
        </li>
      );
  }
});