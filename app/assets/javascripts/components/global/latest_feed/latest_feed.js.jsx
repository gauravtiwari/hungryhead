
var LatestFeed = React.createClass({

  getInitialState: function(){
    var feed = JSON.parse(this.props.feed);
    return {
      feed: feed.activities
    };
  },

  componentDidMount: function() {
    var self = this;
    var feed_channel = pusher.subscribe(this.props.channel_name);
    if(feed_channel) {
      feed_channel.bind('new_feed_item', function(data){
        var items =  self.state.feed.concat(data.data.item);
        self.setState({feed: items.reverse()});
      });
    }
  },
  render: function(){
    var latest_feed_items = _.map(this.state.feed, function(item){
      if(item.verb === "invested") {
        return <LatestFeedInvestmentItem key={Math.random()} item={item} />
      } else if(item.verb === "followed") {
        return <LatestFeedFollowItem key={Math.random()} item={item} />
      } else if(item.verb === "feedbacked") {
        return <LatestFeedFeedbackItem key={Math.random()} item={item} />
      } else if(item.verb === "pitched"){
        return <LatestFeedIdeaItem key={Math.random()} item={item} />
      } else if(item.verb === "joined"){
        return <LatestFeedJoinItem key={Math.random()} item={item} />
      } else if(item.verb === "commented"){
        return <LatestFeedCommentItem key={Math.random()} item={item} />
      } else if(item.verb === "voted"){
        return <LatestFeedVoteItem key={Math.random()} item={item} />
      } else if(item.verb === "mentioned"){
        return <LatestFeedMentionItem key={Math.random()} item={item} />
      }
    });

    return(
        <ul className="idea-latest-activities no-style no-padding p-l-15 p-r-15">
          {latest_feed_items}
        </ul>
      );
  }
});