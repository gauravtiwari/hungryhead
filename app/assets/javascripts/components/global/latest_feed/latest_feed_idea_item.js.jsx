
var LatestFeedIdeaItem = React.createClass({

  loadActivity: function() {
    $.getScript(Routes.activity_path(this.props.item.activity_id));
  },

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
    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-13 clearfix" onClick={this.loadActivity}>
          <span className="inline">
            <div className="thumbnail-wrapper d32 fs-11 user-pic circular inline m-r-10">
              {placeholder}
            </div>
            <strong className="inline p-r-5 text-black">{actor}</strong>
            {this.props.item.verb} {this.props.item.recipient.recipient_name}
          </span>
        </li>
      );
  }
});