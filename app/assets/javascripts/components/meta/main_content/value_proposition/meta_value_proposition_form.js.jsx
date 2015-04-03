/** @jsx React.DOM */

var MetaValuePropositionForm = React.createClass({

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'plan-edit-form': true,
      'show': this.props.editable,
      'hidden': !this.props.editable
    });

     var loading_class = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

    if(this.props.meta.sections && this.props.meta.sections.value_proposition) {
      var value_proposition = this.props.meta.sections.value_proposition;
    } else {
      var value_proposition = "";
    }


    return (
      <div className={classes}>
         <form id="plan-edit-form" ref="value_form" className="plan-edit-form" onSubmit={this._onKeyDown}>
             <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
             <label>Describe your value proposition. <span>What is it that is most attractive? etc.</span></label>
             <textarea ref="description" className="form-control empty" defaultValue= {value_proposition} name="meta[value_proposition]" placeholder='Write are your value propositions?' autofocus/>
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
      var formData = $( this.refs.value_form.getDOMNode() ).serialize();
      this.props.handleValuePropositionSubmit(formData, this.refs.description.getDOMNode().value);
  }

});

