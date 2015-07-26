var BusinessModel = React.createClass({

  getInitialState: function() {
    return {
      mode: false,
      editable: false,
      loading: false,
      alreadyOpened: false,
      editing_user: "",
      editing_user_id: null
    }
  },

  componentDidMount: function() {
    var self = this;
    $.pubsub('subscribe', 'closeSectionForm', function(msg, data){
      self.setState({loading: data, editable: false});
    });
  },

  handleBusinessModelSubmit: function(formData, body) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: this.props.meta.idea_path,
      type: "PUT",
      dataType: "json",
      success: function ( data ) {
        if(data.error) {
          this.setState({error: data.error});
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  openBusinessModelForm: function() {
    var idea = this.state.idea;
    this.setState({editable: !this.state.editable});
  },

  showMarkDownModal: function(){
    $('body').append($('<div>', {class: 'markdown-modal', id: 'markdown-modal'}));
    React.render(
          <MarkDownHelpModal />,
          document.getElementById('markdown-modal')
        );
    $('#markdownPopup').modal('show');
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'idea-business-model': true,
      'hidden': this.state.editable,
      'show': !this.state.editable
    });

    if(this.state.error) {
      var error = <span className="alert alert-danger">{this.state.error}</span>;
    }

    var text = this.state.editable ? <span><i className="fa fa-times-circle"></i> Cancel </span> : <span><i className="fa fa-pencil"></i> Edit business model</span>;

    if(this.props.idea && this.props.idea.business_model) {
      var html = marked(this.props.idea.business_model);
      var business_model_classes = "section-content business model";
    } else {
      var html = "<div class='no-content text-center fs-22 light'>Describe the business model for your idea. <span>How will you make revenue from your idea? etc.</span> </div>";
      var business_model_classes = "section-content canvas-placeholder sales-business business-model";
    }

    if(this.props.meta.is_owner) {
      return (
        <div className="panel box-shadow no-border">
          {error}
          <div className="panel-heading p-l-60 p-b-10 bg-light-blue-lightest m-b-20">
            <div className="panel-title b-b b-grey p-b-5 text-master"><i className="fa fa-globe text-danger"></i> Describe your business model</div>
            <div className="panel-controls p-r-60">
            <ul>
              <li>
                <a className="portlet-maximize pointer text-master m-r-10 fs-12" onClick={this.showMarkDownModal}>Help <i className="fa fa-question-circle"></i></a>
              </li>
              <li>
                <a className="portlet-close pointer text-master fs-12" onClick={this.openBusinessModelForm}>{text}</a>
              </li>
            </ul>
            </div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-master">
            <div onClick={this.openBusinessModelForm} className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <BusinessModelForm editable={this.state.editable} idea={this.props.idea} loading= {this.state.loading} handleBusinessModelSubmit= {this.handleBusinessModelSubmit} form={this.props.idea} />
          </div>
        </div>
      )
    } else {
       return (
      <div className="panel bg-white box-shadow no-border">
        <div className="panel-heading p-l-60 p-b-10 bg-light-blue-lightest m-b-20">
          <div className="panel-title b-b b-grey p-b-5 text-master"><i className="fa fa-globe text-danger"></i> BusinessModel</div>
        </div>
        <div className="panel-body p-l-60 p-r-60 text-master">
          <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
        </div>
      </div>
    )
    }
  }
});
