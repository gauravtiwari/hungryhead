 /**
 * @jsx React.DOM
 */

var SharePostForm = React.createClass({

   handleSubmit: function ( event ) {
    event.preventDefault();
    var body = this.refs.body.getDOMNode().value.trim();
    // validate
    if (!body) {
      return false;
    }
    // submit
    var formData = $( this.refs.form.getDOMNode() ).serialize();
    this.props.handleSharePostSubmit(formData);

    // reset form;
    this.refs.body.getDOMNode().value = "";

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
          <div className="modal fade stick-up" id="sharePostPopup" tabIndex="-1" role="dialog" aria-labelledby="sharePostPopupLabel" aria-hidden="true">
          <div className="modal-dialog ">
          <div className="modal-content-wrapper">
              <div className="modal-content">
                  <div className="modal-header text-left">
                      <button type="button" className="close" data-dismiss="modal" aria-hidden="true">
                          <i className="pg-close"></i>
                      </button>
                      <h2 className="normal no-margin p-b-10 text-master">Share a post</h2>
                      <div className="divider b-b text-master b-grey b-md b-small"></div>
                      <h5 className="p-t-10">Share anything you think would be useful to others or just make a private post.</h5>
                  </div>
                  <div className="modal-body clearfix m-t-20">
                    <form id="share_post_form" ref="form" role="form" noValidate="novalidate" acceptCharset="UTF-8" onSubmit={ this.handleSubmit }>
                      <div className="row">
                          <div className="col-md-12">
                            <div className="form-group">
                              <label htmlFor="title">Type your share body</label>
                              <input ref="title" className="form-control fs-14 m-t-5 empty" name="post[title]" placeholder="Type title for this post..." />
                            </div>

                            <div className="form-group">
                              <label htmlFor="body">Type your share body</label>
                              <textarea ref="body" className="form-control fs-14 m-t-5 empty" name="post[body]" placeholder="Type your post..." />
                            </div>
                            <div className="checkbox check-primary checkbox-circle">
                              <input name="post[status]" type="checkbox" defaultChecked="checked" value="1" id="post_status" />
                              <label htmlFor="post_status">Public Post</label>
                            </div>
                          </div>
                          <div className="col-md-5 pull-right m-t-15">
                            <button type="submit" id="post_share_body" className="btn btn-primary pull-right"><i className={loading_classes}></i> Share </button>
                            <a id="cancel" className="btn btn-danger cancel m-r-10 pull-right" data-dismiss="modal" aria-hidden="true"> Cancel </a>
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



