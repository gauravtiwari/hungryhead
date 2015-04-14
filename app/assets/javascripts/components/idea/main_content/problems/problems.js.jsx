/** @jsx React.DOM */

var converter = new Showdown.converter();

var Problems = React.createClass({

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

  showMarkDownModal: function(){
    $('body').append($('<div>', {class: 'markdown-modal', id: 'markdown-modal'}));
    React.render(
          <MarkDownHelpModal />,
          document.getElementById('markdown-modal')
        );
    $('#markdownPopup').modal('show');
  },


  handleProblemsSubmit: function(formData, description) {
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

  openProblemsForm: function() {
    this.setState({editable: !this.state.editable});
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'idea-problems': true,
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
     var text = this.state.editable ? <span><i className="fa fa-times-circle"></i> Cancel </span> : <span><i className="fa fa-pencil"></i> Edit problems</span>;
    
    if(this.props.idea.sections && this.props.idea.sections.problems) {
      var html = converter.makeHtml(this.props.idea.sections.problems);
    } else {
      var html = "<div class='no-content'>Describe the problems identified. <span>How others are solving, if any? etc.</span> </div>";
    }

    if(this.props.meta.is_owner) {
      return (
        <div className="panel bg-danger-dark box-shadow">
          {error}
          <div className="panel-heading p-l-60 p-b-10">
            <div className="panel-title b-b b-grey p-b-5 text-white">Problem</div>
            <div className="panel-controls">
            <ul>
              <li>
                <a className="portlet-maximize text-white m-r-10 fs-12" onClick={this.showMarkDownModal}>Help <i className="fa fa-question-circle"></i></a>
              </li>
              <li>
                <a className="portlet-close text-white fs-12" onClick={this.openProblemsForm}>{text}</a>
              </li>
            </ul>
            </div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-white">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <ProblemsForm editable={this.state.editable} idea={this.props.idea} loading= {this.state.loading} handleProblemsSubmit= {this.handleProblemsSubmit} form={this.props.idea} />
          </div>
        </div>
      )
    } else {
       return (
        <div className="panel bg-danger-dark box-shadow">
          <div className="panel-heading p-l-60 p-b-10">
            <div className="panel-title b-b b-grey p-b-5 text-white">Problem</div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-white">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
          </div>
        </div>
    )
    }
  }
});
