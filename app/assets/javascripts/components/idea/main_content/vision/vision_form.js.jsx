/** @jsx React.DOM */

var VisionForm = React.createClass({

  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'vision-edit-form': true,
      'show': this.props.editable,
      'hidden': !this.props.editable
    });

    var loading_class = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });

    if(this.props.idea.sections && this.props.idea.sections.vision) {
      var vision = this.props.idea.sections.vision;
    } else {
      var vision = "";
    }


    return (
      <div className={classes}>
         <form id="vision-edit-form" ref="vision_form" className="vision-edit-form" onSubmit={this._onKeyDown}>
             <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
             <label>Your vision. <span>What is different you see that others do not? etc.</span></label>
             <textarea ref="description" className="form-control empty" defaultValue= {vision} name="idea[vision]" placeholder='What is your vision?' autofocus/>
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
     var formData = $( this.refs.vision_form.getDOMNode() ).serialize();
     this.props.handleVisionSubmit(formData, this.refs.description.getDOMNode().value);
  }

});

