/**
 * @jsx React.DOM
 */


var OpenFeedbackButton = React.createClass({

  getInitialState: function () {
    return {loading: false, feedbacked: this.props.feedbacked};
  },
  openFeedbackBox: function () {
    $("#feedbackFormPopup").modal('show');
    this.setState({loading: false});
  },

  componentDidMount: function(){
    var self = this;
    $.pubsub('subscribe', 'idea_feedbacked', function(msg, data){
      self.setState({feedbacked: false});
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
      'fa fa-comment': this.state.feedbacked,
      'fa fa-fw fa-check': !this.state.feedbacked
    });

    if(!this.state.feedbacked) {
      var feedbackButtonText = <a className="btn btn-cons padding-5 new-feedback-button btn-green semi-bold text-white pull-right m-r-10" onClick={this.openFeedbackedBox}><i className={classes}></i> Feedbacked</a>;
    } else {
      var feedbackButtonText = <a className="btn btn-cons btn-info padding-5 new-feedback-button pull-right m-r-10" onClick={this.openFeedbackBox}><i className={classes}></i> Feedback</a>;
    }

    return(
       feedbackButtonText
      )
  }
});
