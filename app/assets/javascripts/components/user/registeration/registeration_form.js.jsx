/** @jsx React.DOM */

var RegisterationForm = React.createClass({

  getInitialState: function(){
    return {
      form: this.props.form,
      password: "",
      email: "",
      username: "",
      school_id: "",
      name: "",
      school_domain: ".edu"
    };
  },

  componentDidMount: function(){
    var self = this;
    var $schoolSelect = $('#school_select');
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
                    logo: item.logo.logo.mini.url,
                    id: item.id
                  };
                })
              };
            }
          }
        });
      };
    })(this));

    $schoolSelect.on("select2:select", function (e) {
      log("select2:select", e);
    });
  },

  onUsernameChange: function(e) {
    data = {
      username: e.target.value,
      name: this.refs.name.getDOMNode().value.trim()
    }
    var target = e.target;
    if($(this.refs.name.getDOMNode().length) != 0) {
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

  render: function() {
    var cx = React.addons.classSet;

    var button_class = cx ({
      'main-button': true,
      'disabled': this.props.disabled
    });

    var loading_class = cx ({
      'fa fa-spinner fa-spin': this.props.loading
    });

    return (
      <form id="form-register" ref="form" autoComplete="off" className="p-t-15" role="form" noValidate="novalidate" acceptCharset="UTF-8" onSubmit={ this._onKeyDown }>
        <div className="row">
          <div className="col-sm-6">
            <div className="form-group form-group-default">
              <label>Your full name</label>
              <input type="text" ref="name" id="name" autoComplete="off" name="student[name]" placeholder="John Smith" className="form-control" required aria-required="true" />
            </div>
          </div>

          <div className="col-sm-6">
            <div className="form-group form-group-default">
              <label>Username</label>
              <input type="text" name="student[username]" autoComplete="off" onBlur={this.onUsernameChange} placeholder="no empty spaces or symbols" id="formUsername" className="form-control" minlength="6" required aria-required="true" />
              <span id="invalid-username"></span>
            </div>
          </div>

        </div>

        <div className="row">
          <div className="col-sm-12">
            <div className="form-group">
              <label>Select your University/College <small className="fs-8 text-danger">Your school is not in the list. <a data-toggle="modal" data-target="#addSchoolPopup">Click here</a></small></label>
              <input type="text" name="student[school_id]" autoComplete="off" id="school_select" data-url={this.state.form.url} data-placeholder="Type and choose your school from the list" className="form-control full-width" required aria-required="true" />
            </div>
          </div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <div className="form-group form-group-default input-group">
              <label>Email</label>
              <input type="email" name="student[email]" autoComplete="off" onBlur={this.onEmailChange} placeholder="Your school email" className="form-control" required="true" aria-required="true" />
              <span className="input-group-addon" id="school_domain">
                {this.state.school_domain}
              </span>
              <span id="invalid-email"></span>
            </div>
          </div>

          <div className="col-sm-6">
            <div className="form-group form-group-default">
              <label>Password</label>
              <input type="password" name="student[password]" id="formPassword" autoComplete="off" placeholder="Minimum of 8 Characters" className="form-control" minlength="8" required aria-required="true" />
            </div>
          </div>
        </div>

        <div className="row m-t-10">
          <div className="col-md-6">
            <div className="checkbox check-success">
              <input type="checkbox" name="student[terms_accepted]" value="1" id="checkbox1" defaultChecked />
              <label htmlFor="checkbox1">I agree to the <a href="#" className="text-info small">Pages Terms</a> and <a href="#" className="text-info small">Privacy</a>.</label>
            </div>
          </div>
          <div className="col-md-6 text-right">
            <span className="fs-12">Already registered?<a className="fs-13" href="/login" className="text-primary bold"> Login</a></span>
          </div>
        </div>
        <button className="btn btn-complete btn-sm fs-13 m-t-10" type="submit"><i className={loading_class}></i> Submit</button>

        <a className="btn btn-primary btn-sm fs-13 m-l-10 m-t-10" href="/">Back</a>
        <div className="pull-right text-right">
          <span className="fs-12">Faculty?<a className="fs-13" href="/teachers_join" className="text-primary bold"> Click to join</a></span>
        </div>
      </form>
    )
  },

  _onKeyDown: function(event) {
      event.preventDefault();
      if($(this.refs.form.getDOMNode()).valid()) {
        var formData = $(this.refs.form.getDOMNode()).serialize();
        this.props.handleRegisterationSubmit(formData);
      }
  }


});
