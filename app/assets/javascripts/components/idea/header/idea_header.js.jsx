var IdeaHeader = React.createClass({

  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      data: data,
      idea: data.idea
    }
  },

  saveIdeaForm:function(formData, action) {
    $.pubsub('publish', 'idea_edit_form_saving', true);
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: action,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        this.setState({idea: data.idea});
        $('#editIdeaFormPopup').modal('hide');
        $('body').pgNotification({style: "simple", message: "Idea Profile Updated", position: "bottom-left", type: "success",timeout: 5000}).show();
        $.pubsub('publish', 'idea_edit_form_saving', false);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  openForm: function() {
    $('body').append($('<div>', {class: 'edit_idea_form_modal', id: 'edit_idea_form_modal'}));
    React.render(<IdeaEditForm key={this.state.idea.uuid} closeForm={this.closeForm} openForm={this.openForm} idea={this.state.idea} form={this.state.idea.form} saveIdeaForm={this.saveIdeaForm} />,
      document.getElementById('edit_idea_form_modal')
    );
    $('#editIdeaFormPopup').modal('show');
  },

  closeForm: function() {
    $('#editIdeaFormPopup').modal('hide');
  },

  render: function() {
    if(this.state.data.meta.is_owner) {
      var text = <span><i className="fa fa-pencil"></i> Edit</span>;
    } else {
      var text = "";
    }
    return (
      <div className="panel bg-solid box-shadow m-b-10">
        <div className="panel-body">
          <IdeaProfile idea={this.state.idea} text={text} openForm={this.openForm} />
          <IdeaPitch idea={this.state.idea} text={text} openForm={this.openForm} />
          <IdeaCardStats data={this.props.stats} />
        </div>
      </div>
    );
  }
});