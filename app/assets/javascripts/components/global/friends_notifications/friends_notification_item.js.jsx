
var FriendsNotificationItem = React.createClass({

  loadActivity: function() {
    $.getScript(Routes.activity_path(this.props.item.activity_id));
  },

  render: function() {
   var html_id = "feed_"+this.props.item.id;

    return (<li className="alert-list padding-10 overflow-hidden" id={html_id} onClick={this.loadActivity}>
               <div className="p-l-10 col-xs-height col-middle col-xs-9 fs-13">
                 <span className="text" dangerouslySetInnerHTML={{__html: this.props.item.html}}>
                 </span>
                 <span className="meta clearfix">
                  <span className="text-master hint-text inline fs-12">{moment(this.props.item.updated_at).fromNow()}</span>
                 </span>
               </div>
             </li>
      );
  }
});