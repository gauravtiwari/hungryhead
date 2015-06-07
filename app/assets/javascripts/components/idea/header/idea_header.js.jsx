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
    if(this.state.idea.cover.has_cover || this.state.data.meta.is_owner) {
      var cover = <IdeaCover data= {this.state.data} />
    } else {
      var cover = ""
    }
    return (
      <div className="idea-header bg-solid">
        {cover}
        <IdeaProfile idea={this.state.idea} />
        <IdeaPitch idea={this.state.idea} />
      </div>
    );
  }
});