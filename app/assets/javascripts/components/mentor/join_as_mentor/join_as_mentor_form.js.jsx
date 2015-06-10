var JoinAsMentorForm = React.createClass({

  getInitialState: function() {
    return {
      submitted: $.cookie('submitted_mentor_request') ? $.cookie('submitted_mentor_request') : false,
      name: $.cookie('submitted_mentor_request') ? $.cookie('submitted_mentor_name') : null,
      loading: false
    }
  },

  submitInviteRequest: function(e) {
    e.preventDefault();
    if($(this.refs.form.getDOMNode()).valid()) {
      this.setState({loading: true});
      var formData = $( this.refs.form.getDOMNode() ).serialize();
      event.stopPropagation();
      $.post(Routes.invite_requests_path(), formData, function(data, textStatus, xhr) {
        if(data.created) {
          this.setState({submitted: true, name: data.name});
          $.cookie('submitted_mentor_request', true, {expires: 365});
          $.cookie('submitted_mentor_name', data.name, {expires: 365});
          this.setState({loading: false});
        }
      }.bind(this)).fail(function(xhr, textStatus, errorThrown) {
        var errors = JSON.parse(xhr.responseText);
        this.setState({loading: false});
        $.each(errors, function(keys, values) {
          $('body').pgNotification({style: "simple", message: (values).toString(), position: "top-right", type: "danger",timeout: 5000}).show();
        });
      }.bind(this));
    }

  },

  clearCookie: function() {
    $.removeCookie('submitted_mentor_request');
    $.removeCookie('submitted_mentor_name');
    this.setState({submitted: false, name: null});
  },

  render: function() {

    var cx = React.addons.classSet;
    var classes = cx({
      'fa fa-spinner fa-spin': this.state.loading
    });

    if(this.state.submitted) {
      var content = <h3 className="text-center text-master wrapper-small">Thank you <span className="bold">{this.state.name} <i className="fa fa-smile-o"></i> </span> <br/>Your invite request has been submitted. We will be in touch. <br/> Not you? <a className="pointer" onClick={this.clearCookie}>Click here</a>  </h3>

    } else {
      var content =  <form ref="form" noValidate="novalidate" className="new_invite_request sm-p-b-50 p-b-20" id="new_invite_request" acceptCharset="UTF-8" onSubmit={this.submitInviteRequest}>
        <div className="col-md-4 col-sm-6 auto-margin">
           <h3 className="text-master m-b-20 p-b-5 b-b b-grey pull-left">Lets get started</h3>
       </div>
       <div className="join-mentor-form clearfix">
        <div className="col-sm-6 col-md-4 auto-margin">
          <div className="form-group form-group-default">
            <label>Your Name</label>
            <input className="string required form-control" placeholder="John Smith" type="text" name="invite_request[name]" id="invite_request_name" />
          </div>
        </div>

        <div className="col-sm-6 col-md-4 auto-margin">
          <div className="form-group form-group-default input-group">
            <span className="input-group-addon bg-solid-dark text-white">
              http://
            </span>
            <label>Reference website</label>
            <input className="string url required form-control" placeholder="linkedin, about me url..." type="url" name="invite_request[url]" id="invite_request_url" />
          </div>
        </div>

        <div className="col-sm-6 col-md-4 auto-margin">
          <div className="form-group form-group-default input-group input-group-attached col-xs-12">
          <label>Email Address</label>
          <input className="string email required form-control" placeholder="johndoe@example.com" type="email" name="invite_request[email]" id="invite_request_email" />
          </div>
          <span className="input-group-btn">
            <button type="submit" className="btn btn-complete pull-right btn-cons">Request invite <i className={classes}></i> </button>
          </span>
          <p className="fs-12 pull-right text-right m-t-20 text-master">
            Be first to find out when we Launch our product.
          </p>
        </div>
      </div>
      </form>;
    }

    return (
      <div className="row p-b-80">
        {content}
      </div>
    );
  }
});