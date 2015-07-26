var LookingForTeam = React.createClass({
  render: function() {
    return (
      <div className="alert text-white bg-solid">
        <span>
          <i className="fa fa-search"></i> {this.props.idea.name} is currently looking for team members
          who could help them build their idea. <a href={this.props.idea.name} className="text-white b-b b-white p-b-5">Register your interest</a>
        </span>
      </div>
    );
  }
});