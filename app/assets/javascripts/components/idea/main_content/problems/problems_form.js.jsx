var ProblemsForm = React.createClass({

  render: function() {
    var classes = classNames({
      'problems-edit-form': true,
      'show': this.props.editable,
      'hidden': !this.props.editable
    });

     var loading_class = classNames({
      'fa fa-spinner fa-spin': this.props.loading
    });

    if(this.props.idea  && this.props.idea.problems) {
      var problems = this.props.idea.problems;
    } else {
      var problems = "";
    }

    return (
      <div className={classes}>
         <form id="problems-edit-form" ref="problems_form" className="problems-edit-form" onSubmit={this._onKeyDown}>
             <label className="m-b-20">Describe the problems identified. <span>How others are solving, if any? etc.</span> <small className="clearfix">You can link images using markdown(Click help)</small></label>
             <textarea ref="description" className="form-control empty" defaultValue= {problems} name="idea[problems]" placeholder='List the problems you have identified?' autofocus/>
             <div className="form-buttons send-button m-t-10 pull-right">
              <div>
                <button type="submit" id="post_feedback_message" className="main-button"><i className={loading_class}></i> Save </button>
              </div>
            </div>
          </form>
      </div>
    )
  },

  _onKeyDown: function(event) {
      event.preventDefault();
      var formData = $( this.refs.problems_form ).serialize();
      this.props.handleProblemsSubmit(formData, this.refs.description.value);
  }

});
