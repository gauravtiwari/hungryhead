var EventJoinButton = React.createClass({
  getInitialState: function(){
    return {
      attending: this.props.data.attending,
      event: this.props.data
    };
  },

  handleJoin: function() {
    this.setState({attending: !this.state.attending});
    $.ajaxSetup({ cache: false });
    $.post(Routes.event_join_path(this.state.event.event_slug), function(data, textStatus, xhr) {
      this.setState({
        attending: data.attending
      });
      $.pubsub('publish', 'update_event_attendees', data.attendees);
      $.pubsub('publish', 'update_attendees_listing', data);
    }.bind(this));
  },

  handleDelete: function() {
    this.setState({attending: !this.state.attending});
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: Routes.event_leave_path(this.state.event.event_slug),
      type: 'DELETE',
      dataType: 'json'
    })
    .done(function(data) {
      this.setState({attending: data.attending});
      $.pubsub('publish', 'update_event_attendees', data.attendees);
      $.pubsub('publish', 'update_attendees_listing', data);
    }.bind(this))
    .fail(function(xhr, status, err) {
      this.setState({attending: !this.state.attending});
      var errors = JSON.parse(xhr.responseText);
    }.bind(this))

  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'main-button pointer bold m-r-10': true,
      'published': this.state.attending
    });


    if(this.state.attending) {
      var icon = <span><i className="fa fa-check-circle"></i> Going</span>;
    } else {
      var icon = <span><i className="fa fa-user-plus"></i> Join</span>;
    }

    return (
      <div className="JoinEventButton">
        <a className={classes} rel="nofollow" onClick={this.state.attending? this.handleDelete : this.handleJoin}>
          {icon}
        </a>
      </div>
    );
  }
});