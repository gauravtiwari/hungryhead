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
        React.render(<LatestFeed key={Math.random()} path={this.props.path} channel_name={this.props.channel_name} />,
             document.getElementById('render_notifications'));
       parentdrop.removeClass('open');
       parentdrop.addClass('open');
       $('body').addClass('stop-scrolling');
    } else {
        parentdrop.removeClass('open');
        $('body').removeClass('stop-scrolling');
    }
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
