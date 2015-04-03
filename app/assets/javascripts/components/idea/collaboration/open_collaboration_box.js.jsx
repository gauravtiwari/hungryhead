/**
 * @jsx React.DOM
 */

var OpenCollaborationBox = React.createClass({

  OpenCollaboration: function() {
    if(this.isMounted()) {
	  	if($('body').hasClass('show-collaboration')) {
			 $('body').removeClass('show-collaboration');
			 $('.quickview-wrapper').removeClass('open');
		}
		else {
			 $('body').addClass('show-collaboration' );
			 $('.quickview-wrapper').addClass('open');
		}
    }
  },

  render: function() {
    return(
       <button className="collaboration-button" id="open-collaboration" onClick={this.OpenCollaboration}>
			<i className="fa fa-fw fa-users"></i>
			<span className="notifications-count">5</span>
			<span>Chat</span>
		</button>
      )
  }
});
