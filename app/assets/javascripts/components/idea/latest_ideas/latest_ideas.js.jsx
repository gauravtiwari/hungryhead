
var LatestIdeas = React.createClass({

  getInitialState: function() {
    return {
      list: [],
      type: null,
      current_path: this.props.path,
      done: false
    }
  },

  componentDidMount: function() {
    if(this.isMounted()) {
      this.fetchList();
      var ideas_channel = pusher.subscribe("ideas-channel");
      if(ideas_channel) {
        ideas_channel.bind('new_idea', function(data){
          var new_item = [data.data]
          var newState = React.addons.update(this.state, {
              list : {
                $unshift : new_item
              }
          });
          this.setState(newState);
          $("#idea_"+data.data.id).effect('highlight', {color: '#f7f7f7'} , 5000);
          $("#idea_"+data.data.id).addClass('animated fadeInDown');
        }.bind(this));
      }
    }
  },

  loadTrending: function() {
    this.setState({current_path: Routes.trending_ideas_path(), done: false, loading: true});
    $.getJSON(Routes.trending_ideas_path(), function(json, textStatus) {
      this.setState({
        list: json.list,
        type: json.type,
        loading: false
      });
    }.bind(this));
  },

  loadPopular: function() {
    this.setState({current_path: Routes.popular_ideas_path(), done: false, loading: true});
    $.getJSON(Routes.popular_ideas_path(), function(json, textStatus) {
      this.setState({
        list: json.list,
        type: json.type,
        loading: false
      });
    }.bind(this));
  },

  resetList: function() {
    this.setState({current_path: Routes.latest_ideas_path(), done: false, loading: true});
    $.getJSON(Routes.latest_ideas_path(), function(json, textStatus) {
      this.setState({
        list: json.list,
        type: json.type,
        loading: false
      });
    }.bind(this));
  },

  fetchList: function(){
    this.setState({loading: true});
    $.getJSON(this.state.current_path, function(json, textStatus) {
      this.setState({
        list: json.list,
        type: json.type,
        loading: false
    });
    }.bind(this));
  },

  render: function() {

    var ideas =  _.map(this.state.list, function(item){
            return <LatestIdeasItem key={Math.random()} item={item} />;
        });

    if(this.state.loading) {
      var content = <div className="no-content light p-t-40">
        <i className="fa fa-spinner fa-pulse"></i>
        </div>;
    } else {
      if(this.state.list.length > 0) {
        var content = ideas
      } else {
        var content = <div className="text-center fs-22 font-opensans text-master light p-t-40">
          <i className="fa fa-list"></i>
          <span className="clearfix">No ideas published</span>
        </div>;
      }
    }

    var styles = {
      maxHeight: '200px'
    }

    return (
      <div className="widget-11-2 p-b-10 panel no-border no-margin">
          <div className="panel-heading bg-light-blue-lightest">
           <div className="panel-title">
              {this.state.type}
            </div>
            <div className="panel-controls">
                <ul>
                    <li className="hidden-xlg">
                      <div className="dropdown">
                        <a data-target="#" className="pointer" href="#" data-toggle="dropdown" aria-haspopup="true" role="button" aria-expanded="false">
                          <i className="portlet-icon portlet-icon-settings m-r-10"></i>
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
                      <a data-toggle="tooltip" title="Refresh" className="text-black pointer" onClick={this.resetList}>
                          <i className="portlet-icon portlet-icon-refresh"></i>
                      </a>
                    </li>
                </ul>
            </div>
          </div>
          <div className="panel-body no-padding full-border-light scrollable" style={styles}>
            <ul className="trending-list no-padding no-style" ref="trendingList" style={styles}>
             {content}
            </ul>
          </div>
      </div>
    );
  }

});