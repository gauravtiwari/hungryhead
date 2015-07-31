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
          $('#form-register').hide().fadeOut('fast');
          $('.student-registeration-form').html("<div class='no-content animated fadeIn text-green'> Registeration Successful. You will receive an email shortly on " + data.email + "</div>");
        }
        if(data.error){
          $('body').pgNotification({style: "simple", message: data.error.toString(), position: "top-right", type: "danger",timeout: 5000}).show();
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
