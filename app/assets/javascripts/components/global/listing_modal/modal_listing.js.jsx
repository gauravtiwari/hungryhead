
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
			<div className="modal fade stick-up" tabIndex="-1" role="dialog" id="modalListingPopup" aria-labelledby="modalListingPopupLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
			<div className="modal-dialog modal-md">
			<div className="modal-content">
			<div className="widget-11-2 panel no-border no-margin widget-loader-circle">

			<div className="panel-heading">
				<button type="button" className="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span className="sr-only">Close</span></button>
				<div className="panel-title b-b b-grey p-b-5">
				  {this.state.meta.label}
				</div>
			</div>
			<div className="auto-overflow">
			 <ul className="modal-list p-t-20 no-style no-padding">
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
			</div>
			);
	}
});