
var LatestUsers = React.createClass({

  getInitialState: function() {
    var data = JSON.parse(this.props.users);
    return {
      list: data.list,
      type: data.type,
      current_path: undefined,
      loading: false,
      done: false
    }
  },

  componentDidMount: function() {
    if(this.isMounted()) {
      var users_channel = pusher.subscribe("users-channel");
      if(users_channel) {
        users_channel.bind('new_user', function(data){
          var new_item = [data.data]
          var newState = React.addons.update(this.state, {
              list : {
                $unshift : new_item
              }
          });
          this.setState(newState);
          $("#user_"+data.data.id).addClass('animated fadeInDown');
        }.bind(this));
      }
    }
  },

  loadTrending: function() {
    this.setState({loading: true});
    this.setState({current_path: Routes.trending_users_path(), done: false});
    $.getJSON(Routes.trending_users_path(), function(json, textStatus) {
      this.setState({
        list: json.list,
        type: json.type,
        loading: false
      });
    }.bind(this));
  },

  loadPopular: function() {
    this.setState({loading: true});
    this.setState({current_path: Routes.popular_users_path(), done: false});
    $.getJSON(Routes.popular_users_path(), function(json, textStatus) {
      this.setState({
        list: json.list,
        type: json.type,
        loading: false
      });
    }.bind(this));
  },

  resetList: function() {
    this.setState({current_path: Routes.latest_users_path(), done: false, loading: true});
    $.getJSON(Routes.latest_users_path(), function(json, textStatus) {
      this.setState({
        list: json.list,
        type: json.type,
        loading: false
      });
    }.bind(this));
  },

  render: function() {

    var type = this.state.type;
    var users = _.map(this.state.list, function(item){
        return <LatestUsersItem key={Math.random()} type={type} item={item} />;
    });

    if(this.state.loading) {
      var content = <div className="no-content light p-t-40"><i className="fa fa-spinner fa-pulse"></i></div>
    } else {
      var content = users
    }

    if(this.state.list.length > 4) {
      var styles = {
        maxHeight: '250px',
        height: '250px'
      }
    } else {
      var styles = {
        maxHeight: '150px',
        height: '150px'
      }
    }

    return (
      <div className="widget-11-2 panel no-border no-margin">
          <div className="panel-heading">
            <div className="panel-title fs-11 text-master">
              {this.state.type}
            </div>
            <div className="panel-controls">
                <ul>
                    <li className="hidden-xlg">
                      <div className="dropdown">
                        <a className="pointer" data-toggle="dropdown" aria-haspopup="true" role="button" aria-expanded="false">
                          <i className="portlet-icon portlet-icon-settings m-r-10"></i>
                        </a>
                        <ul className="dropdown-menu pull-right" role="menu">
                          <li>
                            <a className="pointer" onClick={this.loadTrending}>Trending People</a>
                          </li>
                          <li>
                            <a className="pointer" onClick={this.loadPopular}>Popular People</a>
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
          <div className="panel-body full-border-light scrollable no-padding no-margin"  style={styles}>
            <ul className="trending-list no-padding no-style no-margin" ref="trendingList" style={styles}>
              {content}
            </ul>
          </div>
      </div>
    );
  }

});