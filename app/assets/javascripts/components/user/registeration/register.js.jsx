/** @jsx React.DOM */

var Register = React.createClass({
  getInitialState: function() {
    return {
      form: this.props.form,
      name: "",
      errors: []
    };
  },

  componentDidMount: function() {
    this.setState({disabled: false});
    var self = this;
  },

  handleRegisteration: function ( formData ) {
    var self = this;
    this.setState({disabled: true})
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: Routes.user_registration_path(),
      type: "POST",
      dataType: "json",
      success: function ( data ) {
      if(data.invalid) {
        var options =  {
          content: ""+data.msg+"",
          style: "error",
          timeout: 10000
        }
        $.snackbar(options);
      }
      if(data.name) {
        $.snackbar ({
          content: "Registeration successfull. We have emailed you a link to confirm your email.", 
          style: "notice", 
          timeout: 5000
        });
        setTimeout(function(){
          window.location = Routes.root_path();
          self.setState({disabled: false});
        }, 2000);
      }
      }.bind(this),
      error: function(xhr, status, err) {
        $.snackbar({content: err, style: "error", timeout: 5000});
      }.bind(this)
    });
  },

  render: function() {
    return (<div className="signup-page">
            <div className="container">
              <div className="form-signup auto-margin panel panel-default">
               <RegisterationHeader />
               <RegisterationForm form={this.state.form} handleRegisterationSubmit={this.handleRegisteration} />
              </div>
            </div>
          </div>
    );
  }

});
