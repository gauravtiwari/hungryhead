var EventCover = React.createClass({
  getInitialState: function() {
    var data = JSON.parse(this.props.data);

    if(data.event.cover) {
      var top = data.event.cover.top;
      var left = data.event.cover.left;
    }
    return {
      cover: data.event.cover,
      form: data.event.form,
      top: top,
      left: left,
      draggable: false,
      is_owner: data.event.is_owner,
      visible: false,
      loading: false
    }
  },

  triggerOpen: function(e) {
    e.preventDefault();
    $('input[id=event_cover]').click();
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
   $("#coverpic").draggable({
    containment: "cover-wrap-event",
    cursor: "crosshair",
    drag:function(event, ui) {
      var wrapper = $("#cover-wrap-event").offset();
      ui.position.left = Math.min( 100, ui.position.left );
      ui.position.top = Math.min( 100, ui.position.top );
      self.setState({top:  ui.position.top, left: ui.position.left});
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
          cover: data.event.cover,
          form: data.event.form,
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
          cover: data.event.cover ,
          form: data.event.form
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
        'social': true,
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

      if(this.state.cover.has_cover){
        var top = this.state.top || "auto";
        var left = this.state.left || "auto";
        var imageStyle = {
          position: 'absolute',
          right: 'auto',
          top: '' + top + '',
          left: '' + left + '',
        };
        var image = <img className="cover-photo" id="event_cover_preview" src={this.state.cover.url} />;
      } else {
        if(this.state.is_owner) {
        var handle = <h2 className="text-white pull-right fs-50"><i className="fa fa-upload fs-50"></i> Click to upload cover</h2>;
        var image = <div className="no-content cover-handle bold z-index-10" onClick={this.triggerOpen}>{handle}</div>;
      } else {
        var image = <img className="cover-photo" src={this.state.cover.url} />;
      }
    }


      if(this.state.is_owner) {
        return (

          <div className={drag_class} data-pages="parallax" data-social="cover" id="cover-wrap-event">
              <form ref="coverForm" method="PUT" action={this.state.form.action} id="cover-upload" className="cover-form" onChange={this._onChange} encType="multipart/form-data">
                <input type="hidden" name="_method" value={this.state.form.method} />
                <input type="file" ref="cover" style={{"display" : "none"}} name="event[cover]" id="event_cover" />
                <input type="hidden" ref="position" name="event[cover_position]" value={top} />
                <input type="hidden" ref="position" name="event[cover_left]" value={left} />
              </form>
              <div id="coverpic" style={imageStyle}>
                {image}
              </div>
              <CoverEditMenu loading={this.state.loading} onCancel={this._onCancel} onUpdate={this._onUpdate} draggable={this.state.draggable} visible={this.state.visible} cover = {this.state.cover} triggerOpen = {this.triggerOpen} handleDelete ={this.handleDelete} handleReposition = {this.handleReposition} />
          </div>
        )
     } else {
       return (
      <div className={drag_class} data-social="cover" id="cover-wrap-event" id="cover-wrap-event">
           <div id="coverpic" style={imageStyle}>
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
        $('#eventcover_preview').attr('width', "100%");
        $('#eventcover_preview').attr('style', "");
        $('#eventcover_preview').attr('src', upload.target.result);
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
           cover: response.event.cover,
           form: response.event.form,
           loading: false,
           draggable: !self.state.draggable,
          visible: !self.state.visible
         });

         self.handleCoverDrag();
       }

    });

  }

});
