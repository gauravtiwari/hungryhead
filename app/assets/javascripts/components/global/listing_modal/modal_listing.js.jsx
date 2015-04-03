
var ModalListing = React.createClass({
	
	getInitialState: function(){
		return {
			listings: [],
			meta: [],
			done: false
		};
	},

	componentDidMount: function() {
		if(this.isMounted()){
		  var self = this;
		  this.loadListings();
		  $('#modalListingPopup').on('hidden.bs.modal', function () {
			React.unmountComponentAtNode(document.getElementById('listing_modal'));
			$('#listing_modal').remove();
		  });
		}
	},


	loadListings: function() {
		$.ajaxSetup({ cache: false });
		 $.getJSON(this.props.path, function(data) {
		  this.setState({
		    listings: this.buildElements(data.payload.listings),
			meta: data.payload.meta
		  });
		}.bind(this));
	},


	buildElements: function(listings) {
	  var elements = [];
	  _.map(listings, function(item){
	    elements.push(<ModalListItem item={item} key={item.uuid} />)
	  });
	  return elements;
	},

	handleInfiniteLoad: function() {
		if(this.state.meta.next_page != null) {
		  this.loadMoreListings();
		}
	},

	loadMoreListings: function() {
	    var self = this;
	    if(!self.state.done) {
	      $.ajax({
	        url: this.props.path + "?page=" + this.state.meta.next_page,
	        success: function(data) {
	          var listings = self.state.listings;
	          var new_elements = self.buildElements(data.payload.listings)
	          self.setState({meta: data.payload.meta, isInfiniteLoading: false,  listings: self.state.listings.concat(new_elements)});
	          if(self.state.meta.next_page === null) {
	            self.setState({done: true, isInfiniteLoading: false});
	            event.stopPropagation();
	          }
	        }
	      });
	    }
  	},

	elementInfiniteLoad: function() {
		return;
	},

	render: function() {
		return(
			<div className="modal fade" tabIndex="-1" role="dialog" id="modalListingPopup" aria-labelledby="modalListingPopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
			<div className="modal-dialog modal-lg">
			<div className="modal-content">
			   	<div className="profile-wrapper-title">
			      <button type="button" className="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span className="sr-only">Close</span></button>
			      <h4 className="modal-title" id="modalListingPopupLabel">{this.state.meta.label}</h4>
			    </div>

			  <div className="modal-body white-background">
				  <ul className="followers-list">
				  	<Infinite elementHeight={96}
	                 containerHeight={500}
	                 infiniteLoadBeginBottomOffset={250}
	                 onInfiniteLoad={this.handleInfiniteLoad}
	                 loadingSpinnerDelegate={this.elementInfiniteLoad()}
	                 isInfiniteLoading={this.state.isInfiniteLoading}
	                 >
	                  {this.state.listings}
	                 </Infinite>
				  </ul>
			  </div>
			</div>
			</div>
			</div>
			);
	}
});