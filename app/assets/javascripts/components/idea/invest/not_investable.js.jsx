/** @jsx React.DOM */

var NotInvestable = React.createClass({

  render: function() {
    return (
      <div className="modal-body">
        <div className="no-balance">
          <h3 className="text-center fs-22">{this.props.idea.name} is not investable. </h3>
          <p className="text-center">A score of 1000 is needed for an idea to make it investable.</p>
        </div>
      </div>
    )
  }
});
