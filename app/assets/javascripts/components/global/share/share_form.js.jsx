 /**
 * @jsx React.DOM
 */

var ShareForm = React.createClass({

   handleSubmit: function ( event ) {
    event.preventDefault();
    var message = this.refs.message.getDOMNode().value.trim();

    // validate
    if (!message) {
      return false;
    }

    // submit
    var formData = $( this.refs.form.getDOMNode() ).serialize();
    this.props.handleShareSubmit(formData);

    // reset form;
    this.refs.message.getDOMNode().value = "";

    event.stopPropagation();
  },

  componentDidMount: function(){
  	$('body textarea').on('focus', function(){
    	$(this).autosize();
	  });
  },

  render: function() {

    var cx = React.addons.classSet;
    var loading_classes = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

    return (
          <div className="modal fade stick-up" id="sharePopup" tabIndex="-1" role="dialog" aria-labelledby="sharePopupLabel" aria-hidden="true">
          <div className="modal-dialog ">
          <div className="modal-content-wrapper">
              <div className="modal-content">
                  <div className="modal-header">
                      <button type="button" className="close" data-dismiss="modal" aria-hidden="true">
                          <i className="pg-close"></i>
                      </button>
                      <h5 className="text-left p-b-5 b-b b-grey pull-left">
                        <span className="semi-bold">Share {this.props.shareable_name}</span> with your friends
                      </h5>
                  </div>
                  <div className="modal-body clearfix">
                    <form id="share_form" ref="form" role="form" noValidate="novalidate" acceptCharset="UTF-8" onSubmit={ this.handleSubmit }>
                      <div className="row">
                          <div className="col-md-12">
                            <input ref="token" type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
                            <div className="form-group">
                              <label htmlFor="body">Type your share message</label>
                              <textarea ref="message" className="form-control fs-14 m-t-5 empty" name="share[body]" placeholder="Type your message..." />
                            </div>
                          </div>
                          <div className="col-md-5 pull-right m-t-15">
                            <button type="submit" id="post_share_message" className="btn btn-primary pull-right"><i className={loading_classes}></i> Share </button>
                            <a id="cancel" className="btn btn-danger cancel m-r-10 pull-right" onClick={this.closeFeedbackForm} > Cancel </a>
                          </div>
                      </div>
                    </form>
                  </div>
              </div>
            </div>
          </div>
        </div>
      )
  }

});



