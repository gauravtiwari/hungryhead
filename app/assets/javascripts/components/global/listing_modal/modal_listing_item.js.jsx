
var ModalListItem = React.createClass({
	render: function(){

		if(this.props.item.not_current_user) {
			var follow_button = <Follow followed={this.props.item.followed} />
		}

		var location_list = _.map(this.props.item.locations, function(location){
			return <li key={Math.random()}><i className="ion-location red-link"></i> <a href={location.url}>{location.tag}</a></li>;
		});

		if(this.props.item.avatar) {
			var image = <img src={this.props.item.avatar} className="pull-left m-r-10" width="40px" height="40px" />;
		} else {
			var image =  <span className="icon-thumbnail placeholder bg-master-light pull-left text-white">
				  	{this.props.item.user_name_badge}
				  </span>;
		}

		return (
			<li className="m-b-10">
			  <div className="widget-16-header p-b-10 p-l-15">
			 	{image}
			  <div className="pull-left">
			      <p className="all-caps bold  small no-margin overflow-ellipsis ">{this.props.item.name}</p>
			      <p className="small no-margin overflow-ellipsis">{location_list}</p>
			      <p className="about-me" dangerouslySetInnerHTML={{__html: jQuery.truncate(this.props.item.about_me, {length: 100})}}></p>
			  </div>
			  <div className="pull-right">
			  	{follow_button}
			  </div>
			  <div className="clearfix"></div>
			  </div>
			</li>

			);
	}
});