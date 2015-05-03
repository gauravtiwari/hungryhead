
var LatestFeedNoteItem = React.createClass({
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
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-13 clearfix">
          <span className="inline text-master">
            <a className="text-complete" href={this.props.item.actor.url}>
              <div className="thumbnail-wrapper fs-11 d24 user-pic circular inline m-r-10">
                {placeholder}
              </div>
              <strong>{actor}</strong>
            </a>
            <span className="verb p-l-5">
              shared a note
            </span>
          </span>
        </li>
      );
  }
});