var PublishIdeaPopup = React.createClass({

  componentDidMount: function() {
    $('[data-toggle="tooltip"]').tooltip();
  },

  render: function() {
    return (
        <div className="investapp invest-box">
          <div className="modal fade stick-up" tabIndex="-1" role="dialog" id="ideaPrivacyPopup" aria-labelledby="privacylPopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
            <div className="modal-dialog modal-md">
            <div className="modal-content-wrapper">
              <div className="modal-content">
                 <div className="modal-header clearfix text-left">
                    <button type="button" className="close" data-dismiss="modal" aria-hidden="true">
                      <i className="pg-close fs-14"></i>
                    </button>
                    <h5 className="b-b b-grey p-b-5 pull-left">Customize Privacy for <span className="semi-bold">{this.props.name}</span></h5>
                </div>
              <div className="modal-body">
                <form  id="privacy-form" role="form" noValidate="novalidate" acceptCharset="UTF-8" ref="privacy_form" onSubmit={this._onKeyDown}>
                 <div className="form-group">
                     <div className="row">
                         <div className="row">
                           <div className="col-sm-12 col-md-12">
                             <div className="form-group">
                               <label>Select Multiple Privacy</label>
                               <input type="text" name="idea[privacy]" autoComplete="off" id="privacy_select" placeholder="Type and choose privacy types from list" className="form-control full-width three-tags" required aria-required="true" />
                             </div>
                           </div>
                         </div>
                          <p className="hint-text small clearfix p-t-10">
                            <i className="fa fa-info-circle m-r-5"></i>
                            We encourage you to share your idea as much as possible, <span className="bold">Learn more</span>.
                            <a className="inline m-l-5" onClick={this.learnMoreSharing}>Read More</a>
                          </p>
                         <div className="col-md-6 pull-right m-t-15">
                            <button type="submit" id="update_section" className="btn btn-success pull-right">
                              Save
                            </button>
                            <button type="button" className="btn btn-danger m-r-10 pull-right" data-dismiss="modal">Cancel</button>
                         </div>
                     </div>
                 </div>
             </form>
            </div>
            </div>
            </div>
            </div>
          </div>
        </div>
    )
  },

  _onKeyDown: function(event) {
    event.preventDefault();
    var formData = $( this.refs.privacy_form.getDOMNode() ).serialize();
    if($(this.refs.invest_form.getDOMNode()).valid()) {
      this.props.sendInvestment(formData, this.props.form.action, {amount: amount});
    }
  }

});
