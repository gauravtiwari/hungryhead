/** @jsx React.DOM */

var SchoolLogo = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);
    return {
      logo: data.school.logo,
      badge: data.school.badge,
      form: data.school.form,
      is_owner: data.school.is_owner,
      loading: false
    }
  },

  componentDidMount: function() {
    this.setState({loading: false});
  },

  triggerOpen: function(e) {
    e.preventDefault();
    $('input[id=school_logo]').click();
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

      if(this.state.logo.url) {
        var image = <img className="user-image" id="schoolpic_preview" width="110" height="110" src={this.state.logo.url} />;
      } else {
        var image = <span className="placeholder bold text-white fs-22">{this.state.badge}</span>;
      }

      if(this.state.is_owner) {
      return (
        <div id="profile_image">
          <form ref="logoForm" method="PUT" action={this.state.form.action} id="logo-upload" className="logo-form" onChange={this._onChange} encType="multipart/form-data">
            <input type="hidden" name="_method" value={this.state.form.method} />
            <input type="file" ref="logo" style={{"display" : "none"}} direct = "true" name="school[logo]" id="school_logo" />
          </form>
          <div id="userpic">
          <div className="logo no-margin">
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
        $('#schoolpic_preview').attr('src', upload.target.result);
        $('#school_pic_menu').attr('src', upload.target.result);
      }.bind(this);
      reader.readAsDataURL(file);
      var form = document.getElementById('logo-upload');
       $('#logo-upload').ajaxSubmit({
      'type' : 'PUT',
       beforeSubmit: function(a,f,o) {
         o.dataType = 'json';
       },
       complete: function(XMLHttpRequest, textStatus) {
         var response = JSON.parse(XMLHttpRequest.responseText);
         self.setState({
           logo: response.school.logo,
           form: response.school.form,
           loading: false
         });
       }

    });

  }

});
