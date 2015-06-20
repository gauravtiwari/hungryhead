var IdeaPitch= React.createClass({
  render: function() {

    if(this.props.idea.elevator_pitch) {
      var html = this.props.idea.elevator_pitch;
    } else {
      var html = "<div class='no-content text-center fs-16 light'>Introduce your idea using a video. <span>Please add a youtube or vimeo video link. It's optional</span> </div>";
    }

    return (
      <div className="col-md-6">
        <h4 className="text-white p-t-20 p-b-20" dangerouslySetInnerHTML={{__html: html}}></h4>
      </div>
    );
  }
});