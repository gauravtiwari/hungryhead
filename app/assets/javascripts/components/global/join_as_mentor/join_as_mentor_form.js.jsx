var JoinAsMentorForm = React.createClass({

  getInitialState: function() {
    return {
      submitted: $.cookie('submitted_mentor_request')
    }
  },

  submitInviteRequest: function(e) {
    e.preventDefault();
    var formData = $( this.refs.form.getDOMNode() ).serialize();
    event.stopPropagation();
    $.post(Routes.invite_requests_path(), formData, function(data, textStatus, xhr) {
      $.cookie('submitted_mentor_request', true, {expires: 365});
    });
  },

  render: function() {

    if(this.state.submitted === undefined) {
      var content =  <form ref="form" noValidate="novalidate" className="new_invite_request" id="new_invite_request" acceptCharset="UTF-8" onSubmit={this.submitInviteRequest}>
        <div className="col-sm-4 auto-margin">
          <div className="form-group form-group-default">
            <label>Your Name</label>
            <input className="string required form-control" placeholder="John Smith" type="text" name="invite_request[name]" id="invite_request_name" />
          </div>
        </div>

        <div className="col-sm-4 auto-margin">
          <div className="form-group form-group-default">
            <label>Reference website</label>
            <input className="string url required form-control" placeholder="Reference website, linkedin, about me url..." type="url" name="invite_request[url]" id="invite_request_url" />
          </div>
        </div>

        <div className="col-sm-4 auto-margin">
          <div className="form-group form-group-default input-group input-group-attached col-xs-12">
          <label>Email Address</label>
          <input className="string email required form-control" placeholder="johndoe@example.com" type="email" name="invite_request[email]" id="invite_request_email" />
          </div>
          <span className="input-group-btn">
            <button type="submit" className="btn btn-danger pull-right btn-cons">Sign Up</button>
          </span>
          <p className="fs-12 pull-right text-right m-t-20 text-white">
            Be first to find out when we Launch our product.
          </p>
        </div>
      </form>;
    } else {
      var content = <div className="text-center text-white">Your invite request has been submitted. We will be in touch.</div>
    }

    return (
      <div className="row">
        {content}
      </div>
    );
  }
});