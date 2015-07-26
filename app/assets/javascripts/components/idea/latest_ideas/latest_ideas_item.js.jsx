var LatestIdeasItem = React.createClass({

  render: function() {
    var html_id = "idea_" + this.props.item.id;

    return (
      <li id={html_id}>
        <div className="widget-16-header">
        <div className="thumbnail-wrapper d32 inline circular b-white m-r-5 m-b-5 b-a b-white">
          <span className="placeholder inline bold fs-12 text-white">
            {this.props.item.name_badge}
          </span>
        </div>
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