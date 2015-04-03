var Team = React.createClass({
	
	getInitialState: function() {
		var data = JSON.parse(this.props.data);
		return {
			members: data.idea.members,
			is_owner: data.meta.is_owner,
			loading: false,
			idea_team_path: data.idea.idea_team_path,
			team_count: data.idea.team_count
		};
	},

	openInviteBox: function() {
		$('#inviteTeamPopup').modal('show');
	},

	loadTeam: function() {
	    this.setState({loading: true});
	    $.get(this.state.idea_team_path, function(data){
	      $('body').append($('<div>', {class: 'team_member_list', id: 'idea_team_modal'}));
	      $('#idea_team_modal').html(data);
	      this.setState({loading: false});
	      $('#ideaTeamPopup').modal('show');
	      ReactRailsUJS.mountComponents();
	    }.bind(this));
	},

	render: function() {

		var cx = React.addons.classSet;
	    var classes = cx({
	      'fa fa-spinner fa-spin': this.state.loading
	    });

		var teamMembersItem = _.map(this.state.members, function(member){
			return <TeamMember member={member} key={member.uuid} />
		});

		if(this.state.team_count > 4) {
			var see_all = <a className="see-all" onClick={this.loadTeam}><i className={classes}></i> See all</a>
		}

		if(this.state.is_owner) {
			var action_text = <a href="javascript:void(0)" className="show-all" onClick={this.openInviteBox}>
								<i className="ion-person-add"></i> Add team member
							</a>;
		} else {
			var action_text = {see_all};
		}

		return (
			<div className="idea-aside-box-wrapper">
				<div className="profile-wrapper-title">
					<h4><i className="ion-person-stalker red-link"></i> Team</h4>
					{action_text}
				</div>
				<ul className="stories-list">
					{teamMembersItem}
				</ul>
			</div>
		);
	}
})
