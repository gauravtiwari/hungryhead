/** @jsx React.DOM */

var IdeaCardStats = React.createClass({

  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      feedbacks_count: data.feedbacks_count,
      followers_count: data.followers_count,
      raised: data.raised,
      views_count: data.views_count,
      comments_count: data.comments_count,
      votes_count: data.votes_count,
      score: data.score,
      width: null
    }
  },

  calculateScore: function() {
    var remaining = this.state.score/10000
    this.setState({width: remaining * 100});
  },

  componentDidMount: function() {
    var self = this;
    this.calculateScore();
    $.pubsub('subscribe', 'update_followers_stats', function(msg, data){
      self.setState({followers_count: data});
    });
    $.pubsub('subscribe', 'update_investment_stats', function(msg, data){
      var sum = +data + +(this.state.raised);
      this.setState({raised: sum});
    }.bind(this));

    $.pubsub('subscribe', 'update_vote_stats', function(msg, data){
      this.setState({votes_count: this.state.votes_count + 1});
    }.bind(this));

    $.pubsub('subscribe', 'update_feedback_stats', function(msg, data){
      this.setState({feedbacks_count: data});
    }.bind(this));
  },

  openLeaderboardHelpModal: function() {
    $('body').append($('<div>', {class: 'idea_leaderboard_help_modal', id: 'idea_leaderboard_help_modal'}));
    React.render(<IdeaLeaderboardHelpModal key={Math.random()} />,
      document.getElementById('idea_leaderboard_help_modal')
    );
    ReactRailsUJS.mountComponents();
    $('#leaderboardHelpModal').modal('show');
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'widget-16 panel no-border cup-bg profile-cards box-shadow no-margin': true
    });

    return(
      <div className={classes}>
        <div className="panel-heading bg-light-blue-lightest m-b-20">
          <div className="panel-title b-b b-grey p-b-5">
            <i className="fa fa-star text-danger"></i> Reputation
          </div>
          <a className="know-more" onClick={this.openLeaderboardHelpModal}>
            <i className="fa fa-question-circle pull-right fs-16 text-black"></i>
          </a>
        </div>
        <div className="p-l-25 p-r-45">
            <div className="row">

            <div style={{width: '50%'}} className="text-center auto-margin">
                <div className="progress-text text-center text-success fs-16 p-b-10 bold">Score: {this.state.score}/10K</div>
                <div className="progress">
                    <div className="progress-bar progress-bar-success" style={{width: this.state.width + '%'}}></div>
                </div>
            </div>

            <div className="col-md-4 text-center">
              <p className="hint-text all-caps font-montserrat small no-margin">Views</p>
              <p className="all-caps font-montserrat no-margin text-success">{this.state.views_count}</p>
            </div>

            <div className="col-md-4 text-center">
              <p className="hint-text all-caps font-montserrat small no-margin">Feedbacks</p>
              <p className="all-caps font-montserrat no-margin text-success">{this.state.feedbacks_count}</p>
            </div>
            <div className="col-md-4 text-center">
            <p className="hint-text all-caps font-montserrat small no-margin ">Raised</p>
            <p className="all-caps font-montserrat  no-margin text-success ">{this.state.raised}</p>
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
