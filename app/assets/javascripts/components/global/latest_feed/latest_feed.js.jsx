
var LatestFeed = React.createClass({

  getInitialState: function(){
    return {
      feed: this.props.feed
    };
  },

  componentDidMount: function() {
    var self = this;
    var feed = this.state.feed;
    var feed_channel = pusher.subscribe(this.props.channel_name);
    if(feed_channel) {
      feed_channel.bind('new_feed_item', function(data){
        var items = feed.concat(data.data.item);
        self.setState({feed: items.reverse()});
      });
    }
  },
  render: function(){
    var latest_feed_items = _.map(this.state.feed, function(item){
      if(item.verb === "invested") {
        return <LatestFeedInvestmentItem key={item.id} item={item} />
      } else if(item.verb === "followed") {
        return <LatestFeedFollowItem key={item.id} item={item} />
      } else if(item.verb === "left a feedback") {
        return <LatestFeedFeedbackItem key={item.id} item={item} />
      }  else{
        return <LatestFeedIdeaItem key={item.id} item={item} />
      }
    });

    return(
        <ul className="idea-latest-activities no-style no-padding p-l-15 p-r-15">
          {latest_feed_items}
        </ul>
      );
  }
});