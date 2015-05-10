
var LatestIdeas = React.createClass({

  getInitialState: function() {
    return {
      list: [],
      type: null,
      current_path: this.props.path,
      next_page: null,
      done: false
    }
  },

  componentDidMount: function() {
    if(this.isMounted()) {
      this.fetchList();
    }
  },

  loadTrending: function() {
    this.setState({current_path: Routes.trending_ideas_path(), done: false});
    $.getJSON(Routes.trending_ideas_path(), function(json, textStatus) {
      this.setState({
        list: this.buildElements(json.list),
        type: json.type,
        next_page: json.next_page
      });
    }.bind(this));
  },

  loadPopular: function() {
    this.setState({current_path: Routes.popular_ideas_path(), done: false});
    $.getJSON(Routes.popular_ideas_path(), function(json, textStatus) {
      this.setState({
        list: this.buildElements(json.list),
        type: json.type,
        next_page: json.next_page
      });
    }.bind(this));
  },

  buildElements: function(feed) {
      var elements = [];
      _.map(feed, function(item){
        elements.push(<LatestIdeasItem key={item.id} item={item} />);
      });
      return elements;
  },

  loadMoreItems: function() {
    var self = this;
    if(!self.state.done) {
      $.ajax({
        url: this.state.current_path + "?page=" + this.state.next_page,
        success: function(data) {
          var new_elements = self.buildElements(data.list)
          self.setState({next_page: data.next_page, isInfiniteLoading: false,  list: self.state.list.concat(new_elements)});
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
      this.loadMoreItems();
    }
  },

  elementInfiniteLoad: function() {
    return;
  },

  resetList: function() {
    this.setState({current_path: Routes.latest_ideas_path(), done: false});
    $.getJSON(Routes.latest_ideas_path(), function(json, textStatus) {
      this.setState({
        list: this.buildElements(json.list),
        type: json.type,
        next_page: json.next_page
      });
    }.bind(this));
  },

  fetchList: function(){
    $.getJSON(this.state.current_path, function(json, textStatus) {
      this.setState({
        list: this.buildElements(json.list),
        type: json.type,
        next_page: json.next_page
    });
    }.bind(this));
  },

  render: function() {

    return (
      <div className="widget-11-2 m-b-10 panel no-border no-margin">
          <div className="panel-heading">
           <div className="panel-title">
            {this.state.type}
            </div>
            <div className="panel-controls">
                <ul>
                    <li className="hidden-xlg">
                      <div className="dropdown">
                        <a data-target="#" className="pointer" href="#" data-toggle="dropdown" aria-haspopup="true" role="button" aria-expanded="false">
                          <i className="portlet-icon portlet-icon-settings"></i>
                        </a>
                        <ul className="dropdown-menu pull-right" role="menu">
                          <li>
                            <a className="pointer" onClick={this.loadTrending}>Trending Idea</a>
                          </li>
                          <li>
                            <a className="pointer" onClick={this.loadPopular}>Popular Ideas</a>
                          </li>
                        </ul>
                      </div>
                    </li>
                    <li>
                      <a data-toggle="refresh" className="portlet-refresh text-black pointer" onClick={this.resetList}>
                          <i className="portlet-icon portlet-icon-refresh"></i>
                      </a>
                    </li>
                </ul>
            </div>
          </div>
          <div className="panel-body no-padding full-border-light">
            <ul className="trending-list p-t-10 no-style" ref="trendingList">
              <Infinite elementHeight={45}
              containerHeight={200}
              infiniteLoadBeginBottomOffset={150}
              onInfiniteLoad={this.handleInfiniteLoad}
              loadingSpinnerDelegate={this.elementInfiniteLoad()}
              isInfiniteLoading={this.state.isInfiniteLoading}
              >
               {this.state.list}
              </Infinite>
            </ul>
          </div>
      </div>
    );
  },

  componentDidUpdate: function() {
    this._scrollToBottom();
  },

  _scrollToBottom: function() {
    var ul = this.refs.trendingList.getDOMNode();
    ul.scrollTop = ul.scrollHeight;
  },
});