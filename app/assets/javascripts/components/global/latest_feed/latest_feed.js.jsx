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
              feed : {
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

  buildElements: function(feed) {
      var elements = [];
      _.map(feed, function(item){
        if(item.verb === "invested") {
          elements.push(<LatestFeedInvestmentItem key={Math.random()} item={item} />)
        } else if(item.verb === "followed") {
          elements.push(<LatestFeedFollowItem key={Math.random()} item={item} />)
        } else if(item.verb === "feedbacked") {
          elements.push(<LatestFeedFeedbackItem key={Math.random()} item={item} />)
        } else if(item.verb === "pitched"){
          elements.push(<LatestFeedIdeaItem key={Math.random()} item={item} />)
        } else if(item.verb === "joined"){
          elements.push(<LatestFeedJoinItem key={Math.random()} item={item} />)
        } else if(item.verb === "commented"){
          elements.push(<LatestFeedCommentItem loadActivity={this.loadActivity} key={Math.random()} item={item} />)
        } else if(item.verb === "voted"){
          elements.push(<LatestFeedVoteItem key={Math.random()} item={item} />)
        } else if(item.verb === "mentioned"){
          elements.push(<LatestFeedMentionItem key={Math.random()} item={item} />)
        } else if(item.verb === "noted"){
          elements.push(<LatestFeedNoteItem key={Math.random()} item={item} />)
        } else if(item.verb === "shared"){
          elements.push(<LatestFeedShareItem key={Math.random()} item={item} />)
        }
      });
      return elements;
  },

  loadMoreNotifications: function() {
    var self = this;
    if(!self.state.done) {
      $.ajax({
        url: this.props.path + "?page=" + this.state.next_page,
        success: function(data) {
          var feed = self.state.feed;
          var new_elements = self.buildElements(data.items)
          self.setState({next_page: data.next_page, isInfiniteLoading: false,  feed: self.state.feed.concat(new_elements)});
          if(self.state.next_page === null) {
            self.setState({done: true, isInfiniteLoading: false});
            event.stopPropagation();
          }
        }
      });
    }
  },

  handleInfiniteLoad: function() {
    if(this.state.next_page != null) {
      this.loadMoreNotifications();
    }
  },

  elementInfiniteLoad: function() {
    return;
  },


  fetchNotifications: function(){
    $.getJSON(this.props.path, function(json, textStatus) {
      this.setState({
        feed: this.buildElements(json.items),
        next_page: json.next_page
    });
    }.bind(this));
  },

  render: function(){

    return(
      <div className="widget-11-2 panel b-b b-light-grey no-margin">
          <div className="panel-heading">
           <div className="panel-title">
            Latest activities
            </div>
          </div>
          <div className="panel-body full-border-light no-margin auto-overflow no-padding">
           <div>
             <ul className="idea-latest-activities no-style no-padding no-margin">
               <Infinite elementHeight={45}
                containerHeight={250}
                infiniteLoadBeginBottomOffset={200}
                onInfiniteLoad={this.handleInfiniteLoad}
                loadingSpinnerDelegate={this.elementInfiniteLoad()}
                isInfiniteLoading={this.state.isInfiniteLoading}
                >
                 {this.state.feed}
                </Infinite>
             </ul>
            </div>
          </div>
      </div>

      );
  }
});