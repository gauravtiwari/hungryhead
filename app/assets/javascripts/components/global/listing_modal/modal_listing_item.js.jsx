
var ModalListItem = React.createClass({
	render: function(){

		if(this.props.item.not_current_user) {
			var follow_button = <Follow followed={this.props.item.followed} />
		}

		var location_list = _.map(this.props.item.locations, function(location){
			return <li key={Math.random()}><i className="ion-location red-link"></i> <a href={location.url}>{location.tag}</a></li>;
		});
		return (
			<li>
				<div className="user-avatar margin-right">
					<img src={this.props.item.avatar} width="50px" height="50px" />
				</div>
				<div className="followers-list-content">
					<p><a href={this.props.item.path}>{this.props.item.name}</a> 
					</p>
					<ul className="item-tags grey-links">
						{location_list}
					</ul>
					<p className="about-me" dangerouslySetInnerHTML={{__html: jQuery.truncate(this.props.item.about_me, {length: 100})}}></p>
					{follow_button}
				</div>
			</li>
			);
	}
});