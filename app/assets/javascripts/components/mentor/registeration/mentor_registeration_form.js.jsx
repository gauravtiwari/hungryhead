/** @jsx React.DOM */

var MentorRegisterationForm = React.createClass({

  getInitialState: function(){
    return {
      form: this.props.form,
      password: "",
      email: "",
      username: "",
      school_id: "",
      name: ""
    };
  },

  componentDidMount: function(){
    var self = this;
    $('#school_select').each((function(_this) {
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
  },

  onUsernameChange: function(e) {
    data = {
      username: e.target.value
    }
    $.ajax({
        data: data,
        url: Routes.check_username_path(),
        type: "GET",
        dataType: "json",
        success: function ( data ) {
        if(data.available) {
          $('#invalid-username').text("").hide();
        } else {
          $('#invalid-username').text(data.error).show();
        }
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(err.toString());
        }.bind(this)
    });
  },

  fillName: function(e){
    var fname = $(this.refs.fname.getDOMNode()).val();
    var lname = $(this.refs.lname.getDOMNode()).val();
    $(this.refs.fullname.getDOMNode()).val(fname +" " + lname)
  },

  onEmailChange: function(e) {
   data = {
      email: e.target.value
    }
    $.ajax({
        data: data,
        url: Routes.check_email_path(),
        type: "GET",
        dataType: "json",
        success: function ( data ) {
        if(data.available) {
          $('#invalid-email').text("").hide();
        } else {
          $('#invalid-email').text(data.error).show();
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
              <input type="text" ref="name" autoComplete="off" name="mentor[name]" placeholder="John Smith" className="form-control" required aria-required="true" />
            </div>
          </div>

          <div className="col-sm-6">
            <div className="form-group form-group-default">
              <label>Email</label>
              <input type="email" name="mentor[email]" autoComplete="off" onBlur={this.onEmailChange} placeholder="Your school email" className="form-control" required="true" aria-required="true" />
              <span id="invalid-email"></span>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-sm-12">
            <div className="form-group">
              <label>Select your school</label>
              <input type="text" name="mentor[school_id]" autoComplete="off" id="school_select" data-url={this.state.form.url} data-placeholder="Type and choose your school from the list" className="form-control full-width" required aria-required="true" />
            </div>
          </div>
        </div>
        <div className="row">
          <div className="col-sm-6">
            <div className="form-group form-group-default">
              <label>Username</label>
              <input type="text" name="mentor[username]" autoComplete="off" onBlur={this.onUsernameChange} placeholder="no empty spaces or symbols" className="form-control" minlength="6" required aria-required="true" />
              <span id="invalid-username"></span>
            </div>
          </div>

          <div className="col-sm-6">
            <div className="form-group form-group-default">
              <label>Password</label>
              <input type="password" name="mentor[password]" autoComplete="off" placeholder="Minimum of 8 Characters" className="form-control" minlength="8" required="true" aria-required="true" />
            </div>
          </div>
        </div>

        <div className="row m-t-10">
          <div className="col-md-6">
            <div className="checkbox check-success">
              <input type="checkbox" name="mentor[terms_accepted]" value="1" id="checkbox1" checked/>
              <label htmlFor="checkbox1">I agree to the <a href="#" className="text-info small">Pages Terms</a> and <a href="#" className="text-info small">Privacy</a>.</label>
            </div>
          </div>
          <div className="col-md-6 text-right">
            <span>Already registered?<a href="/login" className="text-info small"> Login</a></span>
          </div>
        </div>
        <button className="btn btn-complete btn-cons m-t-10" type="submit"><i className={loading_class}></i> Submit</button>
        <a className="btn btn-primary btn-cons m-t-10" href="/">Back</a>
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
