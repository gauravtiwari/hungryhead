/** @jsx React.DOM */

var converter = new Showdown.converter();

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

  openPlanForm: function(event) {
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
      'idea-plan': true,
      'hidden': this.state.editable,
      'show': !this.state.editable
    });

    if(this.state.error) {
      var error = <span className="alert alert-danger">{this.state.error}</span>;
    }

    var text = this.state.editable ? <span><i className="ion-close"></i> Cancel </span> : <span><i className="ion-edit"></i> Edit summary</span>;
    
    if(this.props.idea.description) {
      var html = converter.makeHtml(this.props.idea.description);
    } else {
      var html = "<div class='no-content'>Describe your idea. <span>What is it? Story? etc.</span> </div>";
    }


    if(this.props.meta.is_owner) {
      return (
        <div className="widget-box the-plan">
          {error}
          <div className="profile-wrapper-title">
              <h4><i className="ion-search red-link"></i> Summary</h4>
              <a className="show-all margin-right" onClick={this.showMarkDownModal}><i className="ion-help-circled"></i> Markdown Help</a>
              <a className="show-all" onClick={this.openPlanForm}>{text}</a>
          </div>

          <div className="section-content plan">
            <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
            <PlanForm editable={this.state.editable} idea={this.props.idea} loading= {this.state.loading} handlePlanSubmit= {this.handlePlanSubmit} form={this.props.idea} />
          </div>
        </div>
      );
    } else {
       return (
      <div className="widget-box the-plan">
        <div className="profile-wrapper-title">
            <h4><i className="ion-search red-link"></i> Summary</h4>
        </div>
        <div className="section-content plan">
          <div className={classes} dangerouslySetInnerHTML={{__html: html}}></div>
        </div>
      </div>
    );
    }
  }
});
