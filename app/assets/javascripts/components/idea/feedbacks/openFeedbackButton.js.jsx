/**
 * @jsx React.DOM
 */

var OpenFeedbackButton = React.createClass({

  getInitialState: function () {
    return {loading: false, feedbacked: this.props.feedbacked};
  },

  openFeedbackBox: function () {
    this.setState({loading: true});
    $('body').append($('<div>', {class: 'feedback_modal', id: 'feedback_modal'}));
    React.render(
      <FeedbackComposer form={this.props.form} key={Math.random()}  />,
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
      var feedbackButtonText = <a className="btn btn-sm fs-13 padding-5  p-l-10 p-r-10 new-feedback-button btn-green semi-bold text-white pull-right m-r-10" onClick={this.openFeedbackedBox}><i className={classes}></i> Feedbacked</a>;
    } else {
      var feedbackButtonText = <a className="btn btn-sm fs-13 padding-5  p-l-10 p-r-10 btn-info  new-feedback-button pull-right m-r-10" onClick={this.openFeedbackBox}><i className={classes}></i> Feedback</a>;
    }

    return(
       feedbackButtonText
      )
  }
});
