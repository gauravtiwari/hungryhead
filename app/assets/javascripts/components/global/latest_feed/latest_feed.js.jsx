
var LatestFeed = React.createClass({

  getInitialState: function(){
    return {
      feed: this.props.feed
    };
  },

  componentDidMount: function() {
    var self = this;
    var idea_feed_channel = pusher.subscribe("feed-"+this.props.idea_id);
    if(idea_feed_channel) {
      idea_feed_channel.bind('new_feed_item', function(data){
        var items = data.data.item.reverse();
        self.setState({feed: items});
      });
    }
  },
  render: function(){
    var latest_feed_items = _.map(this.state.feed, function(item){
      if(item.verb === "invested") {
        return <LatestFeedInvestmentItem key={item.id} item={item} />
      } else if(item.verb === "followed") {
        return <LatestFeedFollowItem key={item.id} item={item} />
      } else {
        return <LatestFeedFeedbackItem key={item.id} item={item} />
      }
    });

    return(
        <ul className="idea-latest-activities no-style no-padding p-l-15 p-r-15">
          {latest_feed_items}
        </ul>
      );
  }
});