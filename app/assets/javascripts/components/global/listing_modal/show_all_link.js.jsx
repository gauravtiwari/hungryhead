
var ShowAllLink = React.createClass({

	loadAll: function() {
	  this.setState({loading: true});
	  var path = this.props.path;
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
				<a className="see-all" data-toggle="tooltip" data-container="body" title="See all" href="javascript:void(0)" onClick={this.loadAll}>
          <i className="fa fa-ellipsis-h"></i>
        </a>
			);
	}
});