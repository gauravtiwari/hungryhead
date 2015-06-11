/** @jsx React.DOM */

var PublishIdeaPopup = React.createClass({

  getInitialState: function() {
    return {
      url: this.props.url,
      is_team: this.props.is_team,
      privacy: this.props.current_privacy,
      is_public: this.props.is_public,
      loading: false,
      idea: this.props.idea,
      published: this.props.published,
      profile_complete: this.props.profile_complete,
      loading: false
    }
  },

  componentDidMount: function() {
    $('[data-toggle="tooltip"]').tooltip();
    $('.single-tag').tagsinput({maxTags: 1});
    $('.three-tags').tagsinput({maxTags: 3});
    var $privacySelect = $('#privacy_select');
    var self = this;
    $privacySelect.each((function(_this) {
      return function(i, e) {
        var select;
        select = $(e);
        return $(select).select2({
          minimumInputLength: 2,
          placeholder: select.data('placeholder'),
          ajax: {
            url: Routes.autocomplete_role_name_roles_path(),
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
          }
        });
      };
    })(this));
  },

  handleClick: function ( event ) {
    this.setState({disabled: true})
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: this.state.url,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        this.setState({
         privacy: data.current_privacy,
         is_public: data.is_public,
         is_team: data.is_team,
         published: data.published,
         url: data.url
       });
        this.setState({disabled: false});
        $('body').pgNotification({style: "simple", message: data.msg, position: "bottom-left", type: "danger",timeout: 5000}).show();
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
    var text = this.state.is_public && this.state.published ? 'Published' : 'Private';
    var title = this.state.is_public ? 'Visible to everyone on Hungryhead' : 'Private, visible to you and team members';

    var cx = React.addons.classSet;
    var classes = cx({
      'btn btn-sm fs-13 padding-5 p-l-10 p-r-10 m-r-10 pull-right': true,
      'privacy-team btn-info': !this.state.is_public,
      'privacy-public btn-success': this.state.is_public
    });

    var icon_class = cx({
      "fa fa-lock": !this.state.is_public,
      "fa fa-unlock-alt": this.state.is_public
    });

    return (
        <div className="investapp invest-box">
          <div className="modal fade stick-up" tabIndex="-1" role="dialog" id="privacyPopup" aria-labelledby="privacylPopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
            <div className="modal-dialog modal-md">
            <div className="modal-content-wrapper">
              <div className="modal-content">
                 <div className="modal-header clearfix text-left">
                    <button type="button" className="close" data-dismiss="modal" aria-hidden="true">
                      <i className="pg-close fs-14"></i>
                    </button>
                    <h5 className="b-b b-grey p-b-5 pull-left">Customize Privacy for <span className="semi-bold">{this.state.idea.name}</span></h5>
                </div>
              <div className="modal-body">
                <form id="privacy-form" role="form" noValidate="novalidate" acceptCharset="UTF-8" ref="privacy_form" onSubmit={this._onKeyDown}>
                 <div className="form-group">
                     <div className="row">
                         <div className="row">
                           <div className="col-sm-12 col-md-12">
                             <div className="form-group">
                               <label>Select Multiple Privacy</label>
                               <input type="text" name="idea[privacy]" autoComplete="off" id="privacy_select" placeholder="Type and choose privacy types from list" className="form-control full-width three-tags" required aria-required="true" />
                             </div>
                           </div>
                         </div>
                          <p className="hint-text small clearfix p-t-10">
                            <i className="fa fa-info-circle m-r-5"></i>
                            We encourage you to share your idea as much as possible, <span className="bold">Learn more</span>.
                            <a className="inline m-l-5" onClick={this.learnMoreSharing}>Read More</a>
                          </p>
                         <div className="col-md-6 pull-right m-t-15">
                            <button type="submit" id="update_section" className="btn btn-success pull-right">
                              Save
                            </button>
                            <button type="button" className="btn btn-danger m-r-10 pull-right" data-dismiss="modal">Cancel</button>
                         </div>
                     </div>
                 </div>
             </form>
            </div>
            </div>
            </div>
            </div>
          </div>
        </div>
    )
  },

});
