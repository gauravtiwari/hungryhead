
var LatestUserActivityVoteItem = React.createClass({
  render: function() {
    var html_id = "feed_"+this.props.item.id;

    if(window.currentUser.name === this.props.item.recipient.recipient_user_name) {
      if(this.props.item.recipient.recipient_type === "idea") {
        var recipient = "on your idea "+this.props.item.recipient.recipient_name;
      } else {
        var recipient = "on your "+this.props.item.recipient.recipient_type;
      }
    } else {
      if(this.props.item.recipient.recipient_type === "idea") {
        var recipient = "on " + this.props.item.recipient.recipient_name;
      } else {
        var recipient = "on a " + this.props.item.recipient.recipient_type;
      }
    }

    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-13 clearfix">
          <span className="inline text-master">
            <span className="verb b-b b-grey">
              <i className="fa fa-thumbs-up"></i> {this.props.item.verb}
            </span>
            <span className="recipient p-l-5">
              {recipient}
            </span>
          </span>
        </li>
      );
  }
});