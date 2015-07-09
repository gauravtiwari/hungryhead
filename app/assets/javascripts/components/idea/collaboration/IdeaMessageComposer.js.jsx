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
          <form ref="form" className="add-comment" acceptCharset="UTF-8" method="post">
            <div className="col-xs-12 no-padding">
                <textarea type="text" value={this.state.text} onChange={this._onChange} onKeyDown={this._onKeyDown} data-chat-input data-chat-conversation="#idea-conversation" ref="body" id="message" name="idea_message[body]" className="form-control chat-input" placeholder="Type and enter to send" />
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
    if(event.keyCode === ENTER_KEY_CODE) {
      event.preventDefault();
      var text = this.refs.body.getDOMNode().value.trim();
      if (text) {
        var formData = $( this.refs.form.getDOMNode() ).serialize();
        this.props.onMessageSubmit(formData, this.props.form.action, text);
      }
      this.setState({text: ''});
    }
  }

});
