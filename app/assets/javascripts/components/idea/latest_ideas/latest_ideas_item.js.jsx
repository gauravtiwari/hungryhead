var LatestIdeasItem = React.createClass({
  render: function() {
    return (
      <li className="m-b-10">
        <div className="widget-16-header p-b-10 p-l-15">
        <div className="pull-left">
            <a href={this.props.item.url}>
              <p className="all-caps bold  small no-margin overflow-ellipsis ">{this.props.item.name}</p>
            </a>
            <p className="small no-margin">{this.props.item.pitch}</p>
        </div>
        <div className="clearfix"></div>
        </div>
      </li>
    );
  }
});