
var LoginForm = React.createClass({
render: function() {
  var button_class = classNames ({
    'main-button': true,
    'disabled': this.props.disabled
  });

  var loading_class = classNames ({
    'fa fa-spinner fa-spin': this.props.loading
  });

  var confirmation_text = "Didn't recieve email confirmation? Click here";
  var account_text = "Don't have an account? Click here";

  return (

    <form id="form-login" ref="form" className="p-t-15 clearfix sm-p-b-100" role="form" noValidate="novalidate" acceptCharset="UTF-8" onSubmit={ this._onKeyDown }>
      <div className="form-group">
        <div className="controls">
          <input type="text" name="user[login]" autoCorrect="off" autoComplete="off" autoCapitalize="off" placeholder="Email or UserName" className="form-control" required="true" aria-required="true" />
        </div>
      </div>
      <div className="form-group">
        <div className="controls">
          <input type="password" autoComplete="off" autoCorrect="off" autoCapitalize="off" className="form-control" name="user[password]" placeholder="Password" required="true" aria-required="true" />
        </div>
      </div>
      <div className="row">
        <div className="col-sm-6 md-no-padding">
          <div className="checkbox check-success">
            <input type="checkbox" name="user[remember_me]" value="1" id="checkbox1" defaultChecked/>
            <label htmlFor="checkbox1" className="text-white">Keep Me Signed in</label>
          </div>
        </div>
      </div>
      <button className="btn btn-brand text-white m-r-10 btn-cons m-t-10" type="submit"><i className={loading_class}></i> Sign in</button>
    </form>
  );
},

_onKeyDown: function(event) {
    event.preventDefault();
    if($(this.refs.form).valid()) {
      var formData = $( this.refs.form ).serialize();
      this.props.handleLoginSubmit(formData);
    }

}


});
