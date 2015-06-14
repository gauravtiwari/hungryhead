
/** @jsx React.DOM */

var CardForm = React.createClass({

  componentDidMount: function() {
    if(this.isMounted()){
      $('.single-tag').tagsinput({maxTags: 1});
      $('.three-tags').tagsinput({maxTags: 3});
    }
  },

  selectHobbies: function(e){
    $( e.target).autocomplete({
      minLength: 0,
      source: Routes.autocomplete_hobby_name_hobbies_path(),
      focus: function( event, ui ) {
        return false;
      },
      select: function( event, ui ) {
        $( "#user_institution_id" ).val( ui.item.id );
        $( "#autocomplete_hobbies_name" ).val( ui.item.value );
        return false;
      }
    });
  },

  render: function() {
    var cx = React.addons.classSet;
    var markets = this.props.profile.markets.map(function(market){
      return market.tag
    });

    var hobbies = this.props.profile.hobbies.map(function(hobby){
      return hobby.tag
    });

    var loadingClass = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

    return(
      <div className="modal fade stick-up" id="editProfileFormPopup" tabIndex="-1" role="dialog" aria-labelledby="editProfileFormPopupLabel" aria-hidden="true">
        <div className="modal-dialog modal-lg">
            <div className="modal-content">
                <div className="modal-header clearfix text-left">
                    <button type="button" className="close" onClick={this.props.closeForm}>
                      <i className="pg-close fs-14"></i>
                    </button>
                    <h5 className="b-b b-grey p-b-5 pull-left">Edit your <span className="semi-bold">Profile</span></h5>
                </div>
                <div className="modal-body p-t-20">
                    <div className="editProfile">
                      <div className="panel panel-default no-border">
                        <div className="panel-body no-padding no-border">
                          <form ref="profile_form" noValidate="novalidate" className="edit_user" id="edit_user" method="put" onSubmit={this._onKeyDown} acceptCharset="UTF-8">
                            <div className="col-md-6">
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
                                  <input className="string required form-control" required="required" aria-required="true" type="text" placeholder="I am founder or student ..." defaultValue={this.props.profile.mini_bio}  name="user[mini_bio]" id="user_mini_bio" />
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
                            </div>
                            <div className="col-md-6">
                              <div className="form-group">
                                  <label>Website url</label>
                                  <span className="help"> e.g. "www.example.com"</span>
                                  <input className="string form-control" type="url" placeholder="Enter Website url" defaultValue={this.props.profile.website_url}  name="user[website_url]" id="user_website_url" />
                              </div>
                              <div className="form-group">
                                  <label>Linkedin url</label>
                                  <span className="help"> e.g. "www.linkedin.com/john"</span>
                                  <input className="string form-control" type="url" placeholder="Enter Linkedin url" defaultValue={this.props.profile.linkedin_url}  name="user[linkedin_url]" id="user_linkedin_url" />
                              </div>
                              <div className="form-group">
                                  <label>Facebook url</label>
                                  <span className="help"> e.g. "www.facebook.com/john"</span>
                                  <input className="string form-control" type="url" placeholder="Enter Facebook url" defaultValue={this.props.profile.facebook_url}  name="user[facebook_url]" id="user_facebook_url" />
                              </div>
                              <div className="form-group">
                                  <label>Twitter url</label>
                                  <span className="help"> e.g. "www.twitter.com/john"</span>
                                  <input className="string form-control" type="url" placeholder="Enter Twitter url" defaultValue={this.props.profile.twitter_url}  name="user[twitter_url]" id="user_twitter_url" />
                              </div>

                              <div className="form-group">
                                <label>Interests/Hobbies</label>
                                <span className="help"> e.g. "Programming, Marketing"</span>
                                <input defaultValue={hobbies} onKeyup={this.selectHobbies} className="string optional form-control" placeholder="Which hobbies or interests you have?" type="text" name="user[hobby_list]" id="user_hobby_list" />
                              </div>
                              <button name="commit" className="btn btn-success btn-cons pull-right"><i className={loadingClass}></i> Save</button>
                              <a onClick={this.props.closeForm} id="cancel-edit-profile" className="btn btn-danger btn-cons pull-right">Cancel</a>
                            </div>
                          </form>
                        </div>
                    </div>
                  </div>
                </div>
            </div>
        </div>
    </div>

    )
  },

  _onKeyDown: function(event) {
    event.preventDefault();
    if($(this.refs.profile_form.getDOMNode()).valid()) {
      var formData = $( this.refs.profile_form.getDOMNode() ).serialize();
      this.props.saveSidebarWidget(formData, this.props.form.action);
    }
  }

});
