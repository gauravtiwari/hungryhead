/** @jsx React.DOM */
var converter = new Showdown.converter();

var MetaValueProposition = React.createClass({

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
  
  handleValuePropositionSubmit: function(formData, description) {
    this.setState({description: description.description});
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

  showMarkDownModal: function(){
    React.render(
          <MarkDownHelpModal />,
          document.getElementById('markdown-modal')
        );
    $('#markdownPopup').modal('show');
  },


  openValuePropositionForm: function() {
    this.setState({editable: !this.state.editable});
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'meta-value_proposition': true,
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

    var text = this.state.editable ? <span><i className="ion-close"></i> Cancel </span> : <span><i className="ion-edit"></i> Edit value proposition</span>;
    
    if(this.props.meta.sections && this.props.meta.sections.value_proposition) {
      var html = converter.makeHtml(this.props.meta.sections.value_proposition);
    } else {
      var html = "<div class='no-content'>Describe your value proposition. <span>What is it that is most attractive? etc.</span> </div>";
    }

    if(this.props.meta.is_owner) {
      return (
        <div className="widget-box the-value_proposition">
          {error}
          <div className="profile-wrapper-title">
              <h4><i className="ion-speedometer red-link"></i> Value Proposition</h4>
              <a className="show-all margin-right" onClick={this.showMarkDownModal}><i className="ion-help-circled"></i> Markdown Help</a>
              <a className="show-all" onClick={this.openValuePropositionForm}>{text}</a>
          </div>

          <div className="section-content value_proposition">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <MetaValuePropositionForm editable={this.state.editable} meta={this.props.meta} loading= {this.state.loading} handleValuePropositionSubmit= {this.handleValuePropositionSubmit} form={this.props.meta} />
          </div>
        </div>
      )
    } else {
       return (
      <div className="widget-box the-value_proposition">
        <div className="profile-wrapper-title">
            <h4><i className="ion-speedometer red-link"></i> Value Proposition</h4>
        </div>

        <div className="section-content value_proposition">
          <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
        </div>
      </div>
    )
    }
  }
});
