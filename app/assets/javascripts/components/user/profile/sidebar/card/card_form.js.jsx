
/** @jsx React.DOM */

var CardForm = React.createClass({

  componentDidMount: function() {
    if(this.isMounted()){
      $('.single-tag').tagsinput({maxTags: 1});
      $('.three-tags').tagsinput({maxTags: 3});
    }
  },
  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'edit-mode-section edit-profile': true,
      'show': this.props.mode,
      'hide': !this.props.mode,
    });

    var markets = this.props.profile.markets.map(function(market){
      return market.tag
    });

    var skills = this.props.profile.skills.map(function(skill){
      return skill.tag
    });

    var loadingClass = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

    return(

    <div className={classes}>
      <div className="panel panel-default">
        <div className="panel-heading">
            <div className="panel-title">
            Update Profile
            </div>
        </div>
        <div className="panel-body p-t-20">
          <form ref="profile_form" noValidate="novalidate" className="edit_user" id="edit_user" method="put" onSubmit={this._onKeyDown} acceptCharset="UTF-8">
            <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
            <div className="form-group">
                <label>Your name</label>
                <span className="help"> e.g. "John Doe" <span className="text-danger">required</span></span>
                <input className="string required form-control" required="required" aria-required="true" type="text" defaultValue={this.props.profile.name} name="user[name]" id="user_name" />
            </div>
            <div className="form-group">
                <label>Email</label>
                <span className="help"> e.g. "johndoe@example.com" <span className="text-danger">required</span></span>
               <input className="string email required form-control" required="required" aria-required="true" type="email" defaultValue={this.props.profile.email}  name="user[email]" id="user_email" />
            </div>

            <div className="form-group">
                <label>Mini Bio</label>
                <span className="help"> e.g. "Student, interested in startups"</span>
                <input className="string required form-control" required="required" aria-required="true" type="text" defaultValue={this.props.profile.mini_bio}  name="user[mini_bio]" id="user_mini_bio" />
            </div>
            <div className="form-group">
              <label>Location you are based</label>
              <span className="help"> e.g. "Lancaster"</span>
              <input defaultValue={this.props.profile.location_name} className="string optional location_list single-tag" placeholder="Location where you are based?" type="text" name="user[location_list]" id="user_location_list" />
            </div>

            <div className="form-group">
              <label>Markets interested</label>
              <span className="help"> e.g. "Ecommerce, SASS"</span>
              <input defaultValue={markets} className="string optional form-control market_list three-tags" placeholder="Which markets interests you?" type="text" name="user[market_list]" id="user_market_list" />
            </div>

            <div className="form-group">
              <label>Skills</label>
              <span className="help"> e.g. "Programming, Marketing"</span>
              <input defaultValue={skills} className="string optional form-control skill_list three-tags" placeholder="Which skills you have?" type="text" name="user[skill_list]" id="user_skill_list" />
            </div>

            <button name="commit" className="btn btn-success btn-cons pull-right"><i className={loadingClass}></i> Save</button>
            <a onClick={this.props.openForm} id="cancel-edit-profile" className="btn btn-danger btn-cons pull-right">Cancel</a>
          </form>
        </div>
    </div>
  </div>
    )
  },

  _onKeyDown: function(event) {
    event.preventDefault();
    var formData = $( this.refs.profile_form.getDOMNode() ).serialize();
    this.props.saveSidebarWidget(formData, this.props.form.action);
  }

});
