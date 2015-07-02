/** @jsx React.DOM */

var Avatar = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      avatar: data.user.avatar,
      badge: data.user.badge,
      form: data.user.form,
      is_owner: data.user.is_owner,
      loading: false
    }
  },

  componentDidMount: function() {
    this.setState({loading: false});
  },

  triggerOpen: function(e) {
    e.preventDefault();
    $('input[id=user_avatar]').click();
  },

  render: function() {
      var cx = React.addons.classSet;
      var upload_class = cx({
        'uploading': true
      });

      var classes = cx({
        'fa fa-camera text-white': !this.state.loading,
        'fa fa-spinner text-white fa-spin': this.state.loading
      });

      if(this.state.avatar && this.state.avatar.url) {
        var image = <img className="user-image" id="userpic_preview" width="110" height="110" src={this.state.avatar.url} />;
      } else {
        var image = <span className="placeholder bold text-white fs-22">{this.state.badge}</span>;
      }

      if(this.state.is_owner) {
      return (
        <div id="profile_image">
          <form ref="avatarForm" role="form" method="PUT" action={this.state.form.action} id="avatar-upload" className="avatar-form" onChange={this._onChange} encType="multipart/form-data">
            <input type="hidden" name="_method" value={this.state.form.method} />
            <input type="file" ref="avatar" style={{"display" : "none"}} direct = "true" name="user[avatar]" id="user_avatar" />
          </form>
          <div id="userpic">
          <div className="avatar">
            <div className="upload_icon">
              <a id ="trigger-file-upload" className="trigger-file-upload" data-toggle="dropdown">
                <span className={upload_class}>
                  <i className={classes} onClick={this.triggerOpen}></i>
                </span>
              </a>
            </div>
          </div>
            {image}
          </div>
        </div>
      )
    } else {
      return (
        <div id="profile_image">
          <div id="userpic">
            {image}
          </div>
        </div>
      )
    }
  },

  _onChange: function(e) {
      this.setState({loading: true});
      e.preventDefault();
      var self = this;
      var reader = new FileReader();
      var file = e.target.files[0];
      reader.onload = function(upload) {
        $('#userpic_preview').attr('src', upload.target.result);
        $('#user_pic_mini').attr('src', upload.target.result);
        $('#user_pic_menu').attr('src', upload.target.result);
      }.bind(this);
      reader.readAsDataURL(file);
      var form = document.getElementById('avatar-upload');
       $('#avatar-upload').ajaxSubmit({
      'type' : 'PUT',
       beforeSubmit: function(a,f,o) {
         o.dataType = 'json';
       },
       complete: function(XMLHttpRequest, textStatus) {
         var response = JSON.parse(XMLHttpRequest.responseText);
         $('#user_pic_mini').attr('src', response.user.avatar.url);
         $('#user_pic_menu').attr('src', response.user.avatar.url);
         self.setState({
           avatar: response.user.avatar,
           form: response.user.form,
           loading: false
         });
       }

    });

  }

});
