
var LatestUserActivityPostItem = React.createClass({

  loadActivity: function() {
    $.getScript(Routes.activity_path(this.props.item.activity_id));
  },


  render: function() {
    var html_id = "feed_"+this.props.item.id;

    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-13 clearfix" onClick={this.loadActivity}>
          <span className="inline text-master">
            <span className="verb b-b b-grey p-b-5">
              <i className="fa fa-share"></i> shared a <a onClick={this.loadActivity}>post</a>
            </span>
          </span>
        </li>
      );
  }
});