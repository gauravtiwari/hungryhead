
var LatestListings = React.createClass({

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

  buildElements: function(feed) {
      var elements = [];
      _.map(feed, function(item){
        elements.push(<LatestListingsItem key={Math.random()} item={item} />);
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
      <div className="widget-11-2 panel no-border p-b-10 no-margin bg-white">
          <div className="panel-heading">
           <div className="panel-title">
            {this.state.type}
            </div>
            <div className="panel-controls">
                <ul>
                    <li>
                      <a data-toggle="refresh" className="portlet-refresh text-black pointer" onClick={this.resetList}>
                          <i className="portlet-icon portlet-icon-refresh"></i>
                      </a>
                    </li>
                </ul>
            </div>
          </div>
          <div className="panel-body full-border-light no-padding">
            <ul className="trending-list p-t-10 no-style no-margin" ref="trendingList">
              <Infinite elementHeight={50}
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

});