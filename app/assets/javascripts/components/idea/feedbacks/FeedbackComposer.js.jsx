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
         $('body').pgNotification({style: "simple", message: "<span> You gave feedback to " + data.meta.idea_name +"</span>", position: "bottom-left", type: "success",timeout: 5000}).show();
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

    <div className="modal fade fill-in" id="feedbackFormPopup" tabindex="-1" role="dialog" aria-labelledby="feedbackFormPopupLabel" aria-hidden="true">
    <button type="button" className="close" data-dismiss="modal" aria-hidden="true">
        <i className="pg-close"></i>
    </button>
    <div className="modal-dialog ">
        <div className="modal-content">
            <div className="modal-header">
                <h5 className="text-left p-b-5"><span className="semi-bold">Write feedback for</span> {this.state.form.idea_name}</h5>
            </div>
            <div className="modal-body">
            <form ref="form" className={form_classes} acceptCharset="UTF-8" onSubmit={ this._onKeyDown }>
                <div className="row">
                    <div className="col-md-12">

                          <input ref="token" type="hidden" name={ this.state.form.csrf_param } value={ this.state.form.csrf_token } />
                          <label htmlFor="body">Intrinsically, what you think works, not works and recommendations? </label>
                          <textarea ref="body" name="feedback[body]" placeholder="Type your feedback here ..." className="feedback_message-composer form-control input-lg" autoFocus={true} onChange={this._onChange}/>
                    </div>
                    <div className="col-md-5 pull-right m-t-15">
                    <button type="submit" id="post_feedback_message" className="btn btn-primary pull-right"><i className={loading_classes}></i> Submit </button>
                        <a id="cancel" className="btn btn-danger cancel m-r-10 pull-right" onClick={this.closeFeedbackForm} > Cancel </a>

                    </div>
                </div>
              </form>
            </div>
            <div className="modal-footer">

            </div>
        </div>
    </div>
    </div>

    );
  }

});
