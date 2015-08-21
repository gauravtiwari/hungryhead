var EventStats = React.createClass({
  getInitialState: function(){
    return {
      spots: this.props.spots,
      comments: this.props.comments,
      attendees: this.props.attendees
    }
  },
  componentDidMount: function(){
    $.pubsub('subscribe', 'update_event_attendees', function(msg, data){
      this.setState({
        attendees: data
      })
    }.bind(this));
  },
  render: function() {
    return (
      <div className="event-stats-list no-border">
        <div className="col-sm-4 all-caps text-center">
           <span>Spots</span>
           <span className="text-brand displayblock text-center">
            {this.state.spots}
           </span>
         </div>
         <div className="col-sm-4 all-caps text-center">
           <span>Comments</span>
           <span className="text-brand displayblock text-center">
            {this.state.comments}
           </span>
         </div>
         <div className="col-sm-4 all-caps text-center">
           <span>Attending</span>
           <span className="text-brand displayblock text-center">
            {this.state.attendees}
           </span>
         </div>
        </div>
    );
  }
});