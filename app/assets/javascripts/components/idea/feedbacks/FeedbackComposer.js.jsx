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
         $('body').pgNotification({style: "simple", message: "<img width='40px' src="+data.user_avatar+"> <span> You gave feedback to " + data.meta.idea_name +"</span>", position: "top-right", type: "success",timeout: 5000}).show();
        this.setState({loading: false});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  _onChange: function(event, value) {
    this.setState({text: event.target.value});
  },

  _onKeyDown: function(event) {
      event.preventDefault();
      var text = this.refs.body.getDOMNode().value.trim();
      if (text) {
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
    var form_classes = "add-feedback ";

    var cx = React.addons.classSet;
    var loading_classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    return (
  <div className="feedbackFormPopup">
    <div className="modal fade" tabIndex="-1" role="dialog" id="feedbackFormPopup" aria-labelledby="feedbackFormPopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
    <div className="modal-dialog modal-lg">
      <div className="modal-content">
        <div className="profile-wrapper-title">
         <button type="button" className="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span className="sr-only">Close</span></button>
          <h4 className="modal-title">
            <span>
              <i className="ion-edit"></i> Write your feedback/idea
            </span> 
          </h4>
        </div>
      <div className="feedback_message-form">
        <div className="feedback_message-form-textarea">
         <form ref="form" className={form_classes} acceptCharset="UTF-8" onSubmit={ this._onKeyDown }>
            <input ref="token" type="hidden" name={ this.state.form.csrf_param } value={ this.state.form.csrf_token } />
            <label htmlFor="body">Intrinsically, what you think works, not works and recommendations? </label>
            <textarea ref="body" name="feedback[body]" placeholder="Type your feedback here ..." className="feedback_message-composer form-control empty" autoFocus={true} onChange={this._onChange}/>
          <div className="form-buttons send-button">
            <div>
              <button type="submit" id="post_feedback_message" className="main-button"><i className={loading_classes}></i> Submit </button>
            </div>
            <div>
              <a id="cancel" className="main-button cancel" onClick={this.closeFeedbackForm} > Cancel </a>
            </div>
          </div>
        </form>
        </div>
      </div>
      </div>
      </div>
      </div>
      </div>

    );
  }

});
