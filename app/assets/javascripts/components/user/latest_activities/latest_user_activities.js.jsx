var LatestUserActivities = React.createClass({
  getInitialState: function(){
    return {
      feed: [],
      next_page: null,
      closed: true,
      count: null
    };
  },

  componentDidMount: function() {
    if(this.isMounted()){
      this.fetchNotifications();
      var feed_channel = pusher.subscribe(this.props.channel_name);
      if(feed_channel) {
        feed_channel.bind('new_feed_item', function(data){
          var new_item = this.buildElements([data.data])
          var newState = React.addons.update(this.state, {
              activities : {
                $unshift : new_item
              }
          });
          this.setState(newState);
          $("#feed_"+data.data.id).effect('highlight', {color: '#f7f7f7'} , 5000);
          $("#feed_"+data.data.id).addClass('animated fadeInDown');
        }.bind(this));
      }
    }

  },

  fetchNotifications: function(){
    $.getJSON(this.props.path, function(json, textStatus) {
      this.setState({
        activities: json.items,
        next_page: json.next_page
    });
    }.bind(this));
  },

  render: function(){

    var activities = _.map(this.state.activities, function(item){
      if(item.verb === "invested") {
        return <LatestUserActivityInvestmentItem key={Math.random()} item={item} />;
      } else if(item.verb === "followed") {
        return <LatestUserActivityFollowItem key={Math.random()} item={item} />;
      } else if(item.verb === "feedbacked") {
        return <LatestUserActivityFeedbackItem key={Math.random()} item={item} />;
      } else if(item.verb === "pitched"){
        return <LatestUserActivityIdeaItem key={Math.random()} item={item} />;
      } else if(item.verb === "joined"){
        return <LatestUserActivityJoinItem key={Math.random()} item={item} />;
      } else if(item.verb === "commented"){
        return <LatestUserActivityCommentItem key={Math.random()} item={item} />;
      } else if(item.verb === "badged"){
        return <LatestUserActivityBadgeItem key={Math.random()} item={item} />;
      } else if(item.verb === "voted"){
        return <LatestUserActivityVoteItem key={Math.random()} item={item} />;
      } else if(item.verb === "mentioned"){
        return <LatestUserActivityMentionItem key={Math.random()} item={item} />;
      } else if(item.verb === "posted"){
        return <LatestUserActivityPostItem key={Math.random()} item={item} />;
      } else if(item.verb === "shared"){
        return <LatestUserActivityShareItem key={Math.random()} item={item} />;
      }
    });

    return(
      <div className="widget-11-2 panel profile-cards no-margin">
          <div className="panel-heading">
           <div className="panel-title b-b b-grey p-b-5">
            <i className="fa fa-bars text-danger"></i> Latest activities
            </div>
          </div>
          <div className="panel-body no-margin no-padding">
             <ul className="p-l-20 p-r-20 no-style no-padding no-margin">
               {activities}
             </ul>
          </div>
      </div>

      );
  }
});