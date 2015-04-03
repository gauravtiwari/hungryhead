/**
 * @jsx React.DOM
 */

var ConversationReplyForm = React.createClass({

  handleMessageSubmit: function ( event ) {
    event.preventDefault();
    var body = this.refs.body.getDOMNode().value.trim();
  
    // validate
    if (!body) {
      return false;
    }

    // submit
    var formData = $( this.refs.form.getDOMNode() ).serialize();
    this.props.handleReplySubmit(formData);
    // reset form;
    this.refs.body.getDOMNode().value = "";
    event.stopPropagation();
  },


  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'reply-conversation-form': true,
      'hidden': !this.props.replying,
      'show': this.props.replying
    });

    var loadingClass = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

    return (
      <div className={classes}>
        <form ref="form" className="search-conversation" acceptCharset="UTF-8" method="post" onSubmit={ this.handleMessageSubmit }>
          <div className="form-group">
            <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token }/>
            <textarea type="text" className="form-control" ref="body" name="body" placeholder="Write your message..." autofocus />
            <div className='form-buttons pull-right'>
              <button className="btn btn-primary"><i className={loadingClass}></i> Send Message <div className="ripple-wrapper"></div></button>
              <button className="btn btn-danger" onClick={this.props.cancelReplying}>Cancel <div className="ripple-wrapper"></div></button>
            </div>
          </div>
        </form>
      </div>
    );

  },

});

