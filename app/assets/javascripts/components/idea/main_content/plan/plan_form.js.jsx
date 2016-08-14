var PlanForm = React.createClass({

  render: function() {
    var classes = classNames({
      'plan-edit-form': true,
      'show': this.props.editable,
      'hidden': !this.props.editable
    });

     var loading_class = classNames({
      'fa fa-spinner fa-spin': this.props.loading
    });

    return (
      <div className={classes}>
         <form id="plan-edit-form" ref="plan_form" className="plan-edit-form" onSubmit={this._onKeyDown}>
             <label className="m-b-20">Describe your idea. <span>What are you looking to build? Story?</span> <small className="clearfix">You can link images using markdown(Click help)</small></label>
             <textarea ref="description" className="form-control empty" defaultValue= {this.props.idea.description} name="idea[description]" placeholder='Your Story content' autofocus/>
             <div className="form-buttons send-button m-t-10 pull-right">
              <div>
                <button type="submit" id="post_feedback_message" className="main-button fs-13 bold"><i className={loading_class}></i> Save </button>
              </div>
            </div>
          </form>
      </div>
    )
  },

  _onKeyDown: function(event) {
      event.preventDefault();
      var formData = $( this.refs.plan_form ).serialize();
      this.props.handlePlanSubmit(formData, this.refs.description.value);
  }

});
