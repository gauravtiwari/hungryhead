/**
 * @jsx React.DOM
 */

var ENTER_KEY_CODE = 13;

var IdeaMessageComposer = React.createClass({

  getInitialState: function() {
    return {text: ''};
  },

  componentDidMount: function(){
    $('.message-composer').focus();
  },

  render: function() {
    var cx = React.addons.classSet;
    var loading_classes = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

    return (
      <div className="b-t b-b b-grey bg-white clearfix p-l-10 p-r-10">
        <div className="row">
          <form ref="form" className="add-comment" acceptCharset="UTF-8" method="post" onSubmit={ this._onKeyDown }>
            <div className="col-xs-9 no-padding">
                <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
                <textarea type="text" value={this.state.text} onChange={this._onChange} data-chat-input data-chat-conversation="#idea-conversation" ref="body" id="message" name="idea_message[body]" className="form-control chat-input" placeholder="Type and enter to send" />
            </div>
            <div className="col-xs-2 link text-master m-l-10 m-t-15 p-l-10 b-l b-grey col-top">
                <a href="#" className="link text-master">
                    <button type="submit" id="post_message" className="main-button no-border no-padding bg-transparent"><i className={loading_classes}></i> <i className="fa fa-paper-plane"></i> </button>
                </a>
            </div>
          </form>
        </div>
      </div>

    );
  },

  _onChange: function(event, value) {
    this.setState({text: event.target.value});
  },

  _onKeyDown: function(event) {
      event.preventDefault();
      var text = this.refs.body.getDOMNode().value.trim();
      if (text) {
         var formData = $( this.refs.form.getDOMNode() ).serialize();
        this.props.onMessageSubmit(formData, this.props.form.action, {body: text});
      }
      this.setState({text: ''});
  }

});
