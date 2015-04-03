/**
 * @jsx React.DOM
 */

var OpenNotesBox = React.createClass({

  OpenNotes: function() {
    if(this.isMounted()) {
	  	if($('body').hasClass('show-notes')) {
			 $('body').removeClass('show-notes');
			 $('.notes-quickview-wrapper').removeClass('open');
		}
		else {
			 $('body').addClass('show-notes' );
			 $('.notes-quickview-wrapper').addClass('open');
		}
    }
  },

  render: function() {
    return(
       <button className="notes-button" id="notes-collaboration" onClick={this.OpenNotes}>
			<i className="fa fa-fw ion-compose"></i>
			<span className="notifications-count">5</span>
			<span>Notes</span>
		</button>
      )
  }
});
