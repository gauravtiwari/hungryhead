/**
 * @jsx React.DOM
 */

var NotificationItem = React.createClass({

  loadActivity: function() {
    $.get(Routes.activity_path(2), function(data){
      $('body').find('#activity_modal').remove();
      $('body').append($('<div>', {class: 'activity_modal', id: 'activity_modal'}));
      $('#activity_modal').html(data);
      this.setState({loading: false});
      $('#activityModalPopup').modal('show');
      ReactRailsUJS.mountComponents();
      $('#activity_modal .activity-box').height($('.modal').height() - 155);
      $('#activity_modal .activity-box').css('overflow', 'scroll');
    }.bind(this));
  },

  render: function() {

    var cx = React.addons.classSet;
    var conversation_status_classes = cx({
      'notification-item clearfix': true,
      'read': this.props.notification.is_read,
      'unread': !this.props.notification.is_read
    });

    return (
      <div className={conversation_status_classes} onClick={this.loadActivity}>
        <div className="user-avatar margin-right">
          <img src={this.props.notification.sender_avatar}  width="30px"/>
        </div>
      <div className="notification-post">
        <div className="item-content">
          <div className="main-post-content">
            <div dangerouslySetInnerHTML={{__html: this.props.notification.body}}></div>
            <span className=""><em>{moment(this.props.notification.created_at).fromNow()}</em></span>
        </div>
        </div>
      </div>
      </div>

      )

  }

});
