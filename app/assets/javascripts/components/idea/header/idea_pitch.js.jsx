var IdeaPitch= React.createClass({
  render: function() {

    if(this.props.idea.elevator_pitch) {
      var html = this.props.idea.elevator_pitch;
    } else {
      var html = "<div class='no-content text-center fs-16 light'>Introduce your idea using a video. <span>Please add a youtube or vimeo video link. It's optional</span> </div>";
    }

    return (
      <div className="col-md-6">
        <div className="text-white p-t-40 fs-16" dangerouslySetInnerHTML={{__html: html}}></div>
        <a onClick={this.props.openForm} className="pull-right fs-12 b-b b-white pointer text-white">{this.props.text}</a>
      </div>
    );
  }
});