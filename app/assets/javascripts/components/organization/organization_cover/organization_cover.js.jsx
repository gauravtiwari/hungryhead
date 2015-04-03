/** @jsx React.DOM */

var OrganizationCover = React.createClass({
  getInitialState: function() {
    return {
      cover: this.props.organization.cover,
      form: this.props.organization.form,
      draggable: false,
      is_owner: this.props.organization.is_owner,
      position: this.props.organization.cover.position,
      visible: false,
      loading: false
    }
  },

  triggerOpen: function(e) {
    e.preventDefault();
    $('input[id=organization_cover]').click();
  },

  _onUpdate: function(event) {
    event.preventDefault();
    var formData = $( this.refs.coverForm.getDOMNode() ).serialize();
    this.updateCover(formData);
    this.setState({draggable: false});
    this.setState({visible: false});
  },

  _onCancel: function() {
    this.setState({draggable: !this.state.draggable});
    this.setState({visible: !this.props.visible});
  },

  handleReposition: function(e) {
    var self = this;
    this.setState({draggable: !this.state.draggable});
    this.setState({visible: !this.props.visible});
    $("#organization_cover_preview").draggable({
      stop:function(event,ui) {
        var wrapper = $("#cover-wrap").offset();
        var pos = ui.helper.offset();
        self.setState({position: (pos.top - wrapper.top)});
      }
    });
  },

  updateCover: function(formData) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: this.state.form.action,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        this.setState({
          cover: data.organization.cover,
          form: data.organization.form,
          loading: false
        });
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
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
          cover: data.organization.cover ,
          form: data.organization.form
        });
      this.forceUpdate();
      this.setState({ loading: false });
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.state.url, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
      var cx = React.addons.classSet;
      var upload_class = cx({
        'uploading': true
      });

      var drag_class = cx({
        'cover-wrap': true,
        'normal': !this.state.draggable,
        'drag': this.state.draggable
      });

      var classes = cx({
        'fa fa-camera': !this.state.loading,
        'fa fa-spinner fa-spin': this.state.loading
      });

      if(this.state.draggable) {
        $('.university-data').hide();
        $('.follow-list').hide();
      } else {
        $('.university-data').show();
        $('.follow-list').show();
      }

      var imageStyle = {
        position: 'absolute',
        left: '0%',
        right: '0%',
        width: '100%',
        top: '' + this.state.cover.position + '',
      };

      if(this.state.cover !== undefined){
        var image = <img className="cover-image" id="organization_cover_preview" src={this.state.cover.url} style={imageStyle}/>;
      } else {
        var image = <img src="http://placehold.it/200&text=cover" className="cover-image" id="usercover_preview" />;
      }

      if(this.state.is_owner) {
        return (
          <div className={drag_class} id="cover-wrap">
            <form ref="coverForm" method="PUT" action={this.state.form.action} id="cover-upload" className="cover-form" onChange={this._onChange} encType="multipart/form-data">
              <input type="hidden" name="_method" value={this.state.form.method} />
              <input type="file" ref="cover" style={{"display" : "none"}} name="organization[cover]" id="organization_cover" />
               <input type="hidden" ref="position" name="organization[cover_position]" value={this.state.position} />
              <input type="hidden" name={ this.state.form.csrf_param } value={ this.state.form.csrf_token } />
            </form>
            <div id="coverpic">
              {image}
            </div>
            <CoverEditMenu loading={this.state.loading} onCancel={this._onCancel} onUpdate={this._onUpdate} draggable={this.state.draggable} visible={this.state.visible} cover = {this.state.cover} triggerOpen = {this.triggerOpen} handleDelete ={this.handleDelete} handleReposition = {this.handleReposition} />
          </div>
        )
     } else {
       return (
      <div className={drag_class} id="cover-wrap">
       <div id="coverpic">
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
        $('#usercover_preview').attr('src', upload.target.result);
      }.bind(this);
      reader.readAsDataURL(file);
       $('#cover-upload').ajaxSubmit({
      'type' : 'PUT',
       beforeSubmit: function(a,f,o) {
         o.dataType = 'json';
       },
       complete: function(XMLHttpRequest, textStatus) {
         var response = JSON.parse(XMLHttpRequest.responseText);
         self.setState({
           cover: response.organization.cover,
           form: response.organization.form,
           loading: false,
           draggable: !self.state.draggable,
            visible: !self.state.visible
         });
         self.setPosition();
       }

    });

  }

});
