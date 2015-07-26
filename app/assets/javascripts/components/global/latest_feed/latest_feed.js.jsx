
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
    var data = this.props.notifications
    return {
      feed: [],
      next_page: undefined,
      closed: true,
      loading: true,
      count: null
    }
  },

  componentDidMount: function() {
    if(this.isMounted()){
      this.fetchNotifications();
      if(channel) {
        channel.bind(this.props.channel_event, function(data){
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
        elements.push(<LatestFeedItem key={Math.random()} item={item} />)
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
        next_page: json.next_page,
        loading: false
      });
    }.bind(this));
  },

  render: function(){

    if(this.state.loading) {
      var content = <div className="no-content hint-text"><i className="fa fa-spinner fa-spin"></i></div>;
    } else if(this.state.feed.length > 0) {
      var content =  <Infinite elementHeight={60}
                containerHeight={250}
                infiniteLoadBeginBottomOffset={200}
                onInfiniteLoad={this.handleInfiniteLoad}
                loadingSpinnerDelegate={this.elementInfiniteLoad()}
                isInfiniteLoading={this.state.isInfiniteLoading}
                >
                 {this.state.feed}
                </Infinite>;
    } else {
      var content = <div className="text-center fs-22 font-opensans text-master light p-t-40 p-b-40">
          <i className="fa fa-list"></i>
          <span className="clearfix">No latest activities</span>
        </div>;
    }

    return(
      <div className="widget-11-2 panel b-b b-light-grey no-margin">
          <div className="panel-heading bg-light-blue-lightest">
            <div className="panel-title">
              <span className="fa fa-list text-danger"></span> Latest Activities
            </div>
          </div>
          <div className="panel-body full-border-light no-margin auto-overflow no-padding">
           <div>
             <ul className="latest-activities scrollable no-style no-padding no-margin">
              {content}
             </ul>
            </div>
          </div>
      </div>

      );
  }
});