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
    $.Pages.init();
    this.setState({active: !this.state.active});
    var parentdrop = $('.notification-list').find('.notification-dropdown');
    if(!this.state.active) {
        React.render(<LatestFeed key={Math.random()} path={this.props.path} channel_event={this.props.channel_event} />,
             document.getElementById('render_notifications'));
       ReactRailsUJS.mountComponents();
       parentdrop.removeClass('open');
       parentdrop.addClass('open');
       if(this.state.unread_notifications_count > 0 ) {
        this.clearCounter();
       }
       $('body').addClass('stop-scrolling');
    } else {
        parentdrop.removeClass('open');
        $('body').removeClass('stop-scrolling');
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
        <a href="javascript:;" onClick={this.openNotifications} id="notification-center" className="fa fa-globe b-r b-grey p-r-10 b-dashed fs-22 text-brand">
          {thread_count}
        </a>
      )
  }
});
