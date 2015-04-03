
var InviteLink = React.createClass({

	getInitialState: function() {
		return {
			form: this.props.form
		};
	},

	loadInvitePopup: function() {
      $('body').append($('<div>', {class: 'invite_form_modal', id: 'invite_form_modal'}));
      React.render(
		  <InviteTeam key={Math.random()} form={this.state.form} />,
		  document.getElementById('invite_form_modal')
		);
      this.setState({loading: false});
      $('#inviteTeamPopup').modal('show');
      ReactRailsUJS.mountComponents();
	},

	render: function() {
		return (
				<a className="see-all" href="javascript:void(0)" onClick={this.loadInvitePopup}><i className="ion-plus"></i></a>
			);
	}
});