
var AddNoteForm = React.createClass({
	render: function(){
		var cx = React.addons.classSet;
	    var loading_classes = cx({
	      'fa fa-spinner fa-spin': this.props.loading
	    });
		return(<div className="view note" id="quick-note">
                <ul className="toolbar">
                  <li><a href="#" className="close-note-link active"><i className="pg-arrow_left"></i></a>
                  </li>
	                <div className="top text-center">
	                 <span className="margin-right">Created </span> <span className="top-date"></span>
	                </div>
                </ul>
                <div className="add-note-form">
	              <form ref="form" onSubmit={this._onKeyDown}>
	                <div className="content">
	                  <div className="quick-note-editor full-width full-height">
	                  	<input type="hidden" id="note-id" />
	                  	<textarea ref="body" name="note[body]" className="form-control empty" />
	                  </div>
	                  <button className="main-button margin-top float-right"><i className={loading_classes}></i> Create</button>
	                </div>
	              </form>
                </div>
               </div>
			);
	},

  _onKeyDown: function(event) {
      event.preventDefault();
      var text = this.refs.body.getDOMNode().value.trim();
      if (text) {
         var formData = $( this.refs.form.getDOMNode() ).serialize();
        this.props.onNoteSubmit(formData);
      }
      this.refs.body.getDOMNode().value = "";
  }

});