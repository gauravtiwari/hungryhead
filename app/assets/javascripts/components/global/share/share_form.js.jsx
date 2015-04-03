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

    return (
	<div className="chatapp idea-share-box">
	<div className="modal fade" tabIndex="-1" role="dialog" id="sharePopup" aria-labelledby="sharePopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	  <div className="modal-dialog modal-lg">
	    <div className="modal-content">
	      <div className="profile-wrapper-title">
	        <button type="button" className="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span className="sr-only">Close</span></button>
	        <h4 className="modal-title" id="myModalLabel"><i className="ion-chatbubbles"></i> Share {this.props.shareable_name} with your friends</h4>
	      </div>
	      <div className="modal-body">
	  		<article className="share-form">
		      <div className="add-share">
			       <form ref="form" acceptCharset="UTF-8" method="post" onSubmit={ this.handleSubmit }>
			        <p><input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } /></p>
			        <p><textarea ref="message" className="form-control empty" name="share[body]" placeholder="Type your message..." /></p>
			        <p><button type="submit" id="post_share" className="main-button float-right"><i className={this.props.loading}></i> Share</button></p>
			      </form>
		      </div>
	   		 </article>
	   	</div>
	     </div>
  		</div>
  		</div>
  	    </div>
      )
  }

});
 


	