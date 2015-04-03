
var Notes = React.createClass({
	getInitialState: function(){
		return {
			notes: [],
			form: [],
			meta: []
		};
	},

	componentDidMount: function() {
		if(this.isMounted()){
			this.loadNotes();
			$('a[data-toggle="quickview-notes"], #content').on('click', function(){
		      $('body').removeClass('show-notes');
		      $('.notes-quickview-wrapper').removeClass('open');
		    });
		}
	},

	loadNotes: function(){
		$.getJSON(this.props.form.action, function(data) {
			this.setState({
				notes: data.notes,
				form: data.form,
				meta: data.meta
			});
		}.bind(this));
	},

	onNoteSubmit: function ( formData ) {
	    this.setState({loading: true});
	    $.ajaxSetup({ cache: false });
	    $.ajax({
	      data: formData,
	      url: this.props.form.action,
	      type: "POST",
	      dataType: "json",
	      success: function ( response ) {
	      	this.setState({notes: this.state.notes.concat(response).reverse()})
	        this.setState({loading: false});
	      }.bind(this),
	      error: function(xhr, status, err) {
	        console.error(this.props.url, status, err.toString());
	      }.bind(this)
	    });
	  },


	render: function() {
		return(
  		<div className="view-port clearfix quickview-notes" id="note-views">
	        <div className="view list" id="quick-note-list">
	          <div className="toolbar clearfix">
	            <ul className="pull-right ">
	              <li>
	                <a href="#" className="delete-note-link"><i className="fa fa-trash-o"></i></a>
	              </li>
	              <li>
	                <a href="#" className="new-note-link" data-navigate="view" data-view-port="#note-views" data-view-animation="push"><i className="fa fa-plus"></i></a>
	              </li>
	            </ul>
	           <button className="btn-remove-notes btn btn-xs btn-block hide"><i className="fa fa-times"></i> Delete</button>
	          </div>
	          <NotesList loading={this.state.loading} notes={this.state.notes} meta={this.state.meta} />
	        </div>
	        <AddNoteForm form={this.props.form} loading={this.props.loading} onNoteSubmit={this.onNoteSubmit} />
     	</div>


			);
	}
});