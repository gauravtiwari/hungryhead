var Solutions = React.createClass({

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

  handleSolutionsSubmit: function(formData, description) {
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

  showMarkDownModal: function(){
    $('body').append($('<div>', {class: 'markdown-modal', id: 'markdown-modal'}));
    React.render(
          <MarkDownHelpModal />,
          document.getElementById('markdown-modal')
        );
    $('#markdownPopup').modal('show');
  },


  openSolutionsForm: function() {
    this.setState({editable: !this.state.editable});
  },

  render: function() {
    var classes = classNames({
      'idea-solutions': true,
      'hidden': this.state.editable,
      'show': !this.state.editable
    });

    var video_classes = classNames({
      'video-wrapper': true,
      'hidden': this.state.editable,
      'show': !this.state.editable
    });

    if(this.state.error) {
      var error = <span className="alert alert-danger">{this.state.error}</span>;
    }

     var text = this.state.editable ? <span><i className="fa fa-times-circle"></i> Cancel </span> : <span><i className="fa fa-pencil"></i> Edit solutions</span>;

    if(this.props.idea && this.props.idea.solutions) {
      var html = marked(this.props.idea.solutions);
    } else {
      var html = "<div class='no-content text-center fs-22 light'>Describe/List your solution. <span>What is different or unique? </span> </div>";
    }

    if(this.props.meta.is_owner) {
      return (
        <div className="panel box-shadow no-border">
          {error}
          <div className="panel-heading p-l-60 p-b-10 bg-light-blue-lightest m-b-20">
            <div className="panel-title b-b b-grey p-b-5 text-master"><i className="fa fa-smile-o text-danger"></i>  List solutions</div>
            <div className="panel-controls p-r-60">
            <ul>
              <li>
                <a className="portlet-maximize pointer text-master m-r-10 fs-12" onClick={this.showMarkDownModal}>Help <i className="fa fa-question-circle"></i></a>
              </li>
              <li>
                <a className="portlet-close pointer text-master fs-12" onClick={this.openSolutionsForm}>{text}</a>
              </li>
            </ul>
            </div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-master">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <SolutionsForm editable={this.state.editable} idea={this.props.idea} loading= {this.state.loading} handleSolutionsSubmit= {this.handleSolutionsSubmit} form={this.props.idea} />
          </div>
        </div>
      )
    } else {
       return (
       <div className="panel bg-white box-shadow no-border">
        <div className="panel-heading p-l-60 p-b-10 bg-light-blue-lightest m-b-20">
          <div className="panel-title b-b b-grey p-b-5 text-master"><i className="fa fa-smile-o text-danger"></i>  Solution</div>
        </div>
        <div className="panel-body p-l-60 p-r-60 text-master">
          <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
        </div>
      </div>
    )
    }
  }
});
