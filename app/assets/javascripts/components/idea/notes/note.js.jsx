
var Note = React.createClass({
	render: function(){
		return (
	            <li data-noteid={this.props.note.id}>
	              <div className="left">
	                <div className="checkbox check-warning no-margin">
	                  <input id="qncheckbox1" type="checkbox" value="1" />
	                  <label htmlFor="qncheckbox1"></label>
	                </div>
	                <p className="note-preview">{this.props.note.parameters.body}</p>
	              </div>
	              <div className="right pull-right">
	                <span className="date">{moment(this.props.note.created_at).fromNow()}</span>
	                <a href="#" data-navigate="view" data-view-port="#note-views" data-view-animation="push"><i className="fa fa-chevron-right"></i></a>
	              </div>
	            </li>
			);
	}
});