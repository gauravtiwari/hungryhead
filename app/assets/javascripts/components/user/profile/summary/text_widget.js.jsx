/** @jsx React.DOM */
var converter = new Showdown.converter();
var TextWidget = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    if(data.user.about_me && data.user.about_me.content.length > 0) {
      var content = data.user.about_me.content;
    } else {
      var content = "";
    }
    return {
      content: content,
      user: data.user,
      form: data.user.about_me.form,
      loading: false,
      mode: false,
      preview: false
    }
  },

  componentDidMount: function() {
    this.setState({disabled: false})
  },

  showPreview: function() {
    this.setState({preview: !this.state.preview });
  },

  publishWidget:function(formData, action, text) {
    this.setState({content: text.about_me});
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: this.state.form.action,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        this.setState({content: data.user.about_me.content});
        this.setState({mode: false});
        this.setState({preview: false });
        this.setState({loading: false});
        if(data) {
          $('body').pgNotification({style: "simple", message: "Profile Updated", position: "top-right", type: "success",timeout: 5000}).show();
        }
      }.bind(this),
      error: function(xhr, status, err) {
        this.setState({mode: false});
        this.setState({preview: false });
        this.setState({loading: false});
        var errors = JSON.parse(xhr.responseText);
        $('body').pgNotification({style: "simple", message: errors.error.toString(), position: "top-right", type: "danger",timeout: 5000}).show();
      }.bind(this)
    });
  },

  openForm: function() {
    this.setState({mode: !this.state.mode});
  },

  render: function() {
    if(this.state.user.is_owner) {
      if(this.state.mode){
        var text = <span className="fa fa-close"> Cancel</span>;
      } else {
        var text = <span className="fa fa-pencil"> Edit</span>;
      }
    }
  
    if(this.state.content) {
      var html = converter.makeHtml(this.state.content);
    } else {
      if(this.state.user.is_owner) {
        var html = "<div class='text-master text-center auto-margin col-md-8 fs-16 light'>Write about yourself. <span>What are you studying? Your interests? Why are you here? etc.</span> </div>";
      } else {
        var html = "<div class='text-master text-center auto-margin col-md-8 fs-16'>" + this.state.user.name + " has not published about himself</div>";
      }
    }

    if(this.state.preview) {
      var preview = <PreviewContent content={html} />
    }
    return (
        <div className="widget-16 about-me text-master panel panel-transparent no-margin">
            <div className="panel no-margin">
                <TextWidgetHeader text={text} openForm={this.openForm} />
                <TextWidgetContent mode={this.state.mode} content={html} />
                {preview}
                <TextWidgetForm showPreview = {this.showPreview} content={this.state.content} preview = {this.state.preview} mode={this.state.mode} loading={this.state.loading} form={this.state.form} publishWidget ={this.publishWidget} />
            </div>
        </div>
    );
  }

});
