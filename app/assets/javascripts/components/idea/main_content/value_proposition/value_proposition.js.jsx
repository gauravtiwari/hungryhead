/** @jsx React.DOM */
var converter = new Showdown.converter();

var ValueProposition = React.createClass({

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

  showMarkDownModal: function(){
    $('body').append($('<div>', {class: 'markdown-modal', id: 'markdown-modal'}));
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
      'idea-value_proposition': true,
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

     var text = this.state.editable ? <span><i className="fa fa-times-circle"></i> Cancel </span> : <span><i className="fa fa-pencil"></i> Edit values</span>;
    
    if(this.props.idea.sections && this.props.idea.sections.value_proposition) {
      var html = converter.makeHtml(this.props.idea.sections.value_proposition);
    } else {
      var html = "<div class='no-content'>Describe your values. <span>What is it that you are offering that others are not? etc.</span> </div>";
    }

    if(this.props.meta.is_owner) {
      return (
        <div className="panel bg-white box-shadow">
          {error}
          <div className="panel-heading p-l-60 p-b-10">
            <div className="panel-title b-b b-grey p-b-5 text-master">List your values</div>
            <div className="panel-controls">
            <ul>
              <li>
                <a className="portlet-maximize text-master m-r-10 fs-12" onClick={this.showMarkDownModal}>Help <i className="fa fa-question-circle"></i></a>
              </li>
              <li>
                <a className="portlet-close text-master fs-12" onClick={this.openValuePropositionForm}>{text}</a>
              </li>
            </ul>
            </div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-master">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <ValuePropositionForm editable={this.state.editable} idea={this.props.idea} loading= {this.state.loading} handleValuePropositionSubmit= {this.handleValuePropositionSubmit} form={this.props.idea} />
          </div>
        </div>
      )
    } else {
       return (
     <div className="panel bg-white box-shadow">
        <div className="panel-heading p-l-60 p-b-10">
          <div className="panel-title b-b b-grey p-b-5 text-master">Values</div>
        </div>
        <div className="panel-body p-l-60 p-r-60 text-master">
          <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
        </div>
      </div>
    )
    }
  }
});
