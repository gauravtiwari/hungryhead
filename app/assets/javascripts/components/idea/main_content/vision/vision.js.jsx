/** @jsx React.DOM */
var converter = new Showdown.converter();

var Vision = React.createClass({

  getInitialState: function() {
    return {
      mode: false,
      editable: false,
      loading: false
    }
  },

  componentDidMount: function() {
    var self = this;
    $.pubsub('subscribe', 'closeSectionForm', function(msg, data){
      self.setState({loading: data, editable: false});
    });
  },

  handleVisionSubmit: function(formData, description) {
    this.setState({description: description.description});
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: Routes.idea_path(this.props.idea.id),
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  openVisionForm: function() {
    this.setState({editable: !this.state.editable});
  },

  showMarkDownModal: function(){
    React.render(
          <MarkDownHelpModal />,
          document.getElementById('markdown-modal')
        );
    $('#markdownPopup').modal('show');
  },


  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'idea-vision': true,
      'hidden': this.state.editable,
      'show': !this.state.editable
    });

    var video_classes = cx({
      'video-wrapper': true,
      'hidden': this.state.editable,
      'show': !this.state.editable
    });

    if(this.state.error) {
      var error = <span className="alert alert-danger">{this.state.error}</span>;
    }

    var text = this.state.editable ? <span><i className="ion-close"></i> Cancel </span> : <span><i className="ion-edit"></i> Edit vision</span>;
    
    if(this.props.idea.sections && this.props.idea.sections.vision) {
      var html = converter.makeHtml(this.props.idea.sections.vision);
    } else {
      var html = "<div class='no-content'>Your vision. <span>What's different you see that others don't? etc.</span> </div>";
    }

    if(this.props.meta.is_owner) {
      return (
        <div className="widget-box the-vision">
          {error}
          <div className="profile-wrapper-title">
              <h4><i className="ion-earth red-link"></i> Purpose & Vision</h4>
              <a className="show-all margin-right" onClick={this.showMarkDownModal}><i className="ion-help-circled"></i> Markdown Help</a>
              <a className="show-all" onClick={this.openVisionForm}>{text}</a>
          </div>

          <div className="section-content vision">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <VisionForm editable={this.state.editable} idea={this.props.idea} loading= {this.state.loading} handleVisionSubmit= {this.handleVisionSubmit} form={this.props.idea} />
          </div>
        </div>
      )
    } else {
       return (
      <div className="widget-box the-vision">
        <div className="profile-wrapper-title">
            <h4><i className="ion-earth red-link"></i> Purpose & Vision</h4>
        </div>

        <div className="section-content vision">
          <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
        </div>
      </div>
    )
    }
  }
});
