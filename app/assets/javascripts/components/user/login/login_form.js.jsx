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

  var confirmation_text = "Didn't recieve email confirmation? Click here";
  var account_text = "Don't have an account? Click here";

  return (

    <form id="form-login" ref="form" className="p-t-15 clearfix" role="form" action="index.html" noValidate="novalidate" acceptCharset="UTF-8" onSubmit={ this._onKeyDown }>
      <div className="form-group form-group-default">
        <label>Login</label>
        <div className="controls">
          <input type="text" name="user[login]" autoComplete="off" placeholder="User Name" className="form-control" required="true" aria-required="true" />
        </div>
      </div>
      <div className="form-group form-group-default">
        <label>Password</label>
        <div className="controls">
          <input type="password" autoComplete="off" className="form-control" name="user[password]" placeholder="Credentials" required="true" aria-required="true" />
        </div>
      </div>
      <div className="row">
        <div className="col-md-6 no-padding">
          <div className="checkbox check-success">
            <input type="checkbox" name="user[remember_me]" value="1" id="checkbox1" defaultChecked/>
            <label for="checkbox1">Keep Me Signed in</label>
          </div>
        </div>
        <div className="col-md-6 text-right">
          <a href="#" className="text-info small">Need Help? Click here</a>
        </div>
      </div>
      <button className="btn btn-complete btn-cons m-t-10" type="submit"><i className={loading_class}></i> Sign in</button>
      <a className="btn btn-primary btn-cons m-t-10" href="/account/reset-password">Forgot your password? </a>
      <div className="col-md-12 no-padding m-t-20">
        <a className="clearfix" href="/account/confirm/resend">{confirmation_text}</a>
        <a className="clearfix" href="/students_join">{account_text}</a>
      </div>
    </form>
  );
},

_onKeyDown: function(event) {
    event.preventDefault();
    if($(this.refs.form.getDOMNode()).valid()) {
      var formData = $( this.refs.form.getDOMNode() ).serialize();
      this.props.handleLoginSubmit(formData);
    }

}


});
