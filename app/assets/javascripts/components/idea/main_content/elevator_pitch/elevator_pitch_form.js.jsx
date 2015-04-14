/** @jsx React.DOM */

var ElevatorPitchForm = React.createClass({

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


    if(this.props.idea.elevator_pitch && this.props.idea.elevator_pitch) {
      var elevator_pitch = this.props.idea.elevator_pitch;
     } else {
      var elevator_pitch = "";
     }

    return (
      <div className={classes}>
         <form id="plan-edit-form" ref="pitch_form" className="pitch-edit-form" onSubmit={this._onKeyDown}>
             <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
             <label className="m-b-10">Edit your elevator pitch.</label>
             <textarea ref="elevator_pitch" className="form-control empty" defaultValue={elevator_pitch} name="idea[elevator_pitch]" placeholder='Edit your elevator pitch' autofocus/>
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
      var formData = $( this.refs.pitch_form.getDOMNode() ).serialize();
      this.props.handlePitchSubmit(formData);
  }

});

