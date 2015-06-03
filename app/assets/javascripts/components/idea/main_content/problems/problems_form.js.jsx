/** @jsx React.DOM */

var ProblemsForm = React.createClass({

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'problems-edit-form': true,
      'show': this.props.editable,
      'hidden': !this.props.editable
    });

     var loading_class = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

    if(this.props.idea.sections  && this.props.idea.sections.problems) {
      var problems = this.props.idea.sections.problems;
    } else {
      var problems = "";
    }

    return (
      <div className={classes}>
         <form id="problems-edit-form" ref="problems_form" className="problems-edit-form" onSubmit={this._onKeyDown}>
             <label>Describe the problems identified. <span>How others are solving, if any? etc.</span></label>
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
      var formData = $( this.refs.problems_form.getDOMNode() ).serialize();
      this.props.handleProblemsSubmit(formData, this.refs.description.getDOMNode().value);
  }

});

