var LatestListingsItem = React.createClass({
  render: function() {
    if(this.props.item.avatar) {
      var image = <span className="thumbnail-wrapper d32 circular inline m-t-5">
          <img data-src={this.props.item.avatar} data-src-retina={this.props.item.avatar}  width="32" height="32" src={this.props.item.avatar} />
        </span>;
    } else {
      var image = <span className="icon-thumbnail placeholder bg-master-light pull-left text-white">{this.state.name_badge}</span>;
    }
    return (
      <li className="m-b-10">
        <div className="widget-16-header p-b-10 p-l-15">
        {image}
        <div className="pull-left">
            <a href={this.props.item.url}>
              <p className="all-caps bold  small no-margin overflow-ellipsis ">{this.props.item.name}</p>
            </a>
            <p className="small no-margin">{this.props.item.description}</p>
        </div>
        <div className="clearfix"></div>
        </div>
      </li>
    );
  }
});