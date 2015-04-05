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
    $.pubsub('subscribe', 'join_name_changed', function(msg, data){
      self.setState({name: data});
    });
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

      }.bind(this),
      error: function(xhr, status, err) {
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
    return (<RegisterationForm form={this.state.form} handleRegisterationSubmit={this.handleRegisteration} />);
  }

});
