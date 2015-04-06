/** @jsx React.DOM */

var Login = React.createClass({
  getInitialState: function() {
    return {
      form: this.props.form,
      name: "",
      loading: false,
      disabled: false
    };
  },
  
  handleLoginSubmit: function ( data ) {
    var self = this;
    this.setState({disabled: true})
    this.setState({loading: true})
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: data,
      url: Routes.user_session_path(),
      type: "POST",
      dataType: "json",
      success: function ( data ) {
      if(data.name) {
        window.location = Routes.root_path();
        self.setState({disabled: false, loading: false});
      }
      }.bind(this),
      error: function(xhr, status, err) {
        var errors = JSON.parse(xhr.responseText);
        $('body').pgNotification({style: "simple", message: errors.error.toString(), position: "top-right", type: "danger",timeout: 5000}).show();

        this.setState({disabled: false, loading: false});
      }.bind(this)
    });
  },
  render: function() {

    return (<LoginForm disabled={this.state.disabled} loading={this.state.loading} form={this.state.form} handleLoginSubmit={this.handleLoginSubmit} checkUser = {this.checkUser} />);
  }

});
