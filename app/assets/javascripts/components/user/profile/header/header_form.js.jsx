/** @jsx React.DOM */

var UserProfileHeaderForm = React.createClass ({

  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      profile: data.user.profile,
      form: data.user.about_me.form,
      loading: false
    }
  },

  selectUniversity: function(e){
    $( "#autocomplete_institution_name" ).autocomplete({
      minLength: 0,
      source: Routes.autocomplete_organization_name_organizations_path(),
      focus: function( event, ui ) {
        return false;
      },
      select: function( event, ui ) {
        $( "#user_institution_id" ).val( ui.item.id );
        $( "#autocomplete_institution_name" ).val( ui.item.value );
        return false;
      }
    });
  },


  saveUserProfile: function(formData, action) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: action,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        $.pubsub('publish', 'updatedProfileContent', data);
        this.setState({profile: data.user.profile});
        this.setState({loading: false});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.form.action, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
    var cx = React.addons.classSet;
    var loadingClass = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });
    return (<form id="edit-profile-form" ref="header_form" onSubmit={this._onKeyDown} noValidate="novalidate" className="simple_form edit_user" acceptCharset="UTF-8" >
        <div className="row">
          <div className="col-md-6">
            <h3>Fill your Data</h3>
            <div className="form-control-wrapper">
              <label htmlFor="name">Your Name</label>
              <input className="string required form-control empty" type="text" defaultValue={this.state.profile.name} name="user[name]" id="user_name" />
            </div>

            <div className="form-control-wrapper">
              <label htmlFor="username">Username</label>
              <input className="string required form-control empty" type="text" defaultValue={this.state.profile.username} name="user[username]" id="username" />
            </div>

            <div className="form-control-wrapper">
              <label htmlFor="email">Your Email</label>
              <input className="string email required form-control empty" type="email" defaultValue={this.state.profile.email} name="user[email]" id="user_email" />
            </div>

            <div className="form-control-wrapper">
              <label htmlFor="mini_bio">Mini Bio</label>
              <textarea className="form-control empty" defaultValue={this.state.profile.mini_bio} placeholder="Add your bio" name="user[mini_bio]" />
            </div>

            <div className="form-control-wrapper">
              <label htmlFor="locations">I am based in</label>
              <input defaultValue={this.state.profile.location} className="string optional location_list single-tag user-success" autofocus="autofocus" placeholder="Add locations" type="text" name="user[location_list]" id="user_location_list" />
            </div>

            <div className="form-control-wrapper">
              <label>Select your most recent college/university</label>
              <div className="input hidden user_institution_id">
                <input ref="institution_id"  defaultValue={this.state.profile.institution_id} className="hidden" type="hidden" name="user[institution_id]" id="user_institution_id" />
              </div>
              <input type="text" defaultValue={this.state.profile.institution} id="autocomplete_institution_name" required="required" onChange={this.selectUniversity} name="university_name" placeholder= "Enter your most recent college/university name" className="string required form-control empty" />
            </div>


            <div className="button-forms">
              <button name="button" type="submit" className="main-button margin-right">Save <i className={loadingClass}></i></button>
              <a className="main-button for-cancel" href="#" onclick="return false;">
                Cancel</a>
            </div>

          </div>

            <div className="col-md-6">
              <h3>Links</h3>
              <div className="form-control-wrapper">
                <label htmlFor="email">Your website url</label>
                <input placeholder="Enter website url" defaultValue={this.state.profile.website_url} className="string url optional form-control empty" type="url" name="user[website_url]" id="user_website_url" />

              </div>
              <div className="form-control-wrapper">
                <label htmlFor="email">Your facebook url</label>
                <input placeholder="Enter facebook url" defaultValue={this.state.profile.facebook_url} className="string url optional form-control empty" type="url" name="user[facebook_url]" id="user_facebook_url" />

              </div>

              <div className="form-control-wrapper">
                <label htmlFor="email">Your twitter url</label>
                <input placeholder="Enter twitter url" defaultValue={this.state.profile.twitter_url} className="string url optional form-control empty" type="url" name="user[twitter_url]" id="user_twitter_url" />

              </div>

              <div className="form-control-wrapper">
                <label htmlFor="email">Your linkedin url</label>
                <input placeholder="Enter linkedin url" defaultValue={this.state.profile.linkedin_url} className="string url optional form-control empty" type="url" name="user[linkedin_url]" id="user_linkedin_url" />

              </div>

            </div>

          </div>
      </form>
    )
  },

  _onKeyDown: function(event) {
    event.preventDefault();
    var formData = $( this.refs.header_form.getDOMNode() ).serialize();
    this.saveUserProfile(formData, this.state.form.action);
  }

});
