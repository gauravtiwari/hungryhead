
var NotesList = React.createClass({
	render: function() {
		var notes = this.props.notes;
		var loading = this.props.loading;
		var handleNoteSubmit = this.props.handleNoteSubmit;
		var notesListItem = _.map(notes, function(note){
			return <Note note={note} loading={loading} onNoteSubmit={handleNoteSubmit} key={note.uuid} />
		});
		return (
			<ul>
				{notesListItem}
	        </ul>
			)
	}
});