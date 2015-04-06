/** @jsx React.DOM */

var TeacherRegister = React.createClass({
  getInitialState: function() {
    return {
      form: this.props.form,
      name: "",
      loading: false,
      errors: []
    };
  },

  handleRegisteration: function ( formData ) {
    var self = this;
    this.setState({loading: true})
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: Routes.mentor_registration_path(),
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        if(data.name) {
          $('body').pgNotification({style: "simple", message: "Registeration Successful. Please confirm your email.", position: "top-right", type: "success",timeout: 5000}).show();
          setTimeout(function(){
            window.location.href = Routes.root_path;
          }, 3000);
        }
        this.setState({loading: true});
      }.bind(this),
      error: function(xhr, status, err) {
        this.setState({loading: true});
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
    return (<TeacherRegisterationForm loading={this.state.loading} form={this.state.form} handleRegisterationSubmit={this.handleRegisteration} />);
  }

});
