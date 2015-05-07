var IdeaStats = React.createClass({
  render: function() {
    return (
      <div className="col-md-6 p-t-40">
        <div className="col-md-4 no-padding text-center b-r b-white b-dashed">
            <h1 className="all-caps fs-13 text-white bold small">Feedbacks</h1>
            <p className="all-caps bold  fs-13 no-margin text-white ">
              {this.props.feedbacks_count}
            </p>
        </div>
        <div className="col-md-4 text-center b-r b-white b-dashed">
            <h1 className="all-caps fs-13 text-white bold small">Raised</h1>
            <p className="all-caps bold  fs-13 no-margin text-white ">
              {this.props.raised}
            </p>
        </div>
        <div className="col-md-4 text-center">
            <h1 className="all-caps fs-13 text-white bold small">Votes</h1>
            <p className="all-caps bold  fs-13 no-margin text-white">
             {this.props.votes_count}
            </p>
        </div>
      </div>
    );
  }
});