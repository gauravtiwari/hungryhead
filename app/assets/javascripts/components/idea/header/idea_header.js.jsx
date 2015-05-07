var IdeaHeader = React.createClass({

  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      idea: data.idea,
      raised: data.stats.raised,
      feedbacks_count: data.stats.feedbacks_counter,
      votes_count: data.stats.votes_counter
    }
  },

  componentDidMount: function() {
    $.pubsub('subscribe', 'update_investment_stats', function(msg, data){
      this.setState({raised: data + this.state.raised});
    }.bind(this));

    $.pubsub('subscribe', 'update_vote_stats', function(msg, data){
      this.setState({votes_count: this.state.votes_count + 1});
    }.bind(this));

    $.pubsub('subscribe', 'update_feedback_stats', function(msg, data){
      this.setState({feedbacks_count: this.state.feedbacks_count + 1});
    }.bind(this));
  },

  render: function() {
    return (
      <div className="idea-header bg-solid">
        <IdeaProfile idea={this.state.idea} />
        <IdeaStats raised={this.state.raised} feedbacks_count={this.state.feedbacks_count} votes_count={this.state.votes_count} />
      </div>
    );
  }
});