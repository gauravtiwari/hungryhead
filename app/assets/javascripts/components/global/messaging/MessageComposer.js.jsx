/**
 * @jsx React.DOM
 */

var ENTER_KEY_CODE = 13;

var MessageComposer = React.createClass({

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
      <div className="message-form">
        <div className="message-form-textarea">
         <form ref="form" className="add-comment" acceptCharset="UTF-8" method="post" onSubmit={ this._onKeyDown }>
            <p><textarea ref="body" name="message[body]" placeholder="Type your message here..." className="message-composer form-control empty" value={this.state.text} onChange={this._onChange}/></p>

          <div className="send-button float-right">
            <button type="submit" id="post_message" className="btn main-button"><i className={loading_classes}></i> Send </button>
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
