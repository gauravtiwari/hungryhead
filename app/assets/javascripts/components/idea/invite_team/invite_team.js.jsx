
var InviteTeam = React.createClass({

	getInitialState: function() {
		return {
			loading: false
		}
	},

	handleTeamInvite: function(formData) {
		this.setState({loading: true});
	    $.ajaxSetup({ cache: false });
	    $.ajax({
	      data: formData,
	      url: this.props.form.action,
	      type: "POST",
	      dataType: "json",
	      success: function ( data ) {
	        $("#inviteTeamPopup").modal('hide');
	        this.setState({loading: false});
	      }.bind(this),
	      error: function(xhr, status, err) {
	        console.error(this.props.url, status, err.toString());
	      }.bind(this)
	    });
	},

	_onKeyDown: function(event) {
      event.preventDefault();
      var text = this.refs.msg.getDOMNode().value.trim();
      if (text) {
        var formData = $( this.refs.form.getDOMNode() ).serialize();
        this.handleTeamInvite(formData);
      }
  	},

	render: function() {

	var cx = React.addons.classSet;
    var loading_classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

	return (
			<div className="inviteTeamPopup invite-box">
			  <div className="modal fade" tabIndex="-1" role="dialog" id="inviteTeamPopup" aria-labelledby="inviteTeamPopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
			    <div className="modal-dialog modal-lg">
			      <div className="modal-content">
			        <div className="profile-wrapper-title">
			          <h4><i className="ion-person-add"></i> Invite team members</h4>
			           <button type="button" className="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span className="sr-only">Close</span></button>
			        </div>
			        <div className="modal-body col-md-12">
			          <div className="pledge-information-popup">
			          <form ref="form" onSubmit={this._onKeyDown}>
			              <div className="form-group">
			                <label htmlFor='invite[message]'>Type message</label>
			                <textarea ref="msg" name='idea_invite[message]' cols= "3" placeholder= "Type a personalized message... (optional)" className= "form-control empty" />
			              </div>

			              <div className="form-group">
			                <label htmlFor='invitees'>Add team members</label>
			                <input type="hidden" name="idea_invite[invitees]" id="invitees" value="[]" multiple autoComplete="off"/>
			                <input type="text" name="names" className='user_list' placeholder="Start typing name ..." required />
			                <span id="no-message"></span>
			              </div>
			              
			              <div className="form-buttons">
			                <button className='btn btn-primary'><i className={loading_classes}></i> Send</button>
			              </div>

			            </form>
			          </div>
			        </div>
			      </div>
			    </div>
			  </div>
			</div>
		);
	}
});