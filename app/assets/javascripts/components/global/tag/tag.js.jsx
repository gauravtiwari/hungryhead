var TagList = React.createClass({

	getInitialState: function() {
		return {
			url: ""
		}
	},
	componentDidMount: function(){
		this.setState({url: this.slug(this.props.tag)});
	},

	slug: function(text) {
	    var slug = text.trim().toLowerCase().replace(/ /g,'-').replace(/[^\w-]+/g,'');
	    return '/tags/'+slug;
	},

	render: function() {
		return (
				<li> <a href={this.state.url}>{this.props.tag}</a></li>
			)
	}
});