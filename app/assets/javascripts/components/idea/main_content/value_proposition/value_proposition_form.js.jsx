var ValuePropositionForm = React.createClass({

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

    if(this.props.idea && this.props.idea.value_proposition) {
      var value_proposition = this.props.idea.value_proposition;
    } else {
      var value_proposition = "";
    }


    return (
      <div className={classes}>
         <form id="plan-edit-form" ref="value_form" className="plan-edit-form" onSubmit={this._onKeyDown}>
             <label className="m-b-20">Describe your value proposition. <span>What is most lucrative about your idea? etc.</span> <small className="clearfix">You can link images using markdown(Click help)</small></label>
             <textarea ref="description" className="form-control empty" defaultValue= {value_proposition} name="idea[value_proposition]" placeholder='Write are your values? Why your solution is better?' autofocus/>
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
      var formData = $( this.refs.value_form.getDOMNode() ).serialize();
      this.props.handleValuePropositionSubmit(formData, this.refs.description.getDOMNode().value);
  }

});

