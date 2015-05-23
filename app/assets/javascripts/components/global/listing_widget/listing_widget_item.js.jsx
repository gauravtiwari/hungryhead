var ListingWidgetItem = React.createClass({

  render: function() {
    if(this.props.item.avatar) {
      var placeholder =  <div className="thumbnail-wrapper d32 circular b-white m-r-5 m-b-5">
              <a href={this.props.item.url}>
                <img data-src={this.props.item.avatar} data-src-retina={this.props.item.avatar} width="35" height="35" data-toggle="tooltip" data-container="body" data-title={this.props.item.name} src={this.props.item.avatar} alt={this.props.item.name} />
              </a>
          </div>;
    } else {
      var placeholder = <div className="thumbnail-wrapper d32 circular b-white m-r-5 m-b-5">
            <a href={this.props.item.url}>
              <span className="placeholder bold text-white" data-toggle="tooltip" data-container="body" data-title={this.props.item.name}>
                {this.props.item.name_badge}
              </span>
            </a>
          </div>;
    }
    return (
      <li className="m-r-10">
         {placeholder}
      </li>
    );
  }
});