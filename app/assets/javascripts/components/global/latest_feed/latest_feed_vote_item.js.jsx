
var LatestFeedVoteItem = React.createClass({
  render: function() {
    var html_id = "feed_"+this.props.item.id;

    if(window.currentUser.name === this.props.item.actor.actor_name) {
      var actor = "You";
    } else {
      var actor = this.props.item.actor.actor_name;
    }

    if(this.props.item.actor.actor_avatar) {
      var placeholder = <img src={this.props.item.actor.actor_avatar} width="32" height="32" />
    } else {
      var placeholder = <span className="placeholder no-padding bold text-white">{this.props.item.actor.actor_name_badge}
              </span>;
    }

    if(window.currentUser.name === this.props.item.recipient.recipient_user_name) {
      var recipient = "on " + this.props.item.recipient.recipient_user_name.split(' ')[0] + ' ' + this.props.item.recipient.recipient_type;
    } else {
      var recipient = "on his own "+this.props.item.recipient.recipient_type;
    }

    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-12 clearfix">
          <span className="inline">
            <a className="text-master" href={this.props.item.actor.url}>
              <div className="thumbnail-wrapper d32 user-pic circular inline m-r-10">
                {placeholder}
              </div>
              <strong>{actor}</strong>
            </a>
            <span className="verb p-l-5">
              {this.props.item.verb}
            </span>
            <span className="recipient p-l-5">
              {recipient}
            </span>
          </span>
        </li>
      );
  }
});