/** @jsx React.DOM */

var LoginForm = React.createClass({
render: function() {
  var cx = React.addons.classSet;

  var button_class = cx ({
    'main-button': true,
    'disabled': this.props.disabled
  });

  var loading_class = cx ({
    'fa fa-spinner fa-spin': this.props.loading
  });
  return ( <form ref="form" className="sign-in-form form-horizontal ws-validate" id="new_user" acceptCharset="UTF-8" onSubmit={ this._onKeyDown }>
            <input type="hidden" name={this.props.form.csrf_param} value={this.props.form.csrf_token} />
              <div className="form-control-wrapper">
                <label>Email</label>
                <input ref="email" autoComplete="off" required="required" onBlur={this.props.checkUser} autofocus="autofocus" label="false" id="email" className="string required form-control empty" placeholder="johndoe@example.com" type="email" name="user[login]" />
                <span className="material-input"></span>
              </div>
              <div className="form-control-wrapper">
                <label>Password</label>
                 <input ref="password" autoComplete="off" required="required" label="false" id="password" className="password required form-control empty" placeholder="*********" type="password" name="user[password]" />
                 <span className="material-input"></span>
              </div>
              <div className="checkbox">
                  <label>
                      <input type="checkbox" name="user[remember_me]" id="user_remember_me" />
                      <span className="check"></span> Remember me
                  </label>
              </div>
              <div className="login-form-buttons">
              <a className="forgotpassword" href="/account/reset-password">Forgot your password? </a>
                <button name="button" type="submit" className={button_class}><i className={loading_class}></i> Login</button>
              </div>
          </form> 
  );
},

_onKeyDown: function(event) {
    event.preventDefault();
    var formData = $( this.refs.form.getDOMNode() ).serialize();
    this.props.handleLoginSubmit(formData);

}


});
