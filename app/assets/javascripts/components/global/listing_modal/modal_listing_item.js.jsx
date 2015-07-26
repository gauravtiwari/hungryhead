
var ModalListItem = React.createClass({
	render: function(){

		if(this.props.item.not_current_user) {
			var follow_button = <Follow followed={this.props.item.followed} />
		}

		var location_list = _.map(this.props.item.locations, function(location){
			return <a key={Math.random()} href={location.url}>{location.tag}</a>;
		});

		if(this.props.item.avatar) {
			var image = <img src={this.props.item.avatar} width="40px" height="40px" />;
		} else {
			var image =  <span className="placeholder bold text-white">
				  	{this.props.item.user_name_badge}
				  </span>;
		}

		return (
			<li className="m-b-10 clearfix">
			  <div className="widget-16-header p-b-10 p-l-15 p-r-15">
		  	<div className="thumbnail-wrapper d48 inline circular m-r-10">
		 			{image}
		 		</div>
			  <div className="pull-left">
			      <p className="all-caps bold  small no-margin overflow-ellipsis ">{this.props.item.name}</p>
			      <p className="no-margin fs-13 bold">{location_list}</p>
			      <p className="about-me small" dangerouslySetInnerHTML={{__html: this.props.item.about_me}}></p>
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