var IdeaCardStats = React.createClass({

  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      feedbacks_count: data.feedbacks_count,
      investments_count: data.investments_count,
      raised: data.raised,
      name: data.name,
      id: data.id,
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
    $.pubsub('subscribe', 'update_investors_stats', function(msg, data){
      self.setState({investments_count: data});
    });
    $.pubsub('subscribe', 'update_investment_stats', function(msg, data){
      var sum = +data + +(this.state.raised);
      this.setState({raised: sum});
    }.bind(this));

    $.pubsub('subscribe', 'update_vote_stats', function(msg, data){
      this.setState({votes_count:  data});
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
      'widget-16 panel no-border cup-bg profile-cards box-shadow': true
    });

    return(

        <div className="p-l-25 p-r-45 p-t-25">
            <div className="row">
            <div style={{width: '50%'}} className="text-center auto-margin">
                <div className="progress-text text-center text-white fs-16 p-b-10 bold">Score: {this.state.score} / 10K <span className="fa fa-question-circle" data-toggle="tooltip" title="Total Validation score"></span></div>
                <div className="progress">
                    <div className="progress-bar progress-bar-white" style={{width: this.state.width + '%'}}></div>
                </div>
            </div>
          </div>
            <div className="row p-b-25 text-center">
              <div className="inline m-r-15">
                <span className="font-montserrat m-r-5 text-white"><span className="fa fa-eye"></span></span>
                <span className="font-montserrat no-margin text-white">{this.state.views_count}</span>
              </div>

              <div className="inline m-r-15">
                <span className="font-montserrat m-r-5 text-white"><span className="fa fa-comments"></span></span>
                <span className="font-montserrat no-margin text-white">{this.state.feedbacks_count}</span>
              </div>
              <div className="inline m-r-15">
                <span className="font-montserrat m-r-5 text-white"><span className="fa fa-dollar"></span></span>
                <span className="font-montserrat  no-margin text-white ">{this.state.raised}</span>
              </div>
              <div className="inline">
                <span className="font-montserrat m-r-5 text-white"><span className="fa fa-thumbs-up"></span></span>
                <span className="font-montserrat no-margin text-white">{this.state.votes_count}</span>
              </div>
            </div>
          </div>
    )
  }
});
