var LatestIdeasItem = React.createClass({

  render: function() {
    var html_id = "idea_" + this.props.item.id;

    return (
      <li id={html_id}>
        <div className="widget-16-header">

        <p className="no-margin">
          <a className="bold fs-13 no-margin text-black" href={this.props.item.url}>{this.props.item.name}</a>

        </p>
        <span className="small no-margin overflow-hidden"> {this.props.item.description}</span>
        <div className="clearfix"></div>
        </div>
      </li>
    );
  }
});