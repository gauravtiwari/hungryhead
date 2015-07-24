
var LatestUserActivityItem = React.createClass({

  loadActivity: function() {
    $.getScript(Routes.activity_path(this.props.item.activity_id));
  },

  render: function() {
    var html_id = "feed_"+this.props.item.id;
    return (
        <li id={html_id} className="pointer p-b-10 p-t-10 fs-13 clearfix">
         <div className="inline" dangerouslySetInnerHTML={{__html: this.props.item.html}}>
         </div>
        </li>
      );
  }
});