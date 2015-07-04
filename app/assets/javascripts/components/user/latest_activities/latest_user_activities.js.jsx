
var LatestUserActivities = React.createClass({

  getInitialState: function(){
    return {
      activities: this.props.activities,
      closed: true,
      count: null
    };
  },

  componentDidMount: function() {
    if(this.isMounted()){
      if(channel) {
        channel.bind('new_feed_item', function(data){
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
      } else if(item.verb === "commented"){
        return <LatestUserActivityCommentItem key={Math.random()} item={item} />;
      } else if(item.verb === "voted"){
          return <LatestUserActivityVoteItem key={Math.random()} item={item} />;
      } else if(item.verb === "mentioned"){
        return <LatestUserActivityMentionItem key={Math.random()} item={item} />;
      }
    });

    if(activities.length > 0) {
      var content  = activities;
    } else {
      var content = <div className="text-center fs-22 font-opensans text-master light p-t-40 p-b-40">
          <i className="fa fa-list"></i>
          <span className="clearfix">No latest activities</span>
        </div>;
    }

    return(
      <div className="widget-11-2 panel profile-cards no-margin no-border">
          <div className="panel-heading bg-light-blue-lightest m-b-10">
           <div className="panel-title b-b b-grey p-b-5">
            <i className="fa fa-bars text-danger"></i>  Latest activities
            </div>
          </div>
          <div className="panel-body no-margin no-padding p-b-15">
             <ul className="p-l-20 p-r-20 no-style no-padding no-margin">
               {content}
             </ul>
          </div>
      </div>

      );
  }
});