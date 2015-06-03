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
      'panel-body widget-form': true,
      'show': this.props.mode,
      'hidden': !this.props.mode,
    });

    var loading_class = cx({
      'fa fa-spinner fa-spin': this.props.loading
    });


    var save_button_class = cx({
      "btn btn-success m-r-10": true,
      "disabled": this.state.text.length > 1500 || this.state.text.length < 500
    });

    var count_class = cx({
      "chars_count pull-right text-danger fs-12": true,
      'chars-overflow': this.state.text.length > 1500 || this.state.text.length < 500
    });


    return(
      <div className={classes}>
        <form ref="about_widget" className="form" action={this.props.form.action} onSubmit={this._onKeyDown}>
          <div className="form-group">
            <textarea ref="about_me" onChange={this.updateWordCount} className ="textarea wysiwyg form-control empty" type="text" name="user[about_me]" defaultValue={this.state.text} placeholder= "Write about yourself" autofocus="true" />
            <div className="widget-buttons m-t-20">
              <button type="submit" id="update_section" className={save_button_class}>
                <i className={loading_class}></i> Save
              </button>
              <label className={count_class} id="about_me_count">{this.state.text.length} chars (min. 500)</label>
            </div>
          </div>
        </form>
      </div>
    )
  },

  updateWordCount: function(event) {
    var sHTML = $(event.target).val();
    this.setState({text: sHTML});
  },

  _onKeyDown: function(event) {
    event.preventDefault();
    var text = this.refs.about_me.getDOMNode().value.trim();
    var formData = $( this.refs.about_widget.getDOMNode() ).serialize();
    this.props.publishWidget(formData, this.props.form.action, {about_me: text});
  }

});
