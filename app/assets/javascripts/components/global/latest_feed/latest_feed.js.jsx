var SetIntervalMixin = {
    componentWillMount: function() {
        this.intervals = [];
    },
    setInterval: function(fn, ms) {
        this.intervals.push(setInterval(fn, ms));
    },
    componentWillUnmount: function() {
        this.intervals.forEach(clearInterval);
    }
};
var LatestFeed = React.createClass({
  getInitialState: function(){
    return {
      feed: []
    };
  },

  componentDidMount: function() {
    if(this.isMounted()){
      this.fetchNotifications();
      var feed_channel = pusher.subscribe(this.props.channel_name);
      if(feed_channel) {
        feed_channel.bind('new_feed_item', function(data){
          var newState = React.addons.update(this.state, {
              feed : {
                $unshift : [data.data]
              }
          });
          this.setState(newState);
          $("#feed_"+data.data.id).effect('highlight', {color: '#f7f7f7'} , 5000);
        }.bind(this));
      }
    }

  },

  fetchNotifications: function(){
    $.getJSON(this.props.path, function(json, textStatus) {
      this.setState({feed: json});
    }.bind(this));
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
      } else if(item.verb === "noted"){
        return <LatestFeedNoteItem key={Math.random()} item={item} />
      }
    });

    return(
        <ul className="idea-latest-activities no-style no-padding">
          {latest_feed_items}
        </ul>
      );
  }
});