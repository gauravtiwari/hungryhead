var Plan = React.createClass({

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

  handlePlanSubmit: function(formData) {
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

  openPlanForm: function(event) {
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
      'idea-plan': true,
      'hidden': this.state.editable,
      'show': !this.state.editable
    });

    if(this.state.error) {
      var error = <span className="alert alert-danger">{this.state.error}</span>;
    }

     var text = this.state.editable ? <span><i className="fa fa-times-circle"></i> Cancel </span> : <span>Click to edit <i className="fa fa-pencil"></i> </span>;

    if(this.props.idea.description) {
      var html = marked(this.props.idea.description);
    } else {
      var html = "<div class='no-content text-center fs-22 hint-text'>Click edit to describe your idea <span>What is it? What problems are you solving? Your solution? etc.</span> </div>";
    }


    if(this.props.meta.is_owner) {
      return (
        <div className="panel p-t-20 box-shadow no-border no-margin">
          {error}
          <div className="panel-heading p-l-60 p-b-10">
            <div className="panel-title fs-22 b-b b-grey p-b-5 text-master"><i className="fa fa-lightbulb-o text-danger"></i>  Summary</div>
            <div className="panel-controls p-r-60 pull-right">
            <ul>
              <li>
                <a className="portlet-maximize pointer text-master m-r-10 fs-12" onClick={this.showMarkDownModal}>Markdown help <i className="fa fa-question-circle"></i></a>
              </li>
              <li>
                <a className="portlet-close pointer text-master fs-12" onClick={this.openPlanForm}>{text}</a>
              </li>
            </ul>
            </div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-master">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <PlanForm editable={this.state.editable} idea={this.props.idea} loading= {this.state.loading} handlePlanSubmit= {this.handlePlanSubmit} form={this.props.idea} />
          </div>
        </div>
      );
    } else {
       return (
      <div className="panel p-t-20 box-shadow no-border no-margin">
          <div className="panel-heading p-l-60 p-b-10">
            <div className="panel-title fs-22 b-b b-grey p-b-5 text-master"><i className="fa fa-lightbulb-o text-danger"></i>  Summary</div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-master">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
          </div>
        </div>
    );
    }
  }
});
