/**
 * @jsx React.DOM
 */

var ENTER_KEY_CODE = 13;
var converter = new Showdown.converter();

var FeedbackComposer = React.createClass({

  getInitialState: function() {
    return {
      text: '',
      form: this.props.form,
      loading: false,
      feedbacks_path: ""
    };
  },

  componentDidMount: function() {
    this.setState({
      text: '',
      loading: false,
      feedbacks_path: Routes.idea_feedbacks_path(this.state.form.idea_slug)
    });

    $('body textarea').on('focus', function(){
      $(this).autosize();
    });
  },

  handleFeedbackSubmit: function ( formData, action, body ) {
    this.setState({loading: true});
    $.ajaxSetup({ cache: false });
    $.ajax({
      data: formData,
      url: this.state.feedbacks_path,
      type: "POST",
      dataType: "json",
      success: function ( data ) {
        $("#feedbackFormPopup").modal('hide');
        $.pubsub('publish', 'idea_feedbacked', false);
        $.pubsub('publish', 'update_feedback_stats', data.feedbacks_count);
        $('body textarea').trigger('autosize.destroy');
        $('body').pgNotification({style: "simple", message: "<span> You gave feedback to " + data.meta.idea_name +"</span>", position: "bottom-left", type: "success",timeout: 5000}).show();
        this.setState({loading: false});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  _onKeyDown: function(event) {
      event.preventDefault();
      var text = this.refs.body.getDOMNode().value.trim();
      if($(this.refs.form.getDOMNode()).valid()) {
        var formData = $( this.refs.form.getDOMNode() ).serialize();
        this.handleFeedbackSubmit(formData, this.state.form.action, {body: text});
      }
      this.setState({text: ''});
  },

  closeFeedbackForm: function() {
    this.setState({text:true});
    $("#feedbackFormPopup").modal('hide');
  },

  render: function() {
    var form_classes = "add-feedback";

    var cx = React.addons.classSet;
    var loading_classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    return (
    <div className="modal fade stick-up" id="feedbackFormPopup" tabIndex="-1" role="dialog" aria-labelledby="feedbackFormPopupLabel" aria-hidden="true">
    <div className="modal-dialog ">
    <div className="modal-content-wrapper">
        <div className="modal-content">
            <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-hidden="true">
                    <i className="pg-close"></i>
                </button>
                <h5 className="text-left p-b-5 b-b b-grey pull-left">
                  <span className="semi-bold">Write your feedback to</span> {this.state.form.idea_name}
                </h5>
            </div>
            <div className="modal-body clearfix">
              <form id="feedback_form" ref="form" role="form" noValidate="novalidate" className={form_classes} acceptCharset="UTF-8" onSubmit={ this._onKeyDown }>
                <div className="row">
                    <div className="col-md-12">
                      <input ref="token" type="hidden" name={ this.state.form.csrf_param } value={ this.state.form.csrf_token } />
                      <div className="form-group">
                        <label htmlFor="body">What you think works, not works and recommendations for this idea? </label>
                        <textarea ref="body"  onClick={this.loadMentionables}  name="feedback[body]" placeholder="Type your feedback here ..." className="feedback_message-composer form-control fs-14 m-t-5" required aria-required="true" />
                      </div>
                    </div>
                    <p className="hint-text small clearfix">
                      <i className="fa fa-question-circle m-r-5"></i>
                      If you have any questions, please ask in Q/A section.
                    </p>
                    <div className="col-md-5 pull-right m-t-15">
                    <button type="submit" id="post_feedback_message" className="btn btn-primary pull-right"><i className={loading_classes}></i> Submit </button>
                        <a id="cancel" className="btn btn-danger cancel m-r-10 pull-right" onClick={this.closeFeedbackForm} > Cancel </a>
                    </div>
                </div>
              </form>
            </div>
        </div>
      </div>
    </div>
    </div>

    );
  }

});
