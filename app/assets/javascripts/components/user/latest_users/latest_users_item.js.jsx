var LatestUsersItem = React.createClass({

  render: function() {
    var cx = React.addons.classSet;

    var icon_classes = cx ({
      'pull-left p-b-20': true,
      'fa fa-star': this.props.type == "Popular People",
      'fa fa-line-chart': this.props.type == "Trending People",
      'fa fa-bars': this.props.type == "Latest People"
    });

    if(this.props.item.avatar) {
      var image = <div className="thumbnail-wrapper d32 inline circular b-white m-r-5 m-b-5 b-a b-white">
        <img data-src={this.props.item.avatar} data-src-retina={this.props.item.avatar} width="32" height="32" src={this.props.item.avatar} />
      </div>
    } else {
      var image = <div className="thumbnail-wrapper d32 inline circular b-white m-r-5 m-b-5 b-a b-white">
      <span className="placeholder inline bold fs-12 text-white">
        {this.props.item.name_badge}
      </span>
      </div>
    }

    var html_id = "idea_" + this.props.item.id;

    return (
      <li id={html_id}>
        <div className="widget-16-header p-b-10">
          <span>
            {image}
            <a className="bold small no-margin text-black" href={this.props.item.url}>{this.props.item.name}</a>
            <span className="small no-margin overflow-hidden displayblock">{this.props.item.description}</span>
          </span>
        </div>
      </li>
    );
  }

});