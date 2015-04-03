/** @jsx React.DOM */

var MetaVideo = React.createClass({

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

  handleVideoSubmit: function(formData) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: Routes.update_meta_path(this.props.meta.id),
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        $.pubsub('publish', 'updated_meta'+this.props.meta.id, data);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  openPlanForm: function() {
    this.setState({editable: !this.state.editable});
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'meta-plan': true,
      'hidden': this.state.editable,
      'show': !this.state.editable
    });

    if(this.state.error) {
      var error = <span className="alert alert-danger">{this.state.error}</span>;
    }

    var text = this.state.editable ? <span><i className="ion-close"></i> Cancel </span> : <span><i className="ion-edit"></i> Edit video</span>;
    
    if(this.props.meta.video_html) {
      var html = this.props.meta.video_html;
    } else {
      var html = "<div class='no-content'>Introduce your meta using a video. <span>Please add a youtube or vimeo video link. It's optional</span> </div>";
    }


    if(this.props.meta.is_owner) {
      return (
        <div className="widget-box video">
          {error}
          <div className="profile-wrapper-title">
              <h4><i className="ion-videocamera red-link"></i> Video Pitch</h4>
              <a className="show-all" onClick={this.openPlanForm}>{text}</a>
          </div>

          <div className="section-content plan">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <MetaVideoForm editable={this.state.editable} meta={this.props.meta} loading= {this.state.loading} handleVideoSubmit= {this.handleVideoSubmit} form={this.props.form} />
          </div>
        </div>
      );
    } else {
       return (
      <div className="widget-box video">
        <div className="profile-wrapper-title">
            <h4><i className="ion-videocamera red-link"></i> Video Pitch</h4>
        </div>
        <div className="section-content plan">
          <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
        </div>
      </div>
    );
    }
  }
});
