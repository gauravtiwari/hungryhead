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
      url: this.props.meta.idea_path,
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

    if(this.props.idea && this.props.idea.problems) {
      var html = marked(this.props.idea.problems);
    } else {
      var html = "<div class='no-content text-center fs-22 light'>Describe the problems you have identified. <span>How others are solving, if any? etc.</span> </div>";
    }

    if(this.props.meta.is_owner) {
      return (
        <div className="panel bg-white box-shadow no-border">
          {error}
          <div className="panel-heading p-l-60 p-b-10 bg-light-blue-lightest m-b-20">
            <div className="panel-title b-b b-grey p-b-5 text-master"><i className="fa fa-frown-o text-danger"></i>  List problems</div>
            <div className="panel-controls p-r-60">
            <ul>
              <li>
                <a className="portlet-maximize pointer text-master m-r-10 fs-12" onClick={this.showMarkDownModal}>Help <i className="fa fa-question-circle"></i></a>
              </li>
              <li>
                <a className="portlet-close pointer text-master fs-12" onClick={this.openProblemsForm}>{text}</a>
              </li>
            </ul>
            </div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-master">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <ProblemsForm editable={this.state.editable} idea={this.props.idea} loading= {this.state.loading} handleProblemsSubmit= {this.handleProblemsSubmit} form={this.props.idea} />
          </div>
        </div>
      )
    } else {
       return (
        <div className="panel bg-white box-shadow no-border">
          <div className="panel-heading p-l-60 p-b-10 bg-light-blue-lightest m-b-20">
            <div className="panel-title b-b b-grey p-b-5 text-master"><i className="fa fa-frown-o text-danger"></i>  Problem</div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-master">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
          </div>
        </div>
    )
    }
  }
});
