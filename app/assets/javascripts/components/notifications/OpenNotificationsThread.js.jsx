/**
 * @jsx React.DOM
 */

var OpenNotificationsThread = React.createClass({

  getInitialState: function () {
    return {
      loading: false,
      active: false, 
      unread_notifications_count: this.props.unread_notifications_count
    };
  },

  openNotifications: function() {
    this.setState({loading: true});
    this.setState({active: !this.state.active});
    var parentdrop = $('li.drop.notification-threads').find('.dropdown');
    if(!this.state.active) {
        React.render(
          <NotificationList key={Math.random()} path={this.props.path} />,
          document.getElementById('notifications-threads-section')
        );
        parentdrop.removeClass('active');
        parentdrop.addClass('active');
        $('body').addClass('stop-scrolling');
    } else {
        parentdrop.removeClass('active');
        $('body').removeClass('stop-scrolling');
    }
  },

  render: function() {
    if(this.state.unread_notifications_count > 0 ) {
     var thread_count = <span>{this.state.unread_notifications_count}</span>
    }

    return(
        <a className="open-notifications-thread" onClick={this.openNotifications}>
            <i className="ion-earth"></i>
            {thread_count}
        </a>
      )
  }
});
