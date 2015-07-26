var OpenFeedbackButton = React.createClass({

  getInitialState: function () {
    return {loading: false, feedbacked: this.props.feedbacked};
  },

  openFeedbackBox: function () {
    this.setState({loading: true});
    $('body').append($('<div>', {class: 'feedback_modal', id: 'feedback_modal'}));
    React.render(
      <FeedbackComposer key={Math.random()} form={this.props.form}  />,
      document.getElementById('feedback_modal')
    );
    this.setState({loading: false});
    $("#feedbackFormPopup").modal('show');
  },

  componentDidMount: function(){
    var self = this;
    $.pubsub('subscribe', 'idea_feedbacked', function(msg, data){
      self.setState({feedbacked: true});
    });
  },

  openFeedbackedBox: function() {
    swal({
      title: "Error!",
      text: "Hey! You have already feedbacked",
      type: "error",
      confirmButtonText: "",
      timer: 2000
    });
  },


  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-comment': !this.state.feedbacked,
      'fa fa-fw fa-check': this.state.feedbacked
    });

    if(this.state.feedbacked) {
      var feedbackButtonText = <a className="main-button pointer bold fs-13 feedbacked m-r-10" onClick={this.openFeedbackedBox}><i className={classes}></i> Feedbacked</a>;
    } else {
      var feedbackButtonText = <a className="main-button pointer bold fs-13 new-feedback-button m-r-10" onClick={this.openFeedbackBox}><i className={classes}></i> Feedback</a>;
    }

    return(
       feedbackButtonText
      )
  }
});
