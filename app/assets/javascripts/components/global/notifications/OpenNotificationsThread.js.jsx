var OpenNotificationsThread = React.createClass({

  getInitialState: function () {
    return {
      loading: false,
      active: false,
      unread_notifications_count: this.props.unread_notifications_count
    };
  },

  componentDidMount: function() {
    if(this.isMounted()){
      if(channel) {
        channel.bind('new_notifications_count', function(data){
          this.setState({unread_notifications_count: data.data});
        }.bind(this));
      }
    }

  },

  openNotifications: function() {
    this.setState({loading: true});
    if(!this.state.active) {
        $('body').append($('<div>', {class: 'notifications_panel', id: 'notifications_panel'}));
        React.render(<FriendsNotifications key={Math.random()} path={this.props.path} channel_event={this.props.channel_event} />,
             document.getElementById('notifications_panel'));
       ReactRailsUJS.mountComponents();
       $('#notificationsPanel').addClass('open');
       $('body').toggleClass('show-collaboration');
       if(this.state.unread_notifications_count > 0 ) {
        this.clearCounter();
       }
    } else {
        $('#notificationsPanel').removeClass('open');
        $('body').toggleClass('show-collaboration');
    }
  },

  clearCounter: function() {
    $.post(Routes.mark_all_as_read_notifications_path(), function(json, textStatus) {
        this.setState({unread_notifications_count: json.count});
    }.bind(this));
  },

  render: function() {
    if(this.state.unread_notifications_count > 0 ) {
     var thread_count = <span className="bubble font-arial bold">{this.state.unread_notifications_count}</span>
    }

    return(
        <a href="javascript:;" onClick={this.openNotifications} id="notification-center" className="fa fa-globe p-r-10 fs-22 text-brand">
          {thread_count}
        </a>
      )
  }
});
