
var InviteFriends = React.createClass({

  componentDidMount: function() {
    if(this.isMounted()) {
      $('.email-tags').tagsinput({
          limit: 10
      });
    }
  },
  handleInvite: function(formData) {
    $.post(this.props.path, formData, function(data, textStatus, xhr) {
      if(data.invited){
        $('#inviteFriendsPopup').modal('hide');
        $('body').pgNotification({style: "simple", message: data.msg, position: "top-right", type: "success",timeout: 5000}).show();
      }
    });
  },

  render: function() {
    return (
      <form ref="form" className="bg-white panel panel-transparent no-margin m-t-20" noValidate="novalidate" id="valid-form" cceptCharset="UTF-8" onSubmit={this._onKeyDown}>
        <input type="hidden" name={this.props.form.csrf_param} value={this.props.form.csrf_token} />
        <input name="utf8" type="hidden" value="✓" />
        <div className="panel-heading no-padding m-b-10 m-t-10">
          <div className="panel-title b-b b-grey p-b-5">Enter multiple emails <span>(maximum 10 emails)</span></div>
        </div>
        <div className="panel-body no-padding">
        <div className="invite-wrapper">
            <div className="col-md-6 no-padding p-r-15">
              <div className="form-group">
                  <input className="form-control" autofocus="autofocus" placeholder="Type your friend email" type="email" name="user[email][]" id="user_email" />
              </div>
            </div>
            <div className="col-md-6 no-padding p-l-15">
              <div className="form-group">
                  <input className="form-control" autofocus="autofocus" placeholder="Type your friend name" type="text" name="user[name][]" id="user_name" />
              </div>
            </div>
        </div>

        <div className="invite-wrapper m-t-20">
            <div className="col-md-6 no-padding p-r-15">
              <div className="form-group">
                  <input className="form-control" autofocus="autofocus" placeholder="Type your friend email" type="email" name="user[email][]" id="user_email" />
              </div>
            </div>
            <div className="col-md-6 no-padding p-l-15">
              <div className="form-group">
                  <input className="form-control" autofocus="autofocus" placeholder="Type your friend name" type="text" name="user[name][]" id="user_name" />
              </div>
            </div>
        </div>

        <div className="invite-wrapper m-t-20">
            <div className="col-md-6 no-padding p-r-15">
              <div className="form-group">
                  <input className="form-control" autofocus="autofocus" placeholder="Type your friend email" type="email" name="user[email][]" id="user_email" />
              </div>
            </div>
            <div className="col-md-6 no-padding p-l-15">
              <div className="form-group">
                  <input className="form-control" autofocus="autofocus" placeholder="Type your friend name" type="text" name="user[name][]" id="user_name" />
              </div>
            </div>
        </div>

        <div className="invite-wrapper m-t-20">
            <div className="col-md-6 no-padding p-r-15">
              <div className="form-group">
                  <input className="form-control" autofocus="autofocus" placeholder="Type your friend email" type="email" name="user[email][]" id="user_email" />
              </div>
            </div>
            <div className="col-md-6 no-padding p-l-15">
              <div className="form-group">
                  <input className="form-control" autofocus="autofocus" placeholder="Type your friend name" type="text" name="user[name][]" id="user_name" />
              </div>
            </div>
        </div>

        <div className="invite-wrapper m-t-20">
            <div className="col-md-6 no-padding p-r-15">
              <div className="form-group">
                  <input className="form-control" autofocus="autofocus" placeholder="Type your friend email" type="email" name="user[email][]" id="user_email" />
              </div>
            </div>
            <div className="col-md-6 no-padding p-l-15">
              <div className="form-group">
                  <input className="form-control" autofocus="autofocus" placeholder="Type your friend name" type="text" name="user[name][]" id="user_name" />
              </div>
            </div>
        </div>

        <div className="p-t-20 clearfix">
          <button name="button" type="submit" className=" btn btn-sm btn-success fs-13">Click to invite</button>
          <a className="btn btn-sm btn-danger fs-13 pull-right" href={Routes.root_path}>Back</a>
        </div>
        </div>
      </form>
    );
  },

  _onKeyDown: function(event) {
    event.preventDefault();
    if($(this.refs.form.getDOMNode()).valid()) {
      var formData = $(this.refs.form.getDOMNode()).serialize();
      this.handleInvite(formData);
    }
  }
});