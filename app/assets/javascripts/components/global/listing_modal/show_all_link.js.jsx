
var ShowAllLink = React.createClass({

	getInitialState: function() {
		return {
			path: this.props.path
		};
	},

	loadAll: function() {
	  this.setState({loading: true});
	  var path = this.state.path;
      $('body').append($('<div>', {class: 'listing_modal', id: 'listing_modal'}));
      React.render(
		  <ModalListing path={path} key={Math.random()} />,
		  document.getElementById('listing_modal')
		);
      this.setState({loading: false});
      $('#modalListingPopup').modal('show');
      ReactRailsUJS.mountComponents();
	},

	render: function() {
		return (
				<a className="see-all" href="javascript:void(0)" onClick={this.loadAll}><i className="ion-more"></i></a>
			);
	}
});