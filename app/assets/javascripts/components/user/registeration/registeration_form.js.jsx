var RegisterationForm = React.createClass({

  getInitialState: function(){
    return {
      form: this.props.form,
      password: "",
      email: "",
      username: "",
      school_id: "",
      school_domain: '.ac.uk',
      name: ""
    };
  },

  componentDidMount: function(){
    var self = this;
    var $schoolSelect = $('#school_select');
    var self = this;
    $schoolSelect.each((function(_this) {
      return function(i, e) {
        var select;
        select = $(e);
        return $(select).select2({
          minimumInputLength: 2,
          placeholder: select.data('placeholder'),
          ajax: {
            url: select.data('url'),
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

  onUsernameChange: function(e) {
    data = {
      username: e.target.value,
      first_name: this.refs.first_name.value.trim(),
      last_name: this.refs.last_name.value.trim(),
      name: this.refs.first_name.value.trim() + ' ' + this.refs.last_name.value.trim()
    }
    var target = e.target;
    if($(this.refs.name.length) != 0) {
      $.ajax({
          data: data,
          url: Routes.check_username_path(),
          type: "POST",
          dataType: "json",
          success: function ( data ) {
          if(data.available) {
            $('#invalid-username').remove();
          } else {
            $('body').pgNotification({
              style: "simple",
              message: data.error + " \n <strong>" + data.suggestions + "</strong>." + " We have selected one for you.",
              position: "top-right", type: "error",
              timeout: 10000
            }).show();
            $(target).val(data.suggested);
            $(target).focus();
          }
          }.bind(this),
          error: function(xhr, status, err) {
            console.error(err.toString());
          }.bind(this)
      });
    }
  },

  onEmailChange: function(e) {
   data = {
      email: e.target.value
    }
    $.ajax({
        data: data,
        url: Routes.check_email_path(),
        type: "POST",
        dataType: "json",
        success: function ( data ) {
        if(data.available) {
          $('#invalid-email').remove();
        } else {
          $('body').pgNotification({style: "simple", message: data.error, position: "top-right", type: "error",timeout: 10000}).show();
        }
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(err.toString());
        }.bind(this)
    });
  },

  showRequestInviteTab: function(e) {
    e.preventDefault();
    try {
      $('#betaregister').removeClass('active');
      $('#forStudents').removeClass('active');
      $("a[href='#betaregister']").parent().removeClass('active');
      $("a[href='#forStudents']").parent().removeClass('active');
      $("a[href='#request_invite']").parent().addClass('active');
      $("a[href='#forMentors']").parent().addClass('active');
      $('#request_invite').addClass('active');
      $("#forMentors").addClass('active');
      $("#forMentors").tab('show');
      $('#request_invite').tab('show');
    } catch(e) {}
  },

  render: function() {
    var button_class = classNames ({
      'main-button': true,
      'disabled': this.props.disabled
    });

    var loading_class = classNames ({
      'fa fa-spinner fa-spin': this.props.loading
    });

    var request_invite_text = "Alumni or Mentor? ";

    return (
      <form id="form-register" ref="form" autoComplete="off" role="form" noValidate="novalidate" acceptCharset="UTF-8" onSubmit={ this._onKeyDown }>
        <small className="small-text text-white">{request_invite_text}Please click <a onClick={this.showRequestInviteTab} className="bold text-white pointer">request an invite</a> tab</small>
        <div className="row m-t-10">
          <div className="col-sm-6">
            <div className="form-group">
              <input type="text" ref="first_name" id="first_name" autoComplete="off" name="user[first_name]" placeholder="First Name" className="form-control" required aria-required="true" />
            </div>
          </div>

          <div className="col-sm-6">
            <div className="form-group">
              <input type="text" ref="last_name" id="last_name" autoComplete="off" name="user[last_name]" placeholder="Last Name" className="form-control" required aria-required="true" />
              <input type="hidden" ref="name" id="name" autoComplete="off" name="user[name]" />
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-sm-6">
            <div className="form-group">
              <input type="text" name="user[school_id]" autoComplete="off" id="school_select" data-url={this.state.form.url} data-placeholder="Choose your school/uni" className="form-control full-width" required aria-required="true" />
              <small className="small-text text-white m-t-20 p-b-10">Your school/uni is not in the list? <a data-toggle="modal" data-target="#addSchoolPopup" className="pointer bold text-white">Click here</a></small>
            </div>
          </div>
          <div className="col-sm-6">
            <div className="form-group">
              <input type="email" name="user[email]" autoCorrect="off" autoComplete="off" onBlur={this.onEmailChange} placeholder="Your school/uni email" className="form-control" required="true" aria-required="true" />
              <span id="invalid-email"></span>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-sm-6">
            <div className="form-group">
              <input type="text" name="user[username]" autoCorrect="off" autoCapitalize="off" autoComplete="off" onBlur={this.onUsernameChange} placeholder="Username - no empty space or symbol" id="formUsername" className="form-control" minLength="6" required aria-required="true" />
              <span id="invalid-username"></span>
            </div>
          </div>
          <div className="col-sm-6">
            <div className="form-group">
              <input type="password" name="user[password]" autoCapitalize="off" id="formPassword" autoComplete="off" placeholder="Password - min 8 characters" className="form-control" minLength="8" required aria-required="true" />
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-sm-6">
            <div className="checkbox overflow-ellipsis check-success">
              <input type="checkbox" name="user[terms_accepted]" value="1" id="checkbox1" defaultChecked />
              <label htmlFor="checkbox1" className="text-white">I agree to the <a href={Routes.terms_path()} data-toggle="tooltip" title="Click to load terms" className="text-white small bold">Terms or use</a> and <a data-toggle="tooltip" title="Click to load privacy" href={Routes.privacy_path()} className="text-white bold small">Privacy</a></label>
            </div>
          </div>
         <div className="pull-right sm-pull-reset col-sm-6">
           <div className="checkbox check-complete">
            <input type="checkbox" name="user[role]" value="faculty" id="checkbox2" />
            <label htmlFor="checkbox2" className="bold text-white">Are you a Faculty member?</label>
           </div>
         </div>
        </div>
        <div className="sm-m-t-30 m-t-10">
          <button className="btn btn-brand bold text-white btn-sm fs-13" type="submit"><i className={loading_class}></i> Submit</button>
        </div>
      </form>
    )
  },

  _onKeyDown: function(event) {
      event.preventDefault();
      $(this.refs.name).val($(this.refs.first_name).val() + ' ' + $(this.refs.last_name).val());
      if($(this.refs.form).valid()) {
        var formData = $(this.refs.form).serialize();
        this.props.handleRegisterationSubmit(formData);
      }
  }


});
