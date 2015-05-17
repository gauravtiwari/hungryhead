/** @jsx React.DOM */

var ElevatorPitch = React.createClass({

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

  handlePitchSubmit: function(formData) {
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

  openPitchForm: function() {
    this.setState({editable: !this.state.editable});
  },

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'idea-plan text-white': true,
      'hidden': this.state.editable,
      'show': !this.state.editable
    });

    if(this.state.error) {
      var error = <span className="alert alert-danger">{this.state.error}</span>;
    }

    var text = this.state.editable ? <span><i className="ion-close"></i> Cancel </span> : <span><i className="ion-edit"></i> Edit pitch</span>;

    if(this.props.idea.elevator_pitch) {
      var html = this.props.idea.elevator_pitch;
    } else {
      var html = "<div class='no-content text-center fs-16 light'>Introduce your idea using a video. <span>Please add a youtube or vimeo video link. It's optional</span> </div>";
    }


    if(this.props.meta.is_owner) {
      return (
        <div className="panel bg-danger box-shadow">
          {error}
          <div className="panel-heading p-l-60 p-b-10">
            <div className="panel-title b-b b-grey p-b-5 text-white">Elevator Pitch</div>
            <div className="panel-controls p-r-60">
            <ul>
              <li>
                <a className="portlet-maximize text-white m-r-10 fs-12" onClick={this.showMarkDownModal}>Help <i className="fa fa-question-circle"></i></a>
              </li>
              <li>
                <a className="portlet-close text-white fs-12" onClick={this.openPitchForm}>{text}</a>
              </li>
            </ul>
            </div>
          </div>
          <div className="panel-body p-l-60 p-r-60 text-white">
            <h3 onClick={this.openMarketForm} className={classes} dangerouslySetInnerHTML={{__html: html}}></h3>
            <ElevatorPitchForm editable={this.state.editable} idea={this.props.idea} loading= {this.state.loading} handlePitchSubmit= {this.handlePitchSubmit} form={this.props.idea} />
          </div>
        </div>
      );
    } else {
       return (
      <div className="panel bg-danger box-shadow">
        <div className="panel-heading p-l-60 p-b-10">
          <div className="panel-title b-b b-grey p-b-5 text-white">Elevator Pitch</div>
        </div>
        <div className="panel-body p-l-60 p-r-60 text-white">
          <div className={classes}><h3 className="no-margin text-white" dangerouslySetInnerHTML={{__html: html}}></h3></div>
        </div>
      </div>
    );
    }
  }
});
