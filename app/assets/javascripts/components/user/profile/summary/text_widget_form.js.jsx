/** @jsx React.DOM */

var TextWidgetForm = React.createClass({

  getInitialState: function() {
    return {
      text: this.props.content ? this.props.content : ""
    };
  },

  render: function(){
    var cx = React.addons.classSet;
    var classes = cx({
      'widget-form': true,
      'show': this.props.mode,
      'hidden': !this.props.mode,
    });

    var preview_classes = cx({
      'textarea form-control empty': true,
      'show': !this.props.preview,
      'hidden': this.props.preview,
    });

    if(this.props.preview) {
      var text = "Edit";
    } else {
      var text = "Preview";
    }

    var loading_class = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });


      var save_button_class = cx({
        "main-button": true,
        "disabled": this.state.text.length > 1500 || this.state.text.length < 500
      });

      var count_class = cx({
        "chars_count float-right": true,
        'chars-overflow': this.state.text.length > 1500 || this.state.text.length < 500
      });


    return(
      <div className={classes}>
        <form ref="about_widget" className="form" action={this.props.form.action} onSubmit={this._onKeyDown}>
          <textarea onChange={this.updateWordCount} ref="about_me" className ={preview_classes} type="text" name="user[about_me]" defaultValue={this.state.text} placeholder= "Write about yourself" />
          <input type="hidden" name={ this.props.form.csrf_param } value={ this.props.form.csrf_token } />
          <div className="widget-buttons">
            <button type="submit" id="update_section" className={save_button_class}>
              <i className={loading_class}></i> Save
            </button>
            <a id="update_section" className="main-button button-margin" onClick={this.props.showPreview}>
              {text}
            </a>
            <label className={count_class} id="about_me_count">{this.state.text.length} chars (min. 500)</label>
          </div>
        </form>
      </div>
    )
  },

  updateWordCount: function(event) {
    this.setState({text: event.target.value});
  },

  _onKeyDown: function(event) {
    event.preventDefault();
    var text = this.refs.about_me.getDOMNode().value.trim();
    var formData = $( this.refs.about_widget.getDOMNode() ).serialize();
    this.props.publishWidget(formData, this.props.form.action, {about_me: text});
  }

});
