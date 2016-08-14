
var InviteTeam = React.createClass({

	getInitialState: function() {
		return {
			loading: false
		}
	},

	componentDidMount: function() {
		if(this.isMounted()){
			this.selectTeam();
		}
	},

	handleTeamInvite: function(formData) {
		this.setState({loading: true});
		$.ajaxSetup({ cache: false });
		$.ajax({
		  data: formData,
		  url: this.props.path,
		  type: "POST",
		  dataType: "json",
		  success: function ( data ) {
		  	if(data.error){
		  		$('body').pgNotification({
		  			style: "simple",
		  			message: data.error,
		  			position: "bottom-left",
		  			type: "danger",
		  			timeout: 5000
		  		}).show();
		  	} else {
		  		$("#inviteTeamPopup").modal('hide');
		  	}
		  	this.setState({loading: false});
		  }.bind(this),
		  error: function(xhr, status, err) {
		    console.error(this.props.url, status, err.toString());
		  }.bind(this)
		});
	},

	selectTeam: function(e){
	  var $teamsSelect = $('#teams_select');
	  var self = this;
	  $teamsSelect.each((function(_this) {
	    return function(i, e) {
	      var select;
	      select = $(e);
	      return $(select).select2({
	        minimumInputLength: 2,
	        placeholder: select.data('placeholder'),
	        tags: true,
	        maximumSelectionSize: 3,
	        ajax: {
	          url: Routes.autocomplete_user_name_users_path(),
	          dataType: 'json',
	          type: 'GET',
	          cache: true,
	          quietMillis: 50,
	          data: function(term) {
	            return {
	              term: term
	            };
	          },
	          results: function(data) {
	            return {
	              results: data
	            };
	          }
	        },
	        formatResult: function(user) {
          	return "<div class='select2-user-result'>" +  user.value + " <span class='small text-danger'> (" + user.username +  ")</span></div>";
          },

          formatSelection: function(user) {
          	return user.value;
          },
	        id: function(object) {
	          return object.id;
	        }
	      });
	    };
	  })(this));
	},

	_onKeyDown: function(event) {
      event.preventDefault();
      var text = this.refs.msg.value.trim();
      if (text) {
        var formData = $( this.refs.form ).serialize();
        this.handleTeamInvite(formData);
      }
  	},

	render: function() {
    var loading_classes = classNames({
      'fa fa-spinner fa-spin': this.state.loading
    });

	return (
			<div className="inviteTeamPopup invite-box">
			  <div className="modal fade stick-up" tabIndex="-1" role="dialog" id="inviteTeamPopup" aria-labelledby="inviteTeamPopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
			    <div className="modal-dialog modal-md">
			      <div className="modal-content">
			        <div className="modal-header clearfix text-left">
			           <button type="button" className="close" data-dismiss="modal" aria-hidden="true">
                 	<i className="pg-close fs-14"></i>
                 </button>
                 <h5><i className="fa fa-plus"></i> Invite team members</h5>
               </div>
			        <div className="modal-body">
			          <div className="pledge-information-popup">
			          <form className="form-default" ref="form" onSubmit={this._onKeyDown} role="form">
			              <div className="form-group">
			                <label className="text-master" htmlFor='invite[message]'>Type message</label>
			                <textarea ref="msg" name='team_invite[message]' cols= "3" placeholder= "Type a personalized message... (optional)" className= "form-control empty" />
			              </div>
			              <div className="form-group">
			                <label className="text-master" htmlFor='invitees'>Add team members</label>
			                <input type="text" name="team_invite[invitees]" className='user_list' data-placeholder="Start typing name ..." required id="teams_select" />
			                <span id="no-message"></span>
			              </div>
			              <div className="form-buttons">
			                <button className='btn btn-primary'><i className={loading_classes}></i> Invite</button>
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
