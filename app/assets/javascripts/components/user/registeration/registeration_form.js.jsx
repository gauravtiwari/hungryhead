/** @jsx React.DOM */

var RegisterationForm = React.createClass({
  
  getInitialState: function(){
    return {
      password: "",
      email: "",
      username: "",
      university_id: "",
      name: ""
    };
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
          $('input[id=username]').css("border-bottom", "2px solid green");
          $('#invalid-username').text("");
        } else {
          $('input[id=username]').css("border-bottom", "2px solid red");
          $('#invalid-username').text(data.error).show();
        }
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(err.toString());
        }.bind(this)
    });
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
          $('input[id=login]').css("border-bottom", "2px solid green");
          $('#invalid-email').text("");
        } else {
          $('input[id=login]').css("border-bottom", "2px solid red");
          $('#invalid-email').text(data.error).show();
        }
        }.bind(this),
        error: function(xhr, status, err) {
          console.error(err.toString());
        }.bind(this)
    });
  },

  render: function() {
    var confirmatiom_text = "Didn't receive confirmation instructions?";

    return (<form ref="form" className="sign-up-form form-horizontal ws-validate" id="new_user" acceptCharset="UTF-8" onSubmit={ this._onKeyDown }>
                <input type="hidden" name={this.props.form.csrf_param} value={this.props.form.csrf_token} />
          
                <div className="form-control-wrapper">
                  <label>Name</label>
                  <input ref="name" required="required" autoComplete="off" id="name" className="string required form-control empty" placeholder="John Doe" type="text" name="user[name]" />
                </div>

                <div className="form-control-wrapper">
                  <label>Username</label>
                  <input ref="username" required="required" autoComplete="off"  onBlur={this.onUsernameChange} id="username" className="string required form-control empty" placeholder="johndoe" type="text" name="user[username]" />
                  <span className="invalid" id="invalid-username"></span>
                </div>

                <div className="form-control-wrapper">
                  <label>Email</label>
                  <input ref="email" required="required" id="login" autoComplete="off"  onBlur={this.onEmailChange} className="string email required form-control empty" placeholder="johndoe@example.com" type="email" name="user[email]" />
                  <span className="invalid" id="invalid-email"></span>
                </div>
                <div className="form-control-wrapper">
                  <label>Password</label>
                  <input ref="password" required="required" autoComplete="off" id="password" className="password required form-control empty" placeholder="*********" type="password" name="user[password]" />
                </div>

                <div className="signup-form-buttons">
                  <button name="button" type="submit" className="main-button">Join</button>
                </div>
                
                <div className="signup-box-footer">
                <p>Or, Signup using <a href="/join">social accounts</a></p>
                <p>Already registered, <a href="/login">Login</a></p>
                <p>
                <a href="/account/confirm/resend">{confirmatiom_text}</a>
                </p>
                </div>
             </form>     
    )
  },

  _onKeyDown: function(event) {
      event.preventDefault();
      if(this.refs.username.getDOMNode().value.trim() && this.refs.email.getDOMNode().value.trim() && this.refs.password.getDOMNode().value.trim() && this.refs.name.getDOMNode().value.trim()) {
        var formData = $( this.refs.form.getDOMNode() ).serialize();
        this.props.handleRegisterationSubmit(formData);
      } else {
        event.stopPropagation();
      }
  }


});
