var Logo = React.createClass({
  getInitialState: function() {
    return {
      logo: this.props.logo,
      form: this.props.form
    }
  },

  componentDidMount: function() {
    this.setState({loading: false});
  },

  triggerOpen: function(e) {
    e.preventDefault();
    $('input[id=idea_logo]').click();
  },

  handleDelete: function() {
    this.setState({ loading: true });
    $.ajaxSetup({ cache: false });
    $.ajax({
      url: this.state.form.action,
      type: "DELETE",
      dataType: "json",
      success: function ( data ) {
        this.setState({
          logo: data.idea.logo ,
          form: data.idea.form
        });

      $('#userpic_preview').attr('src', "http://placehold.it/200&text=logo");
      $('#user_pic_mini').attr('src', "http://placehold.it/200&text=logo");
      $('#user_pic_menu').attr('src', "http://placehold.it/200&text=logo");
      this.forceUpdate();
      this.setState({ loading: false });
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
      var upload_class = classNames({
        'uploading': true
      });

      var classes = classNames({
        'fa fa-camera': !this.state.loading,
        'fa fa-spinner fa-spin': this.state.loading
      });

      if(this.state.logo !== undefined){
        var image = <img className="idea-image" id="idealogo_preview" width="110px" height="110px" src={this.state.logo.url} />;

      } else {
        var image = <img src="" className="idea-image" width="110px" height="110px" id="idealogo_preview" />;
      }

      return (
        <div id="idea_image">
          <form ref="logoForm" method="POST" action={this.state.form.action} id="logo-upload" className="logo-form" onChange={this._onChange} encType="multipart/form-data">
            <input type="hidden" name="_method" value={this.state.form.method} />
            <input type="file" ref="logo" style={{"display" : "none"}} name="idea[logo]" id="idea_logo" />
          </form>
          <div id="userpic">
          <div className="logo">
            <a id ="trigger-file-upload" className="trigger-file-upload" data-toggle="dropdown">
              <span className={upload_class} onClick={this.triggerOpen}>
                <i className={classes}></i>
              </span>
            </a>
            </div>
            {image}
          </div>
        </div>
      )
  },

  _onChange: function(e) {
      this.setState({loading: true});
      e.preventDefault();
      var self = this;
      var reader = new FileReader();
      var file = e.target.files[0];
      reader.onload = function(upload) {
        $('#idealogo_preview').attr('src', upload.target.result);
        $('#idealogo_mini').attr('src', upload.target.result);
      }.bind(this);
      reader.readAsDataURL(file);
      var form = document.getElementById('logo-upload');
       $('#logo-upload').ajaxSubmit({
       beforeSubmit: function(a,f,o) {
         o.dataType = 'json';
       },
       complete: function(XMLHttpRequest, textStatus) {
         var response = JSON.parse(XMLHttpRequest.responseText);
         self.setState({
           logo: response.idea.logo,
           form: response.idea.form,
           loading: false
         });
       }

    });

  }

});
