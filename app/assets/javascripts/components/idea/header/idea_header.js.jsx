var IdeaHeader = React.createClass({

  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      data: data,
      idea: data.idea,
      raised: data.stats.raised,
      feedbacks_count: data.stats.feedbacks_counter,
      votes_count: data.stats.votes_counter
    }
  },

  render: function() {
    return (
      <div className="idea-header bg-solid">
        <IdeaCover data= {this.state.data} />
        <IdeaProfile idea={this.state.idea} />
        <IdeaPitch idea={this.state.idea} />
      </div>
    );
  }
});