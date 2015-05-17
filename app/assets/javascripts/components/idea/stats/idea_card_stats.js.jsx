/** @jsx React.DOM */

var IdeaCardStats = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      feedbacks_count: data.feedbacks_count,
      followers_count: data.followers_count,
      investments_count: data.investments_count,
      views_count: data.views_count,
      comments_count: data.comments_count,
      votes_count: data.votes_count,
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
      'widget-16 panel no-border cup-bg profile-cards box-shadow': true
    });

    return(
      <div className={classes}>
        <div className="panel-heading">
          <div className="panel-title b-b b-grey p-b-5">
          <i className="fa fa-star text-danger"></i> Reputation
          </div>
        </div>
        <div className="p-l-25 p-r-45">
          <h3 className="no-margin p-b-25 no-padding text-master text-center">Score: {this.state.score}</h3>

            <div className="row">

            <div className="col-md-4 text-center">
              <p className="hint-text all-caps font-montserrat small no-margin">Views</p>
              <p className="all-caps font-montserrat no-margin text-success">{this.state.views_count}</p>
            </div>

            <div className="col-md-4 text-center">
              <p className="hint-text all-caps font-montserrat small no-margin">Feedbacks</p>
              <p className="all-caps font-montserrat no-margin text-success">{this.state.feedbacks_count}</p>
            </div>
            <div className="col-md-4 text-center">
            <p className="hint-text all-caps font-montserrat small no-margin ">Invested</p>
            <p className="all-caps font-montserrat  no-margin text-success ">{this.state.investments_count}</p>
            </div>
          </div>
          <div className="row p-t-15 p-b-15">
            <div className="col-md-4 text-center m-t-10">
              <p className="hint-text all-caps font-montserrat small no-margin ">Followers</p>
              <p className="all-caps font-montserrat no-margin text-success ">{this.state.followers_count}</p>
              </div>


            <div className="col-md-4 text-center m-t-10">
              <p className="hint-text all-caps font-montserrat small no-margin">Votes</p>
              <p className="all-caps font-montserrat no-margin text-success">{this.state.votes_count}</p>
            </div>

            <div className="col-md-4 text-center m-t-10">
              <p className="hint-text all-caps font-montserrat small no-margin">Comments</p>
              <p className="all-caps font-montserrat no-margin text-success">{this.state.comments_count}</p>
            </div>
          </div>
      </div>
      </div>
    )
  }
});
