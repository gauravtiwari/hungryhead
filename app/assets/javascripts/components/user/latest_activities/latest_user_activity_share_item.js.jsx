
var LatestUserActivityShareItem = React.createClass({
  render: function() {
    var html_id = "feed_"+this.props.item.id;

    if(window.currentUser.name === this.props.item.recipient.recipient_user_name) {
      var recipient = "your "+ this.props.item.recipient.recipient_type + ' ' + <a href={this.props.item.recipient_url}>this.props.item.recipient.recipient_name</a>;
    } else {
      var recipient = <a href={this.props.item.recipient_url}>this.props.item.recipient.recipient_user_name.split(' ')[0]</a> + ' ' + this.props.item.recipient.recipient_type;
    }

    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-13 clearfix">
          <span className="inline text-master">
            <span className="verb b-b b-grey">
              <i className="fa fa-share"></i> {this.props.item.verb}
            </span>
            <span className="recipient p-l-5">
              {recipient}
            </span>
          </span>
        </li>
      );
  }
});