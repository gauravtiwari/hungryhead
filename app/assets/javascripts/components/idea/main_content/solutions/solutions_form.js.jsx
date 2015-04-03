/** @jsx React.DOM */

var SolutionsForm = React.createClass({

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'solutions-edit-form': true,
      'show': this.props.editable,
      'hidden': !this.props.editable
    });

     var loading_class = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

    if(this.props.idea.sections && this.props.idea.sections.solutions) {
      var solutions = this.props.idea.sections.solutions;
    } else {
      var solutions = "";
    }

    return (
      <div className={classes}>
         <form id="solutions-edit-form" ref="solutions_form" className="solutions-edit-form" onSubmit={this._onKeyDown}>
             <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
             <label>Describe the solutions identified. <span>What is different or unique? </span></label>
             <textarea ref="description" className="form-control empty" defaultValue= {solutions} name="idea[solutions]" placeholder='List your solutions' autofocus/>
             <div className="form-buttons send-button">
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
      var formData = $( this.refs.solutions_form.getDOMNode() ).serialize();
      this.props.handleSolutionsSubmit(formData, this.refs.description.getDOMNode().value);
  }

});

