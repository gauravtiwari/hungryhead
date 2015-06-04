var LatestIdeasItem = React.createClass({

  render: function() {
    return (
      <li className="m-b-15">
        <div className="widget-16-header p-l-15 p-r-15">

        <p className="no-margin">
          <a className="bold fs-13 no-margin" href={this.props.item.url}>{this.props.item.name}</a>
          <span className="small no-margin"> : {this.props.item.description}</span>
        </p>
        <div className="clearfix"></div>
        </div>
      </li>
    );
  }
});