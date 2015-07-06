/** @jsx React.DOM */

var NotInvestable = React.createClass({

  calculateScore: function() {
    var remaining = this.props.idea.score/1000
    return remaining * 100
  },

  render: function() {
    return (
      <div className="modal-body">
        <div className="no-balance">
          <div style={{width: '50%'}} className="text-center auto-margin">
            <div className="progress-text text-center text-success fs-16 p-b-10 bold">Current Score: {this.props.idea.score}</div>
            <div className="progress">
                <div className="progress-bar progress-bar-success" style={{width: this.calculateScore() + '%'}}></div>
            </div>
          </div>
          <h3 className="text-center fs-22">{this.props.idea.name} is not investable. </h3>
          <p className="text-center">A score of 1000 is needed for an idea to be investable.</p>
        </div>
      </div>
    )
  }
});
