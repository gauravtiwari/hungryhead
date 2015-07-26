var Card = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      profile: data.user.profile,
      id: data.user.id,
      form: data.user.form,
      is_owner: data.user.is_owner,
      disabled: false
    }
  },

  saveSidebarWidget:function(formData, action) {
    $.pubsub('publish', 'sidebar_widget_saving', true);
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: action,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        this.setState({profile: data.user.profile});
        $('#editProfileFormPopup').modal('hide');
        $('body').pgNotification({style: "simple", message: "Profile Updated", position: "bottom-left", type: "success",timeout: 5000}).show();
        $.pubsub('publish', 'sidebar_widget_saving', false);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  openForm: function() {
    $('body').append($('<div>', {class: 'edit_profile_form_modal', id: 'edit_profile_form_modal'}));
    React.render(<CardForm key={Math.random()} closeForm={this.closeForm} openForm={this.openForm} profile={this.state.profile} loading={this.state.loading} form={this.state.form} saveSidebarWidget={this.saveSidebarWidget} />,
      document.getElementById('edit_profile_form_modal')
    );
    $('#editProfileFormPopup').modal('show');
  },

  closeForm: function() {
    $('#editProfileFormPopup').modal('hide');
  },

  render: function() {

  if(this.state.is_owner) {
    if(this.state.mode){
      var text = <span className="fa fa-times-circle"> Cancel</span>;
    } else {
      var text = <span className="fa fa-pencil"> Edit</span>;
    }
  } else {
    var text = "";
  }
    return (<CardContent key={Math.random()} openForm={this.openForm} text={text} data={this.props.data} is_owner={this.state.is_owner} profile={this.state.profile} />
    );
  }

});
