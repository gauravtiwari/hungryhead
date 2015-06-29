
/** @jsx React.DOM */

var DashboardForm = React.createClass({

  getInitialState: function() {
    var data = JSON.parse(this.props.school);
    return {
      school: data.school,
      loading: false
    }
  },

  componentDidMount: function() {
    if(this.isMounted()){
      $("#editSchoolFormPopup").on("hidden.bs.modal", function (e) {
        $('#edit_profile_form_modal').remove();
      });
      $('#edit_school').validate();
      $('#schoolPhone').rules('add', {
        phoneUK: true
      });
      this.selectLocations();
    }
  },

  saveSchoolForm: function(formData, action) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: action,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        $('#editSchoolFormPopup').modal('hide');
        $('body').pgNotification({style: "simple", message: "Profile Updated", position: "bottom-left", type: "success",timeout: 5000}).show();
        this.setState({loading: false});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  selectLocations: function(e){
    var $locationsSelect = $('#locations_select');
    var self = this;
    $locationsSelect.each((function(_this) {
      return function(i, e) {
        var select;
        select = $(e);
        return $(select).select2({
          minimumInputLength: 2,
          placeholder: select.data('placeholder'),
          tags: true,
          maximumSelectionSize: 1,
          ajax: {
            url: Routes.autocomplete_location_name_locations_path(),
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
                results: $.map(data, function(item) {
                  return {
                    text: item.label,
                    value: item.value,
                    id: item.id
                  };
                })
              };
            }
          },
          id: function(object) {
            return object.text;
          },
          initSelection: function (element, callback) {
            var locations = self.state.school.locations.map(function(location){
              return {id: Math.random(), text: location.tag}
            });
            callback(locations);
          }
        });
      };
    })(this));
  },

  render: function() {
    var cx = React.addons.classSet;
    var loadingClass = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    var locations = this.state.school.locations.map(function(location){
      return location;
    });

    return(
      <div className="modal fade stick-up" id="editSchoolFormPopup" tabIndex="-1" role="dialog" aria-labelledby="editSchoolFormPopupLabel" aria-hidden="true">
        <div className="modal-dialog modal-lg">
            <div className="modal-content">
                <div className="modal-header clearfix text-left">
                    <button type="button" className="close" data-dismiss="modal" aria-hidden="true">
                      <i className="pg-close fs-14"></i>
                    </button>
                    <h5 className="b-b b-grey p-b-5 pull-left">Update School <span className="semi-bold">Profile</span></h5>
                </div>
                <div className="modal-body p-t-20">
                    <div className="editSchool">
                      <div className="panel panel-default no-border">
                        <div className="panel-body no-padding no-border">
                          <form ref="school_form" noValidate="novalidate" className="edit_school" id="edit_school" method="put" onSubmit={this._onKeyDown} acceptCharset="UTF-8">
                            <div className="col-md-6">
                              <div className="form-group">
                                  <label>Name</label>
                                  <input className="string required form-control" required="required" aria-required="true" type="text" defaultValue={this.state.school.name} name="school[name]" id="school_name" />
                              </div>
                              <div className="form-group">
                                  <label>Email</label>
                                 <input className="string email required form-control" placeholder="School contact email" required="required" aria-required="true" type="email" defaultValue={this.state.school.email}  name="school[email]" id="school_email" />
                              </div>
                              <div className="form-group">
                                  <label>Phone</label>
                                 <input className="string phone required form-control" placeholder="School contact phone" required="required" aria-required="true" type="text" defaultValue={this.state.school.phone}  name="school[phone]" id="schoolPhone" />
                              </div>
                              <div className="form-group">
                                  <label>Description</label>
                                  <span className="help"> e.g. "max: 240 characters"</span>
                                  <textarea className="string required form-control" required="required" aria-required="true" type="text" placeholder="We are ..." defaultValue={this.state.school.description}  name="school[description]" id="school_mini_bio"></textarea>
                              </div>
                            </div>
                            <div className="col-md-6">
                              <div className="form-group">
                                <label>Location</label>
                                <input defaultValue={this.state.school.locations} className="form-control string optional location_list full-width" data-placeholder="Lancaster" type="text" name="school[location_list]" id="locations_select" />
                              </div>
                              <div className="form-group">
                                  <label>Website url</label>
                                  <span className="help"> e.g. "www.lancs.ac.uk"</span>
                                  <input className="string form-control" type="url" placeholder="Enter Website url" defaultValue={this.state.school.website_url}  name="school[website_url]" id="school_website_url" />
                              </div>
                              <div className="form-group">
                                  <label>Facebook url</label>
                                  <span className="help"> e.g. "www.facebook.com/lancasteruni"</span>
                                  <input className="string form-control" type="url" placeholder="Enter Facebook url" defaultValue={this.state.school.facebook_url}  name="school[facebook_url]" id="school_facebook_url" />
                              </div>
                              <div className="form-group">
                                  <label>Twitter url</label>
                                  <span className="help"> e.g. "www.twitter.com/lancasteruni"</span>
                                  <input className="string form-control" type="url" placeholder="Enter Twitter url" defaultValue={this.state.school.twitter_url}  name="school[twitter_url]" id="school_twitter_url" />
                              </div>
                              <div className="m-t-20 pull-right">
                                <button name="commit" className="btn btn-success btn-sm fs-13"><i className={loadingClass}></i> Save</button>
                                <a data-dismiss="modal" aria-hidden="true" id="cancel-edit-school" className="btn btn-danger btn-sm fs-13 m-l-10">Cancel</a>
                              </div>
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
    if($(this.refs.school_form.getDOMNode()).valid()) {
      var formData = $( this.refs.school_form.getDOMNode() ).serialize();
      this.saveSchoolForm(formData, this.state.school.form.action);
    }
  }

});
