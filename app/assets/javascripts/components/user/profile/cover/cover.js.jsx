/** @jsx React.DOM */

var Cover = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);

    if(data.user.cover) {
      var position = data.user.cover.position;
    }
    return {
      cover: data.user.cover,
      form: data.user.form,
      position: position,
      draggable: false,
      is_owner: data.user.is_owner,
      visible: false,
      loading: false
    }
  },

  triggerOpen: function(e) {
    e.preventDefault();
    $('input[id=user_cover]').click();
  },

  _onUpdate: function(event) {
    event.preventDefault();
    var formData = $( this.refs.coverForm.getDOMNode() ).serialize();
    this.updateCover(formData);
    this.setState({draggable: false});
    this.setState({visible: false});
  },

  _onCancel: function() {
    this.setState({draggable: false});
    this.setState({visible: false});
  },

  handleReposition: function(e) {
    this.setState({draggable: !this.state.draggable});
    this.setState({visible: !this.props.visible});
    this.handleCoverDrag()
  },

  handleCoverDrag: function(){
   var self = this;
   $("#usercover_preview").draggable({
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
          cover: data.user.cover,
          form: data.user.form,
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
      url: this.state.form.delete_action,
      type: "DELETE",
      dataType: "json",
      success: function ( data ) {
        this.setState({
          cover: data.user.cover ,
          form: data.user.form
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
        $('.inner-profile-content').hide();
      } else {
        $('.inner-profile-content').show();
      }

      if(this.state.cover !== undefined){
        var position = this.state.position;
         var imageStyle = {
          position: 'absolute',
          left: '0%',
          right: '0%',
          width: '100%',
          top: '' + position + '',
        };
        var image = <img className="cover-image" id="usercover_preview" src={this.state.cover.url} style={imageStyle}/>;
        
      } else {
        var image = <img src="http://placehold.it/200&text=cover" className="cover-image" id="usercover_preview" />;
      }


      if(this.state.is_owner) {
        return (
          <div className={drag_class} id="cover-wrap">
            <form ref="coverForm" method="PUT" action={this.state.form.action} id="cover-upload" className="cover-form" onChange={this._onChange} encType="multipart/form-data">
              <input type="hidden" name="_method" value={this.state.form.method} />
              <input type="file" ref="cover" style={{"display" : "none"}} name="user[cover]" id="user_cover" />
               <input type="hidden" ref="position" name="user[cover_position]" value={position} />
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
           cover: response.user.cover,
           form: response.user.form,
           loading: false,
           draggable: !self.state.draggable,
          visible: !self.state.visible
         });

         self.handleCoverDrag();
       }

    });

  }

});
