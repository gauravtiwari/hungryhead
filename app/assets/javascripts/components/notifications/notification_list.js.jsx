/**
 * @jsx React.DOM
 */
var NotificationList = React.createClass({

  getInitialState: function () {
     return {
      notifications: [],
      meta: [],
      done: false,
      notifications_count: 0,
      isInfiniteLoading: false,
      loading: false
    };
  },

  loadNotifications: function() {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
     $.getJSON(this.props.path, function(data) {
      this.setState({
        notifications: this.buildElements(data.notifications),
        meta: data.meta,
        loading: false,
        notifications_count: data.notifications_count
      });
    }.bind(this));
  },

  buildElements: function(notifications) {
      var elements = [];
      _.map(notifications, function(notification){
        elements.push(<NotificationItem key={Math.random()} notification={notification} />)
      });
      return elements;
  },

  loadMoreNotifications: function() {
    var self = this;
    if(!self.state.done) {
      $.ajax({
        url: this.props.path + "?page=" + this.state.meta.next_page,
        success: function(data) {
          var notifications = self.state.notifications;
          var new_elements = self.buildElements(data.notifications)
          self.setState({meta: data.meta, isInfiniteLoading: false,  notifications: self.state.notifications.concat(new_elements)});
          if(self.state.meta.next_page === null) {
            self.setState({done: true, isInfiniteLoading: false});
            event.stopPropagation();
          }
        }
      });
    }
  },

  componentDidMount: function() {
    if(this.isMounted()){
      var self = this;
      this.loadNotifications();
    }
  },

  markAsRead: function() {
    $.post(Routes.mark_as_read_notifications_path(), function(data){
      this.setState({
          notifications: this.buildElements(data.notifications),
          meta: data.meta,
          done: false,
          notifications_count: data.notifications_count
        });
       var options =  {
        content: "All notifications are marked read",
        style: "snackbar", // add a custom class to your snackbar
        timeout: 3000 // time in milliseconds after the snackbar autohides, 0 is disabled
      }
      $.snackbar(options);
    
    }.bind(this));
  },

  handleInfiniteLoad: function() {
    if(this.state.meta.next_page != null) {
      this.loadMoreNotifications();
    }
  },

  elementInfiniteLoad: function() {
    return;
  },

  render: function() {
    
    return(
      <div>
        <div className="notification-section-header clearfix">
          <a href={Routes.notifications_path()}>Notifications ({this.state.notifications_count})</a>
           <div className="show-all"><a onClick={this.markAsRead}> Mark all as read </a></div>
        </div>
       <div className="notifications-box live">
         <div className="link-list">
              <Infinite elementHeight={65}
                 containerHeight={300}
                 infiniteLoadBeginBottomOffset={250}
                 onInfiniteLoad={this.handleInfiniteLoad}
                 loadingSpinnerDelegate={this.elementInfiniteLoad()}
                 isInfiniteLoading={this.state.isInfiniteLoading}
                 >
                  {this.state.notifications}
                 </Infinite>
          </div>
        </div>
      </div>
        );
      
  }

});
