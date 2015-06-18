
var InviteLink = React.createClass({

	getInitialState: function() {
		return {
			path: this.props.path
		};
	},

	loadInvitePopup: function() {
      $('body').append($('<div>', {class: 'invite_form_modal', id: 'invite_form_modal'}));
      React.render(
		  <InviteTeam key={Math.random()} path={this.state.path} />,
		  document.getElementById('invite_form_modal')
		);
      this.setState({loading: false});
      $('#inviteTeamPopup').modal('show');
      ReactRailsUJS.mountComponents();
	},

	render: function() {
		return (
        <a className="portlet-maximize" data-toggle="tooltip" title="Click to invite team members" data-container="body" href="javascript:void(0)" onClick={this.loadInvitePopup}>
          <i className="fa fa-plus"></i>
        </a>
			);
	}
});