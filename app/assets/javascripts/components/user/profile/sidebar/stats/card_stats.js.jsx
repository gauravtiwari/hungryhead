/** @jsx React.DOM */

var CardStats = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      feedbacks_count: data.feedbacks_count,
      followers_count: data.followers_count,
      investments_count: data.investments_count,
      score: data.score
    }
  },

  componentDidMount: function() {
    var self = this;
    $.pubsub('subscribe', 'update_followers_stats', function(msg, data){
      self.setState({followers_count: data});
    });
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'widget-16 panel no-border no-margin profile-cards box-shadow': true
    });

    return(
      <div className={classes}>
        <div className="panel-heading">
          <div className="panel-title b-b b-grey p-b-5">Reputation
          </div>
        </div>
        <div className="p-l-25 p-r-45">
          <h3 className="no-margin p-b-25 no-padding text-master text-center">{this.state.score}</h3>
          <div className="row p-b-25">
            <div className="col-md-4 text-center">
              <p className="hint-text all-caps font-montserrat small no-margin">Feedbacks</p>
              <p className="all-caps font-montserrat no-margin text-success">{this.state.feedbacks_count}</p>
            </div>
            <div className="col-md-4 text-center">
            <p className="hint-text all-caps font-montserrat small no-margin ">Invested</p>
            <p className="all-caps font-montserrat  no-margin text-warning ">{this.state.investments_count}</p>
            </div>
            <div className="col-md-4 text-center">
              <p className="hint-text all-caps font-montserrat small no-margin ">Followers</p>
              <p className="all-caps font-montserrat no-margin text-success ">{this.state.followers_count}</p>
              </div>
            </div>
        </div>
      </div>
    )
  }
});
