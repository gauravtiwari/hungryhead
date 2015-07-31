var Register = React.createClass({
  getInitialState: function() {
    return {
      form: this.props.form,
      name: "",
      errors: [],
      loading: false
    };
  },

  handleRegisteration: function ( formData ) {
    var self = this;
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: Routes.user_registration_path(),
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        if(data.name) {
          $('#form-register').remove();
          $('body').pgNotification({style: "simple", message: "Registeration Successful. You will receive an email shortly on " + data.email + ". Redirecting...", position: "top-right", type: "success",timeout: 5000}).show();
          setTimeout(function(){
            window.location.href = Routes.root_path;
          }, 3000);
        }

        this.setState({loading: false});
      }.bind(this),
      error: function(xhr, status, err) {
        this.setState({loading: false});
        var errors = JSON.parse(xhr.responseText);
        $.each(errors, function(keys, values) {
           _.map(values, function(key, value) {
            $('body').pgNotification({style: "simple", message: (value + " " + key[0]).toString(), position: "top-right", type: "danger",timeout: 5000}).show();
           });
        });
      }.bind(this)
    });
  },

  render: function() {
    return (<RegisterationForm loading={this.state.loading} form={this.state.form} handleRegisterationSubmit={this.handleRegisteration} />);
  }

});
