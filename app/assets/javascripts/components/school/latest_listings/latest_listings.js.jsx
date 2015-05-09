
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
        elements.push(<LatestListingsItem key={item.id} item={item} />);
      });
      return elements;
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
      <div className="widget-11-2 panel no-border no-margin bg-white">
          <div className="panel-heading">
           <div className="panel-title">
            {this.state.type}
            </div>
            <div className="panel-controls">
                <ul>
                    <li>
                      <a data-toggle="refresh" className="portlet-refresh text-black pointer" onClick={this.fetchList}>
                          <i className="portlet-icon portlet-icon-refresh"></i>
                      </a>
                    </li>
                </ul>
            </div>
          </div>
          <div className="panel-body full-border-light no-padding">
            <ul className="trending-list  p-t-10 no-style no-margin" ref="trendingList">
               {this.state.list}
            </ul>
          </div>
      </div>
    );
  }

});