var TeamMember = React.createClass({

  render: function() {
      return (
        <li>
          <img src={this.props.member.avatar} />
          <div className="hover-box">
            <h3><a href={this.props.member.path}>{this.props.member.name}</a></h3>
            <span>{this.props.member.role}</span>
          </div>
        </li>
      );
  }
});
