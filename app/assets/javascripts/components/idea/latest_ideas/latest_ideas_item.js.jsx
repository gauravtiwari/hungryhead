var LatestIdeasItem = React.createClass({

  render: function() {
    var html_id = "idea_" + this.props.item.id;

    return (
      <li className="m-b-10" id={html_id}>
        <div className="widget-16-header p-l-15 p-r-15">

        <p className="no-margin">
          <a className="bold fs-13 no-margin" href={this.props.item.url}>{this.props.item.name}</a>
          <span className="small no-margin overflow-hidden"> : {this.props.item.description}</span>
        </p>
        <div className="clearfix"></div>
        </div>
      </li>
    );
  }
});