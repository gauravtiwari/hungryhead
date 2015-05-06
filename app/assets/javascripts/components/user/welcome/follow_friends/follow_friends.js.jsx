var FollowFriends = React.createClass({

  getInitialState: function() {
    return {
      friends: [],
      next_page: null
    }
  },

  componentDidMount: function() {
    if(this.isMounted()){
      this.fetchFriends();
    }

  },

  buildElements: function(friends) {
    var elements = [];
    _.map(friends, function(friend){
      elements.push(<Friend friend={friend} key={friend.uuid} />)
    });
    return elements;
  },

  loadMoreFriends: function() {
    if(!this.state.done) {
      $.getJSON(this.props.path + "?page=" + this.state.next_page, function(data, textStatus) {
        var new_elements = this.buildElements(data.friends)
        this.setState({
          next_page: data.meta.next_page,
          isInfiniteLoading: false,
          friends: this.state.friends.concat(new_elements)
        });

        if(data.meta.next_page === null) {
          this.setState({
            done: true,
            isInfiniteLoading: false
          });
        }
      }.bind(this));
    }
  },

  handleInfiniteLoad: function() {
    if(this.state.next_page != null) {
      this.loadMoreFriends();
    }
  },

  elementInfiniteLoad: function() {
    return;
  },


  fetchFriends: function(){
    $.ajaxSetup ({
        cache: false
    });
    $.getJSON(this.props.path, function(json, textStatus) {
      this.setState({
        friends: this.buildElements(json.friends),
        next_page: json.meta.next_page
    });
    }.bind(this));
  },

  render: function() {
    return (
      <div>
      <ul className="no-style friends-list full-border-light m-t-15 full-border-light-bottom">
        <Infinite elementHeight={45}
         containerHeight={400}
         infiniteLoadBeginBottomOffset={300}
         onInfiniteLoad={this.handleInfiniteLoad}
         loadingSpinnerDelegate={this.elementInfiniteLoad()}
         isInfiniteLoading={this.state.isInfiniteLoading}
         >
          {this.state.friends}
        </Infinite>
      </ul>
    </div>
    );
  }
});